from django.urls import path
from . import views

urlpatterns = [
    path('', views.home, name='home'),
    path('carrinho/', views.tela_carrinho, name='carrinho'),
    path('loja_detalhe/', views.tela_loja_detalhe, name='loja_detalhe'),
    path('socio/', views.tela_socio, name='socio'),
    path('login/', views.tela_login, name='login'),
    path('cadastro/', views.tela_cadastro, name='cadastro'),
    path('historia/', views.tela_historia, name='historia'),
]
