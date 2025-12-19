"""
URL configuration for Medipol Student Project Hub
"""
from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/auth/', include('users.urls')),
    path('api/projects/', include('projects.urls')),
    path('api/teams/', include('teams.urls')),
    path('api/messaging/', include('messaging.urls')),
]

# Serve media files in development
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

# Custom admin site headers
admin.site.site_header = "Medipol Student Project Hub Admin"
admin.site.site_title = "Medipol Hub Admin"
admin.site.index_title = "Welcome to Medipol Student Project Hub Administration"
