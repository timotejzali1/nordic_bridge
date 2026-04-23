--[[
    Vehicle keys: shared registry (mode resolution, plate normalize, export helpers).
    Backends in server/keys/backends/*.lua call Bridge.Keys.RegisterAdapter.
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

local ALIASES = {
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
    ['mrnewb'] = 'mrnewbkeys',
    ['mrnewbkeys'] = 'mrnewbkeys',
    ['mrnewbvehiclekeys'] = 'mrnewbkeys',
}

--- Canonical mode string after alias expansion (lowercase).
function Bridge.Keys.ResolveVehicleKeysMode()
    local mode = Config.VehicleKeys or 'none'
    if type(mode) ~= 'string' then
        return 'none'
    end
    mode = string.lower(mode)
    return ALIASES[mode] or mode
end

Bridge.Keys._mode = Bridge.Keys.ResolveVehicleKeysMode()

function Bridge.Keys.ResourceStarted(name)
    return GetResourceState(name) == 'started'
end

--- Try several export call styles; returns true if any pcall succeeded without error.
function Bridge.Keys.TryExport(resName, calls)
    if not Bridge.Keys.ResourceStarted(resName) then return false end
    local ex = exports[resName]
    if type(ex) ~= 'table' then return false end
    for _, call in ipairs(calls) do
        local ok = pcall(call, ex)
        if ok then return true end
    end
    return false
end

local function noop() end

Bridge.Keys._grantAdapter = noop
Bridge.Keys._revokeAdapter = noop
Bridge.Keys._grantNetAdapter = noop
Bridge.Keys._revokeNetAdapter = noop
Bridge.Keys._adapterChosen = false

--- Called by exactly one backend file that matches Config.VehicleKeys.
--- Optional 3rd/4th: grant/revoke by network id (required for qbx_vehiclekeys; noop for plate-only scripts).
function Bridge.Keys.RegisterAdapter(grantPlate, revokePlate, grantNetId, revokeNetId)
    Bridge.Keys._adapterChosen = true
    if type(grantPlate) == 'function' then
        Bridge.Keys._grantAdapter = grantPlate
    end
    if type(revokePlate) == 'function' then
        Bridge.Keys._revokeAdapter = revokePlate
    end
    if type(grantNetId) == 'function' then
        Bridge.Keys._grantNetAdapter = grantNetId
    end
    if type(revokeNetId) == 'function' then
        Bridge.Keys._revokeNetAdapter = revokeNetId
    end
end
