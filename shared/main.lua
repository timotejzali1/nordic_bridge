Bridge = {
    Framework = {},
    Inventory = {},
    Notify = {},
    Clothing = {},
    TextUI = {},
    Interact = {},
    Keys = {},
}

function Bridge.Print(msg)
    print('^3[nordic_bridge]^0 ' .. tostring(msg))
end

function Bridge.Error(msg)
    print('^1[nordic_bridge] ERROR:^0 ' .. tostring(msg))
end

Bridge.Print(('Loaded | Framework: %s | Inventory: %s | Notifications: %s | Clothing: %s | TextUI: %s | Interact: %s | VehicleKeys: %s'):format(
    Config.Framework, Config.Inventory, Config.Notifications, Config.Clothing, Config.TextUI, Config.Interact, Config.VehicleKeys or 'none'
))
