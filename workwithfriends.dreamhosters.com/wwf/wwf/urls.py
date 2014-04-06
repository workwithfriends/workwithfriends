from django.conf.urls import patterns, include, url

from django.contrib import admin

admin.autodiscover()

urlpatterns = patterns('',
                       # Examples:
                       # url(r'^$', 'wwf.views.home', name='home'),
                       # url(r'^blog/', include('blog.urls')),

                       url(
                           r'^admin/',
                           include(admin.site.urls)
                       ),
                       url(
                           r'^facebook/',
                           include('django_facebook.urls')
                       ),
                       url(
                           r'^accounts/',
                           include('django_facebook.auth_urls')
                       ),
                       url(
                           r'^loginWithFacebook/',
                           include('wwf.views.loginWithFacebook')
                       ),
                       url(
                           r'^addAboutMeToAccount',
                           include('wwf.views.addAboutMeToAccount')
                       ),
                       url(
                           r'^addSkillsToAccount/',
                           include('wwf.views.addSkillsToAccount')
                       ),
                       url(
                           r'^removeSkillFromAccount/',
                           include('wwf.views.removeSkillFromAccount')
                       ),
                       url(
                           r'^postJob/',
                           include('wwf.views.postJob')
                       ),
                       url(
                           r'^deleteJob/',
                           include('wwf.views.deleteJob')
                       ),
                       url(
                           r'^takeJob/',
                           include('wwf.views.takeJob')
                       ),
                       url(
                           r'^completeJob/',
                           include('wwf.views.completeJob')
                       ),
                       url(
                           r'^viewFriendProfile/',
                           include('wwf.views.viewFriendProfile')
                       ),
                       url(
                           r'^getPostedJobs/',
                           include('wwf.views.getPostedJobs')
                       ),
)

