from django.contrib import admin
from .models import Team, TeamMembership


@admin.register(Team)
class TeamAdmin(admin.ModelAdmin):
    list_display = ['project', 'max_members', 'get_current_size', 'created_at']
    list_filter = ['created_at']
    search_fields = ['project__title']
    filter_horizontal = ['members']
    ordering = ['-created_at']

    def get_current_size(self, obj):
        return obj.get_member_count()
    get_current_size.short_description = 'Current Size'


@admin.register(TeamMembership)
class TeamMembershipAdmin(admin.ModelAdmin):
    list_display = ['team', 'student', 'role', 'joined_date']
    list_filter = ['role', 'joined_date']
    search_fields = ['team__project__title', 'student__user__name']
    ordering = ['-joined_date']
