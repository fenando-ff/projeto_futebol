"""Testes isolados, sem conectar ao MySQL ou enviar emails reais.

As migrations da aplicacao espelham tabelas externas e incluem SQL MySQL.
Os testes de fluxo criam somente as tabelas unmanaged de que precisam.
"""
from .settings import *  # noqa: F403

DATABASES = {"default": {"ENGINE": "django.db.backends.sqlite3", "NAME": ":memory:"}}
MIGRATION_MODULES = {"app_futebol": None, "accounts": None, "minigame": None}
EMAIL_BACKEND = "django.core.mail.backends.locmem.EmailBackend"
PASSWORD_HASHERS = ["django.contrib.auth.hashers.MD5PasswordHasher"]
ALLOWED_HOSTS = ["testserver", "localhost"]
STORAGES = {
    "default": {"BACKEND": "django.core.files.storage.FileSystemStorage"},
    "staticfiles": {"BACKEND": "django.contrib.staticfiles.storage.StaticFilesStorage"},
}
