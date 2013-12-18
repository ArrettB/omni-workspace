package dynamic.util.diagnostics;

import org.w3c.dom.Node;

import java.util.Enumeration;
import java.util.Hashtable;

public final class Diagnostics
        implements Runnable {
    public static final int MIN_LEVEL = 0;
    public static final int FATAL = 0;
    public static final int ERROR = 1;
    public static final int WARNING = 4;
    public static final int STATUS = 8;
    public static final int DEBUG = 11;
    public static final int DEBUG2 = 12;
    public static final int DEBUG3 = 13;
    public static final int TRACE = 14;
    public static final int TRACE2 = 15;
    public static final int MAX_LEVEL = 15;
    private static Thread tid = null;
    private static Hashtable contexts = new Hashtable();

    public static DiagnosticsContext initialize(Node n)
            throws Exception {
        DiagnosticsContext context = new DiagnosticsContext();
        context.initialize(n);
        registerThread(context);
        return context;
    }

    public static void destroy() {
        DiagnosticsContext context = getContext();
        if (context == null) return;

        Enumeration e = contexts.keys();
        while (e.hasMoreElements()) {
            Object x = e.nextElement();
            Object y = contexts.get(x);
            if (y == context) contexts.remove(x);
        }

        context.destroy();
    }

    public static DiagnosticsContext getContext() {
        return (DiagnosticsContext) contexts.get(Thread.currentThread());
    }

    public static void registerThread(Thread thread) {
        registerThread(thread, getContext());
    }

    public static void registerThread(DiagnosticsContext context) {
        registerThread(Thread.currentThread(), context);
    }

    public static void registerThread(Thread thread, DiagnosticsContext context) {
        if ((thread != null) && (context != null))
            contexts.put(thread, context);
    }

    public static void releaseThread(Thread thread) {
        if (thread != null)
            contexts.remove(thread);
    }

    private static void start() {
        tid = new Thread(new Diagnostics(), "DiagnosticsCleaner");
        tid.setDaemon(true);
        tid.setPriority(1);
        tid.start();
    }

    private static void stop() {
        if (tid == null) return;
        Thread temp = tid;
        tid = null;
        if (temp != Thread.currentThread()) temp.interrupt();
    }

    public void run() {
        try {
            Thread thisThread = Thread.currentThread();
            while (thisThread == tid) {
                Enumeration hashEnum = contexts.keys();
                while (hashEnum.hasMoreElements()) {
                    Thread thread = (Thread) hashEnum.nextElement();
                    if (!thread.isAlive())
                        contexts.remove(thread);
                }
                try {
                    Thread.sleep(60000L);
                } catch (InterruptedException e) {
                }
            }
        } catch (Exception e) {
            e.printStackTrace(System.err);
        }
    }

    public static int getPort() {
        DiagnosticsContext context = getContext();
        if (context == null) {
            return 0;
        }
        return context.getPort();
    }

    public static void write(DiagnosticsMessage msg) {
        DiagnosticsContext context = getContext();
        if (context == null) {
            System.err.print("* " + msg.toString());
        } else {
            context.write(msg);
        }
    }

    public static DiagnosticsMessage write(int severity, String msg, Throwable ex, Object caller) {
        DiagnosticsMessage m = new DiagnosticsMessage(severity, msg, ex, caller);
        write(m);
        return m;
    }

    public static DiagnosticsMessage fatal(String msg, Throwable ex, Object caller) {
        return write(0, msg, ex, caller);
    }

    public static DiagnosticsMessage fatal(String msg, Throwable ex) {
        return write(0, msg, ex, null);
    }

    public static DiagnosticsMessage fatal(String msg) {
        return write(0, msg, null, null);
    }

    public static DiagnosticsMessage error(String msg, Throwable ex, Object caller) {
        return write(1, msg, ex, caller);
    }

    public static DiagnosticsMessage error(String msg, Throwable ex) {
        return write(1, msg, ex, null);
    }

    public static DiagnosticsMessage error(String msg) {
        return write(1, msg, null, null);
    }

    public static DiagnosticsMessage warning(String msg, Object caller) {
        return write(4, msg, null, caller);
    }

    public static DiagnosticsMessage warning(String msg) {
        return write(4, msg, null, null);
    }

    public static DiagnosticsMessage status(String msg, Object caller) {
        return write(8, msg, null, caller);
    }

    public static DiagnosticsMessage status(String msg) {
        return write(8, msg, null, null);
    }

    public static DiagnosticsMessage debug(String msg, Object caller) {
        return write(11, msg, null, caller);
    }

    public static DiagnosticsMessage debug(String msg) {
        return write(11, msg, null, null);
    }

    public static DiagnosticsMessage debug2(String msg, Object caller) {
        return write(12, msg, null, caller);
    }

    public static DiagnosticsMessage debug2(String msg) {
        return write(12, msg, null, null);
    }

    public static DiagnosticsMessage debug3(String msg, Object caller) {
        return write(13, msg, null, caller);
    }

    public static DiagnosticsMessage debug3(String msg) {
        return write(13, msg, null, null);
    }

    public static DiagnosticsMessage trace(String msg, Object caller) {
        return write(14, msg, null, caller);
    }

    public static DiagnosticsMessage trace(String msg) {
        return write(14, msg, null, null);
    }

    public static DiagnosticsMessage trace2(String msg, Object caller) {
        return write(15, msg, null, caller);
    }

    public static DiagnosticsMessage trace2(String msg) {
        return write(15, msg, null, null);
    }

    static {
        start();
    }
}

/* Location:           /Users/dave/kettle_river_consulting/customers/omni_workspace/iFrame framework/original code/
 * Qualified Name:     dynamic.util.diagnostics.Diagnostics
 * JD-Core Version:    0.6.2
 */