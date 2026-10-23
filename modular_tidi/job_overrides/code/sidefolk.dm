/datum/job/roguetown/mercenary
	total_positions = 7
	spawn_positions = 7

/datum/advclass/mercenary/lirvanmerc
	maximum_possible_slots = 0
	category_tags = list()

/datum/job/roguetown/mercenary/New()
	. = ..()
	job_subclasses -= /datum/advclass/mercenary/lirvanmerc
