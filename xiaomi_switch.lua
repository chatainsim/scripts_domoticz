commandArray = {}

-- Commande Selector Switch
    if (devicechanged['Xiaomi Switch Micro-onde'] == 'Click') then
        print("MicroOnde: Click ON for 10s")
        commandArray['Xiaomi Switch Micro-onde']='Off'
        commandArray[1]={['Xiaomi Smart Plug']='On'}
        commandArray[2]={['Xiaomi Smart Plug']='Off AFTER 10'}
    end

    if (devicechanged['Xiaomi Switch Micro-onde'] == 'Double Click') then
        print("MicroOnde: Double Click ON for 30s")
        commandArray['Xiaomi Switch Micro-onde']='Off'
        commandArray[1]={['Xiaomi Smart Plug']='On'}
        commandArray[2]={['Xiaomi Smart Plug']='Off AFTER 30'}
    end
    
    if (devicechanged['Xiaomi Switch Micro-onde'] == 'Long Click' ) then
        print("MicroOnde: Long Click ON for 2m")
        commandArray['Xiaomi Switch Micro-onde']='Off'
        commandArray['Xiaomi Smart Plug']='On FOR 2'
    end

return commandArray
