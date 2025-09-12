from django.urls import path
from . import views

urlpatterns = [
    path('', views.home, name='home'),
    path("carrinho/", views.tela_carrinho, name="carrinho"),
    path("loja_detalhe/", views.tela_loja_detalhe, name="loja_detalhe")
]
