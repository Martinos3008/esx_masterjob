VehiculosEMS = function()
	ESX.UI.Menu.CloseAll() -- Cerramos todos los menús abiertos

	local elements =  {} -- Elementos vacíos, para añadir dinamismo al menú
	local ped = PlayerPedId() -- Variable ped

	if IsPedSittingInAnyVehicle(ped) then
        table.insert(elements, {label = "Guardar vehículo", value = "guardar"})
    else
        table.insert(elements, {label = "Sacar vehículo", value = "sacar"})
    end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'VehiculosEMS', {
		title    = "Vehículos EMS",
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)

		if data.current.value == "guardar" then
			GuardarVehEMS()
		elseif data.current.value == "sacar" then
			SacarVehEMS()
		end
	end, function(data, menu)
		menu.close()
	end)
end

GuardarVehEMS = function()
	vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	ESX.Game.DeleteVehicle(vehicle)
	ESX.UI.Menu.CloseAll()
end

SacarVehEMS = function()
	ESX.UI.Menu.CloseAll() -- Cerramos todos los menús abiertos

	local elements =  {
		{label = ("Ambulancia"),  value = 'ambulance', pos = vector3(296.07, -607.52, 43.33), heading = 70.56}, -- Copiar y pegar para añadir más
	} -- Elementos vacíos, para añadir dinamismo al menú
	local playerPed = PlayerPedId()
	local pedCoords = GetEntityCoords(playerPed)
	local pedHeading = GetEntityHeading(playerPed)

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'listaVehiculosEMS', {
		title    = "Lista de vehículos",
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)

	ESX.Game.SpawnVehicle(data.current.value, data.current.pos, data.current.heading, function(vehicle) 
    	SetVehicleNumberPlateText(vehicle, "LSC"..GetPlayerServerId(PlayerId()))   
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		menu.close()
		end)
	end, function(data, menu)
		menu.close()
	end)
end
