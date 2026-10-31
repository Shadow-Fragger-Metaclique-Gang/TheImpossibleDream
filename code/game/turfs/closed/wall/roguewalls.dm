/turf/closed/wall/mineral/rogue
	//canSmoothWith = null
	desc = ""
	var/smooth_icon = null
	sheet_type = null
	baseturfs = /turf/open/floor/rogue/dirt/road
	wallclimb = TRUE
	icon = 'icons/turf/mining.dmi'


/turf/closed/wall/mineral/rogue/examine()
	. += ..()
	if(max_integrity)
		var/healthpercent = (turf_integrity/max_integrity) * 100
		switch(healthpercent)
			if(50 to 99)
				. += "It looks slightly damaged."
			if(25 to 50)
				. += "It appears heavily damaged."
			if(1 to 25)
				. +=	"<span class='warning'>It's falling apart!</span>"


/turf/closed/wall/mineral/rogue/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Click-drag yourself onto a wall to lean against it. This allows other people to move past you, while also gradually restoring energy and stamina.")
	. += span_info("Left-clicking a wall while you're next to it will allow you to climb it. The higher your Climbing skill is, the quicker you can finish climbing up a level. Buckling yourself to an uprighted chair can help, too.")
	. += span_info("Your Climbing skill determines the tier of wall you can scale, as well. Most people can climb rock walls and trees without trouble, but mossy walls and fortifications can only be surmounted by a few.")
	. += span_info("Press the 'Shift' button and the 'F' key at the same time to look up a level. If there's nothing to stand on - like a branch or unoccupied tile - adjacent to your direction, climbing up might cause you to fall back down.")
	. += span_info("Note that this behavior mostly applies to walls and trees that're only one level tall. Those with higher Climbing skills can 'cling' to higher walls, allowing them to scale multiple levels without falling.")
	. += span_info("Certain walls can be destroyed through different means. Rock walls succumb to tools that pick, wood walls crumble to tools that chop, and all walls vanish when introduced to blastpowder and siegeweapons.")


//////////////////
// Wooden walls //
//////////////////

/turf/closed/wall/mineral/rogue/wood
	name = "wooden wall"
	desc = "A rough-hewn wall of wood."
	icon = 'icons/turf/smooth/walls/wood.dmi'
	icon_state = MAP_SWITCH("wood", "wood-0")
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_CLOSED_WALL + SMOOTH_GROUP_WALLS_WOOD
	smoothing_list = SMOOTH_GROUP_DOOR_SECRET + SMOOTH_GROUP_WALLS_WOOD
	blade_dulling = DULLING_BASHCHOP
	max_integrity = 800
	break_sound = 'sound/combat/hits/onwood/destroywalldoor.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
	//canSmoothWith = list(/turf/closed/wall/mineral/rogue/wood, /obj/structure/roguewindow, /obj/structure/roguetent, /turf/closed/wall/mineral/rogue/wooddark)
//	sheet_type = /obj/item/grown/log/tree/lumber
	above_floor = /turf/open/floor/rogue/ruinedwood
	baseturfs = /turf/open/floor/rogue/ruinedwood
	neighborlay = "dirtedge"
	climbdiff = 3

	burn_power = 20
	spread_chance = 4

/turf/closed/wall/mineral/rogue/wood/window
	name = "wooden window"
	desc = "A window with a rough-hewn wood frame."
	icon = MAP_SWITCH('icons/turf/smooth/walls/wood.dmi', 'icons/turf/window.dmi')
	icon_state = "wood"
	opacity = FALSE
	max_integrity = 600

/turf/closed/wall/mineral/rogue/wood/window/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && ((mover.pass_flags & PASSTABLE) || (mover.pass_flags & PASSGRILLE)) )
		return 1
	return ..()

/turf/closed/wall/mineral/rogue/wood/window/Initialize(mapload)
	. = ..()
	var/mutable_appearance/M = mutable_appearance(icon, "woodhole", layer = ABOVE_NORMAL_TURF_LAYER)
	add_overlay(M)

/turf/closed/wall/mineral/rogue/wooddark
	name = "dark wood wall"
	desc = "Made from durable, somewhat darker wood." // i am not sure if the wood is really dark
	icon = 'icons/turf/smooth/walls/wood_dark.dmi'
	icon_state = MAP_SWITCH("wood_dark", "wood_dark-0")
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_CLOSED_WALL + SMOOTH_GROUP_WALLS_WOOD
	smoothing_list = SMOOTH_GROUP_DOOR_SECRET + SMOOTH_GROUP_WALLS_WOOD
	blade_dulling = DULLING_BASHCHOP
	max_integrity = 1000
	break_sound = 'sound/combat/hits/onwood/destroywalldoor.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
//	sheet_type = /obj/item/grown/log/tree/lumber
	above_floor = /turf/open/floor/rogue/ruinedwood
	baseturfs = /turf/open/floor/rogue/ruinedwood
	neighborlay = "dirtedge"
	climbdiff = 3
	burn_power = 20
	spread_chance = 4

/turf/closed/wall/mineral/rogue/woodbark
	name = "bark wall"
	desc = "a natural wall of dark bark."
	icon = 'icons/turf/roguewall.dmi'
	icon_state = "woodbark"
	smoothing_flags = null
	blade_dulling = DULLING_BASHCHOP
	max_integrity = 1100
	break_sound = 'sound/combat/hits/onwood/destroywalldoor.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
	above_floor = /turf/open/floor/rogue/ruinedwood
	baseturfs = /turf/open/floor/rogue/ruinedwood
	neighborlay = "dirtedge"
	climbdiff = 3
	burn_power = 20
	spread_chance = 4

/turf/closed/wall/mineral/rogue/woodbark/Initialize(mapload)
	dir = pick(NORTH, SOUTH, EAST, WEST)
	return ..()

/turf/closed/wall/mineral/rogue/woodbark/window
	name = "bark window"
	desc = "a natural window of dark wood, punched through the stump of a branch."
	icon_state = "woodbarkwindow"
	opacity = FALSE
	max_integrity = 850

/turf/closed/wall/mineral/rogue/woodbark/window/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && ((mover.pass_flags & PASSTABLE) || (mover.pass_flags & PASSGRILLE)) )
		return 1
	return ..()

/turf/closed/wall/mineral/rogue/wooddark/window
	name = "dark wood window"
	icon = 'icons/turf/roguewall.dmi'
	icon_state = "subwindow"
	opacity = FALSE
	max_integrity = 800

/turf/closed/wall/mineral/rogue/wooddark/window/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && ((mover.pass_flags & PASSTABLE) || (mover.pass_flags & PASSGRILLE)) )
		return 1
	return ..()

/turf/closed/wall/mineral/rogue/roofwall
	name = "wooden wall"
	icon = 'icons/turf/roguewall.dmi'
	icon_state = ""

	blade_dulling = DULLING_BASHCHOP
	max_integrity = 800
	break_sound = 'sound/combat/hits/onwood/destroywalldoor.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
	above_floor = /turf/open/floor/rogue/rooftop
	baseturfs = /turf/open/floor/rogue/ruinedwood
	neighborlay = "dirtedge"
	climbdiff = 3
	burn_power = 20
	spread_chance = 4

/turf/closed/wall/mineral/rogue/roofwall/center
	icon_state = "roofTurf_I"

/turf/closed/wall/mineral/rogue/roofwall/middle
	icon_state = "roofTurf_M"

/turf/closed/wall/mineral/rogue/roofwall/middle/dir1
	dir = 1

/turf/closed/wall/mineral/rogue/roofwall/middle/dir8
	dir = 8

/turf/closed/wall/mineral/rogue/roofwall/middle/dir4
	dir = 4

/turf/closed/wall/mineral/rogue/roofwall/outercorner
	icon_state = "roofTurf_OC"

/turf/closed/wall/mineral/rogue/roofwall/outercorner/dir1
	dir = 1

/turf/closed/wall/mineral/rogue/roofwall/outercorner/dir8
	dir = 8

/turf/closed/wall/mineral/rogue/roofwall/outercorner/dir4
	dir = 4

/turf/closed/wall/mineral/rogue/roofwall/innercorner
	icon_state = "roofTurf_IC"

/turf/closed/wall/mineral/rogue/roofwall/innercorner/dir1
	dir = 1

/turf/closed/wall/mineral/rogue/roofwall/innercorner/dir8
	dir = 8

/turf/closed/wall/mineral/rogue/roofwall/innercorner/dir4
	dir = 4

/turf/closed/wall/mineral/rogue/decowood
	name = "decorated wooden wall"
	desc = "Meticulously designed by a professional carpenter."
	icon = 'icons/turf/roguewall.dmi'
	icon_state = "decowood"

	blade_dulling = DULLING_BASHCHOP
	max_integrity = 1200
	break_sound = 'sound/combat/hits/onwood/destroywalldoor.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
//	sheet_type = /obj/item/grown/log/tree/lumber
	above_floor = /turf/open/floor/rogue/ruinedwood
	baseturfs = /turf/open/floor/rogue/ruinedwood
	neighborlay = "dirtedge"
	climbdiff = 3
	burn_power = 20
	spread_chance = 4

/turf/closed/wall/mineral/rogue/decowood/Initialize(mapload)
	. = ..()
	dir = pick(GLOB.cardinals)

/turf/closed/wall/mineral/rogue/decowood/vert
	name = "decorated wooden wall"
	icon_state = "decowood-vert"

/////////////////
// Stone walls //
/////////////////

/turf/closed/wall/mineral/rogue/stone
	name = "stone wall"
	desc = "A wall of smooth unyielding stone."
	icon = 'icons/turf/smooth/walls/stone.dmi'
	icon_state = MAP_SWITCH("stone", "stone-0")
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_CLOSED_WALL + SMOOTH_GROUP_WALLS_STONE
	smoothing_list = SMOOTH_GROUP_DOOR_SECRET + SMOOTH_GROUP_WALLS_STONE
	blade_dulling = DULLING_BASH
	max_integrity = 1000
	sheet_type = /obj/item/natural/stone
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	//canSmoothWith = list(/turf/closed/wall/mineral/rogue/stone)
	above_floor = /turf/open/floor/rogue/blocks
	baseturfs = /turf/open/floor/rogue/blocks
	neighborlay = "dirtedge"
	climbdiff = 3
	damage_deflection = 10//This makes up for same integrity as well it's easier to make than wooden walls

/turf/closed/wall/mineral/rogue/stone/turf_destruction()
	loud_message("The sound of a crumbling stone wall rings out", hearing_distance = 14)
	. = ..()

/turf/closed/wall/mineral/rogue/stone/unbreakable
	name = "heavy stone wall"
	desc = "Seems nigh-indestructable"
	max_integrity = 10000000
	damage_deflection = 99999999

/turf/closed/wall/mineral/rogue/stone/unbreakable/attackby(obj/item/I, mob/user, params, multiplier)
	to_chat(user, span_warning("TOO HARD!"))
	return FALSE

/turf/closed/wall/mineral/rogue/stone/window
	name = "stone window"
	desc = "A window with a solid and sturdy stone frame."
	opacity = FALSE
	max_integrity = 800

/turf/closed/wall/mineral/rogue/stone/window/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && ((mover.pass_flags & PASSTABLE) || (mover.pass_flags & PASSGRILLE)) )
		return 1
	return ..()

/turf/closed/wall/mineral/rogue/stone/window/Initialize(mapload)
	. = ..()
	icon_state = "stone"
	var/mutable_appearance/M = mutable_appearance(icon, "stonehole", layer = ABOVE_NORMAL_TURF_LAYER)
	add_overlay(M)

/turf/closed/wall/mineral/rogue/stone/window/unbreakable
	name = "heavy stone window"
	desc = "Seems nigh-indestructable"
	max_integrity = 10000000
	damage_deflection = 99999999

/turf/closed/wall/mineral/rogue/stone/window/unbreakable/attackby(obj/item/I, mob/user, params, multiplier)
	to_chat(user, span_warning("TOO HARD!"))
	return FALSE

/turf/closed/wall/mineral/rogue/stone/moss
	icon = 'icons/turf/smooth/walls/stone_moss.dmi'
	climbdiff = 4

/turf/closed/wall/mineral/rogue/stone/moss/unbreakable
	desc = "Seems nigh-indestructable"
	max_integrity = 10000000
	damage_deflection = 99999999

/turf/closed/wall/mineral/rogue/stone/moss/unbreakable/attackby(obj/item/I, mob/user, params, multiplier)
	to_chat(user, span_warning("TOO HARD!"))
	return FALSE

/turf/closed/wall/mineral/rogue/stone/window/moss
	icon = MAP_SWITCH( 'icons/turf/smooth/walls/stone_moss.dmi', 'icons/turf/window.dmi')
	icon_state = MAP_SWITCH("stone_moss", "stone_moss")
	climbdiff = 4

/turf/closed/wall/mineral/rogue/stone/window/moss/unbreakable
	desc = "Seems nigh-indestructable"
	max_integrity = 10000000
	damage_deflection = 99999999

/turf/closed/wall/mineral/rogue/stone/window/moss/unbreakable/attackby(obj/item/I, mob/user, params, multiplier)
	to_chat(user, span_warning("TOO HARD!"))
	return FALSE

/turf/closed/wall/mineral/rogue/craftstone
	name = "stone wall"
	desc = "A durable wall made from specially-crafted stone."
	icon = 'icons/turf/walls/craftstone.dmi'
	icon_state = "box"
	icon = 'icons/turf/smooth/walls/stone_fancy.dmi'
	icon_state = MAP_SWITCH("craftstone", "craftstone-0")
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_CLOSED_WALL + SMOOTH_GROUP_WALLS_STONE_CRAFT
	smoothing_list = SMOOTH_GROUP_DOOR_SECRET + SMOOTH_GROUP_WALLS_STONE_CRAFT
	blade_dulling = DULLING_BASH
	max_integrity = 1200
	sheet_type = /obj/item/natural/stone
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	//canSmoothWith = list(/turf/closed/wall/mineral/rogue/craftstone)
	above_floor = /turf/open/floor/rogue/blocks
	baseturfs = /turf/open/floor/rogue/blocks
	neighborlay = "dirtedge"
	climbdiff = 3
	damage_deflection = 10

/turf/closed/wall/mineral/rogue/craftstone/turf_destruction()
	loud_message("The sound of heavy stone bricks crumbling apart rings out", hearing_distance = 14)
	. = ..()

/turf/closed/wall/mineral/rogue/stonebrick
	name = "brick wall"
	desc = "Rows of overlapping bricks form this wall."
	icon = 'icons/turf/smooth/walls/stone_brick.dmi'
	icon_state = MAP_SWITCH("stone_brick", "stone_brick-0")
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_CLOSED_WALL + SMOOTH_GROUP_WALLS_STONE_BRICK
	smoothing_list = SMOOTH_GROUP_DOOR_SECRET + SMOOTH_GROUP_WALLS_STONE_BRICK
	blade_dulling = DULLING_BASH
	max_integrity = 1300
	sheet_type = /obj/item/natural/stone
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	//canSmoothWith = list(/turf/closed/wall/mineral/rogue/stonebrick, /turf/closed/wall/mineral/rogue/wooddark)
	above_floor = /turf/open/floor/rogue/blocks
	baseturfs = /turf/open/floor/rogue/blocks
	neighborlay = "dirtedge"
	climbdiff = 4
	damage_deflection = 15

/turf/closed/wall/mineral/rogue/decostone
	name = "decorated stone wall"
	desc = "The mason did an excellent job etching details into this wall."
	icon = 'icons/turf/smooth/walls/stone_deco.dmi'
	icon_state = MAP_SWITCH("stone_deco", "stone_deco-0")
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_CLOSED_WALL + SMOOTH_GROUP_WALLS_STONE_DECO
	smoothing_list = SMOOTH_GROUP_DOOR_SECRET + SMOOTH_GROUP_WALLS_STONE_DECO
	blade_dulling = DULLING_BASH
	max_integrity = 1400
	sheet_type = /obj/item/natural/stone
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	above_floor = /turf/open/floor/rogue/blocks
	baseturfs = /turf/open/floor/rogue/blocks
	neighborlay = "dirtedge"
	climbdiff = 3



/obj/structure/thronething
	name = "decorated stone wall" // what is thronething??
	icon = 'icons/turf/roguewall.dmi'
	max_integrity = 0
	opacity = 0
	icon_state = "decostone-l"


/turf/closed/wall/mineral/rogue/decostone/cand
	icon_state = "decostone-cand"

/turf/closed/wall/mineral/rogue/decostone/fluffstone
	icon_state = "fluffstone"

//Mildly better than stone-wall due to it being harder to make, plus not loose-stone cobbled together. Also higher climbing diff akin to stone-brick wall.
/turf/closed/wall/mineral/rogue/brick
	name = "brick wall"
	desc = "Rows of overlapping bricks held together by mortar form a nigh-impenetrable wall of stone."
//	icon = 'icons/turf/walls/brick_wall.dmi'
	icon_state = "brick"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_CLOSED_WALL + SMOOTH_GROUP_WALLS_STONE_BRICK
	smoothing_list = SMOOTH_GROUP_DOOR_SECRET + SMOOTH_GROUP_WALLS_STONE_BRICK
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	//canSmoothWith = list(/turf/closed/wall/mineral/rogue/brick)
	above_floor = /turf/open/floor/rogue/tile/brick
	baseturfs = /turf/open/floor/rogue/tile/brick
	neighborlay = "dirtedge"
	climbdiff = 4			//Same as stone-brick wall
	damage_deflection = 20

/turf/closed/wall/mineral/rogue/brick/window
	name = "brick window"
	desc = "A window with a solid and sturdy stone frame."
	opacity = FALSE
	max_integrity = 1400

/////////////////
// Metal walls //
/////////////////

/turf/closed/wall/mineral/rogue/pipe
	name = "metal wall"
	desc = "Solid steel made into an impenetrable obstacle. Dense piping runs along its face."
	icon = 'icons/turf/smooth/walls/pipe_used.dmi'
	icon_state = MAP_SWITCH("pipe", "pipe-0")
	smoothing_flags = SMOOTH_BITMASK_CARDINALS
	smoothing_groups = SMOOTH_GROUP_CLOSED_WALL + SMOOTH_GROUP_WALLS_PIPE
	smoothing_list = SMOOTH_GROUP_DOOR_SECRET + SMOOTH_GROUP_WALLS_PIPE
	blade_dulling = DULLING_BASH
	max_integrity = 30000
	sheet_type = null
	break_sound = 'sound/combat/hits/onmetal/sheet (1).ogg'
	attacked_sound = list('sound/combat/hits/onmetal/attackpipewall (1).ogg','sound/combat/hits/onmetal/attackpipewall (2).ogg')
	//canSmoothWith = list(/turf/closed/wall/mineral/rogue/pipe)
	above_floor = /turf/open/floor/rogue/concrete
	baseturfs = /turf/open/floor/rogue/concrete
	climbdiff = 4
	damage_deflection = 20

/turf/closed/wall/mineral/rogue/stone/blue_moss
	icon = 'icons/turf/smooth/walls/stone_moss_blue.dmi'

/turf/closed/wall/mineral/rogue/stone/window/blue_moss
	icon = MAP_SWITCH('icons/turf/smooth/walls/stone_moss_blue.dmi', 'icons/turf/window.dmi')

/turf/closed/wall/mineral/rogue/stone/red_moss
	icon = MAP_SWITCH('icons/turf/smooth/walls/stone_moss_red.dmi', 'icons/turf/window.dmi')


/turf/closed/wall/mineral/rogue/stone/red_moss
	icon = MAP_SWITCH('icons/turf/smooth/walls/stone_moss_red.dmi', 'icons/turf/window.dmi')


/turf/closed/wall/mineral/rogue/decostone/mossy
	name = "decorated mossy stone wall"
	desc = "There was much effort put into this wall a long time ago."
	icon = 'icons/turf/smooth/walls/stone_moss.dmi'
	climbdiff = 4

/turf/closed/wall/mineral/rogue/decostone/mossy/cand
	icon_state = "decostone-cand-green"

/turf/closed/wall/mineral/rogue/decostone/mossy/blue
	icon = 'icons/turf/smooth/walls/stone_d_moss_b.dmi'

/turf/closed/wall/mineral/rogue/decostone/mossy/blue/long
	icon_state = "decostone-l-blue"

/turf/closed/wall/mineral/rogue/decostone/mossy/blue/end
	icon_state = "decostone-e-blue"

/turf/closed/wall/mineral/rogue/decostone/mossy/blue/cand
	icon_state = "decostone-cand-blue"

/turf/closed/wall/mineral/rogue/decostone/mossy/red
	icon_state = "decostone-b-red"

/turf/closed/wall/mineral/rogue/decostone/mossy/red/long
	icon_state = "decostone-l-red"

/turf/closed/wall/mineral/rogue/decostone/mossy/red/end
	icon_state = "decostone-e-red"

/turf/closed/wall/mineral/rogue/decostone/mossy/red/cand
	icon_state = "decostone-cand-red"


////////////////
// Misc walls //
////////////////

/turf/closed/wall/mineral/rogue/tent
	name = "tent"
	desc = "Made from durable fabric stretched over wooden branches."
	icon = 'icons/turf/roguewall.dmi'
	icon_state = "tent"

	blade_dulling = DULLING_BASHCHOP
	max_integrity = 300
	break_sound = 'sound/combat/hits/onwood/destroywalldoor.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
//	//canSmoothWith = list(/turf/closed/wall/mineral/rogue/wood, /obj/structure/roguewindow, /turf/closed/wall/mineral/rogue/wooddark)
//	sheet_type = /obj/item/grown/log/tree/lumber
	above_floor = /turf/open/floor/rogue/twig
	baseturfs = /turf/open/floor/rogue/twig
	neighborlay = "dirtedge"
	climbdiff = 1

	burn_power = 20
	spread_chance = 9

/turf/closed/wall/shroud //vines
	name = "thick treetop"
	desc = "All the birds flew away before I could see one!"
	icon = 'icons/turf/roguewall.dmi'
	icon_state = "shroud1"
	var/smooth_icon = 'icons/turf/smoothrocks.dmi'
	//canSmoothWith = null
	baseturfs = /turf/open/floor/rogue/shroud
	blade_dulling = DULLING_CUT
	opacity = 1
	density = TRUE
	max_integrity = 200
//	layer = EDGED_TURF_LAYER /ROGTODO make these have borders and smooth
	temperature = TCMB
	sheet_type = null
	attacked_sound = list('sound/combat/hits/onvine/vinehit.ogg')
	debris = list(/obj/item/grown/log/tree/stick = 1, /obj/item/natural/thorn = 2, /obj/item/natural/fibers = 1)
	climbdiff = 0
	above_floor = /turf/open/floor/rogue/shroud
	var/res = 0
	var/res_replenish

/turf/closed/wall/shroud/attack_right(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		user.changeNext_move(CLICK_CD_MELEE)
		playsound(src, "plantcross", 50, FALSE, -1)
		if(do_after(L, rand(5,10), target = src))
			if(!res && world.time > res_replenish)
				res = rand(1,3)
			if(res && prob(50))
				res--
				if(res <= 0)
					res_replenish = world.time + 8 MINUTES
				var/obj/item/B = new /obj/item/grown/log/tree/stick(user.loc)
				user.put_in_hands(B)
				user.visible_message(span_notice("[user] finds [B] in [src]."))
				return
			user.visible_message(span_warning("[user] searches through [src]."))
			if(!res)
				to_chat(user, span_warning("Picked clean... I should try later."))
	..()

/turf/closed/wall/shroud/Initialize(mapload)
	. = ..()
	icon_state = "shroud[pick(1,2)]"
	dir = pick(GLOB.cardinals)
	res = rand(1,3)
	var/turf/open/transparent/openspace/target = get_step_multiz(src, UP)
	if(istype(target))
		target.ChangeTurf(/turf/open/floor/rogue/dirt/road)
