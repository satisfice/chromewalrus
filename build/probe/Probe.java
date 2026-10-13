import java.awt.*;
import org.jogamp.java3d.*;
import org.jogamp.java3d.utils.universe.*;

public class Probe {
    public static void main(String[] a) throws Exception {
        GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
        System.out.println("default: " + ge.getDefaultScreenDevice().getIDstring());
        for (GraphicsDevice d : ge.getScreenDevices()) System.out.println("screen: " + d.getIDstring());
        GraphicsConfiguration pref = SimpleUniverse.getPreferredConfiguration();
        System.out.println("preferred: " + pref.getDevice().getIDstring() + " " + pref.getClass().getName());
        Canvas3D c = new Canvas3D(pref);
        GraphicsConfiguration cg = c.getGraphicsConfiguration();
        System.out.println("canvas gc: " + (cg == null ? "null" : cg.getDevice().getIDstring() + " " + cg.getClass().getName()));
        javax.swing.JFrame f = new javax.swing.JFrame("t", cg);
        System.out.println("frame gc before show: " + f.getGraphicsConfiguration().getDevice().getIDstring());
        f.setSize(200, 200);
        f.setVisible(true);
        Thread.sleep(500);
        System.out.println("frame gc after show: " + f.getGraphicsConfiguration().getDevice().getIDstring());
        try { f.getContentPane().add(c); System.out.println("add OK"); }
        catch (Exception e) { System.out.println("add FAILED: " + e); }
        f.dispose();
        System.exit(0);
    }
}
