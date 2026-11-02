GLOBAL_LIST_INIT(heretic_drug_reagents, list(
	/datum/reagent/druqks,
	/datum/reagent/ozium,
	/datum/reagent/moondust,
	/datum/reagent/moondust_purest,
	/datum/reagent/starsugar,
	/datum/reagent/herozium,
))

GLOBAL_LIST_INIT(heretic_high_nobility, list("Grand Duke", "Consort", "Prince", "Councillor", "Steward", "Court Magician", "Suitor"))

/proc/heretic_is_drugged(datum/reagents/holder)
	if(!holder)
		return FALSE
	for(var/drug in GLOB.heretic_drug_reagents)
		if(holder.has_reagent(drug))
			return TRUE
	return FALSE

/mob/living/proc/is_keep_member()
	var/job_title = mind?.assigned_role
	return (job_title in GLOB.noble_positions) || (job_title in GLOB.courtier_positions) || (job_title in GLOB.retinue_positions) || (job_title in GLOB.garrison_positions) || job_title == "Servant"

/mob/living/proc/is_clergy_or_inquisition()
	var/job_title = mind?.assigned_role
	return (job_title in GLOB.church_positions) || (job_title in GLOB.inquisition_positions)

/mob/living/proc/is_high_nobility()
	return mind?.assigned_role in GLOB.heretic_high_nobility

/mob/living/proc/is_heretic_prize()
	var/job_title = mind?.assigned_role
	return (job_title in GLOB.heretic_high_nobility) || job_title == "Bishop" || job_title == "Martyr" || (job_title in GLOB.inquisition_positions)

/obj/item/bodypart/bodypart_attacked_by(bclass = BCLASS_BLUNT, dam, mob/living/user, zone_precise = src.body_zone, silent = FALSE, crit_message = FALSE, armor, obj/item/weapon, pen_info, no_crit = FALSE, no_debuff = FALSE)
	var/old_bleeding = bleeding
	. = ..()
	if(user && owner && bleeding > old_bleeding)
		SEND_SIGNAL(user, COMSIG_HERETIC_WOUND_DEALT, owner, .)

/mob/living/proc/last_hit_by(mob/living/killer)
	return killer && lastattacker_weakref?.resolve() == killer
