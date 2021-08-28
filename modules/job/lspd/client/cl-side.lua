codelspd = [[

    codigocargadolspd = true

    AddEventHandler('lspd:client:entrarZona', function(zone)
        if zone == 'ArmarioLSPD' then
            CurrentAction     = 'armariolspd'
            CurrentActionMsg  = "Locker"
            CurrentActionData = {}
            CurrentActionMsgCoords = vector3(457.5, -993.80, 30.90+0.25)
        elseif zone == "VehiculosLSPD" then
            CurrentAction     = 'vehiculoslspd'
            CurrentActionMsg  = "Vehículos"
            CurrentActionData = {}
            CurrentActionMsgCoords = vector3(459.29, -1007.94, 27.41+1)
        elseif zone == "DepositoLSPD" then
            CurrentAction     = 'depositolspd'
            CurrentActionMsg  = "Presiona ~y~E~s~ para abrir el depósito"
            CurrentActionData = {}
            CurrentActionMsgCoords = vector3(-319.72, -131.68, 38.00+1)
        elseif zone == "BasureroLSPD" then
            CurrentAction     = 'basurerolspd'
            CurrentActionMsg  = "Presiona ~y~E~s~ para depositar un elemento ilícito"
            CurrentActionData = {}
            CurrentActionMsgCoords = vector3(481.22, -990.09, 24.91+1)
        elseif zone == "JefeLSPD" then
            CurrentAction     = 'jefelspd'
            CurrentActionMsg  = "Gestionar empresa"
            CurrentActionData = {}
            CurrentActionMsgCoords = vector3(464.97, -1009.29, 34.93+1)
        end
    end)
    
    AddEventHandler('lspd:client:salirZona', function(zone)
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
            
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
                local coords, letSleep = GetEntityCoords(PlayerPedId()), true
    
                for k,v in pairs(Config.LSPD) do
                    if v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance then
                        DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, false, 2, true, nil, nil, false)
                        letSleep = false
                    end
                end
    
                if ESX.PlayerData.job.grade_name == 'boss' then
                    local coords, letSleep = GetEntityCoords(PlayerPedId()), true
    
                    for k,v in pairs(Config.LSPDJefe) do
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
    
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
    
                local coords      = GetEntityCoords(PlayerPedId())
                local isInMarker  = false
                local currentZone = nil
    
                for k,v in pairs(Config.LSPD) do
                    if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 3) then
                        isInMarker  = true
                        currentZone = k
                    end
                end
    
                if ESX.PlayerData.job.grade_name == 'boss' then
                    for k,v in pairs(Config.LSPDJefe) do
                        if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 3) then
                            isInMarker  = true
                            currentZone = k
                        end
                    end
                end
    
                if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
                    HasAlreadyEnteredMarker = true
                    LastZone                = currentZone
                    TriggerEvent('lspd:client:entrarZona', currentZone)
                end
    
                if not isInMarker and HasAlreadyEnteredMarker then
                    HasAlreadyEnteredMarker = false
                    TriggerEvent('lspd:client:salirZona', LastZone)
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
    
                if IsControlJustReleased(0, 38) and ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
                    
                    if CurrentAction == 'armariolspd' then
                        ESX.UI.Menu.CloseAll()
                        AbrirArmarioLSPD()
                    elseif CurrentAction == 'vehiculoslspd' then
                        ESX.UI.Menu.CloseAll()
                        VehiculosLSPD()
                    -- elseif CurrentAction == 'depositolspd' then
                    --     ESX.UI.Menu.CloseAll()
                    --     DepositoLSPD()
                    -- elseif CurrentAction == 'basurerolspd' then
                    --     ESX.UI.Menu.CloseAll()
                    --     AbrirBasureroLSPD()
                    elseif CurrentAction == 'jefelspd' then
                        ESX.UI.Menu.CloseAll()
                        TriggerEvent('esx_society:openBossMenu', 'police', function(data, menu)
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
	if ESX.GetPlayerData().job.name == "police" and not codigocargadolspd then
        assert(load(codelspd))()
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  	ESX.PlayerData = xPlayer
  	if ESX.GetPlayerData().job.name == "police" and not codigocargadolspd then
        assert(load(codelspd))()
	end
end)
