/datum/species/construct/metal
	is_subrace = FALSE

/datum/species/construct/metal
	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/crest,
		/datum/customizer/bodypart_feature/hair/head/humanoid,
		/datum/customizer/bodypart_feature/hair/facial/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
		/datum/customizer/bodypart_feature/underwear,
		/datum/customizer/bodypart_feature/legwear,
		/datum/customizer/organ/vagina/human_anthro,
		/datum/customizer/organ/ears/demihuman,
		/datum/customizer/organ/horns/demihuman,
		/datum/customizer/organ/tail/demihuman,
		/datum/customizer/organ/tail/manticore,
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/breasts/human,
		/datum/customizer/organ/testicles/anthro,
		)

	body_marking_sets = list(
		/datum/body_marking_set/none,
		/datum/body_marking_set/belly,
		/datum/body_marking_set/bellysocks,
		/datum/body_marking_set/tiger,
		/datum/body_marking_set/tiger_dark,
		/datum/body_marking_set/gradient,
		/datum/body_marking_set/construct_plating_light,
		/datum/body_marking_set/construct_plating_medium,
		/datum/body_marking_set/construct_plating_heavy,
	)
	body_markings = list(
		/datum/body_marking/flushed_cheeks,
		/datum/body_marking/eyeliner,
		/datum/body_marking/plain,
		/datum/body_marking/tiger,
		/datum/body_marking/tiger/dark,
		/datum/body_marking/sock,
		/datum/body_marking/socklonger,
		/datum/body_marking/tips,
		/datum/body_marking/bellyscale,
		/datum/body_marking/bellyscaleslim,
		/datum/body_marking/bellyscalesmooth,
		/datum/body_marking/bellyscaleslimsmooth,
		/datum/body_marking/buttscale,
		/datum/body_marking/belly,
		/datum/body_marking/bellyslim,
		/datum/body_marking/butt,
		/datum/body_marking/tie,
		/datum/body_marking/tiesmall,
		/datum/body_marking/backspots,
		/datum/body_marking/front,
		/datum/body_marking/drake_eyes,
		/datum/body_marking/tonage,
		/datum/body_marking/spotted,
		/datum/body_marking/nose,
		/datum/body_marking/harlequin,
		/datum/body_marking/harlequinreversed,
		/datum/body_marking/bangs,
		/datum/body_marking/bun,
		/datum/body_marking/gradient,
		/datum/body_marking/waist,
		/datum/body_marking/womb_tattoo,
		/datum/body_marking/butterfly,
		/datum/body_marking/construct_plating_light,
		/datum/body_marking/construct_plating_medium,
		/datum/body_marking/construct_plating_heavy,
		/datum/body_marking/construct_head_standard,
		/datum/body_marking/construct_head_round,
		/datum/body_marking/construct_standard_eyes,
		/datum/body_marking/construct_visor_eyes,
		/datum/body_marking/construct_psyclops_eye,
	)

#define CONSTRUCT_BRASS "dfbd6c"
#define CONSTRUCT_IRON "525352"
#define CONSTRUCT_STEEL  "babbb9"
#define CONSTRUCT_BRONZE "e2a670"
#define CONSTRUCT_COAL "1f1f1f"
#define CONSTRUCT_COBALT "323666"
#define CONSTRUCT_GRANITE "ff8f8f"
#define CONSTRUCT_JADE "517051"
#define CONSTRUCT_AMETHYST "3a0b3d"
#define CONSTRUCT_CORAL "ff96d6" //Pink
#define CONSTRUCT_LIMESTONE "e6e4d8" //Tan
#define CONSTRUCT_SILVER "94B9C0" //Ice grey, at least that's what microsoft paint says
#define CONSTRUCT_COPPER "b87333" //Orange
#define CONSTRUCT_GOLD "d4af37" //Gold
#define CONSTRUCT_RUST "B71F1F" //Dark red
#define CONSTRUCT_OBSIDIAN "19132a" //Black
#define CONSTRUCT_LAPIS "26619C" //Deep blue
#define CONSTRUCT_BASALT "474a4c" //Dark grey
#define CONSTRUCT_MARBLE "E6E6E6" //White
#define CONSTRUCT_TOPER "fffb9e"

/datum/species/construct/metal/get_skin_list()
	return list(
		"Brass" = CONSTRUCT_BRASS,
		"Iron" = CONSTRUCT_IRON,
		"Steel" = CONSTRUCT_STEEL,
		"Bronze" = CONSTRUCT_BRONZE,
		"Toper" = CONSTRUCT_TOPER,
		"Coal" = CONSTRUCT_COAL,
		"Cobalt" = CONSTRUCT_COBALT,
		"Granite" = CONSTRUCT_GRANITE,
		"Jade" = CONSTRUCT_JADE,
		"Amythortz" = CONSTRUCT_AMETHYST,
		"Silver" = CONSTRUCT_SILVER,
		"Coral" = CONSTRUCT_CORAL,
		"Gold" = CONSTRUCT_GOLD,
		"Limestone" = CONSTRUCT_LIMESTONE,
		"Copper" = CONSTRUCT_COPPER,
		"Rust" = CONSTRUCT_RUST,
		"Obsidian" = CONSTRUCT_OBSIDIAN,
		"Lapis" = CONSTRUCT_LAPIS,
		"Marble" = CONSTRUCT_MARBLE,
		"Basalt" = CONSTRUCT_BASALT,
	)
