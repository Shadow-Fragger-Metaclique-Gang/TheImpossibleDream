/obj/item/clothing/neck/roguetown/examine(mob/user)
	. = ..()
	if(bell)
		. += span_info("It has a <a href='?src=[REF(src)];removebell=1'>bell</a> attached.")

/obj/item/clothing/neck/roguetown/Topic(href, href_list)
	..()

	if(!usr)
		return

	if(href_list["removebell"])
		remove_bell(usr)

/obj/item/clothing/neck/roguetown/proc/remove_bell(mob/user)
	if(!bell)
		return
	if(!Adjacent(user))
		to_chat(user, span_warning("As much as I'd love to snatch that bell, I'm not close enough."))
		return
	for(var/obj/item/catbell/bell in src)
		user.put_in_hands(bell)
		break
	bell = FALSE
	bellsound = FALSE
	qdel(src.GetComponent(/datum/component/squeak))
	to_chat(user, span_info("I remove the bell from [src]."))

/obj/item/clothing/neck/roguetown/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/catbell))
		var/obj/item/catbell/bell = I
		if(src.bellsound || src.bell) //Already has a bell, can't attach another one.
			to_chat(user, span_info("[src] already has a bell attached!"))
			return
		to_chat(user, span_info("I attach \the [bell] to [src]."))
		src.bell = TRUE
		src.bellsound = TRUE
		src.AddComponent(/datum/component/squeak, bell.jingle_sounds, 50, 100, 1)
		I.forceMove(src)
	..()

/obj/item/clothing/neck/roguetown/gorget/cursed_collar
	leashable = TRUE

/obj/item/clothing/neck/roguetown/collar
	leashable = TRUE

/obj/item/clothing/neck/roguetown/collar/leather
	name = "leather collar"
	desc = "A sturdy leather collar."
	icon = 'modular_tidi/sexcon/icons/leashes_collars.dmi'
	mob_overlay_icon = 'modular_tidi/sexcon/icons/collars_leashes.dmi'
	icon_state = "leathercollar"
	item_state = "leathercollar"
	leashable = TRUE
	resistance_flags = FIRE_PROOF
	bellsound = FALSE
	bell = FALSE

/obj/item/clothing/neck/roguetown/collar/cowbell
	name = "cowbell collar"
	desc = "A leather collar with a jingly cowbell attached."
	icon = 'modular_tidi/sexcon/icons/leashes_collars.dmi'
	mob_overlay_icon = 'modular_tidi/sexcon/icons/collars_leashes.dmi'
	icon_state = "cowbellcollar"
	item_state = "cowbellcollar"
	leashable = TRUE
	resistance_flags = FIRE_PROOF
	bellsound = TRUE

/obj/item/clothing/neck/roguetown/collar/cowbell/Initialize(mapload)
		. = ..()
		AddComponent(/datum/component/squeak, SFX_CBJINGLE, 50, 100, 1) //We want squeak so wearer jingles if touched while wearing collar

/obj/item/clothing/neck/roguetown/collar/catbell
	name = "catbell collar"
	desc = "A leather collar with a jingling catbell attached."
	icon = 'modular_tidi/sexcon/icons/leashes_collars.dmi'
	mob_overlay_icon = 'modular_tidi/sexcon/icons/collars_leashes.dmi'
	icon_state = "catbellcollar"
	item_state = "catbellcollar"
	leashable = TRUE
	resistance_flags = FIRE_PROOF
	bellsound = TRUE

/obj/item/clothing/neck/roguetown/collar/catbell/Initialize(mapload)
		. = ..()
		AddComponent(/datum/component/squeak, SFX_COLLARJINGLE, 50, 100, 1) //We want squeak so wearer jingles if touched while wearing collar
