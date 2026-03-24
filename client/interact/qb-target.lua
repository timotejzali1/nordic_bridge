if Config.Interact ~= 'qb-target' then return end

local function toVec3(c)
    if not c then return vector3(0.0, 0.0, 0.0) end
    if type(c) == 'vector3' or type(c) == 'vec3' then return vector3(c.x, c.y, c.z) end
    local x = c.x or c[1] or 0.0
    local y = c.y or c[2] or 0.0
    local z = c.z or c[3] or 0.0
    return vector3(x + 0.0, y + 0.0, z + 0.0)
end

local function uniqueZoneName()
    return ('nordic_bridge_zone_%s_%s'):format(GetGameTimer(), math.random(100000, 999999))
end

local function buildOptions(options, entityArg)
    local out = {}
    for _, opt in ipairs(options or {}) do
        out[#out + 1] = {
            type = 'client',
            icon = opt.icon or 'fas fa-hand',
            label = opt.label or 'Interact',
            action = function(ent)
                local e = ent or entityArg
                if opt.canInteract and not opt.canInteract(e) then return end
                if opt.onSelect then opt.onSelect(e) end
            end,
        }
    end
    return out
end

Bridge.Interact.AddSphereZone = function(data)
    if not Bridge.Interact._validateZoneData(data, 'AddSphereZone') then return nil end
    local coords = toVec3(data.coords)
    local radius = data.radius or 2.0
    local zoneName = data.name or uniqueZoneName()
    local distance = data.distance or math.max(radius * 1.5, 2.5)

    exports['qb-target']:AddCircleZone(zoneName, coords, radius, {
        name = zoneName,
        debugPoly = data.debug or false,
        useZ = data.useZ ~= false,
    }, {
        options = buildOptions(data.options),
        distance = distance,
    })

    return Bridge.Interact._newInteractHandle(function()
        exports['qb-target']:RemoveZone(zoneName)
    end)
end

Bridge.Interact.AddBoxZone = function(data)
    if not Bridge.Interact._validateZoneData(data, 'AddBoxZone') then return nil end
    local coords = toVec3(data.coords)
    local length = data.length or (data.size and (data.size.x or data.size[1])) or 1.5
    local width = data.width or (data.size and (data.size.y or data.size[2])) or 1.5
    local zoneName = data.name or uniqueZoneName()
    local heading = data.rotation or data.heading or 0.0
    local minZ = data.minZ or (coords.z - ((data.size and (data.size.z or data.size[3])) or 1.0) / 2)
    local maxZ = data.maxZ or (coords.z + ((data.size and (data.size.z or data.size[3])) or 3.0) / 2)
    local distance = data.distance or 2.5

    exports['qb-target']:AddBoxZone(zoneName, coords, length, width, {
        name = zoneName,
        heading = heading,
        debugPoly = data.debug or false,
        minZ = minZ,
        maxZ = maxZ,
    }, {
        options = buildOptions(data.options),
        distance = distance,
    })

    return Bridge.Interact._newInteractHandle(function()
        exports['qb-target']:RemoveZone(zoneName)
    end)
end

Bridge.Interact.AddLocalEntity = function(entity, data)
    entity, data = Bridge.Interact._coerceAddLocalEntityArgs(entity, data)
    local handle = Bridge.Interact.NormalizeEntityHandle(entity)
    if not handle then
        Bridge.Error('Interact.AddLocalEntity: invalid entity. Pass a handle (number), numeric string, { vehicle = ent } / { entity = ent } / { netId = n }, or one table with those fields plus .options')
        return nil
    end
    local distance = data.distance or 2.5

    exports['qb-target']:AddTargetEntity(handle, {
        options = buildOptions(data.options, handle),
        distance = distance,
    })

    return Bridge.Interact._newInteractHandle(function()
        pcall(function()
            exports['qb-target']:RemoveTargetEntity(handle)
        end)
    end)
end
