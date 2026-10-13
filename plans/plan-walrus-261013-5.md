# Plan: render the graph automatically after File > Open

## Prompt that precipitated this plan

> now modify it so that it automatically renders a graph when it is opened

## Findings

H3Main.handleOpenFileRequest() (H3Main.java, around line 137) loads the graph, populates the menus, resets the transform, sets the title and status bar, and enables Rendering > Start.
The user must then choose Rendering > Start.
That menu item calls handleStartRenderingRequest() (line 340), which snapshots the current menu choices (spanning tree, colors, labels, adaptive setting), runs setupRendering(), and starts the render loop.

## Proposed change

In handleOpenFileRequest(), after `m_startMenuItem.setEnabled(true);`, call `handleStartRenderingRequest();`.
This renders with the default menu choices, exactly as if the user had chosen Rendering > Start immediately after opening.
No change to build-walrus.ps1 or run-walrus.bat is needed, because only the tracked H3Main.java changes and the build script copies and patches it.
README.md and docs/guide.txt: update the Quick Start steps that say to choose Rendering > Start after loading (README step 4, and the equivalent text in readme-windows.md if any).

## Existing Solutions

- No library or tool is needed; this is a one-line call to an existing method.
- Alternative: a command-line flag (for example `H3Main --autostart file.graph`) so that auto-render is optional and a file can be given on the command line. More code (argument parsing, which H3Main may not do yet) and not what was asked.
- Alternative: a "Render on open" checkbox in the Rendering menu, defaulting to on. More flexible, since large graphs take a while to lay out and the user could turn it off; adds a menu item and state.

## Assumptions

- "Renders a graph" means doing what Rendering > Start does with the default settings.
- Auto-render should happen for every file opened, not only the first.
- If setupRendering() fails (for example a malformed spanning tree), it already shows its own error dialog, and the graph stays loaded with Start enabled.
- Large graphs will begin laying out immediately and the window may be unresponsive for a while; this was already true after pressing Start.
- H3Main.java was committed with no uncommitted changes, so no pre-edit commit is needed. I will commit H3Main.java and the docs when done. I will not run the program; you will try it.

## Questions

1. Always auto-render (as proposed), or add a menu checkbox so it can be turned off?
2. Should I update the README Quick Start step 4 (and the guide) to say rendering starts automatically?
