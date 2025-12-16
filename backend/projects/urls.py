"""
URL routing for Projects app
"""
from django.urls import path, include
from rest_framework.routers import DefaultRouter

from .views import (
    ProjectViewSet,
    MilestoneViewSet,
    JoinRequestViewSet
)

router = DefaultRouter()
router.register(r'', ProjectViewSet, basename='project')
router.register(r'milestones', MilestoneViewSet, basename='milestone')
router.register(r'requests', JoinRequestViewSet, basename='joinrequest')

urlpatterns = [
    path('', include(router.urls)),
]
