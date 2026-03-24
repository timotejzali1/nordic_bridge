if Config.Inventory ~= 'ox_inventory' then return end

Bridge.Inventory.AddItem = function(source, item, count, metadata, slot)
    return exports.ox_inventory:AddItem(source, item, count, metadata, slot)
end

Bridge.Inventory.RemoveItem = function(source, item, count, metadata, slot)
    return exports.ox_inventory:RemoveItem(source, item, count, metadata, slot)
end

Bridge.Inventory.GetItemCount = function(source, item)
    local itemData = exports.ox_inventory:GetItem(source, item)
    if type(itemData) == 'table' and itemData.count then
        return itemData.count
    end
    return itemData or 0
end

Bridge.Inventory.HasItem = function(source, item, count)
    count = count or 1
    return Bridge.Inventory.GetItemCount(source, item) >= count
end

Bridge.Inventory.GetItem = function(source, item)
    return exports.ox_inventory:GetItem(source, item)
end

Bridge.Inventory.GetItemBySlot = function(source, slot)
    return exports.ox_inventory:GetSlot(source, slot)
end

Bridge.Inventory.GetItemInfo = function(item)
    local items = exports.ox_inventory:Items()
    if not items then return nil end
    return items[item]
end

Bridge.Inventory.GetPlayerInventory = function(source)
    return exports.ox_inventory:GetInventoryItems(source)
end

Bridge.Inventory.CanCarryItem = function(source, item, count)
    return exports.ox_inventory:CanCarryItem(source, item, count)
end

Bridge.Inventory.SetMetadata = function(source, slot, metadata)
    exports.ox_inventory:SetMetadata(source, slot, metadata)
end

Bridge.Inventory.RegisterStash = function(id, label, slots, weight)
    exports.ox_inventory:RegisterStash(id, label, slots, weight)
end

Bridge.Inventory.OpenStash = function(source, id)
    TriggerClientEvent('ox_inventory:openInventory', source, 'stash', id)
end

Bridge.Inventory.RegisterShop = function(name, data)
    exports.ox_inventory:RegisterShop(name, data)
end

Bridge.Inventory.OpenShop = function(source, name)
    TriggerClientEvent('ox_inventory:openInventory', source, 'shop', name)
end

Bridge.Inventory.ClearStash = function(id)
    exports.ox_inventory:ClearInventory(id)
end

Bridge.Inventory.GetImagePath = function(item)
    return ('nui://ox_inventory/web/images/%s.png'):format(item)
end

Bridge.Inventory.AddTrunkItems = function(plate, items)
    for _, v in pairs(items) do
        exports.ox_inventory:AddItem(('trunk-%s'):format(plate), v.name, v.count, v.metadata)
    end
end

Bridge.Inventory.AddItemsToTrunk = function(plate, items)
    return Bridge.Inventory.AddTrunkItems(plate, items)
end

Bridge.Inventory.UpdatePlate = function(oldPlate, newPlate)
    exports.ox_inventory:UpdateVehicle(oldPlate, newPlate)
end
