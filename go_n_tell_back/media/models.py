from django.db import models


class PositionTime(models.Model):
    lat = models.FloatField(null=True, default=-1.0)
    lng = models.FloatField(null=True, default=-1.0)
    accuracy = models.FloatField(null=True, default=-1.0)
    timestamp = models.DateTimeField(auto_now=True)


class MediaModel(models.Model):
    type = models.CharField(null=True, default="text", max_length=200)
    content = models.TextField(null=True, default="", max_length=2000)
    created = models.DateTimeField(auto_now=True)
    position_time = models.ForeignKey(PositionTime, null=True, on_delete=models.DO_NOTHING)
    icon = models.CharField(null=True, default="icon", max_length=50)
