/datum/wound/dynamic/burn
	name = "burn"
	// [SURREALIS-EDIT] - VRCOMBAT
	// SURREALIS-EDIT - ORIGINAL
	/*
	whp = 1 // 1 to 1 to puncture, as it is an AP type
	sewn_whp = 0
	bleed_rate = 0.2
	sewn_bleed_rate = 0.04
	clotting_rate = 0.01
	sewn_clotting_rate = 0.01
	clotting_threshold = 0.15
	sewn_clotting_threshold = 0.1
	sew_threshold = 20
	can_sew = TRUE
	can_cauterize = FALSE
	passive_healing = 0.1
	*/
	whp = 10
	bleed_rate = 0
	clotting_rate = 0
	clotting_threshold = null
	sewn_clotting_threshold = 0
	woundpain = 8
	passive_healing = 0.3
	sew_threshold = 10
	can_sew = TRUE
	can_cauterize = FALSE
	sewn_bleed_rate = 0
	// [/SURREALIS-EDIT]
	bypass_bloody_wound_check = TRUE
	severity_type = SEVERITY_TYPE_BURN // name off the limb's actual burnt fraction, not the whp heal-pool
	sound_effect = list('sound/combat/hits/burn (1).ogg', 'sound/combat/hits/burn (2).ogg')
	severity_stages = list( // burn_dam as a percent of the limb's max_damage
		"reddened" = 5,
		"blistering" = 20,
		"scalded" = 40,
		"charred" = 60,
		"cindered" = 80,
	)

// [SURREALIS-EDIT] - VRCOMBAT
// SURREALIS-EDIT - ORIGINAL
/*
#define BURN_UPG_WHPRATE 1.2
#define BURN_UPG_SEWRATE 0.65
#define BURN_UPG_PAINRATE 0.25
#define BURN_CHAR_THRESHOLD 120
// flat floor + a capped damage term, so a fireball (90) bleeds more than a spitfire (40) without the old runaway clamp
#define BURN_UPG_BLEED_FLAT 0.8
#define BURN_UPG_BLEED_SCALE 0.02
#define BURN_UPG_BLEED_SCALE_CAP 1.6
#define BURN_ARMORED_BLEED_CLAMP (ARTERY_LIMB_BLEEDRATE * 0.33)
#define BURN_MAX_BLEED (ARTERY_LIMB_BLEEDRATE * 0.75)

/datum/wound/dynamic/burn/on_bodypart_gain(obj/item/bodypart/affected)
	if(!affected.can_bloody_wound())
		set_bleed_rate(0)
	return ..()

/datum/wound/dynamic/burn/upgrade(dam, armor, exposed)
	whp += (dam * BURN_UPG_WHPRATE)
	sew_threshold += (dam * BURN_UPG_SEWRATE)
	woundpain += (dam * BURN_UPG_PAINRATE)
	if(bodypart_owner?.can_bloody_wound())
		set_bleed_rate(bleed_rate + BURN_UPG_BLEED_FLAT + clamp(dam * BURN_UPG_BLEED_SCALE, 0, BURN_UPG_BLEED_SCALE_CAP))
		if(bleed_rate > BURN_MAX_BLEED)
			set_bleed_rate(BURN_MAX_BLEED)
		if(armor && !exposed)
			armor_check(armor, BURN_ARMORED_BLEED_CLAMP)
	if(whp >= BURN_CHAR_THRESHOLD && !disabling)
		disabling = TRUE
		passive_healing = 0
		clotting_threshold = 1
		clotting_rate = 0.1
		bodypart_owner?.update_disabled()
*/
#define BURN_UPG_WHPRATE 0.8
#define BURN_UPG_PAINRATE 0.5
#define BURN_UPG_HEALDECAY 0.01
#define BURN_CRITICAL_WHP 70

/datum/wound/dynamic/burn/can_stack_with(datum/wound/other)
	return !istype(other, /datum/wound/dynamic/burn)

/datum/wound/dynamic/burn/can_worsen(damage)
	if(amount > 1)
		return FALSE
	if(is_maxed)
		return FALSE
	if(whp >= max_absorbable_damage)
		return FALSE
	var/hypothetical_whp = whp + (damage * BURN_UPG_WHPRATE)
	return (max(whp, hypothetical_whp) / max(min(whp, hypothetical_whp), 1)) <= 3

/datum/wound/dynamic/burn/can_merge(datum/wound/other)
	if(!other || QDELETED(other))
		return FALSE
	if(other.type != type)
		return FALSE
	if((max(whp, other.whp) / max(min(whp, other.whp), 1)) > 3)
		return FALSE
	if(is_sewn() != other.is_sewn())
		return FALSE
	return TRUE

/datum/wound/dynamic/burn/sew_wound()
	return standard_sewing_procedure()

/datum/wound/dynamic/burn/upgrade(dam, armor)
	whp += (dam * BURN_UPG_WHPRATE)
	woundpain += (dam * BURN_UPG_PAINRATE)
	passive_healing = max(0.1, passive_healing - BURN_UPG_HEALDECAY)
	if(!is_sewn())
		if(whp >= BURN_CRITICAL_WHP && bodypart_owner?.can_bloody_wound() && !bodypart_owner.cauterizing)
			set_bleed_rate(0.4)
			bodypart_owner.check_wound_infection(src)
		else
			set_bleed_rate(0)
// [/SURREALIS-EDIT]
	update_stage()
	..()

#undef BURN_UPG_WHPRATE
// [SURREALIS-EDIT] - VRCOMBAT
// SURREALIS-EDIT - ORIGINAL
/*
#undef BURN_UPG_SEWRATE
#undef BURN_UPG_PAINRATE
#undef BURN_CHAR_THRESHOLD
#undef BURN_UPG_BLEED_FLAT
#undef BURN_UPG_BLEED_SCALE
#undef BURN_UPG_BLEED_SCALE_CAP
#undef BURN_ARMORED_BLEED_CLAMP
#undef BURN_MAX_BLEED

/datum/wound/charring
	name = "severe burn"
	check_name = span_warning("<B>CHARRED</B>")
	severity = WOUND_SEVERITY_SEVERE
	crit_message = list(
		"The flesh is seared to the bone!",
		"The %BODYPART is charred black!",
		"The skin blisters and splits open!",
		"The flesh crackles and chars!",
	)
	sound_effect = 'sound/combat/crit.ogg'
	whp = 60
	sewn_whp = 25
	woundpain = 80
	sewn_woundpain = 30
	bleed_rate = 10 // Let's make it actually do something ok
	sewn_bleed_rate = 0.5
	sew_threshold = 120
	mob_overlay = ""
	can_sew = TRUE
	can_cauterize = FALSE
	disabling = TRUE
	critical = TRUE
	bypass_bloody_wound_check = TRUE

/datum/wound/charring/can_stack_with(datum/wound/other)
	if(istype(other, /datum/wound/charring) && (type == other.type))
		return FALSE
	return TRUE

/datum/wound/charring/on_bodypart_gain(obj/item/bodypart/affected)
	. = ..()
	affected.temporary_crit_paralysis(15 SECONDS)

/datum/wound/charring/on_mob_gain(mob/living/affected)
	. = ..()
	affected.emote("firescream", TRUE)
	flash_color(affected, "#a83c1a", 15)
	affected.Slowdown(15)
	affected.Paralyze(15)
	shake_camera(affected, 2, 2)
	playsound(affected, 'sound/health/burning.ogg', 60, TRUE)
	if(iscarbon(owner) && owner.mind)
		affected.apply_status_effect(/datum/status_effect/debuff/critwounded) //apply critically wounded - more energy in cmode cost. Until fixed.

/datum/wound/charring/sew_wound()
	. = ..()
	if(.)
		bodypart_owner?.update_disabled()

/datum/wound/charring/chest
	name = "torso charring"
	crit_message = list(
		"The torso is seared!",
		"The chest is charred black!",
		"The ribcage crackles with heat!",
	)
	mortal = TRUE

/datum/wound/charring/head
	name = "head charring"
	crit_message = list(
		"The skull is seared!",
		"The face is charred beyond recognition!",
		"The head is engulfed in searing heat!",
	)
	mortal = TRUE
*/
#undef BURN_UPG_PAINRATE
#undef BURN_UPG_HEALDECAY
#undef BURN_CRITICAL_WHP
// [/SURREALIS-EDIT]

/datum/wound/lampcautery
	name = "cauterized wound"
	whp = 240
	bleed_rate = 0
	clotting_rate = 0
	clotting_threshold = 0
	passive_healing = 1
	woundpain = 100
	healable_by_miracles = FALSE
