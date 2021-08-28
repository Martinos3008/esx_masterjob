ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'banda', "Alerta policial", true, true)
TriggerEvent('esx_society:registerSociety', 'banda', 'banda', 'society_banda', 'society_banda', 'society_banda', {type = 'public'})

RegisterServerEvent('banda:server:sacar')
AddEventHandler('banda:server:sacar', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_banda', function(inventory)
		local item = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and item.count >= count then

			-- can the player carry the said amount of x item?
			if xPlayer.canCarryItem(itemName, count) then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				xPlayer.showNotification("Has retirado " .. count .. "x de " .. item.label)
			else
				xPlayer.showNotification("No tienes suficiente espacio")
			end
		else
			xPlayer.showNotification("Cantidad inválida")
		end
	end)
end)

ESX.RegisterServerCallback('banda:server:sacarcb', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_banda', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterServerEvent('banda:server:trash')
AddEventHandler('banda:server:trash', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_banda', function(inventory)
		local item = inventory.getItem(itemName)
		local playerItemCount = xPlayer.getInventoryItem(itemName).count

		if item.count >= 0 and count <= playerItemCount then
			xPlayer.removeInventoryItem(itemName, count)
		else
			xPlayer.showNotification("Cantidad inválida")
		end

		xPlayer.showNotification("Has depositado " ..count.. "x de " .. item.label)
	end)
end)

RegisterServerEvent('banda:server:depositar')
AddEventHandler('banda:server:depositar', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_banda', function(inventory)
		local item = inventory.getItem(itemName)
		local playerItemCount = xPlayer.getInventoryItem(itemName).count

		if item.count >= 0 and count <= playerItemCount then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
		else
			xPlayer.showNotification("Cantidad inválida")
		end

		xPlayer.showNotification("Has depositado " ..count.. "x de " .. item.label)
	end)
end)

ESX.RegisterServerCallback('banda:server:depositarcb', function(source, cb)
	local xPlayer    = ESX.GetPlayerFromId(source)
	local items      = xPlayer.inventory

	cb({items = items})
end)
