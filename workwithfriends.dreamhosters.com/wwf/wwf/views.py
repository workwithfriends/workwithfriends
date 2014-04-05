from django.http import HttpResponse
from django.forms.util import ValidationError
from open_facebook.api import FacebookAuthorization, OpenFacebook
from django_facebook.auth_backends import FacebookBackend

def test(request):
    FBToken = FacebookAuthorization.get_app_access_token()
    testUser = FacebookAuthorization.create_test_user(app_access_token=FBToken, permissions=None, name="Demitri Nava")

    userToken = 'CAAIv2leQPu8BAFMxvckmf85fNERpggwbXD85HKAcgqlZCnIbLvlevPhsAEnPKxZC29EP5inZBk5ZB7yX6AE746tOTB3w0tmB3Bc3ta7BytSY5z5ZAcV2hQb4TRnnjjQanbTqCOOrtud5SQCyqqh4IeOB6ZAEWpSE8M9q1PWQOXRTZCeA4mprX45kCLgHY6lVQ4ZD'
    
    
    userInfo = {
        'me' : testUser.graph().me(),
        'id': testUser.graph().me()['id'],

        }
    
    graph = OpenFacebook(access_token=userToken, current_user_id=userInfo['id'])
    
    return HttpResponse(str(graph.permissions()))
