from rest_framework import generics, status, viewsets
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated
from django.contrib.auth import get_user_model

from .models import Student, Faculty
from .serializers import (
    UserSerializer, StudentProfileSerializer, FacultyProfileSerializer,
    StudentRegistrationSerializer, FacultyRegistrationSerializer,
    ChangePasswordSerializer
)
from .permissions import IsOwnerOrReadOnly, IsStudent, IsFaculty

User = get_user_model()


class StudentRegistrationView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = StudentRegistrationSerializer
    permission_classes = [AllowAny]

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()

        return Response({
            'message': 'Student registered successfully',
            'user': UserSerializer(user).data
        }, status=status.HTTP_201_CREATED)


class FacultyRegistrationView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = FacultyRegistrationSerializer
    permission_classes = [AllowAny]

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()

        return Response({
            'message': 'Faculty member registered successfully',
            'user': UserSerializer(user).data
        }, status=status.HTTP_201_CREATED)


class CurrentUserView(generics.RetrieveAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = UserSerializer

    def get_object(self):
        return self.request.user


class StudentProfileViewSet(viewsets.ModelViewSet):
    queryset = Student.objects.select_related('user').all()
    serializer_class = StudentProfileSerializer
    permission_classes = [IsAuthenticated, IsOwnerOrReadOnly]

    def get_queryset(self):
        queryset = super().get_queryset()

        department = self.request.query_params.get('department')
        if department:
            queryset = queryset.filter(department__icontains=department)

        year = self.request.query_params.get('year')
        if year:
            queryset = queryset.filter(year=year)

        skills = self.request.query_params.get('skills')
        if skills:
            skill_list = skills.split(',')
            for skill in skill_list:
                queryset = queryset.filter(skills__contains=skill.strip())

        return queryset

    @action(detail=False, methods=['get'], permission_classes=[IsAuthenticated])
    def me(self, request):
        try:
            student = request.user.student_profile
            serializer = self.get_serializer(student)
            return Response(serializer.data)
        except AttributeError:
            return Response(
                {'error': 'User is not a student'},
                status=status.HTTP_400_BAD_REQUEST
            )

    @action(detail=False, methods=['put', 'patch'], permission_classes=[IsAuthenticated, IsStudent])
    def update_profile(self, request):
        try:
            student = request.user.student_profile
            serializer = self.get_serializer(student, data=request.data, partial=True)
            serializer.is_valid(raise_exception=True)
            serializer.save()
            return Response(serializer.data)
        except AttributeError:
            return Response(
                {'error': 'User is not a student'},
                status=status.HTTP_400_BAD_REQUEST
            )


class FacultyProfileViewSet(viewsets.ModelViewSet):
    queryset = Faculty.objects.select_related('user').all()
    serializer_class = FacultyProfileSerializer
    permission_classes = [IsAuthenticated, IsOwnerOrReadOnly]

    def get_queryset(self):
        queryset = super().get_queryset()

        department = self.request.query_params.get('department')
        if department:
            queryset = queryset.filter(department__icontains=department)

        title = self.request.query_params.get('title')
        if title:
            queryset = queryset.filter(title__icontains=title)

        return queryset

    @action(detail=False, methods=['get'], permission_classes=[IsAuthenticated])
    def me(self, request):
        try:
            faculty = request.user.faculty_profile
            serializer = self.get_serializer(faculty)
            return Response(serializer.data)
        except AttributeError:
            return Response(
                {'error': 'User is not faculty'},
                status=status.HTTP_400_BAD_REQUEST
            )

    @action(detail=False, methods=['put', 'patch'], permission_classes=[IsAuthenticated, IsFaculty])
    def update_profile(self, request):
        try:
            faculty = request.user.faculty_profile
            serializer = self.get_serializer(faculty, data=request.data, partial=True)
            serializer.is_valid(raise_exception=True)
            serializer.save()
            return Response(serializer.data)
        except AttributeError:
            return Response(
                {'error': 'User is not faculty'},
                status=status.HTTP_400_BAD_REQUEST
            )


class ChangePasswordView(generics.UpdateAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = ChangePasswordSerializer

    def update(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        user = request.user

        if not user.check_password(serializer.validated_data['old_password']):
            return Response(
                {'old_password': 'Wrong password'},
                status=status.HTTP_400_BAD_REQUEST
            )

        user.set_password(serializer.validated_data['new_password'])
        user.save()

        return Response({
            'message': 'Password changed successfully'
        }, status=status.HTTP_200_OK)
