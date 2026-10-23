/obj/structure/roguemachine/talkstatue/mercenary
	desc = "A gilbranze warrior erupts from the stone bell that homes them; foreign garb, horns of stone, claws of deathly metals. The perfect central-point of a proud warrior extrinsic to this place and tyme. The base bears a discreet silver slot, said to make the stone more forthcoming."
	var/static/public_wretch_roster_until = 0

/obj/structure/roguemachine/talkstatue/mercenary/proc/expire_public_wretch_roster()
	if(world.time < public_wretch_roster_until)
		return
	public_wretch_roster_until = 0
	SStgui.update_uis(src)

/obj/structure/roguemachine/talkstatue/mercenary/proc/wretch_roster_ui_data(list/data, is_wretch, is_bathhouse)
	var/public_access = world.time < public_wretch_roster_until
	data["public_wretch_access"] = public_access
	return public_access

/obj/structure/roguemachine/talkstatue/mercenary/proc/resolve_wretch_key(target_key)
	if(!target_key || wretch_status[target_key])
		return target_key
	for(var/name_key in wretch_status)
		var/list/entry = wretch_status[name_key]
		if(REF(entry["mob"]) == target_key)
			return name_key
	return target_key

/obj/structure/roguemachine/talkstatue/mercenary/proc/reveal_wretch_roster(mob/living/carbon/human/H, obj/item/roguecoin/silver/coin)
	if(world.time < public_wretch_roster_until)
		to_chat(H, span_notice("The statue is already speaking freely of the Wretches."))
		return TRUE
	if(coin.quantity > 1)
		coin.set_quantity(coin.quantity - 1)
	else
		qdel(coin)
	public_wretch_roster_until = world.time + 5 MINUTES
	addtimer(CALLBACK(src, PROC_REF(expire_public_wretch_roster)), 5 MINUTES)
	playsound(src, 'sound/foley/coinphy (1).ogg', 60, TRUE)
	to_chat(H, span_notice("The stone swallows the silver, and its murmuring turns to the Wretches. The roster is revealed to all for five minutes."))
	SStgui.update_uis(src)
	return TRUE

/obj/structure/roguemachine/talkstatue/mercenary/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/roguecoin/silver) && ishuman(user))
		return reveal_wretch_roster(user, I)
	return ..()

/obj/structure/roguemachine/talkstatue/mercenary/proc/register_mercenary(mob/living/carbon/human/H)
	if(!H || QDELETED(H) || !H.mind || role_title(H) != "Mercenary")
		return FALSE
	var/datum/preferences/P = statue_prefs_of(H)
	mercenary_status[H.real_name] = list(
		"status" = "Available",
		"mob" = H,
		"message" = P?.statue_merc_message || "",
	)
	pending_registrations -= H.key
	to_chat(H, span_boldnotice("<font color='#d4af37'>The mercenary statue records my name among those ready for hire.</font>"))
	return TRUE

/obj/structure/roguemachine/talkstatue/mercenary/proc/register_wretch(mob/living/carbon/human/H, class_category)
	if(!H || QDELETED(H) || !H.mind || role_title(H) != "Wretch")
		return FALSE
	var/list/aliases
	switch(class_category)
		if(CLASS_CAT_ACCURSED)
			aliases = list("Wraith", "Spectre", "Phantom", "Ghost", "Poltergeist")
		if(CLASS_CAT_RACIAL)
			aliases = list("Wraith", "Spectre", "Phantom", "Ghost", "Poltergeist")
		if(CLASS_CAT_WARRIOR)
			aliases = list("The Destroyer", "The Murderer", "The Violent", "The Psycho", "The Butcher")
		if(CLASS_CAT_CLERIC)
			aliases = list("The Blessed", "The Pious", "The Sacred", "The Sanctified", "The Favored")
		if(CLASS_CAT_BATTLEMAGE)
			aliases = list("The Sprite", "The Fairy", "The Dryad", "The Nymph", "The Satyr")
		if(CLASS_CAT_ROGUE)
			aliases = list("The Coin", "The Painting", "The Candlestick", "The Goblet", "The Statue")
		if(CLASS_CAT_MAGE)
			aliases = list("The Grand Sorcerer", "The Archwizard", "The Magister of Magics", "The Master Caster", "The Hexmaster")
		if(CLASS_CAT_RANGER)
			aliases = list("The Owl", "The Falcon", "The Nightingale", "The Sparrow", "The Mockingbird")
		else
			aliases = list("The Destroyer", "The Murderer", "The Violent", "The Psycho", "The Butcher")
	var/auto_nom = pick(aliases)
	var/datum/preferences/P = statue_prefs_of(H)
	var/nom_de_guerre = P?.statue_wretch_nom || auto_nom
	wretch_status[H.real_name] = list(
		"status" = "Available",
		"mob" = H,
		"message" = P?.statue_wretch_message || "",
		"nom_de_guerre" = nom_de_guerre,
		"auto_nom" = auto_nom,
	)
	to_chat(H, span_boldnotice("<font color='#9c4dcc'>The mercenary statue gives me a name for the Wretch roster: <b>[nom_de_guerre]</b>.</font>"))
	return TRUE

/obj/structure/roguemachine/talkstatue/mercenary/proc/register_adventurer(mob/living/carbon/human/H)
	if(!H || QDELETED(H) || !H.mind)
		return FALSE
	var/datum/preferences/P = statue_prefs_of(H)
	if(!P?.statue_adv_optin)
		return FALSE
	adventurer_status[H.real_name] = list(
		"status" = "Available",
		"mob" = H,
		"message" = P.statue_adv_message || "",
	)
	to_chat(H, span_boldnotice("<font color='#4da6ff'>The mercenary statue records my name among the adventurers of the realm.</font>"))
	return TRUE

/obj/structure/roguemachine/talkstatue/mercenary/proc/unregister_far_traveler(mob/living/carbon/human/H)
	if(!H)
		return
	for(var/name in mercenary_status)
		var/list/entry = mercenary_status[name]
		if(entry["mob"] == H)
			mercenary_status -= name
	for(var/name in wretch_status)
		var/list/entry = wretch_status[name]
		if(entry["mob"] == H)
			wretch_status -= name

/proc/unregister_from_mercenary_statue(mob/living/carbon/human/H)
	var/obj/structure/roguemachine/talkstatue/mercenary/statue = SSroguemachine.mercenary_statue
	if(!statue && length(SSroguemachine.mercenary_statues))
		statue = SSroguemachine.mercenary_statues[1]
	statue?.unregister_far_traveler(H)

/// Called from /datum/advclass/mercenary/post_equip. Returns TRUE if the core code should go on to post the statue advertisement.
/datum/advclass/mercenary/proc/statue_post_equip(mob/living/carbon/human/H)
	var/datum/job/assigned_job
	if(H.mind)
		if(istype(H.mind.assigned_role, /datum/job))
			assigned_job = H.mind.assigned_role
		else
			assigned_job = SSjob.GetJob(H.mind.assigned_role)
	if(assigned_job?.title == "Merchant Mercenary")
		give_merchant_keyring(H)
		return FALSE
	if(assigned_job?.title != "Mercenary")
		return FALSE
	var/obj/structure/roguemachine/talkstatue/mercenary/statue = SSroguemachine.mercenary_statue
	if(!statue && length(SSroguemachine.mercenary_statues))
		statue = SSroguemachine.mercenary_statues[1]
		SSroguemachine.mercenary_statue = statue
	if(!statue)
		to_chat(H, span_warning("No mercenary statue can be found; I could not be entered on its roster."))
		return FALSE
	statue.register_mercenary(H)
	return TRUE

/datum/advclass/wretch/post_equip(mob/living/carbon/human/H)
	. = ..()
	var/obj/structure/roguemachine/talkstatue/mercenary/statue = SSroguemachine.mercenary_statue
	if(!statue && length(SSroguemachine.mercenary_statues))
		statue = SSroguemachine.mercenary_statues[1]
	if(!statue)
		to_chat(H, span_warning("No mercenary statue can be found; I could not be entered on its roster."))
		return
	statue.register_wretch(H, class_select_category)

/datum/job/roguetown/adventurer/after_spawn(mob/living/L, mob/M, latejoin = FALSE)
	. = ..()
	if(!ishuman(L))
		return
	var/obj/structure/roguemachine/talkstatue/mercenary/statue = SSroguemachine.mercenary_statue
	if(!statue && length(SSroguemachine.mercenary_statues))
		statue = SSroguemachine.mercenary_statues[1]
		SSroguemachine.mercenary_statue = statue
	statue?.register_adventurer(L)
