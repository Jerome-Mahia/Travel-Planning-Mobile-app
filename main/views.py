
from asyncio import events
import email
from django.core.mail import EmailMessage
from django.template.loader import render_to_string

from unicodedata import name
import pytz
from rest_framework.views import APIView
from rest_framework import permissions, status
from rest_framework.response import Response 
from rest_framework.generics import ListAPIView, RetrieveAPIView
from rest_framework.parsers import MultiPartParser,FormParser

from django.contrib.auth import get_user_model
User = get_user_model()

from .serializers import *
from .models import *
import random
from datetime import datetime,timedelta,time,date
import requests
from django.http import FileResponse

import secrets
import string
import math
from django.utils.timezone import make_aware
from django.core.mail import send_mail
from django.contrib.postgres.search import SearchQuery,  SearchVector
from rest_framework.decorators import api_view,permission_classes
from rest_framework.permissions import AllowAny

from rest_framework_simplejwt.tokens import RefreshToken

from PIL import Image
import sys
import os

from django.contrib.postgres.search import SearchQuery,  SearchVector
from .utils import *


class RegisterSuperView(APIView):
    permission_classes = (permissions.AllowAny,)

    def post(self,request, format=None):
        data = request.data
        name = data['name']
        email = data['email']
        email = email.lower()
        password = data['password']
        phone = data['phone']
        dob = data['dob']
        image=['image']

        user = User.objects.create_superuser(name=name, image=image,email=email, password=password,phone=phone,dob=dob)
        refresh = RefreshToken.for_user(user)

        return Response (
            {
            'refresh': str(refresh),
            'access': str(refresh.access_token)
            },
            status=status.HTTP_200_OK
        )
    
class RegisterView(APIView):
    permission_classes = (permissions.AllowAny,)

    def post(self,request, format=None):
        data = request.data
        name = data['name']
        email = data['email']
        email = email.lower()
        password = data['password']
        phone = data['phone']
        image=data['image']
        dob = data['dob']
        code = data['code']

        valid = VerificationCode.objects.filter(code=code, type='registration',email=email, expiry_date__gt =datetime.now()).exists()
        print(valid)
        if valid:
            if len(password) >=8:
                
                if not User.objects.filter(email=email).exists():
                    
                    
                        user = User.objects.create_user(name=name, email=email, password=password,phone=phone,dob=dob,image=image)
                        otp_delete = VerificationCode.objects.get(code=code, type='registration',email=email, expiry_date__gt =datetime.now())
                        otp_delete.delete()
                        refresh = RefreshToken.for_user(user)

                        return Response ({
                            'refresh': str(refresh),
                            'access': str(refresh.access_token)
                            },
                            status=status.HTTP_200_OK
                        )
                    
                   
                else:
                    return Response(
                        {'error': 'User with this email already exists'},
                        status=status.HTTP_400_BAD_REQUEST
                    )
    
            else:
                return Response(
                        {'error': 'Password must be at least 8 characters long'},
                        status=status.HTTP_400_BAD_REQUEST
                    )
        else:
            return Response(
                    {'error': 'Invalid code'},
                    status=status.HTTP_400_BAD_REQUEST
                )




#Send registration or Verification code
class SendCode(APIView):
    permission_classes = (permissions.AllowAny,)

    def post(self,request, format=None):
        data = request.data
        email = data['email']
        code_type = data['code_type']
        
        if code_type == 'registration':
            if not User.objects.filter(email=email).exists():               
                code = createCode()
            
                expiry_date = datetime.now() + timedelta(hours=0, minutes=10, seconds=0) 
                timezone = pytz.timezone('Africa/Nairobi')
                expiry_date = timezone.localize(expiry_date)

                new_code = VerificationCode(email=email, code=code,type='registration' ,expiry_date=expiry_date)
                new_code.save()

                message = render_to_string('main/verifyEmail.html', {'code': code})
                email = EmailMessage('Email Verification code', message, 'mikemundati@gmail.com',to=[email])
                email.fail_silently = False
                email.content_subtype = 'html'
                email.send()
                #send_mail("Email Verification code", "Your verification code is " + code + " .It will expire in 10 minutes", "mikemundati@gmail.com",[ email], fail_silently=False)
                return Response(
                    {'success': 'Code sent successfully'},
                    status=status.HTTP_200_OK
                )
            else:
                return Response(
                    {'error': 'User with this email already exists'},
                    status=status.HTTP_400_BAD_REQUEST
                )

        elif code_type == 'resetpassword':
            if  User.objects.filter(email=email).exists():
                code = createCode()
                        
                expiry_date = datetime.now() + timedelta(hours=0, minutes=10, seconds=0)
                timezone = pytz.timezone('Africa/Nairobi')
                expiry_date = timezone.localize(expiry_date)

                new_code = VerificationCode(email=email, code=code,type='resetpassword' ,expiry_date=expiry_date)
                new_code.save()

                message = render_to_string('main/resetPassword.html', {'code': code})
                email = EmailMessage('Email Verification code', message, 'mikemundati@gmail.com',to=[email])
                email.fail_silently = False
                email.content_subtype = 'html'
                email.send()

                #send_mail("Reset password code", "Your code is " + code + " .It will expire in 10 minutes", "mikemundati@gmail.com",[ email], fail_silently=False)

                return Response(
                    {'success': 'Code sent successfully'},
                    status=status.HTTP_200_OK
                )
                    
            else:
                return Response(
                    {'error': 'Invalid email'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            
        else:
            return Response(status=status.HTTP_400_BAD_REQUEST)

        


class ResetPassword(APIView):
    permission_classes = (permissions.AllowAny,)

    def post(self, request, format=None):
        data = request.data
        otp = data['code']
        email = data['email']
        password = data['password']
                
        #check if otp has not expired
        valid = VerificationCode.objects.filter(code=otp, type='resetpassword',email=email, expiry_date__gt =datetime.now()).exists()
        
                
        if (valid):
            if len(password) >=8:
                #if otp is valid
                #reset password
                user = User.objects.get(email=email)
                user.set_password(password)
                user.save()

                #delete otp
                otp_delete = VerificationCode.objects.get(code=otp, email=email, expiry_date__gt =datetime.now())
                otp_delete.delete()

                return Response(
                        {'success': ' password reset '},
                        status=status.HTTP_201_CREATED
                    )
            
            else:
                return Response(
                    {'error': 'Password must be at least 8 characters long'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            
        else:
            #if otp has expired
            #delete otp
            try:
                otp_delete = VerificationCode.objects.get(code=otp, type='resetpassword',email=email, expiry_date__lt =datetime.now())
                otp_delete.delete()
                return Response(
                    {'error': 'Invalid code'},
                    status=status.HTTP_400_BAD_REQUEST
                )  
            except:
                return Response(
                    {'error': 'Invalid code'},
                    status=status.HTTP_400_BAD_REQUEST
                )      


class GoogleLoginApi( APIView):
    permission_classes = (permissions.AllowAny,)

    def post(self, request):
       
        data = request.data
        email=data['email']
        name=data['name']

        try:    
            #login
            user = User.objects.get(email=email)
            refresh = RefreshToken.for_user(user)

            return Response ({
                'refresh': str(refresh),
                'access': str(refresh.access_token)
                },
                status=status.HTTP_200_OK
            )
        except:
            #create account
            password = createPassword()
            
            user = User.objects.create_user(name=name, email=email, password=password)
            refresh = RefreshToken.for_user(user)

            return Response ({
                'refresh': str(refresh),
                'access': str(refresh.access_token)
                },
                status=status.HTTP_201_CREATED
            ) 