from django.http import HttpResponse
from rest_framework import generics, status
from media.api.serializers import *

from rest_framework.response import Response
from rest_framework.views import APIView


class CloseMedia(generics.GenericAPIView):
    def get(self, request):
        try:
            close_media = MediaModel.objects.all()
            data = MediaSerializer(close_media, many=True).data
            return Response(data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"success": False, "data": {"error": str(e)}}, status=status.HTTP_400_BAD_REQUEST)
