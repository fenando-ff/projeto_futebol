import os
from pathlib import Path
from dotenv import load_dotenv
import dj_database_url
import cloudinary

load_dotenv()

BASE_DIR = Path(__file__).resolve().parent.parent
# DEBUG dinâmico: False no Render, True local
DEBUG = os.environ.get('RENDER', 'False') == 'True' or os.environ.get('DEBUG', 'True') == 'True'

ALLOWED_HOSTS = ["localhost", "127.0.0.1", "projeto-futebol.onrender.com", ".onrender.com", "10.20.83.22", "192.168.61.90"]

SECRET_KEY = os.environ.get('SECRET_KEY', 'django-insecure-fallback-key')

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'app_futebol',
    'accounts',
    'cloudinary',
    'cloudinary_storage',
]

cloudinary.config(
    cloud_name = os.environ.get("Cloudinary_name"),
    api_key = os.environ.get("Cloudinary_key"),
    api_secret = os.environ.get("Cloudinary_secret_key"),
)

DEFAULT_FILE_STORAGE = 'cloudinary_storage.storage.MediaCloudinaryStorage'


TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'whitenoise.middleware.WhiteNoiseMiddleware', # WhiteNoise para arquivos estáticos
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'projeto_futebol.urls'
WSGI_APPLICATION = 'projeto_futebol.wsgi.application'

# Banco de Dados: Usa DATABASE_URL do Render se existir 
# try:
#     DATABASES = {
#         "default": {
#             "ENGINE": os.environ.get("DB_ENGINE"),
#             "NAME": os.environ.get("DB_NAME"),
#             "USER": os.environ.get("DB_USER"),
#             "PASSWORD": os.environ.get("DB_PASSWORD"),
#             "HOST": os.environ.get("DB_HOST"),
#             "PORT": os.environ.get("DB_PORT"),
#             "OPTIONS": {
#                 "ssl": {"ca": str(BASE_DIR / "app_futebol" / "certs" / "ca.pem")}
#             },
#         }
#     }
# except Exception as e:
#     print(f"Erro ao configurar o banco de dados em produção: {e}")
#     try:    
#         DATABASES = {
#             "default": {
#                 "ENGINE": os.environ.get("DB_ENGINE_LOCAL"),
#                 "NAME": os.environ.get("DB_NAME_LOCAL"),
#                 "USER": os.environ.get("DB_USER_LOCAL"),
#                 "PASSWORD": os.environ.get("DB_PASSWORD_LOCAL"),
#                 "HOST": os.environ.get("DB_HOST_LOCAL"),
#                 "PORT": os.environ.get("DB_PORT_LOCAL")
#             }
#         }
#     except Exception as e:
#         print(f"Erro ao configurar o banco de dados local: {e}")




IS_RENDER = os.environ.get("RENDER", "False") == "True"

if IS_RENDER:
    DATABASES = {
        "default": {
            "ENGINE": os.environ.get("DB_ENGINE"),
            "NAME": os.environ.get("DB_NAME"),
            "USER": os.environ.get("DB_USER"),
            "PASSWORD": os.environ.get("DB_PASSWORD"),
            "HOST": os.environ.get("DB_HOST"),
            "PORT": os.environ.get("DB_PORT"),
            "OPTIONS": {
                "ssl": {
                    "ca": str(BASE_DIR / "app_futebol" / "certs" / "ca.pem")
                }
            },
        }
    }
else:
    DATABASES = {
        "default": {
            "ENGINE": os.environ.get("DB_ENGINE_LOCAL"),
            "NAME": os.environ.get("DB_NAME_LOCAL"),
            "USER": os.environ.get("DB_USER_LOCAL"),
            "PASSWORD": os.environ.get("DB_PASSWORD_LOCAL"),
            "HOST": os.environ.get("DB_HOST_LOCAL"),
            "PORT": os.environ.get("DB_PORT_LOCAL"),
        }
    }
    
    
    
    
EMAIL_BACKEND = os.environ.get('EMAIL_BACKEND', 'django.core.mail.backends.smtp.EmailBackend')
EMAIL_HOST = os.environ.get('EMAIL_HOST')
EMAIL_PORT = int(os.getenv("EMAIL_PORT", "587"))
EMAIL_USE_TLS = os.environ.get('EMAIL_USE_TLS') == 'True'
EMAIL_HOST_USER = os.environ.get('EMAIL_HOST_USER')
EMAIL_HOST_PASSWORD = os.environ.get('EMAIL_HOST_PASSWORD')

# Certificado SSL se o arquivo existir
CA_CERT_PATH = os.path.join(BASE_DIR, "app_futebol", "certs", "ca.pem")
if os.path.exists(CA_CERT_PATH):
    DATABASES['default']['OPTIONS'] = {"ssl": {"ca": CA_CERT_PATH}}

STATIC_URL = "/static/"
STATIC_ROOT = os.path.join(BASE_DIR, "staticfiles")
STATICFILES_STORAGE = 'whitenoise.storage.CompressedManifestStaticFilesStorage'

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

print("RENDER =", os.environ.get("RENDER"))
print("DB_HOST produção =", os.environ.get("DB_HOST"))
print("DB_HOST local =", os.environ.get("DB_HOST_LOCAL"))
print("Banco escolhido =", DATABASES["default"]["HOST"])
print("Engine escolhida =", DATABASES["default"]["ENGINE"])