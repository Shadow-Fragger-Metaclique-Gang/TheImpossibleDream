/datum/map_adjustment
	realm_name = "Pharos"

/datum/quirk/wellknown
	desc = "I may not be a resident of Pharos myself, but I spend enough time in and around the city that my face and name are known."

/datum/taxsetter
	good_announcement_text = "The Generous Count Decrees"
	bad_announcement_text = "The Tyrannical Count Dictates"

/datum/special_trait/punkprincess
	name = "Rebellous Daughter"
	greet_text = span_notice("I am quite rebellious for an heiress. Screw Noble Customs!")
	req_text = "Be an heiress"
	allowed_sexes = list(FEMALE)
	allowed_jobs = list(/datum/job/roguetown/prince)
	weight = 50
