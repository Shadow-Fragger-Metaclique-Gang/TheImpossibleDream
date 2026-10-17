/obj/item/rogueweapon/greatsword/avantyne/zizo
	name = "avantyne greatsword"
	desc = "No smith's hand shaped this. It was torn from a heretic's lux and set into the shape of the Demiurge's contempt, a greatblade that hungers for the wounds of lesser gods' faithful."
	force = 25
	force_wielded = 45
	max_blade_int = 600
	max_integrity = 600
	smeltresult = /obj/item/ingot/component/zizo

/obj/item/rogueweapon/greatsword/avantyne/zizo/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_CABAL, "SWORD")

/obj/item/rogueweapon/sword/rapier/avantyne/zizo
	name = "avantyne rapier"
	desc = "A needle of crystallized spite, drawn from a heretic's lux by the Demiurge's will alone. It does not parry so much as wait for the opening IT has already promised it."
	force = 30
	max_blade_int = 350
	max_integrity = 325
	smeltresult = /obj/item/ingot/component/zizo

/obj/item/rogueweapon/sword/rapier/avantyne/zizo/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_CABAL, "SWORD")

/obj/item/rogueweapon/spear/billhook/avantyne/zizo
	name = "avantyne billhook"
	desc = "A reaping hook wrought from a heretic's own lux, its edge curling like a beckoning finger. It was made to drag the faithful down from their pedestals, and it remembers."
	force = 35
	force_wielded = 40
	max_blade_int = 400
	max_integrity = 500
	smeltresult = /obj/item/ingot/component/zizo

/obj/item/rogueweapon/spear/billhook/avantyne/zizo/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_CABAL, "POLEARM")
