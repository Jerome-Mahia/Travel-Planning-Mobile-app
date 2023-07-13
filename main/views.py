
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
import openai

import json

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
        
class GetEditUserDetails(APIView):
    def get(self, request):
        user = request.user
        serializer = UserSerializer(user)
        return Response(
            serializer.data,
                        status=status.HTTP_200_OK)
    
    def post(self, request):
        user = request.user
        data = request.data
        name = data['name']      
        dob = data['dob']
        phone = data['phone']
        image = data['image']

        user.name = name     
        user.dob = dob
        user.phone = phone
        if image != 'null':
            user.image = image 
        
        user.save()
        serializer = UserSerializer(user)
        return Response(
            serializer.data,
            status=status.HTTP_200_OK)

class CreateGetItinerary(APIView):
    def post(self, request):
        data = request.data
        user = request.user
        title = data['title']
        notes = data['notes']
        destination = data['destination']
        start_date = data['start_date']
        end_date = data['end_date']
        collaborators = data['collaborators']
        age = data['age']
        fun = data['fun']
        budget = data['budget']


        if end_date > start_date and datetime.strptime(start_date, '%Y-%m-%d').date() >= date.today():
            days = (datetime.strptime(end_date, '%Y-%m-%d').date() - datetime.strptime(start_date, '%Y-%m-%d').date()).days + 1
            if days > 5:
                return Response(
                    {'error': 'Itinerary cannot be more than 5 days'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            prompt = f"""you are a travel planner Create a brief {age} {fun} {days} day itinerary for a trip to {destination},Kenya
            including the budget for each activity in kshs and if applicable the location of each activity in latitude and longitude format.
            Format the itinerary as a json object with the days as the keys for example day1.
            Each key should have a value that is a list of 3 objects.
            Each object having activity,budget and location as keys.
            The first object should describe in detail the activites  to be done in the morning the 2nd in the afternoon and 3rd in the evening.
            Do not include morning,evening or afternoon in the activity description.
            """
            messages = [{"role": "user", "content": prompt}]
            try:
                openai.api_key = os.environ.get('openai_key')
                response = openai.ChatCompletion.create(
                    model="gpt-3.5-turbo",
                    messages=messages,
                    temperature=0.4, 
                )
            except:
                return Response (
                    {'error': 'Something went wrong gpt'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            print(response['usage'])
            print(response.choices[0].message["content"])

            itinerary = Itinerary(owner=user,title=title,notes=notes,budget=budget,destination=destination,start_date=start_date,end_date=end_date,tokens=response['usage']['total_tokens'])
            itinerary.save()
            if collaborators != 'none':
                for collaborator in collaborators:
                    collaborator = User.objects.get(id=collaborator)
                    if collaborator != user:
                        itinerary.collaborators.add(collaborator)

            content = json.loads(response.choices[0].message["content"])
            
            for i in range(days):
                it_date = datetime.strptime(start_date, '%Y-%m-%d').date() + timedelta(days=i)
                day_name = 'day'+str(i+1)
                try:
                    itinerary_day = ItineraryDay(itinerary=itinerary,date=it_date,name='day_name',morning_activity=content[day_name][0]['activity'],morning_budget=content[day_name][0]['budget'],morning_lat=content[day_name][0]['location']['latitude'],morning_long=content[day_name][0]['location']['longitude'],afternoon_activity=content[day_name][1]['activity'],afternoon_budget=content[day_name][1]['budget'],afternoon_lat=content[day_name][1]['location']['latitude'],afternoon_long=content[day_name][1]['location']['longitude'],evening_activity=content[day_name][2]['activity'],evening_budget=content[day_name][2]['budget'],evening_lat=content[day_name][2]['location']['latitude'],evening_long=content[day_name][2]['location']['longitude'])
                except:
                    return Response (
                        {'error': 'Something went wrong'},
                        status=status.HTTP_400_BAD_REQUEST
                    )
                itinerary_day.save()

        else:
            return Response (
                {'error': 'Invalid dates'},
                status=status.HTTP_400_BAD_REQUEST
            )

        return Response (
            
                {'success': 'Itinerary created successfully'},
                status=status.HTTP_201_CREATED
        
            ) 
    
    def get(self, request):
        user = request.user
        itineraries = Itinerary.objects.filter(owner=user)
        itineraries = ItinerarySerializer(itineraries, many=True)

        collaborating = Itinerary.objects.filter(collaborators__id=user.id)
        #print(collaborating)
        
        collaborating = ItinerarySerializer(collaborating, many=True)
        return Response (         
            {'itineraries': itineraries.data,'collaborating': collaborating.data},
            status=status.HTTP_200_OK   
        ) 

class GetEditItineraryDetails(APIView):
    def get(self, request, pk):
        user = request.user
        itinerary = Itinerary.objects.get(id=pk)
        if itinerary.owner == user or user in itinerary.collaborators.all():
            #itinerary = ItinerarySerializer(itinerary)
            collaborators = []
            for user in itinerary.collaborators.all():
                collaborator = {"name":user.name,"id":user.id}
                collaborators.append(collaborator)
            
            updated_at = itinerary.updated_at.strftime("%d-%m-%Y, %H:%M:%S")
            
            days = ItineraryDay.objects.filter(itinerary=itinerary).order_by('date')
            days = ItineraryDaySerializer(days,many=True)

            try:
                itinerary = {"id":itinerary.id,"title":itinerary.title,"notes":itinerary.notes,"destination":itinerary.destination,"budget":itinerary.budget,"star_date":itinerary.start_date,"end_date":itinerary.end_date,"updated_at":updated_at,"updated_by":itinerary.updated_by.name}
            except:
                itinerary = {"id":itinerary.id,"title":itinerary.title,"notes":itinerary.notes,"destination":itinerary.destination,"budget":itinerary.budget,"star_date":itinerary.start_date,"end_date":itinerary.end_date,"updated_at":updated_at,"updated_by":'none'}
        
            
            return Response (         
                {'itinerary': itinerary,"collaborators":collaborators,"days":days.data},
                status=status.HTTP_200_OK   
            ) 
        else:
            return Response (         
                {'error': 'You are not allowed to view this itinerary'},
                status=status.HTTP_403_FORBIDDEN   
            )
    
    def post(self,request,pk):
        data = request.data
        user = request.user
        itinerary = Itinerary.objects.get(id=pk)
        if itinerary.owner == user or user in itinerary.collaborators.all():
            itinerary.title = data['title']
            itinerary.notes = data['notes']
            itinerary.budget = data['budget']
            itinerary.updated_by = user
            itinerary.save()
            return Response (         
                {'success': 'Itinerary updated successfully'},
                status=status.HTTP_200_OK   
            ) 
        else:
            return Response (         
                {'error': 'You are not allowed to edit this itinerary'},
                status=status.HTTP_403_FORBIDDEN   
            )

class DeleteItinerary(APIView):
    def delete(self, request,pk):
        user = request.user
        itinerary = Itinerary.objects.get(id=pk)
        if itinerary.owner == user:    
            itinerary.delete()
            return Response (         
                {'success': 'Itinerary deleted successfully'},
                status=status.HTTP_200_OK   
            )
        else:
            return Response (         
                {'error': 'You are not allowed to delete this itinerary'},
            )
           
class AddRemoveCollaborator(APIView):
    def post(self, request,pk):
        data = request.data
        user = request.user
        itinerary = Itinerary.objects.get(id=pk)
        if itinerary.owner == user:    
            if data['action'] == 'add':       
                collaborator = User.objects.get(id=data['collaborator'])
                itinerary.collaborators.add(collaborator)
                return Response (         
                    {'success': 'Collaborator added successfully'},
                    status=status.HTTP_200_OK   
                )
            elif data['action'] == 'remove':
                collaborator = User.objects.get(id=data['collaborator'])
                itinerary.collaborators.remove(collaborator)
                return Response (         
                    {'success': 'Collaborator removed successfully'},
                    status=status.HTTP_200_OK   
                )
            

class EditItineraryDay(APIView):
    def post(self, request,pk):
        data = request.data
        user = request.user
        itinerary_day = ItineraryDay.objects.get(id=pk)
        itinerary = itinerary_day.itinerary
        if itinerary.owner == user or user in itinerary.collaborators.all():    
                   
            itinerary_day.name = data['name']
            itinerary_day.morning_activity = data['morning_activity']
            itinerary_day.morning_budget = data['morning_budget']
            itinerary_day.morning_lat = data['morning_lat']
            itinerary_day.morning_long = data['morning_long']
            itinerary_day.afternoon_activity = data['afternoon_activity']
            itinerary_day.afternoon_budget = data['afternoon_budget']
            itinerary_day.afternoon_lat = data['afternoon_lat']
            itinerary_day.afternoon_long = data['afternoon_long']
            itinerary_day.evening_activity = data['evening_activity']
            itinerary_day.evening_budget = data['evening_budget']
            itinerary_day.evening_lat = data['evening_lat']
            itinerary_day.evening_long = data['evening_long']
            
            itinerary_day.save()
            itinerary.updated_by = user
            itinerary.save()

            return Response (         
                {'success': 'Itinerary day edited successfully'},
                status=status.HTTP_200_OK   
            )
           
        else:
            return Response (         
                {'error': 'You are not allowed to edit this itinerary day'},
            )

class SearchUsers(APIView):
    def post(self,request):
        data = request.data
        users = User.objects.filter(name__icontains=data['search'])
        users = UserSerializer(users,many=True)
        return Response (         
            {'users': users.data},
            status=status.HTTP_200_OK   
        )
    
class GetDestinations(APIView):
    def get(self,request):
        destinations = Destination.objects.all()
        destinations = DestinationSerializer(destinations,many=True)
        return Response (         
            {'destinations': destinations.data},
            status=status.HTTP_200_OK   
        )