#!/usr/bin/python3.4
import requests
from datetime import datetime
from miflora.miflora_poller import MiFloraPoller, \
    MI_CONDUCTIVITY, MI_MOISTURE, MI_LIGHT, MI_TEMPERATURE, MI_BATTERY
### PARAMETRES A EDITER
# idx du sensor virtuel pour la temperature et l'humidite
idx = 300
# idx du sensor virtuel pour l'engrais
idx2 = 301
# Adresse MAC du Mi Flower
poller = MiFloraPoller("C4:7C:8D:60:C1:2B")
### FIN DES PARAMETRES A EDITER

maintenant = datetime.now()
date = "{0}/{1}/{2} - {3}:{4}".format(maintenant.day, maintenant.month, maintenant.year, maintenant.hour, maintenant.minute)




temp = poller.parameter_value("temperature")
hum = poller.parameter_value(MI_MOISTURE)
bat = poller.parameter_value(MI_BATTERY)
fert = poller.parameter_value(MI_CONDUCTIVITY)

url = "http://192.168.1.254:3434/json.htm?type=command&param=udevice&idx={0}&nvalue=0&svalue={1};{2};0&battery={3}&rssi=10".format(idx, temp, hum, bat)
r = requests.get(url)
print("{0} - Return code: {1} - Temp: {2} - Hum: {3} - Bat: {4}".format(date, r.status_code, temp, hum, bat))

url2 = "http://192.168.1.254:3434/json.htm?type=command&param=udevice&idx={0}&nvalue=0&svalue={1}&battery={2}&rssi=10".format(idx2, fert, bat)
r2 = requests.get(url2)
print("{0} - Return code: {1} - Fert: {2} - Bat: {3}".format(date, r2.status_code, fert, bat))
