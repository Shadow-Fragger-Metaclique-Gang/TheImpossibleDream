#define COMSIG_MOB_EJACULATED "comsig_mob_ejaculated"				//from base of /datum/sex_controller/proc/ejaculate()
#define COMSIG_SEX_JOSTLE "sex_jostle"

#define COMSIG_MOB_EMOTE "mob_emote"

#define COMSIG_LIVING_ATTACKED_BY "living_attacked_by"

#define MIN_PENIS_SIZE 1
#define MAX_PENIS_SIZE 3
#define DEFAULT_PENIS_SIZE 2

#define PENIS_TYPE_PLAIN 1
#define PENIS_TYPE_KNOTTED 2
#define PENIS_TYPE_EQUINE 3
#define PENIS_TYPE_TAPERED 4
#define PENIS_TYPE_TAPERED_DOUBLE 5
#define PENIS_TYPE_TAPERED_DOUBLE_KNOTTED 6
#define PENIS_TYPE_BARBED 7
#define PENIS_TYPE_BARBED_KNOTTED 8
#define PENIS_TYPE_TENTACLE 9
#define PENIS_TYPE_TAPERED_KNOTTED 10
#define PENIS_TYPE_EQUINE_KNOTTED 11

#define SHEATH_TYPE_NONE 0
#define SHEATH_TYPE_NORMAL 1
#define SHEATH_TYPE_SLIT 2

#define ERECT_STATE_NONE 0
#define ERECT_STATE_PARTIAL 1
#define ERECT_STATE_HARD 2

#define MIN_TESTICLES_SIZE 1
#define MAX_TESTICLES_SIZE 3
#define DEFAULT_TESTICLES_SIZE 2

#define MIN_BREASTS_SIZE 0
#define MAX_BREASTS_SIZE 12
#define DEFAULT_BREASTS_SIZE 3
#define MIN_JIGGLE_BREASTS_SIZE 1
#define BREAST_JIGGLE_CYCLE (0.8 SECONDS)
#define BREAST_JIGGLE_MIN_DURATION 8
#define BREAST_JIGGLE_MAX_DURATION 100
#define BREAST_JIGGLE_FREE_DURATION 50
#define BREAST_JIGGLE_STAMINA_PER_SECOND 0.83
#define BREAST_JIGGLE_ENDLESS_STAMINA_MULT 3
#define BREAST_JIGGLE_HOP_HEIGHT 4
#define BREAST_JIGGLE_ENDLESS 0
#define BREAST_JIGGLE_PROMPT_STEP (BREAST_JIGGLE_CYCLE * 2)

#define EARS_NORMAL 0
#define EARS_SENSITIVE 1 //Should this be used for ANYTHING else - move it. / Also only works on ANTHROS for some reason

#define PENIS_SIZES_BY_NAME list(\
	"Small" = MIN_PENIS_SIZE,\
	"Average" = DEFAULT_PENIS_SIZE,\
	"Large" = MAX_PENIS_SIZE,\
	)

#define SHEATH_TYPES_BY_NAME list(\
	"No Sheath" = SHEATH_TYPE_NONE,\
	"Sheath" = SHEATH_TYPE_NORMAL,\
	"Slit" = SHEATH_TYPE_SLIT,\
	)

#define ERECT_STATES_BY_NAME list(\
	"Unaroused" = ERECT_STATE_NONE,\
	"Half-Aroused" = ERECT_STATE_PARTIAL,\
	"Aroused" = ERECT_STATE_HARD,\
	)

#define TESTICLE_SIZES_BY_NAME list(\
	"Small" = MIN_TESTICLES_SIZE,\
	"Average" = DEFAULT_TESTICLES_SIZE,\
	"Large" = MAX_TESTICLES_SIZE,\
	)

#define BREAST_SIZES_BY_NAME list(\
	"Flat" = 0,\
	"Slight" = 1,\
	"Small" = 2,\
	"Moderate" = 3,\
	"Large" = 4,\
	"Generous" = 5,\
	"Heavy" = 6,\
	"Massive" = 7,\
	"Heaping" = 8,\
	"Obscene" = 9,\
	)

#define COMPONENT_CANCEL_ATTACK (1<<0)
#define COMPONENT_CANCEL_SAY (1<<1)

#define islamia(A) (isliving(A) && istype(A:get_taur_tail(), /obj/item/bodypart/taur/lamia))
#define iscritter(A) (is_species(A, /datum/species/anthromorphsmall))

#define CHASTITY_MOVE_SOUND_DELAY 4
#define CHASTITY_HIGH_POP_THRESHOLD 120
#define CHASTITY_HIGH_POP_SOUND_MULT 0.4

#define COLLAR_LOG_SHOCK "shock"
#define COLLAR_LOG_FORCE_STRIP "force_strip"
#define COLLAR_LOG_HALLUCINATIONS "toggle_hallucinations"
#define COLLAR_LOG_SURRENDER "force_surrender"
#define COLLAR_LOG_AROUSAL "toggle_arousal"
#define COLLAR_LOG_LOVE "toggle_love"
#define COLLAR_LOG_CLOTHING "permit_clothing"
#define COLLAR_LOG_SPEECH "toggle_speech"
#define COLLAR_LOG_DENIAL "toggle_denial"

#define CHASTITY_LOG_IMPRINT "imprint"
#define CHASTITY_LOG_LOCK "lock"
#define CHASTITY_LOG_FRONT "front"
#define CHASTITY_LOG_ANAL "anal"
#define CHASTITY_LOG_SPIKES "spikes"
#define CHASTITY_LOG_FLAT "flat"

#define ORGAN_SLOT_PENIS "penis"
#define ORGAN_SLOT_TESTICLES "testicles"
#define ORGAN_SLOT_BREASTS "breasts"
#define ORGAN_SLOT_VAGINA "vagina"

#define BODYPART_FEATURE_CHASTITY "chastity"
#define BODYPART_FEATURE_PUBES "pubes"
#define BODYPART_FEATURE_PITS "pits"

#define BODY_HAIR_MATERIAL_HAIR 1
#define BODY_HAIR_MATERIAL_FUR 2
#define BODY_HAIR_MATERIAL_FEATHERS 3
#define BODY_HAIR_MATERIAL_FUZZ 4
#define BODY_HAIR_MATERIAL_BRAIDS 5

#define OFFSET_BREASTS "breasts"
#define OFFSET_BREASTS_F "breastsf"

GLOBAL_LIST_INIT(sex_actions, build_sex_actions())

#define SEX_ACTION(sex_action_type) GLOB.sex_actions[sex_action_type]

#define MAX_AROUSAL 150
#define PASSIVE_EJAC_THRESHOLD 108
#define ACTIVE_EJAC_THRESHOLD 100
#define SEX_MAX_CHARGE 300
#define CHARGE_FOR_CLIMAX 100
#define AROUSAL_HARD_ON_THRESHOLD 20
#define CHARGE_RECHARGE_RATE (CHARGE_FOR_CLIMAX / (5 MINUTES))
#define AROUSAL_TIME_TO_UNHORNY (5 SECONDS)
#define SPENT_AROUSAL_RATE (3 / (1 SECONDS))
#define IMPOTENT_AROUSAL_LOSS_RATE (3 / (1 SECONDS))

#define AROUSAL_HIGH_UNHORNY_RATE (1.5 / (1 SECONDS))
#define AROUSAL_MID_UNHORNY_RATE (0.4 / (1 SECONDS))
#define AROUSAL_LOW_UNHORNY_RATE (0.2 / (1 SECONDS))

#define MOAN_COOLDOWN 3 SECONDS
#define PAIN_COOLDOWN 6 SECONDS

#define SEX_SPEED_LOW 1
#define SEX_SPEED_MID 2
#define SEX_SPEED_HIGH 3
#define SEX_SPEED_EXTREME 4
#define SEX_SPEED_LUDICROUS 5

#define SEX_SPEED_MIN 1
#define SEX_SPEED_MAX 5

#define SEX_FORCE_LOW 1
#define SEX_FORCE_MID 2
#define SEX_FORCE_HIGH 3
#define SEX_FORCE_EXTREME 4
#define SEX_FORCE_LUDICROUS 5

#define SEX_FORCE_MIN 1
#define SEX_FORCE_MAX 5

#define SEX_MANUAL_AROUSAL_DEFAULT 1
#define SEX_MANUAL_AROUSAL_UNAROUSED 2
#define SEX_MANUAL_AROUSAL_PARTIAL 3
#define SEX_MANUAL_AROUSAL_FULL 4

#define SEX_MANUAL_AROUSAL_MIN 1
#define SEX_MANUAL_AROUSAL_MAX 4

#define PAIN_MILD_EFFECT 10
#define PAIN_MED_EFFECT 20
#define PAIN_HIGH_EFFECT 30
#define PAIN_MINIMUM_FOR_DAMAGE PAIN_MED_EFFECT
#define PAIN_DAMAGE_DIVISOR 50

#define IMPREG_PROB_DEFAULT 25
#define IMPREG_PROB_INCREMENT 10
#define IMPREG_PROB_MAX 95

#define SEX_CATEGORY_NULL 0
#define SEX_CATEGORY_MISC (1<<0)
#define SEX_CATEGORY_HANDS (1<<1)
#define SEX_CATEGORY_PENETRATE (1<<2)

#define SEX_PART_NULL 0
#define SEX_PART_COCK (1<<0)
#define SEX_PART_CUNT (1<<1)
#define SEX_PART_ANUS (1<<2)
#define SEX_PART_JAWS (1<<3)
#define SEX_PART_SLIT_SHEATH (1<<4)
#define SEX_PART_BREASTS (1<<5)
#define SEX_PART_FOOT (1<<6) // any foot
#define SEX_PART_FEET (1<<7) // BOTH feet
#define SEX_PART_CHEST (1<<8) // distinct from SEX_PART_BREASTS, which checks for breasts as opposed to just the chest being exposed
#define SEX_PART_BALLS (1<<9)
#define SEX_PART_GROIN (1<<10) // requires groin exposed but no particular organ
#define SEX_PART_TAIL (1<<11) // requires a tail we can use to penetrate with
#define SEX_PART_TAIL_MAW (1<<12) // requires a manticore tail, works like freeuse, groin covered or uncovered

#define ALL_KNOTTABLE_SEX_PARTS (SEX_PART_CUNT | SEX_PART_ANUS | SEX_PART_JAWS | SEX_PART_SLIT_SHEATH)

#define SEX_ACTION_INTIMATE_CHECK_NONE 0
#define SEX_ACTION_INTIMATE_CHECK_USER (1<<0)
#define SEX_ACTION_INTIMATE_CHECK_TARGET (1<<1)
#define SEX_ACTION_INTIMATE_CHECK_BOTH (SEX_ACTION_INTIMATE_CHECK_USER|SEX_ACTION_INTIMATE_CHECK_TARGET)

#define KNOTTED_NULL 0
#define KNOTTED_AS_TOP 1
#define KNOTTED_AS_BTM 2

/proc/build_sex_actions()
	. = list()
	for(var/path in typesof(/datum/sex_action))
		if(is_abstract(path))
			continue
		.[path] = new path()
	return .

/////////////////

// Called when a bodypart is checked from an action: /datums/sexcon/sexcon.dm
#define COMSIG_ERP_LOCATION_ACCESSIBLE "erp_location_accessible"
	// Bitflags
	#define SIG_CHECK_FAIL (1 << 0)
	#define SKIP_ADJACENCY_CHECK (1 << 1)
	#define SKIP_TILE_CHECK (1 << 2)
	#define SKIP_GRAB_CHECK (1 << 3)
	// Args
	#define ERP_ACTION 1
	#define ERP_BODYPART 2
	#define ERP_SELF_TARGET 3
	#define ERP_USER 4
	#define ERP_TARGET 5
	#define ERP_LOCATION 6
	#define ERP_GRABS 7
	#define ERP_SKIPUNDIES 8

#define SFX_COLLARJINGLE list('sound/items/jinglebell1.ogg',\
							'sound/items/jinglebell2.ogg',\
							'sound/items/jinglebell3.ogg',\
							'sound/items/jinglebell4.ogg',\
							'modular_tidi/sexcon/sounds/jingle/jinglebell5.ogg',\
							'modular_tidi/sexcon/sounds/jingle/jinglebell6.ogg')
#define SFX_CBJINGLE list('modular_tidi/sexcon/sounds/jingle/cbjingle1.ogg',\
							'modular_tidi/sexcon/sounds/jingle/cbjingle2.ogg',\
							'modular_tidi/sexcon/sounds/jingle/cbjingle3.ogg')

#define TRAIT_BATHHOUSE_DANCER "Bathhouse Dancer"
#define TRAIT_DEATHBYSNUSNU "Bed Breaker" //What do you think? Pelvis crushing and increased pain.
#define TRAIT_BROKEN_IN "Broken In"
#define TRAIT_BAOTHA_FERTILITY_BOON "Marked and shaped by Baotha" //Able to be impregnated, has permanent womb tattoo and stronger version of nympho vice
#define TRAIT_CHASTITY_FULL "Chastity Belt" //Prevents most penetrative sexual activity. Given by chastity belt.
#define TRAIT_CHASTITY_CAGE "Chastity Cage" //Prevents most penis action sexual activity. Given by chastity cage.
#define TRAIT_CHASTITY_PENIS_BLOCKED "Penis Shielded"
#define TRAIT_CHASTITY_VAGINA_BLOCKED "Vagina Shielded"
#define TRAIT_CHASTITY_ANAL "Anal Shield" //Prevents penetrative anal sex. Given by a chastity device with an anal shield.
#define TRAIT_CHASTITY_SPIKED "Genital Spikes" // Causes discomfort during arousal.
#define TRAIT_CHASTITY_LOCKED "Locked Chastity Device" // Prevents removal of the chastity device.

#define TRAIT_SOURCE_CHASTITY "chastity" //source for chastity device traits
#define TRAIT_LOVESTRUCK "lovestruck"

#define MOB_DESCRIPTOR_SLOT_PUBES 16
#define MOB_DESCRIPTOR_SLOT_PITS 17

// Collar and chastity signals, arguments are the carbon mob and the item that was gained or lost
#define COMSIG_CARBON_GAIN_COLLAR "carbon_gain_collar"
#define COMSIG_CARBON_LOSE_COLLAR "carbon_lose_collar"
#define COMSIG_CARBON_GAIN_CHASTITY "carbon_gain_chastity"
#define COMSIG_CARBON_LOSE_CHASTITY "carbon_lose_chastity"

///Chastity state changed on a wearer (mob/living/carbon/human/wearer, obj/item/chastity/device, reason)
#define COMSIG_CARBON_CHASTITY_STATE_CHANGED "carbon_chastity_state_changed"

///Intimate accessory state changed on a wearer (mob/living/carbon/human/wearer, obj/item/intimate_accessory/device, reason)
#define COMSIG_CARBON_INTIMATE_STATE_CHANGED "carbon_intimate_state_changed"

/// Standardized received-sex-action hook emitted on the receiving carbon (mob/living/carbon/human/acting_mob, datum/sex_controller/acting_sexcon, datum/sex_action/action, receiver_part, giving, arousal_amt, pain_amt, applied_force, applied_speed)
#define COMSIG_CARBON_SEX_ACTION_RECEIVED "carbon_sex_action_received"

/// Pre-validation hook emitted on an involved carbon during sex action menu/execution checks (datum/sex_action/action, mob/living/carbon/human/other, checked_part, is_user_role, menu_check)
#define COMSIG_CARBON_SEX_ACTION_VALIDATE "carbon_sex_action_validate"
	/// Return to hide or block the action.
	#define COMPONENT_SEX_ACTION_BLOCK (1<<0)

/// Pre-command hook for collar masters targeting a pet (mob/living/carbon/human/pet, datum/component/collar_master/controller, command_id, command_value)
#define COMSIG_CARBON_COLLAR_COMMAND "carbon_collar_command"
	/// Return to block execution of a collar command.
	#define COMPONENT_COLLAR_COMMAND_BLOCK (1<<0)
	#define COLLAR_COMMAND_SHOCK "shock"
	#define COLLAR_COMMAND_FORCE_STRIP "force_strip"
	#define COLLAR_COMMAND_FORCE_SURRENDER "force_surrender"
	#define COLLAR_COMMAND_TOGGLE_AROUSAL "toggle_arousal"
	#define COLLAR_COMMAND_TOGGLE_SPEECH "toggle_speech"
	#define COLLAR_COMMAND_TOGGLE_DENIAL "toggle_denial"
	#define COLLAR_COMMAND_SET_CHASTITY_LOCK "set_chastity_lock"
	#define COLLAR_COMMAND_SET_CHASTITY_FRONT_MODE "set_chastity_front_mode"
	#define COLLAR_COMMAND_SET_CHASTITY_ANAL_OPEN "set_chastity_anal_open"
	#define COLLAR_COMMAND_SET_CHASTITY_SPIKES "set_chastity_spikes"
	#define COLLAR_COMMAND_SET_CHASTITY_FLAT "set_chastity_flat"

/// Fired when a pet is released/cleaned up from collar control (mob/living/carbon/human/pet, datum/component/collar_master/controller)
#define COMSIG_CARBON_COLLAR_RELEASED "carbon_collar_released"

/// Called before a cursed collar finalizes on a wearer (mob/living/carbon/human/wearer, datum/mind/master, obj/item/clothing/neck/roguetown/cursed_collar/collar)
#define COMSIG_CARBON_COLLAR_BIND_ATTEMPT "carbon_collar_bind_attempt"
	/// Return to prevent the collar from binding.
	#define COMPONENT_COLLAR_BIND_BLOCK (1<<0)

/// Called after a cursed collar binds successfully (mob/living/carbon/human/wearer, datum/mind/master, obj/item/clothing/neck/roguetown/cursed_collar/collar)
#define COMSIG_CARBON_COLLAR_BOUND "carbon_collar_bound"

/// Called before lock state manipulation on chastity devices (mob/living/carbon/human/wearer, mob/living/actor, obj/item/source_item, new_locked_state, method)
#define COMSIG_CARBON_CHASTITY_LOCK_INTERACT "carbon_chastity_lock_interact"
	/// Return to prevent lock state changes from key/lockpick interactions.
	#define COMPONENT_CHASTITY_LOCK_INTERACT_BLOCK (1<<0)

/// Called after lock state changes on chastity devices (mob/living/carbon/human/wearer, mob/living/actor, obj/item/source_item, new_locked_state, method)
#define COMSIG_CARBON_CHASTITY_LOCK_CHANGED "carbon_chastity_lock_changed"

#define CHASTITY_HARDMODE_DISABLED 0
#define CHASTITY_HARDMODE_ENABLED 1

/// Root directory for all chastity flavor-text JSON banks.
/// Used by pick_chastity_string() and anywhere a raw strings() call targets the chastity string dir.
#define CHASTITY_STRINGS_PATH "modular_tidi/sexcon/strings"

/// Picks a random entry from a chastity string bank.
/// Usage: pick_chastity_string("chastity_lock_messages.json", "chastity_lock_denial")
#define pick_chastity_string(FILE, KEY) (pick(strings(FILE, KEY, CHASTITY_STRINGS_PATH)))

#define STATS_KNOTTED "knottings"
#define STATS_KNOTTED_NOT_LUPIANS "knottings_by_non_lupians"
#define STATS_IMPREGNATIONS "impregnations"
