from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated

from .models import Team
from .serializers import TeamSerializer, TeamDetailSerializer, AddMemberSerializer
from users.models import Student


class TeamViewSet(viewsets.ModelViewSet):
    queryset = Team.objects.select_related('project').prefetch_related('members__user').all()
    serializer_class = TeamSerializer
    permission_classes = [IsAuthenticated]

    def get_serializer_class(self):
        if self.action == 'retrieve':
            return TeamDetailSerializer
        return TeamSerializer

    def get_queryset(self):
        user = self.request.user

        if user.user_type == 'student':
            try:
                student = user.student_profile
                from django.db.models import Q
                return Team.objects.filter(
                    Q(project__owner=student) | Q(members=student)
                ).distinct()
            except AttributeError:
                pass

        return super().get_queryset()

    @action(detail=True, methods=['get'])
    def members(self, request, pk=None):
        team = self.get_object()
        from users.serializers import StudentProfileSerializer
        members = team.members.all()
        serializer = StudentProfileSerializer(members, many=True)
        return Response(serializer.data)

    @action(detail=True, methods=['post'])
    def add_member(self, request, pk=None):
        team = self.get_object()

        try:
            student = request.user.student_profile
            if team.project.owner != student:
                return Response(
                    {'error': 'Only project owner can add members directly'},
                    status=status.HTTP_403_FORBIDDEN
                )
        except AttributeError:
            return Response(
                {'error': 'Only students can manage team members'},
                status=status.HTTP_403_FORBIDDEN
            )

        serializer = AddMemberSerializer(data=request.data)
        if serializer.is_valid():
            student_id = serializer.validated_data['student_id']

            try:
                member = Student.objects.get(student_id=student_id)
                success = team.add_member(member)

                if success:
                    return Response({
                        'message': f'Successfully added {member.user.name} to the team',
                        'team': TeamDetailSerializer(team).data
                    })
                else:
                    return Response(
                        {'error': 'Could not add member (team may be full or member already exists)'},
                        status=status.HTTP_400_BAD_REQUEST
                    )
            except Student.DoesNotExist:
                return Response(
                    {'error': 'Student not found'},
                    status=status.HTTP_404_NOT_FOUND
                )

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @action(detail=True, methods=['delete'], url_path='members/(?P<student_id>[^/.]+)')
    def remove_member(self, request, pk=None, student_id=None):
        team = self.get_object()

        try:
            current_student = request.user.student_profile
            if team.project.owner != current_student:
                return Response(
                    {'error': 'Only project owner can remove members'},
                    status=status.HTTP_403_FORBIDDEN
                )
        except AttributeError:
            return Response(
                {'error': 'Only students can manage team members'},
                status=status.HTTP_403_FORBIDDEN
            )

        if team.project.owner.student_id == student_id:
            return Response(
                {'error': 'Cannot remove project owner from team'},
                status=status.HTTP_400_BAD_REQUEST
            )

        try:
            member = Student.objects.get(student_id=student_id)
            if team.members.filter(pk=member.pk).exists():
                team.remove_member(student_id)
                return Response({
                    'message': f'Successfully removed {member.user.name} from the team'
                })
            else:
                return Response(
                    {'error': 'Student is not a member of this team'},
                    status=status.HTTP_400_BAD_REQUEST
                )
        except Student.DoesNotExist:
            return Response(
                {'error': 'Student not found'},
                status=status.HTTP_404_NOT_FOUND
            )
