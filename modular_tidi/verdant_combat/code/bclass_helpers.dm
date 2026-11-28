/proc/bclass_to_armor_type(bclass)
	switch(bclass)
		if(BCLASS_BURN)
			return "fire"
		if(BCLASS_ACID)
			return "acid"
		if(BCLASS_FROST)
			return "frost"
		if(BCLASS_ELECTRICAL)
			return "electrical"
		if(BCLASS_CHOP, BCLASS_CUT)
			return "slash"
		if(BCLASS_STAB, BCLASS_PICK, BCLASS_PIERCE)
			return "stab"
		if(BCLASS_BLUNT, BCLASS_SMASH, BCLASS_PUNCH, BCLASS_TWIST, BCLASS_BITE)
			return "blunt"
		else
			return "blunt"
