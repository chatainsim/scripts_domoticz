-- Website: https://domo.easter.fr/2017/06/26/kodi-lumieres-tv-et-domoticz/
commandArray = {}
    if (devicechanged['Kodi'] == 'Video') then
        commandArray['Spot RF']='Off'
        commandArray['YeeLight LED (Color)']='Off'
        commandArray['RubanLed']='Off'
    elseif ((devicechanged['Kodi'] == 'On' or devicechanged['Kodi'] == 'Paused') and timeofday['Nighttime']) then
        commandArray['Spot RF']='On'
    elseif (devicechanged['TV Sony'] == 'Off' and otherdevices['Spot RF'] == 'On') then 
        commandArray['Spot RF']='Off'
    end
return commandArray
