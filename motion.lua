t1 = os.time()
s = otherdevices_lastupdate['Xiaomi Motion Sensor Entree']

year = string.sub(s, 1, 4)
month = string.sub(s, 6, 7)
day = string.sub(s, 9, 10)
hour = string.sub(s, 12, 13)
minutes = string.sub(s, 15, 16)
seconds = string.sub(s, 18, 19)

debug=true

commandArray = {}
    t2 = os.time{year=year, month=month, day=day, hour=hour, min=minutes, sec=seconds}
    difference = (os.difftime (t1, t2))
    if (devicechanged['Xiaomi Motion Sensor Entree'] == 'On') then
        if (debug) then
            print("Motion on")
        end
        if (otherdevices['YeelightWhite'] == 'Off') then
            if (timeofday['Nighttime']) then
                if (debug) then
                    print('its nighttime')
                end
                commandArray[1]={['YeelightWhite']='On'}
                commandArray[2]={['YeelightWhite']='Set Level 25'}
                --commandArray['YeelightWhite']='On'
            else
                if (debug) then
                    print('its daytime')
                end
                commandArray[1]={['YeelightWhite']='On'}
                commandArray[2]={['YeelightWhite']='Set Level 50'}
            end
        end
    end
    if ((otherdevices['YeelightWhite'] == 'On' or otherdevices['YeelightWhite'] == 'Set Level') and otherdevices['Xiaomi Motion Sensor Entree'] == 'Off' and difference > 30) then
        if (debug) then
            print('Turning YeelightWhite Off after '..difference..'.')
        end
        commandArray['YeelightWhite']='Off'
    end
    --yeewhite
    -- Control pour allumage manuel sans Motion
return commandArray
