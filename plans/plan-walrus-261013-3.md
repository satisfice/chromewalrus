# Plan: mouse wheel zoom in Walrus

Date: 2026-10-13

## Prompt that precipitated this plan

> modify it so that I can use the mouse wheel to zoom in and out

## Findings

- Zoom already exists as `EventHandler.increaseMagnification()` / `decreaseMagnification()`
  (`H3Main.java:2394`, `:2408`). Each call changes magnification by one 25% step
  (docs/guide.txt:208-217), and is bound to the Display menu and the `.` / `,` keys.
- `EventHandler` (`H3Main.java:2185`) implements `KeyListener, MouseListener, MouseMotionListener`,
  registers on `m_canvas` in its constructor (`:2200-2202`), and unregisters in a cleanup method (`:2236-2238`).
- No `MouseWheelListener` exists anywhere in the source.
- Zoom is toward the node at the center of the display (not toward the mouse pointer). Wheel zoom
  will behave the same way; zooming toward the pointer would need new view logic.
- `H3Main.java` is tracked in Git; `git status` shows no uncommitted changes to tracked files.

## Existing Solutions

1. Java AWT `java.awt.event.MouseWheelListener` / `MouseWheelEvent` (standard library, JDK 22): exactly this need.
   `MouseWheelEvent.getWheelRotation()` is negative when the wheel moves away from the user (scroll up).
2. Reuse the existing `increaseMagnification()` / `decreaseMagnification()`: no new zoom code is needed.
3. No third-party library is relevant.

## Proposed change (minimal, in `H3Main.java`)

1. `EventHandler` also implements `MouseWheelListener`.
2. Constructor: `m_canvas.addMouseWheelListener(this);`; cleanup: `m_canvas.removeMouseWheelListener(this);`.
3. New method `mouseWheelMoved(MouseWheelEvent e)`: wheel rotation < 0 (scroll up/away) calls
   `increaseMagnification()`; rotation > 0 calls `decreaseMagnification()`. One step per notch
   (the event's rotation count is applied, capped at a few steps, so a fast spin does not queue
   dozens of slow refreshes).
4. Add the `java.awt.event.MouseWheelEvent` / `MouseWheelListener` import if `java.awt.event.*` is not already imported.
5. Update docs/guide.txt (Zoom In / Zoom Out entries) and the user-facing key list to mention the wheel.
6. Commit as per your Git rules: the edits to tracked files are committed to master after the change.
   No commit of untracked files.
7. Rebuild with `build-walrus.ps1` (compile only). You test; I do not run the application.

## Assumptions (please confirm or correct)

- Scroll up = zoom in, scroll down = zoom out.
- Zoom toward the center node, as with the existing menu/keys, is acceptable.
- Direct edit of the tracked `H3Main.java` (rather than patching only in the build copy) is acceptable.
  This differs from the earlier build-only patches because this is a source feature you asked for,
  and you want to be able to revert via Git.

## Risks

- Java3D's heavyweight canvas may not receive wheel events reliably under JOGL; this is not testable by me.
- Each zoom step triggers two display refreshes (existing Java3D workaround), so very fast wheel spinning may feel slow on large graphs.
