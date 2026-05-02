from django.urls import path
from minigame import views

urlpatterns = [
    path('game/', views.game, name='game_comeco'),
    path('game_roleta/', views.game_sorteio, name='game_sorteio'),
    path('game_toturial/', views.game_toturial, name='mini_game_toturial'),
]

#http://127.0.0.1:8000/game/game_tutorial/ direciona para a página de jogos
