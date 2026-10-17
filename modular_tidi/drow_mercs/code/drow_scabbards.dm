// Only switch sheets for states supplied by this port; restore the original on drawing.
/datum/component/holster/update_icon(atom/source, mob/living/user)
	var/obj/item/scabbard = parent
	if(use_icons)
		var/drow_icons = 'modular_tidi/drow_mercs/icons/drowscabbard.dmi'
		if(sheathed && icon_exists(drow_icons, "[initial(scabbard.icon_state)]_[sheathed.sheathe_icon]"))
			scabbard.icon = drow_icons
		else if(scabbard.icon == drow_icons)
			scabbard.icon = initial(scabbard.icon)
	return ..()
