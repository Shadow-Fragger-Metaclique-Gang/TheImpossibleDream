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

/datum/wound/artery/neck
	var/datum/weakref/slit_by

/obj/item/bodypart/proc/report_heretic_crit(datum/wound/applied, mob/living/user)
	if(!istype(applied) || !user || !owner)
		return
	if(istype(applied, /datum/wound/artery/neck))
		var/datum/wound/artery/neck/slit_throat = applied
		slit_throat.slit_by = WEAKREF(user)

/obj/item/bodypart/bodypart_attacked_by(bclass = BCLASS_BLUNT, dam, mob/living/user, zone_precise = src.body_zone, silent = FALSE, crit_message = FALSE, armor, obj/item/weapon, pen_info, no_crit = FALSE, no_debuff = FALSE)
	var/old_bleeding = bleeding
	. = ..()
	if(user && owner && bleeding > old_bleeding)
		SEND_SIGNAL(user, COMSIG_HERETIC_WOUND_DEALT, owner, .)

/obj/item/bodypart/try_crit(bclass = BCLASS_BLUNT, dam, mob/living/user, zone_precise = src.body_zone, silent = FALSE, crit_message = FALSE)
	. = ..()
	report_heretic_crit(., user)

/obj/item/bodypart/chest/try_crit(bclass, dam, mob/living/user, zone_precise, silent = FALSE, crit_message = FALSE)
	. = ..()
	report_heretic_crit(., user)

/obj/item/bodypart/head/try_crit(bclass, dam, mob/living/user, zone_precise, silent = FALSE, crit_message = FALSE)
	. = ..()
	report_heretic_crit(., user)

/mob/living/carbon/human/proc/throat_slit_by(mob/living/killer)
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	var/datum/wound/artery/neck/slit_throat = head?.has_wound(/datum/wound/artery/neck)
	return slit_throat?.slit_by?.resolve() == killer
