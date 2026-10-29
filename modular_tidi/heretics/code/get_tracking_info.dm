// used for psydondiscern & yearn & bloodhound
/proc/get_tracking_info(atom/tracker, atom/target)
	var/turf/tracker_turf = get_turf(tracker)
	var/turf/target_turf = get_turf(target)

	if(!tracker_turf || !target_turf)
		return

	var/list/tracked_info = list(
		"direction" = dir2text(get_dir(tracker_turf, target_turf)), // returns the cardinal in full lowercase. plan accordingly.
		"distance" = get_dist(tracker_turf, target_turf), // returns -1 if you're on the same turf since it's the "same object"
		"z_level_difference" = target_turf.z - tracker_turf.z // Negative = BELOW	Positive = ABOVE 	0 = SAME Z
	)

	return tracked_info
