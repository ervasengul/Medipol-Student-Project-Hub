from django.contrib import admin
from .models import Project, Milestone, JoinRequest, Feedback


class MilestoneInline(admin.TabularInline):
    model = Milestone
    extra = 1
    fields = ['description', 'due_date', 'is_completed']


@admin.register(Project)
class ProjectAdmin(admin.ModelAdmin):
    list_display = ['title', 'owner', 'category', 'status', 'posted_date', 'get_team_size']
    list_filter = ['category', 'status', 'posted_date']
    search_fields = ['title', 'description', 'owner__user__name']
    ordering = ['-posted_date']
    inlines = [MilestoneInline]

    fieldsets = (
        ('Basic Information', {
            'fields': ('title', 'description', 'category', 'status')
        }),
        ('Team & Supervision', {
            'fields': ('owner', 'supervisor', 'max_team_size')
        }),
        ('Details', {
            'fields': ('required_skills', 'start_date', 'expected_duration', 'tags')
        }),
    )

    def get_team_size(self, obj):
        return f"{obj.get_current_team_size()}/{obj.max_team_size}"
    get_team_size.short_description = 'Team Size'


@admin.register(Milestone)
class MilestoneAdmin(admin.ModelAdmin):
    list_display = ['project', 'description', 'due_date', 'is_completed', 'completed_date']
    list_filter = ['is_completed', 'due_date']
    search_fields = ['project__title', 'description']
    ordering = ['due_date']


@admin.register(JoinRequest)
class JoinRequestAdmin(admin.ModelAdmin):
    list_display = ['student', 'project', 'status', 'request_date', 'response_date']
    list_filter = ['status', 'request_date']
    search_fields = ['student__user__name', 'project__title']
    ordering = ['-request_date']


@admin.register(Feedback)
class FeedbackAdmin(admin.ModelAdmin):
    list_display = ['project', 'faculty', 'created_at']
    list_filter = ['created_at']
    search_fields = ['project__title', 'faculty__user__name', 'comments']
    ordering = ['-created_at']
