# build-walrus.ps1
# Builds Walrus on Windows against JogAmp Java3D 1.7.x (jars in lib\).
# The original source imports javax.media.j3d / javax.vecmath / com.sun.j3d.utils,
# which JogAmp Java3D 1.7 renamed to org.jogamp.*.  To leave the tracked source
# untouched, this script rewrites the imports in a copy under build\src and
# compiles that copy into build\classes.

Set-Location $PSScriptRoot
New-Item -ItemType Directory -Force build\src, build\classes | Out-Null

# Copy each source file, rewriting the package names as it goes.
foreach ($f in Get-ChildItem *.java) {
    $t = [IO.File]::ReadAllText($f.FullName)
    $t = $t -replace 'javax\.media\.j3d', 'org.jogamp.java3d' `
            -replace 'javax\.vecmath', 'org.jogamp.vecmath' `
            -replace 'com\.sun\.j3d\.utils', 'org.jogamp.java3d.utils'
    if ($f.Name -eq 'H3Main.java') {
        # Create the frame on the same GraphicsDevice as the Canvas3D.  Java3D
        # chooses the canvas's device itself; on a multi-monitor system it can
        # differ from the frame's default device, and AWT then throws "adding a
        # container to a container on a different GraphicsDevice".
        $patched = $t.Replace('new JFrame(WALRUS_TITLE)',
            'new JFrame(WALRUS_TITLE, m_canvas.getGraphicsConfiguration())')
        if ($patched -eq $t) { throw 'JFrame patch did not apply to H3Main.java' }
        $t = $patched

        # AWT re-assigns a frame's GraphicsDevice when the window sits on (or is
        # dragged to) another monitor, while the Canvas3D keeps the device it was
        # created with.  Adding the canvas then fails.  Before the canvas is added,
        # print both devices and move the frame onto the canvas's monitor if they differ.
        $helper = @'
    private void alignFrameWithCanvasDevice()
    {
	GraphicsConfiguration canvasGC = m_canvas.getGraphicsConfiguration();
	GraphicsConfiguration frameGC = m_frame.getGraphicsConfiguration();
	if (canvasGC == null || frameGC == null) { return; }
	String canvasID = canvasGC.getDevice().getIDstring();
	String frameID = frameGC.getDevice().getIDstring();
	System.out.println("canvas device " + canvasID + ", frame device " + frameID);
	if (!canvasID.equals(frameID))
	{
	    Rectangle b = canvasGC.getBounds();
	    m_frame.setLocation(b.x + 50, b.y + 50);
	    m_frame.getToolkit().sync();
	    System.out.println("moved frame to " + canvasID + "; frame device now "
		+ m_frame.getGraphicsConfiguration().getDevice().getIDstring());
	}
    }

    private void reinstateCanvasContentPane()
'@
        $patched = $t.Replace('    private void reinstateCanvasContentPane()', $helper)
        if ($patched -eq $t) { throw 'helper patch did not apply to H3Main.java' }
        $t = $patched
        $patched = $t.Replace('m_frame.getContentPane().add(m_canvas, BorderLayout.CENTER);',
            "alignFrameWithCanvasDevice();`r`n`t`tm_frame.getContentPane().add(m_canvas, BorderLayout.CENTER);")
        if ($patched -eq $t) { throw 'align call patch did not apply to H3Main.java' }
        $t = $patched
    }
    [IO.File]::WriteAllText("build\src\$($f.Name)", $t)
}

# Compile everything with the jars in lib\ on the classpath.
$sources = Get-ChildItem build\src\*.java | ForEach-Object { $_.FullName }
javac -nowarn -cp "lib\*" -d build\classes $sources

# The splash image is loaded from the classpath at run time.
Copy-Item walrus-splash.jpg build\classes\ -Force
