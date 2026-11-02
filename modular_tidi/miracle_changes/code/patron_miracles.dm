/datum/patron/divine/abyssor/New()
	..()
	miracles -= /datum/action/cooldown/spell/miracle/heal
	miracles -= /obj/effect/proc_holder/spell/invoked/abyssheal
	paint_miracles -= /datum/action/cooldown/spell/miracle/heal

/datum/patron/divine/dendor/New()
	..()
	miracles -= /datum/action/cooldown/spell/miracle/heal

/datum/patron/divine/xylix/New()
	..()
	miracles -= /datum/action/cooldown/spell/miracle/heal
	miracles -= /obj/effect/proc_holder/spell/invoked/resurrect/xylix

/datum/patron/divine/malum/New()
	..()
	miracles -= /datum/action/cooldown/spell/miracle/heal
	miracles -= /obj/effect/proc_holder/spell/invoked/resurrect/malum
