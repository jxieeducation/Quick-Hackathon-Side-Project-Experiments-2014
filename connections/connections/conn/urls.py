from django.conf.urls import patterns, url
from conn import views

urlpatterns = patterns('',
    url(r'^$', views.index, name='home'),
    url(r'^index/$', views.index, name='home'),
    url(r'^signup/$', views.signup, name="summary"),
    url(r'^login/$', views.login, name="summary"),
    url(r'^dashboard/$', views.dashboard, name="summary"),
    url(r'^message/$', views.message, name="summary"),
    url(r'^upgrade/$', views.upgrade, name="summary"),
    url(r'^graph/$', views.graph, name="summary"),
)