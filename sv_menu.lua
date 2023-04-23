ESX = exports["es_extended"]:getSharedObject()


ESX.RegisterServerCallback("krs:checkgroup", function(source, cb)
    local player = ESX.GetPlayerFromId(source)

    if player ~= nil then
        local playerGroup = player.getGroup()

        if playerGroup ~= nil then 
            cb(playerGroup)
        else
            cb("user")
        end
    else
        cb("user")
    end
end)

RegisterServerEvent('krs:setVehicle')
AddEventHandler('krs:setVehicle', function (vehicleProps, playerID, VehicleType, plate)
	local _source = playerID
	local xPlayer = ESX.GetPlayerFromId(_source)
    local Trigger = ESX.GetPlayerFromId(source)


    if Permission(Trigger) then
        MySQL.Sync.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, stored, type) VALUES (@owner, @plate, @vehicle, @stored, @type)',
        {
            ['@owner']   = xPlayer.identifier,
            ['@plate']   = vehicleProps.plate,
            ['@vehicle'] = json.encode(vehicleProps),
            ['@stored']  = 1,
            ['@state']   = 0,
            ['type'] = VehicleType
        }, function ()
        end)
    else
       
    end
end)

RegisterServerEvent('krs:handcuff')
AddEventHandler('krs:handcuff', function(target)
	local fascetta = exports.ox_inventory:GetItem(source, 'fascetta', nil, false)
	if handcuffed[target] == false or handcuffed[target] == nil then
		if fascetta.count > 0 then
			TriggerClientEvent('krs:handcuff1', target, source)
			TriggerClientEvent('krs:handcuff2', source)
		else
			TriggerClientEvent('esx:showNotification', source,'Non hai le fascette')
		end
	elseif handcuffed[target] == true then
		TriggerClientEvent('krs:uncuff', target)	
	end
end)


RegisterServerEvent('krs:uncuff')
AddEventHandler('krs:uncuff', function(target)
	local fascetta = exports.ox_inventory:GetItem(source, 'fascetta', nil, false)
	if handcuffed[target] == false or handcuffed[target] == nil then
		if fascetta.count > 0 then
			handcuffed[target] = true
			TriggerClientEvent('krs:handcuff1', target, source)
			TriggerClientEvent('krs:handcuff2', source)
		else
			TriggerClientEvent('esx:showNotification', source,'Non hai le fascette')
		end
	elseif handcuffed[target] == true then
		handcuffed[target] = false
		TriggerClientEvent('krs:uncuff', target)
		TriggerClientEvent('krs:handcuff2', source)
	end
end)

RegisterServerEvent('krs:drag')
AddEventHandler('krs:drag', function(target)
  local _source = source
  TriggerClientEvent('krs:drag', target, _source)
end)

RegisterServerEvent('krs:putInVehicle')
AddEventHandler('krs:putInVehicle', function(target)
  TriggerClientEvent('krs:putInVehicle', target)
end)

RegisterServerEvent('krs:OutVehicle')
AddEventHandler('krs:OutVehicle', function(target)
    TriggerClientEvent('krs:OutVehicle', target)
end)


RegisterServerEvent('riparaveicolo:fixcar')
AddEventHandler('riparaveicolo:fixcar', function()
	local _source = source
	PlayersHarvesting2[_source] = true
	--TriggerClientEvent('esx:showNotification', _source, _U('recovery_repair_tools'))
	Harvest2(_source)
end)

RegisterServerEvent('riparaveicolo:fixcarstop')
AddEventHandler('riparaveicolo:fixcarstop', function()
	local _source = source
	PlayersHarvesting2[_source] = false
end)

