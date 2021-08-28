codeems = [[

    codigocargadoems = true

    AddEventHandler('ems:client:entrarZona', function(zone)
        if zone == 'ArmarioEMS' then
            CurrentAction     = 'armarioems'
            CurrentActionMsg  = "Locker"
            CurrentActionData = {}
            CurrentActionMsgCoords = vector3(301.3054, -600.2374, 43.2821+0.25)
        elseif zone == "VehiculosEMS" then
            CurrentAction     = 'vehiculosems'
            CurrentActionMsg  = "Vehículos"
            CurrentActionData = {}
            CurrentActionMsgCoords = vector3(296.07, -607.52, 43.33+0.25)
        elseif zone == "JefeEMS" then
            CurrentAction     = 'jefeems'
            CurrentActionMsg  = "Gestionar empresa"
            CurrentActionData = {}
            CurrentActionMsgCoords = vector3(339.16, -595.69, 42.50+1)
        end
    end)
    
    AddEventHandler('ems:client:salirZona', function(zone)
        CurrentAction = nil
        ESX.UI.Menu.CloseAll()
    end)
    
    -- Loops
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)

            if letSleep then
                Citizen.Wait(500)
            end
            
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
                local coords, letSleep = GetEntityCoords(PlayerPedId()), true
    
                for k,v in pairs(Config.EMS) do
                    if v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance then
                        DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, false, 2, true, nil, nil, false)
                        letSleep = false
                    end
                end
    
                if ESX.PlayerData.job.grade_name == 'boss' then
                    local coords, letSleep = GetEntityCoords(PlayerPedId()), true
    
                    for k,v in pairs(Config.EMSJefe) do
                        if v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance then
                            DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z+0.75, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, false, 2, true, nil, nil, false)
                            letSleep = false
                        end
                    end
                end
            else
            Citizen.Wait(500)
        end
    end
end)
    
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(10)
    
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
    
                local coords      = GetEntityCoords(PlayerPedId())
                local isInMarker  = false
                local currentZone = nil
    
                for k,v in pairs(Config.EMS) do
                    if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 3) then
                        isInMarker  = true
                        currentZone = k
                    end
                end
    
                if ESX.PlayerData.job.grade_name == 'boss' then
                    for k,v in pairs(Config.EMSJefe) do
                        if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 3) then
                            isInMarker  = true
                            currentZone = k
                        end
                    end
                end
    
                if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
                    HasAlreadyEnteredMarker = true
                    LastZone                = currentZone
                    TriggerEvent('ems:client:entrarZona', currentZone)
                end
    
                if not isInMarker and HasAlreadyEnteredMarker then
                    HasAlreadyEnteredMarker = false
                    TriggerEvent('ems:client:salirZona', LastZone)
                end
            end
        end
    end)
    
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
    
            if CurrentAction then
                if(CurrentActionMsgCoords ~= nil) then
                    local text = ""
                    playerPed = PlayerPedId()
                    playerCoords = GetEntityCoords(playerPed)
                    local distance = #(playerCoords - CurrentActionMsgCoords)
                    if distance <= 1 then text='[~y~E~s~] '..CurrentActionMsg
                    else text = CurrentActionMsg end
                    if distance <= 3 then MasterJobTexto(CurrentActionMsgCoords, text, 0.8, 4) end
                else
                    ESX.ShowHelpNotification(CurrentActionMsg)
                end
    
                if IsControlJustReleased(0, 38) and ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
                    
                    if CurrentAction == 'armarioems' then
                        ESX.UI.Menu.CloseAll()
                        AbrirArmarioEMS()
                    elseif CurrentAction == 'vehiculosems' then
                        ESX.UI.Menu.CloseAll()
                        VehiculosEMS()
                    elseif CurrentAction == 'jefeems' then
                        ESX.UI.Menu.CloseAll()
                        TriggerEvent('esx_society:openBossMenu', 'ambulance', function(data, menu)
                        menu.close()
                        end, { wash = false })
                    end
                end
            end
        end
    end)

]]

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	if ESX.GetPlayerData().job.name == "ambulance" and not codigocargadoems then
        assert(load(codeems))()
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  	ESX.PlayerData = xPlayer
  	if ESX.GetPlayerData().job.name == "ambulance" and not codigocargadoems then
        assert(load(codeems))()
	end
end)
