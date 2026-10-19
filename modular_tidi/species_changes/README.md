# SPECIES_CHANGES

**Tag:** `SPECIES_CHANGES`

**Created in:** https://github.com/Shadow-Fragger-Metaclique-Gang/TheImpossibleDream/pull/57

**Major changes:**

## Existing Species Part Edits + Scaling Changes

Not every species had the right parts, nor had they the best pieces. Lupians, for example, didn't have the digitigrade goat legs. I've decided to add them all as a choice for anthro species, alongside a tiny thing like adding tusks to Wildbloods.

More majorly, however, I'd also changed up the minimum and maximum sprite sizes for characters- and had to touch on DNA.dm to do it. You'll find that my edit has been appropriately marked.

Ideally, species_changes.dm will serve as a general edit point for a majority of rearrangements - if we want to make it so that Tabaxi could have tusks, you can edit that file instead of creating a totally new module.

New species content is better contained within its own module, though.

## Files

- `_species_changes.dme`: local includes.
- `code/_species_changes.dm`: Changes to the lists of available parts and customizers to species.

## Core files changed

- `code\__DEFINES\DNA.dm`:
