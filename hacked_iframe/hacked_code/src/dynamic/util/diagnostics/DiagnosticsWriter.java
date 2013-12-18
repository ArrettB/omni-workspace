package dynamic.util.diagnostics;

import dynamic.util.mail.MailSender;
import dynamic.util.threads.BlockingQueue;

import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.util.Date;

public class DiagnosticsWriter
        implements Runnable {
    BlockingQueue queue;
    OutputStream stream;
    String host;
    String port;
    String to;
    String from;
    int level = 15;
    Thread tid;

    DiagnosticsWriter(OutputStream stream, int level) {
        this.stream = stream;
        this.level = level;
    }

    DiagnosticsWriter(String host, String port, String to, String from, int level) {
        this.host = host;
        this.port = port;
        this.to = to;
        this.from = from;
        this.level = level;
    }

    public boolean equals(Object o) {
        if (getClass() != o.getClass()) return false;
        DiagnosticsWriter dw = (DiagnosticsWriter) o;
        if (this.stream != null) return this.stream == dw.stream;
        if (this.to != null) return this.to == dw.to;
        return false;
    }

    synchronized void write(DiagnosticsMessage msg)
            throws Exception {
        if (this.tid == null) start();
        this.queue.enqueue(msg);
    }

    void start() {
        this.queue = new BlockingQueue();
        this.tid = new Thread(this, "DiagnosticsWriter");
        this.tid.setDaemon(true);
        this.tid.setPriority(1);
        this.tid.start();
    }

    void stop() {
        if (this.tid == null) return;
        Thread temp = this.tid;
        this.tid = null;
        if (temp != Thread.currentThread()) temp.interrupt();
        this.queue.close();
        this.queue = null;
    }

    void close() {
        stop();
        try {
            if ((this.stream != null) && (this.stream != System.out) && (this.stream != System.err))
                this.stream.close();
            this.stream = null;
        } catch (Exception e) {
            Diagnostics.error("Problem shutting down stream: " + this.stream, e);
        }
    }

    public void run() {
        while (this.tid == Thread.currentThread()) {
            DiagnosticsMessage msg = null;
            try {
                msg = (DiagnosticsMessage) this.queue.dequeue();
                if (msg.severity <= this.level) {
                    if (this.stream == null) {
                        MailSender ms = new MailSender(this.to, this.from, msg.text, new Date(), msg.toHTML());
                        ms.setServerInfo(this.host, this.port);
                        ms.setContentType("text/html; charset=us-ascii");
                        ms.send();
                    } else if ((this.stream instanceof ObjectOutputStream)) {
                        ObjectOutputStream oos = (ObjectOutputStream) this.stream;
                        oos.writeObject(msg);
                        oos.flush();
                        oos.reset();
                    } else {
                        this.stream.write(msg.toString().getBytes());
                        this.stream.flush();
                    }
                }
            } catch (BlockingQueue.Closed c) {
                stop();
            } catch (Exception e) {
                if (msg != null) System.err.println("! " + msg);
                e.printStackTrace(System.err);
                stop();
            }
        }
    }
}

/* Location:           /Users/dave/kettle_river_consulting/customers/omni_workspace/iFrame framework/original code/
 * Qualified Name:     dynamic.util.diagnostics.DiagnosticsWriter
 * JD-Core Version:    0.6.2
 */