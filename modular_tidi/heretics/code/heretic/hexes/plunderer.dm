/datum/hex/plunderer
	name = "\improper Hex of the Plunderer"
	var/downgrading = FALSE

/datum/hex/plunderer/on_apply(mob/living/carbon/human/sufferer = victim)
	RegisterSignal(sufferer, COMSIG_MOB_HUMAN_ITEM_HELD, PROC_REF(on_item_pickup))

/datum/hex/plunderer/on_remove(mob/living/carbon/human/sufferer = victim)
	UnregisterSignal(sufferer, COMSIG_MOB_HUMAN_ITEM_HELD)

/mob/living/carbon/human/put_in_hand(obj/item/item)
	. = ..()
	if(.)
		SEND_SIGNAL(src, COMSIG_MOB_HUMAN_ITEM_HELD, item)

/datum/hex/plunderer/proc/on_item_pickup(datum/source, obj/item/item)
	SIGNAL_HANDLER

	if(downgrading || QDELETED(item)) // ensure multiple plunderer hexes play nice with each other
		return

	var/static/list/downgrade_tree = list( // ROS becomes dorpel, dorpel becomes blortz, blortz becomes opal, etc...
		// Coins are handled elsewhere, since we have many subtypes of coins for piles
		// Gems
		/obj/item/riddleofsteel = /obj/item/roguegem/diamond,
		/obj/item/roguegem/diamond = /obj/item/roguegem/blue,
		/obj/item/roguegem/blue = /obj/item/roguegem/opal,
		/obj/item/roguegem/opal = /obj/item/roguegem/turq,
		/obj/item/roguegem/turq = /obj/item/roguegem/coral,
		/obj/item/roguegem/coral = /obj/item/roguegem/violet,
		/obj/item/roguegem/violet = /obj/item/roguegem/jade,
		/obj/item/roguegem/jade = /obj/item/roguegem/green,
		/obj/item/roguegem/amber = /obj/item/roguegem/green,
		/obj/item/roguegem/green = /obj/item/roguegem/yellow,
		/obj/item/roguegem/yellow = /obj/item/roguegem/onyxa,
		/obj/item/roguegem/onyxa = /obj/item/pearl,
		/obj/item/pearl/blue = /obj/item/pearl,

		// Ingots
		/obj/item/ingot/blacksteel = /obj/item/ingot/silver,
		/obj/item/ingot/silverblessed/bullion = /obj/item/ingot/silver,
		/obj/item/ingot/silverblessed = /obj/item/ingot/silver,
		/obj/item/ingot/silver = /obj/item/ingot/steel,
		/obj/item/ingot/gold = /obj/item/ingot/steel,
		/obj/item/ingot/steelholy = /obj/item/ingot/steel,
		/obj/item/ingot/bronze = /obj/item/ingot/copper,
		/obj/item/ingot/steel = /obj/item/ingot/iron,
		/obj/item/ingot/iron = /obj/item/ingot/copper,
		/obj/item/ingot/tin = /obj/item/ingot/copper,

		// Misc Valuables
		/obj/item/candle/candlestick/silver = /obj/item/candle/candlestick/gold,
		/obj/item/candle/candlestick/silver/lit = /obj/item/candle/candlestick/gold,
		/obj/item/candle/candlestick/silver/single = /obj/item/candle/candlestick/gold/single,
		/obj/item/candle/candlestick/silver/single/lit = /obj/item/candle/candlestick/gold/single,
		/obj/item/candle/candlestick/gold = /obj/item/candle/candlestick/silver/single,
		/obj/item/candle/candlestick/gold/lit = /obj/item/candle/candlestick/silver/single,
		/obj/item/candle/candlestick/gold/single = /obj/item/candle/silver,
		/obj/item/candle/candlestick/gold/single/lit = /obj/item/candle/silver,
		/obj/item/candle/silver = /obj/item/candle/gold,
		/obj/item/candle/silver/lit = /obj/item/candle/gold,
		/obj/item/candle/gold = /obj/item/candle/yellow,
		/obj/item/candle/gold/lit = /obj/item/candle/yellow,

		/obj/item/kitchen/fork/silver = /obj/item/kitchen/fork/gold,
		/obj/item/kitchen/fork/gold = /obj/item/kitchen/fork/iron,
		/obj/item/kitchen/fork/iron = /obj/item/kitchen/fork,

		/obj/item/kitchen/spoon/silver = /obj/item/kitchen/spoon/gold,
		/obj/item/kitchen/spoon/gold = /obj/item/kitchen/spoon/iron,
		/obj/item/kitchen/spoon/iron = /obj/item/kitchen/spoon/,

		/obj/item/reagent_containers/glass/cup/silver = /obj/item/reagent_containers/glass/cup/golden,
		/obj/item/reagent_containers/glass/cup/golden = /obj/item/reagent_containers/glass/cup/silver/small,
		/obj/item/reagent_containers/glass/cup/silver/small = /obj/item/reagent_containers/glass/cup/golden/small,
		/obj/item/reagent_containers/glass/cup/golden/small = /obj/item/reagent_containers/glass/cup/bronzemug,
		/obj/item/reagent_containers/glass/cup/bronzemug = /obj/item/reagent_containers/glass/cup/wooden,
	)

	var/downgraded_result = downgrade_tree[item.type]

	if(istype(item, /obj/item/roguecoin/gold))
		downgraded_result = /obj/item/roguecoin/silver
	if(istype(item, /obj/item/roguecoin/silver))
		downgraded_result = /obj/item/roguecoin/copper
	if(istype(item, /obj/item/roguecoin/aalloy))
		downgraded_result = /obj/item/roguecoin/copper
	if(istype(item, /obj/item/rogue/painting))
		downgraded_result = /obj/item/ash

	if(!downgraded_result)
		return
	var/mob/living/carbon/human/holder = source
	if(!holder.is_holding(item))
		return

	downgrading = TRUE // multiple plunderer hexes should play nice with each other
	var/obj/item/new_downgraded_item = new downgraded_result(get_turf(holder))
	if(istype(item, /obj/item/roguecoin/))
		var/obj/item/roguecoin/coins_2_delete = item
		var/obj/item/roguecoin/coins_2_create = new_downgraded_item
		coins_2_create.set_quantity(coins_2_delete.quantity)
	holder.dropItemToGround(item)
	qdel(item)
	holder.put_in_hands(new_downgraded_item)

	downgrading = FALSE
