/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: BrowserInfo.java 199 2006-11-14 23:38:41Z gcase $

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


package com.dynamic.charm.web;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;


public class BrowserInfo
{
    // for Safari build 125.1 finds version 125
    static final Pattern safariPattern = Pattern.compile("Safari/(\\d+)(?:\\.|\\s|$)",
            Pattern.CASE_INSENSITIVE); //$NON-NLS-1$

    public static boolean isBot(HttpServletRequest request)
    {
        String agent = request.getHeader("User-Agent").toLowerCase(); //$NON-NLS-1$

        // sample substring Mozilla/5.0 (compatible; Googlebot/2.1;
        // +http://www.google.com/bot.html)
        return (agent.indexOf("bot") >= 0) || (agent.indexOf("crawl") >= 0) //$NON-NLS-1$ //$NON-NLS-2$
            || (request.getParameter("bot") != null); //$NON-NLS-1$
    }

    public static boolean isGecko(HttpServletRequest request)
    {
        String agent = request.getHeader("User-Agent").toLowerCase(); //$NON-NLS-1$

        // sample substring Gecko/20020508
        // search for "gecko/" not to react to "like Gecko"
        return agent.indexOf("gecko/") >= 0; //$NON-NLS-1$
    }

    public static boolean isIE(HttpServletRequest request)
    {
        String agent = request.getHeader("User-Agent").toLowerCase(); //$NON-NLS-1$

        // When accessing with Bobby identified Bobby return 5.5 to allow
        // testing advanced UI as bobby cannot identifiy as IE >=5.5
        if (agent.startsWith("bobby/")) //$NON-NLS-1$
        {
            return true;
        }
        //

        return (agent.indexOf("msie") >= 0); //$NON-NLS-1$
    }

    public static String getIEVersion(HttpServletRequest request)
    {
        String agent = request.getHeader("User-Agent").toLowerCase(); //$NON-NLS-1$

        // When accessing with Bobby identified Bobby return 5.5 to allow
        // testing advanced UI as bobby cannot identifiy as IE >=5.5
        if (agent.startsWith("bobby/")) //$NON-NLS-1$
        {
            return "5.5"; //$NON-NLS-1$
        }
        //

        int start = agent.indexOf("msie ") + "msie ".length(); //$NON-NLS-1$ //$NON-NLS-2$
        if ((start < "msie ".length()) || (start >= agent.length())) //$NON-NLS-1$
        {
            return "0"; //$NON-NLS-1$
        }

        int end = agent.indexOf(";", start); //$NON-NLS-1$
        if (end <= start)
        {
            return "0"; //$NON-NLS-1$
        }
        return agent.substring(start, end);
    }

    public static boolean isKonqueror(HttpServletRequest request)
    {
        String agent = request.getHeader("User-Agent").toLowerCase(); //$NON-NLS-1$
        return agent.indexOf("konqueror") >= 0; //$NON-NLS-1$
    }

    public static boolean isMozilla(HttpServletRequest request)
    {
        String agent = request.getHeader("User-Agent").toLowerCase(); //$NON-NLS-1$
        return agent.indexOf("mozilla/5") >= 0; //$NON-NLS-1$
    }

    public static String getMozillaVersion(HttpServletRequest request)
    {
        String agent = request.getHeader("User-Agent").toLowerCase(); //$NON-NLS-1$
        if (agent.indexOf("mozilla/5") < 0) //$NON-NLS-1$
        {
            return "0"; //$NON-NLS-1$
        }

        int start = agent.indexOf("rv:") + "rv:".length(); //$NON-NLS-1$ //$NON-NLS-2$
        if ((start < "rv:".length()) || (start >= agent.length())) //$NON-NLS-1$
        {
            return "0"; //$NON-NLS-1$
        }

        int end = agent.indexOf(")", start); //$NON-NLS-1$
        if (end <= start)
        {
            return "0"; //$NON-NLS-1$
        }
        return agent.substring(start, end);
    }

    public static boolean isOpera(HttpServletRequest request)
    {
        String agent = request.getHeader("User-Agent").toLowerCase(); //$NON-NLS-1$
        return agent.indexOf("opera") >= 0; //$NON-NLS-1$
    }

    public static boolean isSafari(HttpServletRequest request)
    {
        String agent = request.getHeader("User-Agent").toLowerCase(); //$NON-NLS-1$
        return agent.indexOf("safari/") >= 0; //$NON-NLS-1$
    }

    public static String getSafariVersion(HttpServletRequest request)
    {
        String agent = request.getHeader("User-Agent").toLowerCase(); //$NON-NLS-1$
        Matcher m = safariPattern.matcher(agent);
        boolean matched = m.find();
        if (matched)
        {
            return m.group(1);
        }
        return "0"; //$NON-NLS-1$
    }
}
