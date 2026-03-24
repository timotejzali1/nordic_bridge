if Config.Notifications ~= 'ox_lib' then return end

local lib = _G.lib or exports.ox_lib

Bridge.Notify.Send = function(message, type, duration)
    lib.notify({
        description = message,
        type = type or 'info',
        duration = duration or 5000,
    })
end
