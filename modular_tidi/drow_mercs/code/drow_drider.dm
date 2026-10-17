/turf/closed/attack_hand(mob/user)
	if(istype(user.buckled, /mob/living/simple_animal/hostile/retaliate/rogue/drider))
		var/mob/living/simple_animal/hostile/retaliate/rogue/drider/mount = user.buckled
		return mount.climb_terrain(src, user)
	return ..()

/mob/living/simple_animal/hostile/retaliate/rogue/drider
	food_type = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat,
		/obj/item/reagent_containers/food/snacks/rogue/meat_rotten,
		/obj/item/organ,
		/obj/item/reagent_containers/food/snacks/rogue/truffles,
		/obj/item/reagent_containers/food/snacks/grown/apple,
	)

/mob/living/simple_animal/hostile/retaliate/rogue/drider/Initialize(mapload)
	. = ..()
	food_typecache -= typesof(/obj/item/organ/brain)//no RR via drider
	bbarding = new /obj/item/clothing/barding/drider(src)

/mob/living/simple_animal/hostile/retaliate/rogue/drider/attackby(obj/item/food_item, mob/user, params)
	if(stat || !can_saddle || !food_typecache?[food_item.type])
		return ..()
	if(has_status_effect(/datum/status_effect/buff/mount_apple_healing))
		to_chat(user, span_warning("[src] is still chewing on its last meal! Try again in a few seconds when they look hungry."))
		return
	. = ..()
	apply_status_effect(/datum/status_effect/buff/mount_apple_healing, 1)
	if(length(enemies))
		clear_enemies()
		LoseTarget()
		visible_message(span_notice("[src] calms down."))

/mob/living/simple_animal/hostile/retaliate/rogue/drider/proc/can_climb_with(mob/living/rider)
	if(QDELETED(rider) || !tame || anchored || incapacitated() || IsImmobilized() || !(mobility_flags & MOBILITY_MOVE))
		return FALSE
	if(rider.buckled != src || rider.loc != loc || rider.incapacitated() || rider.IsImmobilized())
		return FALSE
	var/datum/component/riding/riding_datum = GetComponent(/datum/component/riding)
	return riding_datum && LAZYLEN(buckled_mobs) && buckled_mobs[1] == rider

/mob/living/simple_animal/hostile/retaliate/rogue/drider/proc/get_climb_target(turf/closed/wall)
	if(!isturf(loc) || QDELETED(wall) || !wall.wallclimb || wall.z != z || get_dist(src, wall) != 1)
		return null
	if(!(get_dir(src, wall) in GLOB.cardinals))
		return null
	var/turf/open/transparent/openspace/opening = get_step_multiz(src, UP)
	if(!istype(opening) || !can_zTravel(opening, UP))
		return null
	var/turf/open/landing = get_step_multiz(wall, UP)
	if(!istype(landing) || istype(landing, /turf/open/transparent/openspace))
		return null
	if(!opening.CanPass(src, landing) || !landing.CanPass(src, opening))
		return null
	for(var/atom/movable/blocker in opening)
		if(!blocker.CanPass(src, landing))
			return null
	for(var/atom/movable/blocker in landing)
		if(!blocker.CanPass(src, opening))
			return null
	return landing

/mob/living/simple_animal/hostile/retaliate/rogue/drider/proc/climb_terrain(turf/closed/wall, mob/living/rider)
	if(!can_climb_with(rider))
		return FALSE
	var/turf/start = get_turf(src)
	var/turf/landing = get_climb_target(wall)
	if(!landing)
		to_chat(rider, span_warning("My drider cannot find a clear ledge to climb onto here."))
		return FALSE
	rider.visible_message(span_notice("[rider] guides [src] up [wall]..."), span_notice("I guide [src] up [wall]..."))
	if(!do_after(rider, 2 SECONDS, needhand = FALSE, target = src, extra_checks = CALLBACK(src, PROC_REF(can_climb_with), rider)))
		return FALSE
	if(QDELETED(src) || !can_climb_with(rider) || loc != start || get_climb_target(wall) != landing)
		return FALSE
	setDir(get_dir(src, wall))
	// The hostile animal forceMove override brings all buckled passengers along.
	if(!forceMove(landing))
		return FALSE
	var/datum/component/riding/riding_datum = GetComponent(/datum/component/riding)
	riding_datum.last_vehicle_move = world.time
	playsound(src, 'sound/foley/climb.ogg', 100, TRUE)
	return TRUE

/datum/status_effect/buff/mount_apple_healing
	id = "mount_apple_healing"
	duration = 8 SECONDS
	var/healing_on_tick = 1

/datum/status_effect/buff/mount_apple_healing/on_creation(mob/living/new_owner, new_healing_on_tick)
	healing_on_tick = new_healing_on_tick
	return ..()

/datum/status_effect/buff/mount_apple_healing/tick()
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_rogue(get_turf(owner))
	H.color = "#FF6666"
	owner.adjustBruteLoss(-healing_on_tick, 0)
	owner.adjustFireLoss(-healing_on_tick, 0)
	owner.adjustOxyLoss(-healing_on_tick, 0)
	owner.adjustToxLoss(-healing_on_tick, 0)
	owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -healing_on_tick)
	owner.adjustCloneLoss(-healing_on_tick, 0)

