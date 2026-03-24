if Config.Inventory ~= 'qs-inventory' then return end

Bridge.Inventory.AddItem = function(source, item, count, metadata, slot)
    return exports['qs-inventory']:AddItem(source, item, count, slot, metadata)
end

Bridge.Inventory.RemoveItem = function(source, item, count, metadata, slot)
    return exports['qs-inventory']:RemoveItem(source, item, count, slot)
end

Bridge.Inventory.GetItemCount = function(source, item)
    local itemData = exports['qs-inventory']:GetItemByName(source, item)
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

Bridge.Inventory.HasItem = function(source, item, count)
    count = count or 1
    return Bridge.Inventory.GetItemCount(source, item) >= count
end

Bridge.Inventory.GetItem = function(source, item)
    return exports['qs-inventory']:GetItemByName(source, item)
end

Bridge.Inventory.GetItemBySlot = function(source, slot)
    return exports['qs-inventory']:GetItemBySlot(source, slot)
end

Bridge.Inventory.GetItemInfo = function(item)
    return exports['qs-inventory']:GetItemInfo(item)
end

Bridge.Inventory.GetPlayerInventory = function(source)
    return exports['qs-inventory']:GetPlayerInventory(source)
end

Bridge.Inventory.CanCarryItem = function(source, item, count)
    return exports['qs-inventory']:CanCarryItem(source, item, count)
end

Bridge.Inventory.SetMetadata = function(source, slot, metadata)
    exports['qs-inventory']:SetMetadata(source, slot, metadata)
end

Bridge.Inventory.RegisterStash = function(id, label, slots, weight)
    exports['qs-inventory']:RegisterStash(id, {
        label = label,
        slots = slots,
        weight = weight,
    })
end

Bridge.Inventory.OpenStash = function(source, id)
    exports['qs-inventory']:OpenStash(source, id)
end

Bridge.Inventory.RegisterShop = function(name, data)
    exports['qs-inventory']:RegisterShop(name, data)
end

Bridge.Inventory.OpenShop = function(source, name)
    exports['qs-inventory']:OpenShop(source, name)
end

Bridge.Inventory.ClearStash = function(id)
    exports['qs-inventory']:ClearStash(id)
end

Bridge.Inventory.GetImagePath = function(item)
    return ('nui://qs-inventory/html/images/%s.png'):format(item)
end

Bridge.Inventory.AddTrunkItems = function(plate, items)
    for _, v in pairs(items) do
        exports['qs-inventory']:AddItem(('trunk-%s'):format(plate), v.name, v.count, v.slot, v.metadata)
    end
end

Bridge.Inventory.AddItemsToTrunk = function(plate, items)
    return Bridge.Inventory.AddTrunkItems(plate, items)
end

Bridge.Inventory.UpdatePlate = function(oldPlate, newPlate)
    Bridge.Print('UpdatePlate is not natively supported in qs-inventory')
end
