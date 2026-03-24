if Config.Interact ~= 'ox_lib' then return end

--[[
    `lib` is per-resource: it only exists here if `fxmanifest.lua` includes `@ox_lib/init.lua` in shared_scripts
    (before this file). `exports.ox_lib` is not a drop-in for the full `lib` table (no `lib.points`).
]]
local lib = rawget(_G, 'lib')
if not lib or not lib.points or not lib.showTextUI then
    Bridge.Error('Interact (ox_lib): `lib` is not loaded. Add `@ox_lib/init.lua` at the top of `shared_scripts` in nordic_bridge/fxmanifest.lua and ensure `ox_lib` starts before `nordic_bridge`.')
    return
end

local function toVec3(c)
    if not c then return vector3(0.0, 0.0, 0.0) end
    if type(c) == 'vector3' or type(c) == 'vec3' then return vector3(c.x + 0.0, c.y + 0.0, c.z + 0.0) end
    local x = c.x or c[1] or 0.0
    local y = c.y or c[2] or 0.0
    local z = c.z or c[3] or 0.0
    return vector3(x + 0.0, y + 0.0, z + 0.0)
end

local function toVec3Size(s)
    if not s then return vector3(1.0, 1.0, 2.0) end
    if type(s) == 'vector3' or type(s) == 'vec3' then return vector3(s.x + 0.0, s.y + 0.0, s.z + 0.0) end
    local x = s.x or s[1] or 1.0
    local y = s.y or s[2] or 1.0
    local z = s.z or s[3] or 2.0
    return vector3(x + 0.0, y + 0.0, z + 0.0)
end

local CONTROL_E = 38
local SCROLL_DOWN = 14
local SCROLL_UP = 15

local function createSpherePoint(coords, radius, options, keyLabel)
    keyLabel = keyLabel or 'E'
    options = options or {}
    local state = { index = 1 }

    local point = lib.points.new({
        coords = coords,
        distance = math.max(radius + 5.0, 8.0),
        radius = radius,
        nearby = function(self)
            if self.currentDistance > radius then
                if self._showing then
                    lib.hideTextUI()
                    self._showing = false
                end
                return
            end

            if #options > 1 then
                if IsDisabledControlJustPressed(0, SCROLL_DOWN) then
                    state.index = state.index + 1
                    if state.index > #options then state.index = 1 end
                elseif IsDisabledControlJustPressed(0, SCROLL_UP) then
                    state.index = state.index - 1
                    if state.index < 1 then state.index = #options end
                end
            end

            local opt = options[state.index]
            if not opt then return end

            local text = ('[%s] %s'):format(keyLabel, opt.label or 'Interact')
            if #options > 1 then
                text = text .. ('  (%s/%s)'):format(state.index, #options)
            end
            lib.showTextUI(text)
            self._showing = true

            if IsControlJustReleased(0, CONTROL_E) then
                if opt.canInteract and not opt.canInteract(nil) then return end
                if opt.onSelect then opt.onSelect() end
            end
        end,
        onExit = function(self)
            if self._showing then
                lib.hideTextUI()
                self._showing = false
            end
        end,
    })

    return point
end

Bridge.Interact.AddSphereZone = function(data)
    if not Bridge.Interact._validateZoneData(data, 'AddSphereZone') then return nil end
    local coords = toVec3(data.coords)
    local radius = data.radius or 2.0
    local point = createSpherePoint(coords, radius, data.options, data.key)
    return Bridge.Interact._newInteractHandle(function()
        point:remove()
    end)
end

--- Approximate box as a point at center with radius = half diagonal in XY + Z extent
Bridge.Interact.AddBoxZone = function(data)
    if not Bridge.Interact._validateZoneData(data, 'AddBoxZone') then return nil end
    local coords = toVec3(data.coords)
    local size = toVec3Size(data.size)
    local dx, dy, dz = size.x / 2, size.y / 2, size.z / 2
    local radius = math.sqrt(dx * dx + dy * dy + dz * dz)
    local point = createSpherePoint(coords, math.max(radius, 1.0), data.options, data.key)
    return Bridge.Interact._newInteractHandle(function()
        point:remove()
    end)
end

Bridge.Interact.AddLocalEntity = function(entity, data)
    entity, data = Bridge.Interact._coerceAddLocalEntityArgs(entity, data)
    local handle = Bridge.Interact.NormalizeEntityHandle(entity)
    if not handle then
        Bridge.Error('Interact.AddLocalEntity: invalid entity. Pass a handle (number), numeric string, { vehicle = ent } / { entity = ent } / { netId = n }, or one table with those fields plus .options')
        return nil
    end
    local radius = data.distance or 2.5
    local options = data.options or {}
    local keyLabel = data.key or 'E'
    local state = { index = 1 }

    local point = lib.points.new({
        coords = vector3(0.0, 0.0, 0.0),
        distance = radius + 10.0,
        nearby = function(self)
            local okExist, exists = pcall(DoesEntityExist, handle)
            if not okExist or not exists then
                if self._showing then lib.hideTextUI() self._showing = false end
                return
            end

            self.coords = GetEntityCoords(handle)

            if self.currentDistance > radius then
                if self._showing then
                    lib.hideTextUI()
                    self._showing = false
                end
                return
            end

            if #options > 1 then
                if IsDisabledControlJustPressed(0, SCROLL_DOWN) then
                    state.index = state.index + 1
                    if state.index > #options then state.index = 1 end
                elseif IsDisabledControlJustPressed(0, SCROLL_UP) then
                    state.index = state.index - 1
                    if state.index < 1 then state.index = #options end
                end
            end

            local opt = options[state.index]
            if not opt then return end

            local text = ('[%s] %s'):format(keyLabel, opt.label or 'Interact')
            if #options > 1 then
                text = text .. ('  (%s/%s)'):format(state.index, #options)
            end
            lib.showTextUI(text)
            self._showing = true

            if IsControlJustReleased(0, CONTROL_E) then
                if opt.canInteract and not opt.canInteract(handle) then return end
                if opt.onSelect then opt.onSelect(handle) end
            end
        end,
        onExit = function(self)
            if self._showing then
                lib.hideTextUI()
                self._showing = false
            end
        end,
    })

    return Bridge.Interact._newInteractHandle(function()
        pcall(function() lib.hideTextUI() end)
        point:remove()
    end)
end
