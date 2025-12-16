from rest_framework import serializers
from .models import Team, TeamMembership
from users.serializers import StudentProfileSerializer


class TeamMembershipSerializer(serializers.ModelSerializer):
    student_info = StudentProfileSerializer(source='student', read_only=True)

    class Meta:
        model = TeamMembership
        fields = ['id', 'team', 'student', 'student_info', 'role', 'joined_date']
        read_only_fields = ['id', 'joined_date', 'student_info']


class TeamSerializer(serializers.ModelSerializer):
    members_info = StudentProfileSerializer(source='members', many=True, read_only=True)
    project_title = serializers.CharField(source='project.title', read_only=True)
    current_size = serializers.SerializerMethodField()
    available_slots = serializers.SerializerMethodField()

    class Meta:
        model = Team
        fields = [
            'id', 'project', 'project_title', 'max_members',
            'current_size', 'available_slots', 'members', 'members_info',
            'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'project', 'created_at', 'updated_at']

    def get_current_size(self, obj):
        return obj.get_member_count()

    def get_available_slots(self, obj):
        return obj.get_available_slots()


class TeamDetailSerializer(serializers.ModelSerializer):
    members_info = StudentProfileSerializer(source='members', many=True, read_only=True)
    memberships = TeamMembershipSerializer(many=True, read_only=True)
    project_info = serializers.SerializerMethodField()
    current_size = serializers.SerializerMethodField()
    is_full = serializers.SerializerMethodField()

    class Meta:
        model = Team
        fields = [
            'id', 'project', 'project_info', 'max_members',
            'current_size', 'is_full', 'members', 'members_info',
            'memberships', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'project', 'created_at', 'updated_at']

    def get_project_info(self, obj):
        return {
            'id': obj.project.id,
            'title': obj.project.title,
            'status': obj.project.status,
            'owner': obj.project.owner.user.name
        }

    def get_current_size(self, obj):
        return obj.get_member_count()

    def get_is_full(self, obj):
        return obj.is_full()


class AddMemberSerializer(serializers.Serializer):
    student_id = serializers.CharField(required=True)

    def validate_student_id(self, value):
        from users.models import Student
        try:
            Student.objects.get(student_id=value)
        except Student.DoesNotExist:
            raise serializers.ValidationError("Student with this ID does not exist.")
        return value


class RemoveMemberSerializer(serializers.Serializer):
    student_id = serializers.CharField(required=True)
