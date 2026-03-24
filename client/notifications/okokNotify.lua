if Config.Notifications ~= 'okokNotify' then return end

local typeMap = {
    success = 'success',
    error = 'error',
    info = 'info',
    warning = 'warning',
}

Bridge.Notify.Send = function(message, type, duration)
    exports['okokNotify']:Alert('Notification', message, duration or 5000, typeMap[type] or 'info')
end
