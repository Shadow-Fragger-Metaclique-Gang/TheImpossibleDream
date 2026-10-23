/datum/job/roguetown/templar
	total_positions = 2
	spawn_positions = 2
	job_subclasses = list(
		/datum/advclass/templar/monk,
		/datum/advclass/templar/crusader,
		/datum/advclass/templar/noc_spellblade,
		/datum/advclass/templar/guardian,
	)

/datum/job/roguetown/acolyte
	job_subclasses = list(/datum/advclass/acolyte)

// Any Pentacle worshipper may take the Martyr. the outfit converts them to Undivided on spawn.
/datum/job/roguetown/martyr
	allowed_patrons = ALL_DIVINE_PATRONS

/datum/outfit/job/roguetown/martyr
	allowed_patrons = list(/datum/patron/divine/undivided)

