/datum/intent/grab/horns
	name = "crack horn"
	desc = ""
	icon_state = "incrack" // reuse the crack intent icon

/datum/stressevent/hornloss
	timer = 50 MINUTES
	stressadd = 5
	desc = span_boldred("My horns were taken from me!")

/datum/stressevent/hornloss_but_happy
	timer = 30 MINUTES
	stressadd = -3
	desc = span_boldred("I'm permanently broken...")

/obj/item/grabbing/proc/horn_break_sfx(mob/living/user, mob/living/target)
	var/list/soundfiles = list(\
	'modular_tidi/sexcon/sounds/horn_break/break (1).ogg', \
	'modular_tidi/sexcon/sounds/horn_break/break (2).ogg', \
	'modular_tidi/sexcon/sounds/horn_break/break (3).ogg', \
	'modular_tidi/sexcon/sounds/horn_break/break (4).ogg', \
	'modular_tidi/sexcon/sounds/horn_break/break (5).ogg', \
	'modular_tidi/sexcon/sounds/horn_break/break (6).ogg', \
	'modular_tidi/sexcon/sounds/horn_break/break (7).ogg')
	var/soundfiles_max = length(soundfiles) + 1
	var/target_masochist = target.has_flaw(/datum/charflaw/addiction/masochist)
	var/hurting_thyself = user == target
	for(var/i in 1 to soundfiles_max)
		if(i < soundfiles_max) // in the case two mobs target the same horned mob, double check that we're within array range
			playsound(target.loc, soundfiles[i], 50, TRUE)
		sleep(1.5 SECONDS)
		if(!user.doing || i >= soundfiles_max)
			break
		switch(i)
			if(2)
				to_chat(target, target_masochist ? span_userdanger("Yes yes yes!") : hurting_thyself ? span_userdanger("What am I doing!?") : span_userdanger("No no no!"))
			if(5)
				to_chat(target, target_masochist ? span_userdanger("More!!") : hurting_thyself ? span_userdanger("Stop it, they'll snap!") : span_userdanger("My horn are bending, make it stop!"))

/obj/item/grabbing/proc/horn_break_react(mob/living/target)
	sleep(0.6 SECONDS)
	if(target.has_flaw(/datum/charflaw/addiction/masochist))
		if(target?.client?.prefs?.sexable && (target?.sexcon?.arousal > AROUSAL_HARD_ON_THRESHOLD) && target?.sexcon?.can_ejaculate()) // force climax if aroused
			target?.sexcon?.ejaculate()
		else
			target.emote("sexmoanhvy", forced = TRUE)
	else
		target.emote(prob(50) ? "painscream" : "scream", forced = TRUE)
		target.Knockdown(1 SECONDS)
