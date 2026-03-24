--[[
    qbx_vehiclekeys: GiveKeys / RemoveKeys expect (source, vehicleEntity, skipNotification?).
    Vehicle must be a server entity id (we resolve from net id). Plates are not supported here.

    Official export style (see qbx_vehiclekeys docs):
      exports.qbx_vehiclekeys:GiveKeys(source, vehicle, skipNotification)
      exports.qbx_vehiclekeys:RemoveKeys(source, vehicle, skipNotification)
]]

if Bridge.Keys._mode ~= 'qbx_vehiclekeys' then return end

local function entityFromNet(netId)
    local veh = NetworkGetEntityFromNetworkId(netId)
    if not veh or veh == 0 or not DoesEntityExist(veh) then return nil end
    return veh
end

local function giveKeys(src, veh, skipNotification)
    local ok, err = pcall(function()
        exports.qbx_vehiclekeys:GiveKeys(src, veh, skipNotification == true)
    end)
    if not ok then
        Bridge.Error(('qbx_vehiclekeys GiveKeys: %s'):format(tostring(err)))
        return false
    end
    return true
end

local function removeKeys(src, veh, skipNotification)
    local ok, err = pcall(function()
        exports.qbx_vehiclekeys:RemoveKeys(src, veh, skipNotification == true)
    end)
    if not ok then
        Bridge.Error(('qbx_vehiclekeys RemoveKeys: %s'):format(tostring(err)))
        return false
    end
    return true
end

local function grantNet(src, netId)
    local veh = entityFromNet(netId)
    if veh then
        giveKeys(src, veh, true)
        return
    end
    CreateThread(function()
        for _ = 1, 35 do
            Wait(150)
            veh = entityFromNet(netId)
            if veh then
                giveKeys(src, veh, true)
                return
            end
        end
        Bridge.Error(('qbx_vehiclekeys: no server entity for netId %s (player %s)'):format(tostring(netId), tostring(src)))
    end)
end

local function revokeNet(src, netId)
    local veh = entityFromNet(netId)
    if veh then
        removeKeys(src, veh, true)
        return
    end
    CreateThread(function()
        for _ = 1, 15 do
            Wait(100)
            veh = entityFromNet(netId)
            if veh then
                removeKeys(src, veh, true)
                return
            end
        end
    end)
end

Bridge.Keys.RegisterAdapter(
    function() end,
    function() end,
    grantNet,
    revokeNet
)
