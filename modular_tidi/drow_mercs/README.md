# Drow mercenaries

**Tag:** `DROW_MERCS`

**Created In:** https://github.com/Shadow-Fragger-Metaclique-Gang/TheImpossibleDream/pull/43

**Major changes:**

Ports the drow content from [Ratwood PR #2589](https://github.com/Rotwood-Vale/Ratwood-2.0/pull/2589) (Yuckuza).

- `code/drow_weapons.dm`: drow blades, bardiche, urumi, greatflails, crossbows, shield adjustments, and their weapon intents.
- `code/drow_armor.dm` and `code/drow_scabbards.dm`: drow vest, helmets, mail tights, armor sprites, and sheathed-weapon sprites.
- `code/drow_mercenaries.dm`: replaces the anthrax drow mercenary names and lore with the Crocs de l'araignée Cavalier and Assassin.
- `code/drow_adventurer.dm`: drow auxiliary adventurer with crossbow, sword, or whip training and light or medium armor.
- `code/drow_drider.dm` and `code/drow_barding.dm`: drider mount climbing, feeding, and natural armor.
- `code/drow_hunting.dm`: adds wild driders to the Underdark's Common Arachnids hunting pool at weight 5, alongside ordinary spiders at 50 and mutated spiders at 10.
- `code/drow_supplies.dm`, `code/drow_spawner.dm`, and `code/drow_music.dm`: merchant stock, mapper equipment spawner, and both combat music tracks.
- `icons/` and `sounds/`: the drow port's sprites and music.

## Required core edits

- `code/modules/mob/living/simple_animal/simple_animal.dm`: excludes natural drider barding from manual removal and equipment overlays.
