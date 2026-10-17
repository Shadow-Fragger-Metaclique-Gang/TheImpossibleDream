/datum/stressevent/lux_bite
	timer = 10 MINUTES
	stressadd = -4
	desc = span_blue("The sweet taste of lyfe-essence spreads through my belly like orgiastic warmth, how ecstatic!")

/datum/stressevent/lux_bite/impure
	stressadd = -2
	desc = span_blue("The sour taste of impure lyfe-essence spreads through my belly. It's definitely an acquired taste, though.")

/obj/item/reagent_containers/food/snacks/lux // Thank you fluvian code for donating
	name = "temporary lux snack item"
	desc = ""
	list_reagents = list(/datum/reagent/vitae = 1)
	tastes = list("lyfe itself" = 1)
	bitesize = 1

/obj/item/reagent_containers/food/snacks/lux/impure
	list_reagents = list(/datum/reagent/vitae = 0.5)
	tastes = list("something sour" = 1)

/obj/item/reagent_containers/lux/attack(mob/living/M, mob/living/user, def_zone)
	if(M != user || user.used_intent.type == INTENT_HARM || !HAS_TRAIT(M, TRAIT_DEPRAVED)) // Only eat the lux if it's self fed so we don't get people valid testing Baothans with lux on a stick
		return ..()
	var/obj/item/reagent_containers/food/snacks/lux/lux_as_food = new
	lux_as_food.name = name
	if(lux_as_food.attack(M, user, def_zone))
		M.add_stress(/datum/stressevent/lux_bite)
		reagents.remove_reagent(/datum/reagent/vitae, 1)
		if(!reagents.total_volume)
			SEND_SIGNAL(M, COMSIG_HERETIC_LUX_EATEN)
			qdel(src)
	qdel(lux_as_food)

// Impure lux apparently didn't contain reagents, so we add some to it
// This has quite literally zero balance implications because you can't grind impure lux
// Why does lux have vitae physically inside of it anyways? Why are they reagent containers?
/obj/item/reagent_containers/lux_impure
	list_reagents = list(/datum/reagent/vitae = 2.5)

/obj/item/reagent_containers/lux_impure/attack(mob/living/M, mob/living/user, def_zone)
	if(M != user || user.used_intent.type == INTENT_HARM || !HAS_TRAIT(M, TRAIT_DEPRAVED)) // I get why they're not subtypes of eachother but also fuck you
		return ..()
	var/obj/item/reagent_containers/food/snacks/lux/impure/lux_as_food = new
	lux_as_food.name = name
	if(lux_as_food.attack(M, user, def_zone))
		M.add_stress(/datum/stressevent/lux_bite/impure)
		reagents.remove_reagent(/datum/reagent/vitae, 0.5)
		if(!reagents.total_volume)
			SEND_SIGNAL(M, COMSIG_HERETIC_LUX_EATEN)
			qdel(src)
	qdel(lux_as_food)
