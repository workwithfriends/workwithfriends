from django.http import HttpResponse

from models import Account, ProfileImage, PostedJob, CurrentJob, CompletedJob, UserSkill, PostedJobSkill, \
    CurrentJobSkill, CompletedJobSkill

from django.forms.util import ValidationError
from open_facebook.api import FacebookAuthorization, OpenFacebook
from django_facebook.auth_backends import FacebookBackend

import json

FBAuth = FacebookAuthorization
FBOpen = OpenFacebook

APP_ACCESS_TOKEN = FBAuth.get_app_access_token()


def verifyRequest(request, requiredFields):
    params = request.POST
    isMissingFields = False
    missingFields = []
    errorMessage = None
    for field in requiredFields:
        if not field in params:
            isMissingFields = True
            missingFields.append(field)

    if isMissingFields:
        errorMessage = 'Request is missing: ' + str(missingFields)

    return {
        'isMissingFields': isMissingFields,
        'errorMessage': errorMessage
    }


def formattedResponse(isError=False, errorMessage=None, data=None):
    '''
    Returns a properly formatted response for our API.
    :param isError: Whether or not there was an error.
    :param errorMessage: A human readable error message.
    :param data: The appropriate data if the response
    '''

    response = {
        'isError': isError,
        'errorMessage': errorMessage,
        'data': data,
    }
    return HttpResponse(json.dumps(response), content_type="application/json")


'''
formatJobs:
    Helper method to format a database model
    of jobs to a regular python list of jobs
'''


def formatJobs(jobs, hasEmployee=False):
    formattedJobs = None

    if jobs is not None:
        formattedJobs = []
        for job in jobs:
            formattedJob = {
                'employerId': str(job.employer.userId),
                'employerName': str(job.employer.name),
                'type': str(job.jobType),
                'description': str(job.jobDescription),
                'compensation': str(job.jobCompensation),
                'jobId': str(job.pk)
            }

            if hasEmployee:
                formattedJob['employeeId'] = str(job.employee.userId)
                formattedJob['employeeName'] = str(job.employee.name)

            formattedJobs.append(formattedJob)

    return formattedJobs


'''
formatSkills:
    Helper method to format a database model
    of skills to a regular python list of skills
'''


def formatSkills(skills, hasStrength=False):
    formattedSkills = None

    if skills is not None:
        formattedSkills = []
        for skill in skills:
            formattedSkill = {
                'skill': str(skill.skill)
            }

            if hasStrength:
                formattedSkill['strength'] = str(skill.strength)

            formattedSkills.append(formattedSkill)

    return formattedSkills


def loginWithFacebook(request):
    '''
    Required fields:

        accessToken
        userId
        
    '''
    requiredFields = ['accessToken', 'userId']

    verifiedRequestResponse = verifyRequest(request, requiredFields)
    if verifiedRequestResponse['isMissingFields']:
        errorMessage = verifiedRequestResponse['errorMessage']
        return formattedResponse(isError=True, errorMessage=errorMessage)

    request = request.POST

    accessToken = request['accessToken']
    userId = request['userId']

    account, isAccountCreated = Account.objects.get_or_create(userId=userId)

    # if new user
    if (isAccountCreated):
        try:
            graph = FBOpen(access_token=accessToken, current_user_id=userId)

            userInfo = graph.get('me', fields='name, picture')

            name = userInfo['name']
            profileImageUrl = userInfo['picture']['data']['url']
            skills = None
            jobs = None

            account.name = name
            account.save()
            ProfileImage.objects.get_or_create(account=account,
                                               profileImageUrl=profileImageUrl)
        except:
            errorMessage = 'Bad access token'
            return formattedResponse(isError=True, errorMessage=errorMessage)

    # if returning user
    else:
        name = account.name
        profileImageUrl = str(ProfileImage.objects.get(account=account).profileImageUrl)

        # get jobs
        postedJobs = None if not PostedJob.objects.filter(employer=account).exists() else \
            formatJobs(
                PostedJob.objects.filter(
                    employer=account)
            )

        currentJobsAsEmployee = None if not CurrentJob.objects.filter(employee=account).exists() else \
            formatJobs(
                CurrentJob.objects.filter(employee=account),
                hasEmployee=True
            )

        currentJobsAsEmployer = None if not CurrentJob.objects.filter(employer=account).exists() else \
            formatJobs(
                CurrentJob.objects.filter(employer=account),
                hasEmployee=True
            )

        completedJobs = None if not CompletedJob.objects.filter(employee=account).exists() else \
            formatJobs(
                CompletedJob.objects.filter(employee=account),
                hasEmployee=True
            )

        jobs = {
            'postedJobs': postedJobs,
            'currentJobsAsEmployee': currentJobsAsEmployee,
            'currentJobsAsEmployer': currentJobsAsEmployer,
            'completedJobs': completedJobs
        }

        # get skills
        skills = None if not UserSkill.objects.filter(account=account).exists() else formatSkills(
            UserSkill.objects.get(account=account), hasStrength=True)

    data = {
        'isNewUser': isAccountCreated,
        'profileImageUrl': profileImageUrl,
        'name': name,
        'skills': skills,
        'jobs': jobs
    }

    return formattedResponse(data=data)


'''
addSkillToAccount:

    Helper method for addSkillsToAccount
'''


def addSkillToAccount(skill, account):
    accountSkill, isCreated = UserSkill.objects.get_or_create(account=account, skill=skill['skill'])
    accountSkill.strength = skill['strength']

    accountSkill.save()


def addSkillsToAccount(request):
    '''
    Required fields:

        accessToken
        userId
        skills

    '''
    requiredFields = ['accessToken', 'userId', 'skills']

    verifiedRequestResponse = verifyRequest(request, requiredFields)
    if verifiedRequestResponse['isMissingFields']:
        errorMessage = verifiedRequestResponse['errorMessage']
        return formattedResponse(isError=True, errorMessage=errorMessage)

    request = request.POST

    userId = request['userId']
    skills = json.loads(request['skills'])

    if Account.objects.filter(userId=userId).exists():
        account = Account.objects.get(userId=userId)

        for skill in skills:
            addSkillToAccount(skill, account)
    else:
        return formattedResponse(isError=True, errorMessage='Unknown user')

    data = {
        'skills': formatSkills(UserSkill.objects.filter(account=account), hasStrength=True)
    }
    return formattedResponse(data=data)


def removeSkillFromAccount(request):
    '''
    Required fields:

        accessToken
        userId
        skill

    '''
    requiredFields = ['accessToken', 'userId', 'skill']

    verifiedRequestResponse = verifyRequest(request, requiredFields)
    if verifiedRequestResponse['isMissingFields']:
        errorMessage = verifiedRequestResponse['errorMessage']
        return formattedResponse(isError=True, errorMessage=errorMessage)

    request = request.POST

    userId = request['userId']
    skill = request['skill']

    if Account.objects.filter(userId=userId).exists():
        account = Account.objects.get(userId=userId)

        if UserSkill.objects.filter(account=account, skill=skill).exists():
            UserSkill.objects.get(account=account, skill=skill).delete()
    else:
        return formattedResponse(isError=True, errorMessage='Unknown user')

    data = {
        'skills': formatSkills(UserSkill.objects.filter(account=account), hasStrength=True)
    }
    return formattedResponse(data=data)


def postJob(request):
    '''
    Required fields:

        accessToken
        userId
        job
    '''
    requiredFields = ['accessToken', 'userId', 'job']

    verifiedRequestResponse = verifyRequest(request, requiredFields)
    if verifiedRequestResponse['isMissingFields']:
        errorMessage = verifiedRequestResponse['errorMessage']
        return formattedResponse(isError=True, errorMessage=errorMessage)

    request = request.POST

    userId = request['userId']
    job = json.loads(request['job'])

    if Account.objects.filter(userId=userId).exists():
        account = Account.objects.get(userId=userId)

        jobType = job['type']
        jobSkills = job['skills']
        jobDescription = job['description']
        jobCompensation = job['compensation']

        postedJob, isPostedJobCreated = PostedJob.objects.get_or_create(
            employer=account,
            jobType=jobType,
            jobDescription=jobDescription,
            jobCompensation=jobCompensation
        )

        if isPostedJobCreated:
            for skill in jobSkills:
                postedJobSkill, isPostedJobSkillCreated = PostedJobSkill.objects.get_or_create(job=postedJob,
                                                                                               skill=skill)

            postedJobs = formatJobs(
                PostedJob.objects.filter(employer=account)
            )

        else:
            errorMessage = 'Job already exists'
            return formattedResponse(isError=True, errorMessage=errorMessage)
    else:
        errorMessage = 'Unknown user'
        return formattedResponse(isError=True, errorMessage=errorMessage)

    data = {
        'postedJobs': postedJobs
    }
    return formattedResponse(data=data)


def deleteJob(request):
    '''
    Required fields:

        accessToken
        userId
        jobId
    '''
    requiredFields = ['accessToken', 'userId', 'jobId']

    # verify request
    verifiedRequestResponse = verifyRequest(request, requiredFields)
    if verifiedRequestResponse['isMissingFields']:
        errorMessage = verifiedRequestResponse['errorMessage']
        return formattedResponse(isError=True, errorMessage=errorMessage)

    request = request.POST

    userId = request['userId']
    jobId = request['jobId']

    if Account.objects.filter(userId=userId).exists():
        account = Account.objects.get(userId=userId)

        if PostedJob.objects.filter(pk=jobId, employer=account).exists():
            # if job exists with account and id, delete it
            jobToDelete = PostedJob.objects.get(pk=jobId, employer=account)
            jobToDelete.delete()

            postedJobs = formatJobs(
                PostedJob.objects.filter(employer=account)
            )

        else:
            errorMessage = 'Unknown job'
            return formattedResponse(isError=True, errorMessage=errorMessage)
    else:
        errorMessage = 'Unknown user'
        return formattedResponse(isError=True, errorMessage=errorMessage)

    data = {
        'postedJobs': postedJobs
    }

    return formattedResponse(data=data)


def takeJob(request):
    '''
    Required fields:

        accessToken
        userId
        jobId
        employerId
    '''
    requiredFields = ['accessToken', 'userId', 'jobId', 'employerId']

    # verify request
    verifiedRequestResponse = verifyRequest(request, requiredFields)
    if verifiedRequestResponse['isMissingFields']:
        errorMessage = verifiedRequestResponse['errorMessage']
        return formattedResponse(isError=True, errorMessage=errorMessage)

    request = request.POST

    userId = request['userId']
    jobId = request['jobId']
    employerId = request['employerId']

    if userId != employerId:
        if Account.objects.filter(userId=userId).exists():
            if Account.objects.filter(userId=employerId).exists():
                employee = Account.objects.get(userId=userId)
                employer = Account.objects.get(userId=employerId)

                if PostedJob.objects.filter(pk=jobId, employer=employer).exists():
                    jobToTake = PostedJob.objects.get(pk=jobId, employer=employer)

                    jobType = str(jobToTake.jobType)
                    jobDescription = str(jobToTake.jobDescription)
                    jobCompensation = str(jobToTake.jobCompensation)

                    newCurrentJob, newCurrentJobIsCreated = CurrentJob.objects.get_or_create(
                        employee=employee,
                        employer=employer,
                        jobType=jobType,
                        jobDescription=jobDescription,
                        jobCompensation=jobCompensation
                    )

                    if newCurrentJobIsCreated:
                        jobToTake.delete()

                        currentJobsAsEmployee = formatJobs(
                            CurrentJob.objects.filter(employee=employee),
                            hasEmployee=True
                        )

                    else:
                        errorMessage = 'Failed to take job'
                        return formattedResponse(isError=True, errorMessage=errorMessage)
            else:
                errorMessage = 'Unknown employer'
                return formattedResponse(isError=True, errorMessage=errorMessage)
        else:
            errorMessage = 'Unknown user'
            return formattedResponse(isError=True, errorMessage=errorMessage)
    else:
        errorMessage = 'userId and employerId are the same'
        return formattedResponse(isError=True, errorMessage=errorMessage)

    data = {
        'currentJobsAsEmployee': currentJobsAsEmployee
    }
    return formattedResponse(data=data)


def viewFriendProfile(request):
    '''
    Required fields:

        accessToken
        userId
        friendId
    '''
    requiredFields = ['accessToken', 'userId', 'friendId']

    # verify request
    verifiedRequestResponse = verifyRequest(request, requiredFields)
    if verifiedRequestResponse['isMissingFields']:
        errorMessage = verifiedRequestResponse['errorMessage']
        return formattedResponse(isError=True, errorMessage=errorMessage)

    request = request.POST

    userId = request['userId']
    friendId = request['friendId']

    if Account.objects.filter(userId=userId).exists():
        friendIsRegisteredUser = Account.objects.filter(userId=friendId).exists()
        if friendIsRegisteredUser:
            friend = Account.objects.get(userId=friendId)

            friendName = friend.name
            friendProfileImage = str(ProfileImage.objects.get(account=friend))

            friendSkills = formatSkills(
                UserSkill.objects.filter(account=friend),
                hasStrength=True
            )

            friendPostedJobs = formatJobs(
                PostedJob.objects.filter(employer=friend)
            )

            friendCurrentJobsAsEmployee = formatJobs(
                CurrentJob.objects.filter(employee=friend),
                hasEmployee=True
            )
            friendCurrentJobsAsEmployer = formatJobs(
                CurrentJob.objects.filter(employer=friend),
                hasEmployee=True
            )

            friendCompletedJobsAsEmployee = formatJobs(
                CompletedJob.objects.filter(employee=friend),
                hasEmployee=True
            )
            friendCompletedJobsAsEmployer = formatJobs(
                CompletedJob.objects.filter(employer=friend),
                hasEmployee=True
            )

        else:
            # TODO: Add logic for a friend who has not used Work With Friends
            errorMessage = 'Unknown friend'
            return formattedResponse(isError=True, errorMessage=errorMessage)
    else:
        errorMessage = 'Unknown user'
        return formattedResponse(isError=True, errorMessage=errorMessage)

    data = {
        'friendIsRegisteredUser': friendIsRegisteredUser,
        'friendProfileImageUrl': friendProfileImage,
        'friendSkills': friendSkills,
        'friendName': friendName,
        'friendJobs': {
            'postedJobs': friendPostedJobs,
            'currentJobsAsEmployee': friendCurrentJobsAsEmployee,
            'currentJobsAsEmployer': friendCurrentJobsAsEmployer,
            'completedJobsAsEmployee': friendCurrentJobsAsEmployee,
            'completedJobsAsEmployer': friendCompletedJobsAsEmployer,
        }
    }

    return formattedResponse(data=data)


def completeJob(request):
    '''
    Required fields:

        accessToken
        userId
        jobId
    '''
    requiredFields = ['accessToken', 'userId', 'jobId']

    # verify request
    verifiedRequestResponse = verifyRequest(request, requiredFields)
    if verifiedRequestResponse['isMissingFields']:
        errorMessage = verifiedRequestResponse['errorMessage']
        return formattedResponse(isError=True, errorMessage=errorMessage)

    request = request.POST
    userId = request['userId']
    jobId = request['jobId']

    if Account.objects.filter(userId=userId).exists():
        employer = Account.objects.get(userId=userId)

        if CurrentJob.objects.filter(pk=jobId, employer=employer).exists():
            jobToComplete = CurrentJob.objects.get(pk=jobId, employer=employer)

            employee = jobToComplete.employee
            jobType = str(jobToComplete.jobType)
            jobDescription = str(jobToComplete.jobDescription)
            jobCompensation = str(jobToComplete.jobCompenstation)

            newCompletedJob, newCompletedJobIsCreated = CompletedJob.objects.get_or_create(
                employer=employer,
                employee=employee,
                jobType=jobType,
                jobDescription=jobDescription,
                jobCompensation=jobCompensation
            )

            if newCompletedJobIsCreated:
                jobToComplete.delete()

                currentJobsAsEmployer = formatJobs(
                    CurrentJob.objects.filter(employer=employer),
                    hasEmployee=True
                )
                completedJobsAsEmployer = formatJobs(
                    CompletedJob.objects.filter(employer=employer),
                    hasEmployee=True
                )

            else:
                errorMessage = 'Failed to complete job'
                return formattedResponse(isError=True, errorMessage=errorMessage)
        else:
            errorMessage = 'Unknown job'
            return formattedResponse(isError=True, errorMessage=errorMessage)
    else:
        errorMessage = 'Unknown user'
        return formattedResponse(isError=True, errorMessage=errorMessage)

    data = {
        'currentJobsAsEmployer': currentJobsAsEmployer,
        'completedJobsAsEmployer': completedJobsAsEmployer
    }

    return formattedResponse(data=data)
    
def getPostedJobs(request):
    '''
    Required fields:

        accessToken
        userId
    '''
    requiredFields = ['accessToken', 'userId',]

    # verify request
    verifiedRequestResponse = verifyRequest(request, requiredFields)
    if verifiedRequestResponse['isMissingFields']:
        errorMessage = verifiedRequestResponse['errorMessage']
        return formattedResponse(isError=True, errorMessage=errorMessage)

    request = request.POST
    userId = request['userId']
    accessToken = request['accessToken']

    graph = FBOpen(access_token=accessToken, current_user_id=userId)
    allValidFriends = {}
    friendsDegreeOne = graph.get('me/friends')
    for friend in friendsDegreeOne:
        if (Account.objects.filter(userId=friend['id']).exists()):
            allValidFriends[friend['id']] = friend['name']
    for person in allValidFriends:
        friends = graph.get(person + '/friends')
        for friend in friends:
            if (Account.objects.filter(userId=friend['id']).exists()):
                allValidFriends[friend['id']] = friend['name']
    postedJobs = PostedJob.objects.all()
    validJobs = []
    for job in postedJobs:
        if job.employer.userId in allValidFriends:
            validJobs.append(job)
    validPostedJobs = formatJobs(validJobs)
    data = {'postedJobs' : validPostedJobs}
    return formattedResponse(data=data)
