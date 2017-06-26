commandArray = {}

if (devicechanged['Kodi'] == 'Video' and timeofday['Daytime']) then
    commandArray['Spot RF']='Off'
    commandArray['YeeLight LED (Color)']='Off'
    commandArray['RubanLed']='Off'
elseif (devicechanged['Kodi'] == 'Video' and timeofday['Nighttime']) then
    commandArray['Variable:kodilight']='0'
    commandArray['Spot RF']='Off'
    commandArray['YeeLight LED (Color)']='Off'
    commandArray['RubanLed']='Off'
elseif (devicechanged['Kodi'] == 'On' or devicechanged['Kodi'] == 'Paused') then
    if (timeofday['Nighttime'] and uservariables['kodilight'] == '0') then
        commandArray['Spot RF']='On'
        commandArray['Variable:kodilight']='1'
    end
elseif (devicechanged['TV Sony'] == 'Off') then 
    commandArray['Spot RF']='Off'
end

return commandArray
