from functools import wraps
from django.shortcuts import redirect
from django.http import JsonResponse


def cliente_login_required(view_func):
    @wraps(view_func)
    def _wrapped_view(request, *args, **kwargs):
        if not request.session.get("cliente_id"):
            if request.headers.get("X-Requested-With") == "XMLHttpRequest":
                return JsonResponse(
                    {"success": False, "needs_login": True, "message": "Faça login para continuar."},
                    status=401,
                )
            return redirect("login")
        return view_func(request, *args, **kwargs)
    return _wrapped_view
