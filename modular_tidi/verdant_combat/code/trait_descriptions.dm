/datum/controller/global_vars/Initialize(mapload)
	. = ..()
	roguetraits -= TRAIT_TEMPO
	roguetraits[TRAIT_CIVILIZEDBARBARIAN] = span_info("My rigorous training in the martial arts has turned me into a living weapon. No limb is out of reach for my fists and feet. My unarmed strikes are more powerful and have a higher chance to inflict critical damage. My parrying with bracers, knuckles, or bandages is significantly more effective.")
	roguetraits[TRAIT_GIANT_WEAPON_WIELDER] = span_info("My giant heritage allows me to wield massive weapons without penalty.")
