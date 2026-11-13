/obj/machinery/light/rogue/hearth/LateInitialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD


/obj/machinery/light/rogue/hearth/LateInitialize()
	. = ..()
	if(!attachment)
		var/obj/item/cooking/pan/mypan = locate(/obj/item/cooking/pan) in get_turf(src)
		if(mypan)
			mypan.forceMove(src)
			attachment=mypan
		else
			var/obj/item/reagent_containers/glass/bucket/pot/mypot = locate(/obj/item/reagent_containers/glass/bucket/pot) in get_turf(src)
			if(mypot)
				mypot.forceMove(src)
				attachment=mypot
