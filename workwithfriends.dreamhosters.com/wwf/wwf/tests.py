from django.test import TestCase
from models import *
from views import *
from django.test.client import RequestFactory
import json



TEST_USER_ID = '524156482'
TEST_ACCESS_TOKEN = 'CAAIv2leQPu8BAOQaRlX07Wke8ZAH9I8ObCsjWjWOlU2cHiikoAXFtFmABlcN6fcO0T0QdwZCZCl0TfRmq7CkdWFAj65H351h94KUl1LLfNPduzc062WLNgefz0LRVylno6BuGoZAOY0nzXZCZCTvZA6R0idty24P1PG6jtyDBFWtyhIDZAJBNlbXKMjmfQ8vcNsZD'

TEST_ACCESS_TOKEN_2 = \
    'CAAIv2leQPu8BADSbOjjKyLM0pkNtUPQjgzYUaLNwONMj4Xdsb3qLID4Ns65W8SB8KnX3GsqlXqxY8gQRZA3XBImZAO66KaW2wJKefG7zQEdJcoH0TKcFmtzRckcAYjTrrq4hMhuMI8THkntVPYawmXz4Y4YfZAYoNfYuzL3ZAdRL3XZB0LuA8tWZBs99qsaZCUZD'
TEST_USER_ID_2 = '865085528'
TEST_SKILLS = [{'skill': 'writer', 'strength': '5'},
               {'skill': 'photographer', 'strength': '8'}]
TEST_JOB = {"type": "photography", "skills": ["photography", "writer"],
            "description": "An easy job", "compensation": "dope herb",
            'lat': 0.0, 'long': 0.0}


def responseIsSuccess(response):
    obj = getResponseObject(response)
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
                                         'firstName', 'lastName', 'skills',
                                         'jobs']))
        self.assertTrue(responseIsSuccess(response), str(response))

    def testAddSkillsToAccount(self):
        response = self.addSkillsToAccount()
        data = getResponseObject(response)['data']
        self.assertTrue(hasFields(data, ['skills', ]))
        self.assertEqual(len(TEST_SKILLS),
                         len(UserSkill.objects.filter(account=self.account)))
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
        self.assertTrue(hasFields(data, ['skills', ]))
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
        self.assertTrue(
            PostedJob.objects.filter(employer=self.account).exists())
        jobId = PostedJob.objects.get(employer=self.account).pk
        request = self.factory.post('/deleteJob',
                                    {'accessToken': TEST_ACCESS_TOKEN,
                                     'userId': TEST_USER_ID,
                                     'jobId': jobId})
        response = deleteJob(request)
        self.assertTrue(responseIsSuccess(response), response)
        self.assertTrue(
            not PostedJob.objects.filter(employer=self.account).exists())


    def testTakeJob(self):
        request = self.factory.post('/loginWithFacebook',
                                    {'accessToken': TEST_ACCESS_TOKEN_2,
                                     'userId': TEST_USER_ID_2
                                    }
        )
        loginWithFacebook(request)
        secondAccount = Account.objects.get(userId=TEST_USER_ID_2)
        postedJobResponse = self.postJob()
        self.assertTrue(
            PostedJob.objects.filter(employer=self.account).exists())
        jobId = PostedJob.objects.get(employer=self.account).pk
        request = self.factory.post('takeJob',
                                    {'accessToken': TEST_ACCESS_TOKEN_2,
                                     'userId': TEST_USER_ID_2,
                                     'jobId': jobId,
                                     'employerId': TEST_USER_ID})
        response = takeJob(request)
        self.assertTrue(CurrentJob.objects.filter(employer=self.account,
                                                  employee=secondAccount).exists())
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
                                     'friendId': TEST_USER_ID_2, })
        response = viewFriendProfile(request)
        data = getResponseObject(response)['data']
        self.assertTrue(
            hasFields(data, ['friendIsRegisteredUser', 'friendProfileImageUrl',
                             'friendLastName', 'friendFirstName',
                             'friendSkills',
                             'friendJobs', ]))
        self.assertTrue(responseIsSuccess(response), response)
