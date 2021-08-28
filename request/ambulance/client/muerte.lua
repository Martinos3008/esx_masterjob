RegisterNetEvent("esx:onPlayerDeath")
AddEventHandler('esx:onPlayerDeath', function(data)
	Citizen.Wait(3000)
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local heading = GetEntityHeading(ped)
	local deadAnimDict = "dead"
	local deadAnim = "dead_a"
	local deadCarAnimDict = "veh@low@front_ps@idle_duck"
	local deadCarAnim = "sit"
	
	isDead = true
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z + 0.5, heading, true, false)
	SetEntityInvincible(ped, true)
	SetEntityHealth(ped, GetEntityMaxHealth(GetPlayerPed(-1)))
	if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
		loadAnimDict("veh@low@front_ps@idle_duck")
		TaskPlayAnim(ped, "veh@low@front_ps@idle_duck", "sit", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
	else
		loadAnimDict(deadAnimDict)
		TaskPlayAnim(ped, deadAnimDict, deadAnim, 1.0, 1.0, -1, 1, 0, 0, 0, 0)
	end
end)

function loadAnimDict(dict)
	while(not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(1)
	end
end
