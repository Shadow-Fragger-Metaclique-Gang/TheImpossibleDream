# SEXCON

**Tag:** `SEXCON`

**Created in:** https://github.com/Shadow-Fragger-Metaclique-Gang/TheImpossibleDream/pull/23

**Major changes:**

## Sexcon One

Nukes AP's 'sexcon two' and replaces it with RW's 'sexcon one', includes most of RW's features relating both directly and loosely to the system.
Here's a non exhaustive list of things included in the module:

- All sex actions from RW, including some AP originals which have been rewritten for the new system.
- All sex preferences from RW.
- RW genital organs, sprites and customizers; AP's sprites still exist as a simple style for any that were replaced.
- RW body hair for armpits and pubes.
- Manticore tail maws (this honestly has way too much around it and probably should not have been ported lmao).
- Chastity devices and associated mechanics.
- Cursed collars, leashes and collar bells.
- RW's iteration of dildos and pegging.
- Branding iron.
- Marked by Baotha flaw and associated womb tattoo giving rite.
- Emberwine.
- Bondage stuff.
- Extra massive size for pintles, purchaseable with triumphs per spawn with it. Hey, I had to add something self-serving after porting chastity.

## Layout

- `_sexcon_defines.dm`: is non-modularly ticked in the .dme because we need our defines loaded early or else shit breaks.
- `_sexcon.dme`: the module's .dme, obviously.
- `code/controller`: the sex controller, sex action base, helpers and ERP panel datum.
- `code/sex_actions`: the actions.
- `code/organs`: genitals, body hair, tails, descriptors, etcetera.
- `code/chastity`, `code/collar`, `code/toys`, `code/items`, `code/components` and `code/species`: feature code.
- `code/overrides`: the amalgamate of proc, var, and everything else overrides so we can stay as modular as humanly possible.
- `icons`, `sounds` and `strings`: self explanatory, probably.

## Core files changed

Removed:

- All of `code/datums/sexcon2/`, `code/modules/sexcon/` and `code/__DEFINES/sex.dm`: Azure Peak's sexcon2, replaced by this module.
- `code/datums/mob_descriptors/descriptors/other.dm`: moved to `code/organs/genital_descriptors.dm`.
- `code/modules/mob/dead/new_player/sprite_accessory/genitals.dm`: moved to `code/organs/genital_sprites.dm`.
- `code/modules/client/customizer/customizers/organ/genitals.dm`: moved to `code/organs/genital_customizers.dm`.
- `modular/code/game/objects/items/lewd/dildo.dm`: moved to `code/toys/dildo.dm`.
- `code/modules/client/preferences_toggles.dm`: removal of the Toggle Full Examine verb in favor of keeping it always on, and moving the Toggle ERP Panel verb to the new Sensual subcategory with all of the other gooner toggles.

Hooks:

- `code/_onclick/hud/screen_objects.dm`: triumph use refills your balls.
- `code/_onclick/item_attack.dm`: thrillseeker stuff since it had to be rewritten for the new sex code, and so gnolls can hold branding irons.
- `code/datums/character_flaw/_character_flaw.dm`: new `no_random` var so you don't get lewd vices randomly.
- `code/datums/status_effects/rogue/roguebuff.dm`: fermented crab refills your balls.
- `code/game/objects/items/ritualcircles.dm`: new Baotha rite.
- `code/modules/mob/living/carbon/human/examine.dm`: chastity, brand and status lines. Details dropdown killing.
- `code/modules/mob/living/carbon/human/human.dm`: chastity middle-click and strip panel stuff.
- `code/modules/mob/living/carbon/human/update_icons.dm`: belt toy and chastity overlays.
- `code/modules/mob/living/combat/checkdefense.dm`: thrillseeker stuff.
- `code/modules/mob/living/living.dm`: resisting a leash.
- `code/modules/roguetown/floorinteraction.dm`: licking cum off the floor.
- `code/modules/spells/spell_types/wizard/utility/mirror_transform.dm`: all organs related to this module.
- `code/modules/surgery/bodyparts/bodypart_wounds.dm`: thrillseeker stuff.
- `interface/stylesheet.dm` and `tgui/packages/tgui-panel/styles/tgchat/chat-dark.scss`: the `love_ludicrous` text class.
- `roguetown.dme`: ticks `_sexcon_defines.dm`.

New TGUI files:

- `tgui/packages/tgui/interfaces/SurrealisSexSession/`: the ERP panel.
- `tgui/packages/tgui/interfaces/SurrealisTextInputNopaste.tsx`: text input that blocks pasting, for the permanent binding prayer.
- `tgui/packages/tgui/interfaces/CollarControl.tsx`: cursed collar controls.
- `tgui/packages/tgui/interfaces/PreferencesMenu/tabs/CharacterCreator/subtabs/Appearance/FeatureChoices/SurrealisFeatureChoicePenis.tsx`: feature choices.
- `tgui/packages/tgui/interfaces/PreferencesMenu/tabs/CharacterCreator/subtabs/Appearance/FeatureChoices/SurrealisFeatureChoiceBreasts.tsx`: feature choices.
- `tgui/packages/tgui/interfaces/PreferencesMenu/tabs/CharacterCreator/subtabs/Appearance/FeatureChoices/FeatureChoiceBodyHair.tsx`: feature chocies.
