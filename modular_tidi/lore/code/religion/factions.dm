/datum/faith/divine
	name = "The Blessed Pentacle"
	godhead = /datum/patron/divine/astrata

/datum/faith/primal_divines
	name = "Primal Divines"
	desc = "The primal powers of sea and earth: Abyssor and Dendor, whose influence predates the organized Temple."
	worshippers = "Druids, sailors, seapeople, and sages"
	godhead = null

/datum/faith/embodied_spirits
	name = "Embodied Spirits"
	desc = "The spirits of chance, craft, and life: Xylix, Malum, and Pestra."
	worshippers = "Gamblers, artisans, healers, and those who honor the living world"
	godhead = null

/datum/faith/inhumen
	name = "Ascendants"
	godhead = null

/datum/patron/divine/undivided
	preference_accessible = FALSE

/datum/patron/divine/dendor
	associated_faith = /datum/faith/primal_divines

/datum/patron/divine/abyssor
	associated_faith = /datum/faith/primal_divines

/datum/patron/divine/xylix
	associated_faith = /datum/faith/embodied_spirits

/datum/patron/divine/malum
	associated_faith = /datum/faith/embodied_spirits

/datum/patron/divine/pestra
	associated_faith = /datum/faith/embodied_spirits
