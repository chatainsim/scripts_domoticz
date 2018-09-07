-- otherwise sends a notification to tell us to go check the lost one.
-- https://www.domoticz.com/forum/viewtopic.php?f=15&t=9711&p=112074#p112074


-- 1 hour = 3600 seconds
-- 1 day = 86400
-- 7 days = 604800

index=1
now = os.time()

print("[Check_Sensor_Battery] Checking for last sensor updates")


local tableDeviceToCheck = {    -- timeout for each  device, in seconde.
  ["Congélateur"]=172800, -- 2 days
  ["Salle de bain"]=172800, -- 2 days
  ["Cuisine"]=172800, -- 2 days
  ["Frigo"]=172800, -- 2 days
}

commandArray={}

date = os.date("*t")
if date.hour==18 and date.min==30 then

    for deviceName, deviceTimeOut in pairs(tableDeviceToCheck) do
   
        s = otherdevices_lastupdate[deviceName]
        year = string.sub(s, 1, 4)
        month = string.sub(s, 6, 7)
        day = string.sub(s, 9, 10)
        hour = string.sub(s, 12, 13)
        minutes = string.sub(s, 15, 16)
        seconds = string.sub(s, 18, 19)
        lastAlive = os.time{year=year, month=month, day=day, hour=hour, min=minutes, sec=seconds}
        
        tijd = now - lastAlive
        print(deviceName .." "..tijd.. ' secondes sans réponse, valeur limite ='..deviceTimeOut)
   
        -- If not seen since timeout, send an email
        if (lastAlive + deviceTimeOut) < now then
            commandArray[index]={['SendNotification']='Le Device '..deviceName..' ne répond plus depuis '..s..' secondes. Batterie vide?'}
            print("[Check_Sensor_Battery] Sending alert for device "..deviceName..' not seen for '..s..' seconds. Batery maybe down.')
            index = index + 1
        end
    end
end
return commandArray
