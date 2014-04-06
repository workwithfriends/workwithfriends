from django.test import TestCase
from models import *
from views import *
from django.test.client import RequestFactory
import json



TEST_ACCESS_TOKEN = 'CAAIv2leQPu8BAFyN4zTugRZCOKP0ZC5fcacbx5ZBi6UCsbq4KxNRI50stCtmtgGycQZAh2MheVpPIUfdTVFfOYIP9Ojmvyp9deCpvZBVbZBkKkBdBNbMLvsGL3ozz6R2uHmTY6aWxys3ZCtl78bdlOo1Twq0CKuE1ZBZB58mCihFz3GM1IL3uyNZA0U1XGvd6HLPEZD'
TEST_USER_ID = '570053410'
TEST_ACCESS_TOKEN_2 = 'CAAIv2leQPu8BANQsRYuyUeFceNKuJw3wgw6AsMUh5Uhv7LlYOUvdavrDGWNtSpFmpALBcynKx2yfS09rGr2qEc8ZB6C6biuZBLgXw6CRyu8icKVb9eKijgynll7CFQw4NjGY8JBMPhDYEAdR4gN1wnJ7UpY6oC1Fy2FBaqF73v1PHlksF8v5P7ZCMxVe5sZD'
TEST_USER_ID_2 = '524156482'
TEST_SKILLS = [{'skill': 'writer', 'strength': '5'}, {'skill': 'photographer', 'strength': '8'}]
TEST_JOB = {"type": "photography", "skills": ["photography", "writer"],
            "description": "An easy job", "compensation": "dope herb"}


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
        self.loginWithFacebook()
        self.account = Account.objects.get(userId=TEST_USER_ID)

    def tearDown(self):
        pass

    def loginWithFacebook(self):
        request = self.factory.post('/loginWithFacebook',
                                    {'accessToken': TEST_ACCESS_TOKEN,
                                     'userId': TEST_USER_ID
                                     }
                                    )
        return loginWithFacebook(request)        
    
    def addSkillsToAccount(self):
        request = self.factory.post('/addSkillsToAccount',
                                    {'accessToken': TEST_ACCESS_TOKEN,
                                     'userId': TEST_USER_ID,
                                     'skills': json.dumps(TEST_SKILLS),
                                     }
                                    )
        return addSkillsToAccount(request)

    def postJob(self):
        request = self.factory.post('/postJob',
                                    {'accessToken': TEST_ACCESS_TOKEN,
                                     'userId': TEST_USER_ID,
                                     'job': json.dumps(TEST_JOB)})
        return postJob(request)

    def testLoginWithFacebook(self):
        response = self.loginWithFacebook()
        data = getResponseObject(response)['data']
        self.assertTrue(Account.objects.filter(userId=TEST_USER_ID).exists())
        self.assertTrue(hasFields(data, ['isNewUser', 'profileImageUrl',
                                         'name', 'skills', 'jobs']))
        self.assertTrue(responseIsSuccess(response), str(response))

    def testAddSkillsToAccount(self):
        response = self.addSkillsToAccount()
        data = getResponseObject(response)['data']
        self.assertTrue(hasFields(data, ['skills',]))
        self.assertEqual(len(TEST_SKILLS), len(UserSkill.objects.filter(account=self.account)))
        self.assertTrue(responseIsSuccess(response), str(response))

    def testRemoveSkillFromAccount(self):
        self.addSkillsToAccount()
        skillToRemove = "photographer"
        #Make sure skill is there before we remove it.
        self.assertTrue(UserSkill.objects.filter(account=self.account,
                                                 skill=skillToRemove).exists())
        request = self.factory.post('/removeSkillsFromAccount',
                                    {'accessToken': TEST_ACCESS_TOKEN,
                                     'userId': TEST_USER_ID,
                                     'skill': skillToRemove
                                     }
                                    )
        response = removeSkillFromAccount(request)
        data = getResponseObject(response)['data']
        self.assertTrue(not UserSkill.objects.filter(account=self.account,
                                                 skill=skillToRemove).exists())
        self.assertTrue(hasFields(data, ['skills',]))
        self.assertTrue(responseIsSuccess(response))

    def testPostJob(self):
        response = self.postJob()
        data = getResponseObject(response)['data']
        self.assertTrue(hasFields(data, ['postedJobs']))
        self.assertTrue(PostedJob.objects.filter
                        (employer=self.account,
                         jobType=TEST_JOB['type'],
                         jobDescription=TEST_JOB['description'],
                         jobCompensation=TEST_JOB['compensation']).exists())
        self.assertTrue(responseIsSuccess(response), response)
        

    def testDeleteJob(self):
        postedJobResponse = self.postJob()
        self.assertTrue(PostedJob.objects.filter(employer=self.account).exists())
        jobId = PostedJob.objects.get(employer=self.account).pk
        request = self.factory.post('/deleteJob',
                               {'accessToken': TEST_ACCESS_TOKEN,
                                'userId': TEST_USER_ID,
                                'jobId': jobId})
        response = deleteJob(request)
        self.assertTrue(responseIsSuccess(response), response)
        self.assertTrue(not PostedJob.objects.filter(employer=self.account).exists())


    def testTakeJob(self):
        request = self.factory.post('/loginWithFacebook',
                                    {'accessToken': TEST_ACCESS_TOKEN_2,
                                     'userId': TEST_USER_ID_2
                                     }
                                    )
        loginWithFacebook(request)
        secondAccount = Account.objects.get(userId=TEST_USER_ID_2)
        postedJobResponse = self.postJob()
        self.assertTrue(PostedJob.objects.filter(employer=self.account).exists())
        jobId = PostedJob.objects.get(employer=self.account).pk
        request = self.factory.post('takeJob',
                                    {'accessToken': TEST_ACCESS_TOKEN_2,
                                     'userId': TEST_USER_ID_2,
                                     'jobId': jobId,
                                     'employerId': TEST_USER_ID})
        response = takeJob(request)
        self.assertTrue(CurrentJob.objects.filter(employer=self.account, employee=secondAccount).exists())
        self.assertTrue(responseIsSuccess(response), response)

    def testViewFriendProfile(self):
        request = self.factory.post('/loginWithFacebook',
                                    {'accessToken': TEST_ACCESS_TOKEN_2,
                                     'userId': TEST_USER_ID_2
                                     }
                                    )
        loginWithFacebook(request)
        request = self.factory.post('/viewFriendProfile',
                                    {'accessToken': TEST_ACCESS_TOKEN,
                                     'userId': TEST_USER_ID,
                                     'friendId': TEST_USER_ID_2,})
        response = viewFriendProfile(request)
        data = getResponseObject(response)['data']
        self.assertTrue(hasFields(data, ['friendIsRegisteredUser', 'friendProfileImageUrl',
                                         'friendName', 'friendSkills',
                                         'friendJobs',]))
        self.assertTrue(responseIsSuccess(response), response)
