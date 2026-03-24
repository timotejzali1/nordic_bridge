if Config.Clothing ~= 'illenium-appearance' then return end

local function ia()
    return exports['illenium-appearance']
end

--- illenium-appearance versions differ: getPedAppearance(ped) vs GetPlayerAppearance()
local function getLocalAppearance()
    local exp = ia()
    if not exp then return nil end
    local ped = PlayerPedId()

    local attempts = {
        function() return exp:getPedAppearance(ped) end,
        function() return type(exp.getPedAppearance) == 'function' and exp.getPedAppearance(ped) end,
        function() return exp:GetPedAppearance(ped) end,
        function() return exp:GetPlayerAppearance(ped) end,
        function() return exp:GetPlayerAppearance() end,
        function() return type(exp.getPlayerAppearance) == 'function' and exp.getPlayerAppearance(ped) end,
    }

    for _, try in ipairs(attempts) do
        local ok, result = pcall(try)
        if ok and result ~= nil then
            return result
        end
    end
    return nil
end

Bridge.Clothing.OpenMenu = function(data)
    exports['illenium-appearance']:startPlayerCustomization(function(appearance)
        if appearance then
            TriggerServerEvent('illenium-appearance:server:saveAppearance', appearance)
        end
    end, data)
end

Bridge.Clothing.OpenOutfitMenu = function()
    exports['illenium-appearance']:startOutfitManager()
end

Bridge.Clothing.GetCurrentClothes = function()
    return getLocalAppearance()
end

Bridge.Clothing.SetClothes = function(appearance)
    if not appearance then return end
    local exp = ia()
    if exp.setPlayerAppearance then
        pcall(function() exp:setPlayerAppearance(appearance) end)
        return
    end
    if exp.SetPlayerAppearance then
        pcall(function() exp:SetPlayerAppearance(appearance) end)
        return
    end
    pcall(function() exports['illenium-appearance']:setPlayerAppearance(appearance) end)
end

Bridge.Clothing.SaveOutfit = function(name)
    local appearance = getLocalAppearance()
    if not appearance then return false end
    TriggerServerEvent('nordic_bridge:clothing:saveOutfit', name, appearance)
    return true
end

Bridge.Clothing.LoadOutfit = function(outfitData)
    if not outfitData then return false end
    Bridge.Clothing.SetClothes(outfitData)
    return true
end

Bridge.Clothing.GetPedModel = function()
    return GetEntityModel(PlayerPedId())
end

Bridge.Clothing.SetPedModel = function(model)
    if type(model) == 'string' then model = joaat(model) end
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end
    SetPlayerModel(PlayerId(), model)
    SetModelAsNoLongerNeeded(model)
end
