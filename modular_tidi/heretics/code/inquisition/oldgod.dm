/obj/effect/proc_holder/spell/invoked/psydonpurify
	name = "PURIFY" // The name is ironic, since it doesn't actually removes the curse from the target. It simply shares in it, so that the absolver may track the focus of the hex.
	action_icon = 'icons/mob/actions/psydonmiracles.dmi'
	overlay_icon = 'icons/mob/actions/psydonmiracles.dmi'
	overlay_state = "PERSIST"
	releasedrain = 33
	chargedrain = 0
	chargetime = 0
	range = 3
	warnie = "sydwarning"
	desc = "Greater lux-magicka. By intertwining your lux with another's own, you may share in any supernatural affliction that has been tormenting them."
	movement_interrupt = FALSE
	sound = 'sound/magic/psydonbleeds.ogg'
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 30 SECONDS
	miracle = TRUE
	devotion_cost = 200

/obj/effect/proc_holder/spell/invoked/psydonpurify/cast(list/targets, mob/living/user)
	. = ..()
	if(!ishuman(targets[1]))
		to_chat(user, span_warning("Their Lux cannot be interacted with."))
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/target = targets[1]
	if(target == user)
		to_chat(user, span_warning("I cannot interact with my own Lux."))
		revert_cast()
		return FALSE

	var/shared = FALSE
	for(var/datum/hex/hex as anything in target.active_hexes)
		if(hex.share_with_absolver(user))
			shared = TRUE

	user.visible_message(span_danger("[user] shares in [target]'s suffering!"))
	playsound(get_turf(user), 'sound/magic/psydonbleeds.ogg', 50, TRUE)

	new /obj/effect/temp_visual/psyheal_rogue(get_turf(target), "#487e97")
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(target), "#487e97")
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(target), "#487e97")

	new /obj/effect/temp_visual/psyheal_rogue(get_turf(user), "#487e97")
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(user), "#487e97")
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(user), "#487e97")

	if(shared)
		to_chat(user, span_notice("You intertwine your lux with theirs for a mote, feeling the rot nestle itself within your soul."))
	else
		to_chat(user, span_notice("You intertwine your lux with theirs for a mote."))
	to_chat(target, span_info("You feel a gentle stirring sensation pour over your Lux."))

	return TRUE

/obj/effect/proc_holder/spell/invoked/psydondiscern
	name = "DISCERN"
	desc = "Follow the connection between your suffering and the focus sustaining it."
	action_icon = 'icons/mob/actions/psydonmiracles.dmi'
	overlay_icon = 'icons/mob/actions/psydonmiracles.dmi'
	overlay_state = "PERSIST"
	chargetime = 0
	recharge_time = 1 SECONDS
	miracle = TRUE
	antimagic_allowed = FALSE
	var/datum/hex/tracked_hex

/obj/effect/proc_holder/spell/invoked/psydondiscern/cast(list/targets, mob/living/carbon/human/user)
	. = ..()
	if(targets[1] == user)
		select_hex(user)
	else
		give_tracking_directions(user)
	return TRUE

/obj/effect/proc_holder/spell/invoked/psydondiscern/proc/select_hex(mob/living/carbon/human/user)
	var/list/available_hexes = list()
	if(user.active_hexes)
		available_hexes |= user.active_hexes
	if(user.shared_hexes)
		available_hexes |= user.shared_hexes

	if(!length(available_hexes))
		to_chat(user, span_warning("There's nothing."))
		return

	var/list/choices = list()
	var/index = 1
	for(var/datum/hex/hex as anything in available_hexes)
		choices["[hex.name] ([index])"] = hex
		index++

	var/selection = tgui_input_list(user, "Which affliction shall I pursue?", "DISCERN", choices)
	if(!selection)
		return

	var/datum/hex/selected_hex = choices[selection]
	if(!selected_hex || QDELETED(selected_hex)) // if the menu is open while a hex gets deleted
		return
	tracked_hex = selected_hex
	to_chat(user, span_notice("I attune my senses to [tracked_hex.name]."))

/obj/effect/proc_holder/spell/invoked/psydondiscern/proc/give_tracking_directions(mob/living/carbon/human/user)
	if(!tracked_hex)
		to_chat(user, span_warning("There's nothing to follow."))
		tracked_hex = null
		return

	if(!(tracked_hex in user.active_hexes) && !(tracked_hex in user.shared_hexes))
		to_chat(user, span_warning("I lost track of my suffering."))
		tracked_hex = null
		return

	var/turf/user_turf = get_turf(user)
	var/turf/focus_turf = get_turf(tracked_hex.focus)

	if(user_turf.z != focus_turf.z)
		to_chat(user, span_notice("I sense the magick somewhere [user_turf.z > focus_turf.z ? "below" : "above"] me."))
		return

	var/dist = get_dist(user_turf, focus_turf)
	var/dir_text = dir2text(get_dir(user_turf, focus_turf))

	if(dist <= 10)
		to_chat(user, span_boldnotice("The magick is overwhelming. Its source must be here!"))
	else if(dist < 20)
		to_chat(user, span_notice("I feel strong magick to the [dir_text]."))
	else
		to_chat(user, span_notice("I sense faint magick to the [dir_text]."))
