from django.urls import path
from . import views

urlpatterns = [
    path('login/', views.tela_login, name='login'),
    path('logout', views.logout_view,name='logout'),
    path('', views.home, name='home'),
    path('carrinho/', views.tela_carrinho, name='carrinho'),
    path('adicionar/<int:produto_id>/', views.adicionar_carrinho, name='adicionar_carrinho'),
    path('remover/<int:produto_id>/', views.remover_carrinho, name='remover_carrinho'),
    path('atualizar/<int:produto_id>/', views.atualizar_quantidade_carrinho, name='atualizar_carrinho'),
    path('loja_detalhe/<int:produto_id>/', views.tela_loja_detalhe, name='loja_detalhe'),
    path('conta_criada/', views.tela_conta_finalizada, name='conta_criada'),
    path('historia/', views.tela_historia, name='historia'),
    path('loja_produtos/', views.tela_loja_produtos, name='produtos'),
    path('rec_senha/', views.tela_rec_senha, name='recuperar_senha'),
    path('rec_senha2/', views.tela_rec_senha_2, name='recuperar_senha2'),
    path('rec_senha3/', views.tela_rec_senha_3, name='recuperar_senha3'),
    path('ingresso/', views.tela_ingressos,name='ingresso'),
    path('socio/', views.tela_socio, name='socio'),
    path('pagamento_socio/<int:plano_id>/', views.pagamento_socio, name='confirmar_socio'),
    path('perfil/', views.tela_perfil, name='perfil'),
]

