/datum/intent/axe/cut
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')

/datum/intent/axe/chop
	hitsound = list('modular_tidi/sound_changes/sounds/wpn_impact_blunt2hand_flesh_01.ogg', 'modular_tidi/sound_changes/sounds/wpn_impact_blunt2hand_flesh_02.ogg', 'modular_tidi/sound_changes/sounds/wpn_impact_blunt2hand_flesh_03.ogg')

/datum/voicepack/getmold(soundin)
	var/used
	if(istext(soundin))
		switch(soundin)
			if("laugh")

				used = pick('modular_tidi/sound_changes/sounds/harris_laugh_01.ogg', 'modular_tidi/sound_changes/sounds/harris_laugh_02.ogg', 'modular_tidi/sound_changes/sounds/harris_laugh_03.ogg', 'modular_tidi/sound_changes/sounds/harris_laugh_04.ogg', 'modular_tidi/sound_changes/sounds/harris_laugh_05.ogg', 'modular_tidi/sound_changes/sounds/harris_laugh_07.ogg', 'modular_tidi/sound_changes/sounds/harris_laugh_08.ogg', 'modular_tidi/sound_changes/sounds/harris_laugh_10.ogg', 'modular_tidi/sound_changes/sounds/harris_laugh_11.ogg', 'modular_tidi/sound_changes/sounds/harris_laugh_12.ogg', 'modular_tidi/sound_changes/sounds/harris_laugh_14.ogg')
			if("scream")
				used = 'sound/vo/male/old/scream.ogg'
			if("pain")
				used = pick('sound/vo/male/old/pain (1).ogg','sound/vo/male/old/pain (2).ogg','sound/vo/male/old/pain (3).ogg')
			if("painscream")
				used = pick('sound/vo/male/old/pain (1).ogg','sound/vo/male/old/pain (2).ogg','sound/vo/male/old/pain (3).ogg')
		return used
