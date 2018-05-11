--Source : https://www.gadget-freakz.com/2018/05/script-your-dryver-or-washingmachine/
--Change the values below to reflect to your own setup
Script = 'script_time_wasmachine'
Debug = 'Y'
-- Functions
function Debug_msg (msg)
if (Debug == 'Y') then print('>> ' .. Script .. ': '.. msg) end
end

-- Variable
local washer_status_uservar = 'washingmachine_status'
local energy_consumption = 'Zwave LaveLinge' --Name of Z-Wave plug that contains actual consumption of washingmachine (in Watts)
local washer_counter_uservar = 'washingmachine_counter' --Name of the uservariable that will contain the counter that is needed
local idle_minutes = 5 --The amount of minutes the consumption has to stay below the 'consumption_lower' value
local consumption_upper = 20 --If usage is higher than this value (Watts), the washingmachine has started
local consumption_lower = 4.3 --If usage is lower than this value (Watts), the washingmachine is idle for a moment/done washing
-- sWatt, sTotalkWh = otherdevices_svalues['Clothes Washer Power Usage']:match("([^;]+);([^;]+)")
-- washer_usage = tonumber(sWatt)
washer_usage = tonumber(otherdevices_svalues[energy_consumption])

commandArray = {}

--Virtual switch is off, but consumption is higher than configured level, so washing has started
if (washer_usage > consumption_upper) and uservariables[washer_status_uservar] == 0 then
commandArray['Variable:' .. washer_status_uservar]='1'
Debug_msg('Current power usage (' ..washer_usage.. 'W) is above upper boundary (' ..consumption_upper.. 'W), so washing has started!')
commandArray['Variable:' .. washer_counter_uservar]=tostring(idle_minutes)
end

--Washing machine is not using a lot of energy, check the counter
if (washer_usage < consumption_lower) and uservariables[washer_status_uservar] == 1 then
commandArray['Variable:' .. washer_counter_uservar]=tostring(math.max(tonumber(uservariables[washer_counter_uservar]) - 1, 0))
Debug_msg('Current power usage (' ..washer_usage.. 'W) is below lower boundary (' ..consumption_lower.. 'W), washer is idle or almost ready')
Debug_msg('Subtracting counter, old value: ' ..uservariables[washer_counter_uservar].. ' minutes')
elseif ((uservariables[washer_counter_uservar] ~= idle_minutes) and uservariables[washer_status_uservar] == 1) then
commandArray['Variable:' .. washer_counter_uservar]=tostring(idle_minutes)
print('Resetting Washing Machine Timer')
end

--Washingmachine is done
if ((uservariables[washer_status_uservar] == 1) and uservariables[washer_counter_uservar] == 0) then
Debug_msg('Washingmachine is DONE')
Debug_msg('Current power usage washingmachine ' ..washer_usage.. 'W')
Debug_msg('Washingmachine is done, please go empty it!')
commandArray['SendNotification']='Cycle Ended: Washing Machine#The load in the washing machine has finsihed, please move it to the dryer!#0'
commandArray['Variable:' .. washer_status_uservar]='0'
end

return commandArray
