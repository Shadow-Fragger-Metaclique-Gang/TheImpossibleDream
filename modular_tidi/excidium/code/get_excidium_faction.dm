/// Returns which faction's bounties a user can see.
/obj/structure/roguemachine/bounty/proc/get_excidium_faction_flags(mob/user)
	if(HAS_TRAIT(user, TRAIT_OUTLAW))
		. |= ALL_BOUNTIES
		return

	if(HAS_TRAIT(user, TRAIT_INQUISITION) || (user.mind?.assigned_role in GLOB.inquisition_positions))
		. |= INQ_BOUNTIES

	if(HAS_TRAIT(user, TRAIT_CLERGY) || (user.mind?.assigned_role in GLOB.church_positions))
		. |= CLERGY_BOUNTIES

	if((user.mind?.assigned_role in GLOB.garrison_positions) || (user.mind?.assigned_role in GLOB.retinue_positions) || (user.mind?.assigned_role in GLOB.courtier_positions))
		. |= KEEP_BOUNTIES

	. |= COMMON_BOUNTIES

/obj/structure/roguemachine/bounty/proc/excidium_employer_to_flag(employer)
	switch(employer)
		if("His Majesty's Holy Inquisition")
			. = INQ_BOUNTIES
		if("The Temple of the Five Divine Wills")
			. = CLERGY_BOUNTIES
		if("The Pharovian Justiciary")
			. = KEEP_BOUNTIES
		else
			. = COMMON_BOUNTIES
