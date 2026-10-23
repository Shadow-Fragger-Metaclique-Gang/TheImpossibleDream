// Sacred Ascendance only offers miracles of the Pentacle's gods (Astrata, Noc, Ravox, Eora, Necra, plus the Undivided battlecry).
/datum/action/cooldown/spell/miracle/bishop_pack/New(Target)
	miracle_bishop_t4 -= list(
		/obj/effect/proc_holder/spell/invoked/abyssal_infusion::name,
		/obj/effect/proc_holder/spell/self/howl/call_of_the_moon::name,
		/datum/action/cooldown/spell/malum/fortress::name,
		/obj/effect/proc_holder/spell/invoked/abscond::name,
	)
	miracle_bishop_t3 -= list(
		/obj/effect/proc_holder/spell/invoked/call_dreamfiend::name,
		/datum/action/cooldown/spell/malum_blessing::name,
		/obj/effect/proc_holder/spell/targeted/touch/parlor_trick::name,
	)
	return ..()
