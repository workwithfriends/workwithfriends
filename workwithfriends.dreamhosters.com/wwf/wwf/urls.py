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
                           'wwf.views.loginWithFacebook'
                       ),
                       url(
                           r'^addAboutMeToAccount',
                           'wwf.views.addAboutMeToAccount'
                       ),
                       url(
                           r'^addSkillsToAccount/',
                           'wwf.views.addSkillsToAccount'
                       ),
                       url(
                           r'^removeSkillFromAccount/',
                           'wwf.views.removeSkillFromAccount'
                       ),
                       url(
                           r'^postJob/',
                           'wwf.views.postJob'
                       ),
                       url(
                           r'^deleteJob/',
                           'wwf.views.deleteJob'
                       ),
                       url(
                           r'^takeJob/',
                           'wwf.views.takeJob'
                       ),
                       url(
                           r'^completeJob/',
                           'wwf.views.completeJob'
                       ),
                       url(
                           r'^viewFriendProfile/',
                           'wwf.views.viewFriendProfile'
                       ),
                       url(
                           r'^getPostedJobs/',
                           'wwf.views.getPostedJobs'
                       ),
                       url(
                           r'^getFriends',
                           'wwf.views.getFriends'
                       ),
                       url(
                           r'getNewsfeed',
                           'wwf.views.getNewsfeed'
                       ),
                       url(
                           r'viewJob',
                           'wwf.views.viewJob'
                       )

)

