import os
from pathlib import Path
from dotenv import load_dotenv
import dj_database_url

# 1. Caminhos e Variáveis de Ambiente
BASE_DIR = Path(__file__).resolve().parent.parent
load_dotenv(BASE_DIR / ".env")

# 2. Segurança: DEBUG Dinâmico
# No Render será False (Seguro). No seu PC será True.
DEBUG = os.environ.get('RENDER', 'False') == 'True' or os.environ.get('DEBUG', 'True') == 'True'

# 3. Hosts Permitidos (Essencial para o Render)
ALLOWED_HOSTS = ["localhost", "127.0.0.1", "projeto-futebol.onrender.com", ".onrender.com"]

# 4. Secret Key
SECRET_KEY = os.getenv("SECRET_KEY")
if not SECRET_KEY:
    if DEBUG:
        SECRET_KEY = 'django-insecure-chave-temporaria-local'
    else:
        raise RuntimeError("A variável SECRET_KEY não foi configurada no Render!")

# 5. Apps instaladas
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

# 6. Middleware (WhiteNoise deve ser o segundo da lista)
MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'whitenoise.middleware.WhiteNoiseMiddleware',
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

# 7. Banco de Dados (Suporta DATABASE_URL do Render ou Variáveis separadas)
DATABASES = {
    'default': dj_database_url.config(
        default=f'mysql://{os.environ.get("DB_USER")}:{os.environ.get("DB_PASSWORD")}@{os.environ.get("DB_HOST")}:{os.environ.get("DB_PORT")}/{os.environ.get("DB_NAME")}',
        conn_max_age=600
    )
}

# Configuração de SSL para o MySQL
CA_CERT_PATH = os.path.join(BASE_DIR, "app_futebol", "certs", "ca.pem")
if os.path.exists(CA_CERT_PATH):
    DATABASES['default']['OPTIONS'] = {"ssl": {"ca": CA_CERT_PATH}}

# 8. Internacionalização
LANGUAGE_CODE = 'pt-br'
TIME_ZONE = 'UTC'
USE_I18N = True
USE_TZ = True

# 9. Arquivos Estáticos (Configuração WhiteNoise)
STATIC_URL = "/static/"
STATIC_ROOT = os.path.join(BASE_DIR, "staticfiles")

if not DEBUG:
    STATICFILES_STORAGE = 'whitenoise.storage.CompressedManifestStaticFilesStorage'
else:
    STATICFILES_STORAGE = 'django.contrib.staticfiles.storage.StaticFilesStorage'

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

# 10. Email
EMAIL_BACKEND = os.environ.get('EMAIL_BACKEND', 'django.core.mail.backends.smtp.EmailBackend')
EMAIL_HOST = os.environ.get('EMAIL_HOST')
EMAIL_PORT = int(os.getenv("EMAIL_PORT", "587"))
EMAIL_USE_TLS = os.environ.get('EMAIL_USE_TLS') == 'True'
EMAIL_HOST_USER = os.environ.get('EMAIL_HOST_USER')
EMAIL_HOST_PASSWORD = os.environ.get('EMAIL_HOST_PASSWORD')