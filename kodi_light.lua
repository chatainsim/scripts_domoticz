commandArray = {}
-- If Kodi play a video and it's day time then we turn off the light
if (devicechanged['Kodi'] == 'Video' and timeofday['Daytime']) then
    commandArray['Spot RF']='Off'
    commandArray['YeeLight LED (Color)']='Off'
    commandArray['RubanLed']='Off'
-- If Kodi play a video and it's night time, then we update a variable then turn off the light
elseif (devicechanged['Kodi'] == 'Video' and timeofday['Nighttime']) then
    commandArray['Variable:kodilight']='0'
    commandArray['Spot RF']='Off'
    commandArray['YeeLight LED (Color)']='Off'
    commandArray['RubanLed']='Off'
-- If Kodi is paused or you stop the video playback then only if the user variable is set to 0 we turn one light on
elseif (devicechanged['Kodi'] == 'On' or devicechanged['Kodi'] == 'Paused') then
    if (timeofday['Nighttime'] and uservariables['kodilight'] == '0') then
        commandArray['Spot RF']='On'
        commandArray['Variable:kodilight']='1'
    end
-- If TV ping is KO, the TV switch turn off then it turn off the light
elseif (devicechanged['TV Sony'] == 'Off') then 
    commandArray['Spot RF']='Off'
end

return commandArray
