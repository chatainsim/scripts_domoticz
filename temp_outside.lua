local function round(num, n)
  local mult = 10^(n or 0)
  return math.floor(num * mult + 0.5) / mult
end

commandArray = {}
if (devicechanged['Temperature balcon']) then
    if ((tonumber(otherdevices_temperature['Temperature balcon']) > tonumber(otherdevices_temperature['Temperature Salon'])) and uservariables['notifsalon'] == '0') then
        commandArray['SendEmail']='Temperature Balcon#La temperature du Balcon '..round(otherdevices_temperature['Temperature balcon'],2)..'°c est plus elevee que la temperature du Salon '..round(otherdevices_temperature['Temperature Salon'],2)..'°c.#adresse@mail.com'
        commandArray['Variable:notifsalon']='1'
    elseif ((tonumber(otherdevices_temperature['Temperature balcon']) < tonumber(otherdevices_temperature['Temperature Salon'])) and uservariables['notifsalon'] == '1') then
        commandArray['SendEmail']='Temperature Balcon#La temperature du Balcon '..round(otherdevices_temperature['Temperature balcon'],2)..'°c est plus basse que la temperature du Salon '..round(otherdevices_temperature['Temperature Salon'],2)..'°c.#adresse@mail.com'
        commandArray['Variable:notifsalon']='0'
    end
end
return commandArray
