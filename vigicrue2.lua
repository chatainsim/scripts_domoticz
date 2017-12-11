-- Parameters to change according to you needs
debug=false
-- Station ID, from one to many
Station = {'W141001001', 'L800001020'}
-- IDX of sensor for height value | STATION_ID='IDX_SENSOR'
SIDXHeight = {W141001001='215', L800001020='218'}
-- IDX of sensor for speed value | STATION_ID='IDX_SENSOR'
SIDXSpeed = {W141001001='216', L800001020='217'}
-- End of parameters

json = (loadfile "/opt/domoticz/scripts/lua/JSON.lua")()
time = os.date("*t")
-- Function to update sensor
local function update(idx, value1)
    local cmd = idx..'|0|'..value1
    print(cmd)
    table.insert (commandArray, { ['UpdateDevice'] = cmd } )
end
-- function to get data from url
local function getdata(urlh,urls)
    local DataHeight = assert(io.popen('/usr/bin/curl "'..urlh..'"'))
    local BlocJsonHeight = DataHeight:read('*all')
    DataHeight:close()
    local JsonHeight = json:decode(BlocJsonHeight)
    local Height = JsonHeight.Serie.ObssHydro
    
    local DataSpeed = assert(io.popen('/usr/bin/curl "'..urls..'"'))
    local BlocJsonSpeed = DataSpeed:read('*all')
    DataSpeed:close()
    local JsonSpeed = json:decode(BlocJsonSpeed)
    local Speed = JsonSpeed.Serie.ObssHydro
    
    return Height, Speed
end
commandArray = {}
if ((time.min == 0 or time.min == 30) and time.sec == 0) then
    for k,v in pairs(Station) do
        local IDStation = v
        local IDXHeight = SIDXHeight[v]
        local IDXSpeed = SIDXSpeed[v]
        local urlHeight = 'https://www.vigicrues.gouv.fr/services/observations.json/index.php?CdStationHydro='..IDStation..'&GrdSerie=H&FormatSortie=simple'
        local urlSpeed = 'https://www.vigicrues.gouv.fr/services/observations.json/index.php?CdStationHydro='..IDStation..'&GrdSerie=Q&FormatSortie=simple'
        ResultHeight,ResultSpeed=getdata(urlHeight,urlSpeed)
    
        update(IDXHeight, ResultHeight[#ResultHeight][2])
        update(IDXSpeed, ResultSpeed[#ResultSpeed][2])
        if (debug) then
            print("ResultHeight: "..ResultHeight[#ResultHeight][2])
            print("ResultSpeed: "..ResultSpeed[#ResultSpeed][2])
        end
        --print(v)
    end
end

return commandArray
