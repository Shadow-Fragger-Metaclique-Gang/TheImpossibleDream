/datum/job/roguetown/orthodoxist
	total_positions = 4
	spawn_positions = 4

/datum/job/roguetown/absolver/New()
	job_traits += TRAIT_SQUIRE_REPAIR
	return ..()
