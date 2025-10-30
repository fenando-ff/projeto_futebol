from django.urls import path
from . import views

urlpatterns = [
    path('', views.home, name='home'),
    path('carrinho/', views.tela_carrinho, name='carrinho'),
    path('loja_detalhe/', views.tela_loja_detalhe, name='loja_detalhe'),
    path('socio/', views.tela_socio, name='socio'),
    path('login/', views.tela_login, name='login'),
    path('cadastro/', views.tela_cadastro, name='cadastro'),
    path('cadastro_2/', views.tela_rec_senha, name='cadastro2'),
    path('cadastro_3/', views.tela_rec_senha_2, name='cadastro3'),
    path('carrinho/', views.tela_rec_senha_2, name='carrinho'),
    path('conta_criada/', views.tela_rec_senha_2, name='conta_criada'),
    path('historia/', views.tela_historia, name='historia'),
    path('loja_produtos/', views.tela_historia, name='produtos'),
    path('noticias/', views.tela_historia, name='noticias'),
    path('proximos_jogos/', views.tela_historia, name='jogos'),
    path('rec_senha/', views.tela_historia, name='recuperar_senha'),
    path('rec_senha2/', views.tela_historia, name='recuperar_senha2'),
    path('ingresso/', views.tela_historia, name='ingresso'),
]
