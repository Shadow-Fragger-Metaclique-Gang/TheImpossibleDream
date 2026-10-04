/datum/brewing_recipe/emberwine
	name = "Wine, Aphrodisiac"
	bottle_name = "jackberry wine" // Jackberry wine has the closest color to emberwine for your evil and sexual purposes have fun
	bottle_desc = "A bottle of locally-brewed jackberry wine. Has a sweet, fruity flavor with a hint of tartness."
	reagent_to_brew = /datum/reagent/consumable/ethanol/beer/emberwine
	output_bottle_type = /obj/item/reagent_containers/glass/bottle/brewing_bottle/jack_wine
	needed_reagents = list(/datum/reagent/water = 198)
	needed_items = list(/obj/item/alch/sinew = 2, /obj/item/alch/euphrasia = 2)
	brewed_amount = 2
	brew_time = 5 MINUTES
	sell_value = 60
