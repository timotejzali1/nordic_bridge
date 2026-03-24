if Config.Clothing ~= 'illenium-appearance' then return end

Bridge.Clothing.GetPlayerAppearance = function(source)
    local exp = exports['illenium-appearance']
    if not exp then return nil end
    local attempts = {
        function() return exp:getPedAppearance(source) end,
        function() return exp.getPedAppearance and exp.getPedAppearance(source) end,
        function() return exp:GetPlayerAppearance(source) end,
        function() return exp:GetPlayerAppearance() end,
    }
    for _, try in ipairs(attempts) do
        local ok, result = pcall(try)
        if ok and result ~= nil then
            return result
        end
    end
    return nil
end

Bridge.Clothing.SetPlayerAppearance = function(source, appearance)
    TriggerClientEvent('illenium-appearance:client:loadPlayerAppearance', source, appearance)
end

Bridge.Clothing.SaveOutfit = function(source, name, outfitData)
    local identifier = Bridge.Framework.GetPlayerIdentifier(source)
    if not identifier then return false end

    MySQL.insert('INSERT INTO nordic_outfits (identifier, name, outfit) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE outfit = VALUES(outfit)', {
        identifier, name, json.encode(outfitData)
    })
    return true
end

Bridge.Clothing.LoadOutfit = function(source, name)
    local identifier = Bridge.Framework.GetPlayerIdentifier(source)
    if not identifier then return nil end

    local result = MySQL.single.await('SELECT outfit FROM nordic_outfits WHERE identifier = ? AND name = ?', {
        identifier, name
    })

    if result then
        return json.decode(result.outfit)
    end
    return nil
end

Bridge.Clothing.GetOutfits = function(source)
    local identifier = Bridge.Framework.GetPlayerIdentifier(source)
    if not identifier then return {} end

    local results = MySQL.query.await('SELECT name, outfit FROM nordic_outfits WHERE identifier = ?', {
        identifier
    })

    local outfits = {}
    for _, row in ipairs(results or {}) do
        outfits[#outfits + 1] = {
            name = row.name,
            outfit = json.decode(row.outfit),
        }
    end
    return outfits
end

Bridge.Clothing.DeleteOutfit = function(source, name)
    local identifier = Bridge.Framework.GetPlayerIdentifier(source)
    if not identifier then return false end

    MySQL.query('DELETE FROM nordic_outfits WHERE identifier = ? AND name = ?', {
        identifier, name
    })
    return true
end
