LimpiarPedEMS = function(playerPed)
	SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end

AbrirArmarioEMS = function()
	ESX.UI.Menu.CloseAll()

    local playerPed = PlayerPedId()

    local elements = {
		{label = "Abrir locker", value = "locker"},
		{label = "Ropa de trabajo", value = "jobclothes"},
		{label = "Ropa civil", value = 'civil'},
		{label = 'Mis Vestimentas', value = 'cambiar'}
    }
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armario', {
		title    = "Armario de ropa",
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		LimpiarPedEMS(playerPed)

		if data.current.value == 'civil' then
			TriggerServerEvent('clothing:checkIfNew')
        end

		if data.current.value == 'jobclothes' then
			RopaServicioEMS()
		end
        
		if data.current.value == "locker" then
			ESX.UI.Menu.CloseAll()
			ClearPedSecondaryTask(playerPed)
			loadAnimDict("anim@heists@keycard@") 
			TaskPlayAnim(playerPed, "anim@heists@keycard@", "exit", 8.0, 1.0, -1, 16, 0, 0, 0, 0)
			TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'abrirlocker', 0.4)
			exports['linden_inventory']:OpenStash({ name = "Locker-EMS", owner = true, slots = 70})
			Citizen.Wait(850)
			ClearPedTasks(playerPed)
		end

		if data.current.value == "cambiar" then
			TriggerEvent("skins:abrirArmario")
		end
	end, function(data, menu)
		menu.close()
	end)
end

RopaServicioEMS = function()
	ESX.UI.Menu.CloseAll()

	local elements = {}
    local gender = nil
	local ped = PlayerPedId()
    ESX.TriggerServerCallback('masterjob:server:sex', function(sex)
        gender = sex

		if gender == "m" then
			table.insert(elements, {label = "Uniforme de trabajo", value = "trabajom"})
		else
			table.insert(elements, {label = "Ropa de mujer", value = "trabajof"})
		end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ropaservicio', {
		title    = "Vestimenta de servicio",
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)

		if data.current.value == "trabajom" then
			-- Poner ropa temporal (no se guarda en la DB)
			SetPedComponentVariation(ped, 1, 11, 2) -- Máscara
			SetPedComponentVariation(ped, 3, 37, 0) -- Manos
			SetPedComponentVariation(ped, 4, 20, 0) -- Pantalones
			SetPedComponentVariation(ped, 5, 0, 0) -- Mochilas
			SetPedComponentVariation(ped, 6, 35, 0) -- Zapatos
			SetPedComponentVariation(ped, 7, -1, 0) -- Bufanda y collar
			SetPedComponentVariation(ped, 8, 15, 0) -- Camiseta
			SetPedComponentVariation(ped, 9, -1, 0) -- Chaleco antibalas
			SetPedComponentVariation(ped, 10, 0, 0) -- Badge
			SetPedComponentVariation(ped, 11, 13, 3) -- Torso
			SetPedPropIndex(ped, 0, 8, 0, true) -- Casco
		elseif data.current.value == "trabajof" then
			-- Poner ropa temporal (no se guarda en la DB)
			SetPedComponentVariation(ped, 1, 101, 0) -- Máscara
			SetPedComponentVariation(ped, 3, 4, 0) -- Manos
			SetPedComponentVariation(ped, 4, 35, 0) -- Pantalones
			SetPedComponentVariation(ped, 5, 52, 0) -- Mochilas
			SetPedComponentVariation(ped, 6, 51, 0) -- Zapatos
			SetPedComponentVariation(ped, 7, 8, 0) -- Bufanda y collar
			SetPedComponentVariation(ped, 8, 56, 0) -- Camiseta
			SetPedComponentVariation(ped, 9, 37, 0) -- Chaleco antibalas
			SetPedComponentVariation(ped, 10, 0, 0) -- Badge
			SetPedComponentVariation(ped, 11, 193, 0) -- Torso
			SetPedPropIndex(ped, 0, 121, 0, true) -- Casco
		end
		
	end, function(data, menu)
			menu.close()
		end)
	end)
end
