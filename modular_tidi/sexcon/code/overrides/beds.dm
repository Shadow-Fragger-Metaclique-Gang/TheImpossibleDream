/obj/structure/bed/rogue
	var/broken_matress = FALSE
	var/broken_percentage = 0
	var/broken_rate = 1.0

/obj/structure/bed/rogue/proc/damage_bed(dam_value)
	if(broken_matress)
		playsound(src, pick(list('modular_tidi/sexcon/sounds/furniture/table (1).ogg','modular_tidi/sexcon/sounds/furniture/table (2).ogg','modular_tidi/sexcon/sounds/furniture/table (3).ogg','modular_tidi/sexcon/sounds/furniture/table (4).ogg')), 30, TRUE, ignore_walls = FALSE)
		return
	if(sleepy <= 2) // the bed is already pretty awful and broken (i.e: straw bed/bedroll), so don't break it even further
		return
	broken_percentage += (dam_value * broken_rate)
	if(broken_percentage >= 100) // bed broken
		broken_percentage = 100 // clamp
		broken_matress = TRUE
		sleepy = 1 //Worse than a bedroll, better than nothing
		visible_message(span_warning("\The [src] gives an violent snap. It looks broken!"))
		playsound(src, 'modular_tidi/sexcon/sounds/furniture/bed break.ogg', 50, TRUE, ignore_walls = FALSE)
		desc += " The bed looks stained and has seen better daes."
	else
		playsound(src, pick(list('modular_tidi/sexcon/sounds/furniture/bed squeak (1).ogg','modular_tidi/sexcon/sounds/furniture/bed squeak (2).ogg','modular_tidi/sexcon/sounds/furniture/bed squeak (3).ogg')), 25, TRUE, ignore_walls = FALSE)
		if(broken_percentage > 10)
			playsound(src, 'modular_tidi/sexcon/sounds/furniture/bed damage.ogg', broken_percentage>>2, TRUE, ignore_walls = FALSE)

/obj/structure/bed/rogue/inn/wooldouble
	broken_rate = 0.5

/obj/structure/bed/rogue/inn/double
	broken_rate = 0.5
