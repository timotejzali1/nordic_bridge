if Config.Clothing ~= 'qb-clothing' then return end

Bridge.Clothing.OpenMenu = function(data)
    TriggerEvent('qb-clothing:client:openMenu')
end

Bridge.Clothing.OpenOutfitMenu = function()
    TriggerEvent('qb-clothing:client:openOutfits')
end

Bridge.Clothing.GetCurrentClothes = function()
    local ped = PlayerPedId()
    local clothes = {}

    for i = 0, 11 do
        clothes[i] = {
            drawable = GetPedDrawableVariation(ped, i),
            texture = GetPedTextureVariation(ped, i),
            palette = GetPedPaletteVariation(ped, i),
        }
    end

    clothes.props = {}
    for i = 0, 8 do
        clothes.props[i] = {
            drawable = GetPedPropIndex(ped, i),
            texture = GetPedPropTextureIndex(ped, i),
        }
    end

    return clothes
end

Bridge.Clothing.SetClothes = function(clothingData)
    local ped = PlayerPedId()

    for componentId, data in pairs(clothingData) do
        if componentId ~= 'props' and type(componentId) == 'number' then
            SetPedComponentVariation(ped, componentId, data.drawable or 0, data.texture or 0, data.palette or 0)
        end
    end

    if clothingData.props then
        for propId, data in pairs(clothingData.props) do
            if data.drawable == -1 then
                ClearPedProp(ped, propId)
            else
                SetPedPropIndex(ped, propId, data.drawable or 0, data.texture or 0, true)
            end
        end
    end
end

Bridge.Clothing.SaveOutfit = function(name)
    local clothes = Bridge.Clothing.GetCurrentClothes()
    if not clothes then return false end
    TriggerServerEvent('nordic_bridge:clothing:saveOutfit', name, clothes)
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
