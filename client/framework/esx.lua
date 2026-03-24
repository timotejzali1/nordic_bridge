if Config.Framework ~= 'esx' then return end

local ESX = exports['es_extended']:getSharedObject()

Bridge.Framework.GetPlayerData = function()
    return ESX.GetPlayerData()
end

Bridge.Framework.GetPlayerJob = function()
    local data = ESX.GetPlayerData()
    if not data or not data.job then return {} end
    return {
        name = data.job.name,
        label = data.job.label,
        grade = data.job.grade,
        grade_name = data.job.grade_label,
    }
end

Bridge.Framework.GetPlayerGang = function()
    return { name = 'none', label = 'None', grade = 0, grade_name = '' }
end

Bridge.Framework.GetPlayerName = function()
    local data = ESX.GetPlayerData()
    if not data then return '' end
    return ('%s %s'):format(data.firstName or '', data.lastName or '')
end

Bridge.Framework.IsPlayerLoaded = function()
    local data = ESX.GetPlayerData()
    return data ~= nil and data.job ~= nil
end

Bridge.Framework.GetPlayerMoney = function(moneyType)
    local data = ESX.GetPlayerData()
    if not data then return 0 end

    moneyType = moneyType or 'money'

    if moneyType == 'cash' then moneyType = 'money' end

    for _, account in ipairs(data.accounts or {}) do
        if account.name == moneyType then
            return account.money
        end
    end

    return 0
end

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    Bridge.Print('Player loaded (ESX)')
end)
