/obj/structure/roguemachine/scomm
	var/inquisitionline = FALSE

/// Hooked into the SCOM's MiddleClick. Returns TRUE if the click was handled as an inquisition line toggle.
/obj/structure/roguemachine/scomm/proc/toggle_inquisition_line(mob/living/carbon/human/user)
	if(!HAS_TRAIT(user, TRAIT_INQUISITION_ITEM))
		// A garrison member taking over a machine that was on the inquisition line.
		if(inquisitionline && HAS_TRAIT(user, TRAIT_GARRISON_ITEM))
			inquisitionline = FALSE
		return FALSE
	user.changeNext_move(CLICK_CD_INTENTCAP)
	inquisitionline = !inquisitionline
	if(inquisitionline)
		garrisonline = FALSE
	to_chat(user, span_info("I [inquisitionline ? "connect to the Inquisition SCOMline." : "connect to the general SCOMline."]"))
	playsound(loc, 'sound/misc/garrisonscom.ogg', 100, FALSE, -1)
	update_icon()
	return TRUE

/// Hooked into the SCOM's Hear. Relays what was said on an inquisition-line SCOM to the inquisition line only.
/obj/structure/roguemachine/scomm/proc/relay_inquisition_line(raw_message, usedcolor, message_language)
	raw_message = "<span style='color: [INQUISITION_SCOM_COLOR]'>[raw_message]</span>"
	broadcast_inquisition_line(raw_message, src, usedcolor, message_language)

/// Sends a message to every inquisition stone and every SCOM that is set to the inquisition line.
/proc/broadcast_inquisition_line(message, atom/source, tcolor, message_language)
	for(var/obj/item/scomstone/inquisition/S in SSroguemachine.scomm_machines)
		S.repeat_inquisition_message(message, source, tcolor, message_language)
	for(var/obj/structure/roguemachine/scomm/S in SSroguemachine.scomm_machines)
		if(S.inquisitionline)
			S.repeat_message(message, source, tcolor, message_language)
