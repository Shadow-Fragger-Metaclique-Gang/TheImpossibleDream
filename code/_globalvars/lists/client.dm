GLOBAL_LIST_EMPTY(classic_keybinding_list_by_key)
GLOBAL_LIST_EMPTY(hotkey_keybinding_list_by_key)
GLOBAL_LIST_EMPTY(keybindings_by_name)

GLOBAL_LIST_EMPTY(mouseicons_human)

// This is a mapping from JS keys to Byond - ref: https://keycode.info/
GLOBAL_LIST_INIT(_kbMap, list(
	"UP" = "North",
	"RIGHT" = "East",
	"DOWN" = "South",
	"LEFT" = "West",
	"INSERT" = "Insert",
	"HOME" = "Northwest",
	"PAGEUP" = "Northeast",
	// [SURREALIS-EDIT] - PLASMA_OPTS
	// "DEL" = "Delete", // SURREALIS-EDIT - ORIGINAL
	"DELETE" = "Delete",
	// [/SURREALIS-EDIT]
	"END" = "Southwest",
	"PAGEDOWN" = "Southeast",
	" " = "Space",
	"ALT" = "Alt",
	"SHIFT" = "Shift",
	"CONTROL" = "Ctrl"
	))
