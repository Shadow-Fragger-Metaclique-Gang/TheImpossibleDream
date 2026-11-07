# Saintliness

**Tag:** `SAINTLINESS`

**Created in:**

**RELATED PRs:**

**Major changes:** Everyone who believes in anything is being (audibly) judged by their divine patrons.
This affects whether or not they're ressurectable or on the short road to Hell.
Acting against the wishes of your patron will damn you in their eyes, while pious acts will prove your worth.
Which is to say that you'll be unrevivable if you're too much of a sinner!
The inhumen are mostly exempt from this - but they'll claim you as their own if you're not already one of them.
Being saintly also makes the inhumen exempt you from certain... additional problems that come with revival.

This also gives pestra a few positive mood modifiers if they do... pestran things.

## Files

- `_saintliness.dme`: local includes
- `tgui\packages\tgui-panel\styles\tgchat\chat-dark.scss`: Added a special span class for the godspeech to this.
- `code\spans.dm`: The actual faith span class macro.
- `code\_patron.dm`: Extra on the base patron datum. Also slaps the saintliness components onto the corresponding patron.
- `code\components\_saintliness.dm`: Parent datum for all subsequent saintliness components. Contains all the lines for that specific patron's responses.
- `code\components\astrata.dm`: Astrata's listener component.
- `code\components\abyssor.dm`: Abyssor's listener component.
- `code\components\eora.dm`: Eora's listener component.
- `code\components\noc.dm`: Noc's listener component.
- `code\components\dendor.dm`: Dendor's listener component.
- `code\components\malum.dm`: Malum's listener component.
- `code\components\necra.dm`: Necra's listener component.
- `code\components\pestra.dm`: Pestra's listener component.
- `code\components\ravox.dm`: Ravox's listener component.
- `code\components\xylix.dm`: Xylix's listener component.
- `code\components\graggar.dm`: Graggar's listener component.
- `code\components\matthios.dm`: Matthios' listener component.
- `code\components\zizo.dm`: Zizo's listener component.
- `code\components\baotha.dm`: Baotha's listener component.
- `_signals.dm`: Faith-related signals for the saintliness components. Non-modular because it has to hook into events as they happen.
- `code\stress_positive.dm`: Adds a moodlet for pestrans, also non-modular because it has to be chuffed into the spot the relevant events happen.
- `code\defines.dm`: Integer constants rest here.
- `code\revive.dm`: Includes modular changes to the revive miracles
- `sexcon\control\sex_action.dm`: Adds fornication hooks to certain penetrative and LEWD sex acts.
- `organic_steps.dm`: Pestrans now feel happy if they incise into someone's flesh...


## Core files changed


