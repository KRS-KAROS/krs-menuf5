ESX = exports["es_extended"]:getSharedObject()

RegisterKeyMapping('menuf5','Apri Menu F5','KEYBOARD','F5')

RegisterCommand('menuf5', function()
    Menu()
end)
function Menu()
    lib.registerMenu({
        id = 'menuf5',
        title = 'Menu F5',
        position = 'top-left',
        options = {
            {label = 'Gestione Documenti'}, 
            {label = 'Gestione Fatture'}, 
            {label = 'Menu Criminale'},
            {label = 'Menu Gps'},
            {label = 'Menu Fps'},
            {label = 'Menu Amministrazione'},
        }
    }, function(selected)
        print(selected)
        if selected == 1 then 
            Documenti()
        elseif selected == 2 then
            TriggerEvent('esx:diocaneporco')
        elseif selected == 3 then
            MenuCriminale()
        elseif selected == 4 then
            MenuGps()
        elseif selected == 5 then
            MenuFps()
        elseif selected == 6 then
            ESX.TriggerServerCallback("krs:checkgroup", function(playerRank)
                if playerRank == "admin" or playerRank == "superadmin" then
                 MenuAdmin()
               else 
                  
               end
         end)
        end
    end)
        lib.showMenu('menuf5') 
end

function Documenti()
    lib.registerMenu({
        id = 'documenti',
        title = 'Menu title',
        position = 'top-left',
        options = {
            {label = "Lavoro Principale: " .. ESX.PlayerData.job.label .. " - ".. ESX.PlayerData.job.grade_label},
            {label = "Mostra Documenti"},
            {label = "Guarda Documenti"},
            {label = "Mostra Patente"},
            {label = "Guarda Patente"},
            {label = "Mostra Porto d'armi"},
            {label = "Guarda Porto d'armi"},
        }
    }, function(selected)
        print(selected)
        if selected == 1  then 
            ESX.ShowNotification('Seleziona il giocatore a cui vuoi mostrare la carta di identità')
			TriggerEvent("krs_targeting:beginTargeting", function(plyId)
				TriggerServerEvent('karos-documenti:apricazzo', GetPlayerServerId(PlayerId()), plyId)
			end, 2)
        elseif selected == 2  then
            ESX.ShowNotification('Seleziona il giocatore a cui vuoi mostrare la patente')
			TriggerEvent("krs_targeting:beginTargeting", function(plyId)
				TriggerServerEvent('karos-documenti:apricazzo', GetPlayerServerId(PlayerId()), plyId, 'driver')
			end, 2)
        elseif selected == 3  then
            TriggerServerEvent('karos-documenti:apricazzo', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
        elseif selected == 4 then
            TriggerServerEvent('karos-documenti:apricazzo', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
        elseif selected == 5  then 
            TriggerServerEvent('karos-documenti:apricazzo', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
        elseif selected == 6  then
            ESX.ShowNotification('Seleziona il giocatore a cui vuoi mostrare la patente')
            TriggerEvent("krs_targeting:beginTargeting", function(plyId)
                TriggerServerEvent('karos-documenti:apricazzo', GetPlayerServerId(PlayerId()), plyId, 'weapon')
            end, 2)
        elseif selected == 7  then
            TriggerServerEvent('karos-documenti:apricazzo', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
        end
    end)
    
        lib.showMenu('documenti') 
end



function MenuCriminale()
    lib.registerMenu({
        id = 'menucriminale',
        title = 'Menu F5',
        position = 'top-left',
        options = {
            {label = "Perquisisci"},
            {label = 'Ammanetta/Smanetta'},
            {label = 'Trascina'},
            {label = 'Metti nel Veicolo'},
            {label = 'Fai uscire dal Veicolo'},
        }
    }, function(selected)
        print(selected)
        if selected == 1 then
                if IsPedArmed(GetPlayerPed(-1), 7) then
                    TriggerEvent("ox_inventory:openInventory", "player", GetPlayerServerId(player))
                else
                    ESX.ShowNotification('Non sei Armato!')
                end 	
            elseif selected == 2 then
                TriggerServerEvent('krs:uncuff', GetPlayerServerId(player))             
            elseif selected == 3 then
                TriggerServerEvent('krs:drag', GetPlayerServerId(player))
          
                ESX.ShowNotification('Il giocatore deve essere ammanettato')
           	
            elseif selected == 4 then
                TriggerServerEvent('krs:putInVehicle', GetPlayerServerId(player))
           
                ESX.ShowNotification('Il giocatore deve essere ammanettato')
             	      
            elseif selected == 5 then
                  TriggerServerEvent('krs:OutVehicle', GetPlayerServerId(player)) 
                if IsEntityPlayingAnim(GetPlayerPed(player), "mp_arresting", "idle", 1) or IsEntityPlayingAnim(GetPlayerPed(player), "dead", "dead_a", 1) or IsEntityPlayingAnim(GetPlayerPed(player), 'missminuteman_1ig_2', 'handsup_base', 1) then
                    
                else
                    ESX.ShowNotification('Il giocatore deve avere le mani alzate') 
                end
              
        else
              ESX.ShowNotification('Nessun giocatore vicino')
        end
    end)
    
        lib.showMenu('menucriminale') 

end



local ped = PlayerPedId()

RegisterNetEvent('krs:handcuff1')
AddEventHandler('krs:handcuff1', function(target)
IsHandcuffed = true
local playerPed = PlayerPedId()

local ped = PlayerPedId()
local prevMaleVariation = 0
local prevFemaleVariation = 0
local femaleHash = GetHashKey("mp_f_freemode_01")
local maleHash = GetHashKey("mp_m_freemode_01")

RequestAnimDict('mp_arresting')
while not HasAnimDictLoaded('mp_arresting') do
	Citizen.Wait(100)
end
FreezeEntityPosition(playerPed, true)

TaskPlayAnim(playerPed, 'mp_arresting', 'arrested_spin_l_0', 8.0, -8, -1, 49, 0, 0, 0, 0)
Citizen.Wait(4000)
ClearPedTasksImmediately(playerPed)
FreezeEntityPosition(playerPed, false)
Citizen.Wait(10)
TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)

if GetEntityModel(ped) == femaleHash then 
	prevFemaleVariation = GetPedDrawableVariation(ped, 7)
	SetPedComponentVariation(ped, 7, 25, 0, 0)
  
elseif GetEntityModel(ped) == maleHash then 
	prevMaleVariation = GetPedDrawableVariation(ped, 7)
	SetPedComponentVariation(ped, 7, 41, 0, 0)
end

SetEnableHandcuffs(playerPed, true)
DisablePlayerFiring(playerPed, true)
SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) 
SetPedCanPlayGestureAnims(playerPed, false)
end)

RegisterNetEvent('krs:handcuff2')
AddEventHandler('krs:handcuff2', function()
local playerPed = PlayerPedId()
FreezeEntityPosition(playerPed, true)
RequestAnimDict('arrest')
while not HasAnimDictLoaded('arrest') do
Citizen.Wait(100)
end
		
TaskPlayAnim(playerPed, 'arrest', 'arrest_fallback_low_cop', 8.0, -8, -1, 49, 0, 0, 0, 0)

Citizen.Wait(4000)
FreezeEntityPosition(playerPed, false)
ClearPedTasksImmediately(GetPlayerPed(-1))

end)

RegisterNetEvent('krs:uncuff')
AddEventHandler('krs:uncuff', function()
  IsHandcuffed    = false
  local playerPed = GetPlayerPed(-1)
if not IsHandcuffed then
	  ClearPedSecondaryTask(playerPed)
	  SetEnableHandcuffs(playerPed, false)
	  SetPedCanPlayGestureAnims(playerPed,  true)
	  FreezeEntityPosition(playerPed, false)
	SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 0)
end
end)

RegisterNetEvent('krs:drag')
AddEventHandler('krs:drag', function(cop)
  IsDragged = not IsDragged
  CopPed = tonumber(cop)
end)

Citizen.CreateThread(function()
while true do
Wait(3)
if IsHandcuffed then
	  if IsDragged then
		local ped = GetPlayerPed(GetPlayerFromServerId(CopPed))
		local myped = GetPlayerPed(-1)
		AttachEntityToEntity(myped, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
	  else
		DetachEntity(GetPlayerPed(-1), true, false)
	  end
else
	Citizen.Wait(750)
end
end
end)

RegisterNetEvent('krs:putInVehicle')
AddEventHandler('krs:putInVehicle', function()
  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)
  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
	local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  5.0,  0,  71)

	if DoesEntityExist(vehicle) then
		  local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
		  local freeSeat = nil
		  for i=maxSeats - 1, 0, -1 do
			if IsVehicleSeatFree(vehicle,  i) then
				  freeSeat = i
				  break
			end
		  end
		  if freeSeat ~= nil then
			TaskWarpPedIntoVehicle(playerPed,  vehicle,  freeSeat)
		  end
	end
  end
end)

RegisterNetEvent('krs:OutVehicle')
AddEventHandler('krs:OutVehicle', function()
local playerPed = PlayerPedId()

if not IsPedSittingInAnyVehicle(playerPed) then
	return
end

local vehicle = GetVehiclePedIsIn(playerPed, false)
TaskLeaveVehicle(playerPed, vehicle, 16)
end)

Citizen.CreateThread(function()
while true do
	Citizen.Wait(1)
	local playerPed = PlayerPedId()
	if IsHandcuffed then
		DisableControlAction(0, 24, true) 
		DisableControlAction(0, 257, true) 
		DisableControlAction(0, 25, true) 
		DisableControlAction(0, 263, true) 
		DisableControlAction(0, Keys['R'], true) 
		DisableControlAction(0, Keys['SPACE'], true)
		DisableControlAction(0, Keys['Q'], true) 
		DisableControlAction(0, Keys['TAB'], true) 
		DisableControlAction(0, Keys['F'], true) 
		DisableControlAction(0, Keys['F1'], true) 
		DisableControlAction(0, Keys['F2'], true) 
		DisableControlAction(0, Keys['F3'], true) 
		DisableControlAction(0, Keys['F5'], true) 
		DisableControlAction(0, Keys['F6'], true) 
		DisableControlAction(0, Keys['V'], true) 
		DisableControlAction(0, Keys['C'], true) 
		DisableControlAction(0, Keys['X'], true)
		DisableControlAction(2, Keys['P'], true)
		DisableControlAction(0, 59, true) 
		DisableControlAction(0, 71, true) 
		DisableControlAction(0, 72, true) 
		DisableControlAction(2, Keys['LEFTCTRL'], true)
		DisableControlAction(0,21,true) 
		DisableControlAction(0, 47, true)  
		DisableControlAction(0, 264, true) 
		DisableControlAction(0, 257, true) 
		DisableControlAction(0, 140, true) 
		DisableControlAction(0, 141, true) 
		DisableControlAction(0, 142, true) 
		DisableControlAction(0, 143, true)
		DisableControlAction(0, 75, true)  
		DisableControlAction(27, 75, true)
		if not IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) then
			ESX.Streaming.RequestAnimDict('mp_arresting', function()
				TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
			end)
		end
	else
		Citizen.Wait(700)
	end
end
end)
-- FINE MENU CRIMINALE --


function MenuGps()
    lib.registerMenu({
        id = 'menugps',
        title = 'Menu F5',
        position = 'top-left',
        options = {
            {label = "Centrale Di Polizia"},
            {label = "Ospedale"},
            {label = "Concessionario"},
            {label = "Garage Centrale"},
            {label = "Armeria"},
            {label = "Banca"},
        }
    }, function(selected)
        print(selected)
        if selected == 1 then 
            TriggerEvent("centrale")
        elseif selected == 2 then
            TriggerEvent('ospedale')
        elseif selected == 3 then
            TriggerEvent('concessionario')
        elseif selected == 5 then
            TriggerEvent('garagecentrale')
        elseif selected == 6 then
            TriggerEvent('armeria')
        elseif selected == 7 then
            TriggerEvent('banca')
        elseif selected == 8 then
            TriggerEvent('chiudimenu')
        end
    end)
        lib.showMenu('menugps') 
end

RegisterNetEvent('centrale')
AddEventHandler('centrale', function()
	SetNewWaypoint(411.4890, -982.9155, 29.4157)
		ESX.ShowNotification("GPS Impostato Centrale Di Polizia")
end)

RegisterNetEvent('ospedale')
AddEventHandler('ospedale', function()
	SetNewWaypoint(293.0005, -584.2846, 43.1920)
		ESX.ShowNotification("GPS Impostato Ospedale")
end)

RegisterNetEvent('concessionario')
AddEventHandler('concessionario', function()
	SetNewWaypoint(-54.8417, -1111.2412, 26.4357)
		ESX.ShowNotification("GPS Impostato Concessionario")
end)

RegisterNetEvent('garagecentrale')
AddEventHandler('garagecentrale', function()
	SetNewWaypoint(214.1303, -792.8495, 30.8494)
		ESX.ShowNotification("GPS Impostato Garage Centrale")
end)

RegisterNetEvent('armeria')
AddEventHandler('armeria', function()
	SetNewWaypoint(814.4321, -2127.8757, 29.3061)
		ESX.ShowNotification("GPS Impostato Armeria")
end)

RegisterNetEvent('bancaaa')
AddEventHandler('bancaaa', function()
	SetNewWaypoint(152.4882, -1029.8076, 29.1989)
		ESX.ShowNotification("GPS Impostato Banca")
end)



function MenuFps()
    lib.registerMenu({
        id = 'menufps',
        title = 'Menu F5',
        position = 'top-left',
        options = {
            {label = 'Reset'},
            {label = 'Boost FPS'},
            {label = 'Boost Grafica'},
            {label = 'Boost Luci'},
            {label = 'Gestione Distanza'},		
        }
    }, function(selected)
        print(selected)
        if selected == 1 then 
            SetTimecycleModifier()
            ClearTimecycleModifier()
            ClearExtraTimecycleModifier()
            SetTimecycleModifier('default')
        elseif selected == 2 then 
            SetTimecycleModifier('cinema')
            SetForceVehicleTrails(false)
            SetForcePedFootstepsTracks(false)
        elseif selected == 3 then 
            SetTimecycleModifier('MP_Powerplay_blend')
            SetExtraTimecycleModifier('reflection_correct_ambient')  
        elseif selected == 4 then 
            SetTimecycleModifier('tunnel')
        elseif selected == 5 then 
            DistanzaFPS()
        end
    end)
    
        lib.showMenu('menufps') 

end

function DistanzaFPS()
    lib.registerMenu({
        id = 'distanzafps',
        title = 'Menu F5',
        position = 'top-left',
        options = {
            {label = 'Distanza Bassa'},
		{label = 'Distanza Media'},
		{label = 'Distanza Alta'},	
        }
    }, function(selected)
        print(selected)
        if selected == 1 then 
            OverrideLodscaleThisFrame(0.5)
            SetLightsCutoffDistanceTweak(0.5)
            CascadeShadowsSetCascadeBoundsScale(0.0)	
            RopeDrawShadowEnabled(false)
            CascadeShadowsClearShadowSampleType()
            CascadeShadowsSetAircraftMode(false)
            CascadeShadowsEnableEntityTracker(true)
            CascadeShadowsSetDynamicDepthMode(false)
            CascadeShadowsSetEntityTrackerScale(0.0)
            CascadeShadowsSetDynamicDepthValue(0.0)
            CascadeShadowsSetCascadeBoundsScale(0.0)
            SetFlashLightFadeDistance(0.0)
            SetLightsCutoffDistanceTweak(0.0)
            DistantCopCarSirens(false)
            SetDisableDecalRenderingThisFrame()
        elseif selected == 2 then
            OverrideLodscaleThisFrame(1.0)
            SetLightsCutoffDistanceTweak(1.0)
            CascadeShadowsSetCascadeBoundsScale(0.5)	
            RopeDrawShadowEnabled(false)
            CascadeShadowsClearShadowSampleType()
            CascadeShadowsSetAircraftMode(false)
            CascadeShadowsEnableEntityTracker(true)
            CascadeShadowsSetDynamicDepthMode(false)
            CascadeShadowsSetEntityTrackerScale(0.0)
            CascadeShadowsSetDynamicDepthValue(0.0)
            CascadeShadowsSetCascadeBoundsScale(0.0)
            SetFlashLightFadeDistance(5.0)
            SetLightsCutoffDistanceTweak(5.0)
            DistantCopCarSirens(false)
            SetDisableDecalRenderingThisFrame()
        elseif selected == 3 then
            OverrideLodscaleThisFrame(75.0)
            SetLightsCutoffDistanceTweak(75.0)
            CascadeShadowsSetCascadeBoundsScale(1.0)
            RopeDrawShadowEnabled(true)
            CascadeShadowsClearShadowSampleType()
            CascadeShadowsSetAircraftMode(false)
            CascadeShadowsEnableEntityTracker(true)
            CascadeShadowsSetDynamicDepthMode(false)
            CascadeShadowsSetEntityTrackerScale(5.0)
            CascadeShadowsSetDynamicDepthValue(3.0)
            CascadeShadowsSetCascadeBoundsScale(3.0)
            SetFlashLightFadeDistance(3.0)
            SetLightsCutoffDistanceTweak(3.0)
            DistantCopCarSirens(false)
            SetArtificialLightsState(false)
            SetDisableDecalRenderingThisFrame()
        end
    end)
    
        lib.showMenu('distanzafps') 

end



function MenuAdmin()
    lib.registerMenu({
        id = 'menuadmin',
        title = 'Menu F5',
        position = 'top-left',
        options = {
            {label = 'Noclip'},
            {label = 'Tpm'},
            {label = 'Ripara Veicolo'},
			{label = 'Ribalta Veicolo'},
			{label = 'Spawn Veicolo'},
      
        }
     
    }, function(selected)
        print(selected)
        if selected == 1 then 
           
            noclip = not noclip

            Wait(100)

            if noclip then
                Noclip()
                ESX.ShowNotification('Noclip Abilitato')
            else
                FreezeEntityPosition(PlayerPedId(), false)
                SetEntityInvincible(PlayerPedId(), false)
                SetEntityCollision(PlayerPedId(), true, true)

                SetEntityVisible(PlayerPedId(), true, false)

                SetEveryoneIgnorePlayer(PlayerId(), false)
                SetPoliceIgnorePlayer(PlayerId(), false)

                ESX.ShowNotification('Noclip Disabilitato')
            end
        elseif selected == 2 then
            ExecuteCommand('tpm')
        elseif val == 'invisiblita' then
            invisibile = not invisibile

            if invisibile then
                SetEntityVisible(PlayerPedId(), false, false)
                ESX.ShowNotification('Invisibilità Abilitata')
            else
                SetEntityVisible(PlayerPedId(), true, false)
                ESX.ShowNotification('Invisibilità Disabilitata')
            end
        elseif val == 'tpcoords' then
            local pos = KeyboardInput('BOX_COORDINATE', 'Inserisci Coordinate', '', 50)

            if pos ~= nil and pos ~= '' then
                local _, _, x, y, z = string.find(pos, '([%d%.]+) ([%d%.]+) ([%d%.]+)')
                        
                if x ~= nil and y ~= nil and z ~= nil then
                    SetEntityCoords(PlayerPedId(), x + .0, y + .0, z + .0)
                end
            end
        elseif selected == 3 then
                if IsPedInAnyVehicle(PlayerPedId(), false) then
                    SetVehicleFixed(GetVehiclePedIsUsing(PlayerPedId()))	
                    SetVehicleDirtLevel(GetVehiclePedIsUsing(PlayerPedId()),0)
                    ESX.ShowNotification("Hai riparato il veicolo")
                    
                else
                    ESX.ShowNotification("Bro devi stare nel veicolo!!")
                    
                end
        elseif selected == 4 then
            local player = PlayerPedId()
            local posdepmenu = GetEntityCoords(player)
            local carTargetDep = GetClosestVehicle(posdepmenu['x'], posdepmenu['y'], posdepmenu['z'], 10.0,0,70)
            SetPedIntoVehicle(player , carTargetDep, -1)
            Citizen.Wait(200)
            ClearPedTasksImmediately(player)
            Citizen.Wait(100)
            local playerCoords = GetEntityCoords(PlayerPedId())
            playerCoords = playerCoords + vector3(0, 2, 0)
            SetEntityCoords(carTargetDep, playerCoords)
			ESX.ShowNotification("Hai ribaltato il veicolo")
			
        elseif selected == 5 then
            local input = lib.inputDialog('Spawna un veicolo', {'Inserisci il nome del veicolo'})

			if input then
				local ModelHash = input[1]

				if not IsModelInCdimage(ModelHash) then return end
				RequestModel(ModelHash)
				while not HasModelLoaded(ModelHash) do 
				Citizen.Wait(10)
				end
				local MyPed = PlayerPedId() 
				local Vehicle = CreateVehicle(ModelHash, GetEntityCoords(MyPed), GetEntityHeading(MyPed), true, false)
				SetModelAsNoLongerNeeded(ModelHash)
				TaskWarpPedIntoVehicle(PlayerPedId(), Vehicle, -1)
				ESX.ShowNotification("Hai spawnato un veicolo")
            
			end
            
        end
    end)
        lib.showMenu('menuadmin') 
end


function getCamDirection()
	local heading = GetGameplayCamRelativeHeading() + GetEntityPhysicsHeading(PlayerPedId())
	local pitch = GetGameplayCamRelativePitch()
	local coords = vector3(-math.sin(heading * math.pi / 180.0), math.cos(heading * math.pi / 180.0), math.sin(pitch * math.pi / 180.0))
	local len = math.sqrt((coords.x * coords.x) + (coords.y * coords.y) + (coords.z * coords.z))

	if len ~= 0 then
		coords = coords / len
	end

	return coords
end

function Noclip()
    Citizen.CreateThread(function()
		while noclip do
			Wait(0)
			local plyCoords = GetEntityCoords(PlayerPedId(), false)
			local camCoords = getCamDirection()
			SetEntityVelocity(PlayerPedId(), 0.01, 0.01, 0.01)

			if IsControlPressed(0, 32) then
				plyCoords = plyCoords + (1.0 * camCoords)
			end

			if IsControlPressed(0, 269) then
				plyCoords = plyCoords - (1.0 * camCoords)
			end

			SetEntityCoordsNoOffset(PlayerPedId(), plyCoords, true, true, true)

			FreezeEntityPosition(PlayerPedId(), true)
			SetEntityInvincible(PlayerPedId(), true)
			SetEntityCollision(PlayerPedId(), false, false)

			SetEntityVisible(PlayerPedId(), false, false)

			SetEveryoneIgnorePlayer(PlayerId(), true)
			SetPoliceIgnorePlayer(PlayerId(), true)
		end
	end)
end