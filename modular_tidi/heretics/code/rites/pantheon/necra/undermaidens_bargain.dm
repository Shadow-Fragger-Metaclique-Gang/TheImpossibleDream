/datum/runeritual/god/necra/undermaidens_bargain
	name = "Undermaiden's Bargain"
	desc = "Strikes a bargain with Necra for the souls of everyone within seven paces of the rune."
	tier = SKILL_LEVEL_EXPERT
	cooldown = 30 MINUTES

/datum/runeritual/god/necra/undermaidens_bargain/perform(mob/living/user, obj/structure/ritualcircle/necra/circle)
	circle.loc.visible_message(span_warning("[user] sways before the rune, they open their mouth, though no words come out..."))
	playsound(user, 'sound/vo/mobs/ghost/whisper (3).ogg', 100, FALSE, -1)
	if(!do_after(user, 6 SECONDS))
		return FALSE
	circle.loc.visible_message(span_warning("[user] silently weeps, yet their tears do not flow..."))
	playsound(user, 'sound/vo/mobs/ghost/whisper (1).ogg', 100, FALSE, -1)
	if(!do_after(user, 6 SECONDS))
		return FALSE
	circle.loc.visible_message(span_warning("[user] locks up, as though someone had just grabbed them..."))
	to_chat(user,span_danger("<i>You feel cold breath on the back of your neck...</i>"))
	playsound(user, 'sound/vo/mobs/ghost/death.ogg', 100, FALSE, -1)
	if(!do_after(user, 2 SECONDS))
		return FALSE
	circle.icon_state = "necra_active"
	user.say("Forgive me, the bargain is intoned!!")
	to_chat(user,span_cultsmall("<i>My devotion to the Undermaiden has allowed me to strike a bargain for these souls....</i>"))
	playsound(circle.loc, 'sound/vo/mobs/ghost/moan (1).ogg', 100, FALSE, -1)
	circle.undermaidenbargain(circle)
	addtimer(VARSET_CALLBACK(circle, icon_state, "necra_chalky"), 12 SECONDS)
	return TRUE
