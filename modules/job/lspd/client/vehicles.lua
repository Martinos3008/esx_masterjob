VehiculosLSPD = function()
	ESX.UI.Menu.CloseAll() -- Cerramos todos los menús abiertos

	local elements =  {} -- Elementos vacíos, para añadir dinamismo al menú
	local ped = PlayerPedId() -- Variable ped

	if IsPedSittingInAnyVehicle(ped) then
        table.insert(elements, {label = "Guardar vehículo", value = "guardar"})
    else
        table.insert(elements, {label = "Sacar vehículo", value = "sacar"})
    end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'VehiculosLSPD', {
		title    = "Vehículos LSPD",
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)

		if data.current.value == "guardar" then
			GuardarVehLSPD()
		elseif data.current.value == "sacar" then
			SacarVehLSPD()
		end
	end, function(data, menu)
		menu.close()
	end)
end

GuardarVehLSPD = function()
	vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	ESX.Game.DeleteVehicle(vehicle)
	ESX.UI.Menu.CloseAll()
end

SacarVehLSPD = function()
	ESX.UI.Menu.CloseAll() -- Cerramos todos los menús abiertos

	local elements =  {
		{label = ("Patrulla"),  value = 'police', pos = vector3(455.46, -1017.73, 27.11), heading = 91.11},
		{label = ("Grúa"),  value = 'towtruck', pos = vector3(-354.51, -115.79, 37.75), heading = 74.43},
	} -- Elementos vacíos, para añadir dinamismo al menú
	local playerPed = PlayerPedId()
	local pedCoords = GetEntityCoords(playerPed)
	local pedHeading = GetEntityHeading(playerPed)

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'listaVehiculosLSPD', {
		title    = "Lista de vehículos",
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)

	ESX.Game.SpawnVehicle(data.current.value, data.current.pos, data.current.heading, function(vehicle) 
    	SetVehicleNumberPlateText(vehicle, "LSPD"..GetPlayerServerId(PlayerId()))   
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		menu.close()
		end)
	end, function(data, menu)
		menu.close()
	end)
end
