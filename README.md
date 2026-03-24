# nordic_bridge
=======
# Nordic Bridge

Universal compatibility bridge for FiveM. Configure your framework, inventory, notifications, clothing, TextUI, and interact/targeting once — every script that depends on `nordic_bridge` will use the same settings automatically.

## Supported Systems

| Category | Options |
|---|---|
| **Framework** | `esx`, `qbcore`, `qbox` |
| **Inventory** | `ox_inventory`, `qb-inventory`, `qs-inventory` |
| **Notifications** | `ox_lib`, `okokNotify` |
| **Clothing** | `illenium-appearance`, `rcore_clothing`, `qb-clothing` |
| **TextUI** | `ox_lib` |
| **Interact** | `ox_target`, `qb-target`, `nordic_interact`, `ox_lib` (fallback) |
| **Vehicle keys** | `none`, `qb-vehiclekeys`, `qbx_vehiclekeys`, `wasabi_carlock`, `mk_vehiclekeys`, `qs-vehiclekeys`, `renewed-vehiclekeys`, `cd_garage`, `okokgarage`, `esx_vehiclelock`, `custom` |

## Installation

1. Place `nordic_bridge` in your resources folder.
2. Add `ensure nordic_bridge` to your `server.cfg` **before** any scripts that depend on it.
3. Edit `config.lua` to match your server setup.

## Configuration

```lua
Config.Framework     = 'esx'                  -- 'esx' | 'qbcore' | 'qbox'
Config.Inventory     = 'ox_inventory'          -- 'ox_inventory' | 'qb-inventory' | 'qs-inventory'
Config.Notifications = 'ox_lib'                -- 'ox_lib' | 'okokNotify'
Config.Clothing      = 'illenium-appearance'   -- 'illenium-appearance' | 'rcore_clothing' | 'qb-clothing'
Config.TextUI        = 'ox_lib'                -- 'ox_lib'
Config.Interact      = 'ox_lib'                -- 'ox_target' | 'qb-target' | 'nordic_interact' | 'ox_lib'
Config.VehicleKeys   = 'none'                -- see table above; use 'custom' + server events for unsupported scripts
```

## Usage in Other Scripts

Add the dependency in your script's `fxmanifest.lua`:

```lua
dependencies { 'nordic_bridge' }
```

Then use either the **Bridge table** or **individual exports**:

```lua
-- Bridge table (recommended)
local Bridge = exports['nordic_bridge']:GetBridge()
Bridge.Framework.GetPlayerData()
Bridge.Inventory.HasItem('lockpick')
Bridge.Notify.Send('Hello!', 'success', 5000)

-- Individual exports
exports['nordic_bridge']:HasItem('lockpick', 1)
exports['nordic_bridge']:Notify('Hello!', 'success', 5000)
exports['nordic_bridge']:AddItem(source, 'bread', 3)

-- Interact (client only)
local id = exports['nordic_bridge']:InteractAddSphereZone({
    coords = vector3(100.0, 200.0, 20.0),
    radius = 2.0,
    options = {
        { label = 'Open', icon = 'fa-solid fa-door-open', onSelect = function() print('opened') end },
    },
})
exports['nordic_bridge']:InteractRemove(id)
```

### Vehicle keys (server)

Code layout: `server/keys/registry.lua` (shared helpers + mode), `server/keys/backends/*.lua` (one adapter per script), `server/keys/init.lua` (public `Bridge.Keys.*` API). Add a new backend by creating a file in `backends/` that matches `Bridge.Keys._mode` and calls `Bridge.Keys.RegisterAdapter(grantFn, revokeFn)`.

Set `Config.VehicleKeys` to match your key/lock script. Other resources can grant or remove access by plate:

```lua
exports['nordic_bridge']:KeysGrantJobVehicle(source, plateString)
exports['nordic_bridge']:KeysRevokeJobVehicle(source, plateString)
-- qbx_vehiclekeys needs a vehicle entity on the server; use net id from the client that spawned it:
exports['nordic_bridge']:KeysGrantJobVehicleNet(source, netId)
exports['nordic_bridge']:KeysRevokeJobVehicleNet(source, netId)
exports['nordic_bridge']:KeysNormalizePlate(plateString) -- optional helper
```

With `Config.VehicleKeys = 'custom'`, listen on the server:

- `AddEventHandler('nordic_bridge:keys:grantAccess', function(src, plate) end)`
- `AddEventHandler('nordic_bridge:keys:revokeAccess', function(src, plate) end)`

`Bridge.Keys.GrantForPlate`, `RevokeForPlate`, `GrantPlateList`, and `RevokePlateList` are also on `GetBridge()` (server).

---

## Client Functions

### Framework — `Bridge.Framework.*`

| Function | Parameters | Returns | Description |
|---|---|---|---|
| `GetPlayerData()` | — | `table` | Full player data object from the framework |
| `GetPlayerJob()` | — | `table` | `{ name, label, grade, grade_name }` |
| `GetPlayerGang()` | — | `table` | `{ name, label, grade, grade_name }` — ESX always returns `none` |
| `GetPlayerName()` | — | `string` | First and last name |
| `IsPlayerLoaded()` | — | `boolean` | Whether the player data has loaded |
| `GetPlayerMoney(moneyType)` | `moneyType`: `string` (optional, default `'money'`/`'cash'`) | `number` | Amount of the specified money type |

**Exports:**
```lua
exports['nordic_bridge']:GetPlayerData()
exports['nordic_bridge']:GetPlayerJob()
exports['nordic_bridge']:GetPlayerGang()
exports['nordic_bridge']:GetPlayerName()
exports['nordic_bridge']:IsPlayerLoaded()
exports['nordic_bridge']:GetPlayerMoney('cash')
```

---

### Inventory — `Bridge.Inventory.*`

| Function | Parameters | Returns | Description |
|---|---|---|---|
| `HasItem(item, count)` | `item`: `string`, `count`: `number` (optional, default `1`) | `boolean` | Check if player has at least `count` of `item` |
| `GetItemCount(item)` | `item`: `string` | `number` | Total count of item in inventory |
| `GetItemInfo(item)` | `item`: `string` | `table\|nil` | Registered item definition (label, weight, etc.) |
| `GetPlayerInventory()` | — | `table` | Full inventory items table |
| `GetImagePath(item)` | `item`: `string` | `string` | NUI path to the item's image |
| `AddItem(...)` | — | — | Prints error — server-only function |
| `RemoveItem(...)` | — | — | Prints error — server-only function |

**Exports:**
```lua
exports['nordic_bridge']:HasItem('lockpick', 1)
exports['nordic_bridge']:GetItemCount('bread')
exports['nordic_bridge']:GetItemInfo('water')
exports['nordic_bridge']:GetPlayerInventory()
exports['nordic_bridge']:GetImagePath('bread')
```

---

### Notifications — `Bridge.Notify.*`

| Function | Parameters | Returns | Description |
|---|---|---|---|
| `Send(message, type, duration)` | `message`: `string`, `type`: `string` (`'success'`/`'error'`/`'info'`/`'warning'`), `duration`: `number` (ms, default `5000`) | — | Show a notification on screen |

**Exports:**
```lua
exports['nordic_bridge']:Notify('Item received!', 'success', 5000)
```

---

### Clothing — `Bridge.Clothing.*`

| Function | Parameters | Returns | Description |
|---|---|---|---|
| `OpenMenu(data)` | `data`: `table\|nil` | — | Open the full clothing/appearance menu |
| `OpenOutfitMenu()` | — | — | Open the outfit manager |
| `GetCurrentClothes()` | — | `table` | Get player's current clothing/appearance data |
| `SetClothes(clothingData)` | `clothingData`: `table` | — | Apply clothing data to the player ped |
| `SaveOutfit(name)` | `name`: `string` | `boolean` | Save current outfit to the database |
| `LoadOutfit(outfitData)` | `outfitData`: `table` | `boolean` | Apply saved outfit data to the player |
| `GetPedModel()` | — | `hash` | Get the current ped model hash |
| `SetPedModel(model)` | `model`: `string\|hash` | — | Change the player's ped model |

**Exports:**
```lua
exports['nordic_bridge']:OpenClothingMenu()
exports['nordic_bridge']:OpenOutfitMenu()
exports['nordic_bridge']:GetCurrentClothes()
exports['nordic_bridge']:SetClothes(data)
exports['nordic_bridge']:SaveOutfit('my_outfit')
exports['nordic_bridge']:LoadOutfit(outfitData)
exports['nordic_bridge']:GetPedModel()
exports['nordic_bridge']:SetPedModel('mp_m_freemode_01')
```

---

### TextUI — `Bridge.TextUI.*`

| Function | Parameters | Returns | Description |
|---|---|---|---|
| `Show(text, options)` | `text`: `string`, `options`: `table\|nil` | — | Display a TextUI prompt |
| `Hide()` | — | — | Hide the active TextUI |

**Exports:**
```lua
exports['nordic_bridge']:ShowTextUI('[E] Open', { position = 'right-center' })
exports['nordic_bridge']:HideTextUI()
```

---

### Interact — `Bridge.Interact.*` (client only)

Unified targeting / prompts. Set `Config.Interact` to match the resource you run:

| Value | Backend |
|---|---|
| `ox_target` | [ox_target](https://coxdocs.dev/ox_target) |
| `qb-target` | qb-target |
| `nordic_interact` | Nordic Interact (`AddInteract` / `RemoveInteract`, `nordic_interact:selected`) |
| `ox_lib` | [ox_lib](https://coxdocs.dev/ox_lib) points + TextUI + **E** (fallback when you use none of the above) |

**Option entry** (all backends):

| Field | Type | Description |
|---|---|---|
| `label` | `string` | Text shown to the player |
| `icon` | `string` (optional) | Icon (ox_target / qb-target; ignored on `nordic_interact` / `ox_lib` fallback) |
| `onSelect` | `function(entity?)` | Called when the player confirms (entity is passed for **AddLocalEntity** where supported) |
| `canInteract` | `function(entity?)` (optional) | Return `false` to disable the option |

**Functions:**

| Function | Parameters | Returns | Description |
|---|---|---|---|
| `AddSphereZone(data)` | `data`: see below | `number\|nil` | Sphere at `data.coords` with `data.radius`. Returns **handle id** for `Remove`. |
| `AddBoxZone(data)` | `data`: see below | `number\|nil` | Box zone (ox_target / qb-target native). `nordic_interact` uses a **location** at center with approximate distance. `ox_lib` uses a sphere whose radius fits `data.size`. |
| `AddLocalEntity(entity, data)` | `entity`: see below, `data.options`, `data.distance?`, `data.key?`, `data.color?` | `number\|nil` | Target a ped / vehicle / prop. `distance` / `key` / `color` apply to **nordic_interact** and **ox_lib**; ox_target / qb-target use their own distances where applicable. |

**`entity` for `AddLocalEntity`:** Prefer a **number** (client entity handle). Also accepted: **numeric string**; a table with any of **`entity`**, **`handle`**, **`ent`**, **`vehicle`**, **`veh`**, **`car`**, **`ped`**, **`prop`**, **`object`**, **`obj`**, or **`[1]`**; or **`netId` / `networkId` / `net_id`** (resolved with `NetworkGetEntityFromNetworkId`).

You can call with **one table** instead of two arguments, e.g. `{ vehicle = truck, options = { ... }, distance = 3.0 }` — the bridge splits entity fields from options automatically.

If you accidentally pass **`({ options = ... }, entityHandle)`** (data first, entity second), the bridge **swaps** them when the second argument is a number.

**Cross-resource note:** From another resource, prefer **`exports['nordic_bridge']:InteractAddLocalEntity(handle, data)`** with **`handle` as the first argument (number)** and put **`entity` / `vehicle` / `_handle` / `[1] = handle` copies inside `data`** as well. Some runtimes drop the first export argument; then the bridge still reads the handle from the single table it receives.
| `Remove(id)` | `id`: `number` | `boolean` | Remove a zone or entity interact created by this bridge. |

**`AddSphereZone` / `AddBoxZone` data table:**

| Field | Type | Description |
|---|---|---|
| `coords` | `vector3` or `{ x, y, z }` | Zone center |
| `radius` | `number` | (sphere) Interaction distance |
| `size` | `vector3` or `{ x, y, z }` | (box) Length / width / height |
| `rotation` / `heading` | `number` | (box) Degrees |
| `options` | `table` | Array of option entries |
| `debug` | `boolean` | ox_target / qb-target debug |
| `key` | `string` | **nordic_interact** / **ox_lib** key label (default `E`) |
| `color` | `string` or `table` | **nordic_interact** main color (hex or RGB) |
| `name` | `string` | (qb-target) Optional fixed zone name; random if omitted |
| `distance` | `number` | qb-target max distance; box fallback for nordic |

**Pattern:** Call `Add*` **once** when the interact becomes valid; call `Remove(id)` when it is no longer valid (do not re-add every frame). Nordic Interact behaves best when you follow this pattern.

**Exports:**
```lua
local id = exports['nordic_bridge']:InteractAddSphereZone({ coords = vector3(0,0,0), radius = 2.0, options = { { label = 'Use', onSelect = function() end } } })
exports['nordic_bridge']:InteractAddBoxZone({ coords = vector3(0,0,0), size = vector3(2,2,2), rotation = 0.0, options = { ... } })
exports['nordic_bridge']:InteractAddLocalEntity(entity, { distance = 2.5, options = { { label = 'Search', onSelect = function(ent) end } } })
exports['nordic_bridge']:InteractRemove(id)
```

**`ox_lib` fallback:** Uses `lib.points` proximity + `lib.showTextUI`. Multiple options: **scroll wheel** to change selection, **E** to confirm.

---

## Server Functions

### Framework — `Bridge.Framework.*`

| Function | Parameters | Returns | Description |
|---|---|---|---|
| `GetPlayer(source)` | `source`: `number` | `object` | Raw framework player object |
| `GetPlayerIdentifier(source)` | `source`: `number` | `string\|nil` | Player identifier (ESX identifier / QB citizenid) |
| `GetPlayerName(source)` | `source`: `number` | `string` | First and last name |
| `GetPlayerJob(source)` | `source`: `number` | `table` | `{ name, label, grade, grade_name }` |
| `GetPlayerGang(source)` | `source`: `number` | `table` | `{ name, label, grade, grade_name }` — ESX always returns `none` |
| `GetPlayerMoney(source, moneyType)` | `source`: `number`, `moneyType`: `string` (optional) | `number` | Amount of the specified money type |
| `AddMoney(source, moneyType, amount, reason)` | `source`: `number`, `moneyType`: `string`, `amount`: `number`, `reason`: `string\|nil` | `boolean` | Add money to a player |
| `RemoveMoney(source, moneyType, amount, reason)` | `source`: `number`, `moneyType`: `string`, `amount`: `number`, `reason`: `string\|nil` | `boolean` | Remove money from a player |
| `GetPlayers()` | — | `table` | List of all online player source IDs |

**Exports:**
```lua
exports['nordic_bridge']:GetPlayer(source)
exports['nordic_bridge']:GetPlayerIdentifier(source)
exports['nordic_bridge']:GetPlayerName(source)
exports['nordic_bridge']:GetPlayerJob(source)
exports['nordic_bridge']:GetPlayerGang(source)
exports['nordic_bridge']:GetPlayerMoney(source, 'cash')
exports['nordic_bridge']:AddMoney(source, 'cash', 500, 'job payment')
exports['nordic_bridge']:RemoveMoney(source, 'bank', 200, 'purchase')
exports['nordic_bridge']:GetPlayers()
```

---

### Inventory — `Bridge.Inventory.*`

| Function | Parameters | Returns | Description |
|---|---|---|---|
| `AddItem(source, item, count, metadata, slot)` | `source`: `number`, `item`: `string`, `count`: `number`, `metadata`: `table\|nil`, `slot`: `number\|nil` | `boolean` | Add an item to a player |
| `RemoveItem(source, item, count, metadata, slot)` | `source`: `number`, `item`: `string`, `count`: `number`, `metadata`: `table\|nil`, `slot`: `number\|nil` | `boolean` | Remove an item from a player |
| `HasItem(source, item, count)` | `source`: `number`, `item`: `string`, `count`: `number` (optional, default `1`) | `boolean` | Check if player has at least `count` of `item` |
| `GetItemCount(source, item)` | `source`: `number`, `item`: `string` | `number` | Total count of item in inventory |
| `GetItem(source, item)` | `source`: `number`, `item`: `string` | `table\|nil` | Full item data |
| `GetItemBySlot(source, slot)` | `source`: `number`, `slot`: `number` | `table\|nil` | Item data in a specific slot |
| `GetItemInfo(item)` | `item`: `string` | `table\|nil` | Registered item definition |
| `GetPlayerInventory(source)` | `source`: `number` | `table` | Full player inventory |
| `CanCarryItem(source, item, count)` | `source`: `number`, `item`: `string`, `count`: `number` | `boolean` | Check if player can carry the item |
| `SetMetadata(source, slot, metadata)` | `source`: `number`, `slot`: `number`, `metadata`: `table` | — | Update metadata on an item in a slot |
| `RegisterStash(id, label, slots, weight)` | `id`: `string`, `label`: `string`, `slots`: `number`, `weight`: `number` | — | Register a new stash |
| `OpenStash(source, id)` | `source`: `number`, `id`: `string` | — | Open a stash for a player |
| `RegisterShop(name, data)` | `name`: `string`, `data`: `table` | — | Register a shop |
| `OpenShop(source, name)` | `source`: `number`, `name`: `string` | — | Open a shop for a player |
| `ClearStash(id)` | `id`: `string` | — | Clear all items from a stash |
| `GetImagePath(item)` | `item`: `string` | `string` | NUI path to the item's image |
| `AddTrunkItems(plate, items)` | `plate`: `string`, `items`: `table` (`{ {name, count, metadata}, ... }`) | — | Add items to a vehicle trunk |
| `AddItemsToTrunk(plate, items)` | `plate`: `string`, `items`: `table` | — | Alias for `AddTrunkItems` |
| `UpdatePlate(oldPlate, newPlate)` | `oldPlate`: `string`, `newPlate`: `string` | — | Update a vehicle plate in inventory data |

**Exports:**
```lua
exports['nordic_bridge']:AddItem(source, 'bread', 3, { quality = 100 })
exports['nordic_bridge']:RemoveItem(source, 'bread', 1)
exports['nordic_bridge']:HasItem(source, 'lockpick', 1)
exports['nordic_bridge']:GetItemCount(source, 'water')
exports['nordic_bridge']:GetItem(source, 'bread')
exports['nordic_bridge']:GetItemBySlot(source, 1)
exports['nordic_bridge']:GetItemInfo('bread')
exports['nordic_bridge']:GetPlayerInventory(source)
exports['nordic_bridge']:CanCarryItem(source, 'bread', 5)
exports['nordic_bridge']:SetMetadata(source, 1, { quality = 50 })
exports['nordic_bridge']:RegisterStash('police_evidence', 'Evidence Locker', 50, 100000)
exports['nordic_bridge']:OpenStash(source, 'police_evidence')
exports['nordic_bridge']:RegisterShop('general', { ... })
exports['nordic_bridge']:OpenShop(source, 'general')
exports['nordic_bridge']:ClearStash('police_evidence')
exports['nordic_bridge']:GetImagePath('bread')
exports['nordic_bridge']:AddTrunkItems('ABC123', {{ name = 'water', count = 5 }})
exports['nordic_bridge']:UpdatePlate('ABC123', 'XYZ789')
```

---

### Notifications — `Bridge.Notify.*`

| Function | Parameters | Returns | Description |
|---|---|---|---|
| `SendToPlayer(source, message, type, duration)` | `source`: `number`, `message`: `string`, `type`: `string`, `duration`: `number` (ms, default `5000`) | — | Send a notification to a specific player |

**Exports:**
```lua
exports['nordic_bridge']:NotifyPlayer(source, 'Item received!', 'success', 5000)
```

---

### Clothing — `Bridge.Clothing.*`

| Function | Parameters | Returns | Description |
|---|---|---|---|
| `GetPlayerAppearance(source)` | `source`: `number` | `table\|nil` | Get a player's saved appearance data |
| `SetPlayerAppearance(source, appearance)` | `source`: `number`, `appearance`: `table` | — | Apply appearance data to a player |
| `SaveOutfit(source, name, outfitData)` | `source`: `number`, `name`: `string`, `outfitData`: `table` | `boolean` | Save outfit to the `nordic_outfits` database table |
| `LoadOutfit(source, name)` | `source`: `number`, `name`: `string` | `table\|nil` | Load a saved outfit by name |
| `GetOutfits(source)` | `source`: `number` | `table` | Get all saved outfits: `{ { name, outfit }, ... }` |
| `DeleteOutfit(source, name)` | `source`: `number`, `name`: `string` | `boolean` | Delete a saved outfit |

**Exports:**
```lua
exports['nordic_bridge']:GetPlayerAppearance(source)
exports['nordic_bridge']:SetPlayerAppearance(source, appearanceData)
exports['nordic_bridge']:SaveOutfit(source, 'work_uniform', outfitData)
exports['nordic_bridge']:LoadOutfit(source, 'work_uniform')
exports['nordic_bridge']:GetOutfits(source)
exports['nordic_bridge']:DeleteOutfit(source, 'work_uniform')
```

---

## File Structure

```
nordic_bridge/
├── fxmanifest.lua
├── config.lua
├── README.md
├── shared/
│   └── main.lua
├── client/
│   ├── main.lua
│   ├── framework/
│   │   ├── esx.lua
│   │   ├── qbcore.lua
│   │   └── qbox.lua
│   ├── inventory/
│   │   ├── ox_inventory.lua
│   │   ├── qb-inventory.lua
│   │   └── qs-inventory.lua
│   ├── notifications/
│   │   ├── ox_lib.lua
│   │   └── okokNotify.lua
│   ├── clothing/
│   │   ├── illenium-appearance.lua
│   │   ├── rcore_clothing.lua
│   │   └── qb-clothing.lua
│   ├── textui/
│   │   └── ox_lib.lua
│   └── interact/
│       ├── registry.lua
│       ├── ox_target.lua
│       ├── qb-target.lua
│       ├── nordic_interact.lua
│       └── ox_lib.lua
└── server/
    ├── main.lua
    ├── framework/
    │   ├── esx.lua
    │   ├── qbcore.lua
    │   └── qbox.lua
    ├── inventory/
    │   ├── ox_inventory.lua
    │   ├── qb-inventory.lua
    │   └── qs-inventory.lua
    ├── notifications/
    │   ├── ox_lib.lua
    │   └── okokNotify.lua
    └── clothing/
        ├── illenium-appearance.lua
        ├── rcore_clothing.lua
        └── qb-clothing.lua
```

## Dependencies

- [oxmysql](https://github.com/overextended/oxmysql) — Required for outfit storage.
- Your chosen framework, inventory, notifications, clothing, TextUI, and **interact** resources must be started before `nordic_bridge` (when not using the `ox_lib` interact fallback).
- **Interact `ox_lib` mode** requires `ox_lib` (same as TextUI / notifications when using ox_lib).

## Notes

- **Money type normalization**: ESX uses `'money'` for cash while QBCore/QBox use `'cash'`. The bridge handles this automatically — you can use either name and it will be mapped correctly.
- **Gang support**: ESX does not have a native gang system, so `GetPlayerGang()` always returns `{ name = 'none', label = 'None', grade = 0, grade_name = '' }` on ESX.
- **Unsupported functions**: Some inventory functions (like `RegisterStash`, `RegisterShop`, `UpdatePlate`) may not be supported by every inventory. When called on an unsupported inventory, a warning is printed to the console.
- **Outfit storage**: Outfits are saved in the `nordic_outfits` MySQL table which is automatically created on first start.
- **Interact**: If `Config.Interact` does not match any bridge file exactly, stub functions log an error — fix the string in `config.lua`.
