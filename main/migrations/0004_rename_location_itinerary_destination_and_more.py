# Generated by Django 4.1.7 on 2023-07-05 17:07

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('main', '0003_itinerary_itineraryday'),
    ]

    operations = [
        migrations.RenameField(
            model_name='itinerary',
            old_name='location',
            new_name='destination',
        ),
        migrations.AddField(
            model_name='itinerary',
            name='tokens',
            field=models.IntegerField(default=0),
        ),
    ]