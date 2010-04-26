/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: RequestInterceptor.java 199 2006-11-14 23:38:41Z gcase $

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


package com.dynamic.charm.web.interceptor;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.log4j.NDC;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.dynamic.charm.common.formats.ByteFormat;


public class RequestInterceptor implements HandlerInterceptor
{
    private final static Logger logger = Logger.getLogger(RequestInterceptor.class);

    private Map requestTimeMap = new HashMap();

    private int requestNumberCounter = 0;

    public boolean preHandle(HttpServletRequest request, HttpServletResponse response,
        Object handler) throws Exception
    {
        String requestNo = Integer.toString(getRequestNumber());
        NDC.push(requestNo);
        requestTimeMap.put(requestNo, new Long(System.currentTimeMillis()));
        
        if (logger.isInfoEnabled())
        {
            String queryString = request.getQueryString();
            if (queryString != null)
			{
				logger.info(request.getRequestURI()  + "?" + request.getQueryString());
			}
			else
            {
            	logger.info(request.getRequestURI());
            }       	
        }
        return true;
    }

    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
        ModelAndView modelAndView) throws Exception
    {
    }

    public void afterCompletion(HttpServletRequest request, HttpServletResponse response,
        Object handler, Exception ex) throws Exception
    {
        String requestNo = NDC.peek();
        
        long now = System.currentTimeMillis();
        long start = ((Long) requestTimeMap.remove(requestNo)).longValue();     
        long elapsed = (now - start);

        reportStatus(elapsed);

        NDC.pop();
    }

    private synchronized int getRequestNumber()
    {
        return ++requestNumberCounter;
    }

    private void reportStatus(long elapsedTime)
    {
    	if (logger.isInfoEnabled())
    	{
    		ByteFormat formatter = new ByteFormat();
            Runtime runtime = Runtime.getRuntime();
            long totalMemory = runtime.totalMemory();
            long freeMemory = runtime.freeMemory();
            long usedMemory = totalMemory - freeMemory;
            logger.info("Time:" + elapsedTime + "ms - Java Heap - Size:" + formatter.format(totalMemory) + " - Used:" + formatter.format(usedMemory));    		
    	}
    }
}
