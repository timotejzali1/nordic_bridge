if Config.TextUI ~= 'ox_lib' then return end

local lib = _G.lib or exports.ox_lib

Bridge.TextUI.Show = function(text, options)
    lib.showTextUI(text, options or {})
end

Bridge.TextUI.Hide = function()
    lib.hideTextUI()
end
