/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.

 * Copyright 2005, Dynamic Information Systems, LLC
 * $Id: ExceptionUtils.java 199 2006-11-14 23:38:41Z gcase $

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


package com.dynamic.charm.exception;

import java.io.StringWriter;


/**
 * @author gcase
 *
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class ExceptionUtils
{
    public static String formatStackTrace(Throwable e, String lineBreak)
    {
        StringWriter writer = new StringWriter();
        formatStackTrace(e, lineBreak, writer);
        return writer.toString();
    }

    public static void formatStackTrace(Throwable e, String lineBreak, StringWriter writer)
    {
        StackTraceElement[] trace = e.getStackTrace();
        writer.write(e.toString());
        if (e.getMessage() != null)
        {
        	writer.write(lineBreak);
        	writer.write("Message: " + e.getMessage());     	
        }
        for (int i = 0; i < trace.length; i++)
        {
            writer.write(lineBreak);
            writer.write(" at " + trace[i].toString());
        }
        writer.flush();
    }

    public static String formatStackTraceForWeb(Throwable e)
    {
        return formatStackTrace(e, "<br>");
    }

    public static String formatStackTrace(Throwable e)
    {
        return formatStackTrace(e, "\t\n");
    }
}
