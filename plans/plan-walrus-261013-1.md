# Plan: get Walrus running on this machine

Date: 2026-10-13

## Prompt that precipitated this plan

> do what is necessary to run this

(Preceding question: "how do I run walrus?")

## Findings (read-only checks already done)

- JDK 22.0.2 is installed (`C:\Program Files\Java\jdk-22`). No `make` on PATH except `c:\code\make.bat` (unknown contents). Python 3.13 and git are present.
- The repository holds source only. Missing: `mp.jar`, `antlrall-mod.jar`, `libsea.jar`, `samples/`, compiled `.class` files.
- The Makefile just runs `javac` per file; `make` is not needed.
- Walrus requires Java3D (`javax.media.j3d`, `javax.vecmath`). JDK 22 does not include it.

## Existing Solutions

1. Official CAIDA release package (walrus-0.6.3-src or the binary zip).
   Supplies `mp.jar`, `antlrall-mod.jar`, `libsea.jar`, and `samples/`. This is the only source I know of for `mp.jar` and `antlrall-mod.jar` (modified ANTLR, MPJAVA). Needed in any approach.
2. libsea: source archive already in the repo (`libsea/libsea-0.1-src.zip`); the release package also has a prebuilt `libsea.jar`. Prefer the prebuilt jar.
3. Java3D:
   - Option A: JogAmp Java3D 1.7.x (`org.jogamp.java3d:j3d-core`, `vecmath`, plus JogAmp `jogl-all` and `gluegen-rt` natives), downloadable from Maven Central. Maintained, works with modern JDKs in most cases. Walrus source is from the 2000s and may need small API fixes. Risk: compatibility with JDK 22 is not guaranteed.
   - Option B: Install an older JDK (8) plus Oracle's Java3D 1.5.x/1.6 installer. Closest to what Walrus was written for, but the installer is old, hard to source, and OpenGL drivers may misbehave on Windows 11.
   - Option C: Use the JogAmp Java3D build with a side-by-side JDK 8 or 11 if JDK 22 fails. Fallback only.
4. Build tool: plain `javac` with a classpath is sufficient; no GNU Make required.

## Assumptions (please confirm or correct)

- Internet access to caida.org and Maven Central is allowed.
- Adding about 10 MB of jar files and a `lib/` directory to the project is acceptable. I will not `git add` them (you track files yourself); I would add a `.gitignore` only if you ask.
- Your GPU/OpenGL drivers support what Java3D needs (cannot verify in advance).
- The Walrus source compiles against Java3D 1.7 without edits. If edits are needed, I will report them before making them, since the files are tracked.

## Proposed steps

1. Download the CAIDA release zip into a new empty directory (e.g. `E:\testing\walrus-download`), outside the repo, and inspect its contents before using anything from it.
2. Copy `mp.jar`, `antlrall-mod.jar`, `libsea.jar` into `E:\testing\walrus\lib\`, and `samples\` into the project directory.
3. Download the JogAmp Java3D 1.7.x jars (`j3dcore`, `j3dutils`, `vecmath`, `jogl-all` and `gluegen-rt` with Windows natives) into `lib\`.
4. Compile: `javac -cp "lib\*;." *.java` (untracked `.class` files only).
5. Write `run-walrus.bat` that launches `java -cp "lib\*;." H3Main`, and a short `readme.md` section describing it (per your documentation rule). The new files are untracked.
6. Per your testing rule, I will stop after step 5 and let you launch it and report problems, rather than running it myself.

## Decisions needed

- Java3D route: Option A (JogAmp, recommended) or Option B (older JDK plus Oracle Java3D)?
- May I download from the internet as described?
- Where should the jars live: `E:\testing\walrus\lib\` (proposed) or elsewhere?
