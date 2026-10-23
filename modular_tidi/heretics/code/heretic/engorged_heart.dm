/obj/item/organ/heart/engorged
	name = "engorged heart"
	desc = "A massive, feverishly hot heart. Something within it yearns to hunt."
	var/assassin_heart = FALSE

/datum/species/gnoll/New()
	. = ..()
	organs[ORGAN_SLOT_HEART] = /obj/item/organ/heart/engorged

/obj/item/reagent_containers/food/snacks/organ/check_culling(mob/living/carbon/human/eater)
	. = ..()
	if(!istype(eater))
		return
	eater.adjust_blood_corruption(5)
	if(QDELETED(organ_inside) || !istype(organ_inside, /obj/item/organ/heart))
		return
	SEND_SIGNAL(eater, COMSIG_HERETIC_HEART_EATEN, organ_inside)
	if(!istype(organ_inside, /obj/item/organ/heart/engorged) || !HAS_TRAIT(eater, TRAIT_HORDE))
		return
	eater.set_blood_corruption(100)
	if(HAS_TRAIT_FROM(eater, TRAIT_STRENGTH_UNCAPPED, "engorged_heart"))
		return
	ADD_TRAIT(eater, TRAIT_STRENGTH_UNCAPPED, "engorged_heart")
	eater.change_stat(STATKEY_STR, 1)
	GLOB.excommunicated_players |= eater.real_name // You taste the forbidden fruit
	to_chat(eater, span_cultlarge("GRAGGAR's strength knows no bounds, and neither shall mine!"))

/mob/living/carbon/human/proc/swap_in_engorged_heart()
	var/obj/item/organ/heart/old_heart = getorganslot(ORGAN_SLOT_HEART)
	if(istype(old_heart, /obj/item/organ/heart/engorged))
		return old_heart
	if(old_heart)
		old_heart.Remove(src, special = TRUE)
		qdel(old_heart)
	var/obj/item/organ/heart/engorged/new_heart = new
	new_heart.Insert(src, special = TRUE)
	return new_heart

/datum/antagonist/assassin/on_gain()
	. = ..()
	var/mob/living/carbon/human/H = owner.current
	if(!istype(H))
		return
	var/obj/item/organ/heart/engorged/heart = H.swap_in_engorged_heart()
	heart.assassin_heart = TRUE

/obj/item/rogueweapon/huntingknife/idagger/steel/profane/init_profane_soul(mob/living/carbon/human/target, mob/user, mob/soul)
	. = ..()
	SEND_SIGNAL(target, COMSIG_HERETIC_PECULATED, user)
