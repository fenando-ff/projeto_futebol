from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path("admin/", admin.site.urls),
    path("", include("app_futebol.urls")),      # site normal 
    path("register/", include("accounts.urls")),
    path("api/", include("app_futebol.api_urls")),  # API
]
