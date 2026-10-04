/obj/item/roguekey/var/hardmode_indestructible = FALSE

/obj/item/roguekey/lord/attack(mob/M, mob/user, def_zone) // lord's key opens any chastity device without checks and never breaks, because the lord is merciful like that. Petition the duke to have your cage unlocked unlucky squire! 
	var/handled = chastity_attack(M, user, def_zone)
	if(!isnull(handled))
		return handled
	return ..()

/obj/item/lockpick/attack(mob/M, mob/user, def_zone) // handles lockpicking code for chastity devices. Yes, this is intentionally separate from the roguekey/chastity attack proc, because it has a chance to fail and break the pick, and lord's key can bypass the checks and never break.
	var/handled = chastity_attack(M, user, def_zone)
	if(!isnull(handled))
		return handled
	return ..()

// Spectral lockpick from the Lesser Knock spell: attempt chastity picking first.
// If the target has no chastity device (or isn't human), fall through to ..() which triggers the
// touch_attack dispel logic — so the spell still cancels correctly on non-device targets.
/obj/item/melee/touch_attack/lesserknock/attack(mob/M, mob/user, def_zone)
	var/handled = chastity_attack(M, user, def_zone)
	if(!isnull(handled))
		return handled
	return ..()
