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
    path('rec_senha/', views.tela_rec_senha, name='rec_senha'),
    path('rec_senha_2/', views.tela_rec_senha_2, name='rec_senha_2'),
]
