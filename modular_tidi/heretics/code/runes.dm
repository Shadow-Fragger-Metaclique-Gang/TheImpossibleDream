GLOBAL_LIST_INIT(surrealis_rune_types, list(
	"Rune of Sun" = /obj/structure/ritualcircle/astrata,
	"Rune of Moon" = /obj/structure/ritualcircle/noc,
	"Rune of Beasts" = /obj/structure/ritualcircle/dendor,
	"Rune of Forge" = /obj/structure/ritualcircle/malum,
	"Rune of Trickery" = /obj/structure/ritualcircle/xylix,
	"Rune of Death" = /obj/structure/ritualcircle/necra,
	"Rune of Plague" = /obj/structure/ritualcircle/pestra,
	"Rune of Love" = /obj/structure/ritualcircle/eora,
	"Rune of Justice" = /obj/structure/ritualcircle/ravox,
	"Rune of Storms" = /obj/structure/ritualcircle/abyssor,
	"Rune of Stirring" = /obj/structure/ritualcircle/abyssor_alt_inactive,
	"Rune of Zizo" = /obj/structure/ritualcircle/zizo,
	"Rune of Transaction" = /obj/structure/ritualcircle/matthios,
	"Rune of Violence" = /obj/structure/ritualcircle/graggar,
	"Rune of Hedonism" = /obj/structure/ritualcircle/baotha,
	"Rune of Psydon" = /obj/effect/decal/cleanable/roguerune/god/psydon,
	"Rune of Divinity" = /obj/structure/ritualcircle/undivided,
))

GLOBAL_LIST_INIT(surrealis_rune_patrons, list(
	"Rune of Sun" = /datum/patron/divine/astrata,
	"Rune of Moon" = /datum/patron/divine/noc,
	"Rune of Beasts" = /datum/patron/divine/dendor,
	"Rune of Forge" = /datum/patron/divine/malum,
	"Rune of Trickery" = /datum/patron/divine/xylix,
	"Rune of Death" = /datum/patron/divine/necra,
	"Rune of Plague" = /datum/patron/divine/pestra,
	"Rune of Love" = /datum/patron/divine/eora,
	"Rune of Justice" = /datum/patron/divine/ravox,
	"Rune of Storms" = /datum/patron/divine/abyssor,
	"Rune of Stirring" = /datum/patron/divine/abyssor,
	"Rune of Zizo" = /datum/patron/inhumen/zizo,
	"Rune of Transaction" = /datum/patron/inhumen/matthios,
	"Rune of Violence" = /datum/patron/inhumen/graggar,
	"Rune of Hedonism" = /datum/patron/inhumen/baotha,
	"Rune of Psydon" = /datum/patron/old_god,
	"Rune of Divinity" = /datum/patron/divine/undivided,
))

/proc/surrealis_rune_god(rune_name)
	var/datum/patron/rune_patron = GLOB.surrealis_rune_patrons[rune_name]
	return initial(rune_patron.name)

/proc/surrealis_patron_rune(patron_type)
	for(var/rune_name in GLOB.surrealis_rune_patrons)
		if(GLOB.surrealis_rune_patrons[rune_name] == patron_type)
			return rune_name
	return null

/proc/surrealis_choose_rune(mob/living/user)
	var/own_rune = surrealis_patron_rune(user.patron?.type)
	if(own_rune)
		var/choice = alert(user, "Which rune shall I draw?", "Rune", "[surrealis_rune_god(own_rune)]'s rune", "Another patron's rune", "Cancel")
		if(choice == "Cancel")
			return null
		if(choice != "Another patron's rune")
			return own_rune
	var/list/rune_names = GLOB.surrealis_rune_types.Copy()
	if(!HAS_TRAIT(user, TRAIT_DREAMWALKER) && user.patron?.type != /datum/patron/divine/abyssor)
		rune_names -= "Rune of Stirring"
	return input(user, "Which patron's rune shall I draw?", "Rune") as null|anything in rune_names
