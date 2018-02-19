from django.shortcuts import render
from .models import League, Team
from django.forms.models import model_to_dict
from django.http import HttpResponse,JsonResponse

# Create your views here.

def main(request):
  leagues = League.objects.all()

  return render(request, 'home/main.html', {"leagues":leagues})

def game(request, id):
  return render(request, 'home/game.html', {"gid":id})

def get_league_list():
  league_list = League.objects.all()
  return {'leagues': league_list}

def all_json_models(request, league):
  league = league.replace("_", " ")
  current_league = League.objects.get(name=league)
  teams = Team.objects.all().filter(league=current_league)

  teams_dict = []

  for t in teams:
    teams_dict.append(model_to_dict(t))

  return JsonResponse(teams_dict, safe=False)
