import os
from pathlib import Path
from dotenv import load_dotenv
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
    'minigame',
]


cloudinary.config(
    cloud_name=os.environ.get("Cloudinary_name"),
    api_key=os.environ.get("Cloudinary_key"),
    api_secret=os.environ.get("Cloudinary_secret_key"),
    secure=True,
)

# DEFAULT_FILE_STORAGE = 'cloudinary_storage.storage.MediaCloudinaryStorage'


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

IS_RENDER = os.environ.get("RENDER")

if IS_RENDER == "True":
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
            "HOST": os.environ.get("DB_HOST_LOCAL",),
            "PORT": int(os.environ.get("DB_PORT_LOCAL")),
        },
    }
    
EMAIL_BACKEND = os.environ.get('EMAIL_BACKEND')
EMAIL_HOST = os.environ.get('EMAIL_HOST')
EMAIL_PORT = int(os.getenv("EMAIL_PORT", "587"))
EMAIL_USE_TLS = os.environ.get('EMAIL_USE_TLS') == 'True'
EMAIL_HOST_USER = os.environ.get('EMAIL_HOST_USER')
EMAIL_HOST_PASSWORD = os.environ.get('EMAIL_HOST_PASSWORD')

# Certificado SSL apenas para MySQL
DB_ENGINE = os.getenv('DB_ENGINE')
CA_CERT_PATH = os.path.join(BASE_DIR, "app_futebol", "certs", "ca.pem")
if os.path.exists(CA_CERT_PATH) and DB_ENGINE and 'mysql' in DB_ENGINE:
    DATABASES['default']['OPTIONS'] = {"ssl": {"ca": CA_CERT_PATH}}

STATIC_URL = "/static/"
STATIC_ROOT = os.path.join(BASE_DIR, "staticfiles")
STATICFILES_STORAGE = 'whitenoise.storage.CompressedManifestStaticFilesStorage'
MEDIA_URL = "/media/"
MEDIA_ROOT = os.path.join(BASE_DIR, "media")        #upload da img

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

# print("RENDER =", os.environ.get("RENDER"))
# print("DB_HOST produção =", os.environ.get("DB_HOST"))
# print("DB_HOST local =", os.environ.get("DB_HOST_LOCAL"))
print("Host selecionado =", DATABASES["default"]["HOST"])
# print("Engine escolhida =", DATABASES["default"]["ENGINE"])