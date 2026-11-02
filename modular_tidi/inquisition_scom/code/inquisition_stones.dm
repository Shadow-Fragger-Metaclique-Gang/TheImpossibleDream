/// Inquisistone: a receive-only stone for the Inquisition's private SCOMline. It never hears the public line.
/obj/item/scomstone/inquisition
	name = "Inquisistone"
	desc = "A plain metal ring. The gem set into it is a cold, deep blue, and it seems to listen for a voice that isn't yours. This one can only hear the inquisition SCOMline."
	icon = 'modular_tidi/inquisition_scom/icons/misc.dmi'
	icon_state = "ring_inquisistone"
	messagereceivedsound = 'sound/misc/garrisonscom.ogg'
	hearrange = 0

/obj/item/scomstone/inquisition/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("This stone only receives the Inquisition's private SCOMline. It cannot hear the general SCOMline, and it cannot transmit.")
	. += span_info("Wear it on your finger, then middle-click any SCOM to switch it to the Inquisition SCOMline, which is denoted by blue lettering. Middle-click again to set it back.")

/obj/item/scomstone/inquisition/equipped(mob/living/user, slot)
	. = ..()
	if(slot == SLOT_RING)
		ADD_TRAIT(user, TRAIT_INQUISITION_ITEM, "[ref(src)]")

/obj/item/scomstone/inquisition/dropped(mob/living/user)
	..()
	REMOVE_TRAIT(user, TRAIT_INQUISITION_ITEM, "[ref(src)]")

/obj/item/scomstone/inquisition/attack_right(mob/living/carbon/human/user)
	return

/obj/item/scomstone/inquisition/repeat_message(message, atom/A, tcolor, message_language)
	return

/obj/item/scomstone/inquisition/proc/repeat_inquisition_message(message, atom/A, tcolor, message_language)
	if(!ismob(loc))
		return
	if(tcolor)
		voicecolor_override = tcolor
	if(speaking && message)
		playsound(loc, messagereceivedsound, 100, TRUE, -1)
		say(message, language = message_language)
	voicecolor_override = null

/// Puritanstone: the Inquisitor's stone. It can transmit on the inquisition line, and only that line.
/obj/item/scomstone/inquisition/puritan
	name = "Puritanstone"
	desc = "A lavish silver ring set with a deep rontz gem. It hums softly, as if eager to be spoken into. This one can only speak into the Inquisition SCOMline."
	icon_state = "ring_puritanstone"
	sellprice = 100

/obj/item/scomstone/inquisition/puritan/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Right-click the puritanstone to prepare a message for the Inquisition SCOMline. It never reaches the general SCOMline.")

/obj/item/scomstone/inquisition/puritan/attack_right(mob/living/carbon/human/user)
	user.changeNext_move(CLICK_CD_INTENTCAP)
	if(on_cooldown)
		to_chat(user, span_warning("The gemstone inside still radiates heat from its last transmission. It will cool in [get_cooldown_text()]."))
		playsound(loc, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	if(!get_location_accessible(user, BODY_ZONE_PRECISE_MOUTH, grabs = TRUE))
		to_chat(user, span_warning("My mouth is covered!"))
		return
	visible_message(span_notice("[user] presses [user.p_their()] [src.name] against [user.p_their()] mouth."))
	var/input_text = input(user, "Enter your message:", "Message")
	if(!input_text)
		return
	var/usedcolor = user.voice_color
	if(user.voicecolor_override)
		usedcolor = user.voicecolor_override
	user.whisper(input_text)
	if(length(input_text) > 100)
		input_text = "<small>[input_text]</small>"
	playsound(loc, 'sound/misc/garrisonscom.ogg', 100, FALSE, -1)
	input_text = "<big><span style='color: [INQUISITION_SCOM_COLOR]'>[input_text]</span></big>"
	broadcast_inquisition_line(input_text, src, usedcolor)
	on_cooldown = TRUE
	cooldown_end_time = world.time + cooldown
	addtimer(CALLBACK(src, PROC_REF(reset_cooldown), user), cooldown)
