from rest_framework import serializers
from django.contrib.auth import get_user_model
from .models import *
User = get_user_model()


class ItinerarySerializer(serializers.ModelSerializer):
    class Meta:
        model = Itinerary
        fields = '__all__'

class ItineraryDaySerializer(serializers.ModelSerializer):
    class Meta:
        model = ItineraryDay
        fields = '__all__'
