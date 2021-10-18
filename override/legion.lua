local legionDisableNat = GetModConfigData("legionDisableNat") or false;
if legionDisableNat then
    AddComponentPostInit("perennialcrop",
            function(self)
                self.can_getsick = false;
            end
    )
end