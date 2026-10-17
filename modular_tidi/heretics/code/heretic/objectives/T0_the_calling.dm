/datum/objective/heretic/calling
	name = "The Calling"
	heretic_tier = 0
	rite_offering = /obj/item/rogueweapon/huntingknife

/datum/objective/heretic/calling/update_explanation_text()
	explanation_text = "Offer a knife using the Rite of Ascension on a ritual circle to begin the journey down your path."

/datum/objective/heretic/calling/on_creation()
	. = ..()
	update_explanation_text()

/datum/objective/heretic/calling/check_offering(mob/living/user, atom/movable/offering)
	if(istype(offering, /obj/item/rogueweapon/huntingknife/idagger/steel/profane))
		return "The souls bound within [offering] refuse to be remade."

/datum/objective/heretic/calling/take_offering(mob/living/user, atom/movable/offering, turf/loc)
	var/knife_type
	switch(owner.heretic_path.patron_type)
		if(/datum/patron/inhumen/zizo)
			knife_type = /obj/item/rogueweapon/huntingknife/idagger/steel/zizo
		if(/datum/patron/inhumen/graggar)
			knife_type = /obj/item/rogueweapon/huntingknife/combat/graggar
		if(/datum/patron/inhumen/matthios)
			knife_type = /obj/item/rogueweapon/huntingknife/idagger/steel/matthios
		if(/datum/patron/inhumen/baotha)
			knife_type = /obj/item/rogueweapon/huntingknife/idagger/steel/baotha
	var/obj/item/new_knife = new knife_type(loc)
	loc.visible_message(span_cult("[offering] warps and twists upon the rune, reforged as [new_knife]!"))
	playsound(loc, 'sound/combat/hits/onmetal/grille (2).ogg', 50)
