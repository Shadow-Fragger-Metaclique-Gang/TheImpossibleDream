# Listener deploy

**Tag:** `LISTENER_DEPLOY`

**Created in:** _PR link to be added once opened_

**Major changes:**

## Deployable listeners

Inquisition listening devices can no longer be switched on in the inventory. They only work once laid down.

- Using the listener in hand (`attack_self`) starts a short `do_after` with no progress bar, then drops it on the turf in front of the user (or the user's own turf if that one is dense). It is immediately hidden (alpha 15, named "thing").
- A placed listener is inert. After 30 seconds without being touched or moved it arms and starts listening.
- Picking it up, or moving it into a container, disarms and reveals it. Nudging it along the floor disarms it and restarts the 30 second wait.
- Labelling ("BEND AN EAR") moves from `attack_self` to `attack_right`. The old right-click hide toggle and the middle-click on/off toggle are gone.

## Files

- `_listener_deploy.dme`: local includes.
- `code/listener_deploy.dm`: placing, arming and retrieval procs, the labelling proc, and the `pickup` and `Moved` overrides.

## Core files changed

- `code/modules/roguetown/roguemachine/scomm/listener.dm`: `attack_self` now calls `place_down`, `attack_right` now calls `bend_ear`, and the middle-click toggle is removed. The old bodies are commented out inside `SURREALIS-REMOVE` blocks.
