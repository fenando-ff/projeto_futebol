from django.shortcuts import redirect
from django.contrib import messages
from functools import wraps

def login_obrigatorio(view_func):
    @wraps(view_func)
    def wrapper(request, *args, **kwargs):
        if not request.session.get("participante_id"):
            messages.warning(request, "Faça login para acessar o game 🎮")
            return redirect("game_comeco")
        return view_func(request, *args, **kwargs)
    return wrapper