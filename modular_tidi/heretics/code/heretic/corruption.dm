/mob/living/carbon/human
	var/blood_corruption = 0

/mob/living/carbon/human/proc/get_blood_corruption()
	var/corruption = blood_corruption
	if(HAS_TRAIT(src, TRAIT_BAOTHA_FERTILITY_BOON))
		corruption += 20
	if(isgoblinp(src) || istiefling(src)) // Racism
		corruption += 20
	return clamp(corruption, 0, 100)

/mob/living/carbon/human/proc/adjust_blood_corruption(amount)
	blood_corruption = clamp(blood_corruption + amount, 0, 100)

/mob/living/carbon/human/proc/set_blood_corruption(value)
	blood_corruption = clamp(value, 0, 100)

/proc/is_heretical_rune(atom/rune)
	var/obj/structure/ritualcircle/circle = rune
	return istype(circle) && ispath(circle.allowed_patron, /datum/patron/inhumen)

/datum/action/cooldown/spell/after_cast(atom/cast_on) // If you're a heretic and cast a miracle (anything that drains devotion) you gain a point of blood corruption
	. = ..()
	var/mob/living/carbon/human/caster = owner
	if(!istype(caster) || !istype(caster.patron, /datum/patron/inhumen))
		return
	if(primary_resource_type == SPELL_COST_DEVOTION || secondary_resource_type == SPELL_COST_DEVOTION)
		caster.adjust_blood_corruption(1)

/obj/effect/proc_holder/spell/after_cast(list/targets, mob/user = usr)
	. = ..()
	var/mob/living/carbon/human/caster = user
	if(miracle && istype(caster) && istype(caster.patron, /datum/patron/inhumen))
		caster.adjust_blood_corruption(1)

/datum/status_effect/buff/sermon/on_apply()
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(. && istype(H))
		H.adjust_blood_corruption(-20)

/datum/status_effect/debuff/hereticsermon/on_apply()
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(. && istype(H))
		H.adjust_blood_corruption(-20)
