if Config.Notifications ~= 'ox_lib' then return end

Bridge.Notify.SendToPlayer = function(source, message, type, duration)
    TriggerClientEvent('ox_lib:notify', source, {
        description = message,
        type = type or 'info',
        duration = duration or 5000,
    })
end
