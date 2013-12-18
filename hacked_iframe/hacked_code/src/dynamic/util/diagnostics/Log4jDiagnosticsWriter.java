package dynamic.util.diagnostics;

import dynamic.util.threads.BlockingQueue;
import org.apache.log4j.Appender;
import org.apache.log4j.FileAppender;
import org.apache.log4j.Logger;

import java.util.Enumeration;

/**
 * User: dave
 * Date: 5/31/13
 * Time: 5:43 PM
 */
public class Log4jDiagnosticsWriter extends DiagnosticsWriter {
    Log4jDiagnosticsWriter(String filePath, int level) {
        super(null, level);

        System.out.println("Setting up Log4jDiagnosticsWriter");

        Logger logger = Logger.getLogger("imslogger");

        Enumeration<Appender> appenders = logger.getAllAppenders();
        while(appenders.hasMoreElements()) {
            Appender a = appenders.nextElement();

            System.out.println("Looking at appender " + a.getName());

            if(a instanceof FileAppender) {
                FileAppender fileAppender = (FileAppender)a;
                String file = fileAppender.getFile();

                String fileSeparator = System.getProperty("file.separator");

                String newPath = filePath + fileSeparator + file;

                System.out.println("Setting log4j diagnostics to write to " + newPath);

                fileAppender.setFile(newPath);

                fileAppender.activateOptions();
            }
        }
    }

    public void run() {
        //System.out.println("Log4JDiagnosticsWriter starting...");
        DiagnosticsMessage msg = null;
        try {
            while( true )  {
                msg = (DiagnosticsMessage) this.queue.dequeue();

                if(msg == null) {
                    //System.out.println("Log4JDiagnosticsWriter sleeping...");
                    Thread.sleep(1000);
                } else {
                    do {
                        _handleMessage(msg);
                    } while( ( msg = (DiagnosticsMessage)this.queue.dequeue() ) != null );
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

    private void _handleMessage(DiagnosticsMessage msg) {
        Logger logger = Logger.getLogger("imslogger");

        //System.out.println("Log4JDiagnosticsWriter handling message severity= " + msg.severity + ", text=" + msg.text + ", thread=" +msg.threadName);
        switch(msg.severity) {
            case Diagnostics.FATAL: {
                if(msg.exceptionName != null) {
                    logger.fatal("Exception " + msg.exceptionName + " : " + msg.exceptionMessage);
                }
                logger.fatal(msg.toString());
                break;
            }
            case Diagnostics.ERROR: {
                if(msg.exceptionName != null) {
                    logger.error("Exception " + msg.exceptionName + " : " + msg.exceptionMessage);
                }
                logger.error(msg.toString());
                break;
            }
            case Diagnostics.WARNING: {
                if(msg.exceptionName != null) {
                    logger.warn("Exception " + msg.exceptionName + " : " + msg.exceptionMessage);
                }
                logger.warn(msg.toString());
                break;
            }
            case Diagnostics.STATUS: {
                if(msg.exceptionName != null) {
                    logger.info("Exception " + msg.exceptionName + " : " + msg.exceptionMessage);
                }
                logger.info(msg.toString());
                break;
            }
            case Diagnostics.DEBUG:
            case Diagnostics.DEBUG2:
            case Diagnostics.DEBUG3: {
                if(msg.exceptionName != null) {
                    logger.debug("Exception " + msg.exceptionName + " : " + msg.exceptionMessage);
                }
                logger.debug(msg.toString());
                break;
            }
            case Diagnostics.TRACE:
            case Diagnostics.MAX_LEVEL: {
                if(msg.exceptionName != null) {
                    logger.trace("Exception " + msg.exceptionName + " : " + msg.exceptionMessage);
                }
                logger.trace(msg.toString());
                break;
            }
            default: {
                logger.info(msg.toString());
            }
        }
    }
}
