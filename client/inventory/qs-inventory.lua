if Config.Inventory ~= 'qs-inventory' then return end

Bridge.Inventory.HasItem = function(item, count)
    count = count or 1
    return exports['qs-inventory']:HasItem(item, count)
end

Bridge.Inventory.GetItemCount = function(item)
    local itemData = exports['qs-inventory']:GetItemByName(item)
    if not itemData then return 0 end
    if type(itemData) == 'table' and itemData.amount then
        return itemData.amount
    end
    if type(itemData) == 'table' then
        local total = 0
        for _, v in pairs(itemData) do
            total = total + (v.amount or 0)
        end
        return total
    end
    return 0
end

Bridge.Inventory.GetItemInfo = function(item)
    return exports['qs-inventory']:GetItemInfo(item)
end

Bridge.Inventory.GetPlayerInventory = function()
    return exports['qs-inventory']:GetPlayerInventory()
end

Bridge.Inventory.GetImagePath = function(item)
    return ('nui://qs-inventory/html/images/%s.png'):format(item)
end

Bridge.Inventory.AddItem = function(item, count, metadata, slot)
    Bridge.Error('AddItem is a server-only function')
    return false
end

Bridge.Inventory.RemoveItem = function(item, count, metadata, slot)
    Bridge.Error('RemoveItem is a server-only function')
    return false
end
