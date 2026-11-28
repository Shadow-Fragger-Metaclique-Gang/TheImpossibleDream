// [SURREALIS-EDIT] - VRCOMBAT
// SURREALIS-EDIT - ORIGINAL
/*
#define ARMORID "armor-[blunt]-[slash]-[stab]-[piercing]-[fire]-[magic]"

/proc/getArmor(blunt = 0, slash = 0, stab = 0, piercing = 0, fire = 0, magic = 0)
	. = locate(ARMORID)
	if (!.)
		. = new /datum/armor(blunt, slash, stab, piercing, fire, magic)
*/
#define ARMORID "armor-[blunt]-[slash]-[stab]-[piercing]-[fire]-[acid]-[frost]-[electrical]-[magic]"

/proc/getArmor(blunt = 0, slash = 0, stab = 0, piercing = 0, fire = 0, acid = 0, frost = 0, electrical = 0, magic = 0)
	. = locate(ARMORID)
	if (!.)
		. = new /datum/armor(blunt, slash, stab, piercing, fire, acid, frost, electrical, magic)
// [/SURREALIS-EDIT]

/datum/armor
	datum_flags = DF_USE_TAG
	/// better defined as area pressure melee
	var/blunt
	/// better defined as line pressure melee
	var/slash
	/// better defined as point pressure melee
	var/stab
	/// basically projectiles
	var/piercing
	/// protection against burning
	var/fire
	// [SURREALIS-ADD] - VRCOMBAT
	/// protection against pools of acid
	var/acid
	/// protection against frost damage
	var/frost
	/// protection against electrical damage
	var/electrical
	// [/SURREALIS-ADD]
	/// protection against magical attacks (make this adjustable via rune enchantments or something)
	var/magic

// [SURREALIS-EDIT] - VRCOMBAT
// /datum/armor/New(blunt = 0, slash = 0, stab = 0, piercing = 0, fire = 0, magic = 0) // SURREALIS-EDIT - ORIGINAL
/datum/armor/New(blunt = 0, slash = 0, stab = 0, piercing = 0, fire = 0, acid = 0, frost = 0, electrical = 0, magic = 0)
// [/SURREALIS-EDIT]
	src.blunt = blunt
	src.slash = slash
	src.stab = stab
	src.piercing = piercing
	src.fire = fire
	// [SURREALIS-ADD] - VRCOMBAT
	src.acid = acid
	src.frost = frost
	src.electrical = electrical
	// [/SURREALIS-ADD]
	src.magic = magic
	tag = ARMORID

// [SURREALIS-EDIT] - VRCOMBAT
// SURREALIS-EDIT - ORIGINAL
/*
/datum/armor/proc/modifyRating(blunt = 0, slash = 0, stab = 0, piercing = 0, fire = 0, magic = 0)
	return getArmor(src.blunt+blunt, src.slash+slash, src.stab+stab, src.piercing+piercing,src.fire+fire, src.magic+magic)

/datum/armor/proc/modifyAllRatings(modifier = 0)
	return getArmor(blunt+modifier, slash+modifier, stab+modifier, piercing+modifier,fire+modifier, magic+modifier)
*/
/datum/armor/proc/modifyRating(blunt = 0, slash = 0, stab = 0, piercing = 0, fire = 0, acid = 0, frost = 0, electrical = 0, magic = 0)
	return getArmor(src.blunt+blunt, src.slash+slash, src.stab+stab, src.piercing+piercing, src.fire+fire, src.acid+acid, src.frost+frost, src.electrical+electrical, src.magic+magic)

/datum/armor/proc/modifyAllRatings(modifier = 0)
	return getArmor(blunt+modifier, slash+modifier, stab+modifier, piercing+modifier, fire+modifier, acid+modifier, frost+modifier, electrical+modifier, magic+modifier)
// [/SURREALIS-EDIT]

//TODO! PORT BLACKSTONE BLUNT/SLASH/STAB ARMOR DEFINES!!!!!!
/datum/armor/proc/multiplymodifyAllRatings(modifier = 0)
	// [SURREALIS-EDIT] - VRCOMBAT
	// SURREALIS-EDIT - ORIGINAL
	/*
	return getArmor(blunt*modifier, slash*modifier, stab*modifier, piercing*modifier, fire*modifier, magic*modifier)

/datum/armor/proc/setRating(blunt, slash, stab, piercing, fire, magic)
	*/
	return getArmor(blunt*modifier, slash*modifier, stab*modifier, piercing*modifier, fire*modifier, acid*modifier, frost*modifier, electrical*modifier, magic*modifier)

/datum/armor/proc/setRating(blunt, slash, stab, piercing, fire, acid, frost, electrical, magic)
	// [/SURREALIS-EDIT]
	// [SURREALIS-EDIT] - VRCOMBAT
	// SURREALIS-EDIT - ORIGINAL
	/*
	return getArmor((isnull(blunt) ? src.blunt : blunt),\
					(isnull(slash) ? src.slash : slash),\
					(isnull(stab) ? src.stab : stab),\
					(isnull(piercing) ? src.piercing : piercing),\
					(isnull(fire) ? src.fire : fire),\
					(isnull(magic) ? src.magic : magic))
	*/
	return getArmor((isnull(blunt) ? src.blunt : blunt),\
					(isnull(slash) ? src.slash : slash),\
					(isnull(stab) ? src.stab : stab),\
					(isnull(piercing) ? src.piercing : piercing),\
					(isnull(fire) ? src.fire : fire),\
					(isnull(acid) ? src.acid : acid),\
					(isnull(frost) ? src.frost : frost),\
					(isnull(electrical) ? src.electrical : electrical),\
					(isnull(magic) ? src.magic : magic))
	// [/SURREALIS-EDIT]

/datum/armor/proc/getRating(rating)
	switch(rating)
		// [SURREALIS-EDIT] - VRCOMBAT
		// if("blunt", "slash", "stab", "piercing", "fire", "magic") // SURREALIS-EDIT - ORIGINAL
		if("blunt", "slash", "stab", "piercing", "fire", "acid", "frost", "electrical", "magic")
		// [/SURREALIS-EDIT]
			return vars[rating]
	stack_trace("getRating called with unknown rating key [rating] — fix the caller")
	return 0

/datum/armor/proc/getList()
	// [SURREALIS-EDIT] - VRCOMBAT
	// SURREALIS-EDIT - ORIGINAL
	/*
	return list("blunt" = blunt, "slash" = slash, "stab" = stab, "piercing" = piercing, "fire" = fire, "magic" = magic)

/datum/armor/proc/attachArmor(datum/armor/AA)
	return getArmor(blunt+AA.blunt, slash+AA.slash, stab+AA.stab, piercing+AA.piercing, fire+AA.fire, magic+AA.magic)

/datum/armor/proc/detachArmor(datum/armor/AA)
	return getArmor(blunt-AA.blunt, slash-AA.slash, stab-AA.stab, piercing-AA.piercing, fire-AA.fire, magic-AA.magic)
	*/
	return list("blunt" = blunt, "slash" = slash, "stab" = stab, "piercing" = piercing, "fire" = fire, "acid" = acid, "frost" = frost, "electrical" = electrical, "magic" = magic)

/datum/armor/proc/attachArmor(datum/armor/AA)
	return getArmor(blunt+AA.blunt, slash+AA.slash, stab+AA.stab, piercing+AA.piercing, fire+AA.fire, acid+AA.acid, frost+AA.frost, electrical+AA.electrical, magic+AA.magic)

/datum/armor/proc/detachArmor(datum/armor/AA)
	return getArmor(blunt-AA.blunt, slash-AA.slash, stab-AA.stab, piercing-AA.piercing, fire-AA.fire, acid-AA.acid, frost-AA.frost, electrical-AA.electrical, magic-AA.magic)
	// [/SURREALIS-EDIT]

/datum/armor/vv_edit_var(var_name, var_value)
	if (var_name == NAMEOF(src, tag))
		return FALSE
	. = ..()
	tag = ARMORID // update tag in case armor values were edited

#undef ARMORID
