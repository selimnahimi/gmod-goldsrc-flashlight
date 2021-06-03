flashlightOn = false

net.Receive( "flashlightToggle", function()
    local on = net.ReadBool()

    if (LocalPlayer():Alive() and on != flashlightOn) then
        surface.PlaySound("items/flashlight1.wav")
    end

    flashlightOn = on
end)

local traceFilter = {
    prop_physics = true
}

function traceSight()
    return util.TraceLine( {
        start = LocalPlayer():EyePos(),
        endpos = LocalPlayer():EyePos() + LocalPlayer():GetAimVector() * 10000,
        filter = function( ent ) if ( traceFilter[ent:GetClass()] ) then return true end end
    } )
end

hook.Add( "Think", "Think_Lights!", function()
    if (!flashlightOn) then return end

	local dlight = DynamicLight( LocalPlayer():EntIndex() )
	if ( !dlight ) then return end

    local tr = traceSight()

    dlight.pos = tr.HitPos
    dlight.r = 255
    dlight.g = 255
    dlight.b = 255
    dlight.brightness = 2
    dlight.Decay = 10000
    dlight.Size = 100
    dlight.DieTime = CurTime() + 1
end )