import sys, os
cwd = os.getcwd()
sys.path.append(cwd)
sys.path.append(cwd + '/wwf')  #You must add your project here or 500

#Switch to new python
#You may try to replace $HOME with your actual path
if sys.version < "2.7.3": os.execl("/home/workwithfriends.dreamhosters.com/Python27/bin/python",
                                   "python2.7.3", *sys.argv)

sys.path.insert(0,'/home/workwithfriends.dreamhosters.com/Python27/bin/')
sys.path.insert(0,'/home/workwithfriends.dreamhosters.com/Python27/lib/python2.7/site-packages/django')
sys.path.insert(0,'/home/workwithfriends.dreamhosters.com/Python27/lib/python2.7/site-packages')

os.environ['DJANGO_SETTINGS_MODULE'] = "project.settings"
import django.core.handlers.wsgi
application = django.core.handlers.wsgi.WSGIHandler()
