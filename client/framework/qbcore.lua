if Config.Framework ~= 'qbcore' then return end

local QBCore = exports['qb-core']:GetCoreObject()

Bridge.Framework.GetPlayerData = function()
    return QBCore.Functions.GetPlayerData()
end

Bridge.Framework.GetPlayerJob = function()
    local data = QBCore.Functions.GetPlayerData()
    if not data or not data.job then return {} end
    return {
        name = data.job.name,
        label = data.job.label,
        grade = data.job.grade.level,
        grade_name = data.job.grade.name,
    }
end

Bridge.Framework.GetPlayerGang = function()
    local data = QBCore.Functions.GetPlayerData()
    if not data or not data.gang then return { name = 'none', label = 'None', grade = 0, grade_name = '' } end
    return {
        name = data.gang.name,
        label = data.gang.label,
        grade = data.gang.grade.level,
        grade_name = data.gang.grade.name,
    }
end

Bridge.Framework.GetPlayerName = function()
    local data = QBCore.Functions.GetPlayerData()
    if not data or not data.charinfo then return '' end
    return ('%s %s'):format(data.charinfo.firstname or '', data.charinfo.lastname or '')
end

Bridge.Framework.IsPlayerLoaded = function()
    local data = QBCore.Functions.GetPlayerData()
    return data ~= nil and data.citizenid ~= nil
end

Bridge.Framework.GetPlayerMoney = function(moneyType)
    local data = QBCore.Functions.GetPlayerData()
    if not data or not data.money then return 0 end

    moneyType = moneyType or 'cash'

    if moneyType == 'money' then moneyType = 'cash' end

    return data.money[moneyType] or 0
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    Bridge.Print('Player loaded (QBCore)')
end)
