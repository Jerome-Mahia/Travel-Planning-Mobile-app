
from asyncio import events
import email
from django.core.mail import EmailMessage
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

class RegisterView(APIView):
    permission_classes = (permissions.AllowAny,)

    def post(self,request, format=None):
        data = request.data
        name = data['name']
        email = data['email']
        email = email.lower()
        password = data['password']
        phone = data['phone']
        type = data['type']
        code = data['code']

        valid = VerificationCode.objects.filter(code=code, type='registration',email=email, expiry_date__gt =datetime.now()).exists()
        
        if valid:
            if len(password) >=8:
                
                if not User.objects.filter(email=email).exists():
                    
                    
                        user = User.objects.create_shop_owner(name=name, email=email, password=password,phone=phone)
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
        type = data['type']
        
        if type == 'registration':
            if not User.objects.filter(email=email).exists():               
                code = createCode()
            
                expiry_date = datetime.now() + timedelta(hours=0, minutes=10, seconds=0) 
                timezone = pytz.timezone('Africa/Nairobi')
                expiry_date = timezone.localize(expiry_date)

                new_code = VerificationCode(email=email, code=code,type='registration' ,expiry_date=expiry_date)
                new_code.save()

                send_mail("Email Verification code", "Your verification code is " + code + " .It will expire in 10 minutes", "mikemundati@gmail.com",[ email], fail_silently=False)

            else:
                return Response(
                    {'error': 'User with this email already exists'},
                    status=status.HTTP_400_BAD_REQUEST
                )

        elif type == 'resetpassword':
            if  User.objects.filter(email=email).exists():
                code = createCode()
                        
                expiry_date = datetime.now() + timedelta(hours=0, minutes=10, seconds=0)
                timezone = pytz.timezone('Africa/Nairobi')
                expiry_date = timezone.localize(expiry_date)

                new_code = VerificationCode(email=email, code=code,type='resetpassword' ,expiry_date=expiry_date)
                new_code.save()

                send_mail("Reset password code", "Your code is " + code + " .It will expire in 10 minutes", "mikemundati@gmail.com",[ email], fail_silently=False)

                return "Done"
            else:
                return Response(
                    {'error': 'Invalid email'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            
        else:
            return Response(status=status.HTTP_400_BAD_REQUEST)

        return Response(
            {'success': 'Code sent successfully'},
            status=status.HTTP_200_OK
        )


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
        code = data['code']
        type = data['type']
        
        access_token = google_get_access_token(code=code)
        if access_token == 'Failed to obtain access token from Google.':
            return Response(
           
            status=status.HTTP_401_UNAUTHORIZED
        )
        user_data = google_get_user_info(access_token=access_token)
        email = user_data['email']
        name = user_data['name']

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
            if type == 'shop_owner':
                user = User.objects.create_shop_owner(name=name, email=email, password=password,phone='')
                refresh = RefreshToken.for_user(user)

                return Response ({
                    'refresh': str(refresh),
                    'access': str(refresh.access_token)
                    },
                    status=status.HTTP_201_CREATED
                )    

            elif type == 'client':
                user = User.objects.create_user(name=name, email=email, password=password,phone='')
                refresh = RefreshToken.for_user(user)

                return Response ({
                    'refresh': str(refresh),
                    'access': str(refresh.access_token)
                    },
                    status=status.HTTP_201_CREATED
                )    