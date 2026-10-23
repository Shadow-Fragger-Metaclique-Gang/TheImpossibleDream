/datum/runeritual/god/xylix/stagehands_silence
	name = "Stagehand's Silence"
	desc = "Quickens, quiets and hides everyone within a pace of the rune for a time."
	tier = SKILL_LEVEL_EXPERT
	cooldown = 30 MINUTES

/datum/runeritual/god/xylix/stagehands_silence/perform(mob/living/user, obj/structure/ritualcircle/xylix/circle)
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("I CALL UPON THE MANY-FACED TRAGEDIAN!!") // sm1 redo this thx - Unknown | The monkey paw curls - CODEATHON
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("PLAY YOUR HARP- LET EACH STRING DEAFEN MY FOES!!") // seriously im working w/ ZERO lore.
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("--ON WITH THE SHOW!!") // i miss skipper
	to_chat(user,span_cultsmall("<i>Every play needs its stagehands. Xylix will quicken the slow, speed your sneaking, and quiet your footsteps... for a time.</i>"))
	playsound(circle.loc, 'sound/magic/mockery.ogg', 60, FALSE, -1)
	circle.stagehands_silence(circle)
	return TRUE
