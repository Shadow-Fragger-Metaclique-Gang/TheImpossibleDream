/datum/patron/inhumen/graggar
	name = "Graggar"
	domain = "God of Conquest, Slavery, Domination, and Predators"
	desc = "The Devourer. The Many-Headed Beast. <b>HE</b> is the wicked voice in your head that delights in inflicting suffering upon another, and always demands more. \
	<b>HE</b> is the part of you - no matter how small - that savors in the sickening crunch of a crushed skull. <b>HIS</b> voice is bellowed through Orcish war cries. <b>HIS</b> visage is seen through the Eclipse; a wicked grin; a cruel twist of the brow. \
	<b>HIS</b> perfection is in pillage; in the blind destruction of arts, culture, and the creations of man. With <b>HIM,</b> corpses are butchered. Eaten. Sacrificed and scattered; bodies impaled upon every branch of a blood-soaked tree; one of many within a grove of the devoured dead. \
	It is <b>HIS</b> Will manifest that works of high art and ancient culture are pillaged or burned; <b>HIS</b> glee at the annihilation of the works of the weak. \n \n\
	To kneel before Graggar is to kneel before no other. It is to believe in strength and domination above all else: typically, your own, but there is no shame in recognizing another of greater strength and power - so long as their power holds true. It is to believe in the closeness of the tribe; in its rituals and customs - no matter how brutal. Savagery is strength; the weak are unworthy. It is to take and claim and own what your heart and body desire– or to die gloriously in the process. \n \n\
	<i>Man is no greater than beast; beast is no greater than man.</i> \n \n\
	<b>HE</b> is Bearer of the Word: Conquest."

	worshippers = "Conquerers, Militants, and the Cruel"
	mob_traits = list(TRAIT_HORDE, TRAIT_ORGAN_EATER)
	traits_tier = list(TRAIT_NASTY_EATER = CLERIC_T1)
	miracles = list(/datum/action/cooldown/spell/touch/orison					= CLERIC_ORI,
					/datum/action/cooldown/spell/graggar/rush					= CLERIC_T0,
					/datum/action/cooldown/spell/miracle/heal					= CLERIC_T1,
					/datum/action/cooldown/spell/miracle/bloodmiracle			= CLERIC_T1,
					/datum/action/cooldown/spell/graggar/hamstring				= CLERIC_T1,
					/datum/action/cooldown/spell/projectile/graggar_net				= CLERIC_T2,
					/datum/action/cooldown/spell/graggar/graggar_battlecry		= CLERIC_T2,
					/datum/action/cooldown/spell/graggar/exsanguinate				= CLERIC_T3,
					/datum/action/cooldown/spell/graggar/avatar					= CLERIC_T4,
					/obj/effect/proc_holder/spell/invoked/resurrect/graggar		= CLERIC_T4,
	)
	confess_lines = list(
		"GRAGGAR IS THE BEAST I WORSHIP!",
		"THROUGH VIOLENCE, DIVINITY!",
		"THE GOD OF CONQUEST DEMANDS BLOOD!",
	)
	storyteller = /datum/storyteller/graggar
	crafting_recipes = list(/datum/crafting_recipe/roguetown/structure/graggar_cross_stone, /datum/crafting_recipe/roguetown/structure/graggar_cross_meat)

	titles = list(
		"Sinistar",
		"Dark Star",
		"Gaiyuke", //Not properly a god worshiped by most kazengunites, but still
		"Moose" // fjall
	)

/datum/patron/inhumen/graggar/on_lesser_heal(
	mob/living/user,
	mob/living/target,
	message_out,
	message_self,
	conditional_buff,
	situational_bonus,
	is_inhumen
)
	*is_inhumen = TRUE
	*message_out = span_info("Foul fumes billow outward as [target] is restored!")
	*message_self = span_notice("A noxious scent burns my nostrils, but I feel better!")

	var/bonus = 0

	for(var/obj/effect/decal/cleanable/blood/blood in oview(5, target))
		bonus = min(bonus + 0.1, 2.5)

	if(!bonus)
		return

	*situational_bonus = bonus
	*conditional_buff = TRUE

/datum/patron/inhumen/graggar/on_gain(mob/living/living)
	. = ..()

	RegisterSignal(living, COMSIG_LIVING_DRINKED_LIMB_BLOOD, PROC_REF(on_drink_blood))

/datum/patron/inhumen/graggar/proc/on_drink_blood(mob/living/drinker, mob/living/target)
	SIGNAL_HANDLER

	drinker.adjust_hydration(8)

/datum/patron/inhumen/graggar/on_loss(mob/living/living)
	. = ..()

	UnregisterSignal(living, COMSIG_LIVING_DRINKED_LIMB_BLOOD)

// When bleeding, near blood on ground, zchurch, bad-cross, or ritual chalk
/datum/patron/inhumen/graggar/can_pray(mob/living/follower)
	. = ..()
	// Allows prayer in the Zzzzzzzurch(!)
	if(istype(get_area(follower), /area/rogue/under/cave/inhumen))
		return TRUE
	// Allows prayer near EEEVIL psycross
	for(var/obj/structure/fluff/psycross/cross in view(4, get_turf(follower)))
		if(cross.divine == TRUE)
			to_chat(follower, span_danger("That accursed cross interupts my prayers!"))
			return FALSE
		return TRUE
	// Allows prayer if actively bleeding.
	if(follower.bleed_rate > 0)
		return TRUE
	// Allows prayer near blood.
	for(var/obj/effect/decal/cleanable/blood in view(3, get_turf(follower)))
		return TRUE
	// Allows praying atop ritual chalk of the god.
	for(var/obj/structure/ritualcircle/graggar in view(1, get_turf(follower)))
		return TRUE
	to_chat(follower, span_danger("For Graggar to hear my prayers I must either be in the church of the abandoned, near an inverted psycross, near fresh blood or draw blood of my own!"))
	return FALSE
