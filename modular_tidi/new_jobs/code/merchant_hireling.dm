/datum/job/roguetown/merchant_hireling
	title = "Merchant Mercenary"
	flag = MERCENARY
	department_flag = ATC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_sexes = list(MALE, FEMALE)
	tutorial = "The Merchant has hired you directly as a mercenary. You may choose from the same mercenary classes available to other sell-swords. You must not and cannot register on the Mercenary statue."
	display_order = JDO_MERCHANT_HIRELING
	selection_color = JCOLOR_ATC
	min_pq = 0
	max_pq = null
	round_contrib_points = 1
	townie_contract_gate_exempt = TRUE
	class_categories = TRUE
	advclass_cat_rolls = list(CTAG_MERCENARY = 20)
	job_traits = list(TRAIT_STEELHEARTED)
	always_show_on_latechoices = TRUE
	job_subclasses = list(
		/datum/advclass/mercenary/anthrax,
		/datum/advclass/mercenary/anthrax_assassin,
		/datum/advclass/mercenary/atgervi,
		/datum/advclass/mercenary/atgervi_shaman,
		/datum/advclass/mercenary/etrusca_condottiero,
		/datum/advclass/mercenary/etrusca_balestrieri,
		/datum/advclass/mercenary/desert_rider,
		/datum/advclass/mercenary/desert_rider_zeybek,
		/datum/advclass/mercenary/desert_rider_sahir,
		/datum/advclass/mercenary/desert_rider_almah,
		/datum/advclass/mercenary/forlorn,
		/datum/advclass/mercenary/vaquero,
		/datum/advclass/mercenary/freelancer,
		/datum/advclass/mercenary/freelancer_lancer,
		/datum/advclass/mercenary/freelancer_sabrist,
		/datum/advclass/mercenary/grenzelhoft,
		/datum/advclass/mercenary/grenzelhoft_halberdier,
		/datum/advclass/mercenary/grenzelhoft_crossbowman,
		/datum/advclass/mercenary/grenzelhoft_mage,
		/datum/advclass/mercenary/gronn,
		/datum/advclass/mercenary/gronn_heavy,
		/datum/advclass/mercenary/routier,
		/datum/advclass/mercenary/rumaclan,
		/datum/advclass/mercenary/rumaclan_sasu,
		/datum/advclass/mercenary/hangyaku,
		/datum/advclass/mercenary/chonin,
		/datum/advclass/mercenary/steppesman,
		/datum/advclass/mercenary/warscholar,
		/datum/advclass/mercenary/warscholar_pontifex,
		/datum/advclass/mercenary/warscholar_vizier,
		/datum/advclass/mercenary/blackoak,
		/datum/advclass/mercenary/blackoak_ranger,
		/datum/advclass/mercenary/blackoak_adept,
		/datum/advclass/mercenary/underdweller,
		/datum/advclass/mercenary/grudgebearer,
		/datum/advclass/mercenary/grudgebearer_soldier,
		/datum/advclass/mercenary/trollslayer,
		/datum/advclass/mercenary/lirvanmerc,
	)
	has_subprefs = TRUE
	default_subprefs = list("favorite_advclass" = null)

/// Gives the Merchant keyring, stored in a pack if one accepts it, otherwise left at their feet. Shared by the Merchant's Mercenary and the Dockers.
/proc/give_merchant_keyring(mob/living/carbon/human/H)
	H.equip_to_slot_if_possible(new /obj/item/storage/keyring/merchant(get_turf(H)), SLOT_IN_BACKPACK, FALSE, TRUE, FALSE, TRUE, TRUE)
