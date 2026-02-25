import os
from pathlib import Path
from dotenv import load_dotenv
import dj_database_url

# Caminhos básicos
BASE_DIR = Path(__file__).resolve().parent.parent
load_dotenv(BASE_DIR / ".env")

# SEGURANÇA: DEBUG dinâmico (False no Render, True local)
DEBUG = os.environ.get('RENDER', 'False') == 'True' or os.environ.get('DEBUG', 'True') == 'True'

# Configuração de Hosts para o Render
ALLOWED_HOSTS = ["localhost", "127.0.0.1", "projeto-futebol.onrender.com", ".onrender.com"]

# Secret Key com fallback para evitar quebra no build
SECRET_KEY = os.environ.get('SECRET_KEY', 'django-insecure-chave-padrao-local-123')

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'app_futebol',
    'accounts',
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'whitenoise.middleware.WhiteNoiseMiddleware',  # Essencial para arquivos estáticos
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'projeto_futebol.urls'

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

WSGI_APPLICATION = 'projeto_futebol.wsgi.application'

# BANCO DE DADOS: Configuração inteligente para Render
DATABASES = {
    'default': dj_database_url.config(
        default=f'mysql://{os.environ.get("DB_USER")}:{os.environ.get("DB_PASSWORD")}@{os.environ.get("DB_HOST")}:{os.environ.get("DB_PORT")}/{os.environ.get("DB_NAME")}',
        conn_max_age=600
    )
}

# Certificado SSL para o banco (se houver)
CA_CERT_PATH = os.path.join(BASE_DIR, "app_futebol", "certs", "ca.pem")
if os.path.exists(CA_CERT_PATH):
    DATABASES['default']['OPTIONS'] = {"ssl": {"ca": CA_CERT_PATH}}

# Internacionalização
LANGUAGE_CODE = 'pt-br'
TIME_ZONE = 'UTC'
USE_I18N = True
USE_TZ = True

# ARQUIVOS ESTÁTICOS (Onde o WhiteNoise brilha)
STATIC_URL = "/static/"
STATIC_ROOT = os.path.join(BASE_DIR, "staticfiles")

# Armazenamento otimizado para produção
if not DEBUG:
    STATICFILES_STORAGE = 'whitenoise.storage.CompressedManifestStaticFilesStorage'
else:
    STATICFILES_STORAGE = 'django.contrib.staticfiles.storage.StaticFilesStorage'

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

# Configurações de Email
EMAIL_BACKEND = os.environ.get('EMAIL_BACKEND', 'django.core.mail.backends.smtp.EmailBackend')
EMAIL_HOST = os.environ.get('EMAIL_HOST')
EMAIL_PORT = int(os.getenv("EMAIL_PORT", "587"))
EMAIL_USE_TLS = os.environ.get('EMAIL_USE_TLS') == 'True'
EMAIL_HOST_USER = os.environ.get('EMAIL_HOST_USER')
EMAIL_HOST_PASSWORD = os.environ.get('EMAIL_HOST_PASSWORD')