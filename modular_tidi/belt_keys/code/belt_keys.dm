/obj/structure/mineral_door/attack_right(mob/user)
	user.changeNext_move(CLICK_CD_FAST)

	// Special handling for deadbolt and shutter doors - preserve their custom behavior
	if(istype(src, /obj/structure/mineral_door/wood/deadbolt) || istype(src, /obj/structure/mineral_door/wood/deadbolt/shutter))
		return ..()

	// Check if user has a key in hand or belt slots
	var/obj/item/key_item = find_key_for_door(user)
	if(key_item)
		trykeylock(key_item, user)
		return

	// If no key found, fall back to parent behavior
	return ..()

// Helper proc to find a matching key or keyring in hand or belt slots
/obj/structure/mineral_door/proc/find_key_for_door(mob/user)
	if(!user || !keylock)
		return null

	// Check hand first
	var/obj/item/W = user.get_active_held_item()
	if(W && (istype(W, /obj/item/roguekey) || istype(W, /obj/item/storage/keyring)))
		if(istype(W, /obj/item/roguekey))
			var/obj/item/roguekey/K = W
			if(K.lockhash == lockhash || istype(K, /obj/item/roguekey/lord) || istype(K, /obj/item/roguekey/skeleton))
				return W
		if(istype(W, /obj/item/storage/keyring))
			if(keyring_has_matching_key(W))
				return W

	// Check belt slots if human
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/list/belt_slots = list(
			H.get_item_by_slot(SLOT_BELT),
			H.get_item_by_slot(SLOT_BELT_L),
			H.get_item_by_slot(SLOT_BELT_R)
		)

		for(var/obj/item/I in belt_slots)
			if(!I) continue

			// Check if the belt item itself is a key or keyring
			if(istype(I, /obj/item/roguekey))
				var/obj/item/roguekey/K = I
				if(K.lockhash == lockhash || istype(K, /obj/item/roguekey/lord) || istype(K, /obj/item/roguekey/skeleton))
					return I
			if(istype(I, /obj/item/storage/keyring))
				if(keyring_has_matching_key(I))
					return I

			// Check inside the belt item if it has contents (storage belts, etc.)
			if(LAZYLEN(I.contents))
				for(var/obj/item/contained_item in I.contents)
					if(istype(contained_item, /obj/item/roguekey))
						var/obj/item/roguekey/K = contained_item
						if(K.lockhash == lockhash || istype(K, /obj/item/roguekey/lord) || istype(K, /obj/item/roguekey/skeleton))
							return I // Return the belt item that contains the key
					if(istype(contained_item, /obj/item/storage/keyring))
						if(keyring_has_matching_key(contained_item))
							return I // Return the belt item that contains the keyring

	return null

// Helper proc to check if a keyring contains a matching key
/obj/structure/mineral_door/proc/keyring_has_matching_key(obj/item/storage/keyring/keyring)
	if(!keyring || !istype(keyring, /obj/item/storage/keyring))
		return FALSE

	for(var/obj/item/I in keyring.contents)
		if(istype(I, /obj/item/roguekey))
			var/obj/item/roguekey/K = I
			if(K.lockhash == lockhash)
				return TRUE
		if(istype(I, /obj/item/storage/keyring))
			if(keyring_has_matching_key(I))
				return TRUE

	return FALSE

/obj/structure/mineral_door/trykeylock(obj/item/I, mob/user, autobump = FALSE)
	// Handle belt items that contain keys
	if(LAZYLEN(I.contents) && !istype(I, /obj/item/storage/keyring))
		var/obj/item/found_key = null
		for(var/obj/item/contained_item in I.contents)
			if(istype(contained_item, /obj/item/roguekey))
				var/obj/item/roguekey/K = contained_item
				if(K.lockhash == lockhash || istype(K, /obj/item/roguekey/lord) || istype(K, /obj/item/roguekey/skeleton))
					found_key = contained_item
					break
			if(istype(contained_item, /obj/item/storage/keyring))
				if(keyring_has_matching_key(contained_item))
					found_key = contained_item
					break

		if(found_key)
			// Use the found key instead of the belt
			trykeylock(found_key, user, autobump)
			return
		else
			to_chat(user, span_warning("No matching key found in [I]."))
			door_rattle()
			return
	return ..()

/obj/structure/mineral_door/wood/donjon/stone/attack_right(mob/user)
	// Check for keys first (inherited from parent)
	var/obj/item/key_item = find_key_for_door(user)
	if(key_item)
		trykeylock(key_item, user)
		return

	// If no key, fall back to parent behavior
	if(user.get_active_held_item())
		return ..()

/obj/structure/mineral_door/wood/donjon/stone/MiddleClick(mob/user, params)
	if(user.get_active_held_item())
		return ..()
	if(door_opened || isSwitchingStates)
		return
	if(brokenstate)
		to_chat(user, span_warning("There isn't much left of this door."))
		return
	if(get_dir(src,user) == viewportdir)
		view_toggle(user)
	else
		to_chat(user, span_warning("The viewport doesn't toggle from this side."))
		return

/obj/structure/mineral_door/wood/donjon/MiddleClick(mob/user, params)
	if(user.get_active_held_item())
		return ..()

	if(door_opened || isSwitchingStates)
		return
	if(brokenstate)
		to_chat(user, span_warning("There isn't much left of this door."))
		return
	if(get_dir(src,user) == viewportdir)
		view_toggle(user)
	else
		to_chat(user, span_warning("The viewport doesn't toggle from this side."))
		return
