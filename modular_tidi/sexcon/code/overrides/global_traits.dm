/datum/controller/global_vars/InitGlobalroguetraits()
	..()
	roguetraits += list(
		TRAIT_BATHHOUSE_DANCER = span_info("I am trained in the bathhouse arts. Within its walls I can dance and shake for a patron all night without tiring."),
		TRAIT_DEATHBYSNUSNU = "With strong intent, I am a violent partner in bed. Breaking pelvis and spirit alike.",
		TRAIT_BROKEN_IN = "Rough lovers can still hurt me, but it takes a lot more to make me whimper.",
		TRAIT_BAOTHA_FERTILITY_BOON = span_info("I have been marked by Baotha. I am branded visibly on my groin and am able to be impregnated regardless of physical states that would usually prevent this"),
		TRAIT_CHASTITY_FULL = span_info("My chastity device prevents me from engaging in most penetrative sex."),
		TRAIT_CHASTITY_CAGE = span_info("My chastity device prevents me getting an erection or engaging in penetrative sex."),
		TRAIT_CHASTITY_PENIS_BLOCKED = span_info("My chastity device blocks access to my penis."),
		TRAIT_CHASTITY_VAGINA_BLOCKED = span_info("My chastity device blocks access to my vagina."),
		TRAIT_CHASTITY_ANAL = span_info("My chastity device is equipped with a shield that protects my anus from penetration."),
		TRAIT_CHASTITY_SPIKED = span_info("My chastity device is equipped with spikes constantly pressing against my nethers."),
		TRAIT_CHASTITY_LOCKED = span_info("My chastity device is locked, it's impossible to remove without the key."),
	)

/datum/controller/global_vars/InitGlobaltraits_by_type()
	..()
	traits_by_type[/mob] += list(
		TRAIT_BATHHOUSE_DANCER,
		TRAIT_DEATHBYSNUSNU,
		TRAIT_BROKEN_IN,
		TRAIT_BAOTHA_FERTILITY_BOON,
		TRAIT_CHASTITY_FULL,
		TRAIT_CHASTITY_CAGE,
		TRAIT_CHASTITY_PENIS_BLOCKED,
		TRAIT_CHASTITY_VAGINA_BLOCKED,
		TRAIT_CHASTITY_ANAL,
		TRAIT_CHASTITY_SPIKED,
		TRAIT_CHASTITY_LOCKED,
		TRAIT_LOVESTRUCK,
	)
