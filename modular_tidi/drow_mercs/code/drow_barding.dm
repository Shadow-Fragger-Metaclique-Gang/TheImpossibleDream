/obj/item/clothing/barding
	var/natural_armor = FALSE

/obj/item/clothing/barding/drider
	name = "drider chitin"
	desc = "A drider's tough, living carapace."
	icon = null
	icon_state = null
	invisibility = INVISIBILITY_ABSTRACT
	barding_icon = null
	barding_state = null
	female_barding_state = null
	valid_animal_types = list(/mob/living/simple_animal/hostile/retaliate/rogue/drider)
	armor = ARMOR_BRIGANDINE
	max_integrity = ARMOR_INT_CHEST_PLATE_BRIGANDINE
	natural_armor = TRUE
	sewrepair = FALSE
	salvage_result = null
	salvage_amount = 0
	fiber_salvage = FALSE
	break_sound = null
	drop_sound = null
	var/repair_time = 40 SECONDS//20% integ every 40 seconds
	var/repair_timer

/obj/item/clothing/barding/drider/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, TRAIT_GENERIC)

/obj/item/clothing/barding/drider/Destroy()
	deltimer(repair_timer)
	return ..()

/obj/item/clothing/barding/drider/take_damage(damage_amount, damage_type = BRUTE, damage_flag, sound_effect, attack_dir, armor_penetration)
	. = ..()
	if(. && !repair_timer)
		repair_timer = addtimer(CALLBACK(src, PROC_REF(regenerate)), repair_time, TIMER_STOPPABLE)

/obj/item/clothing/barding/drider/obj_destruction(damage_flag)
	//chitin stays attached so it can regenerate even from zero integ.
	return FALSE

/obj/item/clothing/barding/drider/proc/regenerate()
	repair_timer = null
	var/mob/living/simple_animal/hostile/retaliate/rogue/drider/animal = loc
	if(!istype(animal) || QDELETED(animal) || animal.stat == DEAD || animal.bbarding != src)
		return
	obj_integrity = min(obj_integrity + 0.2 * max_integrity, max_integrity)
	if(obj_broken)
		obj_fix(full_repair = FALSE)
	if(obj_integrity < max_integrity)
		repair_timer = addtimer(CALLBACK(src, PROC_REF(regenerate)), repair_time, TIMER_STOPPABLE)
