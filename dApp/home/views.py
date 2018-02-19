from django.shortcuts import render
from .models import League, Team

# Create your views here.

def main(request):
  leagues = League.objects.all()
  return render(request, 'home/main.html', {"leagues":leagues})

def game(request, id):
  return render(request, 'home/game.html', {"gid":id})
