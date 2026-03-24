if Config.Inventory ~= 'ox_inventory' then return end

Bridge.Inventory.HasItem = function(item, count)
    count = count or 1
    local itemCount = exports.ox_inventory:Search('count', item)
    if type(itemCount) == 'table' then
        local total = 0
        for _, v in pairs(itemCount) do total = total + v end
        return total >= count
    end
    return (itemCount or 0) >= count
end

Bridge.Inventory.GetItemCount = function(item)
    local itemCount = exports.ox_inventory:Search('count', item)
    if type(itemCount) == 'table' then
        local total = 0
        for _, v in pairs(itemCount) do total = total + v end
        return total
    end
    return itemCount or 0
end

Bridge.Inventory.GetItemInfo = function(item)
    local items = exports.ox_inventory:Items()
    if not items then return nil end
    return items[item]
end

Bridge.Inventory.GetPlayerInventory = function()
    return exports.ox_inventory:GetPlayerItems()
end

Bridge.Inventory.GetImagePath = function(item)
    return ('nui://ox_inventory/web/images/%s.png'):format(item)
end

Bridge.Inventory.AddItem = function(item, count, metadata, slot)
    Bridge.Error('AddItem is a server-only function')
    return false
end

Bridge.Inventory.RemoveItem = function(item, count, metadata, slot)
    Bridge.Error('RemoveItem is a server-only function')
    return false
end
