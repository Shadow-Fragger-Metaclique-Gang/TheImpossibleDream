/datum/patron/inhumen/matthios
	name = "Matthios"
	domain = "God of Exchange, Alchemy, Theft, and Greed"
	desc = "Matthios, the Grinning God, the Fiddler-upon-Flames, the Great Leveller, is a Divine Will disparate from his allies of the Infernus. Where they are maelstroms of force, encompassing against all else, Matthios’ works are like lightning, sparking direct and targeted. His greatest works crack the sky once, inspire, and thus ignite embers that, when unified together, form a raging inferno that envelops the world. The Matthic hope is simple: to bring forth the Great Change, which looms ever on the horizon. \n \n\
	In chaos, he is in his element. His voice echoes through a rabid mob; his hands tear the corrupt from their thrones. His mad laughter is the crackle of flame, pillage, and ignition. He is the leader of all free men - the truly free; free from law, expectation, hierarchy, and rule. \n \n\
	It is well known that Matthios walks among men; as an actor does on stage. In these forms, his appearance shifts; the character ever-changing. These masks are known as Gilt Saints to the loyal: the minstrel, the thief, the folk hero and liberator - seducer of Queens, assassin of Kings, and rebel of regimes. \n \n\
	To believe in the promise of Matthios is to have hope for the future. It is the brigand’s hope; to plunder and pillage and render himself Free. It is the hope of the enslaved and disaffected; those most wronged by Tyranny and Honor. It is the hope that your ambitions - or His, by proxy, will soon be rendered true - that all laws unshackle, and that all tyrants fall. \n \n\
	<i>By fire, by blade, by riot or ruin, our Great Change shall be blindingly bright and as inevitable as sunrise.</i> \n \n\
	He is Bearer of the Word: Anarchy."
	worshippers = "Highwaymen, Alchemists, Downtrodden Peasants, and Kobolds"
	crafting_recipes = list(/datum/crafting_recipe/roguetown/sewing/bandithood, /datum/crafting_recipe/roguetown/structure/matthios_cross_stone, /datum/crafting_recipe/roguetown/structure/matthios_cross_meat)
	mob_traits = list(TRAIT_FREEMAN, TRAIT_MATTHIOS_EYES, TRAIT_SEEPRICES_SHITTY)
	miracles = list(/datum/action/cooldown/spell/touch/orison					= CLERIC_ORI,
					/datum/action/cooldown/spell/matthios/freemans_tools		= CLERIC_T0,
					/datum/action/cooldown/spell/miracle/heal					= CLERIC_T1,
					/datum/action/cooldown/spell/miracle/bloodmiracle			= CLERIC_T1,
					/datum/action/cooldown/spell/matthios/mammonite				= CLERIC_T1,
					/datum/action/cooldown/spell/matthios/transact				= CLERIC_T2,
					/datum/action/cooldown/spell/matthios/barter				= CLERIC_T2,
					/datum/action/cooldown/spell/matthios/equalize				= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/resurrect/matthios	= CLERIC_T3,
					/datum/action/cooldown/spell/matthios/churn					= CLERIC_T4
	)
	confess_lines = list(
		"MATTHIOS STEALS FROM THE WORTHLESS!",
		"MATTHIOS IS JUSTICE!",
		"MATTHIOS IS MY LORD!",
	)
	storyteller = /datum/storyteller/matthios

	titles = list(
		"Fyre-Thief",
		"Fire-Thief",
		"Thief-of-Fyre",
		"Thief-of-Fire", // aaaaaaaa
		"Lord", // catchall for various titles of his
		"Matoko",
		"Bear" // fjall
	)

// When near coin of at least 100 mammon, zchurch, bad-cross, or ritual talk
/datum/patron/inhumen/matthios/can_pray(mob/living/follower)
	. = ..()
	// Allows prayer in the Zzzzzzzurch(!)
	if(istype(get_area(follower), /area/rogue/under/cave/inhumen))
		return TRUE
	// Allows prayer near EEEVIL psycross
	for(var/obj/structure/fluff/psycross/cross in view(4, get_turf(follower)))
		if(cross.divine == TRUE)
			to_chat(follower, span_danger("That acсursed cross interupts my prayers!"))
			return FALSE
		return TRUE
	// Allows prayer if the user has more than 100 mammon on them.
	var/mammon_count = get_mammons_in_atom(follower)
	if(mammon_count >= 100)
		return TRUE
	// Spend 5/10 mammon to pray. Megachurch pastors be like.....
	var/obj/item/held_item = follower.get_active_held_item()
	var/helditemvalue = held_item.get_real_price()
	if(istype(held_item, /obj/item/roguecoin) && helditemvalue >= 5)
		qdel(held_item)
		return TRUE
	// Allows praying atop ritual chalk of the god.
	for(var/obj/structure/ritualcircle/matthios in view(1, get_turf(follower)))
		return TRUE
	to_chat(follower, span_danger("For Matthios to hear my prayers I must either be in the church of the abandoned, near an inverted psycross, flaunting wealth upon me of at least 100 mammon, or offer a coin of at least five mammon up to him!"))
	return FALSE

/datum/patron/inhumen/matthios/on_lesser_heal(
	mob/living/user,
	mob/living/target,
	message_out,
	message_self,
	conditional_buff,
	situational_bonus,
	is_inhumen
)
	*is_inhumen = TRUE
	*message_out = span_info("A wreath of gilded light passes over [target]!")
	*message_self = span_notice("I'm bathed in gilded light!")

	if(HAS_TRAIT(target, TRAIT_FREEMAN))
		*conditional_buff = TRUE
		*situational_bonus = 2.5
