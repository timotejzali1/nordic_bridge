if Config.Inventory ~= 'qb-inventory' then return end

local QBCore = exports['qb-core']:GetCoreObject()

Bridge.Inventory.HasItem = function(item, count)
    count = count or 1
    return exports['qb-inventory']:HasItem(item, count)
end

Bridge.Inventory.GetItemCount = function(item)
    local itemData = exports['qb-inventory']:GetItemByName(item)
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
    local items = QBCore.Shared.Items
    if not items then return nil end
    return items[item]
end

Bridge.Inventory.GetPlayerInventory = function()
    local data = QBCore.Functions.GetPlayerData()
    if not data then return {} end
    return data.items or {}
end

Bridge.Inventory.GetImagePath = function(item)
    return ('nui://qb-inventory/html/images/%s.png'):format(item)
end

Bridge.Inventory.AddItem = function(item, count, metadata, slot)
    Bridge.Error('AddItem is a server-only function')
    return false
end

Bridge.Inventory.RemoveItem = function(item, count, metadata, slot)
    Bridge.Error('RemoveItem is a server-only function')
    return false
end
