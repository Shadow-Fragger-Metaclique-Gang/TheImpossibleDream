/client/verb/toggle_command_bar_button()
	set name = "toggle-command-bar-button"
	set hidden = TRUE

	var/current = winget(src, "outputwindow.input", "command")
	if(current == "say")
		set_command_bar_mode(FALSE)
	else
		set_command_bar_mode(TRUE)

/client/proc/set_command_bar_mode(say_mode = TRUE, silent = FALSE)
	if(say_mode)
		winset(src, "outputwindow.input", "command=say")
		winset(src, "outputwindow.saybutton", "text=Say;is-checked=true")
		if(!silent)
			to_chat(src, span_notice("Command bar set to <b>SAY</b> mode. All input goes to say."))
	else
		winset(src, "outputwindow.input", "command=")
		winset(src, "outputwindow.saybutton", "text=Cmd;is-checked=false")
		if(!silent)
			to_chat(src, span_notice("Command bar set to <b>COMMAND</b> mode. Type verbs directly (e.g. say, adminhelp, ooc)."))

/client/proc/setup_command_bar()
	winset(src, "outputwindow.saybutton", "is-visible=true")
	winset(src, "outputwindow.input", "anchor2=92,100")
	set_command_bar_mode(FALSE, silent = TRUE)
