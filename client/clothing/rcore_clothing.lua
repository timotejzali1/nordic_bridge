if Config.Clothing ~= 'rcore_clothing' then return end

Bridge.Clothing.OpenMenu = function(data)
    TriggerEvent('rcore_clothing:openMenu')
end

Bridge.Clothing.OpenOutfitMenu = function()
    TriggerEvent('rcore_clothing:openOutfits')
end

Bridge.Clothing.GetCurrentClothes = function()
    return exports['rcore_clothing']:getCurrentClothing()
end

Bridge.Clothing.SetClothes = function(clothingData)
    exports['rcore_clothing']:setPlayerClothing(clothingData)
end

Bridge.Clothing.SaveOutfit = function(name)
    local clothes = exports['rcore_clothing']:getCurrentClothing()
    if not clothes then return false end
    TriggerServerEvent('nordic_bridge:clothing:saveOutfit', name, clothes)
    return true
end

Bridge.Clothing.LoadOutfit = function(outfitData)
    if not outfitData then return false end
    exports['rcore_clothing']:setPlayerClothing(outfitData)
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
