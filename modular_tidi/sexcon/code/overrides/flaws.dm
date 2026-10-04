/datum/charflaw/var/no_random = FALSE

/datum/charflaw/addiction/lovefiend
	no_random = TRUE

/datum/charflaw/addiction/baothamarked
	no_random = TRUE

/datum/charflaw/marked_by_baotha
	name = "Marked by Baotha"
	desc = "Whether through intentionally seeking out heretical ritualists or against my will, I have been marked by Baotha. I am branded visibly on my groin and am able to be impregnated regardless of physical states that would usually prevent this. I will need to sate my new urges often to avoid stress..."
	no_random = TRUE

/datum/charflaw/marked_by_baotha/on_mob_creation(mob/user)

	var/mutable_appearance/marking_overlay = mutable_appearance('modular_tidi/sexcon/icons/baotha_marking.dmi', "marking_[user.gender == "male" ? "m" : "f"]", -BODY_LAYER)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(isdwarf(H) || isgoblinp(H) || iskobold(H) || iscritter(H))
			if(H.gender == MALE)
				marking_overlay.pixel_y -= 5
			else
				marking_overlay.pixel_y -= 3
	user.add_overlay(marking_overlay)

	// A bodyless spawn(40) sat here. DM binds the next single statement as the spawn body,
	// so the boon has always landed 4 seconds after the marking, not with it.
	addtimer(CALLBACK(src, PROC_REF(grant_fertility_boon), user), 40)

	var/obj/item/organ/vagina/vagina = user.getorganslot(ORGAN_SLOT_VAGINA)
	if(vagina && !vagina.fertility)
		vagina.fertility = TRUE
	var/obj/item/organ/tail/manticore/tail = get_manticore_tail(user)
	if(tail)
		tail.fertility = TRUE

	if(ishuman(user))
		var/mob/living/carbon/human/H = user

		// Add the adjusted Nymphomaniac addiction flaw
		if(!HAS_TRAIT(H, TRAIT_DEPRAVED))
			var/datum/charflaw/addiction/baothamarked/L = new
			H.charflaws += L
			L.on_mob_creation(H)

/datum/charflaw/marked_by_baotha/proc/grant_fertility_boon(mob/user)
	if(QDELETED(user))
		return
	ADD_TRAIT(user, TRAIT_BAOTHA_FERTILITY_BOON, TRAIT_GENERIC)
