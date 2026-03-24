-- Framework exports
exports('GetPlayer', function(...) return Bridge.Framework.GetPlayer(...) end)
exports('GetPlayerIdentifier', function(...) return Bridge.Framework.GetPlayerIdentifier(...) end)
exports('GetPlayerName', function(...) return Bridge.Framework.GetPlayerName(...) end)
exports('GetPlayerJob', function(...) return Bridge.Framework.GetPlayerJob(...) end)
exports('GetPlayerGang', function(...) return Bridge.Framework.GetPlayerGang(...) end)
exports('GetPlayerMoney', function(...) return Bridge.Framework.GetPlayerMoney(...) end)
exports('AddMoney', function(...) return Bridge.Framework.AddMoney(...) end)
exports('RemoveMoney', function(...) return Bridge.Framework.RemoveMoney(...) end)
exports('GetPlayers', function(...) return Bridge.Framework.GetPlayers(...) end)

-- Inventory exports
exports('AddItem', function(...) return Bridge.Inventory.AddItem(...) end)
exports('RemoveItem', function(...) return Bridge.Inventory.RemoveItem(...) end)
exports('GetItemCount', function(...) return Bridge.Inventory.GetItemCount(...) end)
exports('HasItem', function(...) return Bridge.Inventory.HasItem(...) end)
exports('GetItem', function(...) return Bridge.Inventory.GetItem(...) end)
exports('GetItemBySlot', function(...) return Bridge.Inventory.GetItemBySlot(...) end)
exports('GetItemInfo', function(...) return Bridge.Inventory.GetItemInfo(...) end)
exports('GetPlayerInventory', function(...) return Bridge.Inventory.GetPlayerInventory(...) end)
exports('CanCarryItem', function(...) return Bridge.Inventory.CanCarryItem(...) end)
exports('SetMetadata', function(...) return Bridge.Inventory.SetMetadata(...) end)
exports('RegisterStash', function(...) return Bridge.Inventory.RegisterStash(...) end)
exports('OpenStash', function(...) return Bridge.Inventory.OpenStash(...) end)
exports('RegisterShop', function(...) return Bridge.Inventory.RegisterShop(...) end)
exports('OpenShop', function(...) return Bridge.Inventory.OpenShop(...) end)
exports('ClearStash', function(...) return Bridge.Inventory.ClearStash(...) end)
exports('GetImagePath', function(...) return Bridge.Inventory.GetImagePath(...) end)
exports('AddTrunkItems', function(...) return Bridge.Inventory.AddTrunkItems(...) end)
exports('AddItemsToTrunk', function(...) return Bridge.Inventory.AddItemsToTrunk(...) end)
exports('UpdatePlate', function(...) return Bridge.Inventory.UpdatePlate(...) end)

-- Notification exports
exports('NotifyPlayer', function(...) return Bridge.Notify.SendToPlayer(...) end)

-- Clothing exports
exports('GetPlayerAppearance', function(...) return Bridge.Clothing.GetPlayerAppearance(...) end)
exports('SetPlayerAppearance', function(...) return Bridge.Clothing.SetPlayerAppearance(...) end)
exports('SaveOutfit', function(...) return Bridge.Clothing.SaveOutfit(...) end)
exports('LoadOutfit', function(...) return Bridge.Clothing.LoadOutfit(...) end)
exports('GetOutfits', function(...) return Bridge.Clothing.GetOutfits(...) end)
exports('DeleteOutfit', function(...) return Bridge.Clothing.DeleteOutfit(...) end)

-- Vehicle keys / access (server; see Config.VehicleKeys)
exports('KeysGrantJobVehicle', function(playerId, plate)
    if Bridge.Keys and Bridge.Keys.GrantForPlate then
        return Bridge.Keys.GrantForPlate(playerId, plate)
    end
end)
exports('KeysRevokeJobVehicle', function(playerId, plate)
    if Bridge.Keys and Bridge.Keys.RevokeForPlate then
        return Bridge.Keys.RevokeForPlate(playerId, plate)
    end
end)
exports('KeysGrantJobVehicleNet', function(playerId, netId)
    if Bridge.Keys and Bridge.Keys.GrantForNetworkId then
        return Bridge.Keys.GrantForNetworkId(playerId, netId)
    end
end)
exports('KeysRevokeJobVehicleNet', function(playerId, netId)
    if Bridge.Keys and Bridge.Keys.RevokeForNetworkId then
        return Bridge.Keys.RevokeForNetworkId(playerId, netId)
    end
end)
exports('KeysNormalizePlate', function(plate)
    if Bridge.Keys and Bridge.Keys.NormalizePlate then
        return Bridge.Keys.NormalizePlate(plate)
    end
end)

-- Master export returning the full bridge table
exports('GetBridge', function()
    return Bridge
end)

-- Outfit save handler (called from client clothing bridges)
RegisterNetEvent('nordic_bridge:clothing:saveOutfit', function(name, outfitData)
    local source = source
    if Bridge.Clothing.SaveOutfit then
        Bridge.Clothing.SaveOutfit(source, name, outfitData)
    end
end)

-- Create outfit storage table if it doesn't exist
CreateThread(function()
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS `nordic_outfits` (
            `id` INT AUTO_INCREMENT PRIMARY KEY,
            `identifier` VARCHAR(60) NOT NULL,
            `name` VARCHAR(50) NOT NULL,
            `outfit` LONGTEXT NOT NULL,
            UNIQUE KEY `identifier_name` (`identifier`, `name`)
        )
    ]])
    Bridge.Print('Outfit storage table verified')
end)
