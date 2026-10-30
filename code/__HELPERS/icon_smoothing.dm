//generic (by snowflake) tile smoothing code; smooth your icons with this!
/*
	Each tile is divided in 4 corners, each corner has an appearance associated to it; the tile is then overlayed by these 4 appearances
	To use this, just set your atom's 'smoothing_flags' var to 1. If your atom can be moved/unanchored, set its 'can_be_unanchored' var to 1.
	If you don't want your atom's icon to smooth with anything but atoms of the same type, set the list 'smoothing_list' to null;
	Otherwise, put all the smoothing groups you want the atom icon to smooth with in 'smoothing_list', including the group of the atom itself.
	Smoothing groups are just shared flags between objects. If one of the 'smoothing_list' of A matches one of the `smoothing_groups` of B, then A will smooth with B.
	Each atom has its own icon file with all the possible corner states. See 'smooth_wall.dmi' for a template.
	DIAGONAL SMOOTHING INSTRUCTIONS
	To make your atom smooth diagonally you need all the proper icon states (see 'smooth_wall.dmi' for a template) and
	to add the 'SMOOTH_DIAGONAL_CORNERS_CORNERS' flag to the atom's smoothing_flags var (in addition to either SMOOTH_TRUE or SMOOTH_MORE).
	For turfs, what appears under the diagonal corners depends on the turf that was in the same position previously: if you make a wall on
	a plating floor, you will see plating under the diagonal wall corner, if it was space, you will see space.
	If you wish to map a diagonal wall corner with a fixed underlay, you must configure the turf's 'fixed_underlay' list var, like so:
		fixed_underlay = list("icon"='icon_file.dmi', "icon_state"="iconstatename")
	A non null 'fixed_underlay' list var will skip copying the previous turf appearance and always use the list. If the list is
	not set properly, the underlay will default to regular floor plating.
	To see an example of a diagonal wall, see '/turf/closed/wall/mineral/titanium' and its subtypes.
*/

// Components of a smoothing junction
// Redefinitions of the diagonal directions so they can be stored in one var without conflicts
#define NORTH_JUNCTION		NORTH //(1<<0)
#define SOUTH_JUNCTION		SOUTH //(1<<1)
#define EAST_JUNCTION		EAST  //(1<<2)
#define WEST_JUNCTION		WEST  //(1<<3)
#define NORTHEAST_JUNCTION	(1<<4)
#define SOUTHEAST_JUNCTION	(1<<5)
#define SOUTHWEST_JUNCTION	(1<<6)
#define NORTHWEST_JUNCTION	(1<<7)

DEFINE_BITFIELD(smoothing_junction, list(
	"NORTH_JUNCTION" = NORTH_JUNCTION,
	"SOUTH_JUNCTION" = SOUTH_JUNCTION,
	"EAST_JUNCTION" = EAST_JUNCTION,
	"WEST_JUNCTION" = WEST_JUNCTION,
	"NORTHEAST_JUNCTION" = NORTHEAST_JUNCTION,
	"SOUTHEAST_JUNCTION" = SOUTHEAST_JUNCTION,
	"SOUTHWEST_JUNCTION" = SOUTHWEST_JUNCTION,
	"NORTHWEST_JUNCTION" = NORTHWEST_JUNCTION,
))

#define NO_ADJ_FOUND 0
#define ADJ_FOUND 1
#define NULLTURF_BORDER 2

#define DEFAULT_UNDERLAY_ICON 			'icons/turf/floors.dmi'
#define DEFAULT_UNDERLAY_ICON_STATE 	"plating"

//do not use, use QUEUE_SMOOTH(atom)
/atom/proc/smooth_icon()
	if(QDELETED(src))
		return
	smoothing_flags &= ~SMOOTH_QUEUED
	if (!z)
		CRASH("[type] called smooth_icon() without being on a z-level")
	if(smoothing_flags & USES_SMOOTHING)
		smooth()
	else
		CRASH("[type] called smooth_icon() without valid flags: [smoothing_flags]")

/// Basic smoothing proc. The atom checks for adjacent directions to smooth with and changes the icon_state based on that.
/atom/proc/smooth()
	if(!smoothing_icon)
		smoothing_icon = initial(icon_state)
	var/new_junction = NONE

	// cache for sanic speed
	var/smoothing_list = src.smoothing_list

	var/smooth_border = (smoothing_flags & SMOOTH_BORDER)
	var/smooth_obj = (smoothing_flags & SMOOTH_OBJ)
	var/smooth_edge = (smoothing_flags & SMOOTH_EDGE)

#define SET_ADJ_IN_DIR(direction, direction_flag) \
	set_adj_in_dir: { \
		do { \
			var/turf/neighbor = get_step(src, direction); \
			if(!neighbor) { \
				if(smooth_border) { \
					new_junction |= direction_flag; \
				}; \
				break set_adj_in_dir; \
			}; \
			if(smooth_edge && type == neighbor.type) { \
				break set_adj_in_dir; \
			}; \
			if(smooth_obj) { \
				for(var/atom/movable/thing as anything in neighbor) { \
					if(!thing.anchored) { \
						continue; \
					}; \
					if(!length(smoothing_list)) { \
						if(type == thing.type) { \
							new_junction |= direction_flag; \
							break set_adj_in_dir; \
						}; \
						continue; \
					}; \
					var/thing_smoothing_groups = thing.smoothing_groups; \
					if(!length(thing_smoothing_groups)) { \
						continue; \
					}; \
					for(var/target in smoothing_list) { \
						if(smoothing_list[target] & thing_smoothing_groups[target]) { \
							new_junction |= direction_flag; \
							break set_adj_in_dir; \
						}; \
					}; \
				}; \
			}; \
			if(!length(smoothing_list)) { \
				if(type == neighbor.type) { \
					new_junction |= direction_flag; \
				}; \
				break set_adj_in_dir; \
			}; \
			var/neighbor_smoothing_groups = neighbor.smoothing_groups; \
			if(length(neighbor_smoothing_groups)) { \
				for(var/target as anything in smoothing_list) { \
					if(smoothing_list[target] & neighbor_smoothing_groups[target]) { \
						new_junction |= direction_flag; \
						break set_adj_in_dir; \
					}; \
				}; \
			}; \
			break set_adj_in_dir; \
		} while(FALSE) \
	}

	for(var/direction as anything in GLOB.cardinals) //Cardinal case first.
		SET_ADJ_IN_DIR(direction, direction)

	if(smooth_edge)
		if(!isturf(src))
			CRASH("[type] has SMOOTH_EDGE set but is not a turf!")
		var/turf/T = src
		T.set_neighborlays(new_junction)
		return

	if(smoothing_flags & SMOOTH_BITMASK_CARDINALS || !(new_junction & (NORTH|SOUTH)) || !(new_junction & (EAST|WEST)))
		set_smoothed_icon_state(new_junction)
		return

	if(new_junction & NORTH_JUNCTION)
		if(new_junction & WEST_JUNCTION)
			SET_ADJ_IN_DIR(NORTHWEST, NORTHWEST_JUNCTION)

		if(new_junction & EAST_JUNCTION)
			SET_ADJ_IN_DIR(NORTHEAST, NORTHEAST_JUNCTION)

	if(new_junction & SOUTH_JUNCTION)
		if(new_junction & WEST_JUNCTION)
			SET_ADJ_IN_DIR(SOUTHWEST, SOUTHWEST_JUNCTION)

		if(new_junction & EAST_JUNCTION)
			SET_ADJ_IN_DIR(SOUTHEAST, SOUTHEAST_JUNCTION)

	set_smoothed_icon_state(new_junction)

	#undef SET_ADJ_IN_DIR

///Changes the icon state based on the new junction bitmask.
/atom/proc/set_smoothed_icon_state(new_junction)
	icon_state = "[smoothing_icon]-[new_junction]"

/turf/proc/set_neighborlays(new_junction)
	remove_neighborlays()

	if(new_junction == NONE)
		return

	if(new_junction & NORTH)
		handle_edge_icon(NORTH)

	if(new_junction & SOUTH)
		handle_edge_icon(SOUTH)

	if(new_junction & EAST)
		handle_edge_icon(EAST)

	if(new_junction & WEST)
		handle_edge_icon(WEST)

	if(new_junction & NORTHWEST)
		handle_edge_icon(NORTHWEST)

	if(new_junction & NORTHEAST)
		handle_edge_icon(NORTHEAST)

	if(new_junction & SOUTHEAST)
		handle_edge_icon(SOUTHEAST)

	if(new_junction & SOUTHWEST)
		handle_edge_icon(SOUTHWEST)
/turf/proc/handle_edge_icon(dir)
	if(neighborlay_self)
		add_neighborlay(dir, neighborlay_self)
	if(neighborlay)
		// Reverse dir because we are offsetting the overlay onto the adjacency
		add_neighborlay(REVERSE_DIR(dir), neighborlay, TRUE)

/turf/proc/add_neighborlay(dir, edgeicon, offset = FALSE)
	var/add
	var/y = 0
	var/x = 0
	switch(dir)
		if(NORTH)
			add = "[edgeicon]-n"
			y = -32
		if(SOUTH)
			add = "[edgeicon]-s"
			y = 32
		if(EAST)
			add = "[edgeicon]-e"
			x = -32
		if(WEST)
			add = "[edgeicon]-w"
			x = 32
		if(NORTHWEST)
			add = "[edgeicon]-nw"
			y = -32
			x = 32
		if(SOUTHWEST)
			add = "[edgeicon]-sw"
			y = 32
			x = 32
		if(SOUTHEAST)
			add = "[edgeicon]-se"
			y = 32
			x = -32
		if(NORTHEAST)
			add = "[edgeicon]-ne"
			x = 32
			y = -32



	if(!add)
		return

	var/image/overlay = image(icon, src, add, TURF_DECAL_LAYER, pixel_x = offset ? x : 0, pixel_y = offset ? y : 0 )

	LAZYADDASSOC(neighborlay_list, "[dir]", overlay)
	add_overlay(overlay)

/turf/proc/remove_neighborlays()
	if(!LAZYLEN(neighborlay_list))
		return
	for(var/key as anything in neighborlay_list)
		cut_overlay(neighborlay_list[key])
		qdel(neighborlay_list[key])
		neighborlay_list[key] = null
		LAZYREMOVE(neighborlay_list, key)

//Icon smoothing helpers
/proc/smooth_zlevel(zlevel, now = FALSE)
	var/list/away_turfs = block(locate(1, 1, zlevel), locate(world.maxx, world.maxy, zlevel))
	for(var/turf/T as anything in away_turfs)
		if(T.smoothing_flags & USES_SMOOTHING)
			if(now)
				T.smooth_icon()
			else
				QUEUE_SMOOTH(T)
		for(var/atom/A as anything in T)
			if(A.smoothing_flags & USES_SMOOTHING)
				if(now)
					A.smooth_icon()
				else
					QUEUE_SMOOTH(A)

#undef NORTH_JUNCTION
#undef SOUTH_JUNCTION
#undef EAST_JUNCTION
#undef WEST_JUNCTION
#undef NORTHEAST_JUNCTION
#undef NORTHWEST_JUNCTION
#undef SOUTHEAST_JUNCTION
#undef SOUTHWEST_JUNCTION

#undef NO_ADJ_FOUND
#undef ADJ_FOUND
#undef NULLTURF_BORDER

#undef DEFAULT_UNDERLAY_ICON
#undef DEFAULT_UNDERLAY_ICON_STATE

//No real better place to put this
//Redefinitions of the diagonal directions so they can be stored in one var without conflicts
#define N_NORTH		(1<<1)
#define N_SOUTH		(1<<2)
#define N_EAST		(1<<4)
#define N_WEST		(1<<8)
#define N_NORTHEAST	(1<<5)
#define N_NORTHWEST	(1<<9)
#define N_SOUTHEAST	(1<<6)
#define N_SOUTHWEST	(1<<10)
#define dir2neighbor(dir) (1<<(dir))

/turf/proc/verdantsmooth(adjacencies, use_old_behavior)
	if(!use_old_behavior)
		adjacencies = null
		var/turf/neighbortest //completely discard the existing adjacencies, they were calculated incorrectly.
		for (var/testing_dir in list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
			neighbortest = get_step(src, testing_dir)
			if(neighbortest ==null)
				continue
			if(istype(neighbortest, /turf/open/transparent/openspace))
				continue
			if(neighbortest.layer >= src.layer)
				continue
			if(neighbortest.type == src)//TODO: make this take a typecache..
				continue
			if(iswallturf(neighbortest))
				continue
			adjacencies |= dir2neighbor(testing_dir)

	var/list/New
	var/holder

	for(var/A in neighborlay_list)
		cut_overlay("[A]")
		neighborlay_list -= A
	var/usedturf
	if(adjacencies & N_NORTH)
		usedturf = get_step(src, NORTH)
		if(isturf(usedturf))
			var/turf/T = usedturf
			if(neighborlay_override)
				holder = "[neighborlay_override]-n"
				LAZYADD(New, holder)
				neighborlay_list += holder
			else if(T.neighborlay)
				holder = "[T.neighborlay]-n"
				LAZYADD(New, holder)
				neighborlay_list += holder
	if(adjacencies & N_SOUTH)
		usedturf = get_step(src, SOUTH)
		if(isturf(usedturf))
			var/turf/T = usedturf
			if(neighborlay_override)
				holder = "[neighborlay_override]-s"
				LAZYADD(New, holder)
				neighborlay_list += holder
			else if(T.neighborlay)
				holder = "[T.neighborlay]-s"
				LAZYADD(New, holder)
				neighborlay_list += holder
	if(adjacencies & N_WEST)
		usedturf = get_step(src, WEST)
		if(isturf(usedturf))
			var/turf/T = usedturf
			if(neighborlay_override)
				holder = "[neighborlay_override]-w"
				LAZYADD(New, holder)
				neighborlay_list += holder
			else if(T.neighborlay)
				holder = "[T.neighborlay]-w"
				LAZYADD(New, holder)
				neighborlay_list += holder
	if(adjacencies & N_EAST)
		usedturf = get_step(src, EAST)
		if(isturf(usedturf))
			var/turf/T = usedturf
			if(neighborlay_override)
				holder = "[neighborlay_override]-e"
				LAZYADD(New, holder)
				neighborlay_list += holder
			else if(T.neighborlay)
				holder = "[T.neighborlay]-e"
				LAZYADD(New, holder)
				neighborlay_list += holder

	if(1)//if(smooth & SMOOTH_DIAGONAL)
		if(adjacencies & N_NORTHEAST)
			usedturf = get_step(src, NORTHEAST)
			if(isturf(usedturf))
				var/turf/T = usedturf
				if(neighborlay_override)
					holder = "[neighborlay_override]-ne"
					LAZYADD(New, holder)
					neighborlay_list += holder
				else if(T.neighborlay)
					holder = "[T.neighborlay]-ne"
					LAZYADD(New, holder)
					neighborlay_list += holder
		if(adjacencies & N_NORTHWEST)
			usedturf = get_step(src, NORTHWEST)
			if(isturf(usedturf))
				var/turf/T = usedturf
				if(neighborlay_override)
					holder = "[neighborlay_override]-nw"
					LAZYADD(New, holder)
					neighborlay_list += holder
				else if(T.neighborlay)
					holder = "[T.neighborlay]-nw"
					LAZYADD(New, holder)
					neighborlay_list += holder
		if(adjacencies & N_SOUTHEAST)
			usedturf = get_step(src, SOUTHEAST)
			if(isturf(usedturf))
				var/turf/T = usedturf
				if(neighborlay_override)
					holder = "[neighborlay_override]-se"
					LAZYADD(New, holder)
					neighborlay_list += holder
				else if(T.neighborlay)
					holder = "[T.neighborlay]-se"
					LAZYADD(New, holder)
					neighborlay_list += holder
		if(adjacencies & N_SOUTHWEST)
			usedturf = get_step(src, SOUTHWEST)
			if(isturf(usedturf))
				var/turf/T = usedturf
				if(neighborlay_override)
					holder = "[neighborlay_override]-sw"
					LAZYADD(New, holder)
					neighborlay_list += holder
				else if(T.neighborlay)
					holder = "[T.neighborlay]-sw"
					LAZYADD(New, holder)
					neighborlay_list += holder



	if(New)
		add_overlay(New)
	return New



#undef N_NORTH
#undef N_SOUTH
#undef N_EAST
#undef N_WEST
#undef N_NORTHEAST
#undef N_NORTHWEST
#undef N_SOUTHEAST
#undef N_SOUTHWEST
