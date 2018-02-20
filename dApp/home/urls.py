from django.conf.urls import url
from . import views

urlpatterns = [
    url(r'^$', views.main, name='main'),
    url(r'^game/(?P<id>[0-9]+)$', views.game, name='game'),
    url(r'^account/$', views.account, name = 'account')
]
