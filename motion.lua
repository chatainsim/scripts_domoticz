-- Get current time
t1 = os.time()
-- Get time/date of last update on motion sensor - Change 'Xiaomi Motion Sensor Entree' to your motion sensor name
s = otherdevices_lastupdate['Xiaomi Motion Sensor Entree']

-- Cut data returned with the last update on motion sensor to get individual values
-- Source: https://www.domoticz.com/wiki/Event_script_examples#Send_a_warning_when_the_garage_door_has_been_open_for_more_than_10_minutes
year = string.sub(s, 1, 4)
month = string.sub(s, 6, 7)
day = string.sub(s, 9, 10)
hour = string.sub(s, 12, 13)
minutes = string.sub(s, 15, 16)
seconds = string.sub(s, 18, 19)

-- Set to false to disable print
debug=true

commandArray = {}
    -- Convert cut data to time format
    t2 = os.time{year=year, month=month, day=day, hour=hour, min=minutes, sec=seconds}
    -- Difference between current time and last update on motion sensor
    difference = (os.difftime (t1, t2))
    -- If motion sensor status change to 'On'
    if (devicechanged['Xiaomi Motion Sensor Entree'] == 'On') then
        if (debug) then
            print("Motion on")
        end
        -- If the wifi bulb is 'Off' - Change 'YeelightWhite' with your switch name
        if (otherdevices['YeelightWhite'] == 'Off') then
            -- If it's the night we set the light less brighter
            if (timeofday['Nighttime']) then
                if (debug) then
                    print('its nighttime')
                end
                -- Turn on the light and set brighter level - Change bulb name too
                commandArray[1]={['YeelightWhite']='On'}
                commandArray[2]={['YeelightWhite']='Set Level 25'}
                --commandArray['YeelightWhite']='On'
            else
                if (debug) then
                    print('its daytime')
                end
                -- It's day time so let the bulb be much brighter - Change the name of the bulb
                commandArray[1]={['YeelightWhite']='On'}
                commandArray[2]={['YeelightWhite']='Set Level 50'}
            end
        end
    end
    -- If the bulb is 'On' OR the bulb is set to a certain level AND the motion sensor is 'Off' AND difference between current time and last update on motion sensor THEN turn of the light
    -- Change bulb and motion sensor name's
    -- Keep in mine that the bulb will be turn off after the time motion sensor turn off + the time you define with difference > 60
    -- For exemple my motion sensor turn off after 120 seconds, so add the 60 and the bulb will turn off after 120+60 = 180seconds
    if ((otherdevices['YeelightWhite'] == 'On' or otherdevices['YeelightWhite'] == 'Set Level') and otherdevices['Xiaomi Motion Sensor Entree'] == 'Off' and difference > 30) then
        if (debug) then
            print('Turning YeelightWhite Off after '..difference..'.')
        end
        -- Turn off the bulb - Change the name
        commandArray['YeelightWhite']='Off'
    end
return commandArray
