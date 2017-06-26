-- Source: https://www.domoticz.com/wiki/Event_script_examples#Send_a_warning_when_the_garage_door_has_been_open_for_more_than_10_minutes
t1 = os.time()
s = otherdevices_lastupdate['Xiaomi Door Sensor']
frigo = otherdevices_lastupdate['Xiaomi Door Frigo']
balcon = otherdevices_lastupdate['Porte Balcon']
-- Xiaomi Door Frigo
-- returns a date time like 2013-07-11 17:23:12
 
year = string.sub(s, 1, 4)
month = string.sub(s, 6, 7)
day = string.sub(s, 9, 10)
hour = string.sub(s, 12, 13)
minutes = string.sub(s, 15, 16)
seconds = string.sub(s, 18, 19)

fyear = string.sub(frigo, 1, 4)
fmonth = string.sub(frigo, 6, 7)
fday = string.sub(frigo, 9, 10)
fhour = string.sub(frigo, 12, 13)
fminutes = string.sub(frigo, 15, 16)
fseconds = string.sub(frigo, 18, 19)

byear = string.sub(frigo, 1, 4)
bmonth = string.sub(frigo, 6, 7)
bday = string.sub(frigo, 9, 10)
bhour = string.sub(frigo, 12, 13)
bminutes = string.sub(frigo, 15, 16)
bseconds = string.sub(frigo, 18, 19)

commandArray = {}
t4= os.time{year=byear, month=bmonth, day=bday, hour=bhour, min=bminutes, sec=bseconds}
t3 = os.time{year=fyear, month=fmonth, day=fday, hour=fhour, min=fminutes, sec=fseconds}
t2 = os.time{year=year, month=month, day=day, hour=hour, min=minutes, sec=seconds}
difference = (os.difftime (t1, t2))
difference1 = (os.difftime (t1, t3))
if (otherdevices['Xiaomi Door Sensor'] == 'Open' and difference > 600 and difference < 700 and uservariables['doorentree'] == '0') then
   commandArray['SendNotification']='Door alert#The door has been open for more than 10 minutes!'
   commandArray['Variable:doorentree']='1'
   print("Door Entree opened")
elseif (otherdevices['Xiaomi Door Sensor'] == 'Closed' and uservariables["doorentree"] == '1') then
    commandArray['Variable:doorentree']='0'
    print("Door Entree closed")
end
if (otherdevices['Xiaomi Door Frigo'] == 'Open' and difference1 > 120 and difference1 < 140 and uservariables['doorfrigo'] == '0') then
   commandArray['SendNotification']='Fridge alert#The fridge has been open for more than 2 minutes!'
   commandArray['Variable:doorfrigo']='1'
   print("Door Frigo opened")
elseif (otherdevices['Xiaomi Door Frigo'] == 'Closed' and uservariables["doorfrigo"] == '1') then
    commandArray['Variable:doorfrigo']='0'
    print("Door Frigo closed")
end
if (otherdevices['Porte Balcon'] == 'Open' and difference1 > 600 and difference1 < 700 and uservariables['doorbalcon'] == '0') then
   commandArray['SendNotification']='Balcon alert#The balcon has been open for more than 10 minutes!'
   commandArray['Variable:doorbalcon']='1'
   print("Door balcon opened")
elseif (otherdevices['Porte Balcon'] == 'Closed' and uservariables["doorbalcon"] == '1') then
    commandArray['Variable:doorbalcon']='0'
    print("Door Frigo closed")
end



return commandArray
