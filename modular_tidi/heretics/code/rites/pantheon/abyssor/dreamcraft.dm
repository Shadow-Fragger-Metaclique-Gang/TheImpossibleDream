/datum/runeritual/god/abyssor/dreamcraft
	name = "Rite of Dreamcraft"
	desc = "Clads the dreamwalker in dream armor and forges them a dream weapon of their choosing."
	tier = SKILL_LEVEL_EXPERT
	cooldown = 30 MINUTES

/datum/runeritual/god/abyssor/dreamcraft/lock_reason(mob/living/user, obj/structure/ritualcircle/circle)
	. = ..()
	if(.)
		return
	if(!HAS_TRAIT(user, TRAIT_DREAMWALKER))
		return "Only a dreamwalker may perform this rite."

/datum/runeritual/god/abyssor/dreamcraft/perform(mob/living/user, obj/structure/ritualcircle/abyssor_alt_inactive/circle)
	if(!HAS_TRAIT(user, TRAIT_DREAMWALKER))
		return FALSE

	var/list/weapon_options = list(
		"Dreamreaver Greataxe" = image(icon = 'icons/roguetown/weapons/axes64.dmi', icon_state = "dreamaxe"),
		"Harmonious Spear" = image(icon = 'icons/roguetown/weapons/polearms64.dmi', icon_state = "dreamspear"),
		"Oozing Sword" = image(icon = 'icons/roguetown/weapons/swords64.dmi', icon_state = "dreamsword"),
		"Thunderous Trident" = image(icon = 'icons/roguetown/weapons/polearms64.dmi', icon_state = "dreamtri")
	)

	var/choice = show_radial_menu(user, circle, weapon_options, require_near = TRUE, tooltips = TRUE)
	if(!choice)
		return FALSE
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("DREAM! DREAM! MANIFEST MY VISION!!")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("DREAM! DREAM! BEND TO MY WILL!!")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("DREAM! DREAM! FORGE MY WEAPON!!")
	if(!do_after(user, 5 SECONDS))
		return FALSE

	circle.icon_state = "abyssoralt_active"
	circle.dreamarmor(user)
	circle.dreamcraft_weapon(user, choice)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.mind)
			H.mind.special_role = "dreamwalker"
	addtimer(VARSET_CALLBACK(circle, icon_state, "abyssoralt_chalky"), 24 SECONDS)
	return TRUE
