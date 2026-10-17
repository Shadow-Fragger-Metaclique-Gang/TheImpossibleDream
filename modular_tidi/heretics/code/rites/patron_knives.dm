/datum/runeritual/god/patron_knife
	abstract_type = /datum/runeritual/god/patron_knife
	cooldown = 30 MINUTES
	var/knife_type

/datum/runeritual/god/patron_knife/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	var/obj/item/rogueweapon/huntingknife/old_knife = selected_atoms["C"]
	if(istype(old_knife, /obj/item/rogueweapon/huntingknife/idagger/steel/profane))
		deny(user, locate(/obj/structure/ritualcircle) in loc, "The souls bound within [old_knife] refuse to be remade.")
		return FALSE
	var/turf/knife_turf = get_turf(old_knife)
	var/obj/item/new_knife = new knife_type(knife_turf)
	knife_turf.visible_message(span_cult("[old_knife] warps and twists upon the rune, reforged as [new_knife]!"))
	playsound(knife_turf, 'sound/combat/hits/onmetal/grille (2).ogg', 50)
	return TRUE

/datum/runeritual/god/patron_knife/zizo
	name = "Rite of the Avantyne Edge"
	desc = "Reforges any knife upon the rune into an avantyne dagger, paid for in the remains of the dead."
	knife_type = /obj/item/rogueweapon/huntingknife/idagger/steel/zizo
	layout = list(
		"W" = /obj/item/natural/bone,
		"C" = /obj/item/rogueweapon/huntingknife,
		"E" = /obj/item/natural/bone,
	)
	chant_lines = list(
		"ZIZO! ZIZO! THE DEAD YIELD THEIR BONES!",
		"ZIZO! ZIZO! ANOINT THIS BLADE WITH YOUR BLESSING MOST PURE!",
		"ZIZO! ZIZO! AN EDGE TO CLAIM THE IGNORANT'S FLESH!",
	)

/datum/runeritual/god/patron_knife/graggar
	name = "Rite of the Vicious Edge"
	desc = "Reforges any knife upon the rune into a vicious seax, paid for in flesh and blood."
	knife_type = /obj/item/rogueweapon/huntingknife/combat/graggar
	layout = list(
		"W" = /obj/item/organ,
		"C" = /obj/item/rogueweapon/huntingknife,
		"E" = /obj/item/organ,
	)
	banned_atom_types = list(
		/obj/item/organ/penis,
		/obj/item/organ/penis/barbed,
		/obj/item/organ/penis/barbed_knotted,
		/obj/item/organ/penis/equine,
		/obj/item/organ/penis/knotted,
		/obj/item/organ/penis/knotted/big,
		/obj/item/organ/penis/tapered,
		/obj/item/organ/penis/tapered_double,
		/obj/item/organ/penis/tapered_double_knotted,
		/obj/item/organ/penis/tapered_mammal,
		/obj/item/organ/penis/tentacle,
		/obj/item/organ/vagina,
		/obj/item/organ/breasts,
		/obj/item/organ/testicles,
		/obj/item/organ/testicles/internal,
	)
	chant_lines = list(
		"FLESH FOR THE BLADE!!",
		"A HEART FOR THE HUNGER!!",
		"GRAGGAR, MAKE IT CRUEL!!",
	)

/datum/runeritual/god/patron_knife/matthios
	name = "Rite of the Gilded Edge"
	desc = "Reforges any knife upon the rune into a gilded knife, paid for in gold and silver."
	knife_type = /obj/item/rogueweapon/huntingknife/idagger/steel/matthios
	layout = list(
		"W" = list(/obj/item/roguecoin/gold, /obj/item/roguecoin/silver),
		"C" = /obj/item/rogueweapon/huntingknife,
		"E" = list(/obj/item/roguecoin/gold, /obj/item/roguecoin/silver),
	)
	chant_lines = list(
		"Everything has its price!",
		"Gold and silver, I pay in full!",
		"Gild my edge, and let it take what is owed!",
	)

/datum/runeritual/god/patron_knife/baotha
	name = "Rite of the Saccharine Edge"
	desc = "Reforges any knife upon the rune into a saccharine misericorde, paid for in powders of ecstasy."
	knife_type = /obj/item/rogueweapon/huntingknife/idagger/steel/baotha
	layout = list(
		"W" = /obj/item/reagent_containers/powder,
		"C" = /obj/item/rogueweapon/huntingknife,
		"E" = /obj/item/reagent_containers/powder,
	)
	banned_atom_types = list(
		/obj/item/reagent_containers/powder/flour,
		/obj/item/reagent_containers/powder/salt,
		/obj/item/reagent_containers/powder/rocknut,
		/obj/item/reagent_containers/powder/coarse_salt,
		/obj/item/reagent_containers/powder/mineral,
		/obj/item/reagent_containers/powder/black_ichor,
	)
	chant_lines = list(
		"Pour the wine, cut the spice!",
		"Sweeten the steel, let it ache so lovely!",
		"Baotha, kiss this blade!",
	)
