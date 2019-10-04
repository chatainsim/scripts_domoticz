-- Parameters to change according to you needs
debug=false
-- Station ID, from one to many
Station = {'W141001001', 'L800001020'}
-- IDX of sensor for height value | STATION_ID='IDX_SENSOR'
SIDXHeight = {W141001001='215', L800001020='218'}
-- IDX of sensor for speed value | STATION_ID='IDX_SENSOR'
SIDXSpeed = {W141001001='216', L800001020='217'}
-- JSON.lua path
json = (loadfile "/opt/domoticz/scripts/lua/JSON.lua")()
-- Curl path
curl = '/usr/bin/curl'
-- End of parameters

time = os.date("*t")
-- Function to update sensor
local function update(idx, value1)
    local cmd = idx..'|0|'..value1
    --print(cmd)
    table.insert (commandArray, { ['UpdateDevice'] = cmd } )
end
-- function to get data from url
local function getdata(urlh,urls)
    local DataHeight = assert(io.popen(curl..' -s "'..urlh..'"'))
    local BlocJsonHeight = DataHeight:read('*all')
    DataHeight:close()
    local JsonHeight = json:decode(BlocJsonHeight)
    local Height = JsonHeight.Serie.ObssHydro
    
    local DataSpeed = assert(io.popen(curl..' -s "'..urls..'"'))
    local BlocJsonSpeed = DataSpeed:read('*all')
    DataSpeed:close()
    local JsonSpeed = json:decode(BlocJsonSpeed)
    local Speed = JsonSpeed.Serie.ObssHydro
    
    return Height, Speed
end
local function test_error(url)
    local DataTest = assert(io.popen(curl..' -s --max-time 8 "'..url..'"'))
    local BlocJsonTest = DataTest:read('*all')
    DataTest:close()
    JsonTest = json:decode(BlocJsonTest)
    Test = JsonTest[1].error_msg
end
commandArray = {}
if (time.min == 0 or time.min == 30) then
    for k,v in pairs(Station) do
        local IDStation = v
        local IDXHeight = SIDXHeight[v]
        local IDXSpeed = SIDXSpeed[v]
        local urlHeight = 'https://www.vigicrues.gouv.fr/services/observations.json/index.php?CdStationHydro='..IDStation..'&GrdSerie=H&FormatSortie=simple'
        local urlSpeed = 'https://www.vigicrues.gouv.fr/services/observations.json/index.php?CdStationHydro='..IDStation..'&GrdSerie=Q&FormatSortie=simple'
        local status, retval = pcall(test_error,urlHeight);
        if (status) then
            print("Error, station inconnu")
            commandArray['SendNotification']='subject#Erreur, station '..IDStation..' inconnu ou problème temporaire du site Vigicrue, merci de vérifier : '..urlHeight..'#0#sound#extradata#telegram'
        else
            ResultHeight,ResultSpeed=getdata(urlHeight,urlSpeed)
 
            if (#ResultHeight ~= 0) then
                if (debug) then print("ResultHeight: "..ResultHeight[#ResultHeight][2]) end
                update(IDXHeight, ResultHeight[#ResultHeight][2])
            else
                if (debug) then print('Height level is empty.') end
            end
            if (#ResultSpeed ~= 0) then
                if (debug) then print("ResultSpeed: "..ResultSpeed[#ResultSpeed][2]) end
                update(IDXSpeed, ResultSpeed[#ResultSpeed][2])
            else
                if (debug) then print('Speed is empty.') end
            end
        end
    end
end

return commandArray
