util.AddNetworkString("flashlightToggle")

-- ConVars
local cvarSize = CreateConVar("gsrc_flashlight_size", "150", {FCVAR_REPLICATE, FCVAR_NOTIFY}, "The size of the flashlight")
local cvarBrightness = CreateConVar("gsrc_flashlight_brightness", "2", {FCVAR_REPLICATE, FCVAR_NOTIFY}, "The brightness of the flashlight")
local cvarEnabled = CreateConVar("gsrc_flashlight_enabled", "1", {FCVAR_REPLICATE, FCVAR_NOTIFY}, "Enable/Disable the GoldSrc Flashlight addon")

-- A list for storing players flashlight states
flashlightList = {

}

hook.Add( "PlayerSwitchFlashlight", "BlockFlashLight", function( ply, enabled )
    if (!cvarEnabled:GetBool()) then return true end

    -- Player attempts to toggle flashlight. override

    if ply:Alive() then
        if (flashlightList[ply] != nil) then
            net.Start("flashlightToggle")
            net.WriteBool(false)
            net.Send(ply)

            flashlightList[ply] = nil
        else
            -- Send flashlight size and brightness, because these are serverside cvars
            print(cvarSize:GetInt())
            net.Start("flashlightToggle")
            net.WriteBool(true)
            net.WriteInt(cvarSize:GetInt(), 10)
            net.WriteInt(cvarBrightness:GetInt(), 10)
            net.Send(ply)

            flashlightList[ply] = true
        end
    end

    return false
end )
