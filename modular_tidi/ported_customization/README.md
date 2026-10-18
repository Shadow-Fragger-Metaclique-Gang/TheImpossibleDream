# Ported Customizations

**Tag:** `PORTED_CUSTOMIZATION`

**Created in:**

**Major changes:** 4 new hairs. 1 new tiefling tail. 1 new tailmaw. made a few tiefling tails selectable as tailmaws.

Really what it says on the tin. Things like hairs, wings, tails, genital organs, etc etc ported from other servers.

## Files

- `_ported_customization.dme`: local includes
- `hair.dm`: appends to the existing "/datum/customizer_choice/bodypart_feature/hair/head/humanoid/ sprite_accessories" list the ported hairs, gives them their names and icon paths. do note that i have made a specific subtype for ported hairs, so that it is not necessary to copy & paste the entire modular filepath for every new hair.
- `tail.dm`: ditto, but for tails.
- `human_hair.dmi`: sprites for the ported hairs.
- `tiefling.dmi`: sprites for ported tiefling tails.

## Core files changed


