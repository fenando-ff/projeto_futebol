from django.urls import path
from minigame import views

urlpatterns = [
    path('game_roleta/', views.game_sorteio, name='game_sorteio'),
    path('', views.game, name='mini_game'),
    path('game_toturial/', views.game_toturial, name='mini_game_toturial'),
]
