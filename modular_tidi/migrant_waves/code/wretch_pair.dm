/datum/migrant_role/wretch
	name = "Wretch"
	role_category = "Wretch"
	antag_datum = /datum/antagonist/wretch
	advclass_cat_rolls = list(CTAG_WRETCH = 20)
	grant_lit_torch = TRUE
	greet_text = "You fell to the wrong side of civilization. Hounded by your crimes, you have come to Azure Peak looking for easy marks and loose purses. You are expected to actively create conflict."
	banned_flaws = list(/datum/charflaw/hunted, /datum/charflaw/targeted)
	var/static/list/wretch_traits = list(TRAIT_STEELHEARTED, TRAIT_OUTLAW, TRAIT_HERESIARCH, TRAIT_SELF_SUSTENANCE, TRAIT_ZURCH)

/datum/migrant_role/wretch/after_spawn(mob/living/carbon/human/character)
	. = ..()
	// The Wretch job normally grants these, but migrants spawn under the Migrant job.
	for(var/trait in wretch_traits)
		ADD_TRAIT(character, trait, JOB_TRAIT)

/datum/migrant_wave/wretch_pair
	name = "Fugitive Pair"
	track = MIGRANT_TRACK_SPECIAL
	spawn_landmark = "Wretch"
	triumph_only = FALSE
	min_round_time = 30 MINUTES
	max_spawns = 2
	weight = 200
	triumph_threshold = 200
	spawn_landmark = "Wretch"
	required_roles = list(
		/datum/migrant_role/wretch = 1
	)
	optional_roles = list(
		/datum/migrant_role/wretch = 1
	)
	greet_text = "Two fugitives with prices on their heads, pushed together by the road and the same hounds at their heels."
