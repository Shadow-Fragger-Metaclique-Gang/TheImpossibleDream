/datum/crafting_recipe/roguetown/structure/flesh_monolith
	name = "flesh monolith"
	result = /obj/structure/flesh_monolith
	reqs = list(
		/obj/item/bodypart = 2,
		/obj/item/organ/eyes = 2,
	)
	verbage_simple = "construct"
	verbage = "constructs"
	craftsound = 'sound/foley/Building-01.ogg'
	skillcraft = null
	always_availible = FALSE
	subtype_reqs = TRUE

/obj/structure/flesh_monolith
	name = "? ? ? ?"
	desc = "A towering knot of sinew and organs, bowing towards me in unnatural curiosity..."
	icon = 'icons/roguetown/maniac/creations.dmi'
	icon_state = "creation1"
	density = TRUE
	anchored = TRUE
	max_integrity = 300
	var/datum/weakref/maker_ref
	var/list/gazers = list()
	var/list/unmoved = list()

/obj/structure/flesh_monolith/OnCrafted(dirin, mob/user)
	. = ..()
	maker_ref = WEAKREF(user)
	icon_state = "creation[rand(1, 4)]"
	playsound(src, 'sound/villain/wonder.ogg', 100, vary = FALSE)

/obj/structure/flesh_monolith/examine(mob/user)
	var/mob/living/carbon/human/victim = user
	if(!istype(victim) || !victim.mind || victim.stat == DEAD || istype(victim.patron, /datum/patron/inhumen) || HAS_TRAIT(victim, TRAIT_NOMOOD))
		. = ..()
		if(istype(victim) && victim.mind && victim.stat != DEAD && !(REF(victim) in unmoved))
			unmoved += REF(victim)
			victim.visible_message(span_warning("[victim] looks at the [src] without so much as a flicker of a reaction."), ignored_mobs = victim)
		return
	gaze(victim)

/obj/structure/flesh_monolith/proc/gaze(mob/living/carbon/human/victim)
	var/key = REF(victim)
	if(key in gazers)
		to_chat(victim, span_warning("<i>Not again!</i>"))
		to_chat(victim, span_warning("I shut my eyes in panic!"))
		victim.stamina_add(victim.max_stamina)
		victim.become_blind("flesh_monolith")
		addtimer(CALLBACK(victim, TYPE_PROC_REF(/mob/living, cure_blind), "flesh_monolith"), 6 SECONDS)
		return
	gazers += key
	to_chat(victim, span_narsie("IT'S LOOKING AT ME!"))
	SEND_SOUND(victim, pick('modular_tidi/heretics/sound/heretic_scary_one.ogg', 'modular_tidi/heretics/sound/heretic_scary_two.ogg', 'modular_tidi/heretics/sound/heretic_scary_three.ogg', 'modular_tidi/heretics/sound/heretic_scary_four.ogg'))
	var/obj/item/organ/heart/heart = victim.getorganslot(ORGAN_SLOT_HEART)
	if(heart && maker_ref?.resolve())
		heart.monolith_maker = maker_ref
	victim.add_stress(/datum/stressevent/saw_wonder)
	victim.stamina_add(victim.max_stamina)
	victim.freak_out_targeted(src)
	victim.emote("scream", forced = TRUE)

/obj/item/organ/heart
	var/datum/weakref/monolith_maker

/mob/living/carbon/human/examine(mob/user)
	. = ..()
	var/obj/item/organ/heart/heart = getorganslot(ORGAN_SLOT_HEART)
	if(heart?.monolith_maker && heart.monolith_maker.resolve() == user)
		. += span_userdanger("THEY HAVE SEEN IT!")

/obj/item/organ/heart/examine(mob/user)
	. = ..()
	if(monolith_maker && monolith_maker.resolve() == user)
		. += span_cult("This heart gazed upon my monolith. IT wants it.")

/datum/action/cooldown/spell/lacrima/heart
	name = "Aorta-Lacrimoso"
	desc = "Requires an aggressive grab on a prone target, living or dead. Fracture their ribcage and tear out their heart."
	background_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon = 'icons/obj/surgery.dmi'
	button_icon_state = "heart-on"
	primary_resource_type = SPELL_COST_NONE
	secondary_resource_type = SPELL_COST_NONE
	cooldown_time = 10 SECONDS

/datum/action/cooldown/spell/lacrima/heart/cast(atom/cast_on)
	if(!owner.pulling || !ishuman(owner.pulling) || owner.grab_state < GRAB_AGGRESSIVE)
		to_chat(owner, span_warning("I need an aggressive grab on a floored victim to tear out their heart!"))
		reset_spell_cooldown()
		return FALSE
	return ..()

/datum/action/cooldown/spell/lacrima/heart/lux_rip(mob/living/carbon/human/target, mob/living/carbon/human/user)
	var/break_time = 13 SECONDS
	var/tear_time = 7 SECONDS

	if(target == user)
		return FALSE
	if(!target.Adjacent(user))
		to_chat(user, span_info("I need to be next to [target] to tear out their heart."))
		return FALSE
	if(target.mobility_flags & MOBILITY_STAND)
		to_chat(user, span_info("My victim must be lying down."))
		return FALSE

	var/obj/item/bodypart/chest = target.get_bodypart(BODY_ZONE_CHEST)
	if(!chest)
		to_chat(user, span_warning("There is no viable chest to tear a heart from."))
		return FALSE
	var/obj/item/organ/heart/gazed_heart = target.getorganslot(ORGAN_SLOT_HEART)
	if(!gazed_heart)
		to_chat(user, span_warning("Only a hollow chest remains."))
		return FALSE
	if(gazed_heart.monolith_maker?.resolve() != user)
		to_chat(user, span_warning("This one never gazed upon my monolith."))
		return FALSE

	user.visible_message(span_artery("[user] reaches towards [target]'s chest, necrotic flames wreathing [user.p_their()] hand..."))

	if(!chest.has_wound(/datum/wound/fracture/chest))
		if(!do_after(user, break_time, target = target))
			return FALSE
		user.say(",w Cede...")
		if(!HAS_TRAIT(target, TRAIT_NOPAIN) && target.stat != DEAD)
			target.emote("paincrit")
		chest.add_wound(/datum/wound/fracture/chest)
		target.apply_damage(50, BRUTE, BODY_ZONE_CHEST)
		user.visible_message(span_artery("[user] plunges their fist into [target]'s ribcage, shattering it spectacularly!"))

	user.playsound_local(user, 'sound/magic/repulse.ogg', 50, FALSE)

	if(!do_after(user, tear_time, target = target))
		return FALSE
	var/obj/item/organ/heart/heart = target.getorganslot(ORGAN_SLOT_HEART)
	if(!heart)
		to_chat(user, span_warning("Only a hollow chest remains."))
		return FALSE
	user.say(",w --et pars Magni Operis Eius eris!")
	user.playsound_local(user, 'sound/magic/swap.ogg', 50, FALSE)
	playsound(get_turf(target), 'sound/combat/brutal_impalement.ogg', 100, TRUE)

	if(target.stat != DEAD)
		target.emote("superagony")

	heart.Remove(target)
	heart.forceMove(target.drop_location())
	user.put_in_hands(heart)
	user.playsound_local(user, 'modular_tidi/heretics/sound/heart_tear.ogg', 100, FALSE)
	target.add_splatter_floor()
	user.visible_message(span_artery("[user] tears [target]'s heart from [target.p_their()] chest!"), span_cult("I hold [target]'s heart up for ZIZO to see. A deathly shiver runs up my spine."))
	return TRUE
