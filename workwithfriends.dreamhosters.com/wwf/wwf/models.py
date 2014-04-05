from django.db import models

class Account(models.Model):
    name = models.CharField(max_length=200)
    userId = models.CharField(max_length=200)

    def __unicode__(self):
        return str(self.name) + ' ' +  str(self.userId)

class ProfileImage(models.Model):
    acccount = models.ForeignKey(Account)
    profileImageUrl = models.CharField(max_length=200)
    
    def __unicode__(self):
        return str(account)

class Job(models.Model):
    employer = models.ForeignKey(Account)
    jobType = models.CharField(max_length=200)
    jobDescription = models.CharField(max_length=200)
    jobCompensation = models.CharField(max_length=200)
    
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