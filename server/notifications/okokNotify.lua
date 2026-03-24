if Config.Notifications ~= 'okokNotify' then return end

local typeMap = {
    success = 'success',
    error = 'error',
    info = 'info',
    warning = 'warning',
}

Bridge.Notify.SendToPlayer = function(source, message, type, duration)
    TriggerClientEvent('okokNotify:Alert', source, 'Notification', message, duration or 5000, typeMap[type] or 'info')
end
