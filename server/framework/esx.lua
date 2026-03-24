if Config.Framework ~= 'esx' then return end

local ESX = exports['es_extended']:getSharedObject()

Bridge.Framework.GetPlayer = function(source)
    return ESX.GetPlayerFromId(source)
end

Bridge.Framework.GetPlayerIdentifier = function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return nil end
    return xPlayer.getIdentifier()
end

Bridge.Framework.GetPlayerName = function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return '' end
    return xPlayer.getName()
end

Bridge.Framework.GetPlayerJob = function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return {} end
    local job = xPlayer.getJob()
    return {
        name = job.name,
        label = job.label,
        grade = job.grade,
        grade_name = job.grade_label,
    }
end

Bridge.Framework.GetPlayerGang = function(_source)
    return { name = 'none', label = 'None', grade = 0, grade_name = '' }
end

Bridge.Framework.GetPlayerMoney = function(source, moneyType)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return 0 end

    moneyType = moneyType or 'money'

    if moneyType == 'cash' then moneyType = 'money' end

    return xPlayer.getAccount(moneyType).money or 0
end

Bridge.Framework.AddMoney = function(source, moneyType, amount, reason)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end

    moneyType = moneyType or 'money'

    if moneyType == 'cash' then moneyType = 'money' end

    xPlayer.addAccountMoney(moneyType, amount, reason)
    return true
end

Bridge.Framework.RemoveMoney = function(source, moneyType, amount, reason)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end

    moneyType = moneyType or 'money'

    if moneyType == 'cash' then moneyType = 'money' end

    xPlayer.removeAccountMoney(moneyType, amount, reason)
    return true
end

Bridge.Framework.GetPlayers = function()
    return ESX.GetPlayers()
end
