/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2003, Dynamic Information Systems, LLC
* $Id: LogUtil.java 199 2006-11-14 23:38:41Z gcase $

* THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
* OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED.  IN NO EVENT SHALL DYNAMIC INFORMATIONS SYTEMS, LLC
* BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
* SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
* LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
* USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
* OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
* SUCH DAMAGE.
* ====================================================================
*/


package com.dynamic.charm.common;

import org.apache.log4j.ConsoleAppender;
import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.apache.log4j.PatternLayout;
import org.apache.log4j.Priority;


/**
 * This class contains several methods for using the log4j logging libraries.  The flowerBox methods
 * are for decoration, they will take an existing message and format it with asterisks that surround the
 * message, useful for making certain priority messages to stand out.  A flowerboxed message looks like this:
 *
 *  <pre>
 * **********************************
 * **    This is the first line    **
 * ** And this is the second line  **
 * **      Finally, the third      **
 * **********************************
 *  </pre>
 * @author gcase
 */
public class LogUtil
{
    private static final String DEFAULT_LOG_PATTERN = "%d{DATE} [%-5p] %c - %m%n";
    private static final int NUM_STARS_ON_ENDS = 2;

    private LogUtil()
    {
    }

    /**
     * This method will add a ConsoleAppender to the root logger. This is
     * useful for standalone apps where you may not have a valid log4j.xml file
     * to be init log4j, and simply want to dump the output to the console.
     */
    public static void addConsoleAppender()
    {
        addConsoleAppender(false);
    }

    /**
     * This method will add a ConsoleAppender to the root logger. This is
     * useful for standalone apps where you may not have a valid log4j.xml file
     * to be init log4j, and simply want to dump the output to the console.
     *
     * @param onlyIfNoneExists
     *        If true, only add the logger if the root appender does not have
     *        any appenders set for it.
     */
    public static void addConsoleAppender(boolean onlyIfNoneExist)
    {
        if (!onlyIfNoneExist)
        {
            Logger.getRootLogger().addAppender(new ConsoleAppender(new PatternLayout(DEFAULT_LOG_PATTERN), ConsoleAppender.SYSTEM_OUT));
            Logger.getRootLogger().setLevel(Level.DEBUG);
        }
        else if (!Logger.getRootLogger().getAllAppenders().hasMoreElements())
        {
            Logger.getRootLogger().addAppender(new ConsoleAppender(new PatternLayout(DEFAULT_LOG_PATTERN), ConsoleAppender.SYSTEM_OUT));
            Logger.getRootLogger().setLevel(Level.DEBUG);
        }
    }

    /**
     * Logs a message in at DEBUG level, using a flowerbox to decorate the message. The width of the flowebox will be calculated
     * to allow for the length of the message.
     *
     * @param logger the logger to use
     * @param message the message that should be logged out
     */
    public static void flowerBoxDebug(Logger logger, String message)
    {
        if (message == null)
        {
            return;
        }
        else
        {
            flowerBox(logger, new String[] { message }, calcDefaultSize(message.length()), Level.DEBUG);
        }
    }

    /**
     * Logs a message in at DEBUG level, using a flowerbox to decorate the message.
     *
     * @param logger the logger to use
     * @param message the message that should be logged out
     * @param boxWidth the number of characters of the width of the decoration
     */
    public static void flowerBoxDebug(Logger logger, String message, int boxWidth)
    {
        if (message == null)
        {
            return;
        }
        else
        {
            flowerBox(logger, new String[] { message }, boxWidth, Level.DEBUG);
        }
    }

    /**
     * Logs a message in at DEBUG level, using a flowerbox to decorate the messages.  All of the messages
     * passed in will be contained in a single flowerbox.
     *
     * @param logger the logger to use
     * @param messages An array of messages that should be logged.
     */
    public static void flowerBoxDebug(Logger logger, String[] messages)
    {
        flowerBox(logger, messages, calcDefaultSize(getMaxLength(messages)), Level.DEBUG);
    }

    /**
     * Logs a message in at DEBUG level, using a flowerbox to decorate the messages.  All of the messages
     * passed in will be contained in a single flowerbox.  The width of the flowebox will be calculated
     * to allow for the length of the messages.
     *
     * @param logger the logger to use
     * @param messages An array of messages that should be logged.
     * @param boxWidth the number of characters of the width of the decoration
     */
    public static void flowerBoxDebug(Logger logger, String[] messages, int boxWidth)
    {
        flowerBox(logger, messages, boxWidth, Level.DEBUG);
    }

    /**
     * Logs a message in at INFO level, using a flowerbox to decorate the message. The width of the flowebox will be calculated
     * to allow for the length of the message.
     *
     * @param logger the logger to use
     * @param message the message that should be logged out
     */
    public static void flowerBoxInfo(Logger logger, String message)
    {
        if (message == null)
        {
            return;
        }
        else
        {
            flowerBox(logger, new String[] { message }, calcDefaultSize(message.length()), Level.INFO);
        }
    }

    /**
     * Logs a message in at INFO level, using a flowerbox to decorate the message.
     *
     * @param logger the logger to use
     * @param message the message that should be logged out
     * @param boxWidth the number of characters of the width of the decoration
     */
    public static void flowerBoxInfo(Logger logger, String message, int boxWidth)
    {
        if (message == null)
        {
            return;
        }
        else
        {
            flowerBox(logger, new String[] { message }, boxWidth, Level.INFO);
        }
    }

    /**
     * Logs a message in at INFO level, using a flowerbox to decorate the messages.  All of the messages
     * passed in will be contained in a single flowerbox.
     *
     * @param logger the logger to use
     * @param messages An array of messages that should be logged.
     */
    public static void flowerBoxInfo(Logger logger, String[] messages)
    {
        flowerBox(logger, messages, calcDefaultSize(getMaxLength(messages)), Level.INFO);
    }

    /**
     * Logs a message in at INFO level, using a flowerbox to decorate the messages.  All of the messages
     * passed in will be contained in a single flowerbox.  The width of the flowebox will be calculated
     * to allow for the length of the messages.
     *
     * @param logger the logger to use
     * @param messages An array of messages that should be logged.
     * @param boxWidth the number of characters of the width of the decoration
     */
    public static void flowerBoxInfo(Logger logger, String[] messages, int boxWidth)
    {
        flowerBox(logger, messages, boxWidth, Level.INFO);
    }

    /**
     * Logs a message in at WARN level, using a flowerbox to decorate the message. The width of the flowebox will be calculated
     * to allow for the length of the message.
     *
     * @param logger the logger to use
     * @param message the message that should be logged out
     */
    public static void flowerBoxWarn(Logger logger, String message)
    {
        if (message == null)
        {
            return;
        }
        else
        {
            flowerBox(logger, new String[] { message }, calcDefaultSize(message.length()), Level.WARN);
        }
    }

    /**
     * Logs a message in at WARN level, using a flowerbox to decorate the message.
     *
     * @param logger the logger to use
     * @param message the message that should be logged out
     * @param boxWidth the number of characters of the width of the decoration
     */
    public static void flowerBoxWarn(Logger logger, String message, int boxWidth)
    {
        if (message == null)
        {
            return;
        }
        else
        {
            flowerBox(logger, new String[] { message }, boxWidth, Level.WARN);
        }
    }

    /**
     * Logs a message in at WARN level, using a flowerbox to decorate the messages.  All of the messages
     * passed in will be contained in a single flowerbox.
     *
     * @param logger the logger to use
     * @param messages An array of messages that should be logged.
     */
    public static void flowerBoxWarn(Logger logger, String[] messages)
    {
        flowerBox(logger, messages, calcDefaultSize(getMaxLength(messages)), Level.WARN);
    }

    /**
     * Logs a message in at WARN level, using a flowerbox to decorate the messages.  All of the messages
     * passed in will be contained in a single flowerbox.  The width of the flowebox will be calculated
     * to allow for the length of the messages.
     *
     * @param logger the logger to use
     * @param messages An array of messages that should be logged.
     * @param boxWidth the number of characters of the width of the decoration
     */
    public static void flowerBoxWarn(Logger logger, String[] messages, int boxWidth)
    {
        flowerBox(logger, messages, boxWidth, Level.WARN);
    }

    /**
     * Logs a message in at ERROR level, using a flowerbox to decorate the message. The width of the flowebox will be calculated
     * to allow for the length of the message.
     *
     * @param logger the logger to use
     * @param message the message that should be logged out
     */
    public static void flowerBoxError(Logger logger, String message)
    {
        if (message == null)
        {
            return;
        }
        else
        {
            flowerBox(logger, new String[] { message }, calcDefaultSize(message.length()), Level.ERROR);
        }
    }

    /**
     * Logs a message in at ERROR level, using a flowerbox to decorate the message.
     *
     * @param logger the logger to use
     * @param message the message that should be logged out
     * @param boxWidth the number of characters of the width of the decoration
     */
    public static void flowerBoxError(Logger logger, String message, int boxWidth)
    {
        if (message == null)
        {
            return;
        }
        else
        {
            flowerBox(logger, new String[] { message }, boxWidth, Level.ERROR);
        }
    }

    /**
     * Logs a message in at ERROR level, using a flowerbox to decorate the messages.  All of the messages
     * passed in will be contained in a single flowerbox.
     *
     * @param logger the logger to use
     * @param messages An array of messages that should be logged.
     */
    public static void flowerBoxError(Logger logger, String[] messages)
    {
        flowerBox(logger, messages, calcDefaultSize(getMaxLength(messages)), Level.ERROR);
    }

    /**
     * Logs a message in at ERROR level, using a flowerbox to decorate the messages.  All of the messages
     * passed in will be contained in a single flowerbox.  The width of the flowebox will be calculated
     * to allow for the length of the messages.
     *
     * @param logger the logger to use
     * @param messages An array of messages that should be logged.
     * @param boxWidth the number of characters of the width of the decoration
     */
    public static void flowerBoxError(Logger logger, String[] messages, int boxWidth)
    {
        flowerBox(logger, messages, boxWidth, Level.ERROR);
    }

    private static void flowerBox(Logger l, String[] messages, int boxWidth, Priority priority)
    {
        String[] formattedMessages = new String[messages.length];

        if (l.isEnabledFor(priority))
        {
            StringBuffer topBottom = new StringBuffer();
            for (int i = 0; i < boxWidth; i++)
                topBottom.append("*");

            for (int messageIndex = 0; messageIndex < messages.length; messageIndex++)
            {
                String s = messages[messageIndex];

                if (s != null)
                {
                    int spacesOnLeft = (boxWidth - (NUM_STARS_ON_ENDS * 2) - s.length()) / 2;
                    int spacesOnRight = (boxWidth - (NUM_STARS_ON_ENDS * 2) - s.length()) - spacesOnLeft;

                    StringBuffer formatted = new StringBuffer();
                    for (int i = 0; i < NUM_STARS_ON_ENDS; i++)
                        formatted.append("*");
                    for (int i = 0; i < spacesOnLeft; i++)
                        formatted.append(" ");
                    formatted.append(s);
                    for (int i = 0; i < spacesOnRight; i++)
                        formatted.append(" ");
                    for (int i = 0; i < NUM_STARS_ON_ENDS; i++)
                        formatted.append("*");

                    formattedMessages[messageIndex] = formatted.toString();
                }
            }

            l.log(priority, topBottom);
            for (int messageIndex = 0; messageIndex < messages.length; messageIndex++)
            {
                if (formattedMessages[messageIndex] != null)
                {
                    l.log(priority, formattedMessages[messageIndex]);
                }
            }
            l.log(priority, topBottom);
        }
    }

    private static int calcDefaultSize(int originalLength)
    {
        return originalLength + ((NUM_STARS_ON_ENDS + 1) * 2);
    }

    private static int getMaxLength(String[] strings)
    {
        int max = -1;
        for (int i = 0; i < strings.length; i++)
        {
            if (strings[i] != null)
            {
                max = Math.max(strings[i].length(), max);
            }
        }
        return max;
    }

    public static void debugArray(Logger logger, Object[] array, String arrayName, int max)
    {
        if (logger.isDebugEnabled())
        {
            int num = Math.min(array.length, max);
            logger.debug("Value of " + arrayName + "[]:");
            for (int i = 0; i < num; i++)
            {
                logger.debug("   " + arrayName + "[" + i + "] = " + array[i]);
            }
            if (array.length > max)
            {
                logger.debug("Elements " + (max) + " to " + (array.length - 1) + " not shown");
            }
        }
    }

    public static void debugArray(Logger logger, Object[] array, String arrayName)
    {
        debugArray(logger, array, arrayName, 100);
    }
}
