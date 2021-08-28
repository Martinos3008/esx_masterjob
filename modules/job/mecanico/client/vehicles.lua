VehiculosMecanico = function()
	ESX.UI.Menu.CloseAll() -- Cerramos todos los menús abiertos

	local elements =  {} -- Elementos vacíos, para añadir dinamismo al menú
	local ped = PlayerPedId() -- Variable ped

	if IsPedSittingInAnyVehicle(ped) then
        table.insert(elements, {label = "Guardar vehículo", value = "guardar"})
    else
        table.insert(elements, {label = "Sacar vehículo", value = "sacar"})
    end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'VehiculosMecanico', {
		title    = "Vehículos Mecanico",
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)

		if data.current.value == "guardar" then
			GuardarVehMecanico()
		elseif data.current.value == "sacar" then
			SacarVehMecanico()
		end
	end, function(data, menu)
		menu.close()
	end)
end

GuardarVehMecanico = function()
	vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	ESX.Game.DeleteVehicle(vehicle)
	ESX.UI.Menu.CloseAll()
end

SacarVehMecanico = function()
	ESX.UI.Menu.CloseAll() -- Cerramos todos los menús abiertos

	local elements =  {
		{label = ("Grúa"),  value = 'towtruck', pos = vector3(-222.13864135742,-1293.1690673828,31.295974731445), heading = 74.43}, -- Copiar y pegar para añadir más
	} -- Elementos vacíos, para añadir dinamismo al menú
	local playerPed = PlayerPedId()
	local pedCoords = GetEntityCoords(playerPed)
	local pedHeading = GetEntityHeading(playerPed)

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'listaVehiculosMecanico', {
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
