hook.Add( "AddToolMenuCategories", "CustomCategory", function()
	spawnmenu.AddToolCategory( "Options", "GoldSrc", "#GoldSrc" )
end )

hook.Add( "PopulateToolMenu", "CustomMenuSettings", function()
	spawnmenu.AddToolMenuOption( "Options", "GoldSrc", "GoldSrcFlashlightOptions", "#GoldSrc Flashlight", "", "", function( panel )
		panel:ClearControls()
        panel:CheckBox("Enabled", "gsrc_flashlight_enabled")
        panel:CheckBox("Night Vision grain effect", "gsrc_flashlight_nv_grain")
        panel:CheckBox("Snap light to target", "gsrc_flashlight_snap")
        local combobox = panel:ComboBox( "Mode", "gsrc_flashlight_mode")

        combobox:AddChoice("Half-Life 1 flashlight", "hl1")
        combobox:AddChoice("Opposing Force night vision", "op4")
        combobox:AddChoice("Counter-Strike 1.6 night vision", "cs16")
		-- Add stuff here
	end )
end )