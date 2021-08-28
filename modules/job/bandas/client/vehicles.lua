Vehiculosbanda = function()
	ESX.UI.Menu.CloseAll() -- Cerramos todos los menús abiertos

	local elements =  {} -- Elementos vacíos, para añadir dinamismo al menú
	local ped = PlayerPedId() -- Variable ped

	if IsPedSittingInAnyVehicle(ped) then
        table.insert(elements, {label = "Guardar vehículo", value = "guardar"})
    else
        table.insert(elements, {label = "Sacar vehículo", value = "sacar"})
    end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Vehiculosbanda', {
		title    = "Vehículos banda",
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)

		if data.current.value == "guardar" then
			GuardarVehbanda()
		elseif data.current.value == "sacar" then
			SacarVehbanda()
		end
	end, function(data, menu)
		menu.close()
	end)
end

GuardarVehbanda = function()
	vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	ESX.Game.DeleteVehicle(vehicle)
	ESX.UI.Menu.CloseAll()
end

SacarVehbanda = function()
	ESX.UI.Menu.CloseAll() -- Cerramos todos los menús abiertos

	local elements =  {
		{label = ("Dubsta"),  value = 'dubsta', pos = vector3(-1518.3728027344,884.91143798828,181.79252624512), heading = 91.11},
		{label = ("6X6"),  value = 'guardian', pos = vector3(-1518.3728027344,884.91143798828,181.79252624512), heading = 74.43},
		{label = ("Kuruma"),  value = 'Kuruma', pos = vector3(-1518.3728027344,884.91143798828,181.79252624512), heading = 74.43},

	} -- Elementos vacíos, para añadir dinamismo al menú
	local playerPed = PlayerPedId()
	local pedCoords = GetEntityCoords(playerPed)
	local pedHeading = GetEntityHeading(playerPed)

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'banda', {
		title    = "Lista de vehículos",
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)

	ESX.Game.SpawnVehicle(data.current.value, data.current.pos, data.current.heading, function(vehicle) 
    	SetVehicleNumberPlateText(vehicle, "banda"..GetPlayerServerId(PlayerId()))   
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		menu.close()
		end)
	end, function(data, menu)
		menu.close()
	end)
end
