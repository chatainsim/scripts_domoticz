-- ##### Configuration start here ####
-- Time when the script will start turning on the light on the morning
-- For weekday, here at 6AM
weekday = 6
-- For weekend days, here at 9AM
weekend = 9
-- Define night hour when the light will be less bright
night = 21
-- Define when the no light time
-- Here, the light won't be turn on between 1AM and 6AM or 9AM
nolight = 1
-- Define motion sensor name
local motion_sensor  = 'Xiaomi Motion Sensor Entree'
-- Define light bulb name
local light_bulb = 'Hue white lamp 1'
-- If it's a Hue light set the hue variable to true
hue = true
-- If it's a hue light then define "Bright Scene" switch (for day) and "Attenuated Scene" switch (for night) variable
brightscene = 'Scene Lumineux Entree'
attenuated = 'Scene Attenue Entree'
-- To turn debug on set to true
debug=false
-- #### Configuration stop here ####

nowday = os.date("%w")
-- Define morning hour for week days and weekend
if (nowday == 0 or nowday == 6) then
    -- Weekend
    morning = weekend
else
    -- Week days
    morning = weekday
end
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
            if (time.hour <= nolight or time.hour >= night) then
                if (debug) then print('its nighttime') end
                if (hue) then
                    commandArray[attenuated]='On'
                else
                    commandArray[1]={[light_bulb]='On'}
                    commandArray[2]={[light_bulb]='Set Level 1'}
                end
            elseif (time.hour <= night and time.hour >= morning ) then
                if (debug) then print('its daytime') end
                if (hue) then
                    commandArray[brightscene]='On'
                else
                    commandArray[1]={[light_bulb]='On'}
                    commandArray[2]={[light_bulb]='Set Level 75'}
                end
            end
        end
    end
    if (devicechanged[motion_sensor] == 'Off' and uservariables['WhiteAlways'] == '0' and (otherdevices[light_bulb] ~= 'Off' or otherdevices[brightscene] == 'On' or otherdevices[attenuated] == 'On')) then
        if (debug) then print('Turning ' .. light_bulb .. ' Off.') end
        commandArray[light_bulb]='Off'
    end
return commandArray
