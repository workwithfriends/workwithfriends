from django.test import TestCase
from models import *
from views import *
from django.test.client import RequestFactory

TEST_ACCESS_TOKEN = 'CAAIv2leQPu8BAExhbFqZB4neiPCaoALM4OprByaKUGKhpfTNOQ5FG9vSZAxgKPfuxGL4HMjkH11QPfvfLqa1ZCyvdj3tSs8Oa9kgUmg0NZCIB1jAcuUl2uZALXiEo4VxzogxAypfhoYJir9tkhZAfPFe2tn4uQ6aUO3LNGoAt7trZClkv8c2EnASThjhuRXBy6owZBevVr32JAZDZD'
TEST_USER_ID = '570053410'

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

