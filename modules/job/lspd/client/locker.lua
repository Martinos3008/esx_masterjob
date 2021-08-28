LimpiarPedLSPD = function(playerPed)
	SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end

AbrirArmarioLSPD = function()
	ESX.UI.Menu.CloseAll()

    local playerPed = PlayerPedId()

    local elements = {
		{label = "Abrir locker", value = "locker"},
		{label = "Ropa de trabajo", value = "policeclothes"},
		{label = "Ropa civil", value = 'civil'},
		{label = 'Mis Vestimentas', value = 'cambiar'}
    }
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armario', {
		title    = "Armario de ropa",
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		LimpiarPedLSPD(playerPed)

		if data.current.value == 'civil' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
			TriggerEvent('skinchanger:loadSkin', skin)
        end)
	end

		if data.current.value == 'policeclothes' then
			RopaServicioPolicia()
		end
        
		if data.current.value == "locker" then
			ESX.UI.Menu.CloseAll()
			ClearPedSecondaryTask(playerPed)
			loadAnimDict("anim@heists@keycard@") 
			TaskPlayAnim(playerPed, "anim@heists@keycard@", "exit", 8.0, 1.0, -1, 16, 0, 0, 0, 0)
			TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'abrirlocker', 0.4)
			exports['linden_inventory']:OpenStash({ name = "Locker-LSPD", owner = true, slots = 70})
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

RopaServicioPolicia = function()
	ESX.UI.Menu.CloseAll()

	local elements = {}
    local gender = nil
	local ped = PlayerPedId()
    ESX.TriggerServerCallback('masterjob:server:sex', function(sex)
        gender = sex

		if gender == "m" then
			table.insert(elements, {label = "Unidad de patrullaje manga corta", value = "patrulla"})
			table.insert(elements, {label = "Unidad de patrullaje manga larga", value = "patrulla2"})
			table.insert(elements, {label = "Unidad de patrullaje formal", value = "patrulla3"})
			table.insert(elements, {label = "Unidad de patrullaje invierno", value = "patrulla4"})
			table.insert(elements, {label = "Unidad de patrullaje lluvia", value = "patrulla5"})
			table.insert(elements, {label = "Unidad motorizada", value = "moto"})
			if ESX.PlayerData.job.grade_name == "policia9" or ESX.PlayerData.job.grade_name == "policia10" or ESX.PlayerData.job.grade_name == "boss" then
				table.insert(elements, {label = "Detective", value = "detective"})
			end
		else
			table.insert(elements, {label = "Ropa de mujer", value = "mujer1"})
		end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ropaservicio', {
		title    = "Vestimenta de servicio",
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)

		if data.current.value == "patrulla" then
			-- Poner ropa temporal (no se guarda en la DB)
			SetPedComponentVariation(ped, 1, 101, 0) -- Máscara
			SetPedComponentVariation(ped, 3, 11, 0) -- Manos
			SetPedComponentVariation(ped, 4, 35, 0) -- Pantalones
			SetPedComponentVariation(ped, 5, 52, 0) -- Mochilas
			SetPedComponentVariation(ped, 6, 51, 0) -- Zapatos
			SetPedComponentVariation(ped, 7, 8, 0) -- Bufanda y collar
			SetPedComponentVariation(ped, 8, 56, 0) -- Camiseta
			SetPedComponentVariation(ped, 9, 37, 0) -- Chaleco antibalas
			SetPedComponentVariation(ped, 10, 0, 0) -- Badge
			SetPedComponentVariation(ped, 11, 190, 0) -- Torso
			SetPedPropIndex(ped, 0, 121, 0, true) -- Casco
		elseif data.current.value == "patrulla2" then
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
		elseif data.current.value == "patrulla3" then
			-- Poner ropa temporal (no se guarda en la DB)
			SetPedComponentVariation(ped, 1, 0, 0) -- Máscara
			SetPedComponentVariation(ped, 3, 4, 0) -- Manos
			SetPedComponentVariation(ped, 4, 35, 0) -- Pantalones
			SetPedComponentVariation(ped, 5, 52, 0) -- Mochilas
			SetPedComponentVariation(ped, 6, 51, 0) -- Zapatos
			SetPedComponentVariation(ped, 7, 8, 0) -- Bufanda y collar
			SetPedComponentVariation(ped, 8, 56, 0) -- Camiseta
			SetPedComponentVariation(ped, 9, 0, 0) -- Chaleco antibalas
			SetPedComponentVariation(ped, 10, 0, 0) -- Badge
			SetPedComponentVariation(ped, 11, 200, 0) -- Torso
			SetPedPropIndex(ped, 0, 121, 0, true) -- Casco
		elseif data.current.value == "patrulla4" then
			-- Poner ropa temporal (no se guarda en la DB)
			SetPedComponentVariation(ped, 1, 101, 0) -- Máscara
			SetPedComponentVariation(ped, 3, 38, 0) -- Manos
			SetPedComponentVariation(ped, 4, 35, 0) -- Pantalones
			SetPedComponentVariation(ped, 5, 52, 0) -- Mochilas
			SetPedComponentVariation(ped, 6, 51, 0) -- Zapatos
			SetPedComponentVariation(ped, 7, 8, 0) -- Bufanda y collar
			SetPedComponentVariation(ped, 8, 56, 0) -- Camiseta
			SetPedComponentVariation(ped, 9, 28, 0) -- Chaleco antibalas
			SetPedComponentVariation(ped, 10, 0, 0) -- Badge
			SetPedComponentVariation(ped, 11, 154, 0) -- Torso
			SetPedPropIndex(ped, 0, 121, 0, true) -- Casco
		elseif data.current.value == "patrulla5" then
			-- Poner ropa temporal (no se guarda en la DB)
			SetPedComponentVariation(ped, 1, 101, 0) -- Máscara
			SetPedComponentVariation(ped, 3, 4, 0) -- Manos
			SetPedComponentVariation(ped, 4, 35, 0) -- Pantalones
			SetPedComponentVariation(ped, 5, 52, 0) -- Mochilas
			SetPedComponentVariation(ped, 6, 51, 0) -- Zapatos
			SetPedComponentVariation(ped, 7, 0, 0) -- Bufanda y collar
			SetPedComponentVariation(ped, 8, 65, 0) -- Camiseta
			SetPedComponentVariation(ped, 9, 31, 0) -- Chaleco antibalas
			SetPedComponentVariation(ped, 10, 0, 0) -- Badge
			SetPedComponentVariation(ped, 11, 189, 6) -- Torso
			SetPedPropIndex(ped, 0, 121, 0, true) -- Casco
		elseif data.current.value == "detective" then
			-- Poner ropa temporal (no se guarda en la DB)
			SetPedComponentVariation(ped, 1, 0, 0) -- Máscara
			SetPedComponentVariation(ped, 3, 12, 0) -- Manos
			SetPedComponentVariation(ped, 4, 10, 4) -- Pantalones
			SetPedComponentVariation(ped, 5, 0, 0) -- Mochilas
			SetPedComponentVariation(ped, 6, 10, 0) -- Zapatos
			SetPedComponentVariation(ped, 7, 6, 0) -- Bufanda y collar
			SetPedComponentVariation(ped, 8, 12, 5) -- Camiseta
			SetPedComponentVariation(ped, 9, 24, 0) -- Chaleco antibalas
			SetPedComponentVariation(ped, 10, 0, 0) -- Badge
			SetPedComponentVariation(ped, 11, 12, 0) -- Torso
			SetPedPropIndex(ped, 0, 121, 0, true) -- Casco
		elseif data.current.value == "moto" then
			-- Poner ropa temporal (no se guarda en la DB)
			SetPedComponentVariation(ped, 1, 101, 0) -- Máscara
			SetPedComponentVariation(ped, 3, 19, 0) -- Manos
			SetPedComponentVariation(ped, 4, 32, 1) -- Pantalones
			SetPedComponentVariation(ped, 5, 52, 0) -- Mochilas
			SetPedComponentVariation(ped, 6, 13, 0) -- Zapatos
			SetPedComponentVariation(ped, 7, 8, 0) -- Bufanda y collar
			SetPedComponentVariation(ped, 8, 56, 0) -- Camiseta
			SetPedComponentVariation(ped, 9, 37, 0) -- Chaleco antibalas
			SetPedComponentVariation(ped, 10, 0, 0) -- Badge
			SetPedComponentVariation(ped, 11, 190, 1) -- Torso
			SetPedPropIndex(ped, 0, 17, 1, true) -- Casco
		end
		
	end, function(data, menu)
			menu.close()
		end)
	end)
end
