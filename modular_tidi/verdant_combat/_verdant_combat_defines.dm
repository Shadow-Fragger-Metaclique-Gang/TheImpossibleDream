#define AP_NONE		0
#define AP_LIGHT	30
#define AP_MEDIUM	55
#define AP_HEAVY	75
#define AP_BSTEEL	100

#define AP_TO_PEN_TIER(ap) (((ap) >= AP_LIGHT) + ((ap) >= AP_MEDIUM) + ((ap) >= AP_HEAVY) + ((ap) >= AP_BSTEEL))
#define STAT_MOD(stat) floor(((stat) - 10) / 2)
#define ARMOR_DEGRADATION_CLASS(clothing) ((clothing).armor_class == ARMOR_CLASS_NONE ? (clothing).integ_armor_mod : (clothing).armor_class)
#define NORMALIZE_ARMOR_TYPE(d_type) (GLOB.armor_type_by_bclass[d_type] || (d_type))
#define CANONICAL_INTEGRITY_ZONE(def_zone) GLOB.canonical_integrity_zones[def_zone]

// Armor integrity degradation multipliers - blunt damage
#define ARMOR_DEGR_BLUNT_LIGHT 0.5
#define ARMOR_DEGR_BLUNT_MEDIUM 0.75
#define ARMOR_DEGR_BLUNT_HEAVY 1.5

// Armor integrity degradation multipliers - cutting damage
#define ARMOR_DEGR_CUT_LIGHT 1.25
#define ARMOR_DEGR_CUT_MEDIUM 0.75
#define ARMOR_DEGR_CUT_HEAVY 0.5

// Armor integrity degradation multipliers - piercing damage
#define ARMOR_DEGR_PIERCE_LIGHT 0.75
#define ARMOR_DEGR_PIERCE_MEDIUM 1.0
#define ARMOR_DEGR_PIERCE_HEAVY 0.75

#define ACC_RANGED_FARSIGHT_SKILL_REDUCTION 1.5
#define ACC_RANGED_FARSIGHT_MIN 1

#undef RANGED_PER_DAMAGE_BASELINE
#undef RANGED_PER_DAMAGE_SOFTCAP
#undef RANGED_PER_DAMAGE_MULT
#undef RANGED_PER_DAMAGE_CAPPEDMULT
#undef RANGED_PER_DAMAGE_FLOOR

#define BCLASS_FROST		"frost"
#define BCLASS_ELECTRICAL	"electrical"
#define BCLASS_ACID			"acid"

#undef STRONG_STANCE_DMG_BONUS
#undef WEAK_STANCE_DMG_MULT
#undef STRONG_SHP_BONUS
#define STRONG_SHP_BONUS 1
#undef STRONG_INTG_BONUS
#define STRONG_INTG_BONUS 2

#define BLUNT_DEFAULT_PENFACTOR		1
#define STR_PEN_FACTOR			2
#define PER_PEN_FACTOR		2
#define INTENT_BASE_AP			10

#define INTENT_PEN_NONE				0
#define INTENT_PEN_TRACE			0.25
#define INTENT_PEN_GLANCING			0.5
#define INTENT_PEN_BASIC			1
#define INTENT_PEN_BASIC_PLUS		1.25
#define INTENT_PEN_SOLID			1.5
#define INTENT_PEN_KEEN				1.75
#define INTENT_PEN_STRONG			2
#define INTENT_PEN_STRONG_PLUS		2.25
#define INTENT_PEN_PIERCING			2.5
#define INTENT_PEN_PIERCING_PLUS	2.85
#define INTENT_PEN_PUNCTURE			3
#define INTENT_PEN_PUNCTURE_PLUS	3.75
#define INTENT_PEN_ARMOR_BREAKER	4

#define BLUNT_AP_MOD_LIGHT -10
#define BLUNT_AP_MOD_MEDIUM -6
#define BLUNT_AP_MOD_HEAVY 26

/// Damage variance range, in percent, for bows, crossbows and slings.
#define RANGED_VARIANCE_RANGE 20
/// Variance percentile at or below which a hit announces as weak.
#define VARIANCE_LOW_PERCENTILE 10
/// Variance percentile at or above which a hit announces as strong.
#define VARIANCE_HIGH_PERCENTILE 90
#define SPELL_VARIANCE_LOW 15
#define SPELL_VARIANCE_MID 25
#define SPELL_VARIANCE_HIGH 40

#undef SHARPNESS_ONHIT_DECAY
#define SHARPNESS_ONHIT_DECAY		1	//Sharpness decay on parry.

#undef UNARMED_DAMAGE_DEFAULT
#define UNARMED_DAMAGE_DEFAULT		12
#undef UNARMED_DAMAGE_CIVILBARB

#undef TEMPO_CULL_DELAY
#undef TEMPO_DELAY_ONE
#undef TEMPO_DELAY_TWO
#undef TEMPO_DELAY_MAX
#undef TEMPO_CAP
#undef TEMPO_MAX
#undef TEMPO_TWO
#undef TEMPO_ONE
#undef TEMPO_TAG_STAMLOSS_PARRY
#undef TEMPO_TAG_STAMLOSS_DODGE
#undef TEMPO_TAG_ARMOR_INTEGFACTOR
#undef TEMPO_TAG_NOLOS_PARRY
#undef TEMPO_TAG_NOLOS_DODGE
#undef TEMPO_TAG_DEF_SHARPNESSFACTOR
#undef TEMPO_TAG_DEF_INTEGFACTOR
#undef TEMPO_TAG_PARRYCD_BONUS
#undef TEMPO_TAG_RCLICK_CD_BONUS
#undef TEMPO_TAG_FEINTBAIT_FOV
#undef TEMPO_TAG_DEF_BONUS
#undef TEMPO_TAG_DODGE_LOSS
#undef TEMPO_DODGE_LOSS_NORMAL
#undef TEMPO_DODGE_LOSS_LESS
#undef TEMPO_DODGE_LOSS_NONE
#undef TEMPO_TAG_BINDABLE
#undef TEMPO_TAG_EQUIPTOSS
#undef TEMPO_FACTION_KEEP
#undef TEMPO_FACTION_WRETCH
#undef TEMPO_FACTION_CHURCH

#undef CONSTITUTION_BLEEDRATE_MOD
#define CONSTITUTION_BLEEDRATE_MOD 0.025	//How much slower we'll be bleeding for every CON point. 0.1 = 10% slower.
#define FEMORAL_ARTERY_BLEEDRATE 35
/// Bleed curve exponent while conscious.
#define CONSCIOUS_BLEED_PRESSURE_EXPONENT 0.3
/// Internal bleed curve exponent while conscious.
#define CONSCIOUS_INTERNAL_BLEED_PRESSURE_EXPONENT 0.8
/// External bleed fraction in shock.
#define SHOCK_BLEED_FRACTION 0.02
/// Internal bleed fraction in shock.
#define SHOCK_INTERNAL_BLEED_FRACTION 0.015
/// Flat shock blood loss per tick.
#define SHOCK_BLEED_FLAT 1.45
/// Delay before a pierced heart crashes blood pressure.
#define HEART_BP_CRASH_DELAY (10 SECONDS)
/// Time before frostbite drops a limb.
#define FROSTBITE_LOOSE_WARNING (3 MINUTES)
/// Impact damage per tile of knockback left.
#define SMASH_IMPACT_DAMAGE_PER_TILE 5
/// Most knockback tiles that count toward impact damage.
#define SMASH_IMPACT_MAX_TILES 6
/// Infection chance added by a filthy weapon, an animal attacker or a bite.
#define INFECTION_FILTHY_BONUS 5
/// Infection chance added by a deadite attacker.
#define INFECTION_DEADITE_BONUS 5
/// Infection chance added by standing in sewer, swamp or bloody water.
#define INFECTION_FOUL_WATER_BONUS 3
/// Infection chance removed per point of CON above 10, and added per point below.
#define INFECTION_CON_PER_POINT 1
#define INFECTION_STAGE_INFECTED 1
#define INFECTION_STAGE_FESTERING 2
#define INFECTION_STAGE_NECROTIC 3
#define INFECTION_STAGE_SKELETAL 4
/// A gap between living infection ticks longer than this pauses the infection's clock for the gap.
#define INFECTION_CLOCK_PAUSE_GAP (10 SECONDS)
/// Shortest time, before the CON modifier, for a fresh infection to fester, and for a corpse's flesh to become infected.
#define INFECTION_FESTER_MIN_TIME (10 MINUTES)
/// Longest time, before the CON modifier, for a fresh infection to fester, and for a corpse's flesh to become infected.
#define INFECTION_FESTER_MAX_TIME (20 MINUTES)
/// The corpse rot processor ticks every 30 seconds, so only a longer gap pauses a corpse's infection clocks.
#define CORPSE_ROT_CLOCK_GAP (75 SECONDS)
/// Time an NPC corpse stays bare bone before it crumbles to dust.
#define CORPSE_DUST_DELAY (8 MINUTES)
#define ZOMBIE_RISE_MIN_TIME (5 MINUTES)
#define ZOMBIE_RISE_MAX_TIME (10 MINUTES)
#define ZOMBIE_EARLY_ROT_SPEED 2
#define ZOMBIE_FESTERING_ROT_SPEED 4
/// Time between pain emotes from punching heavy armor bare-handed.
#define PUNCH_RECOIL_PAIN_COOLDOWN (5 SECONDS)
/// Oxygen damage per tick from a nicked heart.
#define HEART_PENETRATION_OXYLOSS 5.25
/// Amount of organ damage that counts as a nicked heart.
#define HEART_PENETRATION_NICK_DAMAGE 40
/// How sharply heart oxygen damage grows with organ damage.
#define HEART_PENETRATION_OXYLOSS_EXPONENT 2.2

#undef STANDING_DECAP_GRACE_PERIOD
#undef CRIT_ARMOUR_THRESHOLD
#undef CRIT_RESISTANCE_STACKS_PLAYER
#undef CRIT_RESISTANCE_STACKS_NPC
#undef CRIT_RESISTANCE_STACKS_OP
#undef CRIT_RESISTANCE_EFFECTIVE_BLEEDRATE
#undef CRIT_RESISTANCE_TIMER_CD

// #define HUGBOX

#ifndef HUGBOX
	/// Crit chance multiplier on an undamaged limb.
	#define CRIT_CURVE_FRESH_MULT		0.03
	/// Limb damage fraction at which crits reach full chance.
	#define CRIT_CURVE_FULL_FRACTION	0.75
	/// Shape of the ramp between fresh (undamaged) and full crit chance (75%+ damage).
	#define CRIT_CURVE_EXPONENT			2
	/// A single hit dealing at least this plus the target's CON ignores the curve.
	#define CRIT_CURVE_OVERKILL			90
	/// Flat multiplier on every crit chance.
	#define CRIT_CHANCE_GLOBAL_MULT		0.75
	#define CRIT_SPELL_MULT				0.5
	/// Organ penetration chance multiplier for projectiles.
	#define CRIT_PROJECTILE_ORGAN_MULT	0.5
#endif

#ifdef HUGBOX
	#define CRIT_LIMB_DISLOCATION_DIVISOR		0.5
	#define CRIT_LIMB_DISLOCATION_THRESHOLD		CRIT_OVERKILL_THRESHOLD_EASY
	#define CRIT_LIMB_FRACTURE_DIVISOR			0.6
	#define CRIT_LIMB_FRACTURE_THRESHOLD		CRIT_OVERKILL_THRESHOLD_NORMAL

	#define CRIT_GROIN_FRACTURE_DIVISOR			0.7
	#define CRIT_GROIN_FRACTURE_THRESHOLD		CRIT_OVERKILL_THRESHOLD_NORMAL

	#define CRIT_CHEST_FRACTURE_DIVISOR			0.6
	#define CRIT_CHEST_FRACTURE_THRESHOLD		CRIT_OVERKILL_THRESHOLD_NORMAL
	#define CRIT_CBT_DIVISOR					0.3
	#define CRIT_CBT_THRESHOLD					CRIT_OVERKILL_THRESHOLD_EASY

	#define CRIT_ARTERY_DIVISOR					0.5
	#define CRIT_ARTERY_THRESHOLD				CRIT_OVERKILL_THRESHOLD_EASY
	#define CRIT_ARTERY_CHEST_DIVISOR			0.6
	#define CRIT_ARTERY_CHEST_THRESHOLD			CRIT_OVERKILL_THRESHOLD_NORMAL
	#define CRIT_DISEMBOWEL_DIVISOR				0.6
	#define CRIT_DISEMBOWEL_THRESHOLD			CRIT_OVERKILL_THRESHOLD_HARD
	#define CRIT_SCARRING_DIVISOR				0.4
	#define CRIT_SCARRING_THRESHOLD				CRIT_OVERKILL_THRESHOLD_EASY

	#define CRIT_BURN_DIVISOR					0.5
	#define CRIT_BURN_THRESHOLD					CRIT_OVERKILL_THRESHOLD_HARD

	#define CRIT_NECK_DISLOCATION_DIVISOR		1.0
	#define CRIT_NECK_DISLOCATION_THRESHOLD		CRIT_OVERKILL_THRESHOLD_HARD
	#define CRIT_NECK_FRACTURE_DIVISOR			1.0
	#define CRIT_NECK_FRACTURE_THRESHOLD		CRIT_OVERKILL_THRESHOLD_HARD
	#define CRIT_HEAD_FRACTURE_DIVISOR			0.65
	#define CRIT_HEAD_FRACTURE_THRESHOLD		CRIT_OVERKILL_THRESHOLD_NORMAL
	#define CRIT_SKULL_FRACTURE_DIVISOR			0.7
	#define CRIT_SKULL_FRACTURE_THRESHOLD		CRIT_OVERKILL_THRESHOLD_HARD
	#define CRIT_FACE_FRACTURE_DIVISOR			0.4
	#define CRIT_FACE_FRACTURE_THRESHOLD		CRIT_OVERKILL_THRESHOLD_EASY
	#define CRIT_MOUTH_FRACTURE_DIVISOR			0.3
	#define CRIT_MOUTH_FRACTURE_THRESHOLD		CRIT_OVERKILL_THRESHOLD_EASY

	#define CRIT_ARTERY_NECK_DIVISOR			0.6
	#define CRIT_ARTERY_NECK_THRESHOLD			CRIT_OVERKILL_THRESHOLD_NORMAL
	#define CRIT_FACIAL_STAB_DIVISOR			0.4
	#define CRIT_FACIAL_STAB_THRESHOLD			CRIT_OVERKILL_THRESHOLD_EASY

	#define CRIT_CHEST_ORGAN_STAB_DIVISOR		0.7
	#define CRIT_CHEST_ORGAN_STAB_THRESHOLD		CRIT_OVERKILL_THRESHOLD_NORMAL
	#define CRIT_CHEST_ORGAN_SLASH_DIVISOR		0.8
	#define CRIT_CHEST_ORGAN_SLASH_THRESHOLD	CRIT_OVERKILL_THRESHOLD_HARD
	#define CRIT_CHEST_ORGAN_BLUNT_DIVISOR		0.75
	#define CRIT_CHEST_ORGAN_BLUNT_THRESHOLD	CRIT_OVERKILL_THRESHOLD_VERY_HARD

	#define CRIT_BRAIN_PENETRATION_DIVISOR		0.8
	#define CRIT_BRAIN_PENETRATION_THRESHOLD	CRIT_OVERKILL_THRESHOLD_VERY_HARD
	#define CRIT_BRAIN_BLUNT_DIVISOR			0.8
	#define CRIT_BRAIN_BLUNT_THRESHOLD			CRIT_OVERKILL_THRESHOLD_NORMAL

	// Overkill threshold base values
	#define CRIT_OVERKILL_THRESHOLD_EASY		85
	#define CRIT_OVERKILL_THRESHOLD_NORMAL		90
	#define CRIT_OVERKILL_THRESHOLD_HARD		95
	#define CRIT_OVERKILL_THRESHOLD_VERY_HARD	100
#else
	#define CRIT_LIMB_DISLOCATION_DIVISOR		0
	#define CRIT_LIMB_DISLOCATION_THRESHOLD		0
	#define CRIT_LIMB_FRACTURE_DIVISOR			0
	#define CRIT_LIMB_FRACTURE_THRESHOLD		0

	#define CRIT_GROIN_FRACTURE_DIVISOR			0
	#define CRIT_GROIN_FRACTURE_THRESHOLD		0

	#define CRIT_CHEST_FRACTURE_DIVISOR			0
	#define CRIT_CHEST_FRACTURE_THRESHOLD		0
	#define CRIT_CBT_DIVISOR					0
	#define CRIT_CBT_THRESHOLD					0

	#define CRIT_ARTERY_DIVISOR					0
	#define CRIT_ARTERY_THRESHOLD				0
	#define CRIT_ARTERY_CHEST_DIVISOR			0
	#define CRIT_ARTERY_CHEST_THRESHOLD			0
	#define CRIT_DISEMBOWEL_DIVISOR				0
	#define CRIT_DISEMBOWEL_THRESHOLD			0
	#define CRIT_SCARRING_DIVISOR				0
	#define CRIT_SCARRING_THRESHOLD				0

	#define CRIT_BURN_DIVISOR					0
	#define CRIT_BURN_THRESHOLD					0

	#define CRIT_NECK_DISLOCATION_DIVISOR		0
	#define CRIT_NECK_DISLOCATION_THRESHOLD		0
	#define CRIT_NECK_FRACTURE_DIVISOR			0
	#define CRIT_NECK_FRACTURE_THRESHOLD		0
	#define CRIT_HEAD_FRACTURE_DIVISOR			0
	#define CRIT_HEAD_FRACTURE_THRESHOLD		0
	#define CRIT_SKULL_FRACTURE_DIVISOR			0
	#define CRIT_SKULL_FRACTURE_THRESHOLD		0
	#define CRIT_FACE_FRACTURE_DIVISOR			0
	#define CRIT_FACE_FRACTURE_THRESHOLD		0
	#define CRIT_MOUTH_FRACTURE_DIVISOR			0
	#define CRIT_MOUTH_FRACTURE_THRESHOLD		0

	#define CRIT_ARTERY_NECK_DIVISOR			0
	#define CRIT_ARTERY_NECK_THRESHOLD			0
	#define CRIT_FACIAL_STAB_DIVISOR			0
	#define CRIT_FACIAL_STAB_THRESHOLD			0

	#define CRIT_CHEST_ORGAN_STAB_DIVISOR		0
	#define CRIT_CHEST_ORGAN_STAB_THRESHOLD		0
	#define CRIT_CHEST_ORGAN_SLASH_DIVISOR		0
	#define CRIT_CHEST_ORGAN_SLASH_THRESHOLD	0
	#define CRIT_CHEST_ORGAN_BLUNT_DIVISOR		0
	#define CRIT_CHEST_ORGAN_BLUNT_THRESHOLD	0

	#define CRIT_BRAIN_PENETRATION_DIVISOR		0
	#define CRIT_BRAIN_PENETRATION_THRESHOLD	0
	#define CRIT_BRAIN_BLUNT_DIVISOR			0
	#define CRIT_BRAIN_BLUNT_THRESHOLD			0

	#define CRIT_OVERKILL_THRESHOLD_EASY		0
	#define CRIT_OVERKILL_THRESHOLD_NORMAL		0
	#define CRIT_OVERKILL_THRESHOLD_HARD		0
	#define CRIT_OVERKILL_THRESHOLD_VERY_HARD	0
#endif

/// From /obj/item/organ/proc/Insert() (mob/living/carbon/receiver, obj/item/organ/inserted, special)
#define COMSIG_MOB_ORGAN_INSERTED "mob_organ_inserted"

#define SURGERY_CONSTRUCT (1<<8)

#define PARRY_DISARM 2

#define CHOKE_OXY_RECOVERY_PER_TICK 1.25

#undef BRAIN_DAMAGE_DEATH
#define BRAIN_DAMAGE_DEATH 100

#define GIANT_WEAPON			(1<<17) // Weapon designed for giants - requires double STR for non-giants

#define span_electrical(str) ("<span class='electrical'>" + (str) + "</span>")
#define span_bone_grey(str) ("<span class='bone_grey'>" + (str) + "</span>")
#define span_infection_purple(str) ("<span class='infection_purple'>" + (str) + "</span>")
#define span_frostbite(str) ("<span class='frostbite'>" + (str) + "</span>")
#define span_charred(str) ("<span class='charred'>" + (str) + "</span>")
#define span_acid(str) ("<span class='acid'>" + (str) + "</span>")

#define TRAIT_GIANT_WEAPON_WIELDER "Giant Weapon Wielder" // Allows use of giant weapons without doubling minstr
#define TRAIT_FILTHY_WEAPON "filthy_weapon"
#define TRAIT_BP_CRASH "bp_crash" // Blood pressure has crashed.
