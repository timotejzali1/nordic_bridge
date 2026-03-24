if Config.Interact ~= 'ox_target' then return end

local function toVec3(c)
    if not c then return vector3(0.0, 0.0, 0.0) end
    if type(c) == 'vector3' or type(c) == 'vec3' then return vector3(c.x + 0.0, c.y + 0.0, c.z + 0.0) end
    local x = c.x or c[1] or 0.0
    local y = c.y or c[2] or 0.0
    local z = c.z or c[3] or 0.0
    return vector3(x + 0.0, y + 0.0, z + 0.0)
end

local function toVec3Size(s)
    if not s then return vector3(1.0, 1.0, 1.0) end
    if type(s) == 'vector3' or type(s) == 'vec3' then return vector3(s.x + 0.0, s.y + 0.0, s.z + 0.0) end
    local x = s.x or s[1] or 1.0
    local y = s.y or s[2] or 1.0
    local z = s.z or s[3] or 1.0
    return vector3(x + 0.0, y + 0.0, z + 0.0)
end

local function buildOptions(options)
    local oxOpts = {}
    for i, opt in ipairs(options or {}) do
        oxOpts[#oxOpts + 1] = {
            name = ('nordic_bridge_%s_%s'):format(i, GetGameTimer()),
            icon = opt.icon or 'fa-solid fa-hand',
            label = opt.label or 'Interact',
            onSelect = opt.onSelect,
            canInteract = opt.canInteract,
        }
    end
    return oxOpts
end

Bridge.Interact.AddSphereZone = function(data)
    if not Bridge.Interact._validateZoneData(data, 'AddSphereZone') then return nil end
    local coords = toVec3(data.coords)
    local radius = data.radius or 2.0
    local zoneId = exports.ox_target:addSphereZone({
        coords = coords,
        radius = radius,
        debug = data.debug,
        drawSprite = data.drawSprite,
        options = buildOptions(data.options),
    })
    return Bridge.Interact._newInteractHandle(function()
        exports.ox_target:removeZone(zoneId)
    end)
end

Bridge.Interact.AddBoxZone = function(data)
    if not Bridge.Interact._validateZoneData(data, 'AddBoxZone') then return nil end
    local coords = toVec3(data.coords)
    local size = toVec3Size(data.size)
    local rotation = data.rotation or data.heading or 0.0
    local zoneId = exports.ox_target:addBoxZone({
        coords = coords,
        size = size,
        rotation = rotation,
        debug = data.debug,
        drawSprite = data.drawSprite,
        options = buildOptions(data.options),
    })
    return Bridge.Interact._newInteractHandle(function()
        exports.ox_target:removeZone(zoneId)
    end)
end

Bridge.Interact.AddLocalEntity = function(entity, data)
    entity, data = Bridge.Interact._coerceAddLocalEntityArgs(entity, data)
    local handle = Bridge.Interact.NormalizeEntityHandle(entity)
    if not handle then
        Bridge.Error('Interact.AddLocalEntity: invalid entity. Pass a handle (number), numeric string, { vehicle = ent } / { entity = ent } / { netId = n }, or one table with those fields plus .options')
        return nil
    end
    exports.ox_target:addLocalEntity(handle, buildOptions(data.options))
    return Bridge.Interact._newInteractHandle(function()
        pcall(function()
            exports.ox_target:removeLocalEntity(handle)
        end)
    end)
end
