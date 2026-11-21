/obj/projectile
	var/falloff_start_distance = 0
	var/falloff_damage_per_turf = 0
	var/falloff_ap_per_turf = 0
	var/falloff_accuracy_per_turf = 0
	var/firer_skill_level = 0
	var/falloff_applied = FALSE
	var/variance_percentile = null

/obj/projectile/proc/variance_hit_quality()
	if(isnull(variance_percentile))
		return 0
	if(variance_percentile <= VARIANCE_LOW_PERCENTILE)
		return -1
	if(variance_percentile >= VARIANCE_HIGH_PERCENTILE)
		return 1
	return 0

/proc/projectile_falloff(distance, start_distance, damage_per_turf, ap_per_turf, accuracy_per_turf, skill_level)
	var/static/list/no_falloff = list(0, 0, 0)
	if(start_distance <= 0 || distance <= start_distance)
		return no_falloff
	var/turfs_past = distance - start_distance
	var/damage_reduction = damage_per_turf
	var/ap_reduction = ap_per_turf
	var/accuracy_reduction = accuracy_per_turf
	if(skill_level > 0)
		damage_reduction = max(damage_reduction - min(skill_level, 3), 2)
		if(skill_level > 3)
			ap_reduction = max(ap_reduction - min(skill_level - 3, 3), 2)
		accuracy_reduction = max(accuracy_reduction - skill_level, 1)
	return list(damage_reduction * turfs_past, ap_reduction * turfs_past, accuracy_per_turf > 0 ? accuracy_reduction * turfs_past : 0)

/obj/projectile/proc/falloff_distance_to(turf/target_turf)
	if(!starting || !target_turf)
		return 0
	return max(abs(target_turf.x - starting.x), abs(target_turf.y - starting.y))

/obj/projectile/proc/apply_damage_falloff(turf/target_turf)
	if(falloff_applied || !falloff_start_distance)
		return
	falloff_applied = TRUE
	var/list/loss = projectile_falloff(falloff_distance_to(target_turf), falloff_start_distance, falloff_damage_per_turf, falloff_ap_per_turf, 0, firer_skill_level)
	var/had_damage = damage > 0
	damage = max(damage - loss[1], 0)
	armor_penetration = max(armor_penetration - loss[2], 0)
	return had_damage && damage <= 0

/obj/projectile/proc/farsight_penalty(distance)
	if(distance <= ACC_RANGED_VISUAL_REACH)
		return 0
	var/per_tile = max(ACC_RANGED_FARSIGHT_PENALTY - (firer_skill_level * ACC_RANGED_FARSIGHT_SKILL_REDUCTION), ACC_RANGED_FARSIGHT_MIN)
	return (distance - ACC_RANGED_VISUAL_REACH) * per_tile

/obj/projectile/proc/accuracy_falloff(distance)
	var/list/loss = projectile_falloff(distance, falloff_start_distance, 0, 0, falloff_accuracy_per_turf, firer_skill_level)
	return loss[3]

// Formula: center = (LUC > 10 && (LUC - 10) / 2 > stat - 10 ? (LUC - 10) * 0.0125 : (stat - 10) * 0.025) + skill * 0.05
/proc/ranged_variance_center(luck, bonus_stat, skill_level, luck_only = FALSE)
	var/center = 0
	if(luck_only)
		if(luck > 10)
			center += (luck - 10) * 0.0125
	else if(luck > 10 && (luck - 10) / 2 > bonus_stat - 10)
		center += (luck - 10) * 0.0125
	else
		center += (bonus_stat - 10) * 0.025
	if(skill_level > 0)
		center += skill_level * 0.05
	return center

/obj/item/gun/ballistic/revolver/grenadelauncher/proc/apply_ranged_variance(obj/projectile/BB, mob/living/user, skill_type, bonus_stat, luck_only = FALSE, use_statmult = TRUE)
	var/skill_level = user.get_skill_level(skill_type)
	var/roll = get_damage_variance(skill_type, ranged_variance_center(user.STALUC, bonus_stat, skill_level, luck_only), user)
	BB.damage *= 1 + (roll / 100)
	BB.variance_percentile = ((roll + RANGED_VARIANCE_RANGE) / (RANGED_VARIANCE_RANGE * 2)) * 100
	if(use_statmult)
		BB.damage *= max(bonus_stat / 20, 1)
	BB.firer_skill_level = skill_level

// Formula: stat = heavy bow ? max(STR, 10 + floor((PER - 10) / 2)) : PER
/proc/bow_bonus_stat(mob/living/user, heavy_bow)
	if(!heavy_bow)
		return user.STAPER
	return max(user.STASTR, 10 + floor((user.STAPER - 10) / 2))

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/proc/get_falloff_start_distance(mob/living/user)
	return 4 + max(0, floor((user.STAPER - 10) / 2))

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/get_falloff_start_distance(mob/living/user)
	return 7 + max(0, floor((user.STASTR - 10) / 2))

/obj/projectile
	var/diagonal_step = 0
	var/diagonal_target_z = 0

/obj/projectile/preparePixelProjectile(atom/target, atom/source, params, spread = 0)
	. = ..()
	var/turf/source_turf = get_turf(source)
	var/turf/target_turf = get_turf(target)
	if(arcshot || !source_turf || !target_turf || target_turf.z == source_turf.z)
		return
	diagonal_step = max(1, round(get_dist_euclidian(source_turf, target_turf) / 2))
	diagonal_target_z = target_turf.z

/obj/projectile/Range()
	try_diagonal_z_step()
	if(QDELETED(src))
		return
	return ..()

/obj/projectile/proc/try_diagonal_z_step()
	if(!diagonal_step || !diagonal_target_z || z == diagonal_target_z || QDELETED(src))
		return
	if((decayedRange - range) < diagonal_step)
		return
	var/turf/current = get_turf(src)
	var/going_down = diagonal_target_z < z
	var/turf/passage = going_down ? current : get_step_multiz(current, UP)
	if(!istype(passage, /turf/open/transparent/openspace))
		return
	var/turf/destination = locate(x, y, going_down ? z - 1 : z + 1)
	if(!destination)
		return
	if(destination.density || has_dense_content(destination))
		destination = get_nearest_open_turf(destination, 3)
	if(!destination)
		handle_drop()
		qdel(src)
		return
	trajectory_ignore_forcemove = TRUE
	forceMove(destination)
	trajectory_ignore_forcemove = FALSE
	if(trajectory)
		trajectory.z = destination.z

/obj/projectile/proc/get_nearest_open_turf(turf/center, max_range)
	for(var/i in 0 to max_range)
		for(var/turf/candidate in range(i, center))
			if(!candidate.density && !has_dense_content(candidate))
				return candidate
	return null

/obj/projectile/proc/has_dense_content(turf/candidate)
	for(var/atom/thing in candidate)
		if(thing.density && thing != src && thing != firer)
			return TRUE
	return FALSE
