/*
	Okay this is actually super shitty.
	There are two kinds of ressurection spells, and there doesn't seem to actually be reason for either of them to actually
	exist as seperate entities, yet they persist...

	The actual rez spells seem to be all over the place, as well.
	Ressurections pertaining to the ten seem to MOSTLY exist under
	../code/modules/spells/roguetown/acolyte/resurrect.dm

	But the ascendants get theirs under
	../code/datums/gods/patrons/inhumen/resurrect_inhumen.dm
	For some reason resurrect_inhumen.dm is also chock full with a bunch of non-resurrection spells, too...

*/

// For 'generic' revivals
// Only really check this with inhumen gods if they have some kind of 'tithe' mechanic.
/obj/effect/proc_holder/spell/invoked/resurrect/proc/check_target_saintliness(mob/living/target)
	// Let's keep this binary for now, not really interested in adding anything for neutrally-saintlified targets for now..
	var/component_type = target.patron.worship_component_type
	if(!component_type)
		return FALSE // They're weird and fucked up idk.

	var/datum/component/saintliness/S = target.GetComponent(target.patron.worship_component_type)

	if(S.saintliness < 30)
		return FALSE
	else
		return TRUE

// Astrata and Matthios both use 'anastasis' instead of resurrect for SOME reason.
/datum/action/cooldown/spell/miracle/anastasis/proc/check_target_saintliness(mob/living/target)
	// Let's keep this binary for now, not really interested in adding anything for neutrally-saintlified targets for now..
	var/component_type = target.patron.worship_component_type
	if(!component_type)
		return FALSE // They're weird and fucked up idk.

	var/datum/component/saintliness/S = target.GetComponent(target.patron.worship_component_type)

	if(S.saintliness < 30)
		return FALSE
	else
		return TRUE

// For 'inhumen' revivals
