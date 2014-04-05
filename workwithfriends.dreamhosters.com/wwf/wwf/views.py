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


def formatJobs(jobs):
    formattedJobs = None

    if jobs is not None:
        formattedJobs = []
        for job in jobs:
            formattedJob = {
                'employerId': str(job.employer.userId),
                'employerName': str(job.employer.name),
                'type': str(job.jobType),
                'description': str(job.jobDescription),
                'compensation': str(job.jobCompensation)
            }

            formattedJobs.append(formattedJob)

    return formattedJobs


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
    request = request.POST
    accessToken = request['accessToken']
    userId = request['userId']

    account, isAccountCreated = Account.objects.get_or_create(userId=userId)

    # if new user
    if (isAccountCreated):
        graph = FBOpen(access_token=accessToken, current_user_id=userId)

        userInfo = graph.get('me', fields='name, picture')

        name = userInfo['name']
        profileImageUrl = userInfo['picture']
        skills = None
        jobs = None

        account.name = name

        profileImage, isImageCreated = ProfileImage.objects.get_or_create(account=account,
                                                                     profileImageUrl=profileImageUrl)

        account.save()

    # if returning user
    else:
        name = account.name
        profileImageUrl = ProfileImage.objects.get(account=account).profileImageurl

        # get jobs
        postedJobs = None if not PostedJob.objects.filter(account=account).exists() else formatJobs(
            PostedJob.objects.get(
                account=account))
        currentJobs = None if not CurrentJob.objects.filter(account=account).exists() else formatJobs(
            CurrentJob.objects.get(account=account))
        completedJobs = None if not CompletedJob.objects.filter(account=account).exists() else formatJobs(
            CompletedJob.objects.get(account=account))

        jobs = {
            'postedJobs': postedJobs,
            'currentJobs': currentJobs,
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
