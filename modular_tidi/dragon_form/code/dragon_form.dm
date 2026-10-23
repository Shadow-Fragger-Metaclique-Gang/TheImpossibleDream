/obj/effect/proc_holder/spell/self/wingsoffreedom
	name = "Wings of Freedom"
	desc = "Transform into the strongest form of Matthios' own - a dragon. A mere mortal can't sustain this form for long, yet with the power Matthios grants you, you shall burn this world of tyranny to the ground."
	overlay_state = "wingsoffreedom"
	action_icon = 'modular_tidi/dragon_form/icons/dragonmiracle.dmi'
	glow_color = GLOW_COLOR_MATTHIOS
	glow_intensity = GLOW_INTENSITY_LOW
	clothes_req = FALSE
	human_req = FALSE
	chargedrain = 0
	chargetime = 0
	recharge_time = 30 MINUTES
	cooldown_min = 30 MINUTES
	invocations = list("I WILL BURN THE WORLD OF TYRANNY TO THE GROUND!!")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	devotion_cost = 200
	miracle = TRUE


/obj/effect/proc_holder/spell/self/wingsoffreedom/cast(list/targets, mob/living/carbon/human/user = usr)
	. = ..()

	if(user.has_status_effect(/datum/status_effect/debuff/submissive))
		to_chat(user, span_warning("Your will is too broken to change form."))
		revert_cast(user)
		return FALSE

	if(istype(user, /mob/living/carbon/human/species/wildshape))
		revert_cast(user)
		return FALSE

	if(!do_after(user, 10 SECONDS, target = user))
		to_chat(user, span_userdanger("You are unable to concentrate enough to shapeshift!"))
		revert_cast(user)
		return FALSE

	if(istype(get_area(user), /area/rogue/indoors/ravoxarena))
		to_chat(user, span_userdanger("I reach for my draconic form, but something rebukes me! Ravox is too strong in this dimension!"))
		revert_cast(user)
		return FALSE

	user.Stun(30)
	user.Knockdown(30)
	INVOKE_ASYNC(user, TYPE_PROC_REF(/mob/living/carbon/human, wildshape_transformation_twilight_dragon), /mob/living/carbon/human/species/wildshape/dragon_matthios)

	return TRUE

// Mob itself
/mob/living/carbon/human/species/wildshape/dragon_matthios
	name = "Gilded Dragon"
	desc = "It has been a very long time since the dragons ruled the skies, yet their power still remains formiddable. Despite their monstrous form, ancient intelligence in their eyes betrays their sentience."
	race = /datum/species/dragon_matthios
	footstep_type = FOOTSTEP_MOB_HEAVY
	ambushable = FALSE
	skin_armor = new /obj/item/clothing/suit/roguetown/armor/regenerating/skin/twilight_dragon_skin
	wildshape_icon = 'modular_tidi/dragon_form/icons/dragon_cool.dmi'
	wildshape_icon_state = "dragon_cool"
	pixel_x = -32
	pixel_y = -16
	var/swooping = NONE

/mob/living/carbon/human/species/wildshape/dragon_matthios/gain_inherent_skills()
	if(mind)
		adjust_skillrank(/datum/skill/combat/wrestling, SKILL_LEVEL_MASTER, TRUE)
		adjust_skillrank(/datum/skill/combat/unarmed, SKILL_LEVEL_MASTER, TRUE)
		adjust_skillrank(/datum/skill/misc/swimming, SKILL_LEVEL_EXPERT, TRUE)
		adjust_skillrank(/datum/skill/misc/athletics, SKILL_LEVEL_MASTER, TRUE)
		adjust_skillrank(/datum/skill/magic/arcane, SKILL_LEVEL_EXPERT, TRUE)

		STASTR = 15
		STACON = 15
		STAWIL = 15
		STAPER = 12
		STASPD = 6
		STAINT = 15

		AddSpell(new /obj/effect/proc_holder/spell/self/twilight_dragonclaws)
		AddSpell(new /obj/effect/proc_holder/spell/invoked/gilded_swoop)

		var/datum/action/cooldown/spell/projectile/fireball/fireball = new /datum/action/cooldown/spell/projectile/fireball
		var/datum/action/cooldown/spell/projectile/spitfire/spitfire = new /datum/action/cooldown/spell/projectile/spitfire

		fireball.Grant(src)
		spitfire.Grant(src)

		AddSpell(new /obj/effect/proc_holder/spell/targeted/woundlick)
		src.apply_status_effect(/datum/status_effect/buff/twilight_dragon_form)

		real_name = "Gilded Dragon"

#define GILDED_SWOOP_DAMAGEABLE 1
#define GILDED_SWOOP_INVULNERABLE 2
#define GILDED_SWOOP_HEIGHT 270
#define GILDED_SWOOP_DIRECTION_CHANGE_RANGE 5

/obj/effect/proc_holder/spell/invoked/gilded_swoop
    name = "Gilded Swoop"
    recharge_time = 30 SECONDS
    overlay_state = "dendor"
    chargetime = 0
    range = 15
    antimagic_allowed = TRUE

/obj/effect/proc_holder/spell/invoked/gilded_swoop/cast(list/targets, mob/living/user = usr)
    if(!istype(user, /mob/living/carbon/human/species/wildshape/dragon_matthios))
        return FALSE
    var/mob/living/carbon/human/species/wildshape/dragon_matthios/dragon = user
    return dragon.gilded_swoop(targets[1])

/obj/effect/temp_visual/gilded_dragon_flight
    icon = 'modular/icons/mob/96x96/ratwood_dragon.dmi'
    icon_state = "dragon_cool"
    layer = ABOVE_ALL_MOB_LAYER
    pixel_x = -32
    duration = 10
    randomdir = FALSE

/obj/effect/temp_visual/gilded_dragon_flight/Initialize(mapload, negative)
    . = ..()
    INVOKE_ASYNC(src, PROC_REF(flight), negative)

/obj/effect/temp_visual/gilded_dragon_flight/proc/flight(negative)
    if(negative)
        animate(src, pixel_x = -GILDED_SWOOP_HEIGHT*0.1, pixel_z = GILDED_SWOOP_HEIGHT*0.15, time = 3, easing = BOUNCE_EASING)
    else
        animate(src, pixel_x = GILDED_SWOOP_HEIGHT*0.1, pixel_z = GILDED_SWOOP_HEIGHT*0.15, time = 3, easing = BOUNCE_EASING)
    sleep(3)
    icon_state = "dragon_swoop"
    if(negative)
        animate(src, pixel_x = -GILDED_SWOOP_HEIGHT, pixel_z = GILDED_SWOOP_HEIGHT, time = 7)
    else
        animate(src, pixel_x = GILDED_SWOOP_HEIGHT, pixel_z = GILDED_SWOOP_HEIGHT, time = 7)

/obj/effect/temp_visual/gilded_dragon_flight/end
    pixel_x = GILDED_SWOOP_HEIGHT
    pixel_z = GILDED_SWOOP_HEIGHT
    duration = 10

/obj/effect/temp_visual/gilded_dragon_flight/end/flight(negative)
    if(negative)
        pixel_x = -GILDED_SWOOP_HEIGHT
        animate(src, pixel_x = -32, pixel_z = 0, time = 5)
    else
        animate(src, pixel_x = -32, pixel_z = 0, time = 5)

/obj/effect/temp_visual/gilded_dragon_flight/end
    icon = 'modular/icons/mob/96x96/ratwood_dragon.dmi'
    icon_state = "dragon_cool"

/mob/living/carbon/human/species/wildshape/dragon_matthios/proc/gilded_swoop(atom/movable/manual_target)
    if(stat || swooping || !manual_target || QDELETED(manual_target))
        return FALSE
    var/turf/target_turf = get_turf(manual_target)
    if(!target_turf || target_turf.z != z)
        return FALSE

    playsound(loc, 'sound/vo/mobs/vdragon/drgnroar.ogg', 50, TRUE, -1)
    swooping |= GILDED_SWOOP_DAMAGEABLE
    movement_type = FLYING
    density = FALSE
    var/old_icon_state = icon_state
    icon_state = "shadow"
    visible_message("<span class='boldwarning'>[src] swoops up high!</span>")

    var/negative
    var/initial_x = x
    if(target_turf.x < initial_x)
        negative = TRUE
    else if(target_turf.x > initial_x)
        negative = FALSE
    else
        negative = prob(50)
    var/obj/effect/temp_visual/gilded_dragon_flight/F = new(loc, negative)

    negative = !negative
    var/oldtransform = transform
    var/oldalpha = alpha
    alpha = 255
    animate(src, alpha = 204, transform = matrix()*0.9, time = 3, easing = BOUNCE_EASING)
    for(var/i in 1 to 3)
        sleep(1)
        if(QDELETED(src) || stat == DEAD)
            qdel(F)
            if(stat == DEAD)
                swooping &= ~GILDED_SWOOP_DAMAGEABLE
                animate(src, alpha = oldalpha, transform = oldtransform, time = 0, flags = ANIMATION_END_NOW)
            return FALSE
    animate(src, alpha = 100, transform = matrix()*0.7, time = 7)
    swooping |= GILDED_SWOOP_INVULNERABLE
    mouse_opacity = MOUSE_OPACITY_TRANSPARENT
    SLEEP_CHECK_DEATH(7)

    while(manual_target && !QDELETED(manual_target) && loc != get_turf(manual_target))
        forceMove(get_step(src, get_dir(src, manual_target)))
        SLEEP_CHECK_DEATH(0.5)

    var/descent_time = 10
    if(negative)
        if(ISINRANGE(x, initial_x + 1, initial_x + GILDED_SWOOP_DIRECTION_CHANGE_RANGE))
            negative = FALSE
    else if(ISINRANGE(x, initial_x - GILDED_SWOOP_DIRECTION_CHANGE_RANGE, initial_x - 1))
        negative = TRUE
    new /obj/effect/temp_visual/gilded_dragon_flight/end(loc, negative)
    new /obj/effect/temp_visual/dragon_swoop(loc)
    animate(src, alpha = 255, transform = oldtransform, descent_time)
    SLEEP_CHECK_DEATH(descent_time)
    icon_state = old_icon_state
    swooping &= ~GILDED_SWOOP_INVULNERABLE
    mouse_opacity = initial(mouse_opacity)
    playsound(loc, 'sound/misc/meteorimpact.ogg', 200, TRUE)
    for(var/mob/living/L in orange(1, src))
        if(L.stat)
            visible_message(span_warning("[src] slams down on [L], crushing [L.p_them()]!"))
            L.gib()
        else
            L.adjustBruteLoss(75)
            if(L && !QDELETED(L))
                var/throw_dir = get_dir(src, L)
                if(L.loc == loc)
                    throw_dir = pick(GLOB.alldirs)
                var/throwtarget = get_edge_target_turf(src, throw_dir)
                L.throw_at(throwtarget, 3)
                visible_message(span_warning("[L] is thrown clear of [src]!</span>"))
    for(var/mob/M in range(7, src))
        shake_camera(M, 15, 1)
    movement_type = GROUND
    density = TRUE
    SLEEP_CHECK_DEATH(1)
    swooping &= ~GILDED_SWOOP_DAMAGEABLE
    return TRUE

/mob/living/carbon/human/species/wildshape/dragon_matthios/apply_damage(damage = 0, damagetype = BRUTE, def_zone = null, blocked = FALSE, forced = FALSE, spread_damage = FALSE)
    if(swooping & GILDED_SWOOP_INVULNERABLE)
        return FALSE
    return ..()

#undef GILDED_SWOOP_DAMAGEABLE
#undef GILDED_SWOOP_INVULNERABLE
#undef GILDED_SWOOP_HEIGHT
#undef GILDED_SWOOP_DIRECTION_CHANGE_RANGE

/datum/species/dragon_matthios
	name = "Gilded Dragon"
	id = "dragon_matthios"
	species_traits = list(NO_UNDERWEAR, NO_ORGAN_FEATURES, NO_BODYPART_FEATURES)
	inherent_traits = list(
		TRAIT_TOXIMMUNE,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_NOPAINSTUN,
		TRAIT_NOFIRE,
		TRAIT_NIGHT_VISION,
		TRAIT_BASHDOORS,
		TRAIT_STRONGBITE,
		TRAIT_STEELHEARTED,
		TRAIT_DEATHBYSNUSNU,
		TRAIT_ORGAN_EATER,
		TRAIT_WILD_EATER,
		TRAIT_HARDDISMEMBER,
		TRAIT_PIERCEIMMUNE,
		TRAIT_LONGSTRIDER,
		TRAIT_NOFALLDAMAGE1,
		TRAIT_KNEESTINGER_IMMUNITY
	)
	inherent_biotypes = MOB_HUMANOID
	no_equip = list(SLOT_SHIRT, SLOT_HEAD, SLOT_WEAR_MASK, SLOT_ARMOR, SLOT_GLOVES, SLOT_SHOES, SLOT_PANTS, SLOT_CLOAK, SLOT_BELT, SLOT_BACK_R, SLOT_BACK_L, SLOT_S_STORE, SLOT_RING, SLOT_NECK)
	nojumpsuit = 1
	sexes = 1
	offset_features = list(OFFSET_HANDS = list(0,2), OFFSET_HANDS_F = list(0,2))
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/night_vision,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/wild_tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		)

	languages = list(
		/datum/language/draconic,
		/datum/language/common,
	)

/datum/species/dragon_matthios/send_voice(mob/living/carbon/human/human)
	playsound(get_turf(human), pick('sound/vo/mobs/vw/aggro (1).ogg','sound/vo/mobs/vw/aggro (2).ogg'), 80, TRUE, -1)

/datum/species/dragon_matthios/regenerate_icons(mob/living/carbon/human/human)
	human.icon = 'modular_tidi/dragon_form/icons/dragon_cool.dmi'
	human.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)
	human.icon_state = "dragon_cool"
	human.update_damage_overlays()
	return TRUE

/datum/species/dragon_matthios/on_species_gain(mob/living/carbon/carbon, datum/species/old_species)
	. = ..()
	RegisterSignal(carbon, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/species/dragon_matthios/update_damage_overlays(mob/living/carbon/human/human)
	human.remove_overlay(DAMAGE_LAYER)
	return TRUE

/datum/intent/simple/twilight_dragon_cut
	name = "claw"
	clickcd = 10
	icon_state = "incut"
	blade_class = BCLASS_CUT
	attack_verb = list("claws", "mauls", "eviscerates")
	animname = "cut"
	hitsound = "genslash"
	penfactor = PEN_MEDIUM
	reach = 2
	candodge = TRUE
	canparry = TRUE
	miss_text = "slashes the air!"
	miss_sound = "bluntswoosh"
	item_d_type = "slash"

/datum/intent/simple/twilight_dragon_chop
	name = "claw"
	icon_state = "inchop"
	blade_class = BCLASS_CHOP
	attack_verb = list("claws", "mauls", "eviscerates")
	animname = "chop"
	hitsound = "genslash"
	penfactor = PEN_HEAVY
	candodge = TRUE
	canparry = TRUE
	miss_text = "slashes the air!"
	miss_sound = "bluntwooshlarge"
	item_d_type = "slash"
	damfactor = 1.2

/datum/intent/mace/smash/twilight_dragon_smash
	name = "thrash"
	desc = "A powerful, smash of dragon muscle that deals normal damage but can throw a standing opponent back and slow them down, based on your strength. Ineffective below 10 strength. Slowdown & Knockback scales to your Strength up to 15 (1 - 5 tiles). Cannot be used consecutively more than every 5 seconds on the same target. Prone targets halve the knockback distance."
	icon_state = "insmash"
	reach = 2
	maxrange = 5
	chargetime = 1
	penfactor = PEN_LIGHT

/datum/intent/mace/strike/twilight_dragon_strike
	name = "armor rending strike"
	miss_text = "strikes the air!"
	miss_sound = "bluntwooshlarge"
	attack_verb = list("punches", "strikes", "tears")

/obj/item/rogueweapon/twilight_dragon_claw
	name = "dragon claw"
	desc = "It is said that true dragons used to infuse their claws with metal alloys to make them more dangerous in combat. Regardless of whether that's true, those talons, blessed by Matthios, are no less powerful."
	item_state = null
	lefthand_file = null
	righthand_file = null
	icon = 'icons/roguetown/weapons/unarmed32.dmi'
	max_blade_int = 600
	max_integrity = 600
	force = 28
	block_chance = 0
	wdefense = 6
	blade_dulling = DULLING_SHAFT_WOOD
	associated_skill = /datum/skill/combat/unarmed
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	w_class = WEIGHT_CLASS_NORMAL
	can_parry = TRUE
	sharpness = IS_SHARP
	parrysound = "bladedmedium"
	swingsound = list('sound/combat/hits/blunt/genblunt (1).ogg','sound/combat/hits/blunt/genblunt (2).ogg','sound/combat/hits/blunt/genblunt (3).ogg','sound/combat/hits/blunt/flailhit.ogg')
	possible_item_intents = list(/datum/intent/simple/twilight_dragon_cut, /datum/intent/simple/twilight_dragon_chop, /datum/intent/mace/smash/twilight_dragon_smash, /datum/intent/mace/strike/twilight_dragon_strike)
	parrysound = list('sound/combat/parry/parrygen.ogg')
	embedding = list("embedded_pain_multiplier" = 0, "embed_chance" = 0, "embedded_fall_chance" = 0)
	item_flags = DROPDEL
	experimental_inhand = FALSE

/obj/item/rogueweapon/twilight_dragon_claw/right
	icon_state = "claw_r"

/obj/item/rogueweapon/twilight_dragon_claw/left
	icon_state = "claw_l"

/obj/item/rogueweapon/twilight_dragon_claw/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOEMBED, TRAIT_GENERIC)

/obj/effect/proc_holder/spell/self/twilight_dragonclaws
	name = "Dragon Claws"
	desc = "Extend or retract your razor-sharp claws."
	overlay_state = "claws"
	glow_color = GLOW_COLOR_MATTHIOS
	glow_intensity = GLOW_INTENSITY_LOW
	antimagic_allowed = TRUE
	recharge_time = 2 SECONDS
	ignore_cockblock = TRUE
	var/extended = FALSE

/obj/effect/proc_holder/spell/self/twilight_dragonclaws/cast(mob/user = usr)
	..()
	var/obj/item/rogueweapon/twilight_dragon_claw/left/left = user.get_active_held_item()
	var/obj/item/rogueweapon/twilight_dragon_claw/right/right = user.get_inactive_held_item()

	if(extended)
		if(istype(left, /obj/item/rogueweapon/twilight_dragon_claw))
			user.dropItemToGround(left, TRUE)
			qdel(left)

		if(istype(right, /obj/item/rogueweapon/twilight_dragon_claw))
			user.dropItemToGround(right, TRUE)
			qdel(right)

		extended = FALSE
		return

	left = new(user, 1)
	right = new(user, 2)
	user.put_in_hands(left, TRUE, FALSE, TRUE)
	user.put_in_hands(right, TRUE, FALSE, TRUE)
	extended = TRUE


/datum/status_effect/buff/twilight_dragon_form
	id = "twilight_dragon_form"
	alert_type = /atom/movable/screen/alert/status_effect/buff/twilight_dragon_form
	duration = 5 MINUTES

/datum/status_effect/buff/twilight_dragon_form/short
	id = "twilight_dragon_form_short"
	alert_type = /atom/movable/screen/alert/status_effect/buff/twilight_dragon_form
	duration = 30 SECONDS

/atom/movable/screen/alert/status_effect/buff/twilight_dragon_form
	name = "Dragon Form"
	desc = "Burn them! Burn them all!"
	icon_state = "wingsoffreedom_buff"
	icon = 'modular_tidi/dragon_form/icons/dragonmiracle.dmi'

/datum/status_effect/buff/twilight_dragon_form/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		if(H.stat != DEAD)
			H.wildshape_untransform_twilight_dragon(FALSE)

#define TRAIT_SOURCE_WILDSHAPE "wildshape_transform"

/mob/living/carbon/human/species/wildshape/dragon_matthios/death(gibbed, nocutscene = FALSE)
	wildshape_untransform_twilight_dragon(TRUE, gibbed)

/mob/living/carbon/human/proc/wildshape_transformation_twilight_dragon(shapepath)
	if(!mind)
		log_runtime("NO MIND ON [src.name] WHEN TRANSFORMING")
	Paralyze(1, ignore_canstun = TRUE)
	//before we shed our items, save our neck and ring, if we have any, so we can quickly rewear them
	regenerate_icons()
	icon = null
	var/oldinv = invisibility
	invisibility = INVISIBILITY_MAXIMUM
	cmode = FALSE
	if(client)
		SSdroning.play_area_sound(get_area(src), client)

	var/mob/living/carbon/human/species/wildshape/dragon_matthios/W = new shapepath(loc) //We crate a new mob for the wildshaping player to inhabit

	W.set_patron(src.patron)
	W.gender = gender
	W.regenerate_icons()
	W.stored_mob = src
	playsound(W.loc, 'sound/body/shapeshift-start.ogg', 100, FALSE, 3)
	src.forceMove(W)
	W.after_creation()
	W.stored_language = new
	W.stored_language.copy_known_languages_from(src)
	W.stored_skills = ensure_skills().known_skills.Copy()
	W.stored_experience = ensure_skills().skill_experience.Copy()
	W.voice_color = voice_color
	W.cmode_music_override = cmode_music_override
	W.cmode_music_override_name = cmode_music_override_name

	W.bleedsuppress = bleedsuppress
	bleed_rate = 0
	bleedsuppress = TRUE
	W.set_nutrition(nutrition)
	W.set_hydration(hydration)

	mind.transfer_to(W)
	for(var/obj/effect/proc_holder/S in W.mind.spell_list)
		if(!istype(S, /obj/effect/proc_holder/spell/self/wingsoffreedom))
			W.stored_spells += list(S.type)
			W.mind.RemoveSpell(S)
	skills?.known_skills = list()
	skills?.skill_experience = list()
	W.grant_language(/datum/language/draconic)
	W.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)
	W.update_a_intents()

	if(getorganslot(ORGAN_SLOT_PENIS))
		W.internal_organs_slot[ORGAN_SLOT_PENIS] = /obj/item/organ/penis/knotted/big
	if(getorganslot(ORGAN_SLOT_TESTICLES))
		W.internal_organs_slot[ORGAN_SLOT_TESTICLES] = /obj/item/organ/testicles
	if(getorganslot(ORGAN_SLOT_BREASTS))
		W.internal_organs_slot[ORGAN_SLOT_BREASTS] = /obj/item/organ/breasts
	if(getorganslot(ORGAN_SLOT_VAGINA))
		W.internal_organs_slot[ORGAN_SLOT_VAGINA] = /obj/item/organ/vagina

	// temporal traits so our body won't die or snore
	ADD_TRAIT(src, TRAIT_NOSLEEP, TRAIT_SOURCE_WILDSHAPE)
	ADD_TRAIT(src, TRAIT_NOBREATH, TRAIT_SOURCE_WILDSHAPE)
	ADD_TRAIT(src, TRAIT_NOPAIN, TRAIT_SOURCE_WILDSHAPE)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_SOURCE_WILDSHAPE)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_SOURCE_WILDSHAPE)
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_SOURCE_WILDSHAPE)
	ADD_TRAIT(src, TRAIT_PACIFISM, TRAIT_SOURCE_WILDSHAPE) // just an extra layer of protection in case something will go wrong
	src.status_flags |= GODMODE // so they won't die by any means
	invisibility = oldinv

	playsound(W.loc, 'sound/vo/mobs/vdragon/drgnroar.ogg', 100, FALSE, 3)
	W.gain_inherent_skills()
	addtimer(CALLBACK(W, PROC_REF(energy_add), 1000), 3 SECONDS)

/mob/living/carbon/human/proc/wildshape_untransform_twilight_dragon(dead)
	if(!stored_mob)
		return
	if(!mind)
		if(has_status_effect(/datum/status_effect/buff/twilight_dragon_form))
			remove_status_effect(/datum/status_effect/buff/twilight_dragon_form)
		apply_status_effect(/datum/status_effect/buff/twilight_dragon_form/short)
		return
	if(istype(get_area(src), /area/rogue/indoors/ravoxarena))
		to_chat(src, span_userdanger("I reach for my normal form, but something rebukes me! Ravox is too strong in this dimension!"))
		if(has_status_effect(/datum/status_effect/buff/twilight_dragon_form))
			remove_status_effect(/datum/status_effect/buff/twilight_dragon_form)
		apply_status_effect(/datum/status_effect/buff/twilight_dragon_form/short)
		return
	var/mob/living/carbon/human/species/wildshape/WA = src
	Paralyze(1, ignore_canstun = TRUE)
	for(var/obj/item/W in src)
		dropItemToGround(W)
	icon = null
	invisibility = INVISIBILITY_MAXIMUM

	var/mob/living/carbon/human/W = stored_mob
	stored_mob = null

	REMOVE_TRAIT(W, TRAIT_NOSLEEP, TRAIT_SOURCE_WILDSHAPE)
	REMOVE_TRAIT(W, TRAIT_NOBREATH, TRAIT_SOURCE_WILDSHAPE)
	REMOVE_TRAIT(W, TRAIT_NOPAIN, TRAIT_SOURCE_WILDSHAPE)
	REMOVE_TRAIT(W, TRAIT_TOXIMMUNE, TRAIT_SOURCE_WILDSHAPE)
	REMOVE_TRAIT(W, TRAIT_NOHUNGER, TRAIT_SOURCE_WILDSHAPE)
	REMOVE_TRAIT(W, TRAIT_NOMOOD, TRAIT_SOURCE_WILDSHAPE)
	REMOVE_TRAIT(W, TRAIT_PACIFISM, TRAIT_SOURCE_WILDSHAPE)
	W.status_flags &= ~GODMODE
	// re-equip our stored neck and ring items, if we have them

	W.bleedsuppress = bleedsuppress
	W.set_nutrition(nutrition)
	W.set_hydration(hydration)

	W.forceMove(get_turf(src))
	mind.transfer_to(W)
	for(var/S in WA.stored_spells)
		if(S)
			W.mind.AddSpell(new S, W)
	if(dead)
		W.Unconscious(30 SECONDS, TRUE, TRUE)
		W.visible_message(span_boldwarning("[W] twists and shifts back into humen guise in a sickening lurch of flesh and bone, and promptly passes out!"), span_userdanger("I quickly flee the waning vitality of my former shape, but the strain is too much--"))
		to_chat(W, span_crit("...DARKNESS..."))
	W.copy_known_languages_from(WA.stored_language)
	skills?.known_skills = WA.stored_skills.Copy()
	skills?.skill_experience = WA.stored_experience.Copy()

	playsound(W.loc, 'sound/body/shapeshift-end.ogg', 100, FALSE, 3)
	//Compares the list of spells we had before transformation with those we do now. If there are any that don't match, we remove them
	for(var/obj/effect/proc_holder/spell/originspell in WA.stored_spells)
		for(var/obj/effect/proc_holder/spell/wildspell in W.mind.spell_list)
			if((wildspell != originspell) && !istype(wildspell, /obj/effect/proc_holder/spell/self/wingsoffreedom))
				W.RemoveSpell(wildspell)

	W.regenerate_icons()
	if(!dead)
		to_chat(W, span_userdanger("I return to my old form."))

	qdel(src)

#undef TRAIT_SOURCE_WILDSHAPE

/obj/effect/proc_holder/spell/invoked/projectile/fireball/matthios_dragon
	glow_color = GLOW_COLOR_MATTHIOS
	glow_intensity = GLOW_INTENSITY_LOW
	invocation_type = "none"
	recharge_time = 40 SECONDS

/obj/effect/proc_holder/spell/invoked/projectile/spitfire/matthios_dragon
	glow_color = GLOW_COLOR_MATTHIOS
	glow_intensity = GLOW_INTENSITY_LOW
	invocation_type = "none"
	recharge_time = 15 SECONDS
