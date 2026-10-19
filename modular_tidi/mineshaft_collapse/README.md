# MINESHAFT_COLLAPSE

**Tag:** `MINESHAFT_COLLAPSE`

**Created in:** https://github.com/Shadow-Fragger-Metaclique-Gang/TheImpossibleDream/pull/70

**Major changes:** https://github.com/Shadow-Fragger-Metaclique-Gang/TheImpossibleDream/pull/70

This adds dynamic cave-ins and mineshaft collapsing so mining isn't this bog-boring activity. Mineshaft supports can be propped up to prevent cave-ins, which require one log of wood to craft.

## Mineshaft Collapse

## Layout

- `_mine_collapse.dme`: local includes.
- `code/mine_collapse.dm`: The main logic for mineshaft cave-ins and handling the invisible trap - overrides the /turf/closed/mineral/turf_destruction() proc
- `code/mine_support.dm`: Mineshaft support item defines and crafting recipe
- `icons/mineshaft.dmi`: New icons for the cave-in warning symbol, and the mineshaft support
- `sounds/cavein.ogg`: Sound for cave-in trigger

## Core files changed

None.
