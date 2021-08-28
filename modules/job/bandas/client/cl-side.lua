codebanda = [[

    codigocargadobanda = true

    AddEventHandler('banda:client:entrarZona', function(zone)
        if zone == 'Armariobanda' then
            CurrentAction     = 'armariobanda'
            CurrentActionMsg  = "Locker"
            CurrentActionData = {}
            CurrentActionMsgCoords = vector3(-1501.5093994141,856.9306640625,181.59492492676+0.25)
        elseif zone == "Vehiculosbanda" then
            CurrentAction     = 'vehiculosbanda'
            CurrentActionMsg  = "Vehículos"
            CurrentActionData = {}
            CurrentActionMsgCoords = vector3(-1529.6451416016,887.60046386719,181.15+1)
        elseif zone == "Depositobanda" then
            CurrentAction     = 'depositobanda'
            CurrentActionMsg  = "Presiona ~y~E~s~ para abrir el depósito"
            CurrentActionData = {}
            CurrentActionMsgCoords = vector3(-319.72, -131.68, 38.00+1)
        elseif zone == "Basurerobanda" then
            CurrentAction     = 'basurerobanda'
            CurrentActionMsg  = "Presiona ~y~E~s~ para depositar un elemento ilícito"
            CurrentActionData = {}
            CurrentActionMsgCoords = vector3(481.22, -990.09, 24.91+1)
        elseif zone == "Jefebanda" then
            CurrentAction     = 'jefebanda'
            CurrentActionMsg  = "Gestionar empresa"
            CurrentActionData = {}
            CurrentActionMsgCoords = vector3(464.97, -1009.29, 34.93+1)
        end
    end)
    
    AddEventHandler('banda:client:salirZona', function(zone)
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
            
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'banda' then
                local coords, letSleep = GetEntityCoords(PlayerPedId()), true
    
                for k,v in pairs(Config.banda) do
                    if v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance then
                        DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, false, 2, true, nil, nil, false)
                        letSleep = false
                    end
                end
    
                if ESX.PlayerData.job.grade_name == 'boss' then
                    local coords, letSleep = GetEntityCoords(PlayerPedId()), true
    
                    for k,v in pairs(Config.bandaJefe) do
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
    
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'banda' then
    
                local coords      = GetEntityCoords(PlayerPedId())
                local isInMarker  = false
                local currentZone = nil
    
                for k,v in pairs(Config.banda) do
                    if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 3) then
                        isInMarker  = true
                        currentZone = k
                    end
                end
    
                if ESX.PlayerData.job.grade_name == 'boss' then
                    for k,v in pairs(Config.bandaJefe) do
                        if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 3) then
                            isInMarker  = true
                            currentZone = k
                        end
                    end
                end
    
                if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
                    HasAlreadyEnteredMarker = true
                    LastZone                = currentZone
                    TriggerEvent('banda:client:entrarZona', currentZone)
                end
    
                if not isInMarker and HasAlreadyEnteredMarker then
                    HasAlreadyEnteredMarker = false
                    TriggerEvent('banda:client:salirZona', LastZone)
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
    
                if IsControlJustReleased(0, 38) and ESX.PlayerData.job and ESX.PlayerData.job.name == 'banda' then
                    
                    if CurrentAction == 'armariobanda' then
                        ESX.UI.Menu.CloseAll()
                        AbrirArmariobanda()
                    elseif CurrentAction == 'vehiculosbanda' then
                        ESX.UI.Menu.CloseAll()
                        Vehiculosbanda()
                    -- elseif CurrentAction == 'depositobanda' then
                    --     ESX.UI.Menu.CloseAll()
                    --     Depositobanda()
                    -- elseif CurrentAction == 'basurerobanda' then
                    --     ESX.UI.Menu.CloseAll()
                    --     AbrirBasurerobanda()
                    elseif CurrentAction == 'jefebanda' then
                        ESX.UI.Menu.CloseAll()
                        TriggerEvent('esx_society:openBossMenu', 'banda', function(data, menu)
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
	if ESX.GetPlayerData().job.name == "banda" and not codigocargadobanda then
        assert(load(codebanda))()
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  	ESX.PlayerData = xPlayer
  	if ESX.GetPlayerData().job.name == "banda" and not codigocargadobanda then
        assert(load(codebanda))()
	end
end)
