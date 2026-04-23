if Bridge.Keys._mode ~= 'mrnewbkeys' then return end

Bridge.Keys.RegisterAdapter(
    function(src, plate)
        Bridge.Keys.TryExport('MrNewbVehicleKeys', {
            function(e) e:GiveKeysByPlate(src, plate) end,
        })
    end,
    function(src, plate)
        Bridge.Keys.TryExport('MrNewbVehicleKeys', {
            function(e) e:RemoveKeysByPlate(src, plate) end,
        })
    end,
    function(src, netId)
        Bridge.Keys.TryExport('MrNewbVehicleKeys', {
            function(e) e:GiveKeys(src, netId) end,
        })
    end,
    function(src, netId)
        Bridge.Keys.TryExport('MrNewbVehicleKeys', {
            function(e) e:RemoveKeys(src, netId) end,
        })
    end
)
