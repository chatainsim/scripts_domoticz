#!/usr/bin/env python3
#git clone https://github.com/open-homeautomation/miflora.git
import argparse
import re
import logging
import requests

from miflora.miflora_poller import MiFloraPoller, \
    MI_CONDUCTIVITY, MI_MOISTURE, MI_LIGHT, MI_TEMPERATURE, MI_BATTERY
from miflora.backends.gatttool import GatttoolBackend
from miflora.backends.bluepy import BluepyBackend
from miflora import miflora_scanner

backend = GatttoolBackend
mac = 'C4:7C:8D:60:C1:2B'
idx = 300
idx2 = 301
poller = MiFloraPoller(mac, backend)

temp = poller.parameter_value(MI_TEMPERATURE)
hum = poller.parameter_value(MI_MOISTURE)
bat = poller.parameter_value(MI_BATTERY)
fert = poller.parameter_value(MI_CONDUCTIVITY)

url = "http://192.168.1.254:3434/json.htm?type=command&param=udevice&idx={0}&nvalue=0&svalue={1};{2};0&battery={3}&rssi=10".format(idx, temp, hum, bat)
r = requests.get(url)
url2 = "http://192.168.1.254:3434/json.htm?type=command&param=udevice&idx={0}&nvalue=0&svalue={1}&battery={2}&rssi=10".format(idx2, fert, bat)
r2 = requests.get(url2)
