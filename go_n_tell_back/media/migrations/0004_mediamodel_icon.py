# Generated by Django 4.2.3 on 2023-10-29 11:43

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('media', '0003_mediamodel_positiontime_delete_media_model_and_more'),
    ]

    operations = [
        migrations.AddField(
            model_name='mediamodel',
            name='icon',
            field=models.CharField(default='icon', max_length=50, null=True),
        ),
    ]
