/datum/preferences/copy_to(mob/living/carbon/human/character, icon_updates = 1, roundstart_checks = TRUE, character_setup = FALSE, antagonist = FALSE)
	. = ..()
	if(character.sexcon && free_use_default)
		character.sexcon.freeuse = TRUE
	if(character_setup)
		var/obj/item/organ/penis/preview_penis = character.getorganslot(ORGAN_SLOT_PENIS)
		if(preview_penis)
			var/preview_massive = wants_the_big_one() && preview_penis.penis_size == MAX_PENIS_SIZE
			if(preview_penis.massive != preview_massive)
				preview_penis.massive = preview_massive
				character.update_body_parts(TRUE)
