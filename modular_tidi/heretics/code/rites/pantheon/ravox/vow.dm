/datum/runeritual/god/ravox/vow
	name = "Vow to Ravox"
	desc = "The ritualist swears a vow to Ravox, empowering them in righteous combat."
	tier = SKILL_LEVEL_EXPERT
	cooldown = 30 MINUTES

/datum/runeritual/god/ravox/vow/perform(mob/living/user, obj/structure/ritualcircle/ravox/circle)
	var/target = user
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("My steel is sharp, my heart is true!")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("For the weak, my blade I drew!")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("Let foes of justice face my might!")
	if(!do_after(user, 3 SECONDS))
		return FALSE
	user.say("Ravox, guide my hand in righteous fight!")
	playsound(circle.loc, 'sound/magic/holyshield.ogg', 80, FALSE, -1)
	circle.ravoxvow(target)
	return TRUE
