-- Framework exports
exports('GetPlayerData', function(...) return Bridge.Framework.GetPlayerData(...) end)
exports('GetPlayerJob', function(...) return Bridge.Framework.GetPlayerJob(...) end)
exports('GetPlayerGang', function(...) return Bridge.Framework.GetPlayerGang(...) end)
exports('GetPlayerName', function(...) return Bridge.Framework.GetPlayerName(...) end)
exports('IsPlayerLoaded', function(...) return Bridge.Framework.IsPlayerLoaded(...) end)
exports('GetPlayerMoney', function(...) return Bridge.Framework.GetPlayerMoney(...) end)

-- Inventory exports
exports('HasItem', function(...) return Bridge.Inventory.HasItem(...) end)
exports('GetItemCount', function(...) return Bridge.Inventory.GetItemCount(...) end)
exports('GetItemInfo', function(...) return Bridge.Inventory.GetItemInfo(...) end)
exports('GetPlayerInventory', function(...) return Bridge.Inventory.GetPlayerInventory(...) end)
exports('GetImagePath', function(...) return Bridge.Inventory.GetImagePath(...) end)
exports('AddItem', function(...) return Bridge.Inventory.AddItem(...) end)
exports('RemoveItem', function(...) return Bridge.Inventory.RemoveItem(...) end)

-- Notification exports (table form survives some cross-resource call paths better than 3 loose args)
exports('Notify', function(a, b, c)
    if type(a) == 'table' then
        local msg = a.description or a.message or a.title or a.text
        return Bridge.Notify.Send(msg, a.type or a.notifyType or 'info', a.duration or 5000)
    end
    return Bridge.Notify.Send(a, b, c)
end)

-- Clothing exports
exports('OpenClothingMenu', function(...) return Bridge.Clothing.OpenMenu(...) end)
exports('OpenOutfitMenu', function(...) return Bridge.Clothing.OpenOutfitMenu(...) end)
exports('GetCurrentClothes', function(...) return Bridge.Clothing.GetCurrentClothes(...) end)
exports('SetClothes', function(...) return Bridge.Clothing.SetClothes(...) end)
exports('SaveOutfit', function(...) return Bridge.Clothing.SaveOutfit(...) end)
exports('LoadOutfit', function(...) return Bridge.Clothing.LoadOutfit(...) end)
exports('GetPedModel', function(...) return Bridge.Clothing.GetPedModel(...) end)
exports('SetPedModel', function(...) return Bridge.Clothing.SetPedModel(...) end)

-- TextUI exports
exports('ShowTextUI', function(...) return Bridge.TextUI.Show(...) end)
exports('HideTextUI', function(...) return Bridge.TextUI.Hide(...) end)

-- Interact exports (client only)
exports('InteractAddSphereZone', function(data) return Bridge.Interact.AddSphereZone(data) end)
exports('InteractAddBoxZone', function(data) return Bridge.Interact.AddBoxZone(data) end)
-- Prefer (handle, data) with handle as number — most reliable across resources.
-- Fallback: one table { entity = h, vehicle = h, _handle = h, [1] = h, options = {...} } if a runtime drops the first arg.
exports('InteractAddLocalEntity', function(entity, data) return Bridge.Interact.AddLocalEntity(entity, data) end)
exports('InteractRemove', function(id) return Bridge.Interact.Remove(id) end)

-- Master export returning the full bridge table
exports('GetBridge', function()
    return Bridge
end)
