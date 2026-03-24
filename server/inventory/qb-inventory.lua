if Config.Inventory ~= 'qb-inventory' then return end

local QBCore = exports['qb-core']:GetCoreObject()

Bridge.Inventory.AddItem = function(source, item, count, metadata, slot)
    return exports['qb-inventory']:AddItem(source, item, count, slot, metadata)
end

Bridge.Inventory.RemoveItem = function(source, item, count, metadata, slot)
    return exports['qb-inventory']:RemoveItem(source, item, count, slot)
end

Bridge.Inventory.GetItemCount = function(source, item)
    local items = exports['qb-inventory']:GetItemsByName(source, item)
    if not items then return 0 end
    local total = 0
    for _, v in pairs(items) do
        total = total + (v.amount or 0)
    end
    return total
end

Bridge.Inventory.HasItem = function(source, item, count)
    count = count or 1
    return Bridge.Inventory.GetItemCount(source, item) >= count
end

Bridge.Inventory.GetItem = function(source, item)
    return exports['qb-inventory']:GetItemByName(source, item)
end

Bridge.Inventory.GetItemBySlot = function(source, slot)
    return exports['qb-inventory']:GetItemBySlot(source, slot)
end

Bridge.Inventory.GetItemInfo = function(item)
    local items = QBCore.Shared.Items
    if not items then return nil end
    return items[item]
end

Bridge.Inventory.GetPlayerInventory = function(source)
    local player = QBCore.Functions.GetPlayer(source)
    if not player then return {} end
    return player.PlayerData.items or {}
end

Bridge.Inventory.CanCarryItem = function(source, item, count)
    local totalWeight = exports['qb-inventory']:GetTotalWeight(source)
    local maxWeight = exports['qb-inventory']:GetMaxWeight(source)
    if not totalWeight or not maxWeight then return true end
    return totalWeight + (count * 100) <= maxWeight
end

Bridge.Inventory.SetMetadata = function(source, slot, metadata)
    exports['qb-inventory']:SetItemData(source, slot, 'info', metadata)
end

Bridge.Inventory.RegisterStash = function(id, label, slots, weight)
    Bridge.Print('RegisterStash is not natively supported in qb-inventory')
end

Bridge.Inventory.OpenStash = function(source, id)
    TriggerClientEvent('qb-inventory:client:openStash', source, id)
end

Bridge.Inventory.RegisterShop = function(name, data)
    Bridge.Print('RegisterShop is not natively supported in qb-inventory')
end

Bridge.Inventory.OpenShop = function(source, name)
    TriggerClientEvent('qb-inventory:client:openShop', source, name)
end

Bridge.Inventory.ClearStash = function(id)
    Bridge.Print('ClearStash is not natively supported in qb-inventory')
end

Bridge.Inventory.GetImagePath = function(item)
    return ('nui://qb-inventory/html/images/%s.png'):format(item)
end

Bridge.Inventory.AddTrunkItems = function(plate, items)
    local stashId = ('trunk-%s'):format(plate)
    for _, v in pairs(items) do
        exports['qb-inventory']:AddItem(stashId, v.name, v.count, v.slot, v.metadata)
    end
end

Bridge.Inventory.AddItemsToTrunk = function(plate, items)
    return Bridge.Inventory.AddTrunkItems(plate, items)
end

Bridge.Inventory.UpdatePlate = function(oldPlate, newPlate)
    Bridge.Print('UpdatePlate is not natively supported in qb-inventory')
end
