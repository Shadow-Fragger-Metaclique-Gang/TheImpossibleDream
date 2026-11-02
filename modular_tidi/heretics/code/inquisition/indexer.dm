/obj/item/inqarticles/indexer
	desc = "A blessed bladetip on a silvered mechanism, made to quietly take a sample of blood into a vial for testing."
	possible_item_intents = list(/datum/intent/use)
	var/obj/item/inqarticles/blood_vial/vial

/obj/item/inqarticles/indexer/Destroy()
	QDEL_NULL(vial)
	return ..()

/obj/item/inqarticles/indexer/getonmobprop(tag) // Hides inhands
	if(tag == "gen")
		return
	return ..()

/obj/item/inqarticles/indexer/update_icon_state()
	if(!vial)
		icon_state = "indexer"
	else if(vial.cursed)
		icon_state = "indexer_cursed"
	else
		icon_state = vial.subject_name ? "indexer_full" : "indexer_ready"
	return ..()

/obj/item/inqarticles/indexer/get_mechanics_examine(mob/user)
	if(!HAS_TRAIT(user, TRAIT_INQUISITION))
		return list()
	. = list()
	. += span_info("Load a blood vial into the INDEXER, then use it on someone to take a sample.")
	. += span_info("Aim for a part of them that's bare. The jab is quick and quiet; they won't notice, and only I hear the INDEXER work.")
	. += span_info("A throat can always be jabbed, covered or not, but I must have a hold of them first, and everyone nearby will see and hear it.")
	. += span_info("The INDEXER can also draw the blood out of a rune carved in it. The HEMATIC ASSAYER can follow it back to whoever carved it.")
	. += span_info("Use the INDEXER in hand to take the vial out, then test the vial at the HEMATIC ASSAYER.")

/obj/item/inqarticles/indexer/attackby(obj/item/I, mob/living/user, params)
	var/obj/item/inqarticles/blood_vial/new_vial = I
	if(!istype(new_vial))
		return ..()
	if(vial)
		to_chat(user, span_warning("[src] already holds a vial."))
		return TRUE
	if(!user.transferItemToLoc(new_vial, src))
		return TRUE
	vial = new_vial
	playsound(src, 'sound/items/indexer_open.ogg', 50, FALSE, -1)
	update_icon()
	return TRUE

/obj/item/inqarticles/indexer/attack_self(mob/user)
	eject_vial(user)

/obj/item/inqarticles/indexer/attack_right(mob/user)
	eject_vial(user)

/obj/item/inqarticles/indexer/proc/eject_vial(mob/user)
	if(!vial)
		to_chat(user, span_warning("There's no vial in [src]."))
		return
	playsound(src, 'sound/items/indexer_shut.ogg', 50, FALSE, -1)
	if(!user.put_in_hands(vial))
		vial.forceMove(get_turf(src))
	vial = null
	update_icon()

/obj/item/inqarticles/indexer/attack(mob/living/M, mob/living/user)
	if(HAS_TRAIT(user, TRAIT_INQUISITION))
		return
	return ..()

/obj/item/inqarticles/indexer/pre_attack(atom/A, mob/living/user, params)
	if(!HAS_TRAIT(user, TRAIT_INQUISITION) || !ishuman(A))
		return ..()
	. = TRUE
	var/mob/living/carbon/human/subject = A
	if(!vial)
		to_chat(user, span_warning("There's no vial in [src]."))
		return
	if(vial.subject_name)
		to_chat(user, span_warning("The vial is already full."))
		return
	if(NOBLOOD in subject.dna?.species?.species_traits)
		say("ERROR. BONE MARROW IS NOT A VALID INDEXING SUBSTANCE.")
		playsound(subject, 'sound/combat/hits/bladed/genstab (1).ogg', 50, FALSE, -1)
		return
	if(user.zone_selected == BODY_ZONE_PRECISE_NECK) // Grabbing and aiming neck lets you bypass clothing checks but isn't silent
		if(user.pulling != subject)
			to_chat(user, span_warning("I need a hold of [subject] to reach [subject.p_their()] throat."))
			return
		subject.visible_message(span_danger("[user] jabs [src] into [subject]'s throat!"), span_userdanger("[user] jabs [src] into my throat!"))
		playsound(subject, 'sound/items/indexer_finished.ogg', 100, FALSE)
		if(subject.show_redflash())
			subject.flash_fullscreen("redflash3")
	else
		if(!get_location_accessible(subject, user.zone_selected))
			to_chat(user, span_warning("[subject]'s [parse_zone(user.zone_selected)] is covered."))
			return
		user.playsound_local(user, 'sound/items/indexer_finished.ogg', 50, FALSE)
		to_chat(user, span_notice("I quietly take a sample of [subject]'s blood."))
	vial.fill(subject.real_name, subject.get_blood_corruption(), subject.mind && (subject.mind.has_antag_datum(/datum/antagonist/werewolf) || subject.mind.has_antag_datum(/datum/antagonist/vampire)), subject)
	update_icon()
	if(vial.cursed) // Concrete scraping sound dot ogg
		playsound(src, 'sound/items/indexer_cursed.ogg', 100, FALSE, 3)
		say("CURSED BLOOD!")

/obj/structure/ritualcircle
	var/datum/weakref/blood_carver

/obj/structure/ritualcircle/attackby(obj/item/I, mob/living/user, params) // Erase your blood runes bozo
	var/obj/item/inqarticles/indexer/indexer = I
	if(!istype(indexer) || !HAS_TRAIT(user, TRAIT_INQUISITION) || !blood_carver_name)
		return ..()
	if(!indexer.vial || indexer.vial.subject_name)
		to_chat(user, span_warning("[indexer] needs an empty vial to draw the blood from [src]."))
		return TRUE
	var/mob/living/carver = blood_carver?.resolve()
	indexer.vial.fill(blood_carver_name, 100, carver?.mind && (carver.mind.has_antag_datum(/datum/antagonist/werewolf) || carver.mind.has_antag_datum(/datum/antagonist/vampire)), carver)
	indexer.update_icon()
	user.visible_message(span_warning("[user] drives [indexer] into [src], drawing the dried blood out of it as the rune crumbles away!"), span_notice("[indexer] draws the dried blood out of [src], and the rune crumbles away."))
	playsound(src, 'sound/items/indexer_finished.ogg', 100, FALSE)
	if(indexer.vial.cursed) // This is extremely unlikely to happen
		playsound(indexer, 'sound/items/indexer_cursed.ogg', 100, FALSE, 3)
		indexer.say("CURSED BLOOD!")
	qdel(src)
	return TRUE

/obj/item/paper/inqslip/attacked_by(obj/item/I, mob/living/user) // Not anymore
	if(istype(I, /obj/item/inqarticles/indexer))
		return
	return ..()

/obj/item/inqarticles/blood_vial
	name = "blood vial"
	desc = "A small sealed vial made to hold a sample of blood for testing."
	icon = 'modular_tidi/heretics/icons/assayer.dmi'
	icon_state = "assayer_vial"
	w_class = WEIGHT_CLASS_TINY
	grid_width = 32
	grid_height = 32
	sellprice = 0
	var/subject_name
	var/subject_corruption = 0
	var/cursed = FALSE
	var/label
	var/datum/weakref/subject

/obj/item/inqarticles/blood_vial/update_icon_state()
	if(!subject_name)
		icon_state = "assayer_vial"
	else
		icon_state = cursed ? "assayer_vial_full_cursed" : "assayer_vial_full"
	return ..()

/obj/item/inqarticles/blood_vial/update_overlays()
	. = ..()
	if(label)
		. += mutable_appearance(icon, "vial_label")

/obj/item/inqarticles/blood_vial/examine(mob/user)
	. = ..()
	if(subject_name && HAS_TRAIT(user, TRAIT_INQUISITION))
		if(cursed)
			. += span_warning("The blood within is turbid and accursed. There's no need to test it, but Otava will pay for a sample of it through the HERMES.")
		else
			. += span_notice("It holds a sample of blood. Use it in hand to mark it before testing.")
	else if(subject_name)
		. += span_notice("It holds a sample of blood.")

/obj/item/inqarticles/blood_vial/attack_self(mob/user)
	if(!subject_name)
		to_chat(user, span_warning("[src] is empty."))
		return
	if(cursed)
		to_chat(user, span_warning("The accursed blood needs no name."))
		return
	var/new_label = stripped_input(user, "WHOSE BLOOD IS THIS?", "BLOOD VIAL", label, MAX_NAME_LEN)
	if(!new_label || !subject_name || cursed || !user.is_holding(src))
		return
	label = new_label
	name = "[initial(name)] ([label])"
	update_icon()
	to_chat(user, span_notice("I mark [src] as the blood of [label]."))

/obj/item/inqarticles/blood_vial/proc/fill(name, corruption, is_cursed = FALSE, mob/living/subject_mob)
	subject_name = name
	subject_corruption = corruption
	cursed = is_cursed
	subject = subject_mob ? WEAKREF(subject_mob) : null
	update_icon()

/obj/item/inqarticles/blood_vial/proc/empty()
	subject_name = null
	subject_corruption = 0
	cursed = FALSE
	label = null
	subject = null
	name = initial(name)
	update_icon()

/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius/attacked_by(obj/item/I, mob/living/user)
	var/obj/item/inqarticles/blood_vial/blood = I
	if(!istype(blood) || !blood.cursed || !HAS_TRAIT(user, TRAIT_INQUISITION))
		return ..()
	if(alert(user, "DRENCH THE FYRITIUS?", "CURSED BLOOD", "YES", "NO") != "YES")
		return
	blood.empty()
	changefood(/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius/bloodied, user)

GLOBAL_LIST_EMPTY(cursed_blood_sold)

/obj/structure/roguemachine/mail/attackby(obj/item/P, mob/user, params)
	var/obj/item/inqarticles/blood_vial/vial = P
	if(!istype(vial) || !vial.cursed || !(HAS_TRAIT(user, TRAIT_INQUISITION) || HAS_TRAIT(user, TRAIT_PURITAN)))
		return ..()
	if(vial.subject_name in GLOB.cursed_blood_sold)
		to_chat(user, span_warning("Otava already has this one's blood."))
		return TRUE
	GLOB.cursed_blood_sold += vial.subject_name
	visible_message(span_warning("[user] sends something."))
	budget2change(4, user, "MARQUE")
	record_round_statistic(STATS_MARQUES_MADE, 4)
	playsound(loc, 'sound/misc/otavanlament.ogg', 100, FALSE, -1)
	playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
	qdel(vial)
	return TRUE

/datum/inqports/articles/accusations
	name = null

/datum/inqports/articles/indexaccused
	name = null

/datum/inqports/articles/assayer
	name = "Replacement HEMATIC ASSAYER"
	item_type = /obj/item/inqarticles/assayer
	marquescost = 16
	maximum = 1

/datum/inqports/articles/indexers
	name = "2 INDEXERs"
	item_type = /obj/structure/closet/crate/chest/inqcrate/articles/indexers
	marquescost = 4

/datum/inqports/articles/blood_vials
	name = "4 Blood Vials"
	item_type = /obj/structure/closet/crate/chest/inqcrate/articles/blood_vials
	marquescost = 4

/obj/structure/closet/crate/chest/inqcrate/articles/indexers/Initialize(mapload)
	. = ..()
	new /obj/item/inqarticles/indexer(src)
	new /obj/item/inqarticles/indexer(src)

/obj/structure/closet/crate/chest/inqcrate/articles/blood_vials/Initialize(mapload)
	. = ..()
	new /obj/item/inqarticles/blood_vial(src)
	new /obj/item/inqarticles/blood_vial(src)
	new /obj/item/inqarticles/blood_vial(src)
	new /obj/item/inqarticles/blood_vial(src)

/obj/structure/closet/crate/chest/inqcrate/articles/blood_testing/Initialize(mapload)
	. = ..()
	new /obj/item/inqarticles/assayer(src)
	new /obj/item/inqarticles/indexer(src)
	new /obj/item/inqarticles/indexer(src)
	new /obj/item/inqarticles/blood_vial(src)
	new /obj/item/inqarticles/blood_vial(src)
	new /obj/item/inqarticles/blood_vial(src)
	new /obj/item/inqarticles/blood_vial(src)

/datum/controller/subsystem/ticker/PostSetup() // Send a box of heretic hunting stuff when the round type isn't extended
	. = ..()
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(deliver_inquisition_shipment)), HERETIC_AWAKEN_LATEST)

GLOBAL_VAR_INIT(inquisition_shipment_delivered, FALSE)

/proc/deliver_inquisition_shipment(forced = FALSE)
	if(GLOB.inquisition_shipment_delivered)
		return FALSE
	if(!forced && istype(active_preset(), /datum/storyteller/gamemode/extended))
		return FALSE
	var/area/import = GLOB.areas_by_type[/area/rogue/indoors/inq/import]
	if(!import)
		return FALSE
	var/list/turfs = list()
	for(var/turf/T in import)
		turfs += T
	if(!length(turfs))
		return FALSE
	GLOB.inquisition_shipment_delivered = TRUE
	var/turf/drop = pick(turfs)
	playsound(drop, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
	new /obj/structure/closet/crate/chest/inqcrate/articles/blood_testing(drop)
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(HAS_TRAIT(H, TRAIT_INQUISITION))
			to_chat(H, span_warning("A shipment of INDEXERs and blood vials has arrived from Otava. The heretics have stirred; find them."))
			H.playsound_local(H, 'modular_tidi/heretics/sound/heretics_arrival.ogg', 50, FALSE)
	return TRUE
