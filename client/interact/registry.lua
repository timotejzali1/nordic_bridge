--[[
    Interact registry: handle IDs, Remove(), and stubs (overwritten by the active Config.Interact bridge).
]]

Bridge.Interact = Bridge.Interact or {}

local handles = {}
local nextId = 1

--- Natives like DoesEntityExist require a number (entity handle). Strings/tables cause "invalid lua type in __data".
--- Accepts: number, numeric string, or a table with any common ref key (see scalarKeys / netKeys below).
---@param entity any
---@return number|nil handle
function Bridge.Interact.NormalizeEntityHandle(entity)
    if entity == nil then return nil end
    local t = type(entity)
    if t == 'number' then
        local n = math.floor(entity + 0.0)
        if n == 0 then return nil end
        return n
    end
    -- FiveM may surface handles as userdata / cdata in some runtimes
    if t == 'userdata' then
        local n = tonumber(entity)
        if n then
            n = math.floor(n + 0.0)
            if n ~= 0 then return n end
        end
        return nil
    end
    if t == 'string' then
        local n = tonumber(entity)
        if not n then return nil end
        n = math.floor(n + 0.0)
        if n == 0 then return nil end
        return n
    end
    if t == 'table' then
        local scalarKeys = {
            'entity', 'handle', 'ent', 'e',
            '_handle', '_ent', -- avoid serializers that strip reserved-ish keys
            'vehicle', 'veh', 'car',
            'ped', 'npc',
            'prop', 'object', 'obj',
            1,
        }
        for _, k in ipairs(scalarKeys) do
            local v = entity[k]
            if v ~= nil then
                local h = Bridge.Interact.NormalizeEntityHandle(v)
                if h then return h end
            end
        end

        local netKeys = { 'netId', 'networkId', 'net_id', 'NetworkId' }
        for _, k in ipairs(netKeys) do
            local v = entity[k]
            if v ~= nil then
                local nid = Bridge.Interact.NormalizeEntityHandle(v)
                if nid then
                    local ent = NetworkGetEntityFromNetworkId(nid)
                    if ent and ent ~= 0 then return ent end
                end
            end
        end
        return nil
    end
    return nil
end

--- Supports both `AddLocalEntity(handle, { options = ... })` and a single table `{ vehicle = h, options = ... }`.
--- Also fixes swapped args: `AddLocalEntity({ options = ... }, handle)` (data table first, entity second).
---@return any entityOrTable  First arg to pass to NormalizeEntityHandle
---@return table data
function Bridge.Interact._coerceAddLocalEntityArgs(entity, data)
    if type(entity) == 'table' and type(data) == 'number' then
        entity, data = data, entity
    end
    -- Prefer explicit (handle, data): survives cross-resource export better than one big table with callbacks in .options
    if type(entity) == 'number' then
        if type(data) ~= 'table' then
            data = {}
        end
        if data.options == nil then
            data.options = {}
        end
        return entity, data
    end
    if type(entity) == 'table' and type(data) ~= 'table' then
        data = {
            options = entity.options or {},
            distance = entity.distance,
            key = entity.key,
            color = entity.color,
        }
        -- Single-table API: resolve entity / vehicle / netId to a client handle so backends always get a number when possible.
        local resolved = Bridge.Interact.NormalizeEntityHandle(entity)
        if resolved then
            entity = resolved
        end
    end
    if data == nil then
        data = {}
    end
    if data.options == nil then
        data.options = {}
    end
    return entity, data
end

---@param remover function Called when Bridge.Interact.Remove(id) is used
---@return number id
function Bridge.Interact._newInteractHandle(remover)
    local id = nextId
    nextId = nextId + 1
    handles[id] = remover
    return id
end

--- Remove a previously added interact (zone / entity / point).
---@param id number
---@return boolean success
function Bridge.Interact.Remove(id)
    local fn = handles[id]
    if not fn then return false end
    pcall(fn)
    handles[id] = nil
    return true
end

local function stub(fnName)
    return function(...)
        Bridge.Error(('Interact.%s: no bridge matched Config.Interact = %s'):format(fnName, tostring(Config.Interact)))
        return nil
    end
end

Bridge.Interact.AddSphereZone = stub('AddSphereZone')
Bridge.Interact.AddBoxZone = stub('AddBoxZone')
Bridge.Interact.AddLocalEntity = stub('AddLocalEntity')

--- Cross-resource exports often turn the whole argument into nil if it contains vector3 userdata etc.
function Bridge.Interact._validateZoneData(data, fnName)
    if type(data) ~= 'table' then
        Bridge.Error(('Interact.%s: expected a data table (got %s). From another resource, use plain coords { x, y, z } — vector3 userdata can be dropped by the export boundary.'):format(
            fnName or 'AddSphereZone', type(data)))
        return false
    end
    return true
end
