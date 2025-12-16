from rest_framework import serializers
from .models import Project, Milestone, JoinRequest, Feedback
from users.serializers import StudentProfileSerializer, FacultyProfileSerializer


class MilestoneSerializer(serializers.ModelSerializer):
    class Meta:
        model = Milestone
        fields = [
            'id', 'project', 'description', 'due_date', 'is_completed',
            'completed_date', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'completed_date', 'created_at', 'updated_at']

    def validate_due_date(self, value):
        from django.utils import timezone
        if not self.instance and value < timezone.now().date():
            raise serializers.ValidationError("Milestone due date must be in the future.")
        return value


class JoinRequestSerializer(serializers.ModelSerializer):
    student_info = StudentProfileSerializer(source='student', read_only=True)
    project_info = serializers.SerializerMethodField()

    class Meta:
        model = JoinRequest
        fields = [
            'id', 'project', 'student', 'student_info', 'project_info',
            'request_date', 'status', 'message', 'response_message', 'response_date'
        ]
        read_only_fields = ['id', 'request_date', 'status', 'response_date', 'student_info']

    def get_project_info(self, obj):
        return {
            'id': obj.project.id,
            'title': obj.project.title,
            'owner': obj.project.owner.user.name
        }

    def validate(self, attrs):
        project = attrs.get('project')
        student = attrs.get('student')

        if student == project.owner:
            raise serializers.ValidationError("You cannot send a join request to your own project.")

        existing = JoinRequest.objects.filter(
            project=project,
            student=student
        ).exclude(status='rejected').exists()
        if existing:
            raise serializers.ValidationError("You have already sent a request to this project.")

        if not project.can_accept_members():
            raise serializers.ValidationError("This project's team is already full.")

        return attrs


class JoinRequestResponseSerializer(serializers.Serializer):
    response_message = serializers.CharField(required=False, allow_blank=True)


class FeedbackSerializer(serializers.ModelSerializer):
    faculty_info = FacultyProfileSerializer(source='faculty', read_only=True)

    class Meta:
        model = Feedback
        fields = [
            'id', 'project', 'faculty', 'faculty_info', 'comments',
            'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'faculty', 'faculty_info', 'created_at', 'updated_at']


class ProjectListSerializer(serializers.ModelSerializer):
    owner_name = serializers.CharField(source='owner.user.name', read_only=True)
    current_team_size = serializers.SerializerMethodField()
    supervisor_name = serializers.CharField(source='supervisor.user.name', read_only=True, allow_null=True)

    class Meta:
        model = Project
        fields = [
            'id', 'title', 'description', 'category', 'status', 'posted_date',
            'owner_name', 'current_team_size', 'max_team_size', 'supervisor_name',
            'required_skills', 'tags'
        ]

    def get_current_team_size(self, obj):
        return obj.get_current_team_size()


class ProjectDetailSerializer(serializers.ModelSerializer):
    owner_info = StudentProfileSerializer(source='owner', read_only=True)
    supervisor_info = FacultyProfileSerializer(source='supervisor', read_only=True)
    milestones = MilestoneSerializer(many=True, read_only=True)
    current_team_size = serializers.SerializerMethodField()
    available_slots = serializers.SerializerMethodField()
    team_members = serializers.SerializerMethodField()

    class Meta:
        model = Project
        fields = [
            'id', 'title', 'description', 'category', 'status', 'posted_date',
            'owner', 'owner_info', 'supervisor', 'supervisor_info',
            'required_skills', 'max_team_size', 'current_team_size', 'available_slots',
            'start_date', 'expected_duration', 'tags',
            'milestones', 'team_members',
            'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'posted_date', 'owner', 'created_at', 'updated_at']

    def get_current_team_size(self, obj):
        return obj.get_current_team_size()

    def get_available_slots(self, obj):
        return obj.max_team_size - obj.get_current_team_size()

    def get_team_members(self, obj):
        team = obj.get_team()
        if team:
            members = team.members.all()
            return StudentProfileSerializer(members, many=True).data
        return []


class ProjectCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Project
        fields = [
            'title', 'description', 'category', 'status', 'supervisor',
            'required_skills', 'max_team_size', 'start_date', 'expected_duration', 'tags'
        ]

    def validate_max_team_size(self, value):
        if value < 1 or value > 20:
            raise serializers.ValidationError("Team size must be between 1 and 20.")
        return value

    def create(self, validated_data):
        from teams.models import Team

        request = self.context.get('request')
        try:
            student = request.user.student_profile
        except AttributeError:
            raise serializers.ValidationError("Only students can create projects.")

        project = Project.objects.create(owner=student, **validated_data)

        Team.objects.create(project=project, max_members=project.max_team_size)

        return project


class ProjectUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Project
        fields = [
            'title', 'description', 'category', 'status', 'supervisor',
            'required_skills', 'max_team_size', 'start_date', 'expected_duration', 'tags'
        ]

    def validate_max_team_size(self, value):
        if self.instance:
            current_size = self.instance.get_current_team_size()
            if value < current_size:
                raise serializers.ValidationError(
                    f"Cannot set max team size below current member count ({current_size})."
                )
        return value
