/datum/hex/soulbound
	name = "\improper Hex of the Soulbound"
	var/mob/living/carbon/human/co_dependent // who are we codependent to and vice-versa

//holy snowflake code to account for 2 targets. generally hexes shouldn't afflict multiple people at once, hence why it's not in the framework
/datum/hex/soulbound/proc/apply_soulbound(mob/living/carbon/human/hex_caster, mob/living/carbon/human/first_victim, mob/living/carbon/human/second_victim, obj/item/new_focus)
	if(!second_victim || second_victim == first_victim)
		qdel(src)
		return FALSE

	for(var/datum/hex/hex as anything in first_victim.active_hexes) // look up fear & hunger abominable marriage for more information
		if(istype(hex, /datum/hex/soulbound))
			qdel(src)
			return FALSE

	for(var/datum/hex/hex as anything in second_victim.active_hexes)
		if(istype(hex, /datum/hex/soulbound))
			qdel(src)
			return FALSE

	co_dependent = second_victim
	if(!apply(hex_caster, first_victim, new_focus))
		return FALSE

	if(!co_dependent.active_hexes)
		co_dependent.active_hexes = list()

	co_dependent.active_hexes += src
	if(co_dependent != caster) // only register the signal if you don't already have one, since caster & victim already get their own signals from apply()
		RegisterSignal(co_dependent, COMSIG_PARENT_QDELETING, PROC_REF(hex_broken))

	if(!suspended)
		on_apply(co_dependent)

	return TRUE

/datum/hex/soulbound/focus_moved() // dont forget to destroy the component on the other victim
	var/was_suspended = suspended
	. = ..()
	if(was_suspended == suspended)
		return
	if(suspended)
		on_remove(co_dependent)
	else
		on_apply(co_dependent)

/datum/hex/soulbound/Destroy()
	if(co_dependent)
		if(!suspended)
			on_remove(co_dependent)
		co_dependent.active_hexes -= src
		if(co_dependent != caster)
			UnregisterSignal(co_dependent, COMSIG_PARENT_QDELETING)
		co_dependent = null
	return ..()

/datum/hex/soulbound/on_apply(mob/living/carbon/human/sufferer = victim)
	sufferer.AddComponent(/datum/component/baotha_soulbound, src)
	sufferer.AddSpell(new /obj/effect/proc_holder/spell/invoked/yearn)

/datum/hex/soulbound/on_remove(mob/living/carbon/human/sufferer = victim)
	var/datum/component/baotha_soulbound/component = sufferer.GetComponent(/datum/component/baotha_soulbound)
	if(component)
		qdel(component)
	sufferer.RemoveSpell(/obj/effect/proc_holder/spell/invoked/yearn)

// the actual soulbinded component
/datum/component/baotha_soulbound
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/datum/hex/soulbound/bond // WHICH hex? Differentiates if someone was spiteful enough to soulbind you twice
	var/panic_distance = 4 // sets separated to TRUE
	var/separated = FALSE // start FREAKING OUT

/datum/component/baotha_soulbound/Initialize(datum/hex/soulbound/new_bond)
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	bond = new_bond
	START_PROCESSING(SSprocessing, src)
	return ..()

/datum/component/baotha_soulbound/process()
	if(QDELETED(bond))
		qdel(src)
		return

	var/mob/living/carbon/human/first_bonded = parent // parent of the component
	var/list/participants = list(bond.victim, bond.co_dependent)

	if(bond.absolver)
		participants += bond.absolver // this creates a polycule. this lets you get close to the absolver and use him for your dependency instead of your co-cursed

	var/near_partner = FALSE

	for(var/mob/living/carbon/human/other_participants as anything in participants)
		if(other_participants == first_bonded) // we're not dependent on ourselves here.
			continue
		if(other_participants.z == first_bonded.z && get_dist(first_bonded, other_participants) <= panic_distance)
			near_partner = TRUE
			break

	if(separated == !near_partner) // if we're separated and we're still far away, return. if we're together and we're still close together, return. only send a message once we separate/reunite
		return

	separated = !near_partner
	if(separated)
		first_bonded.add_stress(/datum/stressevent/soulbound_withdrawal) // we don't need a to_chat because stress events already type themselves into chat if they're bad enough
	else
		first_bonded.remove_stress(/datum/stressevent/soulbound_withdrawal)
		to_chat(first_bonded, span_danger("I feel safer with them. I don't want to ever leave their side, no matter what..."))

/datum/component/baotha_soulbound/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	bond = null
	var/mob/living/carbon/human/first_bonded = parent
	first_bonded.remove_stress(/datum/stressevent/soulbound_withdrawal)
	return ..()

/datum/stressevent/soulbound_withdrawal
	stressadd = 20
	timer = 999 MINUTES
	desc = span_boldred("Everything's going wrong. Everything's going wrong and it won't get any better until I'm back with them!")

// Yearn
// Lets you track your soulbound partner
/obj/effect/proc_holder/spell/invoked/yearn
	name = "Yearn"
	desc = "Feel the desperate longing that binds your soul to another, and follow it to its source."
	action_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_state = "bloom"
	chargetime = 0
	recharge_time = 1 SECONDS
	antimagic_allowed = TRUE
	var/datum/hex/soulbound/tracked_bond
	var/mob/living/carbon/human/tracked_person

/obj/effect/proc_holder/spell/invoked/yearn/cast(list/targets, mob/living/carbon/human/user)
	. = ..()
	if(targets[1] == user)
		select_bond(user)
	else
		give_tracking_directions(user)
	return TRUE

//lord bless gnoll tracking for letting me use their bullshit
/obj/effect/proc_holder/spell/invoked/yearn/proc/select_bond(mob/living/carbon/human/user) // dont forget that bond is which hex soulbound, and not the person.
	var/list/available_hexes = list()
	if(user.active_hexes)
		available_hexes |= user.active_hexes
	if(user.shared_hexes)
		available_hexes |= user.shared_hexes

	var/list/choices = list()
	for(var/datum/hex/soulbound/bond as anything in available_hexes)
		if(!istype(bond, /datum/hex/soulbound) || bond.suspended)
			continue

		for(var/mob/living/carbon/human/participant as anything in bond.get_other_participants(user))
			if(QDELETED(participant))
				continue
			choices["[participant.real_name]"] = list(bond, participant)

	if(!length(choices)) // just incase, even if theoretically the spell should remove itself
		to_chat(user, span_warning("There's nobody calling to me."))
		return

	var/selection = tgui_input_list(user, "Whose presence do I yearn for?", "YEARN", choices)
	if(!selection)
		return

	var/list/chosen = choices[selection]
	if(!chosen)
		return

	tracked_bond = chosen[1]
	tracked_person = chosen[2]
	to_chat(user, span_notice("I feel my soul reaching out towards [tracked_person]."))

/datum/hex/soulbound/proc/get_other_participants(mob/living/carbon/human/user)
	var/list/participants = list(victim, co_dependent)

	if(absolver)
		participants += absolver

	participants -= user
	return participants

/obj/effect/proc_holder/spell/invoked/yearn/proc/give_tracking_directions(mob/living/carbon/human/user)
	if(!tracked_bond || !tracked_person)
		tracked_bond = null
		tracked_person = null
		return

	if(tracked_bond.suspended || (!(tracked_bond in user.active_hexes) && !(tracked_bond in user.shared_hexes)) || !(tracked_person in tracked_bond.get_other_participants(user)))
		tracked_bond = null
		tracked_person = null
		return

	var/turf/user_turf = get_turf(user)
	var/turf/target_turf = get_turf(tracked_person)

	if(!user_turf || !target_turf)
		return

	if(user_turf.z != target_turf.z)
		to_chat(user, span_notice("I feel their presence somewhere [user_turf.z > target_turf.z ? "below" : "above"] me."))
		return

	var/distance = get_dist(user_turf, target_turf)
	var/direction = dir2text(get_dir(user_turf, target_turf))

	if(distance <= 4)
		to_chat(user, span_boldnotice("They're so close. I can feel them beside me."))
	else if(distance < 20)
		to_chat(user, span_notice("My soul aches for someone to the [direction]."))
	else
		to_chat(user, span_notice("A distant longing draws me towards the [direction]."))
