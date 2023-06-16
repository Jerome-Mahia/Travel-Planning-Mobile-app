
from django.contrib import admin
from django.urls import path,include
from .views import *
from .mobileClient import *

urlpatterns = [
    path('register', RegisterView.as_view()),
    #path('register/super', RegisterSuperView.as_view()),
    path('sendcode', SendCode.as_view()),
    #path('google-login', GoogleLoginApi.as_view()),
    path('reset-password', ResetPassword.as_view()),
]
