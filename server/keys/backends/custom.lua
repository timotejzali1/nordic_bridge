if Bridge.Keys._mode ~= 'custom' then return end

Bridge.Keys.RegisterAdapter(
    function(src, plate)
        TriggerEvent('nordic_bridge:keys:grantAccess', src, plate)
    end,
    function(src, plate)
        TriggerEvent('nordic_bridge:keys:revokeAccess', src, plate)
    end
)
