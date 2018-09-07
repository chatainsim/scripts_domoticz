-- Source: https://www.domoticz.com/forum/viewtopic.php?t=23460#p180690
return {
    on = {  timer =                { "at 00:01" },  
            devices = {             "Pluviometre"     } },                             -- Your switch device triggered by ESP bucket full

            logging = {     level = domoticz.LOG_DEBUG,                                  -- INFO, ERROR or DEBUG
                            marker = "RainFall" },                                            -- 

    execute = function(dz, trigger)
               
        local rainDevice    = dz.devices("Pluie")                                     -- Your (virtual) rain device
        local rainSwitch   = dz.devices("Pluviometre")                                     -- Your (triggered by bucket full) switch 
        local rainmm        = 0.2794                                                                 -- find out what 1 bucket full means in terms of mm 
        local rainTotal     = 0
        local timeSlice     = math.min( (rainDevice.lastUpdate.secondsAgo / 3600), 10) -- at least 1 bucket  in 10 hours     
        
        local rainAmountHour = dz.utils.round((rainmm / timeSlice),1)
        
        -- Calc raintotal and reset raintotal at midnight
        if trigger.isTimer then 
            rainDevice.updateRain(dz.utils.round(rainDevice.rainRate,0),0)                     -- reset rainTotal
            rainSwitch.switchOff().silent()
            dz.log("Reset raintotal to 0",dz.log_DEBUG)
        else        
            rainTotal = dz.utils.round((rainmm + rainDevice.rain),1)  
            rainDevice.updateRain(rainAmountHour,rainTotal)           
            dz.log("One bucket full ==>> updating raindevice. rainrate: " .. rainAmountHour .. " mm/hr, " .. rainTotal .." mm in total today "  ,dz.log_DEBUG)
            rainSwitch.switchOff().silent()
        end
    end
 }
