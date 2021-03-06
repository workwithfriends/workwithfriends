from django.db import models

class Account(models.Model):
    firstName = models.CharField(max_length=200, default='')
    lastName = models.CharField(max_length=200, default='')
    userId = models.CharField(max_length=200)
    aboutMe = models.CharField(max_length=200, default='')

    def __unicode__(self):
        return str(self.firstName) + ' ' + str(self.lastName) + ' ' + str(
            self
                                                                    .userId)

class ProfileImage(models.Model):
    account = models.ForeignKey(Account)
    profileImageUrl = models.CharField(max_length=200)
    
    def __unicode__(self):
        return str(self.account)

class Job(models.Model):
    employer = models.ForeignKey(Account, related_name='%(app_label)s_%(class)s_related')
    jobType = models.CharField(max_length=200)
    jobDescription = models.CharField(max_length=200)
    jobCompensation = models.CharField(max_length=200)
    lat = models.FloatField(default=0.0)
    long = models.FloatField(default=0.0)
    timeCreated = models.DateTimeField(auto_now_add=True)
    
    def __unicode__(self):
        return str(self.jobType) + ' ' + str(self.employer)

    class Meta:
        abstract = True

class PostedJob(Job):
    pass

class CurrentJob(Job):
    employee = models.ForeignKey(Account)

class CompletedJob(Job):
    employee = models.ForeignKey(Account)

class Skill(models.Model):
    skill = models.CharField(max_length=200)

    class Meta:
        abstract = True

class UserSkill(Skill):
    account = models.ForeignKey(Account)
    strength = models.CharField(max_length=200)

    def __unicode__(self):
        return str(self.skill) + ' ' + str(self.account)

class PostedJobSkill(Skill):
    job = models.ForeignKey(PostedJob)

    def __unicode__(self):
        return str(self.skill) + ' ' + str(self.job)

class CurrentJobSkill(Skill):
    job = models.ForeignKey(CurrentJob)

    def __unicode__(self):
        return str(self.skill) + ' ' + str(self.job)

class CompletedJobSkill(Skill):
    job = models.ForeignKey(CompletedJob)
    
    def __unicode__(self):
        return str(self.skill) + ' ' + str(self.job)

class NewsFeed(models.Model):
    account = models.ForeignKey(Account)
    timeCreated = models.DateTimeField(auto_now_add=True)
    type = models.CharField(max_length=200)
    data = models.CharField(max_length=400)

    def __unicode__(self):
        return str(self.account) + ' ' + str(self.type)

class DataPoint(models.Model):
    account = models.ForeignKey(Account)
    action = models.CharField(max_length=200)
    currentState = models.CharField(max_length=200, default='')
    nextState = models.CharField(max_length=200, default='')
    time = models.DateTimeField(auto_now_add=True)

    def __unicode__(self):
        return str(self.account) + ', ' + str(self.action)

class UserFeedback(models.Model):
    account = models.ForeignKey(Account)
    feedback = models.CharField(max_length=200)
    time = models.DateTimeField(auto_now_add=True)

    def __unicode__(self):
        return str(self.account)