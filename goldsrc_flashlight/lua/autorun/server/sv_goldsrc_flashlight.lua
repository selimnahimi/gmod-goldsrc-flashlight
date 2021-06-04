util.AddNetworkString("flashlightToggle")

CreateConVar("gsrc_flashlight_enabled", "1", FCVAR_REPLICATE, "Enable/Disable the GoldSrc Flashlight addon")
CreateConVar("gsrc_flashlight_size", "150", FCVAR_REPLICATE, "The size of the flashlight")
CreateConVar("gsrc_flashlight_brightness", "2", FCVAR_REPLICATE, "The brightness of the flashlight")

flashlightList = {

}

hook.Add( "PlayerSwitchFlashlight", "BlockFlashLight", function( ply, enabled )
    if (!IsEnabled()) then return true end

    -- Player attempts to toggle flashlight. override

    if (!ply:Alive() or flashlightList[ply] != nil) then
        net.Start("flashlightToggle")
        net.WriteBool(false)
        net.Send(ply)

        flashlightList[ply] = nil
    else
        net.Start("flashlightToggle")
        net.WriteBool(true)
        net.Send(ply)

        flashlightList[ply] = true
    end

    return false
end )

function IsEnabled()
    return GetConVar("gsrc_flashlight_enabled"):GetBool()
end
