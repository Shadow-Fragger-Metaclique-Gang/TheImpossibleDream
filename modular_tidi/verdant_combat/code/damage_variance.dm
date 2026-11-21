/mob/living
	var/last_variance_percentile = 0

/proc/get_damage_variance(wep_type, variance_center, mob/living/user)
	var/variance_range = 0
	var/variance_roll = 0
	var/curve_depth = 3
	var/isprojectile = FALSE

	switch(wep_type)
		if(/datum/skill/combat/knives) // Low variance, but tend to roll high with a big curve
			variance_range = 15
			curve_depth = 4
			if(variance_center > 0)
				variance_center += 0.3
		if(/datum/skill/combat/swords)
			variance_range = 25
			curve_depth = 2
			if(variance_center > 0)
				variance_center += 0.15
		if(/datum/skill/combat/axes, /datum/skill/labor/lumberjacking)
			variance_range = 40
			curve_depth = 6
		if(/datum/skill/combat/maces, /datum/skill/combat/shields, /datum/skill/craft/blacksmithing, /datum/skill/labor/mining, /datum/skill/craft/cooking)
			variance_range = 20
			curve_depth = 3
		if(/datum/skill/combat/polearms, /datum/skill/labor/farming)
			variance_range = 30
			curve_depth = 2
			if(variance_center > 0)
				variance_center += 0.1
		if(/datum/skill/combat/whipsflails)
			variance_range = 40
			curve_depth = 3
		if(/datum/skill/combat/unarmed)
			variance_range = 10
			curve_depth = 3
		if(/datum/skill/combat/bows, /datum/skill/combat/crossbows, /datum/skill/combat/slings)
			variance_range = RANGED_VARIANCE_RANGE
			curve_depth = 4
			isprojectile = TRUE

	for(var/i = 0, i < curve_depth, i++)
		variance_roll += rand(-variance_range, variance_range)

	variance_center = clamp(variance_center, -1, 1)

	variance_roll = (variance_roll / curve_depth) + (variance_center * variance_range)

	var/clamped_roll = clamp(variance_roll, -variance_range, variance_range)

	if(!isprojectile && ishuman(user) && variance_range > 0)
		var/mob/living/carbon/human/H = user
		H.last_variance_percentile = ((clamped_roll + variance_range) / (variance_range * 2)) * 100

	return clamped_roll
