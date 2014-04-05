from django.conf.urls import patterns, include, url

from django.contrib import admin

admin.autodiscover()

urlpatterns = patterns('',
                       # Examples:
                       # url(r'^$', 'wwf.views.home', name='home'),
                       # url(r'^blog/', include('blog.urls')),

                       url(r'^admin/', include(admin.site.urls)),
                       url(r'^test/', 'wwf.views.test'),
                       url(r'^facebook/', include('django_facebook.urls')),
                       url(r'^accounts/', include('django_facebook.auth_urls')),
                       url(r'^loginWithFacebook/', include('wwf.views.loginWithFacebook')),
                       url(r'^addSkillsToAccount/', include('wwf.views.addSkillsToAccount')),
                       url(r'^removeSkillFromAccount', include('wwf.views.removeSkillFromAccount')),
                       url(r'^postJob', include('wwf.views.postJob'))
    )
