-- Parameters to change according to you needs
debug=false
-- Json config loadfile
config = '/opt/domoticz/scripts/vigicrue.json'
-- for Windows
-- config = 'C:\\Program Files (x86)\\Domoticz\\scripts\\vigicrue.json'
-- JSON.lua path
json = (loadfile "/opt/domoticz/scripts/lua/JSON.lua")()
-- for Windows
--json = (loadfile "C:\\Program Files (x86)\\Domoticz\\scripts\\lua\\JSON.lua")()
-- Curl path
curl = '/usr/bin/curl'
-- for Windows
-- curl = 'C:\\cygwin\\bin\\curl'
-- End of parameters

time = os.date("*t")

-- Function to update sensor
local function update(idx, value1)
    local cmd = idx..'|0|'..value1
    --print(cmd)
    table.insert (commandArray, { ['UpdateDevice'] = cmd } )
end
local function sendnotif(station, result, type, channel)
    if (type == "height") then
        local cmd = 'Water level is high for station '..station..'#Current level is '..result..'m for'..station..'#0#sound#extradata#'..channel
        if (debug) then print("NotifHeight: "..cmd) end
    elseif (type == "speed") then
        local cmd = 'Water speed level is high for station '..station..'#Current speed level: '..result..'m3/s for '..station..'#0#sound#extradata#'..channel
        if (debug) then print("NotifSpeed: "..cmd) end
    end
    table.insert (commandArray, { ['SendNotification'] = "cmd" } )
    if (debug) then print("Notif: Sent") end
end
-- function to get data from url
local function getdata(urlh,urls)
    local DataHeight = assert(io.popen(curl..' -s "'..urlh..'"'))
    local BlocJsonHeight = DataHeight:read('*all')
    DataHeight:close()
    local JsonHeight = json:decode(BlocJsonHeight)
    local Height = JsonHeight.Serie.ObssHydro
    local Name = JsonHeight.Serie.LbStationHydro
    
    local DataSpeed = assert(io.popen(curl..' -s "'..urls..'"'))
    local BlocJsonSpeed = DataSpeed:read('*all')
    DataSpeed:close()
    local JsonSpeed = json:decode(BlocJsonSpeed)
    local Speed = JsonSpeed.Serie.ObssHydro
    
    return Height, Speed, Name
end
commandArray = {}
if (time.min == 0 or time.min == 30) then
    local file = assert(io.open(config, "r"))
    local json_text = file:read("*all")
    file:close()
    local Conf = json:decode(json_text)
    Station = Conf.station
    for k,v in pairs(Station) do
        local IDStation = v
        local IDXHeight = Conf.idx.height[v]
        local IDXSpeed = Conf.idx.speed[v]
        local NotifHeightV = Conf.notifications.height[v].value
        local NotifHeightA = Conf.notifications.height[v].active
        local NotifSpeedV = Conf.notifications.speed[v].value
        local NotifSpeedA = Conf.notifications.speed[v].active
        local urlHeight = 'https://www.vigicrues.gouv.fr/services/observations.json/index.php?CdStationHydro='..IDStation..'&GrdSerie=H&FormatSortie=simple'
        local urlSpeed = 'https://www.vigicrues.gouv.fr/services/observations.json/index.php?CdStationHydro='..IDStation..'&GrdSerie=Q&FormatSortie=simple'
        ResultHeight,ResultSpeed,StationName=getdata(urlHeight,urlSpeed)
        if (#ResultHeight ~= 0) then
                if (debug) then print("ResultHeight: "..ResultHeight[#ResultHeight][2]) end
                update(IDXHeight, ResultHeight[#ResultHeight][2])
                if (NotifHeightA == "true") then
                    if (tostring(ResultHeight[#ResultHeight][2]) > NotifHeightV) then
			sendnotif(StationName, ResultHeight[#ResultHeight][2], "height", NotifHeightC)
                    end
                end
        else
                if (debug) then print('Height level is empty.') end
        end
        if (#ResultSpeed ~= 0) then
                if (debug) then print("ResultSpeed: "..ResultSpeed[#ResultSpeed][2]) end
                update(IDXSpeed, ResultSpeed[#ResultSpeed][2])
                if (NotifSpeedA == "true") then
                    if (tostring(ResultSpeed[#ResultSpeed][2]) > NotifSpeedV) then
			sendnotif(StationName, ResultSpeed[#ResultSpeed][2], "speed", NotifSpeedC)
                    end
                end
        else
                if (debug) then print('Speed is empty.') end
        end

    end
end

return commandArray

