FROM node:14-alpine


ENV LANG C.UTF-8

ENV MQTT_SERVER localhost
ENV MQTT_PORT 1883
ENV TOPIC AdbMqttBridge
ENV USER mqttuser
ENV PASSWORD mqttpass
ENV ADB_DEVICE 192.168.1.45
ENV POLL_INTERVAL 5

ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache android-tools python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools
WORKDIR /usr/src/app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY adb_monitor.py .

# adb settings must be persistant
VOLUME [ "/config" ]
RUN ln -s /config /root/.android

CMD [ "python", "./adb_monitor.py" ]
