/datum/wound/bruise
	name = "hematoma"
	whp = 30
	bleed_rate = 0
	clotting_threshold = null
	sewn_clotting_threshold = null
	// [SURREALIS-EDIT] - VRCOMBAT
	// woundpain = 10 // SURREALIS-EDIT - ORIGINAL
	woundpain = 5
	// [/SURREALIS-EDIT]
	sew_threshold = 50
	can_sew = FALSE
	can_cauterize = FALSE
	passive_healing = 0.5
	severity_type = SEVERITY_TYPE_WHP

	werewolf_infection_probability = 0

/datum/wound/bruise/small
	name = "bruise"
	whp = 15
	bleed_rate = 0
	// [SURREALIS-EDIT] - VRCOMBAT
	// woundpain = 5 // SURREALIS-EDIT - ORIGINAL
	woundpain = 3
	// [/SURREALIS-EDIT]
	sew_threshold = 25

/datum/wound/bruise/large
	name = "massive hematoma"
	whp = 40
	bleed_rate = 0.9
	clotting_rate = 0.02
	clotting_threshold = 0.3
	// [SURREALIS-EDIT] - VRCOMBAT
	// woundpain = 25 // SURREALIS-EDIT - ORIGINAL
	woundpain = 10
	// [/SURREALIS-EDIT]

/datum/wound/bruise/woundheal
	name = "healed hematoma"
	whp = 240	//2 mins passively, quicker w/ a miracle
	bleed_rate = 0
	clotting_rate = 0
	clotting_threshold = 0
	passive_healing = 1
	woundpain = 100	//lesser miracles reduce woundpain, presumably the receiver will have this on them
	healable_by_miracles = FALSE

/datum/wound/dynamic/bruise
	name = "hematoma"
	whp = 5
	bleed_rate = 0
	clotting_threshold = null
	sewn_clotting_threshold = null
	// [SURREALIS-EDIT] - VRCOMBAT
	// woundpain = 5 // SURREALIS-EDIT - ORIGINAL
	woundpain = 3
	// [/SURREALIS-EDIT]
	passive_healing = 1
	sew_threshold = 50
	can_sew = FALSE
	can_cauterize = FALSE
	passive_healing = 0.5
	severity_stages = list(
		"minor" = 20,
		"moderate" = 60,
		"big" = 100,
		"massive" = 140,
		"immense" = 180,
	)

//Bruise Omniwounds
//Vaguely: Hella painful. No bleeding. No armor interactions. Every hit also increases its self heal by a little bit.

// [SURREALIS-EDIT] - VRCOMBAT
// SURREALIS-EDIT - ORIGINAL
/*
#define BRUISE_UPG_WHPRATE 1
#define BRUISE_UPG_PAINRATE 1
*/
#define BRUISE_UPG_WHPRATE 1.3
#define BRUISE_UPG_PAINRATE 0.4
// [/SURREALIS-EDIT]
#define BRUISE_UPG_SELFHEAL 1

/datum/wound/dynamic/bruise/upgrade(dam, armor)
	whp += (dam * BRUISE_UPG_WHPRATE)
	woundpain += (dam * BRUISE_UPG_PAINRATE)
	passive_healing += BRUISE_UPG_SELFHEAL
	update_stage()
	..()

#undef BRUISE_UPG_WHPRATE
#undef BRUISE_UPG_PAINRATE
#undef BRUISE_UPG_SELFHEAL
