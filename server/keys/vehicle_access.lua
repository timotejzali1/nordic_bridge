--[[
    Vehicle key / access adapters (server-side).
    One backend from Config.VehicleKeys. Grant/revoke are best-effort across common forks.
]]

Bridge.Keys = Bridge.Keys or {}

local function trim(s)
    if not s then return '' end
    return (string.gsub(tostring(s), '^%s*(.-)%s*$', '%1'))
end

--- Normalize for scripts that expect uppercase, no leading/trailing spaces.
function Bridge.Keys.NormalizePlate(plate)
    local t = trim(plate)
    if t == '' then return nil end
    return string.upper(t)
end

local mode = Config.VehicleKeys or 'none'
if type(mode) ~= 'string' then
    mode = 'none'
else
    mode = string.lower(mode)
end

local aliases = {
    ['qb'] = 'qb-vehiclekeys',
    ['qb_vehiclekeys'] = 'qb-vehiclekeys',
    ['qbx'] = 'qbx_vehiclekeys',
    ['qbx-vehiclekeys'] = 'qbx_vehiclekeys',
    ['wasabi'] = 'wasabi_carlock',
    ['mk'] = 'mk_vehiclekeys',
    ['qs'] = 'qs-vehiclekeys',
    ['renewed'] = 'renewed-vehiclekeys',
    ['renewed_vehiclekeys'] = 'renewed-vehiclekeys',
    ['cd'] = 'cd_garage',
    ['okok'] = 'okokgarage',
}

mode = aliases[mode] or mode

local function resStarted(name)
    return GetResourceState(name) == 'started'
end

local function tryExport(resName, calls)
    if not resStarted(resName) then return false end
    local ex = exports[resName]
    if type(ex) ~= 'table' then return false end
    for _, call in ipairs(calls) do
        local ok = pcall(call, ex)
        if ok then return true end
    end
    return false
end

local grant = function() end
local revoke = function() end

if mode == 'none' then
    -- no-op
elseif mode == 'custom' then
    grant = function(src, plate)
        TriggerEvent('nordic_bridge:keys:grantAccess', src, plate)
    end
    revoke = function(src, plate)
        TriggerEvent('nordic_bridge:keys:revokeAccess', src, plate)
    end

elseif mode == 'qb-vehiclekeys' then
    grant = function(src, plate)
        if tryExport('qb-vehiclekeys', {
                function(e) e:GiveKeys(src, plate) end,
                function(e) e.GiveKeys(e, src, plate) end,
            }) then return end
        TriggerClientEvent('qb-vehiclekeys:client:AddKeys', src, plate)
        TriggerClientEvent('vehiclekeys:client:SetOwner', src, plate)
    end
    revoke = function(src, plate)
        tryExport('qb-vehiclekeys', {
            function(e) e:RemoveKeys(src, plate) end,
            function(e) e.RemoveKeys(e, src, plate) end,
        })
        TriggerClientEvent('qb-vehiclekeys:client:RemoveKeys', src, plate)
    end

elseif mode == 'qbx_vehiclekeys' then
    grant = function(src, plate)
        if tryExport('qbx_vehiclekeys', {
                function(e) e:GiveKeys(src, plate) end,
                function(e) e.GiveKeys(src, nil, plate) end,
            }) then return end
        TriggerClientEvent('qb-vehiclekeys:client:AddKeys', src, plate)
        TriggerClientEvent('qbx_vehiclekeys:client:AddKeys', src, plate)
    end
    revoke = function(src, plate)
        tryExport('qbx_vehiclekeys', {
            function(e) e:RemoveKeys(src, plate) end,
        })
        TriggerClientEvent('qb-vehiclekeys:client:RemoveKeys', src, plate)
        TriggerClientEvent('qbx_vehiclekeys:client:RemoveKeys', src, plate)
    end

elseif mode == 'wasabi_carlock' then
    grant = function(src, plate)
        tryExport('wasabi_carlock', {
            function(e) e:GiveKey(src, plate) end,
            function(e) e:GiveKeys(src, plate) end,
        })
        TriggerClientEvent('wasabi_carlock:client:GiveKeys', src, plate)
    end
    revoke = function(src, plate)
        tryExport('wasabi_carlock', {
            function(e) e:RemoveKey(src, plate) end,
            function(e) e:RemoveKeys(src, plate) end,
        })
        TriggerClientEvent('wasabi_carlock:client:RemoveKeys', src, plate)
    end

elseif mode == 'mk_vehiclekeys' then
    grant = function(src, plate)
        tryExport('mk_vehiclekeys', {
            function(e) e:GiveKeys(src, plate) end,
            function(e) e:GiveKeys(plate, src) end,
            function(e) e.GiveKeys(e, src, plate) end,
        })
    end
    revoke = function(src, plate)
        tryExport('mk_vehiclekeys', {
            function(e) e:RemoveKeys(src, plate) end,
            function(e) e:RemoveKeys(plate, src) end,
        })
    end

elseif mode == 'qs-vehiclekeys' then
    grant = function(src, plate)
        tryExport('qs-vehiclekeys', {
            function(e) e:GiveServerKeys(src, plate, nil, false) end,
            function(e) e:GiveServerKeys(src, plate) end,
            function(e) e:GiveKeys(src, plate) end,
        })
        TriggerClientEvent('qs-vehiclekeys:client:AddKeys', src, plate)
    end
    revoke = function(src, plate)
        tryExport('qs-vehiclekeys', {
            function(e) e:RemoveServerKeys(src, plate) end,
            function(e) e:RemoveKeys(src, plate) end,
        })
        TriggerClientEvent('qs-vehiclekeys:client:RemoveKeys', src, plate)
    end

elseif mode == 'renewed-vehiclekeys' then
    grant = function(src, plate)
        tryExport('Renewed-Vehiclekeys', {
            function(e) e:addKey(src, plate) end,
            function(e) e:AddKey(src, plate) end,
            function(e) e:giveKeys(src, plate) end,
        })
    end
    revoke = function(src, plate)
        tryExport('Renewed-Vehiclekeys', {
            function(e) e:removeKey(src, plate) end,
            function(e) e:RemoveKey(src, plate) end,
        })
    end

elseif mode == 'cd_garage' then
    grant = function(src, plate)
        TriggerClientEvent('cd_garage:AddKeys', src, plate)
        tryExport('cd_garage', {
            function(e) e:GiveKeys(src, plate) end,
        })
    end
    revoke = function(src, plate)
        TriggerClientEvent('cd_garage:RemoveKeys', src, plate)
        tryExport('cd_garage', {
            function(e) e:RemoveKeys(src, plate) end,
        })
    end

elseif mode == 'okokgarage' then
    grant = function(src, plate)
        TriggerClientEvent('okokGarage:GiveKeys', src, plate)
        tryExport('okokGarage', {
            function(e) e:GiveKeys(src, plate) end,
        })
    end
    revoke = function(src, plate)
        TriggerClientEvent('okokGarage:RemoveKeys', src, plate)
    end

elseif mode == 'esx_vehiclelock' or mode == 'esx' then
    -- Community scripts differ; fire common client events and optional exports.
    grant = function(src, plate)
        TriggerClientEvent('esx_vehiclelock:givekey', src, plate)
        TriggerClientEvent('vehiclelock:givekey', src, plate)
        tryExport('esx_vehiclelock', {
            function(e) e:giveVehicleKey(src, plate) end,
        })
    end
    revoke = function(src, plate)
        TriggerClientEvent('esx_vehiclelock:removekey', src, plate)
        tryExport('esx_vehiclelock', {
            function(e) e:removeVehicleKey(src, plate) end,
        })
    end

else
    Bridge.Print(('VehicleKeys: unknown mode %q — set Config.VehicleKeys to a supported value or "custom"'):format(tostring(Config.VehicleKeys)))
end

function Bridge.Keys.GrantForPlate(playerId, plate)
    local p = Bridge.Keys.NormalizePlate(plate)
    if not p or mode == 'none' then return end
    grant(playerId, p)
end

function Bridge.Keys.RevokeForPlate(playerId, plate)
    local p = Bridge.Keys.NormalizePlate(plate)
    if not p or mode == 'none' then return end
    revoke(playerId, p)
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

Bridge.Print(('Vehicle access bridge: %s'):format(mode))
