#define MAX_THROWING_DIST 1280 // 5 z-levels on default width
#define MAX_TICKS_TO_MAKE_UP 3 //how many missed ticks will we attempt to make up for this run.

SUBSYSTEM_DEF(throwing)
	name = "Throwing"
	priority = FIRE_PRIORITY_THROWING
	wait = 1
	flags = SS_NO_INIT|SS_KEEP_TIMING|SS_TICKER
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/list/currentrun
	var/list/processing = list()

/datum/controller/subsystem/throwing/stat_entry()
	return ..("P:[processing.len]")


/datum/controller/subsystem/throwing/fire(resumed = 0)
	if (!resumed)
		src.currentrun = processing.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(length(currentrun))
		var/atom/movable/AM = currentrun[currentrun.len]
		var/datum/thrownthing/TT = currentrun[AM]
		currentrun.len--
		if (QDELETED(AM) || QDELETED(TT))
			processing -= AM
			if (MC_TICK_CHECK)
				return
			continue

		TT.tick()

		if (MC_TICK_CHECK)
			return

	currentrun = null

/datum/thrownthing
	var/atom/movable/thrownthing
	var/atom/target
	var/turf/target_turf
	var/target_zone
	var/init_dir
	var/maxrange
	var/speed
	var/mob/thrower
	var/diagonals_first
	var/dist_travelled = 0
	var/start_time
	var/dist_x
	var/dist_y
	var/dx
	var/dy
	var/force = MOVE_FORCE_DEFAULT
	var/pure_diagonal
	var/diagonal_error
	var/datum/callback/callback
	var/paused = FALSE
	var/delayed_time = 0
	var/last_move = 0
	var/extra = FALSE
// [SURREALIS-ADD] - THROWING_REFACTOR - Path the item is going to travel in flight.
	var/list/path = list()
// [/SURREALIS-ADD]
/datum/thrownthing/New(thrownthing, target, target_turf, init_dir, maxrange, speed, thrower, diagonals_first, force, callback, target_zone, extra)
	. = ..()
	src.thrownthing = thrownthing
	RegisterSignal(thrownthing, COMSIG_PARENT_QDELETING, PROC_REF(on_thrownthing_qdel))
	src.target = target
	src.target_turf = target_turf
	src.init_dir = init_dir
	src.maxrange = maxrange
	src.speed = speed
	src.thrower = thrower
	src.diagonals_first = diagonals_first
	src.force = force
	src.callback = callback
	src.target_zone = target_zone
	src.extra = extra

/datum/thrownthing/Destroy()
	SSthrowing.processing -= thrownthing
	thrownthing.throwing = null
	thrownthing = null
	target = null
	thrower = null
	if(callback)
		QDEL_NULL(callback) //It stores a reference to the thrownthing, its source. Let's clean that.
	return ..()
// [SURREALIS-ADD] - THROWING_REFACTOR
//Draw the path we're going to take, and cut the base turf from it.
/datum/thrownthing/proc/init_path()
	thrownthing.allow_diagonal_movement = TRUE
	path.Add(getline(get_turf(thrownthing), target_turf))
	path -= path[1] //cut initial turf, we don't need it.
// [/SURREALIS-ADD]
///Defines the datum behavior on the thrownthing's qdeletion event.
/datum/thrownthing/proc/on_thrownthing_qdel(atom/movable/source, force)
	SIGNAL_HANDLER
	qdel(src)

/datum/thrownthing/proc/tick()
	var/atom/movable/AM = thrownthing
// [SURREALIS-EDIT] - THROWING_REFACTOR - bugfix
	//if (!AM ||!isturf(AM.loc) || !AM.throwing) - ORIGINAL
	if (!AM ||!isturf(AM.loc) || !AM.throwing)
// [/SURREALIS-EDIT]
		finalize()
		return

	if(paused)
		delayed_time += world.time - last_move
		return

	if (dist_travelled && hitcheck()) //to catch sneaky things moving on our tile while we slept
		finalize()
		return

	var/atom/step

	last_move = world.time
// [SURREALIS-ADD] - THROWING_REFACTOR - If the path is somehow not set up, make sure to do that.
	if(!length(path))
		init_path()
// [/SURREALIS-ADD]

	//calculate how many tiles to move, making up for any missed ticks.
	var/tilestomove = CEILING(min(((((world.time+world.tick_lag) - start_time + delayed_time) * speed) - (dist_travelled ? dist_travelled : -1)), speed*MAX_TICKS_TO_MAKE_UP) * (world.tick_lag * SSthrowing.wait), 1)
	while (tilestomove-- > 0)
// [SURREALIS-EDIT] - THROWING_REFACTOR - How exactly does vandalizing this file more make it easier to maintain?
		//if ((dist_travelled >= maxrange || AM.loc == target_turf))
		if(!path)
			finalize()
			return
		if ((dist_travelled >= maxrange || AM.loc == target_turf || path[1] == null))
// [/SURREALIS-EDIT] - THROWING_REFACTOR
			finalize()
			return

// [SURREALIS-EDIT] - THROWING_REFACTOR
/* ORIGINAL
		if (dist_travelled <= max(dist_x, dist_y)) //if we haven't reached the target yet we home in on it, otherwise we use the initial direction
			step = get_step(AM, get_dir(AM, target_turf))
		else
			step = get_step(AM, init_dir)

		if (!pure_diagonal && !diagonals_first) // not a purely diagonal trajectory and we don't want all diagonal moves to be done first
			if (diagonal_error >= 0 && max(dist_x,dist_y) - dist_travelled != 1) //we do a step forward unless we're right before the target
				step = get_step(AM, dx)
			diagonal_error += (diagonal_error < 0) ? dist_x/2 : -dist_y
*/
		step = get_step(AM, get_dir(AM, path[1]))

		path -= path[1] //Remove the first entry, and shift the entire stack left. This means path[1] is always the next turf.
// [/SURREALIS-EDIT]
		if (!step) // going off the edge of the map makes get_step return null, don't let things go off the edge
			finalize()
			return
// [SURREALIS-EDIT] - THROWING_REFACTOR
//		AM.Move(step, get_dir(AM, step), DELAY_TO_GLIDE_SIZE(1 / speed))
		AM.Move(step, get_dir(AM, step), MOVEMENT_ADJUSTED_GLIDE_SIZE(1 / speed,  MC_AVERAGE_FAST(1, max((world.time-SSthrowing.last_fire) / SSthrowing.wait, 1))))
// [/SURREALIS-EDIT]
		if (!AM.throwing) // we hit something during our move
			finalize(hit = TRUE)
			return

		dist_travelled++

		if (dist_travelled > MAX_THROWING_DIST)
			finalize()
			return

/datum/thrownthing/proc/finalize(hit = FALSE, target=null)
	set waitfor = FALSE
	//done throwing, either because it hit something or it finished moving
	if(!thrownthing)
		return
// [SURREALIS-ADD] - THROWING_REFACTOR
	thrownthing.allow_diagonal_movement = FALSE
// [/SURREALIS-ADD]
	thrownthing.throwing = null
	if (!hit)
		for (var/thing in get_turf(thrownthing)) //looking for our target on the turf we land on.
			var/atom/A = thing
			if (A == target)
				hit = TRUE
				thrownthing.throw_impact(A, src)
				if(QDELETED(thrownthing)) //throw_impact can delete things, such as glasses smashing
					return //deletion should already be handled by on_thrownthing_qdel()
				break
		if (!hit)
			thrownthing.throw_impact(get_turf(thrownthing), src)	// we haven't hit something yet and we still must, let's hit the ground.
			if(QDELETED(thrownthing)) //throw_impact can delete things, such as glasses smashing
				return //deletion should already be handled by on_thrownthing_qdel()

	if(target)
		thrownthing.throw_impact(target, src)
		if(QDELETED(thrownthing)) //throw_impact can delete things, such as glasses smashing
			return //deletion should already be handled by on_thrownthing_qdel()

	if (callback)
		callback.Invoke()

	if(extra)
		thrownthing.throw_at(get_step(thrownthing, thrownthing.dir), 1, 1, thrownthing, spin = FALSE)

	if(!thrownthing.zfalling) // I don't think you can zfall while thrown but hey, just in case.
		var/turf/T = get_turf(thrownthing)
		if(T)
			T.zFall(thrownthing)

	qdel(src)

/datum/thrownthing/proc/hit_atom(atom/A)
	finalize(hit=TRUE, target=A)

/datum/thrownthing/proc/hitcheck()
	for (var/thing in get_turf(thrownthing))
		var/atom/movable/AM = thing
		if (AM == thrownthing || (AM == thrower && !ismob(thrownthing)))
			continue
		if (AM.density && !(AM.pass_flags & LETPASSTHROW) && !(AM.flags_1 & ON_BORDER_1))
			finalize(hit=TRUE, target=AM)
			return TRUE

#undef MAX_THROWING_DIST
#undef MAX_TICKS_TO_MAKE_UP
