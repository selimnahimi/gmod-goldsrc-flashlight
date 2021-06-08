-- ConVars
local cvarMode = CreateClientConVar( "gsrc_flashlight_mode", "hl1", true, false)
local cvarGrain = CreateClientConVar( "gsrc_flashlight_nv_grain", "1", true, false)
local cvarSnap = CreateClientConVar( "gsrc_flashlight_snap", "1", true, false)

local flashlightOn = false
local flashlightSize = 150
local flashlightBrightness = 2

local function IsNVG()
    local value = cvarMode:GetString()
    if (value == "cs16" or value == "op4") then return true end

    return false
end

sounds = {
    ["cs16"] = {
        "gsrc/items/cs_nvg_on.wav",
        "gsrc/items/cs_nvg_off.wav"
    },
    ["op4"] = {
        "gsrc/items/op4_nvg_on.wav",
        "gsrc/items/op4_nvg_off.wav"
    },
    ["hl1"] = {
        "gsrc/items/flashlight1.wav",
        "gsrc/items/flashlight1.wav"
    }
}

net.Receive( "flashlightToggle", function()
    local mode = cvarMode:GetString()

    local on = net.ReadBool()

    if (LocalPlayer():Alive() and on != flashlightOn) then
        flashlightSize = net.ReadInt(10)
        flashlightBrightness = net.ReadInt(10)

        local sound
        if (!flashlightOn) then
            sound = sounds[mode] or sounds["hl1"]
            sound = sound[1]
        else
            sound = sounds[mode] or sounds["hl1"]
            sound = sound[2]
        end

        surface.PlaySound(sound)
    end

    flashlightOn = on
end)

local traceBlackList = {
}

local function traceSight()
    return util.TraceLine( {
        start = LocalPlayer():EyePos(),
        endpos = LocalPlayer():EyePos() + LocalPlayer():GetAimVector() * 10000,
        filter = function( ent ) if ( ent != LocalPlayer() and !traceBlackList[ent:GetClass()] ) then return true end end
    } )
end

local function createFlashlight(pos, size, brightness)
    local dlight = DynamicLight( LocalPlayer():EntIndex() )
	if ( !dlight ) then return end

    dlight.pos = pos
    dlight.r = 255
    dlight.g = 255
    dlight.b = 255
    dlight.brightness = brightness
    dlight.Decay = 10000
    dlight.Size = size
    dlight.DieTime = CurTime() + 1
end

hook.Add( "Think", "GoldSrcFlashlightThink", function()
    if (!flashlightOn) then return end

    if (IsNVG()) then
        createFlashlight(LocalPlayer():EyePos(), 1000, 1)
    else
        local tr = traceSight()

        local hitClass = tr.Entity:GetClass()
        local hitPos = tr.HitPos

        if (cvarSnap:GetBool()) then
            if (hitClass != "worldspawn") then
                hitPos = tr.Entity:GetPos() + tr.Entity:OBBCenter()
            end
        end

        createFlashlight(hitPos, flashlightSize, flashlightBrightness)
    end
end )

local nvg_colors = {
	[ "$pp_colour_addr" ] = 0,
	[ "$pp_colour_addg" ] = 0.5,
	[ "$pp_colour_addb" ] = 0,
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] = 1,
	[ "$pp_colour_colour" ] = 1,
	[ "$pp_colour_mulr" ] = 0,
	[ "$pp_colour_mulg" ] = 0,
	[ "$pp_colour_mulb" ] = 0
}

hook.Add( "RenderScreenspaceEffects", "color_modify_example", function()
    if (!flashlightOn) then return end
    if (IsNVG()) then
        DrawColorModify( nvg_colors )

        if (cvarGrain:GetBool()) then
            DrawMaterialOverlay( "gsrc/overlay/nv_grain", 0 )
        end
    end

end )
