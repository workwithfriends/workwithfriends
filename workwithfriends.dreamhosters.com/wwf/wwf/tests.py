from django.test import TestCase
from models import *
from views import *
from django.test.client import RequestFactory
import json


TEST_ACCESS_TOKEN = 'CAAIv2leQPu8BAExhbFqZB4neiPCaoALM4OprByaKUGKhpfTNOQ5FG9vSZAxgKPfuxGL4HMjkH11QPfvfLqa1ZCyvdj3tSs8Oa9kgUmg0NZCIB1jAcuUl2uZALXiEo4VxzogxAypfhoYJir9tkhZAfPFe2tn4uQ6aUO3LNGoAt7trZClkv8c2EnASThjhuRXBy6owZBevVr32JAZDZD'
TEST_USER_ID = '570053410'
TEST_SKILLS = ['writer', 'photographer']

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

    def tearDown(self):
        pass

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
        self.assertTrue(responseIsSuccess(response))

    '''
    def testAddSkillsToAccount(self):
        request = self.factory.post('/addSkillsToAccount',
                                    {'accessToken': TEST_ACCESS_TOKEN,
                                     'userId': TEST_USER_ID,
                                     'skills': TEST_SKILLS,
                                     }
                                    )
        response = addSkillsToAccount(request)
        self.assertTrue(responseIsSuccess(response))

        
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
