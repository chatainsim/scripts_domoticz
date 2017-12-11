#!/bin/bash
###############################
# Obsolete nouvelle version : https://github.com/chatainsim/scripts_domoticz/blob/master/vigicrue2.lua
###############################
exit 0
### PARAMETRES A MODIFIER
#Domoticz
SERVER="192.168.1.254:3434"
#ID Grenoble Bastille
STATION="W141001001"
#IDX Hauteur eau
HIDX="215"
#IDX Vitesse eau
SIDX="216"
### FIN DES PARAMETERES A MODIFIER


#Url niveau eau
URLNIVEAU="http://www.vigicrues.gouv.fr/niveau3.php?CdStationHydro=$STATION&typegraphe=h&AffProfondeur=24&nbrstations=3&ong=2"
NIVEAU=$(curl -s "$URLNIVEAU" | grep titre_cadre | awk -F ">|<" '{print $31}')
#Url debit eau
URLDEBIT="http://www.vigicrues.gouv.fr/niveau3.php?CdStationHydro=$STATION&typegraphe=q&AffProfondeur=24&nbrstations=3&ong=2"
DEBIT=$(curl -s "$URLDEBIT" | grep titre_cadre | awk -F ">|<" '{print $31}')

URLHAUTEUR="http://$SERVER/json.htm?type=command&param=udevice&idx=$HIDX&svalue=$NIVEAU"
URLSPEED="http://$SERVER/json.htm?type=command&param=udevice&idx=$SIDX&svalue=$DEBIT"
curl -s $URLHAUTEUR > /dev/null
curl -s $URLSPEED > /dev/null
