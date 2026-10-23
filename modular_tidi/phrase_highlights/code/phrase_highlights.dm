/proc/highlight_phrases(text)
	var/static/list/compiled
	var/static/last_input
	var/static/last_output
	if(text == last_input)
		return last_output
	if(!compiled)
		compiled = list()
		for(var/phrase in GLOB.phrase_highlights)
			var/regex/reg = regex("([REGEX_QUOTE(html_encode(phrase))])(?!\[^<\]*>)", "gi")
			compiled[reg] = "<span data-component=\"TooltipHTML\" data-html=\"[html_encode(GLOB.phrase_highlights[phrase])]\" style=\"color:#ad456d\">$1</span>"
	last_input = text
	for(var/regex/reg as anything in compiled)
		text = reg.Replace(text, compiled[reg])
	last_output = text
	return text

/atom/movable/say_quote(input, list/spans = list(speech_span), message_mode, plaintext_input)
	if(!input)
		return ..()
	if(isnull(plaintext_input))
		plaintext_input = input
		input = parsemarkdown_basic(input, limited = TRUE, barebones = TRUE)
	return ..(highlight_phrases(input), spans, message_mode, plaintext_input)
