from rest_framework import permissions


class IsProjectOwnerOrReadOnly(permissions.BasePermission):
    def has_object_permission(self, request, view, obj):
        if request.method in permissions.SAFE_METHODS:
            return True

        return obj.owner.user == request.user


class IsProjectOwner(permissions.BasePermission):
    def has_object_permission(self, request, view, obj):
        return obj.owner.user == request.user


class IsFacultyOrReadOnly(permissions.BasePermission):
    def has_permission(self, request, view):
        if request.method in permissions.SAFE_METHODS:
            return request.user and request.user.is_authenticated

        return (
            request.user and
            request.user.is_authenticated and
            request.user.user_type == 'faculty'
        )


class CanJoinProject(permissions.BasePermission):
    def has_object_permission(self, request, view, obj):
        if request.user.user_type != 'student':
            return False

        if obj.owner.user == request.user:
            return False

        return obj.can_accept_members()


class CanManageJoinRequest(permissions.BasePermission):
    def has_object_permission(self, request, view, obj):
        return obj.project.owner.user == request.user
