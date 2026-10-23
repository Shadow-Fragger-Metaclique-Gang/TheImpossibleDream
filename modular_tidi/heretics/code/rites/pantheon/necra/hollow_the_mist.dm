/datum/runeritual/god/necra/hollow_the_mist
	name = "Hollow the Mist"
	desc = "Manifests a cross construction kit upon the rune while the fog is coming."
	tier = SKILL_LEVEL_EXPERT
	cooldown = 30 MINUTES

/datum/runeritual/god/necra/hollow_the_mist/lock_reason(mob/living/user, obj/structure/ritualcircle/circle)
	. = ..()
	if(.)
		return
	if(!SSevent_scheduler.fog_scheduled)
		return "This rite can only be performed when the fog is coming."

/datum/runeritual/god/necra/hollow_the_mist/perform(mob/living/user, obj/structure/ritualcircle/necra/circle)
	circle.loc.visible_message(span_warning("[user] begins to chant in a low, vibrating hum, their voice sounding like grinding bone..."))
	playsound(user, 'sound/vo/mobs/ghost/whisper (3).ogg', 100, FALSE)
	if(do_after(user, 100))
		circle.loc.visible_message(span_notice("The chalk lines of the rune begin to seep into the floor, turning a pale, ghostly white."))
		var/obj/item/cross_construction_kit/K = new /obj/item/cross_construction_kit(circle.loc)
		circle.loc.visible_message(span_boldnotice("A heavy [K.name] manifests in the center of the rune!"))
		circle.icon_state = "necra_active"
		. = TRUE
		addtimer(VARSET_CALLBACK(circle, icon_state, "necra_chalky"), 12 SECONDS)
