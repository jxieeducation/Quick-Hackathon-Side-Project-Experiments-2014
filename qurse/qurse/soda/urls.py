from django.conf.urls import patterns, url
from soda import views

urlpatterns = patterns('',
    url(r'^$', views.index, name="home"),
    url(r'^create/$', views.create, name="create"),
    url(r'^pay/(?P<transaction_id>[-\w]+)/$', views.pay, name="pay"),
    url(r'^stripehook/$', views.stripehook, name="hook"),
    url(r'^status/(?P<transaction_id>[-\w]+)/$', views.status, name="status"),
)