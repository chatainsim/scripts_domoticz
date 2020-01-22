-- Use Lua -> Time
-- For displaying debug messages
debug=false
-- IP address of octoprint 
OctoIP='OctoprintIPAddress'
-- Port of Octoprint - Default 80
OctoPort='80'
-- Octoprint API Key (found in Settings -> API)
OctoAPI='OctoprintAPIKey'
-- JSON.lua path
json = (loadfile "/home/pi/domoticz/scripts/lua/JSON.lua")()
-- Curl path
curl = '/usr/bin/curl'

-- IDX of your Dummy devices
OctoStatusIDX='387' -- type: Text
OctoBebIDX='388' -- type: Temperature
OctoHeadIDX='389' -- type: Temperature
OctoTotalTimeIDX='390' -- type: Text
OctoCompleteIDX='391' -- type: Percentage
OctoPrintTimeIDX='392' -- type: Text
OctoTimeLeftIDX='393' -- type: Text

-- If you don't have a heated bed, put this to false
HeatedBed=true

OctoPrinter='http://'..OctoIP..':'..OctoPort..'/api/printer'
OctoJob='http://'..OctoIP..':'..OctoPort..'/api/job'

local function update(idx, value1)
    local cmd = idx..'|0|'..value1
    table.insert (commandArray, { ['UpdateDevice'] = cmd } )
end
local function ping(OctoIP)
    ping_success=os.execute('ping -W2 -c1 '..OctoIP)
    return ping_success
end
local function online()
    DataOctoTemp = assert(io.popen(curl..' -s --max-time 8 -H "X-Api-Key: '..OctoAPI..'" "'..OctoPrinter..'"'))
    BlocOctoTemp = DataOctoTemp:read('*all')
    DataOctoTemp:close()
    JsonOctoTemp = json:decode(BlocOctoTemp)
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
    local status, retval = pcall(online,10);
if(ping(OctoIP)) then
    if (status) then
      DataOctoTemp = assert(io.popen(curl..' -s --max-time 8 -H "X-Api-Key: '..OctoAPI..'" "'..OctoPrinter..'"'))
      BlocOctoTemp = DataOctoTemp:read('*all')
      DataOctoTemp:close()
      JsonOctoTemp = json:decode(BlocOctoTemp)
      OctoBeb = JsonOctoTemp.temperature.bed.actual
      OctoHead = JsonOctoTemp.temperature.tool0.actual
      OctoStatus = JsonOctoTemp.state.text
      OctoState = JsonOctoTemp.state.flags.printing
      if (HeatedBed) then update(OctoBebIDX, OctoBeb) end
      update(OctoHeadIDX, OctoHead)
      update(OctoStatusIDX, OctoStatus)
      
      if (OctoState) then
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
      end
    else
      if (debug) then print("Printer not connected") end
      update(OctoStatusIDX, "Printer not connected")
      if (HeatedBed) then update(OctoBebIDX, 0) end
      update(OctoHeadIDX, 0)
      update(OctoTotalTimeIDX, SecondsToClock(0))
      update(OctoCompleteIDX, 0)
      update(OctoPrintTimeIDX, SecondsToClock(0))
      update(OctoTimeLeftIDX, SecondsToClock(0))
    end
else
    update(OctoStatusIDX, "Octoprint offline.")
end
return commandArray
