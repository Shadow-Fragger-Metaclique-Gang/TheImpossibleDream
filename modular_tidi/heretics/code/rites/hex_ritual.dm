/datum/runeritual/god/hex
	abstract_type = /datum/runeritual/god/hex

/datum/runeritual/god/hex/cleanup_atoms(list/selected_atoms) // Removes EVERYTHING except the focus. The focus should ALWAYS be on N. And the doll should ALWAYS be on C.
	var/list/consumed_atoms = selected_atoms.Copy()
	consumed_atoms -= "N"
	return ..(consumed_atoms)
