/datum/quirk/malodorous
	name = "Malodorous"
	desc = "My body odor is unbearable without regular baths, and others can tell."
	drawback = TRUE
	added_traits = list(TRAIT_MALODOROUS)

/datum/quirk/malodorous/apply_to_human(mob/living/carbon/human/recipient)
	recipient.malodorous_scent = recipient.client?.prefs?.malodorous_scent || ""

/datum/preferences
	var/malodorous_scent = ""

/mob/living/carbon/human
	/// Player-written description of our scent.
	var/malodorous_scent = ""
	/// Bathing suppresses our scent until this world.time.
	var/malodorous_suppressed_until = 0
	/// The last time our scent aura pulsed.
	var/malodorous_last_aura_tick = 0

/mob/living/carbon/human/Life()
	. = ..()
	if(QDELETED(src))
		return
	if(mind && HAS_TRAIT(src, TRAIT_MALODOROUS))
		malodorous_handle_scent()

/mob/living/carbon/human/proc/malodorous_is_reeking()
	return HAS_TRAIT(src, TRAIT_MALODOROUS) && world.time >= malodorous_suppressed_until

/mob/living/carbon/human/proc/malodorous_on_bath()
	malodorous_suppressed_until = world.time + 30 MINUTES
	remove_status_effect(/datum/status_effect/debuff/malodorous_stink)
	to_chat(src, span_notice("I scrub the stink away. I should stay fresh for a while."))

/mob/living/carbon/human/proc/malodorous_apply_contact_stink(mob/living/carbon/human/target)
	target.apply_status_effect(/datum/status_effect/debuff/malodorous_contact, malodorous_scent)

/mob/living/carbon/human/proc/malodorous_handle_scent()
	var/should_reek = malodorous_is_reeking() && can_smell()

	if(should_reek && mind?.antag_datums)
		for(var/datum/antagonist/D in mind.antag_datums)
			if(istype(D, /datum/antagonist/vampire/lord) || istype(D, /datum/antagonist/werewolf) || istype(D, /datum/antagonist/skeleton) || istype(D, /datum/antagonist/zombie) || istype(D, /datum/antagonist/lich))
				should_reek = FALSE
				break

	if(should_reek)
		apply_status_effect(/datum/status_effect/debuff/malodorous_stink)
	else
		remove_status_effect(/datum/status_effect/debuff/malodorous_stink)

	if(!should_reek)
		return
	if(world.time < malodorous_last_aura_tick + 30 SECONDS)
		return
	malodorous_last_aura_tick = world.time
	new /obj/effect/temp_visual/flies(get_turf(src))
	malodorous_stink_aura(src)

/proc/malodorous_examine_text(scent)
	var/scent_text = html_encode(scent || "an unusual scent")
	return span_greentext("They reek of [scent_text].")

/proc/malodorous_stink_aura(mob/living/carbon/human/H)
	for(var/mob/living/nearby in view(2, H))
		if(nearby == H)
			continue
		if(nearby.stat)
			continue
		if(!nearby.can_smell())
			continue
		if(HAS_TRAIT(nearby, TRAIT_NOSTINK))
			continue
		if(HAS_TRAIT(nearby, TRAIT_NOBREATH))
			continue
		if(!nearby.has_stress_event(/datum/stressevent/malodorous_aura))
			to_chat(nearby, "<span class='warning' style='color:#48c75a'>Something nearby reeks.</span>")
			nearby.add_stress(/datum/stressevent/malodorous_aura)

/mob/living/carbon/human/proc/malodorous_examine_lines(mob/user)
	var/list/lines = list()
	if(user == src || get_dist(user, src) > 3)
		return lines
	var/reeking_naturally = malodorous_is_reeking()
	var/datum/status_effect/debuff/malodorous_contact/contact_stink = has_status_effect(/datum/status_effect/debuff/malodorous_contact)
	if(!reeking_naturally && !contact_stink)
		return lines
	var/can_see_stink = !isliving(user) // adminghost always sees it
	if(isliving(user))
		var/mob/living/living_user = user
		can_see_stink = living_user.can_smell() && !HAS_TRAIT(living_user, TRAIT_NOSTINK)
	if(!can_see_stink)
		return lines
	if(reeking_naturally)
		lines += malodorous_examine_text(malodorous_scent)
	else
		lines += malodorous_examine_text(contact_stink.scent)
	return lines

/obj/item/soap/bathe_target(mob/living/carbon/human/target, mob/user)
	. = ..()
	if(!.)
		return
	if(HAS_TRAIT(target, TRAIT_MALODOROUS))
		target.malodorous_on_bath()
	target.remove_status_effect(/datum/status_effect/debuff/malodorous_contact)

/datum/status_effect/debuff/malodorous_stink
	id = "malodorous_stink"
	duration = 999 MINUTES
	alert_type = null

	mob_effect_icon = 'modular_tidi/quirks/icons/malodorous.dmi'
	mob_effect_icon_state = "mob_smell"
	mob_effect_layer = ABOVE_MOB_LAYER

/datum/stressevent/malodorous_aura
	timer = 1 MINUTES
	stressadd = 2
	desc = span_red("Something nearby reeks.")

/datum/status_effect/debuff/malodorous_contact
	id = "malodorous_contact"
	duration = 15 MINUTES
	tick_interval = 5 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/debuff/malodorous_contact
	var/scent = ""
	var/last_aura_tick = 0

/datum/status_effect/debuff/malodorous_contact/on_creation(mob/living/new_owner, inherited_scent = "")
	scent = inherited_scent
	last_aura_tick = 0
	return ..()

/datum/status_effect/debuff/malodorous_contact/refresh(mob/living/new_owner, inherited_scent = "")
	scent = inherited_scent
	last_aura_tick = 0
	if(owner)
		process_inherited_scent(TRUE)
	return ..()

/datum/status_effect/debuff/malodorous_contact/on_apply()
	. = ..()
	to_chat(owner, span_warning("I reek of someone else's stench now...ew..."))
	process_inherited_scent(TRUE)

/datum/status_effect/debuff/malodorous_contact/tick()
	process_inherited_scent()

/datum/status_effect/debuff/malodorous_contact/proc/process_inherited_scent(force = FALSE)
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	if(!H.can_smell())
		H.remove_status_effect(/datum/status_effect/debuff/malodorous_stink)
		return
	if(!H.has_status_effect(/datum/status_effect/debuff/malodorous_stink))
		H.apply_status_effect(/datum/status_effect/debuff/malodorous_stink)
	if(!force && world.time < last_aura_tick + 30 SECONDS)
		return
	last_aura_tick = world.time
	new /obj/effect/temp_visual/flies(get_turf(H))
	malodorous_stink_aura(H)

/datum/status_effect/debuff/malodorous_contact/on_remove()
	to_chat(owner, span_notice("The lingering scent finally fades off me."))
	if(!HAS_TRAIT(owner, TRAIT_MALODOROUS))
		owner.remove_status_effect(/datum/status_effect/debuff/malodorous_stink)
	return ..()

/atom/movable/screen/alert/status_effect/debuff/malodorous_contact
	name = "Musked"
	desc = "Someone's stench rubbed off on me. I should be able to wash it off, or wait it out."
	icon_state = "debuff"
