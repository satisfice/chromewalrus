@echo off
rem Launches Walrus.  Run build-walrus.ps1 first.
rem lib\* holds Walrus's jars and the JogAmp Java3D/JOGL jars; build\classes holds Walrus itself.
rem The --add-opens options let JOGL reach AWT internals, which JDK 17+ blocks by default.
cd /d "%~dp0"
java --add-opens java.desktop/sun.awt=ALL-UNNAMED --add-opens java.desktop/sun.java2d=ALL-UNNAMED --add-opens java.desktop/sun.awt.windows=ALL-UNNAMED -cp "lib\*;build\classes" H3Main %*
