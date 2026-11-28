/datum/intent/simple/elemental_unarmed
	name = "elemental unarmed"
	icon_state = "instrike"
	attack_verb = list("punches", "strikes", "rolls on", "crushes")
	animname = "strike"
	blade_class = BCLASS_BLUNT
	hitsound = null
	chargetime = 0
	// [SURREALIS-EDIT] - VRCOMBAT
	// penfactor = PEN_NONE // SURREALIS-EDIT - ORIGINAL
	penfactor = 0
	// [/SURREALIS-EDIT]
	swingdelay = 3

/datum/intent/simple/elementalt2_unarmed
	name = "elemental unarmed"
	icon_state = "instrike"
	attack_verb = list("punches", "strikes", "kicks", "steps on", "crushes")
	animname = "strike"
	blade_class = BCLASS_SMASH
	hitsound = null
	chargetime = 0
	// [SURREALIS-EDIT] - VRCOMBAT
	// penfactor = PEN_NONE // SURREALIS-EDIT - ORIGINAL
	penfactor = 0
	// [/SURREALIS-EDIT]
	swingdelay = 3
