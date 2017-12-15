-- ##### Configuration start here ####
nowday = os.date("%w")
-- Define morning hour
if (nowday == 0 or nowday == 6) then
    morning = 10
else
    morning = 6
end
-- Define night hour
night = 22
nolight = 1
-- Define motion sensor
local motion_sensor  = 'Xiaomi Motion Sensor Entree'
-- Define light bulb
local light_bulb = 'YeelightWhite'
-- To turn debug on set to true
debug=false
-- #### Configuration stop here ####

s = otherdevices_lastupdate[motion_sensor]
time = os.date("*t")
t1 = os.time()
year = string.sub(s, 1, 4)
month = string.sub(s, 6, 7)
day = string.sub(s, 9, 10)
hour = string.sub(s, 12, 13)
minutes = string.sub(s, 15, 16)
seconds = string.sub(s, 18, 19)

commandArray = {}
    t2 = os.time{year=year, month=month, day=day, hour=hour, min=minutes, sec=seconds}
    difference = (os.difftime (t1, t2))
    if (devicechanged[motion_sensor] == 'On') then
        if (debug) then print("Motion on") end
        if (otherdevices[light_bulb] == 'Off') then
            if (time.hour < morning and time.hour < nolight or time.hour > night and time.hour < nolight) then
                if (debug) then print('its nighttime') end
                commandArray[1]={[light_bulb]='On'}
                commandArray[2]={[light_bulb]='Set Level 1'}
            elseif (time.hour > morning and time.hour < nolight or time.hour < night and time.hour > morning ) then
                if (debug) then print('its daytime') end
                commandArray[1]={[light_bulb]='On'}
                commandArray[2]={[light_bulb]='Set Level 40'}
            end
        end
    end
    if ((otherdevices[light_bulb] == 'On' or otherdevices[light_bulb] == 'Set Level') and otherdevices[motion_sensor] == 'Off' and difference > 30) then
        if (debug) then print('Turning ' .. light_bulb .. ' Off after '..difference..'.') end
        commandArray[light_bulb]='Off'
    end
return commandArray
