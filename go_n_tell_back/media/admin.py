from django.contrib import admin
from media.models import *


@admin.register(PositionTime)
class PositionTimeAdmin(admin.ModelAdmin):
    pass


@admin.register(MediaModel)
class MediaModelAdmin(admin.ModelAdmin):
    pass
