ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('masterjob:server:sex', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {["identifier"] = xPlayer.identifier}, function(result)
        cb(result[1].sex)
    end)
end)
