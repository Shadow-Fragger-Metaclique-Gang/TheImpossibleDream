/datum/controller/global_vars/Initialize(mapload)
	. = ..()
	traits_by_type[/mob] += TRAIT_TOO_STUPID_TO_FEINT

/datum/antagonist/zombie/transform_zombie()
	. = ..()
	var/mob/living/carbon/human/zombie = owner?.current
	if(zombie && has_turned)
		ADD_TRAIT(zombie, TRAIT_TOO_STUPID_TO_FEINT, "[type]")
		zombie.apply_status_effect(/datum/status_effect/deadite_stats)

/datum/antagonist/zombie/on_removal()
	var/mob/living/carbon/human/zombie = owner?.current
	if(zombie)
		REMOVE_TRAIT(zombie, TRAIT_TOO_STUPID_TO_FEINT, "[type]")
		zombie.remove_status_effect(/datum/status_effect/deadite_stats)
	return ..()

/datum/rmb_intent/feint/special_attack(mob/living/user, atom/target)
	if(!isliving(target) || !HAS_TRAIT(target, TRAIT_TOO_STUPID_TO_FEINT))
		return ..()
	if(!user || user.incapacitated() || user.has_status_effect(/datum/status_effect/debuff/feintcd) || HAS_TRAIT(user, TRAIT_DEADITE) || HAS_TRAIT(user, TRAIT_PACIFISM))
		return ..()
	var/mob/living/L = target
	user.visible_message(span_warning("[user] feints an attack at [L], but [L.p_they()] [L.p_are()] too stupid to fall for it!"), span_warning("<i>What the fuck was I thinking?</i>"))
	L.emote("rage", forced = TRUE)
	user.apply_status_effect(/datum/status_effect/debuff/feintcd, (FEINT_RCLICK_CD - user.get_tempo_bonus(TEMPO_TAG_RCLICK_CD_BONUS)))

/datum/status_effect/deadite_stats
	id = "deadite_stats"
	alert_type = null
	effectedstats = list(STATKEY_STR = 2, STATKEY_WIL = 2, STATKEY_INT = -20, STATKEY_SPD = -4)
