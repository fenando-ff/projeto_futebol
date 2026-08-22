"""
URL configuration for projeto_futebol project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.conf import settings
from django.conf.urls.static import static
from django.contrib import admin
from django.shortcuts import render
from django.urls import include, path

urlpatterns = [
    path("admin/", admin.site.urls),
    path("", include("app_futebol.urls")),
    path("api/", include("app_futebol.urls_api")),
    path("register/", include("accounts.urls")),
    path("game/", include("minigame.urls")),
]

if settings.DEBUG:
    from drf_yasg import openapi
    from drf_yasg.views import get_schema_view
    from rest_framework import permissions

    schema_view = get_schema_view(
        openapi.Info(
            title="API Fut-App",
            default_version="v1",
            description="API backend do aplicativo Fut-App.",
            contact=openapi.Contact(email="contato@fut-app.com.br"),
        ),
        public=True,
        permission_classes=[permissions.AllowAny],
    )

    urlpatterns += [
        path("swagger/", schema_view.with_ui("swagger", cache_timeout=0), name="schema-swagger-ui"),
        path("swagger.json", schema_view.without_ui(cache_timeout=0), name="schema-json"),
    ]

    def teste_erro_400(request):
        return render(request, "400.html", status=400)

    def teste_erro_403(request):
        return render(request, "403.html", status=403)

    def teste_erro_404(request):
        return render(request, "404.html", status=404)

    def teste_erro_500(request):
        return render(request, "500.html", status=500)

    urlpatterns += [
        path("teste-erro/400/", teste_erro_400, name="teste-erro-400"),
        path("teste-erro/403/", teste_erro_403, name="teste-erro-403"),
        path("teste-erro/404/", teste_erro_404, name="teste-erro-404"),
        path("teste-erro/500/", teste_erro_500, name="teste-erro-500"),
    ]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
