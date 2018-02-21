from django.conf.urls import url
from . import views

urlpatterns = [
    url(r'^$', views.main, name='main'),
    url(r'^game/(?P<id>[0-9]+)$', views.game, name='game'),
    url(r'^account/$', views.account, name = 'account'),
    url(r'^league/(?P<league>[-\w]+)/all_json_models/', views.all_json_models, name='all_json_models'),
    url(r'^putDB/create$', views.putCreateInfo, name='putCreateInfo'),
    url(r'^putDB/bet$', views.putBetInfo, name='putBetInfo'),
    url(r'^putDB/verify$', views.putVerifyInfo, name='putVerifyInfo'),

]
