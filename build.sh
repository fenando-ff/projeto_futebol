#!/usr/bin/env bash
# Sair se houver erro
set -o errexit

# Instalar as bibliotecas
pip install -r requirements.txt

# Coletar arquivos estáticos (CSS/JS)
python manage.py collectstatic --no-input

# Rodar as migrações do banco de dados
python manage.py migrate