// LORD_OF_VANITY
/obj/item/clothing/suit/roguetown/armor/manual/meditation/body/duke
	name = "the lord's new clothes"
	desc = "The finest clothes in all the land, tailored at GREAT expense by a most wise and radiant lord. It's said they're invisible to only the dimwitted."
	body_parts_covered = COVERAGE_ALL_BUT_HANDLEGS|NECK
	body_parts_inherent = COVERAGE_ALL_BUT_HANDLEGS|NECK
	armor = ARMOR_BRONZE
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER
	repair_fraction = 0.35
	repairmsg_full = "Why yes, my clothing IS pristine isn't it?"
	repairmsg_end = "My clothes shimmer anew, as opulent as the day they were tailored."
	repairmsg_continue = "As I think on their radiance, my clothing mends some of its abuse."

/obj/item/clothing/suit/roguetown/armor/manual/meditation/chest/duke
	name = "the lord's new vest"
	desc = "A shimmering vest of magical cloth tailored exclusively for a most wise and fashionable lord. Invisible to the dullard."
	body_parts_covered = COVERAGE_VEST
	body_parts_inherent = COVERAGE_VEST
	armor = ARMOR_BRIGANDINE
	blocksound = SOFTHIT
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER
	repair_fraction = 0.35
	repairmsg_full = "Why yes, my vest IS pristine isn't it?"
	repairmsg_end = "My vest shimmers anew, as opulent as the day it was tailored."
	repairmsg_continue = "As I think on its radiance, my vest mends some of its abuse."

/obj/item/clothing/suit/roguetown/armor/manual/meditation/legs/duke
	name = "the lord's new hosen"
	desc = "An exquisite weave, apparent only to those of sufficient wit and breeding."
	slot_flags = ITEM_SLOT_PANTS
	body_parts_covered = LEGS|FEET
	body_parts_inherent = LEGS|FEET
	sleeved = null
	attachment_component = null
	armor = ARMOR_BRONZE
	max_integrity = ARMOR_INT_LEG_BRONZE
	repair_fraction = 0.35
	repairmsg_full = "Why yes, my pantaloons are pristine aren't they?"
	repairmsg_end = "My trousers shimmer anew, as opulent as the day they were tailored."
	repairmsg_continue = "As I think on their radiance, my hosen mend some of their abuse."

/obj/item/clothing/suit/roguetown/armor/manual/meditation/legs/duke/worn_on_body(mob/living/carbon/human/user)
	return ..() || user?.wear_pants == src
