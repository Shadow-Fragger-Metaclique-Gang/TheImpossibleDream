/datum/objective/heretic/zizo/monolith
	name = "Unholy Construction"
	heretic_tier = 4
	heretic_branch = HERETIC_PATH_AMBITION
	rite_offering = /obj/item/organ/heart

/datum/objective/heretic/zizo/monolith/update_explanation_text()
	explanation_text = "Construct a monolith of flesh, make someone gaze upon it, and then sacrifice their heart using the Rite of Ascension."

/datum/objective/heretic/zizo/monolith/on_creation()
	. = ..()
	owner?.teach_crafting_recipe(/datum/crafting_recipe/roguetown/structure/flesh_monolith)
	if(owner && !owner.has_spell(/datum/action/cooldown/spell/lacrima/heart, TRUE))
		owner.AddSpell(new /datum/action/cooldown/spell/lacrima/heart)
	update_explanation_text()

/datum/objective/heretic/zizo/monolith/Destroy()
	owner?.RemoveSpell(/datum/action/cooldown/spell/lacrima/heart)
	return ..()

/datum/objective/heretic/zizo/monolith/check_offering(mob/living/user, atom/movable/offering)
	var/obj/item/organ/heart/heart = offering
	if(heart.monolith_maker?.resolve() != user)
		return "This heart never gazed upon my monolith."

/datum/objective/heretic/zizo/monolith/take_offering(mob/living/user, atom/movable/offering, turf/loc)
	var/obj/item/organ/heart/heart = offering
	record_victim(heart.monolith_gazer?.resolve())
	var/obj/structure/ritualcircle/circle = locate() in loc
	circle.icon_state = "zizo_active"
	addtimer(VARSET_CALLBACK(circle, icon_state, "zizo_chalky"), 12 SECONDS)
	loc.visible_message(span_cult("[offering] blackens and caves in upon the rune, as if something on the other side had taken a bite."))
