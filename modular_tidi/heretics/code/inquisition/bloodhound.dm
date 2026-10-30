// tracks hex foci by tasting the user's blood in case of an absolver being absent
/obj/item/inqarticles/bloodhound
	name = "BLOODHOUND"
	desc = "The latest advancements in thaumaturgy and haematology have yielded an apparatus capable of tracking the foci sustaining heretical curses, at a price."
	icon = 'modular_tidi/heretics/icons/scanner.dmi' // yeah i don't have a sprite that rly fits for this
	icon_state = "scanner"
	w_class = WEIGHT_CLASS_HUGE // we want this to be big and bulky so we use the absolver when we can!
	twohands_required = TRUE
	grid_width = 32
	grid_height = 32
	possible_item_intents = list(/datum/intent/use)
	gripped_intents = list(/datum/intent/use)
	sellprice = 0
	verb_say = "growls"

/obj/item/inqarticles/bloodhound/attack_self(mob/living/carbon/human/user)
	if(!do_after(user, 1 SECONDS))
		return
	user.blood_volume = max(user.blood_volume - 20, 0) // again, we want to use the absolver.
	user.fullscreen_redflash(pick("redflash1", "redflash2"))
	if(!length(user.active_hexes))
		say("NOTHING.")
		return

	var/datum/hex/tracked_hex = user.active_hexes[1] // you dont get to choose what hex you're tracking buddy. get the absolver.
	var/list/tracked_info = get_tracking_info(src, tracked_hex.focus)
	if(!tracked_info)
		return
	if(tracked_info["z_level_difference"] != 0)
		say(tracked_info["z_level_difference"] > 0 ? "ABOVE." : "BELOW.")
		return
	if(tracked_info["distance"] <= 0) // -1 means you're on the same turf
		say("HERE.")
		return
	var/direction = uppertext(tracked_info["direction"])
	var/proximity = tracked_info["distance"] > 15 ? "FAR." : "CLOSE."
	say("[direction]. [proximity]")

/datum/inqports/articles/bloodhound
	name = "BLOODHOUND"
	item_type = /obj/item/inqarticles/bloodhound
	marquescost = 8
	maximum = 1
