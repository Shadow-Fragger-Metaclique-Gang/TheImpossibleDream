/datum/job/roguetown/mercenary
	total_positions = 5
	spawn_positions = 5

/datum/advclass/mercenary/lirvanmerc
	maximum_possible_slots = 0
	category_tags = list()

/datum/job/roguetown/mercenary/New()
	. = ..()
	job_subclasses -= /datum/advclass/mercenary/lirvanmerc
