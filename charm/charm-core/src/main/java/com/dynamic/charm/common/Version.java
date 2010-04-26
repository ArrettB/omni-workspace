/*
 *               ApexIT, Inc.
 *
 * This software can only be used with the expressed written
 * consent of ApexIT, Inc. All rights reserved.
 *
 * Copyright 2005, Dynamic Information Systems, LLC
 * Copyright 2007, ApexIT, Inc.
 * $Id: Version.java 413 2009-05-28 22:06:43Z bvonhaden $
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO
 * EVENT SHALL DYNAMIC INFORMATIONS SYTEMS, LLC
 * OR APEX IT BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * ====================================================================
 */


package com.dynamic.charm.common;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.log4j.Logger;


/**
 * Version information for the Charm application.
 *
 * This file should be modified and checked in to record the revision.
 * 
 * @version $Id: Version.java 413 2009-05-28 22:06:43Z bvonhaden $
 */
public class Version
{
    private static final String author = "$Author: bvonhaden $";
    private static final String date = "$Date: 2009-05-28 17:06:43 -0500 (Thu, 28 May 2009) $";
    private static final String project = "$project: charm-core$";
    private static final String revision = "$Revision: 413 $";
    private static final String url = "$URL: http://svn.apexit.com/svn/charm/trunk/charm-core/src/main/java/com/dynamic/charm/common/Version.java $";

 
    private final static String PARSE_DATE_PATTERN = "yyyy-MM-dd HH:mm:ss Z";
    private final static String FORMAT_DATE_PATTERN = "MM/dd/yyyy hh:mm a";

    private static final Logger logger = Logger.getLogger(Version.class);

    static
    {
        LogUtil.flowerBoxInfo(logger, getFullVersion());
    }

    private static String getValue(String expandedValue, String keyword)
    {
        return expandedValue.substring(keyword.length() + 3, expandedValue.length() - 1);
    }

    public static String getAuthor()
    {
        return getValue(author, "Author");
    }

    public static String getDate()
    {
        String result = getDateTime();
        int i = result.indexOf(" (");
        if (i != -1)
        {
            result = result.substring(0, i);
        }
        return result;
    }

    public static String getFormattedDate()
    {
        Date parsed = getParsedDate();
        if (parsed != null)
        {
            return new SimpleDateFormat(FORMAT_DATE_PATTERN).format(parsed);
        }
        else
        {
            return "unknown";
        }
    }

    public static Date getParsedDate()
    {
        try
        {
            return new SimpleDateFormat(PARSE_DATE_PATTERN).parse(getDate());
        }
        catch (ParseException e)
        {
            return null;
        }
    }

    public static String getDateTime()
    {
        return getValue(date, "Date");
    }

    public static String getProject()
    {
        return getValue(project, "Project");
    }

    public static String getRevision()
    {
        String result = getValue(revision, "Revision").trim();
        if (result.length() == 1)
        {
            result = "00" + result;
        }
        if (result.length() == 2)
        {
            result = "0" + result;
        }
        return result;
    }

    public static String getUrl()
    {
    	 return getValue(url, "URL");
    }
    
    public static String getFullVersion()
    {
        return getProject() + " [" + getRevision() + "] (" + getFormattedDate() + ")";
    }

    public String toString()
    {
        return getFullVersion();
    }

    public static void main(String[] argv)
    {
        System.out.println(getFullVersion());
    }
}
