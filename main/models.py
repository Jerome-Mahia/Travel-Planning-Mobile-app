from django.db import models

# Create your models here.

from django.conf import settings
from django.contrib.auth.models import AbstractBaseUser, PermissionsMixin, BaseUserManager
from cloudinary.models import CloudinaryField
from datetime import datetime,timedelta,time,date

#custom user manager
class UserAccountManager(BaseUserManager):

    def create_user(self, email, name,phone,dob,image ,password=None):
        if not email:
            raise ValueError('Users must have email address')

        #ensure emails are consistent
        email = self.normalize_email(email)
        email = email.lower()

        #create user
        user = self.model(
            email = email,
            name = name,
            phone=phone,
            dob=dob,
            image=image,
        )
        user.set_password(password)
        user.save()

        return user
    
   
    def create_superuser(self, email, name,phone,dob,image, password=None):
        user = self.create_user(email, name,phone,dob, password)
        user.is_superuser = True
        user.is_staff = True
        user.save()

        return user    

class UserAccount(AbstractBaseUser, PermissionsMixin):

    #i can add any other fields i would want a user to have such as phone number
    email = models.EmailField(max_length=255, unique=True)
    name = models.CharField(max_length=255, null=True)
    phone = models.CharField(max_length=10,null=True,blank=True)
    dob = models.DateField(null=True,blank=True)
    image = CloudinaryField('image',null=True,blank=True)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    friends = models.ManyToManyField(settings.AUTH_USER_MODEL, related_name='user_friends',blank=True)
    


    objects = UserAccountManager()

    #determine what default login will be 
    #Normally it is 'username' but i want to use email
    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['name','phone' ]

    def get_full_name(self):
        return self.name

    def get_short_name(self):
        return self.name
    
    def __str__(self):
        return self.email


class VerificationCode(models.Model):
    class Type(models.TextChoices):
        REGISTRATION = 'registration'
        RESETPASSWORD = 'resetpassword'

    email = models.EmailField()
    code = models.CharField(max_length=6)
    type = models.CharField(max_length=20, choices=Type.choices, default=Type.REGISTRATION)
    date_created = models.DateTimeField(auto_now_add=True)
    expiry_date = models.DateTimeField(null=True)

class Itinerary(models.Model):
    owner = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    collaborators = models.ManyToManyField(settings.AUTH_USER_MODEL, related_name='colaborators',blank=True)
    title = models.CharField(max_length=255)
    notes = models.TextField(null=True, blank=True)
    budget = models.IntegerField(default=0)
    destination = models.CharField(max_length=255)
    start_date = models.DateField()
    end_date = models.DateField()
    created_at = models.DateTimeField(auto_now_add=True)
    tokens = models.IntegerField(default=0)
    updated_at = models.DateTimeField(auto_now=True)
    updated_by = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='updated_by',null=True, blank=True)
    #is_public = models.BooleanField(default=False)
    def __str__(self):
        return self.title + " for " + self.owner.email


class ItineraryDay(models.Model):
    itinerary = models.ForeignKey(Itinerary, on_delete=models.CASCADE)
    date = models.DateField()
    name = models.CharField(max_length=255)
    morning_activity = models.TextField(null=True, blank=True)
    afternoon_activity = models.TextField(null=True, blank=True)
    evening_activity = models.TextField(null=True, blank=True)
    morning_budget = models.IntegerField(default=0)
    afternoon_budget = models.IntegerField(default=0)
    evening_budget = models.IntegerField(default=0)
    morning_lat = models.FloatField(null=True, blank=True,default=0.0)
    morning_long = models.FloatField(null=True, blank=True,default=0.0)
    afternoon_lat = models.FloatField(null=True, blank=True,default=0.0)
    afternoon_long = models.FloatField(null=True, blank=True,default=0.0)
    evening_lat = models.FloatField(null=True, blank=True,default=0.0)
    evening_long = models.FloatField(null=True, blank=True,default=0.0)
    def __str__(self):
        return self.name

class Destination(models.Model):
    class Region(models.TextChoices):
        RIFTVALLEY = 'Rift Valley'
        EASTERN = 'Eastern'
        NORTHEASTERN = 'North Eastern'
        COAST = 'Coast'
        CENTRAL = 'Central'
        NAIROBI = 'Nairobi'
        NYANZA = 'Nyanza'
        WESTERN = 'Western'

    name = models.CharField(max_length=255)
    image = CloudinaryField('image',null=True,blank=True)
    overview = models.TextField(null=True, blank=True)
    region = models.CharField(max_length=20, choices=Region.choices, default=Region.NAIROBI)
    county = models.CharField(max_length=255,null=True, blank=True)

    def __str__(self):
        return self.name
    

class Request(models.Model):
    class Status(models.TextChoices):
        DENIED = 'Denied'
        ACCEPTED = 'Accepted'
        PENDING = 'Pending'
        
    sent_by = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='by')
    sent_to = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE , related_name='to')
    status = models.CharField(max_length=20, choices=Status.choices, default=Status.PENDING)
    
    def __str__(self):
       return  "{}".format(self.pk)
