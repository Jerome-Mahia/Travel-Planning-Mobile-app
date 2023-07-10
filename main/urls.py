
from django.contrib import admin
from django.urls import path,include
from .views import *

urlpatterns = [
    path('register', RegisterView.as_view()),
    path('register/super', RegisterSuperView.as_view()),
    path('sendcode', SendCode.as_view()),
    path('google-login', GoogleLoginApi.as_view()),
    path('reset-password', ResetPassword.as_view()),
    path('create-get-itinerary', CreateGetItinerary.as_view()),
    path('get-itinerary-details/<str:pk>', GetItineraryDetails.as_view()),
    path('add-remove-collaborator/<str:pk>', AddRemoveCollaborator.as_view()),
    path('delete-itinerary/<str:pk>', DeleteItinerary.as_view()),
    path('edit-itinerary-day/<str:pk>', EditItineraryDay.as_view()),
]
