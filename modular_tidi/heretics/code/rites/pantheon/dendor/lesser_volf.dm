/datum/runeritual/god/dendor/lesser_volf
	name = "Rite of the Lesser Volf"
	desc = "The ritualist, standing upon the rune, takes on the aspect of the lesser volf."
	tier = SKILL_LEVEL_EXPERT
	cooldown = 30 MINUTES

/datum/runeritual/god/dendor/lesser_volf/perform(mob/living/user, obj/structure/ritualcircle/dendor/circle)
	var/mob/living/target = null
	var/turf/T = get_turf(circle)
	for(var/mob/living/person in T.contents)
		if(!ishuman(person))
			continue
		if(user != person)
			continue
		target = person
	if(!target)
		to_chat(user, span_warning("<i>I need to be standing on the rune for this to work.</i>"))
		return FALSE
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("RRRGH GRRRHHHG GRRRHH!!")
	playsound(circle.loc, 'sound/vo/mobs/vw/idle (1).ogg', 100, FALSE, -1)
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("GRRRR GRRRRHHHH!!")
	playsound(circle.loc, 'sound/vo/mobs/vw/idle (4).ogg', 100, FALSE, -1)
	if(!do_after(user, 5 SECONDS))
		return FALSE
	circle.loc.visible_message(span_warning("[user] snaps and snarls at the rune. Drool runs down their lip..."))
	playsound(circle.loc, 'sound/vo/mobs/vw/bark (1).ogg', 100, FALSE, -1)
	if(!do_after(user, 3 SECONDS))
		return FALSE
	circle.loc.visible_message(span_warning("[user] snaps their head upward, they let out a howl!"))
	playsound(circle.loc, 'sound/vo/mobs/wwolf/howl (2).ogg', 100, FALSE, -1)
	circle.lesservolf(target) // starts proc
	return TRUE
