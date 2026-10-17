# Nudist-approved equipment

**Tag:** `NUDIST_APPROVED`

**Created in:** https://github.com/Shadow-Fragger-Metaclique-Gang/TheImpossibleDream/pull/44

**Major changes:** Port of [Ratwood PR #962](https://github.com/Rotwood-Vale/Ratwood-2.0/pull/962).

`/obj/item/nudist_approved` defaults to `FALSE`. Setting it to `TRUE` lets a Nudist wear the item when it would otherwise be blocked

## Files

- `_nudist_approved.dme`: local includes.
- `code/nudist_approved.dm`: item variable, examine/sleep/stripping overrides, and trait descriptions.
- `code/approved_items.dm`: accessory approvals and armored exceptions.

## Core files changed

- `code/modules/mob/living/carbon/human/species.dm`: limits the existing Nudist equipment restriction to nudist_approved = FALSE items, which is the default
