from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from .models import User, Student, Faculty


@admin.register(User)
class UserAdmin(BaseUserAdmin):
    list_display = ['email', 'name', 'user_type', 'is_active', 'date_joined']
    list_filter = ['user_type', 'is_active', 'is_staff', 'date_joined']
    search_fields = ['email', 'name']
    ordering = ['-date_joined']

    fieldsets = (
        (None, {'fields': ('email', 'password')}),
        ('Personal info', {'fields': ('name', 'profile_image', 'user_type')}),
        ('Permissions', {'fields': ('is_active', 'is_staff', 'is_superuser')}),
        ('Important dates', {'fields': ('last_login', 'date_joined')}),
    )

    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('email', 'name', 'user_type', 'password1', 'password2'),
        }),
    )


@admin.register(Student)
class StudentAdmin(admin.ModelAdmin):
    list_display = ['student_id', 'get_name', 'department', 'year']
    list_filter = ['department', 'year']
    search_fields = ['student_id', 'user__name', 'user__email', 'department']
    ordering = ['student_id']

    def get_name(self, obj):
        return obj.user.name
    get_name.short_description = 'Name'


@admin.register(Faculty)
class FacultyAdmin(admin.ModelAdmin):
    list_display = ['faculty_id', 'get_name', 'title', 'department']
    list_filter = ['department', 'title']
    search_fields = ['faculty_id', 'user__name', 'user__email', 'department']
    ordering = ['faculty_id']

    def get_name(self, obj):
        return obj.user.name
    get_name.short_description = 'Name'
