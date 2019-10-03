OctoIP='OctoprintIP'
OctoAPI='YourOctoprintAPIKey'
-- JSON.lua path
json = (loadfile "/home/pi/domoticz/scripts/lua/JSON.lua")()
-- Curl path
curl = '/usr/bin/curl'

-- IDX of your Dummy Devices
OctoStatusIDX='387' -- Text
OctoBebIDX='388' -- Temperature
OctoHeadIDX='389' -- Temperature
OctoTotalTimeIDX='390' -- Text
OctoCompleteIDX='391' -- Percentage
OctoPrintTimeIDX='392' -- Text
OctoTimeLeftIDX='393' -- Text

OctoPrinter='http://'..OctoIP..'/api/printer'
OctoJob='http://'..OctoIP..'/api/job'

local function update(idx, value1)
    local cmd = idx..'|0|'..value1
    --print(cmd)
    table.insert (commandArray, { ['UpdateDevice'] = cmd } )
end
local function round(num, n)
  local mult = 10^(n or 0)
  return math.floor(num * mult + 0.5) / mult
end
function SecondsToClock(seconds)
  local seconds = tonumber(seconds)

  if seconds <= 0 then
    return "00:00:00";
  else
    hours = string.format("%02.f", math.floor(seconds/3600));
    mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
    secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
    return hours..":"..mins..":"..secs
  end
end
commandArray = {}
  DataOctoTemp = assert(io.popen(curl..' -s --max-time 8 -H "X-Api-Key: '..OctoAPI..'" "'..OctoPrinter..'"'))
  BlocOctoTemp = DataOctoTemp:read('*all')
  DataOctoTemp:close()
  JsonOctoTemp = json:decode(BlocOctoTemp)
  OctoBeb = JsonOctoTemp.temperature.bed.actual
  OctoHead = JsonOctoTemp.temperature.tool0.actual
  OctoStatus = JsonOctoTemp.state.text
  update(OctoBebIDX, OctoBeb)
  update(OctoHeadIDX, OctoHead)
  update(OctoStatusIDX, OctoStatus)
  
  DataOctoTime = assert(io.popen(curl..' -s --max-time 8 -H "X-Api-Key: '..OctoAPI..'" "'..OctoJob..'"'))
  BlocOctoTime = DataOctoTime:read('*all')
  DataOctoTime:close()
  JsonOctoTime = json:decode(BlocOctoTime)
  OctoTotalTime = JsonOctoTime.job.estimatedPrintTime
  OctoComplete = JsonOctoTime.progress.completion
  OctoPrintTime = JsonOctoTime.progress.printTime
  OctoTimeLeft = JsonOctoTime.progress.printTimeLeft
  update(OctoTotalTimeIDX, SecondsToClock(OctoTotalTime))
  update(OctoCompleteIDX, round(OctoComplete))
  update(OctoPrintTimeIDX, SecondsToClock(OctoPrintTime))
  update(OctoTimeLeftIDX, SecondsToClock(OctoTimeLeft))
  
return commandArray
