from django.shortcuts import render
from .models import *
from django.forms.models import model_to_dict
from django.http import HttpResponse,JsonResponse, HttpResponseNotAllowed
from django.views.decorators.csrf import ensure_csrf_cookie

# Create your views here.

def main(request):
  leagues = League.objects.all()

  return render(request, 'home/main.html', {"leagues":leagues})

def game(request, id):
  return render(request, 'home/game.html', {"gid":id})


def account(request, addr):
  account = Account.objects.get(addr=addr)
  txs = Transaction.objects.filter(sender=account)
  print(txs)
  return render(request, 'home/account.html', {"txs":txs})

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

@ensure_csrf_cookie
def putCreateInfo(request):
  if not request.is_ajax:
    return HttpResponseNotAllowed()
  try:
    addr = request.POST.get('addr')
    account = Account.objects.get_or_create(addr=addr)[0]
  
    txid = request.POST.get('txid')
    league = request.POST.get('league')
    teamA = request.POST.get('teamA')
    teamB = request.POST.get('teamB')
    startTime = request.POST.get('startTimeStamp')
  except KeyError:
    print("Faild to create txinfo")
    return HttpResponse(status=304)

  Transaction.objects.create(sender=account, txid=txid, txtype='CREATE',
                             league=league, teamA=teamA, teamB=teamB, startTime=startTime)

  return HttpResponse(status=200)

@ensure_csrf_cookie
def putBetInfo(request):
  if not request.is_ajax:
    return HttpResponseNotAllowed()
  try:
    addr = request.POST.get('addr')
    account = Account.objects.get_or_create(addr=addr)[0]
  
    txid = request.POST.get('txid')
    league = request.POST.get('league')
    teamA = request.POST.get('teamA')
    teamB = request.POST.get('teamB')
    startTime = request.POST.get('startTimeStamp')
  except KeyError:
    print("Faild to create txinfo")
    return HttpResponse(status=304)

  Transaction.objects.create(sender=account, txid=txid, txtype='BET',
                             league=league, teamA=teamA, teamB=teamB, startTime=startTime)

  return HttpResponse(status=200)

@ensure_csrf_cookie
def putVerifyInfo(request):
  if not request.is_ajax:
    return HttpResponseNotAllowed()
  try:
    addr = request.POST.get('addr')
    account = Account.objects.get_or_create(addr=addr)[0]

    txid = request.POST.get('txid')
    league = request.POST.get('league')
    teamA = request.POST.get('teamA')
    teamB = request.POST.get('teamB')
    startTime = request.POST.get('startTimeStamp')
  except KeyError:
    print("Faild to create txinfo")
    return HttpResponse(status=304)

  Transaction.objects.create(sender=account, txid=txid, txtype='VERIFY',
                             league=league, teamA=teamA, teamB=teamB, startTime=startTime)

  return HttpResponse(status=200)




