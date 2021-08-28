local blips = {
    -- Example {title="", colour=, id=, x=, y=, z=},

     {title="Comisaría N°21", colour=30, id=60, x = 433.87, y = -981.94, z = 30.71},
     {title="Hospital", colour=27, id=61, x = 300.52319335938, y = -586.46820068359, z = 43.283988952637},
     {title="Taller Mecánico Sur", colour=46, id=402, x = -359.46, y = -133.65, z = 38.68},
  }
      
Citizen.CreateThread(function()

    for _, info in pairs(blips) do
      info.blip = AddBlipForCoord(info.x, info.y, info.z)
      SetBlipSprite(info.blip, info.id)
      SetBlipDisplay(info.blip, 4)
      SetBlipScale(info.blip, 0.8)
      SetBlipColour(info.blip, info.colour)
      SetBlipAsShortRange(info.blip, true)
	    BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(info.title)
      EndTextCommandSetBlipName(info.blip)
    end
end)
