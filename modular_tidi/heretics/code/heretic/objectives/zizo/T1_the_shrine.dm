/datum/objective/heretic/zizo/shrine
	name = "The Shrine"
	heretic_tier = 1

/datum/objective/heretic/zizo/shrine/update_explanation_text()
	explanation_text = "Construct an inverted psycross somewhere in the town."

/datum/objective/heretic/zizo/shrine/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_ITEM_CRAFTED, PROC_REF(on_item_crafted))
	update_explanation_text()

/datum/objective/heretic/zizo/shrine/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_ITEM_CRAFTED)
	return ..()

/datum/objective/heretic/zizo/shrine/proc/on_item_crafted(datum/source, mob/user, craft_path)
	SIGNAL_HANDLER
	if(completed || !ispath(craft_path, /obj/structure/fluff/psycross/zizocross))
		return
	var/area/rogue/crafted_area = get_area(user)
	if(!istype(crafted_area) || !crafted_area.town_area)
		return
	complete()
	UnregisterSignal(owner.current, COMSIG_ITEM_CRAFTED)

/// So we can actually build them
/datum/crafting_recipe/roguetown/structure/zizo_cross
	always_availible = TRUE
	skillcraft = null
	craftdiff = 0

/datum/crafting_recipe/roguetown/structure/zizo_cross_stone
	always_availible = TRUE
	skillcraft = null
	craftdiff = 0

/datum/crafting_recipe/roguetown/structure/zizo_cross_gold
	always_availible = TRUE
	skillcraft = null
	craftdiff = 0
