from django.http import HttpResponse

from models import Account, ProfileImage, PostedJob, CurrentJob, CompletedJob, \
    UserSkill, PostedJobSkill, \
    CurrentJobSkill, CompletedJobSkill, NewsFeed

from django.forms.util import ValidationError
from open_facebook.api import FacebookAuthorization, OpenFacebook
from django_facebook.auth_backends import FacebookBackend

import json
import time

FBAuth = FacebookAuthorization
FBOpen = OpenFacebook

APP_ACCESS_TOKEN = FBAuth.get_app_access_token()

NEWSFEED_POSTED_JOB_TYPE = 'postedJob'
NEWSFEED_CURRENT_JOB_TYPE = 'currentJob'
NEWSFEED_COMPLETED_JOB_TYPE = 'completedJob'
NEWSFEED_SKILLS_UPDATE_TYPE = 'addedSkills'


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
formatJobsForNewsFeed:
    Helper method to format a database job model
    into a python dictionary for newsfeed data

    job: job database model
'''


def formatJobForNewsfeed(job, hasEmployee=False):
    formattedJob = {
        'jobId': str(job.pk),
        'type': str(job.jobType),
        'compensation': str(job.jobCompensation),
    }

    if hasEmployee:
        formattedJob['employeeFirstName'] = str(job.employee.firstName)
        formattedJob['employeeLastName'] = str(job.employee.lastName)
        formattedJob['employeeId'] = str(job.employee.userId)

    return formattedJob


def formatJob(job, hasEmployee=False):
    if not hasEmployee:
        skills = PostedJobSkill.objects.filter(job=job)
    else:
        skills = CurrentJobSkill.objects.filter(job=job) if \
            CurrentJobSkill.objects.filter(job=job).exists() else \
            CompletedJobSkill.objects.filter(job=job)

    formattedJob = {
        'employerId': str(job.employer.userId),
        'employerFirstName': str(job.employer.firstName),
        'employerLastName': str(job.employer.lastName),
        'employerProfileImageUrl': str(
            ProfileImage
            .objects
            .get(
                account=job.employer
            )
            .profileImageUrl),
        'type': str(job.jobType),
        'description': str(job.jobDescription),
        'compensation': str(job.jobCompensation),
        'jobId': str(job.pk),
        'time': str(job.timeCreated),
        'lat': float(job.lat),
        'long': float(job.long),
        'skills': formatSkills(skills)
    }

    if hasEmployee:
        formattedJob['employeeId'] = str(job.employee.userId)
        formattedJob['employeeFirstName'] = str(job.employee.firstName)
        formattedJob['employeeLastName'] = str(job.employee.lastName)
        formattedJob['employeeProfileImageUrl'] = str(
            ProfileImage
            .objects
            .get(
                account=job.employee
            )
            .profileImageUrl)

    return formattedJob


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
            formattedJob = formatJob(job, hasEmployee=hasEmployee)
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


'''
getUserModel:
    Helper method that gets the entire person model
    formatted into a JSON for easy message passing
'''


def getUserModel(account):
    userId = str(account.userId)
    firstName = str(account.firstName)
    lastName = str(account.lastName)
    aboutMe = str(account.aboutMe)
    profileImageUrl = str(
        ProfileImage.objects.get(account=account).profileImageUrl
    )

    # get jobs
    postedJobs = None if not PostedJob.objects.filter(
        employer=account).exists() else \
        formatJobs(
            PostedJob.objects.filter(
                employer=account)
        )

    currentJobsAsEmployee = None if not CurrentJob.objects.filter(
        employee=account).exists() else \
        formatJobs(
            CurrentJob.objects.filter(employee=account),
            hasEmployee=True
        )

    currentJobsAsEmployer = None if not CurrentJob.objects.filter(
        employer=account).exists() else \
        formatJobs(
            CurrentJob.objects.filter(employer=account),
            hasEmployee=True
        )

    completedJobs = None if not CompletedJob.objects.filter(
        employee=account).exists() else \
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
    skills = None if not UserSkill.objects.filter(
        account=account).exists() else formatSkills(
        UserSkill.objects.get(account=account), hasStrength=True)

    userModel = {
        'userId': userId,
        'profileImageUrl': profileImageUrl,
        'firstName': firstName,
        'lastName': lastName,
        'aboutMe': aboutMe,
        'skills': skills,
        'jobs': jobs
    }

    return userModel


def loginWithFacebook(request):
    '''
    Required fields:

        accessToken
        userId
        
    '''
    requiredFields = ['accessToken']

    verifiedRequestResponse = verifyRequest(request, requiredFields)
    if verifiedRequestResponse['isMissingFields']:
        errorMessage = verifiedRequestResponse['errorMessage']
        return formattedResponse(isError=True, errorMessage=errorMessage)

    request = request.POST

    accessToken = request['accessToken']

    graph = FBOpen(access_token=accessToken)

    try:
        userInfo = graph.get('me', fields='first_name, last_name, '
                                          'picture, id')
    except:
        errorMessage = 'Bad access token'
        return formattedResponse(isError=True, errorMessage=errorMessage)

    firstName = userInfo['first_name']
    lastName = userInfo['last_name']
    userId = userInfo['id']

    account, isAccountCreated = Account.objects.get_or_create(userId=userId)


    # if new user, create blank user model
    if isAccountCreated:

        profileImageUrl = userInfo['picture']['data']['url']

        aboutMe = None
        skills = None
        jobs = None
        account.firstName = firstName
        account.lastName = lastName
        account.save()
        ProfileImage.objects.get_or_create(account=account,
                                           profileImageUrl=profileImageUrl)

    # if returning user, get user model
    else:
        userModel = getUserModel(account)

        profileImageUrl = userModel['profileImageUrl']
        firstName = userModel['firstName']
        lastName = userModel['lastName']
        aboutMe = userModel['aboutMe']
        skills = userModel['skills']
        jobs = userModel['jobs']

    # get models of user's friends that have Work With Friends
    try:
        friendsWithApp = getFriendsWithAppByModel(accessToken)
    except:
        errorMessage = 'Bad access token'
        return formattedResponse(isError=True, errorMessage=errorMessage)

    userModel = {
        'userId': userId,
        'isNewUser': isAccountCreated,
        'profileImageUrl': profileImageUrl,
        'firstName': firstName,
        'lastName': lastName,
        'aboutMe': aboutMe,
        'skills': skills,
        'jobs': jobs,
        'friends': friendsWithApp
    }

    return formattedResponse(data=userModel)


def addAboutMeToAccount(request):
    '''
    Required fields:

        accessToken
        userId
        aboutMe
    '''
    requiredFields = ['accessToken', 'userId', 'aboutMe']

    verifiedRequestResponse = verifyRequest(request, requiredFields)
    if verifiedRequestResponse['isMissingFields']:
        errorMessage = verifiedRequestResponse['errorMessage']
        return formattedResponse(isError=True, errorMessage=errorMessage)

    request = request.POST

    userId = request['userId']
    aboutMe = request['aboutMe']

    if Account.objects.filter(userId=userId):
        account = Account.objects.get(userId=userId)
        account.aboutMe = aboutMe
        account.save()
    else:
        errorMessage = 'Unknown user'
        return formattedResponse(isError=True, errorMessage=errorMessage)

    userModel = getUserModel(account)

    return formattedResponse(data=userModel)


'''
addSkillToAccount:

    Helper method for addSkillsToAccount
'''


def addSkillToAccount(skill, account):
    accountSkill, isCreated = UserSkill.objects.get_or_create(account=account,
                                                              skill=skill[
                                                                  'skill'])
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

        # add skills to account
        for skill in skills:
            addSkillToAccount(skill, account)

        # push skills to newsfeed
        pushUpdateToNewsFeed(
            account=account,
            updateType=NEWSFEED_SKILLS_UPDATE_TYPE,
            updateData={
                'skillsAdded': skills
            }
        )

    else:
        return formattedResponse(isError=True, errorMessage='Unknown user')

    userSkills = {
        'skills': formatSkills(UserSkill.objects.filter(account=account),
                               hasStrength=True)
    }
    return formattedResponse(data=userSkills)


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

    userSkills = {
        'skills': formatSkills(UserSkill.objects.filter(account=account),
                               hasStrength=True)
    }
    return formattedResponse(data=userSkills)


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
        jobLat = job['lat']
        jobLong = job['long']

        postedJob, isPostedJobCreated = PostedJob.objects.get_or_create(
            employer=account,
            jobType=jobType,
            jobDescription=jobDescription,
            jobCompensation=jobCompensation,
            lat=jobLat,
            long=jobLong
        )

        if isPostedJobCreated:
            # push job to newsfeed
            pushUpdateToNewsFeed(
                account=account,
                updateType=NEWSFEED_POSTED_JOB_TYPE,
                updateData=formatJobForNewsfeed(job=postedJob)
            )

            # create skills for job
            for skill in jobSkills:
                postedJobSkill, isPostedJobSkillCreated = PostedJobSkill.objects.get_or_create(
                    job=postedJob,
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

    postedJobModel = {
        'postedJobs': postedJobs
    }
    return formattedResponse(data=postedJobModel)


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

            # delete job from news feed if it exists
            jobNewsfeedData = formatJobForNewsfeed(jobToDelete)
            if NewsFeed.objects.filter(account=account, type=NEWSFEED_POSTED_JOB_TYPE, data=jobNewsfeedData).exists():
                newsfeedItemToDelete = NewsFeed.objects.get(
                    account=account,
                    type=NEWSFEED_POSTED_JOB_TYPE,
                    data=jobNewsfeedData
                )
                newsfeedItemToDelete.delete()

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

    postedJobModel = {
        'postedJobs': postedJobs
    }

    return formattedResponse(data=postedJobModel)


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

                if PostedJob.objects.filter(pk=jobId,
                                            employer=employer).exists():
                    jobToTake = PostedJob.objects.get(pk=jobId,
                                                      employer=employer)

                    jobSkills = PostedJobSkill.objects.filter(job=jobToTake)
                    jobType = str(jobToTake.jobType)
                    jobDescription = str(jobToTake.jobDescription)
                    jobCompensation = str(jobToTake.jobCompensation)
                    jobLat = float(jobToTake.lat)
                    jobLong = float(jobToTake.long)

                    newCurrentJob, newCurrentJobIsCreated = CurrentJob.objects.get_or_create(
                        employee=employee,
                        employer=employer,
                        jobType=jobType,
                        jobDescription=jobDescription,
                        jobCompensation=jobCompensation,
                        lat=jobLat,
                        long=jobLong
                    )

                    if newCurrentJobIsCreated:

                        # push new current job to newsfeed
                        pushUpdateToNewsFeed(
                            account=employer,
                            updateType=NEWSFEED_CURRENT_JOB_TYPE,
                            updateData=formatJobForNewsfeed(job=newCurrentJob)
                        )

                        # add skills to current job
                        formattedSkills = formatSkills(jobSkills)

                        for skillObject in formattedSkills:
                            CurrentJobSkill.objects.create(
                                job=newCurrentJob,
                                skill=skillObject['skill']
                            )

                        jobToTake.delete()

                        currentJobsAsEmployee = formatJobs(
                            CurrentJob.objects.filter(employee=employee),
                            hasEmployee=True
                        )

                    else:
                        errorMessage = 'Failed to take job'
                        return formattedResponse(isError=True,
                                                 errorMessage=errorMessage)
            else:
                errorMessage = 'Unknown employer'
                return formattedResponse(isError=True,
                                         errorMessage=errorMessage)
        else:
            errorMessage = 'Unknown user'
            return formattedResponse(isError=True, errorMessage=errorMessage)
    else:
        errorMessage = 'userId and employerId are the same'
        return formattedResponse(isError=True, errorMessage=errorMessage)

    currentJobsAsEmployeeModel = {
        'currentJobsAsEmployee': currentJobsAsEmployee
    }
    return formattedResponse(data=currentJobsAsEmployeeModel)


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
    accessToken = request['accessToken']

    if Account.objects.filter(userId=userId).exists():
        friendIsRegisteredUser = Account.objects.filter(
            userId=friendId).exists()
        if friendIsRegisteredUser:
            friend = Account.objects.get(userId=friendId)
            friendModel = getUserModel(friend)

            friendFirstName = friendModel['firstName']
            friendLastName = friendModel['lastName']
            friendProfileImage = friendModel['profileImageUrl']
            friendAboutMe = friendModel['aboutMe']
            friendSkills = friendModel['skills']
            friendJobs = friendModel['jobs']

        else:
            graph = FBOpen(access_token=accessToken, current_user_id=userId)
            friendInfo = graph.get(
                friendId,
                fields='picture, first_name, last_name'
            )

            friendFirstName = friendInfo['first_name']
            friendLastName = friendInfo['last_name']
            friendProfileImage = friendInfo['picture']['data']['url']
            friendAboutMe = ''
            friendJobs = None
            friendSkills = None

    else:
        errorMessage = 'Unknown user'
        return formattedResponse(isError=True, errorMessage=errorMessage)

    friendModelToReturn = {
        'friendIsRegisteredUser': friendIsRegisteredUser,
        'friendProfileImageUrl': friendProfileImage,
        'friendSkills': friendSkills,
        'friendFirstName': friendFirstName,
        'friendLastName': friendLastName,
        'friendAboutMe': friendAboutMe,
        'friendJobs': friendJobs
    }

    return formattedResponse(data=friendModelToReturn)


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
            jobSkills = CurrentJobSkill.objects.filter(job=jobToComplete)
            jobType = str(jobToComplete.jobType)
            jobDescription = str(jobToComplete.jobDescription)
            jobCompensation = str(jobToComplete.jobCompenstation)
            jobLat = float(jobToComplete.lat)
            jobLong = float(jobToComplete.long)

            newCompletedJob, newCompletedJobIsCreated = CompletedJob.objects.get_or_create(
                employer=employer,
                employee=employee,
                jobType=jobType,
                jobDescription=jobDescription,
                jobCompensation=jobCompensation,
                lat=jobLat,
                long=jobLong
            )

            if newCompletedJobIsCreated:

                # push completed job to newsfeed
                pushUpdateToNewsFeed(
                    account=employer,
                    updateType=NEWSFEED_COMPLETED_JOB_TYPE,
                    updateData=formatJobForNewsfeed(job=newCompletedJob)
                )

                # add skills to completed job
                formattedSkills = formatSkills(jobSkills)
                for skillObject in formattedSkills:
                    CompletedJobSkill.objects.create(
                        job=newCompletedJob,
                        skill=skillObject['skill']
                    )

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
                return formattedResponse(isError=True,
                                         errorMessage=errorMessage)
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
    requiredFields = ['accessToken', 'userId', ]

    # verify request
    verifiedRequestResponse = verifyRequest(request, requiredFields)
    if verifiedRequestResponse['isMissingFields']:
        errorMessage = verifiedRequestResponse['errorMessage']
        return formattedResponse(isError=True, errorMessage=errorMessage)

    request = request.POST
    userId = request['userId']
    accessToken = request['accessToken']

    if Account.objects.filter(userId=userId).exists():

        graph = FBOpen(access_token=accessToken, current_user_id=userId)
        friendsDegreeOne = graph.get('me/friends')['data']

        validPeople = {}

        # get user's immediate friends that have an account
        for friend in friendsDegreeOne:
            if (Account.objects.filter(userId=friend['id']).exists()):
                validPeople[friend['id']] = friend['name']

        # get user's friends of friends that have an account
        for validFriendId in validPeople.copy():
            friendsOfValidFriend = graph.get(validFriendId + '/friends')['data']
            for person in friendsOfValidFriend:
                if userId != person['id'] and \
                        Account.objects.filter(userId=person['id']).exists():
                    validPeople[person['id']] = person['name']

        postedJobs = PostedJob.objects.all()
        validPostedJobs = []
        for job in postedJobs:
            if job.employer.userId in validPeople:
                validPostedJobs.append(job)

        formattedPostedJobs = formatJobs(validPostedJobs)

    else:
        errorMessage = 'Unknown user'
        return formattedResponse(isError=True, errorMessage=errorMessage)

    data = {
        'postedJobs': formattedPostedJobs
    }
    return formattedResponse(data=data)


def getFriendsWithAppById(accessToken):
    graph = FBOpen(access_token=accessToken)

    allFriendsById = graph.get('me/friends', field='id')['data']
    friendsWithAppById = []

    for friend in allFriendsById:
        if Account.objects.filter(userId=friend['id']).exists():
            friendsWithAppById.append(friend['id'])

    return friendsWithAppById


def getFriendsWithAppByModel(accessToken):
    friendsWithAppById = getFriendsWithAppById(accessToken)
    friendsWithAppByModel = []

    for friendId in friendsWithAppById:
        friendObject = Account.objects.get(userId=friendId)
        friendsWithAppByModel.append({
            'friendFirstName': str(friendObject.firstName),
            'friendLastName': str(friendObject.lastName),
            'friendProfileImageUrl': str(
                ProfileImage.
                objects
                .get(
                    account=friendObject
                )
                .profileImageUrl
            ),
            'friendId': str(friendObject.userId)
        })

    return friendsWithAppByModel


def getFriends(request):
    '''
        Required fields:

            accessToken
            userId
    '''
    requiredFields = ['accessToken', 'userId']

    # verify request
    verifiedRequestResponse = verifyRequest(request, requiredFields)
    if verifiedRequestResponse['isMissingFields']:
        errorMessage = verifiedRequestResponse['errorMessage']
        return formattedResponse(isError=True, errorMessage=errorMessage)

    request = request.POST
    accessToken = request['accessToken']
    try:
        friends = getFriendsWithAppByModel(accessToken)
    except:
        errorMessage = 'Bad access token'
        return formattedResponse(isError=True, errorMessage=errorMessage)

    return formattedResponse(data=friends)


def pushUpdateToNewsFeed(account, updateType, updateData):
    NewsFeed.objects.create(account=account, type=updateType, data=json.dumps(updateData))


def getNewsfeed(request):
    '''
    Required fields:

        accessToken
        userId
    '''
    requiredFields = ['accessToken', 'userId']

    # verify request
    verifiedRequestResponse = verifyRequest(request, requiredFields)
    if verifiedRequestResponse['isMissingFields']:
        errorMessage = verifiedRequestResponse['errorMessage']
        return formattedResponse(isError=True, errorMessage=errorMessage)

    request = request.POST

    accessToken = request['accessToken']
    userId = request['userId']

    friendsWithAppById = getFriendsWithAppById(accessToken)

    newsfeed = []

    # get user's newsfeed updates
    if Account.objects.filter(userId=userId).exists():
        account = Account.objects.get(userId=userId)

        if NewsFeed.objects.filter(account=account).exists():

            accountNewsfeedItems = NewsFeed.objects.filter(account=account)

            for newsfeedItem in accountNewsfeedItems:
                newsfeed.append({
                    'userId': str(account.userId),
                    'profileImageUrl': str(ProfileImage
                                           .objects
                                           .get(account=account)
                                           .profileImageUrl),
                    'newsfeedItemType': str(newsfeedItem.type),
                    'newsfeedItemTime': str(newsfeedItem.timeCreated),
                    'newsfeedItemData': str(newsfeedItem.data)
                })

    # get newsfeed updates from friends with app
    for friendId in friendsWithAppById:
        friendAccount = Account.objects.get(userid=friendId)

        if NewsFeed.objects.filter(account=friendAccount).exists():

            friendNewsfeedItems = NewsFeed.objects.filter(account=friendAccount)

            for newsfeedItem in friendNewsfeedItems:
                newsfeed.append({
                    'userId': str(friendAccount.userId),
                    'profileImageUrl': str(ProfileImage
                                           .objects
                                           .get(account=friendAccount)
                                           .profileImageUrl),
                    'newsfeedItemType': str(newsfeedItem.type),
                    'newsfeedItemTime': str(newsfeedItem.timeCreated),
                    'newsfeedItemData': str(newsfeedItem.data)
                })

    newsfeedResponseObject = {
        'newsfeed': newsfeed
    }

    return formattedResponse(data=newsfeedResponseObject)


def viewJob(request):
    '''
    Required fields:

        accessToken
        jobId
        jobType
    '''
    requiredFields = ['accessToken', 'jobId', 'jobType']

    # verify request
    verifiedRequestResponse = verifyRequest(request, requiredFields)
    if verifiedRequestResponse['isMissingFields']:
        errorMessage = verifiedRequestResponse['errorMessage']
        return formattedResponse(isError=True, errorMessage=errorMessage)

    request = request.POST

    jobId = request['jobId']
    jobType = request['jobType']

    if jobType == NEWSFEED_POSTED_JOB_TYPE:

        jobToView = formatJob(PostedJob.objects.get(pk=jobId)) if \
            PostedJob.objects.filter(pk=jobId).exists() else None

    elif jobType == NEWSFEED_CURRENT_JOB_TYPE:

        jobToView = formatJob(
            CurrentJob.objects.get(pk=jobId),
            hasEmployee=True
        ) if CurrentJob.objects.filter(pk=jobId).exists() else None

    elif jobType == NEWSFEED_COMPLETED_JOB_TYPE:

        jobToView = formatJob(
            CompletedJob.objects.get(pk=jobId),
            hasEmployee=True
        ) if CompletedJob.objects.filter(pk=jobId).exists() else None
    else:
        errorMessage = 'Bad job type'
        return formattedResponse(isError=True, errorMessage=errorMessage)

    if jobToView is None:
        errorMessage = 'Unknown job'
        return formattedResponse(isError=True, errorMessage=errorMessage)

    return formattedResponse(data=jobToView)