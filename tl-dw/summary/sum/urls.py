from django.conf.urls import patterns, url
from sum import views

urlpatterns = patterns('',
    url(r'^$', views.index, name='home'),
    url(r'^summarize/(?P<url>\w+)/$', views.summarize, name="summary"),
)