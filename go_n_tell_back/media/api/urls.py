from django.urls import path

from media.api.views import *

urlpatterns = [
    path("media-close-to-me/", CloseMedia.as_view(), name="close_media"),
]
