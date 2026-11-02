/obj/item/roguekey/ortho_four
	name = "Otavan Embassy Bedroom IV key"
	desc = "This key opens the doors to bedroom four."
	icon_state = "brownkey"
	lockid = "OEB4"

/obj/item/roguekey/ortho_five
	name = "Otavan Embassy Bedroom V key"
	desc = "This key opens the doors to bedroom five."
	icon_state = "brownkey"
	lockid = "OEB5"

/obj/structure/roguemachine/vendor/inq_keys/Initialize(mapload)
	. = ..()
	for(var/X in list(/obj/item/roguekey/ortho_four, /obj/item/roguekey/ortho_five))
		var/obj/P = new X(src)
		held_items[P] = list()
		held_items[P]["NAME"] = P.name
		held_items[P]["PRICE"] = 0
