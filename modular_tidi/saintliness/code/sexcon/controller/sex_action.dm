// Doesn't actually check fornication, it just sends the signal to the involved mobs if they're fornicating
/datum/sex_action/fornication_check(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.marriedto != target.real_name || target.marriedto != user.real_name)
		SEND_SIGNAL(user, COMSIG_MOB_FORNICATION)
		SEND_SIGNAL(target, COMSIG_MOB_FORNICATION)

// None of the sex_actions call ..() so there's no use in overriding them. We'll have to do this all... one by one. Heh.
// Also only do this to the on_start proc because otherwise the fornication lines'll spam people
// Some might not like that (weirdos)


/datum/sex_action/anal_ride_sex/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	fornication_check(user, target)

/datum/sex_action/anal_sex/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	fornication_check(user, target)

/datum/sex_action/double_penetration_sex/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	fornication_check(user, target)

/datum/sex_action/slit_sex/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	fornication_check(user, target)

/datum/sex_action/throat_sex/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	fornication_check(user, target)

/datum/sex_action/vaginal_ride_sex/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	fornication_check(user, target)

/datum/sex_action/vaginal_sex/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	fornication_check(user, target)

/datum/sex_action/lick_ears/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	fornication_check(user, target)

/datum/sex_action/foot_lick/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	fornication_check(user, target)
// I'm not brave enough to do the rest of the forbidden sex acts. God save me.
