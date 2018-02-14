from django.shortcuts import render

# Create your views here.

def index(request, id):
  return render(request, 'game/index.html', {"gid":id})
