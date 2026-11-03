# Migrant waves

**Tag:** `MIGRANT_WAVES`

**Created in:** https://github.com/Shadow-Fragger-Metaclique-Gang/TheImpossibleDream/pull/102

**Major changes:**

## Migrant waves

- Ghosts can see, queue for and join migrant waves. Every wave that starts forming is announced in chat to the lobby and to eligible ghosts. Standard and admin ghosts qualify (including the default `/nodraw` type), but not scrying eyes or trapped spirits, and nobody qualifies when `norespawn` is on. When a wave spawns, a queued ghost is turned into a lobby mob and then spawned the usual way.
- Ghosts get a Migration Waves button on their HUD (standard and admin ghost HUDs) that opens the same menu as the lobby's Migrants button. It uses the `migrate` icon state from this module's `icons/screen_ghost.dmi`.
- Every migrant wave's triumph cost (`triumph_threshold`) is doubled.
- New special wave, Fugitive Pair: two Wretches. It runs on the special track and can be bought for 400 triumph. Wretches pick from the normal Wretch subclasses and get the Wretch antag datum and the Wretch job's traits, and spawn at the Wretch landmarks.

## Files

- `_migrant_waves.dme`: local includes.
- `code/ghost_migration.dm`: ghost eligibility, the candidate list (lobby players plus ghosts) and the ghost-to-lobby-mob conversion used when a wave spawns.
- `code/ghost_hud.dm`: the HUD button (using `icons/screen_ghost.dmi`) and the proc that adds it to the ghost HUD.
- `code/triumph_cost.dm`: the triple-cost multiplier, applied in `/datum/migrant_wave/New()`, and the `fixed_triumph_threshold` override.
- `code/wretch_pair.dm`: the Wretch migrant role and the Fugitive Pair wave.

## Core files changed

- `code/controllers/subsystem/migrants.dm`: the active-migrant list, the panel viewer list and the wave announcement now use `get_migrant_candidate_mobs()`. `spawn_migrant` gets its mob from `get_migrant_new_player()`, which converts a ghost to a lobby mob. Every wave is now announced from `begin_forming`, so every track, admin-forced waves, hidden waves and waves within 5 minutes of the last announcement all show in chat for the lobby and ghosts. The old per-track announce calls and the hidden and throttle checks are commented out.
- `code/_onclick/hud/ghost.dm`: calls `add_migrant_waves_button()` at the end of `/datum/hud/ghost/New` and `/datum/hud/adminghost/New`.
