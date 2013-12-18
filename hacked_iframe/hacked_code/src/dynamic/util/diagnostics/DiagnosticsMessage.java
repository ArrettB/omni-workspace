package dynamic.util.diagnostics;

import dynamic.util.string.StringUtil;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.PrintWriter;
import java.io.Serializable;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Vector;

public class DiagnosticsMessage
        implements Serializable {
    public Date date;
    public int severity = -1;
    public String text;
    public String exceptionName;
    public String exceptionMessage;
    public String query;
    public String stacktrace;
    public String stacktraceHTML;
    public String caller;
    public String threadName;
    private static final String dateFormat = "yyyy/MM/dd HH:mm:ss.SSS";
    private static String format = "%date [%severity] (%thread) %text\n%exception\n%stacktrace\n%caller";

    public static String[] color = {"#FF00FF", "#FF0000", "#D00000", "#A00000", "#C0C000", "#A0A000", "#808000", "#404000", "#00C000", "#00A000", "#008000", "#000000", "#0000FF", "#A000A0", "#808080", "#A0A0A0", "#C0C0C0"};

    public DiagnosticsMessage(int severity, String text, Throwable ex, Object caller) {
        this.date = new Date();
        this.severity = severity;
        this.text = text;
        this.threadName = Thread.currentThread().getName();

        if (ex != null) {
            try {
                this.exceptionName = ex.getClass().getName();
                this.exceptionMessage = ex.getMessage();
                ByteArrayOutputStream fooStream = new ByteArrayOutputStream();
                ex.printStackTrace(new PrintWriter(fooStream, true));
                this.stacktrace = fooStream.toString();
                int dropfirstline = this.stacktrace.indexOf('\n');
                if (dropfirstline != -1)
                    this.stacktrace = this.stacktrace.substring(dropfirstline + 1);
                if ((ex instanceof SQLException)) {
                    SQLException sqlEx = ((SQLException) ex).getNextException();
                    if (sqlEx != null) {
                        this.query = sqlEx.getMessage();
                    }
                }

                int pos = 0;
                StringBuffer sb = new StringBuffer();

                Vector sourcePaths = StringUtil.stringToVector(System.getProperty("dynamic.source.path"), ';');
                if (sourcePaths != null) {
                    while (pos >= 0) {
                        int atPos = this.stacktrace.indexOf("at ", pos);
                        int startPos = this.stacktrace.indexOf("(", pos);
                        int endPos = this.stacktrace.indexOf(")", pos);

                        if ((atPos <= 0) || (startPos <= 0) || (endPos <= 0))
                            break;
                        String file = this.stacktrace.substring(atPos + 3, startPos);
                        String contents = this.stacktrace.substring(startPos + 1, endPos);
                        file = file.substring(0, file.lastIndexOf("."));
                        file = StringUtil.replaceString(file, ".", "/");
                        file = file + ".java";
                        sb.append(this.stacktrace.substring(pos, startPos));
                        boolean found = false;
                        for (int i = 0; i < sourcePaths.size(); i++) {
                            File d = new File((String) sourcePaths.elementAt(i));
                            File f = new File(d, file);
                            if (f.exists()) {
                                sb.append("(<a href=\"file://" + f.getCanonicalPath() + "\">" + contents + "</a>" + ")");
                                found = true;
                                break;
                            }
                        }
                        if (!found) sb.append("(" + contents + ")");
                        pos = endPos + 1;
                    }

                }

                sb.append(this.stacktrace.substring(pos));
                this.stacktraceHTML = sb.toString();
            } catch (Throwable t) {
                this.stacktrace = ("stacktrace not available because: " + t);
                this.stacktraceHTML = ("stacktrace not available because: " + t);
            }
        }

        try {
            if (caller != null) {
                this.caller = caller.getClass().getName();
            }
        } catch (Exception e) {
            this.caller = "Could not determine caller";
        }
    }

    private String exceptionToString() {
        String result = "";
        try {
            if (this.exceptionName != null) {
                result = this.exceptionName + ": " + this.exceptionMessage;
                if (this.query != null) result = result + " while executing: " + this.query;
                result = result + "\n";
                if (this.stacktrace != null) result = result + this.stacktrace;
            }
        } catch (Exception e) {
            result = "Could not read exception";
        }

        return result;
    }

    private String exceptionToHTML() {
        String result = "";
        try {
            if (this.exceptionName != null) {
                String url = "http://java.sun.com/products/jdk/1.2/docs/api/" + StringUtil.replaceString(this.exceptionName, ".", "/") + ".html";
                result = "<a href=\"" + url + "\" target=\"new\">" + this.exceptionName + "</a>: " + StringUtil.toHTML(this.exceptionMessage);
                if (this.query != null) result = result + " while executing: " + StringUtil.toHTML(this.query);
                result = result + "\n";
                if (this.stacktraceHTML != null) result = result + this.stacktraceHTML;
            }
        } catch (Exception e) {
            result = "Could not read exception";
        }

        return result;
    }

    public String toString() {
        String EOL = System.getProperty("line.separator");
        String tmp1 = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss.SSS").format(this.date) + " [" + (this.severity < 10 ? " " : "") + this.severity + "] (" + this.threadName + ") " + this.text;
        String tmp2 = exceptionToString();
        String tmp3 = this.caller == null ? "" : this.caller;
        if (tmp1.length() > 0) tmp1 = tmp1 + EOL;
        if (tmp2.length() > 0) tmp2 = tmp2 + EOL;
        if (tmp3.length() > 0) tmp3 = tmp3 + EOL;
        return tmp1 + tmp2 + tmp3;
    }

    public String toHTML() {
        String EOL = "\n";
        String tmp1 = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss.SSS").format(this.date) + " [" + (this.severity < 10 ? " " : "") + this.severity + "] (" + this.threadName + ") " + StringUtil.toHTML(this.text);
        String tmp2 = exceptionToHTML();
        String tmp3 = this.caller == null ? "" : this.caller;
        if (tmp2.length() > 0) tmp2 = "<pre>" + tmp2 + "</pre>";
        if (tmp3.length() > 0) tmp3 = EOL + tmp3;

        return "<font color=\"" + color[this.severity] + "\">" + tmp1 + tmp2 + tmp3 + "</font>" + EOL;
    }
}

/* Location:           /Users/dave/kettle_river_consulting/customers/omni_workspace/iFrame framework/original code/
 * Qualified Name:     dynamic.util.diagnostics.DiagnosticsMessage
 * JD-Core Version:    0.6.2
 */