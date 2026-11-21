/datum/wound/burn
	mob_overlay = ""

/datum/wound/burn/can_stack_with(datum/wound/other)
	if(other.type != type)
		return TRUE
	var/datum/wound/burn/existing = other
	if(whp > existing.whp)
		existing.worsen_wound(whp - existing.whp)
	return FALSE

/datum/wound/burn/on_mob_gain(mob/living/affected, damage)
	. = ..()
	if(iscarbon(affected) && affected.mind)
		affected.apply_status_effect(/datum/status_effect/debuff/critwounded)

/datum/wound/burn/proc/worsen_wound(amount)
	return

/datum/wound/burn/frostbite
	name = "severe frostbite"
	check_name = span_frostbite("<B>FROSTBITE</B>")
	severity = WOUND_SEVERITY_SEVERE
	whp = 40
	woundpain = 20
	bleed_rate = 0.15
	clotting_rate = 0
	clotting_threshold = null
	sewn_clotting_threshold = 0
	sew_threshold = 10
	passive_healing = 0.1
	can_cauterize = FALSE
	can_sew = TRUE
	disabling = TRUE
	critical = TRUE
	crit_message = list(
		"%VICTIM's %BODYPART freezes solid!",
		"%VICTIM's %BODYPART is frozen to the bone!",
		"Ice crystals form in %VICTIM's %BODYPART!",
	)
	sound_effect = 'sound/combat/crit.ogg'
	var/time_until_falloff = 0
	var/time_until_halfway = 0
	var/numb_stage = 0
	var/next_disable_check = 0
	var/next_organ_damage = 0

/datum/wound/burn/frostbite/on_mob_gain(mob/living/affected, damage)
	. = ..()
	affected.emote("paincrit", TRUE)
	if(damage)
		whp += damage * 0.8
		woundpain += damage * 0.4
	time_until_falloff = world.time + rand(20 MINUTES, 40 MINUTES)
	time_until_halfway = world.time + (time_until_falloff - world.time) / 2
	next_disable_check = world.time + rand(30 SECONDS, 2 MINUTES)
	next_organ_damage = world.time + rand(5 MINUTES, 10 MINUTES)

/datum/wound/burn/frostbite/on_life()
	. = ..()
	if(!owner || !bodypart_owner)
		return
	var/is_vital = (bodypart_owner.body_zone == BODY_ZONE_HEAD || bodypart_owner.body_zone == BODY_ZONE_CHEST)
	if(is_vital)
		if(world.time >= next_organ_damage)
			next_organ_damage = world.time + rand(5 MINUTES, 10 MINUTES)
			apply_organ_damage()
		return
	update_numbness()
	if(world.time >= next_disable_check)
		next_disable_check = world.time + rand(30 SECONDS, 2 MINUTES)
		if(prob(15))
			to_chat(owner, span_userdanger("My [bodypart_owner.name] seizes up from the cold!"))
			bodypart_owner.set_disabled(TRUE)
			addtimer(CALLBACK(src, PROC_REF(remove_disable)), rand(3 SECONDS, 10 SECONDS))
	if(world.time >= time_until_falloff)
		owner.visible_message(span_danger("[owner]'s frostbitten [bodypart_owner.name] falls off!"), \
							span_userdanger("My frostbitten [bodypart_owner.name] falls off!"))
		bodypart_owner.dismember(BURN, BCLASS_FROST, skip_checks = TRUE)

/datum/wound/burn/frostbite/proc/update_numbness()
	if(numb_stage < 1)
		numb_stage = 1
		to_chat(owner, span_warning("You can't feel your [bodypart_owner.name]."))
	else if(numb_stage < 2 && world.time >= time_until_halfway)
		numb_stage = 2
		to_chat(owner, span_danger("Your [bodypart_owner.name] has gone hard and cold."))
	else if(numb_stage < 3 && world.time >= time_until_falloff - FROSTBITE_LOOSE_WARNING)
		numb_stage = 3
		to_chat(owner, span_danger("<B>Your [bodypart_owner.name] is coming loose...</B>"))

/datum/wound/burn/frostbite/proc/remove_disable()
	if(!bodypart_owner)
		return
	bodypart_owner.set_disabled(FALSE)
	to_chat(owner, span_notice("Feeling returns to my [bodypart_owner.name]."))

/datum/wound/burn/frostbite/proc/apply_organ_damage()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/human_owner = owner
	if(bodypart_owner.body_zone == BODY_ZONE_HEAD)
		var/obj/item/organ/brain/brain = human_owner.getorganslot(ORGAN_SLOT_BRAIN)
		if(brain)
			brain.applyOrganDamage(5)
			to_chat(human_owner, span_userdanger("My head throbs with icy pain..."))
		return
	var/obj/item/organ/heart/heart = human_owner.getorganslot(ORGAN_SLOT_HEART)
	var/obj/item/organ/lungs/lungs = human_owner.getorganslot(ORGAN_SLOT_LUNGS)
	heart?.applyOrganDamage(3)
	lungs?.applyOrganDamage(3)
	to_chat(human_owner, span_userdanger("My chest feels frozen from the inside..."))

/datum/wound/burn/frostbite/worsen_wound(amount)
	owner.emote("paincrit", TRUE)
	if(amount)
		whp += amount * 0.8
		woundpain += amount * 0.4

/datum/wound/burn/electrical
	name = "deep electrical burn"
	check_name = span_electrical("<B>ELECTRICAL BURN</B>")
	severity = WOUND_SEVERITY_SEVERE
	whp = 45
	woundpain = 25
	bleed_rate = 0.18
	clotting_rate = 0
	clotting_threshold = null
	sewn_clotting_threshold = 0
	sew_threshold = 10
	passive_healing = 0.15
	can_cauterize = FALSE
	can_sew = TRUE
	disabling = FALSE
	critical = TRUE
	crit_message = list(
		"%VICTIM's %BODYPART is charred by electricity!",
		"Electricity arcs through %VICTIM's %BODYPART!",
		"%VICTIM's %BODYPART smokes from the electrical current!",
	)
	sound_effect = 'sound/combat/crit.ogg'

/datum/wound/burn/electrical/on_mob_gain(mob/living/affected, damage)
	. = ..()
	affected.Stun(clamp(woundpain * 0.3, 5, 15))
	affected.emote("painscream", TRUE)
	if(damage)
		whp += damage * 0.9
		woundpain += damage * 0.5

/datum/wound/burn/electrical/worsen_wound(amount)
	if(amount)
		whp += amount * 0.9
		woundpain += amount * 0.5

/datum/wound/burn/acid
	name = "severe acid burn"
	check_name = span_acid("<B>ACID BURN</B>")
	severity = WOUND_SEVERITY_SEVERE
	whp = 50
	woundpain = 30
	bleed_rate = 0.35
	clotting_rate = 0.01
	clotting_threshold = 0.3
	sewn_clotting_threshold = null
	sew_threshold = 50
	passive_healing = 0.1
	can_cauterize = FALSE
	can_sew = FALSE
	disabling = FALSE
	critical = TRUE
	crit_message = list(
		"%VICTIM's %BODYPART is eaten away by acid!",
		"Acid eats through %VICTIM's %BODYPART!",
		"%VICTIM's %BODYPART begins sloughing off!",
	)
	sound_effect = 'sound/combat/crit.ogg'

/datum/wound/burn/acid/on_mob_gain(mob/living/affected, damage)
	. = ..()
	if(damage)
		whp += damage
		woundpain += damage * 0.6
		set_bleed_rate(min(0.35 + (damage * 0.015), 0.8))
		clotting_rate = max(0.01 - (damage * 0.0002), 0.005)
	affected.emote("painscream", TRUE)

/datum/wound/burn/acid/worsen_wound(amount)
	if(amount)
		whp += amount
		woundpain += amount * 0.6
		set_bleed_rate(min(bleed_rate + (amount * 0.015), 0.8))
		clotting_rate = max(clotting_rate - (amount * 0.0002), 0.005)
	owner.emote("painscream", TRUE)

/datum/wound/burn/acid/on_life()
	. = ..()
	if(!iscarbon(owner))
		return
	if(!owner.stat && prob(5))
		to_chat(owner, span_warning("The acid burn continues to sting!"))
		worsen_wound(1)

/datum/wound/burn/charred
	name = "charred tissue"
	check_name = span_charred("<B>CHARRED</B>")
	severity = WOUND_SEVERITY_FATAL
	crit_message = list(
		"%VICTIM's %BODYPART is charred to the bone!",
		"%VICTIM's %BODYPART burns to cinders!",
		"Flames consume %VICTIM's %BODYPART!",
		"%VICTIM's %BODYPART is turned to char!",
	)
	sound_effect = 'sound/combat/crit.ogg'
	whp = 60
	woundpain = 35
	bleed_rate = 0.6
	clotting_rate = 0
	clotting_threshold = null
	sewn_clotting_threshold = 0
	sew_threshold = 10
	can_sew = TRUE
	can_cauterize = FALSE
	disabling = TRUE
	critical = TRUE
	passive_healing = 0
	sleep_healing = 0.5

/datum/wound/burn/charred/on_mob_gain(mob/living/affected, damage)
	. = ..()
	affected.emote("paincrit", TRUE)
	affected.Slowdown(clamp(woundpain * 0.5, 10, 20))
	shake_camera(affected, 3, 3)
	if(damage)
		whp += damage * 1.2
		woundpain += damage * 0.7
		set_bleed_rate(min(0.6 + (damage * 0.02), 1.2))

/datum/wound/burn/charred/worsen_wound(amount)
	owner.emote("paincrit", TRUE)
	owner.Slowdown(clamp(woundpain * 0.5, 10, 20))
	shake_camera(owner, 3, 3)
	if(amount)
		whp += amount * 1.2
		woundpain += amount * 0.7
		set_bleed_rate(min(bleed_rate + (amount * 0.02), 1.2))

/obj/projectile/magic/baroness/lightning
	woundclass = BCLASS_ELECTRICAL

/obj/projectile/magic/lich/lightning
	woundclass = BCLASS_ELECTRICAL
