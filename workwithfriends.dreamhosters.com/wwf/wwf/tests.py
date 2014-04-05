from django.test import TestCase
from models import *
from views import *
from django.test.client import RequestFactory

TEST_ACCESS_TOKEN = ''
TEST_USER_ID = ''

def responseIsSuccess(response):
    lenToRemove = len('Content-Type: application/json')
    obj = json.loads(str(response)[lenToRemove:])
    return not obj['isError']

class testAllRequests(TestCase):
    def setUp(self):
        factory = RequestFactory()

    def tearDown(self):
        pass

    def testLoginWithFacebook(self):
        request = self.factory.post('/loginWithFacebook',
                                    {'accessToken': TEST_ACCESS_TOKEN,
                                     'userId': TEST_USER_ID
                                     }
                                    )
        response = loginWithFacebook(request)
        self.assertTrue(responseIsSuccess(response))

