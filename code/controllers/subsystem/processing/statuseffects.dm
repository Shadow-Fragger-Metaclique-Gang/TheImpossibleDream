PROCESSING_SUBSYSTEM_DEF(statuseffects)
	name = "Status Effects"
	wait = 2
	stat_tag = "STE"
	processing_flag = PROCESSING_STATUSEFFECTS
	/// Whole-decisecond world.time -> list of status effects to wake at that time
	var/alist/wake_buckets = alist()
	/// Last bucket key already woken; -1 until the first wake is scheduled
	var/last_wake_key = -1

/datum/controller/subsystem/processing/statuseffects/fire(resumed = 0)
	if(!resumed)
		run_wakes()
	return ..()

/datum/controller/subsystem/processing/statuseffects/proc/schedule_wake(datum/status_effect/effect, wake_time)
	var/key = CEILING(wake_time, 1)
	if(last_wake_key < 0)
		last_wake_key = round(world.time) - 1
	var/list/bucket = wake_buckets[key]
	if(!bucket)
		bucket = list()
		wake_buckets[key] = bucket
	bucket += effect
	effect.wake_key = key

/datum/controller/subsystem/processing/statuseffects/proc/cancel_wake(datum/status_effect/effect)
	var/key = effect.wake_key
	effect.wake_key = null
	var/list/bucket = wake_buckets[key]
	if(!bucket)
		return
	bucket -= effect
	if(!length(bucket))
		wake_buckets -= key

/datum/controller/subsystem/processing/statuseffects/proc/run_wakes()
	if(last_wake_key < 0)
		return
	for(var/key in last_wake_key + 1 to CEILING(world.time, 1))
		var/list/bucket = wake_buckets[key]
		if(!bucket)
			continue
		wake_buckets -= key
		for(var/datum/status_effect/effect as anything in bucket)
			effect.wake_key = null
			if(!QDELETED(effect))
				effect.expire()
	last_wake_key = round(world.time)
