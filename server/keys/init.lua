--[[
    Vehicle keys: public API + startup message.
    Loads after registry.lua and server/keys/backends/*.lua.
]]

local mode = Bridge.Keys._mode

if mode ~= 'none' and not Bridge.Keys._adapterChosen then
    Bridge.Print(('VehicleKeys: unknown or unsupported mode %q — set Config.VehicleKeys to a supported value or "custom"'):format(
        tostring(Config.VehicleKeys)
    ))
end

function Bridge.Keys.GrantForPlate(playerId, plate)
    local p = Bridge.Keys.NormalizePlate(plate)
    if not p or mode == 'none' then return end
    Bridge.Keys._grantAdapter(playerId, p)
end

function Bridge.Keys.RevokeForPlate(playerId, plate)
    local p = Bridge.Keys.NormalizePlate(plate)
    if not p or mode == 'none' then return end
    Bridge.Keys._revokeAdapter(playerId, p)
end

--- For qbx_vehiclekeys and similar: server needs a real vehicle entity (use net id from the spawning client).
function Bridge.Keys.GrantForNetworkId(playerId, netId)
    if mode == 'none' or type(netId) ~= 'number' or netId <= 0 then return end
    Bridge.Keys._grantNetAdapter(playerId, math.floor(netId))
end

function Bridge.Keys.RevokeForNetworkId(playerId, netId)
    if mode == 'none' or type(netId) ~= 'number' or netId <= 0 then return end
    Bridge.Keys._revokeNetAdapter(playerId, math.floor(netId))
end

function Bridge.Keys.GrantPlateList(playerId, plates)
    if type(plates) ~= 'table' then return end
    for _, pl in ipairs(plates) do
        Bridge.Keys.GrantForPlate(playerId, pl)
    end
end

function Bridge.Keys.RevokePlateList(playerId, plates)
    if type(plates) ~= 'table' then return end
    for _, pl in ipairs(plates) do
        Bridge.Keys.RevokeForPlate(playerId, pl)
    end
end

function Bridge.Keys.GrantNetworkIdList(playerId, netIds)
    if type(netIds) ~= 'table' then return end
    for _, nid in ipairs(netIds) do
        Bridge.Keys.GrantForNetworkId(playerId, tonumber(nid))
    end
end

function Bridge.Keys.RevokeNetworkIdList(playerId, netIds)
    if type(netIds) ~= 'table' then return end
    for _, nid in ipairs(netIds) do
        Bridge.Keys.RevokeForNetworkId(playerId, tonumber(nid))
    end
end

Bridge.Print(('Vehicle access bridge: %s'):format(mode))
