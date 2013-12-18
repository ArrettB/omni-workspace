package dynamic.util.diagnostics;

import dynamic.util.string.StringUtil;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.lang.reflect.Constructor;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Properties;
import java.util.Vector;

public class DiagnosticsContext
        implements Runnable {
    Vector writers = new Vector();
    Vector sockets = new Vector();
    Vector ports = new Vector();
    ServerSocket serverSocket = null;
    Thread tid = null;
    boolean isShuttingDown = false;

    void initialize(Node n)
            throws Exception {
        if (n == null) return;

        Element topElement = (Element) n;

        String path = topElement.getAttribute("sourcePath");
        if ((path != null) && (path.length() > 0)) {
            String currentPath = System.getProperty("dynamic.source.path");
            currentPath = StringUtil.appendUnique(currentPath, path, ';');
            Properties p = System.getProperties();
            p.put("dynamic.source.path", currentPath);
            System.setProperties(p);
        }

        int level = 15;
        String attr = topElement.getAttribute("level");
        if ((attr != null) && (attr.length() > 0)) level = Integer.parseInt(attr);

        NodeList list = topElement.getElementsByTagName("diagnosticsStream");
        for (int x = 0; x < list.getLength(); x++) {
            Element element = (Element) list.item(x);
            attr = element.getAttribute("class");
            if ((attr != null) && (attr.length() > 0)) {
                Class c = Class.forName(attr);
                attr = element.getAttribute("property");
                OutputStream os = (OutputStream) c.getField(attr).get(null);
                int l = level;
                String tmp = element.getAttribute("level");
                if ((tmp != null) && (tmp.length() > 0)) l = Integer.parseInt(tmp);
                registerStream(os, l);
            }

        }

        list = topElement.getElementsByTagName("diagnosticsFile");
        for (int x = 0; x < list.getLength(); x++) {
            Element element = (Element) list.item(x);
            attr = element.getAttribute("path");
            if ((attr != null) && (attr.length() > 0)) {
                OutputStream os = new FileOutputStream(attr, true);
                int l = level;
                String tmp = element.getAttribute("level");
                if ((tmp != null) && (tmp.length() > 0)) l = Integer.parseInt(tmp);
                registerStream(os, l);
            }

        }

        list = topElement.getElementsByTagName("diagnosticsListener");
        for (int x = 0; x < list.getLength(); x++) {
            Element element = (Element) list.item(x);
            String name = element.getAttribute("name");
            attr = element.getAttribute("class");
            if ((attr != null) && (attr.length() > 0)) {
                Class c = Class.forName(attr);
                Constructor construct = c.getConstructor(new Class[]{name.getClass()});
                OutputStream os = null;
                if (construct != null) os = (OutputStream) construct.newInstance(new Object[]{name});
                else
                    os = (OutputStream) c.newInstance();
                int l = level;
                String tmp = element.getAttribute("level");
                if ((tmp != null) && (tmp.length() > 0)) l = Integer.parseInt(tmp);
                registerStream(os, l);
            }

        }

        list = topElement.getElementsByTagName("diagnosticsMailer");
        for (int x = 0; x < list.getLength(); x++) {
            Element element = (Element) list.item(x);
            String host = element.getAttribute("host");
            if ((host == null) || (host.length() == 0))
                throw new Exception("Missing required attribute \"host\" on diagnosticsMailer");
            String port = element.getAttribute("port");
            if ((port == null) || (port.length() == 0)) port = "25";
            String to = element.getAttribute("to");
            if ((to == null) || (to.length() == 0))
                throw new Exception("Missing required attribute \"to\" on diagnosticsMailer");
            String from = element.getAttribute("from");
            if ((from == null) || (from.length() == 0))
                throw new Exception("Missing required attribute \"from\" on diagnosticsMailer");
            int l = level;
            String tmp = element.getAttribute("level");
            if ((tmp != null) && (tmp.length() > 0)) l = Integer.parseInt(tmp);
            registerWriter(new DiagnosticsWriter(host, port, to, from, l));
        }

        list = topElement.getElementsByTagName("diagnosticsLog4j");
        for (int x = 0; x < list.getLength(); x++) {
            Element element = (Element) list.item(x);
            String tmp = element.getAttribute("level");
            int l = level;
            if ((tmp != null) && (tmp.length() > 0)) l = Integer.parseInt(tmp);

            tmp = element.getAttribute("path");
            String logFilePath = ".";
            if ((tmp != null) && (tmp.length() > 0)) logFilePath = tmp;

            registerWriter(new Log4jDiagnosticsWriter(logFilePath, l));
        }

        String ports = topElement.getAttribute("port");
        setPorts(ports);

        start();
    }

    synchronized void destroy() {
        stop();
        this.isShuttingDown = true;
        closeSockets();
        if (this.writers != null) {
            for (int i = 0; i < this.writers.size(); i++) {
                DiagnosticsWriter w = (DiagnosticsWriter) this.writers.elementAt(i);
                w.close();
            }

            this.writers.removeAllElements();
            this.writers = null;
        }
    }

    synchronized void registerStream(OutputStream newStream, int level) {
        this.writers.addElement(new DiagnosticsWriter(newStream, level));
    }

    synchronized void registerWriter(DiagnosticsWriter writer) {
        if (this.writers.contains(writer)) return;
        this.writers.addElement(writer);
    }

    private void setPorts(String port_string) {
        this.ports.removeAllElements();
        if ((port_string == null) || (port_string.length() == 0)) return;

        Vector tmp_ports = StringUtil.stringToVector(port_string, ',');
        for (int i = 0; i < tmp_ports.size(); i++) {
            Vector low_high = StringUtil.stringToVector((String) tmp_ports.elementAt(i), '-');
            if (low_high.size() == 1) {
                this.ports.addElement(new Integer((String) low_high.elementAt(0)));
            } else {
                int low = Integer.parseInt((String) low_high.elementAt(0));
                int high = Integer.parseInt((String) low_high.elementAt(1));
                for (int j = low; j <= high; j++) {
                    this.ports.addElement(new Integer(j));
                }
            }
        }
    }

    synchronized void write(DiagnosticsMessage msg) {
        if ((this.writers == null) || (this.writers.size() == 0)) {
            System.err.print("# " + msg.toString());
            return;
        }

        for (int i = this.writers.size() - 1; i >= 0; i--) {
            try {
                DiagnosticsWriter w = (DiagnosticsWriter) this.writers.elementAt(i);
                w.write(msg);
            } catch (Exception e) {
                this.writers.removeElementAt(i);
                System.err.println("! " + msg + "\n" + e);
            }
        }
    }

    int getPort() {
        if (this.serverSocket == null) return 0;
        return this.serverSocket.getLocalPort();
    }

    private void start() {
        if (this.ports.size() == 0) return;
        this.tid = new Thread(this, "DiagnosticsListener");
        this.tid.setDaemon(true);
        this.tid.setPriority(1);
        Diagnostics.registerThread(this.tid, this);
        this.tid.start();
    }

    private void stop() {
        if (this.tid == null) return;
        Thread temp = this.tid;
        this.tid = null;
        if (temp != Thread.currentThread()) temp.interrupt();
    }

    public void run() {
        try {
            boolean found = false;
            Exception lastException = null;

            for (int i = 0; i < this.ports.size(); i++) {
                try {
                    int port = ((Integer) this.ports.elementAt(i)).intValue();
                    this.serverSocket = new ServerSocket(port);
                    found = true;
                } catch (IOException e) {
                    lastException = e;
                }
            }

            if (found) {
                Diagnostics.trace("Diagnostics listening on port " + getPort());
                Thread thisThread = Thread.currentThread();
                while (thisThread == this.tid) {
                    Socket socket = this.serverSocket.accept();
                    Diagnostics.trace("Diagnostics connection request from " + socket.getInetAddress() + ":" + socket.getPort());
                    OutputStream out = socket.getOutputStream();
                    registerStream(new ObjectOutputStream(out), 15);
                    this.sockets.addElement(socket);
                }
            } else {
                Diagnostics.error("Diagnostics could find no ports to listen on", lastException);
            }
        } catch (Exception e) {
            if (!this.isShuttingDown)
                Diagnostics.error("DiagnosticsContext.run() aborting due to exception", e);
        } finally {
            closeSockets();
        }
    }

    private synchronized void closeSockets() {
        if (this.serverSocket != null) {
            try {
                this.serverSocket.close();
            } catch (Exception e) {
                Diagnostics.error("Problems shutting down server socket: " + this.serverSocket, e);
            }
            this.serverSocket = null;
        }

        if (this.sockets != null) {
            for (int i = 0; i < this.sockets.size(); i++) {
                Socket s = (Socket) this.sockets.elementAt(i);
                try {
                    s.close();
                } catch (Exception e) {
                    Diagnostics.error("Problems shutting down socket: " + s, e);
                }
            }
            this.sockets.removeAllElements();
            this.sockets = null;
        }
    }
}

/* Location:           /Users/dave/kettle_river_consulting/customers/omni_workspace/iFrame framework/original code/
 * Qualified Name:     dynamic.util.diagnostics.DiagnosticsContext
 * JD-Core Version:    0.6.2
 */