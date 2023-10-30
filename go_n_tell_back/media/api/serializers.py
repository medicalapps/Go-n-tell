from rest_framework import serializers
from media.models import *
import locale


class MediaSerializer(serializers.ModelSerializer):
    content = serializers.SerializerMethodField()
    latlangtime = serializers.SerializerMethodField()

    created = models.DateTimeField(auto_now=True)
    position_time = models.ForeignKey(PositionTime, null=True, on_delete=models.DO_NOTHING)

    lat = models.FloatField(null=True, default=-1.0)
    lng = models.FloatField(null=True, default=-1.0)
    accuracy = models.FloatField(null=True, default=-1.0)
    timestamp = models.DateTimeField(auto_now=True)

    class Meta:
        model = MediaModel

        fields = (
            "id",
            "type",
            "content",
            "created",
            "latlangtime",
        )

    def get_content(self, obj):
        try:
            if obj.type == "text":
                return obj.content
        except Exception as e:
            return "Error: " + str(e)

    def get_latlangtime(self, obj):
        try:
            if obj.position_time is not None:
                return {
                    "lat": obj.position_time.lat,
                    "lng": obj.position_time.lng,
                    "timestamp": obj.position_time.timestamp,
                    "accuracy": obj.position_time.accuracy,
                }
        except Exception as e:
            return {"Error": str(e)}
