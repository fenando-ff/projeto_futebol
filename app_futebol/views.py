from django.shortcuts import render

# Create your views here.
from django.http import HttpResponse

def home(request):
    return HttpResponse("Se está vendo essa mensagem é pq rodou sucesso!")