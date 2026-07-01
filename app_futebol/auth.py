import hmac
import hashlib
import base64
import time
from django.conf import settings
from rest_framework.authentication import BaseAuthentication
from rest_framework import exceptions
from ..models import Clientes

TOKEN_TTL = 60 * 60 * 24 * 7


def _sign(client_id, timestamp):
    key = settings.SECRET_KEY.encode()
    msg = f"{client_id}:{timestamp}".encode()
    return hmac.new(key, msg, hashlib.sha256).hexdigest()


def gerar_token(client_id):
    timestamp = int(time.time())
    sig = _sign(client_id, timestamp)
    payload = f"{client_id}:{timestamp}:{sig}"
    return base64.urlsafe_b64encode(payload.encode()).decode()


def validar_token(token):
    try:
        payload = base64.urlsafe_b64decode(token.encode()).decode()
        client_id_str, timestamp_str, _ = payload.split(":")
        client_id = int(client_id_str)
        timestamp = int(timestamp_str)
    except Exception:
        return None

    if time.time() - timestamp > TOKEN_TTL:
        return None

    if _sign(client_id, timestamp) != payload.split(":")[2]:
        return None

    return client_id


class ClienteTokenAuthentication(BaseAuthentication):
    def authenticate(self, request):
        auth = request.headers.get("Authorization", "")
        if not auth.startswith("Token "):
            return None
        token = auth.split(" ", 1)[1]
        client_id = validar_token(token)
        if client_id is None:
            raise exceptions.AuthenticationFailed("Token inválido ou expirado")
        try:
            cliente = Clientes.objects.get(pk=client_id)
        except Clientes.DoesNotExist:
            raise exceptions.AuthenticationFailed("Usuário não encontrado")
        return (cliente, None)
