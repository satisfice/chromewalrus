# Running Walrus on Windows

Walrus (2005) needs Java3D. This setup uses the maintained JogAmp Java3D 1.7.2 with JDK 22.

## Contents of lib\

- `mp.jar`, `antlrall-mod.jar`, `libsea.jar`: from the CAIDA walrus-0.6.3 release (retrieved from the Internet Archive; the CAIDA download link is dead).
- `java3d-core`, `java3d-utils`, `vecmath` 1.7.2; `jogl-all`, `gluegen-rt` 2.6.0 with Windows amd64 natives: from Maven Central.

`samples\` comes from the same release.

## Build

    powershell -File build-walrus.ps1

JogAmp renamed the Java3D packages (`javax.media.j3d` to `org.jogamp.java3d`, and so on).
The build script rewrites the imports in a copy of the source under `build\src`, so the
tracked `.java` files are not modified.

## Run

    run-walrus.bat

Then choose File > Open and load `samples\champagne.graph`.
Other arguments are passed through to `H3Main`.

## Notes

- Java3D 1.7 on JDK 22 is untested for this program; report any errors.
- `lib\`, `build\` and `samples\` are generated or downloaded and are not tracked in Git.
