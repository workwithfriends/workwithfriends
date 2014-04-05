from django.test import TestCase
from models import *
from views import *
from django.test.client import RequestFactory
import json


TEST_ACCESS_TOKEN = 'CAAIv2leQPu8BAFLI8z6ZAiujA7kUEe5DyRcxqKKRW5Oi4AFziZCBD2LOn9CQtHZBGmKMGVqtpDKAmsUPnZBkTp9awzXOZBO6ChZCKQvvYuVQjI68C7ngKiQ3RHe6XTAwyK2yZBKp2yEopdjJG9aNXwOJwzei99HyBYDhWITaQEHWCFe4n3xaN4TsRcOBqLUkKU22rY8ccXNcgZDZD'
TEST_USER_ID = '570053410'
TEST_SKILLS = [{'skill': 'writer', 'strength': '5'}, {'skill': 'photographer', 'strength': '8'}]

def responseIsSuccess(response):
    lenToRemove = len('Content-Type: application/json')
    obj = json.loads(str(response)[lenToRemove:])
    return not obj['isError']

def getResponseObject(response):
    lenToRemove = len('Content-Type: application/json')
    obj = str(response)[lenToRemove:]
    return json.loads(obj)

def hasFields(data, fields):
    for field in fields:
        if not field in data:
            return False
    return True
    

class testAllRequests(TestCase):
    def setUp(self):
        self.factory = RequestFactory()
        self.loginToFacebook()

    def tearDown(self):
        pass

    def loginToFacebook(self):
        request = self.factory.post('/loginWithFacebook',
                                    {'accessToken': TEST_ACCESS_TOKEN,
                                     'userId': TEST_USER_ID
                                     }
                                    )
        response = loginWithFacebook(request)        

    def testLoginWithFacebook(self):
        request = self.factory.post('/loginWithFacebook',
                                    {'accessToken': TEST_ACCESS_TOKEN,
                                     'userId': TEST_USER_ID
                                     }
                                    )
        response = loginWithFacebook(request)
        data = getResponseObject(response)['data']
        self.assertTrue(Account.objects.filter(userId=TEST_USER_ID).exists())
        self.assertTrue(hasFields(data, ['isNewUser', 'profileImageUrl',
                                         'name', 'skills', 'jobs']))
        self.assertTrue(responseIsSuccess(response), str(response))

    def testAddSkillsToAccount(self):
        request = self.factory.post('/addSkillsToAccount',
                                    {'accessToken': TEST_ACCESS_TOKEN,
                                     'userId': TEST_USER_ID,
                                     'skills': TEST_SKILLS,
                                     }
                                    )
        response = addSkillsToAccount(request)
        self.assertTrue(responseIsSuccess(response), str(response))

        '''
    def removeSkillsFromAccount(self):
        request = self.factory.post('/removeSkillsFromAccount',
                                    {'accessToken': TEST_ACCESS_TOKEN,
                                     'userId': TEST_USER_ID,
                                     'skills': TEST_SKILLS,
                                     }
                                    )
        response = removeSkillsFromAccount(request)
        self.assertTrue(responseIsSuccess(response))
        '''
