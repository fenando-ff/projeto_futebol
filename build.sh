#!/usr/bin/env bash
<<<<<<< HEAD
set -o errexit
pip install -r requirements.txt
python manage.py collectstatic --no-input
=======
# Sair se houver erro
set -o errexit

# Instalar as bibliotecas
pip install -r requirements.txt

# Coletar arquivos estáticos (CSS/JS)
python manage.py collectstatic --no-input

# Rodar as migrações do banco de dados
>>>>>>> cd12e247b6a82871e257fc124cf29aad359fef40
python manage.py migrate