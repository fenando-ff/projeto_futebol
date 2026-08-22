import os
from pathlib import Path

from dotenv import load_dotenv

load_dotenv()

BASE_DIR = Path(__file__).resolve().parent.parent


def _env_bool(name, default=False):
    value = os.environ.get(name)
    if value is None:
        return default
    return value.strip().lower() in {"1", "true", "yes", "on"}


IS_RENDER = _env_bool("RENDER")
DEBUG = _env_bool("DEBUG", default=not IS_RENDER) and not IS_RENDER

IP_LOCAL = os.environ.get("IP_LOCAL")
ALLOWED_HOSTS = [
    "localhost",
    "127.0.0.1",
    "172.20.10.3",
    "10.100.179.2",
    "192.168.1.7",
    "172.24.57.2",
    "172.20.10.4",
]
if IS_RENDER:
    ALLOWED_HOSTS.extend(["projeto-futebol.onrender.com", ".onrender.com"])
if IP_LOCAL:
    ALLOWED_HOSTS.append(IP_LOCAL)

SECRET_KEY = os.environ.get("SECRET_KEY")
if not SECRET_KEY:
    raise RuntimeError("Defina a variavel de ambiente SECRET_KEY em producao.")

INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    "rest_framework",
    "drf_yasg",
    "django_filters",
    "storages",
    "app_futebol",
    "accounts",
    "minigame",
]

REST_FRAMEWORK = {
    "DEFAULT_AUTHENTICATION_CLASSES": [
        "rest_framework.authentication.SessionAuthentication",
        "app_futebol.auth.ClienteTokenAuthentication",
    ],
    "DEFAULT_PERMISSION_CLASSES": [
        "rest_framework.permissions.IsAuthenticatedOrReadOnly",
    ],
    "DEFAULT_PAGINATION_CLASS": "rest_framework.pagination.PageNumberPagination",
    "PAGE_SIZE": 20,
    "DEFAULT_THROTTLE_CLASSES": [
        "rest_framework.throttling.AnonRateThrottle",
        "rest_framework.throttling.UserRateThrottle",
    ],
    "DEFAULT_THROTTLE_RATES": {
        "anon": "100/min",
        "user": "300/min",
    },
}

if DEBUG:
    REST_FRAMEWORK["DEFAULT_RENDERER_CLASSES"] = [
        "rest_framework.renderers.JSONRenderer",
        "rest_framework.renderers.BrowsableAPIRenderer",
    ]
else:
    REST_FRAMEWORK["DEFAULT_RENDERER_CLASSES"] = [
        "rest_framework.renderers.JSONRenderer",
    ]

# Origins permitidas para frontend/mobile.
CORS_ALLOWED_ORIGINS = [
    "http://localhost:8000",
    "http://localhost:8081",
    "http://localhost:19006",
    "http://10.20.83.22:8000",
    "http://10.183.35.22:8000",
    "http://192.168.61.90:8000",
    "https://projeto-futebol.onrender.com",
]
CORS_ALLOW_CREDENTIALS = True

CSRF_TRUSTED_ORIGINS = [
    "http://localhost:8000",
    "http://localhost:8081",
    "http://localhost:19006",
    "https://projeto-futebol.onrender.com",
]

R2_ACCOUNT_ID = os.environ.get("R2_ACCOUNT_ID")
R2_ACCESS_KEY_ID = os.environ.get("R2_ACCESS_KEY_ID")
R2_SECRET_ACCESS_KEY = os.environ.get("R2_SECRET_ACCESS_KEY")
R2_BUCKET_NAME = os.environ.get("R2_BUCKET_NAME")
R2_REGION_NAME = os.environ.get("R2_REGION_NAME", "auto")
R2_ENDPOINT_URL = f"https://{R2_ACCOUNT_ID}.r2.cloudflarestorage.com"

DEFAULT_FILE_STORAGE = "storages.backends.s3boto3.S3Boto3Storage"

AWS_S3_REGION_NAME = R2_REGION_NAME
AWS_S3_ENDPOINT_URL = R2_ENDPOINT_URL
AWS_S3_ACCESS_KEY_ID = R2_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY = R2_SECRET_ACCESS_KEY
AWS_STORAGE_BUCKET_NAME = R2_BUCKET_NAME
AWS_S3_OBJECT_PARAMETERS = {"CacheControl": "max-age=86400"}
AWS_S3_FILE_OVERWRITE = True
AWS_S3_USE_SSL = True
AWS_DEFAULT_ACL = "public-read"
AWS_S3_SIGNATURE_VERSION = "s3v4"

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.debug",
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
            ],
        },
    },
]

MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "whitenoise.middleware.WhiteNoiseMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
]

ROOT_URLCONF = "projeto_futebol.urls"
WSGI_APPLICATION = "projeto_futebol.wsgi.application"

if IS_RENDER:
    DATABASES = {
        "default": {
            "ENGINE": os.environ.get("DB_ENGINE"),
            "NAME": os.environ.get("DB_NAME"),
            "USER": os.environ.get("DB_USER"),
            "PASSWORD": os.environ.get("DB_PASSWORD"),
            "HOST": os.environ.get("DB_HOST"),
            "PORT": int(os.environ.get("DB_PORT")),
            "OPTIONS": {
                "ssl": {
                    "ca": os.path.join(BASE_DIR, os.environ.get("DB_SSL_CA"))
                }
            },
        },
    }
else:
    DATABASES = {
        "default": {
            "ENGINE": os.environ.get("DB_ENGINE"),
            "NAME": os.environ.get("DB_NAME_LOCAL"),
            "USER": os.environ.get("DB_USER_LOCAL"),
            "PASSWORD": os.environ.get("DB_PASSWORD_LOCAL"),
            "HOST": os.environ.get("DB_HOST_LOCAL"),
            "PORT": int(os.environ.get("DB_PORT_LOCAL")),
        },
    }

EMAIL_TRANSPORT = os.environ.get("EMAIL_TRANSPORT", "smtp").strip().lower()
EMAIL_BACKEND = (
    "app_futebol.email_backends.ResendEmailBackend"
    if EMAIL_TRANSPORT == "resend"
    else os.environ.get("EMAIL_BACKEND", "django.core.mail.backends.smtp.EmailBackend")
)
EMAIL_HOST = os.environ.get("EMAIL_HOST", "")
EMAIL_PORT = int(os.getenv("EMAIL_PORT", "587"))
EMAIL_USE_TLS = os.environ.get("EMAIL_USE_TLS", "True") == "True"
EMAIL_HOST_USER = os.environ.get("EMAIL_HOST_USER", "")
EMAIL_HOST_PASSWORD = os.environ.get("EMAIL_HOST_PASSWORD", "")
RESEND_API_KEY = os.environ.get("RESEND_API_KEY", "")
RESEND_FROM_EMAIL = os.environ.get("RESEND_FROM_EMAIL", "")
EMAIL_REQUEST_TIMEOUT_SECONDS = float(os.getenv("EMAIL_REQUEST_TIMEOUT_SECONDS", "10"))
DEFAULT_FROM_EMAIL = os.environ.get(
    "DEFAULT_FROM_EMAIL",
    RESEND_FROM_EMAIL if EMAIL_TRANSPORT == "resend" else (EMAIL_HOST_USER or "webmaster@localhost"),
)

DB_ENGINE = os.getenv("DB_ENGINE")
CA_CERT_PATH = os.path.join(BASE_DIR, "app_futebol", "certs", "ca.pem")
if os.path.exists(CA_CERT_PATH) and DB_ENGINE and "mysql" in DB_ENGINE:
    DATABASES["default"]["OPTIONS"] = {"ssl": {"ca": CA_CERT_PATH}}

STATIC_URL = "/static/"
STATIC_ROOT = os.path.join(BASE_DIR, "staticfiles")
STATICFILES_STORAGE = "whitenoise.storage.CompressedManifestStaticFilesStorage"
MEDIA_URL = "/media/"
MEDIA_ROOT = os.path.join(BASE_DIR, "media")

SESSION_COOKIE_SECURE = IS_RENDER
CSRF_COOKIE_SECURE = IS_RENDER
SECURE_PROXY_SSL_HEADER = ("HTTP_X_FORWARDED_PROTO", "https") if IS_RENDER else None

DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"

TIME_ZONE = "America/Sao_Paulo"
LANGUAGE_CODE = "pt-br"
