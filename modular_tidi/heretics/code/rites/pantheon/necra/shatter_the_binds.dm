/datum/runeritual/god/necra/shatter_the_binds
	name = "Shatter the Binds"
	desc = "Breaks a dead assassin's profane dagger laid on the rune, freeing the souls trapped within."

/datum/runeritual/god/necra/shatter_the_binds/perform(mob/living/user, obj/structure/ritualcircle/necra/circle)
	to_chat(user, span_info("<i>This rite allows for the breaking of a soul-trapping assassin's dagger. Doing so will allow the spirits \
	to return to Necra or their corpses, potentially allowing for revival. Place the dagger upon the \
	rune and chant the verse.\nBe patient, as this will take time. The assassin must be dead for this rite.</i>"))
	var/turf/runeturf = get_turf(circle)
	var/obj/item/rogueweapon/huntingknife/idagger/steel/profane/pissdagger

	for(var/obj/item/rogueweapon/huntingknife/idagger/steel/profane/P in runeturf.contents)
		pissdagger = P
		break // ladies. ladies. one at a time...

	if(!pissdagger)
		to_chat(user, span_warning("<i>This ritual requires an assassin's profane dagger to be placed upon the rune.</i>"))
		return FALSE

	if(!pissdagger.is_my_owner_dead())
		to_chat(user, span_warning("<i>I hear a laughing surrounding me. The assassin is not yet dead... their foul magicks still protect this dagger!</i>"))
		return FALSE

	user.visible_message(span_warning("[user] places the dagger in the center of the rune, drawing spectral strands of Lux up through the air!"))
	playsound(user, 'sound/vo/mobs/ghost/whisper (3).ogg', 100, FALSE, -1)
	if(do_after(user, 10 SECONDS))
		playsound(user, 'sound/vo/mobs/ghost/whisper (1).ogg', 100, FALSE, -1)
		pissdagger.visible_message(span_warning("[pissdagger] is suddenly thrust up into the air! Nigh-invisible threads tear at it, beginning to bend the metal!"))
		if(do_after(user, 10 SECONDS))
			playsound(user, 'sound/magic/soulsteal_2.ogg', 80, TRUE)
			pissdagger.say(span_cult("NECRA DELIVER US!!"))
			if(do_after(user, 5 SECONDS))
				pissdagger.visible_message(span_warning("[pissdagger] is CRUSHED and TWISTED! TERRIBLE SCREAMS sounds from within!"))
				playsound(user, 'sound/vo/mobs/ghost/death.ogg', 100, FALSE, -1)
				pissdagger.say(span_cult("MASTER, I DON'T WANT TO GO!!"))
				if(do_after(user, 5 SECONDS))
					user.say("UNDERMAIDEN, SHAKE FREE THE SOULS OF THE DAMNED!") // change this to something better thanks
					playsound(user, 'sound/misc/carriage2.ogg', 80, TRUE)
					pissdagger.release_profane_souls(user)
					pissdagger.shatter_dagger()
					. = TRUE
