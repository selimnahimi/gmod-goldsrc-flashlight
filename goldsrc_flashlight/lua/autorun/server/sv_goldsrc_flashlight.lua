util.AddNetworkString("flashlightToggle")

flashlightList = {

}

hook.Add( "PlayerSwitchFlashlight", "BlockFlashLight", function( ply, enabled )
    -- Player attempts to toggle flashlight. override

    if (!ply:Alive() or flashlightList[ply] != nil) then
        print("Flashlight off")
        net.Start("flashlightToggle")
        net.WriteBool(false)
        net.Send(ply)

        flashlightList[ply] = nil
    else
        print("Flashlight on")
        net.Start("flashlightToggle")
        net.WriteBool(true)
        net.Send(ply)

        flashlightList[ply] = true
    end

    return false
end )