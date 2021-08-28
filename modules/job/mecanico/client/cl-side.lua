codemeca = [[

    codigocargadomeca = true

    AddEventHandler('mecanico:client:entrarZona', function(zone)
        if zone == 'ArmarioLSC' then
            CurrentAction     = 'armariomeca'
            CurrentActionMsg  = "Locker"
            CurrentActionData = {}
            CurrentActionMsgCoords = vector3(-206.65560913086,-1341.6083984375,34.894596099854+0.25)
        elseif zone == "VehiculosLSC" then
            CurrentAction     = 'vehiculosmeca'
            CurrentActionMsg  = "Vehículos"
            CurrentActionData = {}
            CurrentActionMsgCoords = vector3(-202.13780212402,-1309.6726074219,31.294134140015+0.25)
        elseif zone == "JefeLSC" then
            CurrentAction     = 'jefemeca'
            CurrentActionMsg  = "Gestionar empresa"
            CurrentActionData = {}
            CurrentActionMsgCoords = vector3(-355.18, -144.18, 42.20+1)
        end
    end)
    
    AddEventHandler('mecanico:client:salirZona', function(zone)
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
            
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
                local coords, letSleep = GetEntityCoords(PlayerPedId()), true
    
                for k,v in pairs(Config.Mecanico) do
                    if v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance then
                        DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, false, 2, true, nil, nil, false)
                        letSleep = false
                    end
                end
    
                if ESX.PlayerData.job.grade_name == 'boss' then
                    local coords, letSleep = GetEntityCoords(PlayerPedId()), true
    
                    for k,v in pairs(Config.MecanicoJefe) do
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
    
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
    
                local coords      = GetEntityCoords(PlayerPedId())
                local isInMarker  = false
                local currentZone = nil
    
                for k,v in pairs(Config.Mecanico) do
                    if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 3) then
                        isInMarker  = true
                        currentZone = k
                    end
                end
    
                if ESX.PlayerData.job.grade_name == 'boss' then
                    for k,v in pairs(Config.MecanicoJefe) do
                        if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 3) then
                            isInMarker  = true
                            currentZone = k
                        end
                    end
                end
    
                if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
                    HasAlreadyEnteredMarker = true
                    LastZone                = currentZone
                    TriggerEvent('mecanico:client:entrarZona', currentZone)
                end
    
                if not isInMarker and HasAlreadyEnteredMarker then
                    HasAlreadyEnteredMarker = false
                    TriggerEvent('mecanico:client:salirZona', LastZone)
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
    
                if IsControlJustReleased(0, 38) and ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
                    
                    if CurrentAction == 'armariomeca' then
                        ESX.UI.Menu.CloseAll()
                        AbrirArmarioMecanico()
                    elseif CurrentAction == 'vehiculosmeca' then
                        ESX.UI.Menu.CloseAll()
                        VehiculosMecanico()
                    elseif CurrentAction == 'jefemeca' then
                        ESX.UI.Menu.CloseAll()
                        TriggerEvent('esx_society:openBossMenu', 'mechanic', function(data, menu)
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
	if ESX.GetPlayerData().job.name == "mechanic" and not codigocargadomeca then
        assert(load(codemeca))()
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  	ESX.PlayerData = xPlayer
  	if ESX.GetPlayerData().job.name == "mechanic" and not codigocargadomeca then
        assert(load(codemeca))()
	end
end)
