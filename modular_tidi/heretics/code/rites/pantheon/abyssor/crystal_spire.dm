/datum/runeritual/god/abyssor/crystal_spire
	name = "Rite of the Crystal Spire"
	desc = "Forms an abyssal marker, which opens a crystal spire and its dreamfiends wherever it is set."
	tier = SKILL_LEVEL_EXPERT
	cooldown = 30 MINUTES

/datum/runeritual/god/abyssor/crystal_spire/lock_reason(mob/living/user, obj/structure/ritualcircle/circle)
	. = ..()
	if(.)
		return
	// Abyssorites get access to stirring rites
	if(user.patron?.type != /datum/patron/divine/abyssor)
		return "Only an Abyssorite may perform this rite."
	// Time check for Rite of the Crystal Spire
	var/time_elapsed = STATION_TIME_PASSED() / (1 MINUTES)
	if(time_elapsed < 30)
		var/time_left = 30 - time_elapsed
		return "The veil is too thin to summon crystal spires. Wait another [round(time_left, 0.1)] minutes."

/datum/runeritual/god/abyssor/crystal_spire/perform(mob/living/user, obj/structure/ritualcircle/abyssor_alt_inactive/circle)
	if(do_after(user, 50))
		user.say("Deep Father, hear my call!")
		if(do_after(user, 50))
			user.say("From the Abyss, split the earth!")
			if(do_after(user, 50))
				circle.icon_state = "abyssoralt_active"
				user.say("Let your tempest chase away the craven ones!")
				to_chat(user, span_cultsmall("<i>A crystalline shard forms at the center of the rune, humming with Abyssor's power.</i>"))
				new /obj/item/abyssal_marker(circle.loc)
				. = TRUE
				addtimer(VARSET_CALLBACK(circle, icon_state, "abyssoralt_chalky"), 24 SECONDS)
