# Customization

**Tag:** `CUSTOMIZATION`

**Created in:** https://github.com/Shadow-Fragger-Metaclique-Gang/TheImpossibleDream/pull/66

**RELATED PRs:** https://github.com/Shadow-Fragger-Metaclique-Gang/TheImpossibleDream/pull/68
				 https://github.com/Shadow-Fragger-Metaclique-Gang/TheImpossibleDream/pull/87
				 https://github.com/Shadow-Fragger-Metaclique-Gang/TheImpossibleDream/pull/107

**Major changes:** Bunchs of hairstyles. More 'succubus' themed tailmaws. Enables angel wings. Gives tieflings the ability to choose from two "devillish" wings.

## Files

- `_customization.dme`: local includes
- `hair.dm`: appends to the existing "/datum/customizer_choice/bodypart_feature/hair/head/humanoid/ sprite_accessories" list the hairs, gives them their names and icon paths. do note that i have made a specific subtype for hairs, so that it is not necessary to copy & paste the entire modular filepath for every new hair.
- `tail.dm`: ditto, but for tails.
- `human_hair.dmi`: sprites for the hairs.
- `tiefling.dmi`: sprites for tiefling tails.
- `tiefling.dm`: enables wings for tieflings.
- `wings.dm`: dictates what wings tieflings can choose. enables angel wings.
## Core files changed
- `code/modules/mob/dead/new_player/sprite_accessory/wings.dm` LINE 165, Comments out EXTRA_STATE from succubus wings so that the ugly red detail gets disabled.

