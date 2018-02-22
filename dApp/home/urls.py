from django.conf.urls import url
from . import views
#app_name="home"
urlpatterns = [
    url(r'^$', views.main, name='main'),
    url(r'^game/(?P<id>[0-9]+)$', views.game, name='game'),
    url(r'^account/(?P<addr>\w{42})$', views.account, name = 'account'),
    url(r'^league/(?P<league>[-\w]+)/all_json_models/', views.all_json_models, name='all_json_models'),

    url(r'^putDB/create$', views.putCreateInfo, name='putCreateInfo'),
    url(r'^putDB/bet$', views.putBetInfo, name='putBetInfo'),
    url(r'^putDB/verify$', views.putVerifyInfo, name='putVerifyInfo'),

    url(r'^community/$', views.post_list, name = 'post_list'),
    url(r'^community/(?P<id>\d+)$', views.post_detail, name = 'post_detail'),
    url(r'^(?P<id>\d+)/edit/$', views.post_edit, name = "post_edit"),
    url(r'^community/posting/$', views.post_posting, name = 'post_posting')
]
