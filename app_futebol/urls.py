from django.urls import path
from . import views

urlpatterns = [
    path('', views.home, name='home'),
    path('carrinho/', views.tela_carrinho, name='carrinho'),
    path('loja_detalhe/', views.tela_loja_detalhe, name='loja_detalhe'),
    path('socio/', views.tela_socio, name='socio'),
    path('login/', views.tela_login, name='login'),
    path('cadastro/', views.tela_cadastro, name='cadastro'),
    path('conta_criada/', views.tela_conta_finalizada, name='conta_criada'),
    path('historia/', views.tela_historia, name='historia'),
    path('loja_produtos/', views.tela_loja_produtos, name='produtos'),
    path('noticias/', views.tela_noticias, name='noticias'),
    path('proximos_jogos/', views.tela_proximo_jogo, name='jogos'),
    path('rec_senha/', views.tela_rec_senha, name='recuperar_senha'),
    path('rec_senha2/', views.tela_rec_senha_2, name='recuperar_senha2'),
    path('ingresso/', views.tela_ingressos,name='ingresso'),
    path('pagamento_socio/', views.pagamento_socio,name='confirmar_socio'),
]

