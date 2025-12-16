from django.db import models
from users.models import Student
from projects.models import Project


class Team(models.Model):
    project = models.OneToOneField(Project, on_delete=models.CASCADE, related_name='team')
    max_members = models.PositiveIntegerField(default=5)
    members = models.ManyToManyField(Student, related_name='teams', blank=True)

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name = 'Team'
        verbose_name_plural = 'Teams'
        ordering = ['-created_at']

    def __str__(self):
        return f"Team for {self.project.title} ({self.members.count()}/{self.max_members})"

    def add_member(self, student):
        if self.members.count() >= self.max_members:
            return False

        if self.members.filter(pk=student.pk).exists():
            return False

        if student == self.project.owner:
            return False

        self.members.add(student)
        return True

    def remove_member(self, student_id):
        try:
            student = Student.objects.get(student_id=student_id)
            self.members.remove(student)
        except Student.DoesNotExist:
            pass

    def get_member_count(self):
        return self.members.count()

    def is_full(self):
        return self.members.count() >= self.max_members

    def get_available_slots(self):
        return max(0, self.max_members - self.members.count())


class TeamMembership(models.Model):
    ROLE_CHOICES = (
        ('owner', 'Project Owner'),
        ('member', 'Team Member'),
        ('contributor', 'Contributor'),
    )

    team = models.ForeignKey(Team, on_delete=models.CASCADE, related_name='memberships')
    student = models.ForeignKey(Student, on_delete=models.CASCADE, related_name='memberships')
    role = models.CharField(max_length=20, choices=ROLE_CHOICES, default='member')
    joined_date = models.DateTimeField(auto_now_add=True)

    class Meta:
        verbose_name = 'Team Membership'
        verbose_name_plural = 'Team Memberships'
        unique_together = ['team', 'student']
        ordering = ['joined_date']

    def __str__(self):
        return f"{self.student.user.name} - {self.team.project.title} ({self.role})"
