/obj/effect/proc_holder/spell/invoked/appraise/secular/pileappraisal
	name = "Pile Appraise"
	range = 1

/obj/effect/proc_holder/spell/invoked/appraise/secular/pileappraisal/cast(list/targets, mob/living/user)
	var/turf/T = get_turf(targets[1])
	var/totalvalue = 0
	var/divisor = input(user, "What percentage are they taking?", "Pile Appraisal", 100) as num
	divisor /= 100
	for(var/obj/O in T.contents)
		if(O.sellprice)
			totalvalue += O.get_real_price()
	to_chat(user, ("<font color='yellow'>That pile of items costs around [totalvalue] mammons. <br>Their cut is [totalvalue*divisor] mammons, leaving you [totalvalue-totalvalue*divisor] mammons.</font>"))
