/datum/objective/heretic/baotha/conversion
	name = "Defiled"
	heretic_tier = 5
	needs_indulgence = FALSE

/datum/objective/heretic/baotha/conversion/update_explanation_text()
	explanation_text = "Make a member of the high nobility, a member of the inquisition, the Pontifex, or the Martyr bearing Baotha's brand climax upon my patron's rune while they are affected by drugs and emberwine. The act will convert them to the Baothan faith."

/datum/objective/heretic/baotha/conversion/on_climax(mob/living/carbon/human/climaxer)
	if(!climaxer.is_heretic_prize() || !HAS_TRAIT(climaxer, TRAIT_BAOTHA_FERTILITY_BOON) || !climaxer.has_status_effect(/datum/status_effect/debuff/emberwine))
		return
	if(!heretic_is_drugged(climaxer.reagents) || !(locate(/obj/structure/ritualcircle/baotha) in get_turf(climaxer)))
		return
	INVOKE_ASYNC(src, PROC_REF(convert), climaxer)
	record_victim(climaxer)
	complete()

/datum/objective/heretic/baotha/conversion/proc/convert(mob/living/carbon/human/convert)
	convert.set_patron(/datum/patron/inhumen/baotha)
	convert.mind?.heretic_conversion()
	to_chat(convert, span_userdanger("Baotha burns within me, purple flames setting my very essence alight! It's all too much... I am hers now."))
