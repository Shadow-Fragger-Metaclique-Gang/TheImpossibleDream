/datum/intent/mace/smash/flailchop
	name = "pendulous chop"
	icon_state = "inchop"
	attack_verb = list("chops", "hacks")
	chargetime = 1.2 SECONDS
	recovery = 40
	damfactor = 1.3
	reach = 2
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	penfactor = PEN_MEDIUM
	chargedloop = /datum/looping_sound/flailswing
	keep_looping = TRUE
	blade_class = BCLASS_CHOP
	item_d_type = "slash"

/datum/intent/dagger/sucker_punch/drow
	name = "stern rebuttal"
	icon_state = "inpunch"
	desc = "Bust your target's nose with a swift-and-sudden jab. Often called an underdark handshake."
	attack_verb = list("punches", "jabs", "clocks")
	animname = "strike"
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/punch/punch_hard (1).ogg', 'sound/combat/hits/punch/punch_hard (2).ogg', 'sound/combat/hits/punch/punch_hard (3).ogg')
	damfactor = 0.8 //basically just bash, but flavored as a punch
	penfactor = PEN_NONE
	clickcd = 14
	recovery = 10
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR
	canparry = TRUE
	candodge = TRUE

/obj/item/rogueweapon/flail/peasantwarflail/stalker
	name = "spined drow greatflail"
	desc = "A pendulous, bladed, and spined orb of dark mithril hung from a thorned link of chains. For more robustly built drow caviliers, there is \
	nothing quite as potent as these fearsome greatflails. The spikes have a nasty habit of gumming up with gore; this is intentional."
	icon = 'modular_tidi/drow_mercs/icons/drowblunt64.dmi'
	icon_state = "drowgreatflail"
	possible_item_intents = list(/datum/intent/flail/strike)
	gripped_intents = list(/datum/intent/flail/strikerange, /datum/intent/flail/smash/ranged, /datum/intent/mace/smash/flailchop, /datum/intent/flail/sweep)
	associated_skill = /datum/skill/combat/whipsflails
	resistance_flags = FIRE_PROOF// weapon of war, not a thresher
	minstr = 12
	wdefense = 5
	max_integrity = 300
	anvilrepair = /datum/skill/craft/weaponsmithing
	special = /datum/special_intent/greatsword_swing// put that blade to use
	bigboy = TRUE

/obj/item/rogueweapon/flail/peasantwarflail/stalker/alt
	name = "drow greatflail"
	desc = "A pendulous orb of dark mithril hung from a thorned link of chains. For more robustly built drow caviliers, there is \
	nothing quite as potent as these fearsome greatflails."
	icon_state = "drowgreatflailb"
	possible_item_intents = list(/datum/intent/flail/strike/matthiosflail)//we use the better intents here since it's fully focused on blunt damage
	gripped_intents = list(/datum/intent/flail/strike/matthiosflail, /datum/intent/flail/smash/matthiosflail, /datum/intent/flail/sweep)
	minstr = 13// no jaluck twinks allowed!
	wdefense = 4// not as scary looking so worse defense idk
	special = /datum/special_intent/greatflail_swing// greatflail special tho!
	bigboy = TRUE

/datum/intent/spear/cut/bardiche/cleave/chop
	name = "cleaving chop"
	blade_class = BCLASS_CHOP
	attack_verb = list("chops", "hacks")
	animname = "chop"
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	penfactor = PEN_MEDIUM
	item_d_type = "slash"

/obj/item/rogueweapon/halberd/bardiche/stalker
	name = "drow bardiche"
	desc = "While similar to the iron bardiche wielded by petty drow raiders, this elegant polearm cut a far more striking image. \
	Finely forged and superbly balanced, the bardiche of a drow cavalier can cleave through enemy chaff both one-handed on spiderback \
	& two-handed on foot."
	icon = 'modular_tidi/drow_mercs/icons/drowpolearms64.dmi'
	icon_state = "drowbardiche"
	force = 25
	force_wielded = 28//-2 force
	possible_item_intents = list(SPEAR_THRUST, /datum/intent/spear/cut/glaive, /datum/intent/axe/chop/scythe)
	gripped_intents = list(/datum/intent/spear/thrust/drow_glaive, /datum/intent/spear/cut/glaive/sweep, /datum/intent/spear/cut/bardiche/cleave/chop)
	wdefense = 4//-2 def given how good it's intents are
	max_blade_int = 160//-40 blade integ
	smeltresult = /obj/item/ingot/steel
	slot_flags = ITEM_SLOT_BACK//Option-unique, uncraftable. Ensures the loadout doesn't implode on itself.
	equip_delay_self = 2 SECONDS
	unequip_delay_self = 2 SECONDS
	inv_storage_delay = 1 SECONDS

/obj/item/rogueweapon/halberd/bardiche/stalker/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 2,"nx" = 8,"ny" = 2,"wx" = -4,"wy" = 2,"ex" = 1,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 300,"wturn" = 32,"eturn" = -23,"nflip" = 0,"sflip" = 100,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 4,"sy" = -2,"nx" = -3,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)

/datum/intent/sword/disarm/range
	name = "reaching disarm"
	reach = 2

/datum/intent/sword/cut/sabre/slow
	clickcd = 12
	damfactor = 1.25//Better than rapier (Base is 1.1 for swords)
	penfactor = PEN_LIGHT//Very slight buff to pen on cut mode. Still weaker then sword-chop mode.

/obj/item/rogueweapon/sword/long/rhomphaia/stalker
	name = "drow aruval"
	desc = "For underdark outsiders, drow smithing can seem a competition for who can put the most spikes and hooks on a weapon; \
	this aruval is the logical end of that philosophy. This curved blade sports a backcurved tip, a hooked claw on the back edge, \
	and a piercing spike near its gilded crossguard."
	icon = 'modular_tidi/drow_mercs/icons/drowswords64.dmi'
	icon_state = "drowaruval"
	sheathe_icon = "drowaruval"
	force = 25
	force_wielded = 25//good damage both wielded and unweilded, but lower than greatswords and rhomphaia proper
	max_integrity = 200//50 more than the standard rhomphaia
	possible_item_intents = list(/datum/intent/sword/cut/falx, /datum/intent/sword/thrust/hook, /datum/intent/sword/chop/falx, /datum/intent/sword/disarm)
	gripped_intents = list(/datum/intent/sword/cut/zwei, /datum/intent/sword/chop/militia, /datum/intent/pick/bad, /datum/intent/sword/disarm/range)//longer range, two hands on sword makes for better chop, if slower. Shitty pick using our weird spikes
	alt_grips = null
	wdefense_wbonus = 4
	bigboy = TRUE
	special = /datum/special_intent/shin_swipe

/obj/item/rogueweapon/sword/long/shotel/stalker
	name = "drow shotel"
	desc = "A darkly shimmering shotel of drowsmith. While reminescent of the more commonly used drow falx, \
	the shotels superior reach and light weight make it a favorite of Crocs de l'araignée Cavaliers who seek \
	the reach of a polearm with the speed of a sword."
	icon = 'modular_tidi/drow_mercs/icons/drowswords64.dmi'
	icon_state = "drowshotel"
	sheathe_icon = "drowshotel"
	alt_grips = null
	possible_item_intents = list(/datum/intent/sword/cut/zwei, /datum/intent/sword/chop/long, /datum/intent/dagger/sucker_punch/drow)
	gripped_intents = list(/datum/intent/sword/cut/zwei, /datum/intent/sword/chop/long, /datum/intent/dagger/sucker_punch/drow)
	force = 27
	force_wielded = 27//doesn't get buffed to 30 like normal shotel
	max_integrity = 175//tiny bit more integ since it's unique
	bigboy = TRUE
	special = /datum/special_intent/shin_swipe

/obj/item/rogueweapon/sword/sabre/hook/stalker
	icon = 'modular_tidi/drow_mercs/icons/drowswords64.dmi'
	pixel_x = -16
	pixel_y = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	name = "drow hook sword"
	desc = "A darkly shimmering hook sword of drowsmith. While reminescent of the more commonly used drow falx, \
	the hook swords sport a far more aggressive curve that allows the wielder to hook and pull the weapons from the hands of their enemies. \
	Historically, the hook sword was employed by Crocs de l'araignée Cavaliers tasked with quelling slave rebellions, easily dispatching \
	the makeshift weapons of would-be freemen."
	icon_state = "drowhooksword"
	sheathe_icon = "drowhook"
	possible_item_intents = list(/datum/intent/sword/cut/sabre, /datum/intent/sword/thrust/hook, /datum/intent/dagger/sucker_punch/drow, /datum/intent/sword/disarm)
	force = 22//+2 over normal hooksword
	max_integrity = 175//tiny bit more integ since it's unique
	bigboy = TRUE

/obj/item/rogueweapon/sword/falx/stalker
	icon = 'modular_tidi/drow_mercs/icons/drowswords32.dmi'
	name = "stalker falx"
	desc = "A jagged blade with an inward edge. A popular choice for drow warriors, the falx is adept at slicing through the armor of men and the flesh of lessers."
	icon_state = "spiderfalx"
	sheathe_icon = "spidersaber"
	wbalance = WBALANCE_SWIFT
	possible_item_intents = list(/datum/intent/sword/cut/falx,  /datum/intent/sword/chop/falx, /datum/intent/dagger/sucker_punch/drow, /datum/intent/rend)
	force = 25// same as elf sabre
	wdefense = 5//-1, use it with a shield

/obj/item/rogueweapon/sword/long/elf/stalker
	name = "drow greatsabre"
	desc = "A large, curved blade sporting a single cutting edge and a blunted spine affixed with a piercing spike. \
	While not near as elaborate as other drow blades, the simple strength of the greatsabre makes it adept at cleaving through armor, chitin, and bone alike."
	icon = 'modular_tidi/drow_mercs/icons/drowswords64.dmi'
	icon_state = "drowsword"
	sheathe_icon = "drowgreatsabre"
	force = 25
	force_wielded = 30
	max_integrity = 200
	possible_item_intents = list(/datum/intent/sword/cut/sabre/slow, /datum/intent/sword/thrust/sabre, /datum/intent/rend, /datum/intent/dagger/sucker_punch/drow)// better to use your fist than dent that pretty pommel
	gripped_intents = list(/datum/intent/sword/cut/sabre/slow, /datum/intent/pick/bad, /datum/intent/sword/chop/sabre, /datum/intent/dagger/sucker_punch/drow)//shitty pick using our spiked bit.
	alt_grips = null // nope!
	bigboy = TRUE

/obj/item/rogueweapon/sword/long/kriegmesser/stalker
	name = "drow kriegsmesser"
	desc = "A wickedly sharp two-handed sword of drow smith. While you'd never get one to admit it, this blade was \
	undoubtedly inspired by the grenzelhoftian kriegmesser. The drow version features more gilding than its surface-dwelling cousin, \
	alongside brutal serration found on many drow blades."
	icon = 'modular_tidi/drow_mercs/icons/drowswords64.dmi'
	icon_state = "drowmesser"
	sheathe_icon = "drowmesser"
	possible_item_intents = list(/datum/intent/sword/cut/krieg, /datum/intent/sword/chop/falx, /datum/intent/rend/krieg, /datum/intent/dagger/sucker_punch/drow)
	gripped_intents = list(/datum/intent/sword/cut/krieg, /datum/intent/sword/chop/militia, /datum/intent/rend/krieg, /datum/intent/dagger/sucker_punch/drow)
	alt_grips = null// Can't mordhau this
	max_integrity = 175// less integ than the real deal, not near as much as the kazen messers
	bigboy = TRUE

/obj/item/rogueweapon/sword/long/stalker//what if estoc but longsword?
	name = "drow longsword"
	desc = "A long, darkly shimmering blade of drowsmith. While looking familiar to the standard longsword, \
	the use case is far less versatile. Swords of this kind feature rigidly straight blades, uncharacteristic of drowsmith, and are primarily used as a hunting tool. \
	Regardless of its intended use, a weapon that can puncture the chitin of underdwelling arachnids can just as easily pierce a man's armor."
	icon = 'modular_tidi/drow_mercs/icons/drowswords64.dmi'
	icon_state = "drowlongsword"
	sheathe_icon = "drowlongsword"
	force = 25
	force_wielded = 27
	possible_item_intents = list(/datum/intent/sword/thrust, /datum/intent/sword/cut/rapier, /datum/intent/dagger/sucker_punch/drow)
	gripped_intents = list(/datum/intent/sword/thrust/estoc, /datum/intent/sword/thrust/estoc/lunge, /datum/intent/sword/cut/rapier, /datum/intent/dagger/sucker_punch/drow)
	alt_grips = null// you wouldn't dare dent that gilded crossguard with a mordhau, would you?
	bigboy = TRUE
	special = /datum/special_intent/piercing_lunge

/obj/item/rogueweapon/whip/urumi/spider
	icon = 'modular_tidi/drow_mercs/icons/drowwhips32.dmi'
	name = "drow urumi"
	desc = "Two darkly shimmering and flexible blades coiling outwards from a gilded hilt wrapped with a small piece of spider-silk. \
	The knuckleguarded handle betrays the weapon's grim purpose: to bring the enemies of the drow to their knees, be it through blade or bludgeon."
	icon_state = "spider_urumi"
	force = 31//+1, same as spider whip
	minstr = 10
	max_integrity = 150
	wdefense = 0
	possible_item_intents = list(/datum/intent/whip/lash/drow_urumi, /datum/intent/whip/crack/drow_urumi, /datum/intent/whip/thrust/drow_urumi, /datum/intent/dagger/sucker_punch/drow)
	max_blade_int = 100
	anvilrepair = /datum/skill/craft/weaponsmithing
	sewrepair = FALSE
	smeltresult = /obj/item/ingot/steel
	special = /datum/special_intent/greatsword_swing

/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow/stalker
	name = "gilded drow crossbow"
	desc = "A stripped-down crossbow specifically made for the small engagement ranges of the Underdark and caverns. A practical tool of the Drow assassin - \
	a lady's friend is a man's end. The machining is finely tuned, and the whole of the bow is ornamented in gold - a symbol of rank among drow markswomen."
	icon = 'modular_tidi/drow_mercs/icons/drowmisc32.dmi'
	icon_state = "drowcrossbowgilded0"
	item_state = "drowcrossbowgilded"
	possible_item_intents = list(/datum/intent/shoot/crossbow/slurbow, /datum/intent/arc/crossbow/slurbow, INTENT_GENERIC)
	damfactor = 0.7
	accfactor = 1.3
	reloadtime = 20
	hasloadedsprite = TRUE
	movingreload = TRUE
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_HIP
	penfactor = PEN_LIGHT // One tier above the ordinary light-bolt slurbow in this fork's armor system.

/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow/stalker/lesser
	name = "drow crossbow"
	desc = "A stripped-down crossbow specifically made for the small engagement ranges of the Underdark and caverns. The body is well worn \
	and lacks the gilding one commonly sees on the equipment of established Drow warriors."
	icon = 'modular_tidi/drow_mercs/icons/drowmisc32.dmi'
	icon_state = "drowcrossbow0"
	item_state = "drowcrossbow"
	possible_item_intents = list(/datum/intent/shoot/crossbow/slurbow, /datum/intent/arc/crossbow/slurbow, INTENT_GENERIC)
	damfactor = 0.6
	accfactor = 1.3
	reloadtime = 20
	hasloadedsprite = TRUE
	movingreload = TRUE
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_HIP
	penfactor = PEN_NONE

/datum/intent/spear/thrust/drow_glaive
	damfactor = 1.1
	chargetime = 0

/datum/intent/whip/lash/drow_urumi
	name = "urumi lash"
	blade_class = BCLASS_CUT
	attack_verb = list("lashes", "slices")
	hitsound = list('sound/combat/hits/bladed/genslash (1).ogg', 'sound/combat/hits/bladed/genslash (2).ogg', 'sound/combat/hits/bladed/genslash (3).ogg')
	chargetime = 0.5 SECONDS
	penfactor = PEN_NONE
	item_d_type = "slash"
	no_early_release = TRUE

/datum/intent/whip/crack/drow_urumi
	name = "urumi crack"
	blade_class = BCLASS_CHOP
	attack_verb = list("cracks", "slashes")
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	chargetime = 0.9 SECONDS
	penfactor = PEN_LIGHT
	item_d_type = "slash"
	no_early_release = TRUE

/datum/intent/whip/thrust/drow_urumi
	name = "urumi thrust"
	blade_class = BCLASS_STAB
	attack_verb = list("thrusts", "skewers", "perforates")
	animname = "stab"
	icon_state = "instab"
	reach = 3
	chargetime = 1 SECONDS
	clickcd = CLICK_CD_CHARGED
	warnie = "mobwarning"
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = PEN_MEDIUM
	item_d_type = "stab"
	effective_range = 3
	effective_range_type = EFF_RANGE_EXACT
	no_early_release = TRUE

/obj/item/rogueweapon/sword/sabre/stalker
	icon = 'modular_tidi/drow_mercs/icons/drowswords32.dmi'
	icon_state = "spidersaber"
	sheathe_icon = "spidersaber"
	possible_item_intents = list(/datum/intent/sword/cut/sabre, /datum/intent/sword/thrust/sabre, /datum/intent/rend, /datum/intent/dagger/sucker_punch/drow)

/obj/item/rogueweapon/whip/spiderwhip
	icon = 'modular_tidi/drow_mercs/icons/drowwhips32.dmi'

/obj/item/rogueweapon/shield/tower/spidershield
	force = 25
	resistance_flags = FIRE_PROOF
	possible_item_intents = list(SHIELD_BASH_METAL, SHIELD_BLOCK, SHIELD_SMASH_METAL)
