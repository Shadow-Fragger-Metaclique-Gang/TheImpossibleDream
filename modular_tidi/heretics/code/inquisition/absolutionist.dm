/datum/job/roguetown/absolver/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(H.mind)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/psydonpurify)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/psydondiscern)
