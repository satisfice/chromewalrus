# Plan: update README.md with current run instructions

## Prompt that precipitated this plan

> update the readme with latest information about how to run this

## Findings

README.md (tracked, unmodified) describes only the original 2005 procedure:
- QUICK START: unpack a release archive and run `java -cp mp.jar:antlrall-mod.jar:libsea.jar:walrus.jar H3Main`.
- BUILDING AND RUNNING: Mac OS X 10.11.6 with Apple JDK 1.6 and `make`.
- REQUIREMENTS: Java3D 1.2.1 and JDK 1.5.

It says nothing about the current Windows setup: `build-walrus.ps1`, `run-walrus.bat`, `lib\` (JogAmp Java3D 1.7.2, JOGL 2.6.0), JDK 17+ `--add-opens` flags, and `samples\` (now including `collatz.graph`).
That information currently lives only in `readme-windows.md` (untracked) and `readme-collatz.md` (untracked).
The most recent commit added mouse wheel zoom, which the README does not mention.

## Proposed change

Edit README.md only. Keep all original text, and add:

1. REQUIREMENTS: a note that the Windows build uses JDK 17 or later (tested with JDK 22) and JogAmp Java3D 1.7.x, which replaces Sun Java3D.
2. A new section, "BUILDING AND RUNNING ON WINDOWS", placed before the Mac OS X section, covering:
   - what must be in `lib\` and where the jars came from (summarised from readme-windows.md);
   - build: `powershell -File build-walrus.ps1` (rewrites javax.media.j3d / javax.vecmath / com.sun.j3d.utils imports to org.jogamp.* in a copy under `build\src`; tracked source is untouched; also patches H3Main for multi-monitor setups);
   - run: `run-walrus.bat` (explain the `--add-opens` options; extra arguments pass through to H3Main);
   - then File > Open and load `samples\champagne.graph`, and follow QUICK START step 4 onward.
3. QUICK START: a pointer saying that on Windows, step 2 is replaced by the new section, and a line noting mouse wheel zoom.
4. Mention `readme-windows.md` and `readme-collatz.md` for details, and that `lib\`, `build\`, `samples\` are not tracked.

The version banner and change log are left alone.

## Existing Solutions

- No tool is needed; this is a documentation edit.
- Alternative to editing README.md: leave it as is and track `readme-windows.md` instead. Trade-off: the original README stays inaccurate for anyone starting from it, and there are two places to look.
- Alternative: rewrite README.md fully. Trade-off: loses the original CAIDA text, which is historical and licensed content.

## Assumptions

- Mouse wheel zoom is the only user-visible feature from the recent commits that needs mentioning (I will read the diff of commit 676ed61 to confirm the exact behavior before writing it).
- JDK 17+ is the requirement (from the `--add-opens` comment in run-walrus.bat); JDK 22 is what readme-windows.md says was used.
- Only README.md is edited and committed. The untracked files stay untracked unless you tell me otherwise.
- README.md is clean, so no pre-edit commit is needed. After the edit I will commit README.md and this plan only if the plan is tracked (it is not, so only README.md).

## Questions

1. Should the Windows section be added as proposed, or should the Windows instructions replace the Mac section?
2. Should the plan files and readme-windows.md be tracked in Git?
