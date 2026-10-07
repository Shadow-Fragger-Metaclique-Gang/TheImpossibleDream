/datum/controller/subsystem/ticker
	realm_name = "Pharos and its Scar"
	realm_type = "County"
	realm_type_short = "County"
	rulertype = "Count"

/datum/controller/subsystem/librarian/get_book(input)
	if(input && !books.Find(input) && fexists("modular_tidi/lore/strings/books/[input]"))
		var/list/configuration = json_load("modular_tidi/lore/strings/books/[input]")
		books[input] = configuration["Contents"] || list()
	return ..()
