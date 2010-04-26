/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: HrefBuilder.java 199 2006-11-14 23:38:41Z gcase $

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


package com.dynamic.charm.web.builder;

import java.util.Enumeration;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;


public class HrefBuilder
{
    private final static Logger logger = Logger.getLogger(HrefBuilder.class);
    private Map params = new LinkedHashMap();  //used to maintain entry order
    private String href;
    private String contextPath;

    public HrefBuilder(String href)
    {
        this(href, null);
    }

    public HrefBuilder(String href, String contextPath)
    {
        this.href = href;
        this.contextPath = contextPath;
    }

    public void addParameter(String paramName, String paramValue)
    {
        if ((paramName != null) && (paramValue != null))
        {
            params.put(paramName, paramValue);
        }
    }

    public void addParameter(String paramName, Object paramValue)
    {
        if ((paramName != null) && (paramValue != null))
        {
            params.put(paramName, paramValue.toString());
        }
    }

    public void addAllParameters(Map paramMap)
    {
        params.putAll(paramMap);
    }
    
    public void addAllParameters(HttpServletRequest request)
    {
    	Enumeration e = request.getParameterNames();
    	while (e.hasMoreElements())
    	{
    		String paramName = (String) e.nextElement();
    		addParameter(paramName, request.getParameter(paramName));
    	}
    }

    public String evaluate()
    {
        if ((contextPath == null) || (contextPath.length() == 0))
        {
        	contextPath = "";
        }
        
        StringBuffer result = new StringBuffer();
        result.append(contextPath);
        if (contextPath.endsWith("/") && href.startsWith("/"))
		{
			result.append(href.substring(1));
		}
        else if (contextPath.length() > 0 && !contextPath.endsWith("/") && !href.startsWith("/"))
        {
        	 result.append("/");
             result.append(href);
        }
        else
        {
            result.append(href);          	
        }
        
        boolean isFirstParam = (result.indexOf("?") < 0);
        for (Iterator iter = params.entrySet().iterator(); iter.hasNext();)
		{
			Map.Entry entry = (Map.Entry) iter.next();
			appendParam(result, (String)entry.getKey(), entry.getValue().toString(), isFirstParam);
			isFirstParam = false;
		}
 
        return result.toString();
    }

    private static void appendParam(StringBuffer buffer, String paramName, String paramValue,
        boolean isFirstParam)
    {
        buffer.append(isFirstParam ? '?' : '&').append(paramName).append("=").append(paramValue);
    }

    public String toString()
    {
        return evaluate();
    }
}
