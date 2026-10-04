/mob/living/carbon/human/Initialize(mapload)
#ifdef MATURESERVER
	sexcon = new /datum/sex_controller(src)
#endif
	return ..()

/mob/living/carbon/human/Destroy()
	QDEL_NULL(sexcon)
	return ..()

/mob/living/carbon/human/is_fertile(orifice = SEX_PART_CUNT)
	if(orifice & SEX_PART_TAIL_MAW)
		var/obj/item/organ/tail/manticore/tail = get_manticore_tail(src)
		return tail?.fertility
	var/obj/item/organ/vagina/vagina = getorganslot(ORGAN_SLOT_VAGINA)
	return vagina?.fertility

/mob/living/carbon/human/proc/modular_strippanel_chastity_rows()
	var/chastity_row = modular_strippanel_chastity_row()
	if(!chastity_row)
		return list()
	return list("<tr><td><hr></td></tr>", chastity_row)
