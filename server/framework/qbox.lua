if Config.Framework ~= 'qbox' then return end

local QBX = exports['qbx_core']

Bridge.Framework.GetPlayer = function(source)
    return QBX:GetPlayer(source)
end

Bridge.Framework.GetPlayerIdentifier = function(source)
    local player = QBX:GetPlayer(source)
    if not player then return nil end
    return player.PlayerData.citizenid
end

Bridge.Framework.GetPlayerName = function(source)
    local player = QBX:GetPlayer(source)
    if not player then return '' end
    return ('%s %s'):format(player.PlayerData.charinfo.firstname, player.PlayerData.charinfo.lastname)
end

Bridge.Framework.GetPlayerJob = function(source)
    local player = QBX:GetPlayer(source)
    if not player then return {} end
    local job = player.PlayerData.job
    return {
        name = job.name,
        label = job.label,
        grade = job.grade.level,
        grade_name = job.grade.name,
    }
end

Bridge.Framework.GetPlayerGang = function(source)
    local player = QBX:GetPlayer(source)
    if not player then return { name = 'none', label = 'None', grade = 0, grade_name = '' } end
    local gang = player.PlayerData.gang
    return {
        name = gang.name,
        label = gang.label,
        grade = gang.grade.level,
        grade_name = gang.grade.name,
    }
end

Bridge.Framework.GetPlayerMoney = function(source, moneyType)
    local player = QBX:GetPlayer(source)
    if not player then return 0 end

    moneyType = moneyType or 'cash'

    if moneyType == 'money' then moneyType = 'cash' end

    return player.PlayerData.money[moneyType] or 0
end

Bridge.Framework.AddMoney = function(source, moneyType, amount, reason)
    local player = QBX:GetPlayer(source)
    if not player then return false end

    moneyType = moneyType or 'cash'

    if moneyType == 'money' then moneyType = 'cash' end

    return player.Functions.AddMoney(moneyType, amount, reason)
end

Bridge.Framework.RemoveMoney = function(source, moneyType, amount, reason)
    local player = QBX:GetPlayer(source)
    if not player then return false end

    moneyType = moneyType or 'cash'

    if moneyType == 'money' then moneyType = 'cash' end

    return player.Functions.RemoveMoney(moneyType, amount, reason)
end

Bridge.Framework.GetPlayers = function()
    return QBX:GetQBPlayers()
end
