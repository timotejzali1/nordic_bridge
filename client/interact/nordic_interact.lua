if Config.Interact ~= 'nordic_interact' then return end

Bridge.Interact._nordicCb = Bridge.Interact._nordicCb or {}

if not Bridge.Interact._nordicHandlerRegistered then
    Bridge.Interact._nordicHandlerRegistered = true
    AddEventHandler('nordic_interact:selected', function(interactId, selectedIndex, _optionLabel)
        local pack = Bridge.Interact._nordicCb[interactId]
        if not pack or not pack.options then return end
        local opt = pack.options[(selectedIndex or 0) + 1]
        if not opt then return end
        if opt.canInteract and not opt.canInteract(pack.entity) then return end
        if opt.onSelect then
            opt.onSelect(pack.entity)
        end
    end)
end

local function toVec3(c)
    if not c then return vector3(0.0, 0.0, 0.0) end
    if type(c) == 'vector3' or type(c) == 'vec3' then return vector3(c.x, c.y, c.z) end
    local x = c.x or c[1] or 0.0
    local y = c.y or c[2] or 0.0
    local z = c.z or c[3] or 0.0
    return vector3(x + 0.0, y + 0.0, z + 0.0)
end

local function safeDoesEntityExist(handle)
    if type(handle) ~= 'number' or handle == 0 then return false end
    local ok, exists = pcall(DoesEntityExist, handle)
    return ok and not not exists
end

local function buildNordicOptions(options)
    local out = {}
    for i, opt in ipairs(options or {}) do
        out[#out + 1] = {
            label = opt.label or 'Interact',
            primary = i == 1,
        }
    end
    return out
end

local function nordicAdd(payload, bridgeOptions, entityForCb)
    local nordicId = exports['nordic_interact']:AddInteract(payload)
    if not nordicId then return nil end

    Bridge.Interact._nordicCb[nordicId] = {
        options = bridgeOptions or {},
        entity = entityForCb,
    }

    return Bridge.Interact._newInteractHandle(function()
        exports['nordic_interact']:RemoveInteract(nordicId)
        Bridge.Interact._nordicCb[nordicId] = nil
    end)
end

Bridge.Interact.AddSphereZone = function(data)
    if not Bridge.Interact._validateZoneData(data, 'AddSphereZone') then return nil end
    local coords = toVec3(data.coords)
    local radius = data.radius or 2.5
    local opts = data.options or {}
    local nordicOpts = buildNordicOptions(opts)

    return nordicAdd({
        type = 'location',
        target = coords,
        options = nordicOpts,
        key = data.key or 'E',
        distance = radius,
        color = data.color,
    }, opts, nil)
end

Bridge.Interact.AddBoxZone = function(data)
    if not Bridge.Interact._validateZoneData(data, 'AddBoxZone') then return nil end
    local coords = toVec3(data.coords)
    local sx = (data.size and (data.size.x or data.size[1])) or 1.5
    local sy = (data.size and (data.size.y or data.size[2])) or 1.5
    local approx = math.sqrt(sx * sx + sy * sy) / 2 + 0.5
    local opts = data.options or {}
    local nordicOpts = buildNordicOptions(opts)

    return nordicAdd({
        type = 'location',
        target = coords,
        options = nordicOpts,
        key = data.key or 'E',
        distance = data.distance or approx,
        color = data.color,
    }, opts, nil)
end

local function entityNordicType(handle)
    if not safeDoesEntityExist(handle) then return 'prop' end
    local okV, isVeh = pcall(IsEntityAVehicle, handle)
    if okV and isVeh then return 'vehicle' end
    local okP, isPed = pcall(IsEntityAPed, handle)
    if okP and isPed then return 'ped' end
    return 'prop'
end

Bridge.Interact.AddLocalEntity = function(entity, data)
    entity, data = Bridge.Interact._coerceAddLocalEntityArgs(entity, data)
    local handle = Bridge.Interact.NormalizeEntityHandle(entity)
    if not handle then
        Bridge.Error('Interact.AddLocalEntity: invalid entity. Pass a handle (number), numeric string, { vehicle = ent } / { entity = ent } / { netId = n }, or one table with those fields plus .options')
        return nil
    end
    local opts = data.options or {}
    local nordicOpts = buildNordicOptions(opts)

    return nordicAdd({
        type = entityNordicType(handle),
        target = handle,
        options = nordicOpts,
        key = data.key or 'E',
        distance = data.distance or 2.5,
        color = data.color,
    }, opts, handle)
end
