Config = {}

-- Framework: 'esx' | 'qbcore' | 'qbox'
Config.Framework = 'esx'

-- Inventory: 'ox_inventory' | 'qb-inventory' | 'qs-inventory'
Config.Inventory = 'ox_inventory'

-- Notifications: 'ox_lib' | 'okokNotify'
Config.Notifications = 'ox_lib'

-- Clothing: 'illenium-appearance' | 'rcore_clothing' | 'qb-clothing'
Config.Clothing = 'illenium-appearance'

-- TextUI: 'ox_lib'
Config.TextUI = 'ox_lib'

-- Interact / targeting (client only): 'ox_target' | 'qb-target' | 'nordic_interact' | 'ox_lib'
-- Use 'ox_lib' as fallback when you do not run ox_target, qb-target, or nordic_interact.
Config.Interact = 'nordic_interact'

-- Vehicle keys (server): grants/removes access for job vehicles. Use 'none' if you have no key script.
-- Supported: 'none', 'qb-vehiclekeys', 'qbx_vehiclekeys', 'wasabi_carlock', 'mk_vehiclekeys',
-- 'qs-vehiclekeys', 'renewed-vehiclekeys', 'cd_garage', 'okokgarage', 'esx_vehiclelock', 'custom'
-- Aliases: 'qb', 'qbx', 'wasabi', 'mk', 'qs', 'renewed', 'cd', 'okok', 'esx'
-- 'custom' fires server events: nordic_bridge:keys:grantAccess / nordic_bridge:keys:revokeAccess (src, plate)
-- qbx_vehiclekeys: use KeysGrantJobVehicleNet / KeysRevokeJobVehicleNet (plate-only exports are ignored for qbx).
Config.VehicleKeys = 'none'
