# Ported Customizations

**Tag:** `PORTED_CUSTOMIZATION`

**Created in:** https://github.com/Shadow-Fragger-Metaclique-Gang/TheImpossibleDream/pull/66

**RELATED PRs:** https://github.com/Shadow-Fragger-Metaclique-Gang/TheImpossibleDream/pull/68
				 https://github.com/Shadow-Fragger-Metaclique-Gang/TheImpossibleDream/pull/87

**Major changes:** Tons of ported hairstyles. 5 new tailmaws. 1 new tiefling tail. Tieflings get to choose wings now! Angel wings enabled.

Really what it says on the tin. Things like hairs, wings, tails, genital organs, etc etc ported from other servers.

**THIS MODULE IS PENDING RENAMING TO JUST "CUSTOMIZATION" SO IT CAN JUST BE A CATCH-ALL MODULE FOR ALL CUSTOMIZATION.**

## Files

- `_ported_customization.dme`: local includes
- `hair.dm`: appends to the existing "/datum/customizer_choice/bodypart_feature/hair/head/humanoid/ sprite_accessories" list the ported hairs, gives them their names and icon paths. do note that i have made a specific subtype for ported hairs, so that it is not necessary to copy & paste the entire modular filepath for every new hair.
- `tail.dm`: ditto, but for tails.
- `human_hair.dmi`: sprites for the ported hairs.
- `tiefling.dmi`: sprites for ported tiefling tails.
- `tiefling.dm`: enables wings for tieflings.
- `wings.dm`: dictates what wings tieflings can choose. enables angel wings.
## Core files changed
- `code/modules/mob/dead/new_player/sprite_accessory/wings.dm` LINE 165, Comments out EXTRA_STATE from succubus wings so that the ugly red detail gets disabled.

