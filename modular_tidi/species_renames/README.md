# SPECIES_RENAMES

**Tag:** `SPECIES_RENAMES`

**Created in:**

**Major changes:**

## The Great Species Renaming + Redescription, Part Two

Using old lore I'd written up for Scarlet Reach back in the day, I rewrote a good portion of species lore to make sense, and reformatted them to work with the AP Character UI.
Ideally, this is just groundworks for a rough draft; I'd like to add in fun CSS adjustments, open the lore up for other people that enjoy these races more to fill it in, so on and so forth.
That said, it does also introduce certain nations and ideas that aren't in-game as of today. As soon as I figure out how to add those nations (and corresponding lore that I've already written too) - those will be added.

Anyone that wants to edit this further can futz with the `code/species_renames.dm` to introduce new concepts, or rewrite things better.

/ SECOND PASS EDIT /

First pass broke stuff. I'd introduced some new code to essentially bypass the way names were carried over in preferences_savefile.dm - using a global init list to mark off all the old names used in save files, and have the code essentially rename them. It works. It compiles. It doesn't turn everyone I renamed human, which is a victory!

... I also renamed NPC orcs and goblins to Orkhors and Grottins, partially to prevent any weirdness with names, partially because I think it'd be funny to give NPC goblins an actual literal name. Wonder where it came from...

## Layout

=======

- `species_renames.dme`: the module's .dme.
- `code/species_renames.dm`: The main body of work - the renames, re-description, and fresh code.
-

## Core files changed

N/A! We're good!
