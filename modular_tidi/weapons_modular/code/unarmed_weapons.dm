// Weapon overwrites

/obj/item/rogueweapon/handclaw/steel/graggaredged
	possible_item_intents = list(/datum/intent/claw/cut/steel, /datum/intent/claw/lunge/steel, /datum/intent/claw/rend/steel)

/obj/item/rogueweapon/handclaw/ironclaw
	possible_item_intents = list(/datum/intent/claw/cut/iron, /datum/intent/claw/lunge/iron, /datum/intent/claw/rend)
	max_blade_int = 180 //nerfed compared to the gronn special claws

/obj/item/rogueweapon/handclaw
	wdefense = 5
	force = 30
	possible_item_intents = list(/datum/intent/claw/cut/iron, /datum/intent/claw/lunge/iron, /datum/intent/claw/rend)
	max_blade_int = 300

/obj/item/rogueweapon/handclaw/steel
	possible_item_intents = list(/datum/intent/claw/cut/steel, /datum/intent/claw/lunge/steel, /datum/intent/claw/rend/steel)

/obj/item/rogueweapon/handclaw/gronn
	desc = "A pair of uniquely reinforced iron claws forged with the addition of bone by the Iskarn shamans of the Northern Empty. \
			Their unique design aids them in slipping between the plates in armor and their light weight supports rapid aggressive slashes. \
			</br>'To see the claws of the four, Is to see the true danger of the north. Not man, Not land but beast. We are all prey in their eyes.'"
	possible_item_intents = list(/datum/intent/claw/cut/gronn, /datum/intent/claw/lunge/gronn, /datum/intent/claw/rend)

/obj/item/rogueweapon/handclaw/gronn/silver
	wdefense = 4
	possible_item_intents = list(/datum/intent/claw/cut/gronn, /datum/intent/claw/lunge/gronn, /datum/intent/claw/rend)
	wbalance = WBALANCE_SWIFT
	max_blade_int = 200

/obj/item/rogueweapon/handclaw/blacksteel
	possible_item_intents = list(/datum/intent/claw/cut/gronn, /datum/intent/claw/lunge/gronn, /datum/intent/claw/rend)


/datum/intent/claw/lunge
	name = "lunge"
	icon_state = "inimpale"
	attack_verb = list("lunges")
	animname = "stab"
	blade_class = BCLASS_STAB
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	item_d_type = "stab"

/datum/intent/claw/lunge/iron
	damfactor = 1.2
	swingdelay = 8
	clickcd = CLICK_CD_MELEE
	penfactor = PEN_HEAVY

/datum/intent/claw/lunge/steel
	damfactor = 1.2
	swingdelay = 12

//New or overwritten intents

/datum/intent/claw/lunge
	name = "lunge"
	icon_state = "inimpale"
	attack_verb = list("lunges")
	animname = "stab"
	blade_class = BCLASS_STAB
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	item_d_type = "stab"

/datum/intent/claw/lunge/iron
	damfactor = 1.2
	swingdelay = 8
	clickcd = CLICK_CD_MELEE
	penfactor = PEN_HEAVY

/datum/intent/claw/lunge/steel
	damfactor = 1.2
	swingdelay = 12
	clickcd = CLICK_CD_HEAVY
	penfactor = PEN_HEAVY

/datum/intent/claw/lunge/gronn
	damfactor = 1.1
	swingdelay = 5
	clickcd = CLICK_CD_QUICK
	penfactor = PEN_HEAVY

/datum/intent/claw/cut/iron
	penfactor = PEN_MEDIUM
	damfactor = 1.1
	clickcd = CLICK_CD_HEAVY

/datum/intent/claw/cut/steel
	penfactor = PEN_MEDIUM
	swingdelay = 4
	damfactor = 1.3
	clickcd = CLICK_CD_HEAVY

/datum/intent/claw/cut/gronn
	penfactor = PEN_MEDIUM
	swingdelay = 0
	damfactor = 1.1
	clickcd = CLICK_CD_MELEE
	intent_intdamage_factor = 1

/datum/intent/claw/rend/steel
	damfactor = 3

