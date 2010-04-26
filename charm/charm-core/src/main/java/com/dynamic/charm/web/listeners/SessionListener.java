/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.

 * Copyright 2005, Dynamic Information Systems, LLC
 * $Id: SessionListener.java 199 2006-11-14 23:38:41Z gcase $

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

package com.dynamic.charm.web.listeners;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import org.apache.log4j.Logger;

import com.dynamic.charm.exception.CharmException;





/**
 * 
 * 
 * 
 * <br><br>
 * In order
 * for the SessionListener to function properly, it must be configured in your web.xml file
 * in the WEB-INF directory.  This is necessary because that is the only way to notify the
 * application server that this class needs to be registerd as a HttpSessionActivationListener and
 * HttpSessionListener.  By being a registerd as a listener this is able to pass along those
 * notfications to the individual SessionDataListeners contained within the class.   To do this,
 * place the following in your web.xml file, after your <code>context-param</code> section but
 * before your <code>servlet</code>.
 * 
 *<pre>
 *	&lt;listener&gt;
 *		&lt;listener-class&gt;com.dynamic.charm.web.CharmSessionListener&lt;/listener-class&gt;
 *	&lt;/listener&gt;
 *</pre>
 * 
 * 
 * @author gcase
 *
 */
public class SessionListener implements ServletContextListener, HttpSessionListener
{
	private final List listeners = new ArrayList();

	private final static Logger logger = Logger.getLogger(SessionListener.class);
	private static SessionListener instance = null;

	public static final String SESSION_MAP_ATTRIBUTE = SessionListener.class.getName() + ".sessionMap";
	public static final String INSTANCE_ATTRIBUTE = SessionListener.class.getName() + ".instance";


	public SessionListener()
	{
		synchronized (this)
		{
			if (instance == null)
			{
				instance = this;
			}
			else
			{
				throw new CharmException("Multiple instances of SessionListener created.  This class should only be created by the servlet container!");
			}
		}
	}

	public static SessionListener getInstance()
	{
		return instance;
	}
	
	
	public void contextInitialized(ServletContextEvent event)
	{
		logger.info("Context Initialized");
		event.getServletContext().setAttribute(SESSION_MAP_ATTRIBUTE, new HashMap());
		event.getServletContext().setAttribute(INSTANCE_ATTRIBUTE, this);
	}

	public void contextDestroyed(ServletContextEvent e)
	{
		logger.info("Context Destroyed");
	}

	public void sessionCreated(HttpSessionEvent event)
	{
		logger.info("Session created:" + event.getSession().getId());

		HttpSession session = event.getSession();
		Map sessionMap = (Map) session.getServletContext().getAttribute(SESSION_MAP_ATTRIBUTE);
		sessionMap.put(session.getId(), session);
		for (Iterator iter = listeners.iterator(); iter.hasNext();)
		{
			HttpSessionListener listener = (HttpSessionListener) iter.next();
			listener.sessionCreated(event);
		}

	}

	public void sessionDestroyed(HttpSessionEvent event)
	{
		logger.info("Session destroyed:" + event.getSession().getId());

		HttpSession session = event.getSession();
		Map sessionMap = (Map) session.getServletContext().getAttribute(SESSION_MAP_ATTRIBUTE);
		sessionMap.remove(session.getId());
		for (Iterator iter = listeners.iterator(); iter.hasNext();)
		{
			HttpSessionListener listener = (HttpSessionListener) iter.next();
			listener.sessionDestroyed(event);
		}
	}

	public void addChainedSessionListener(HttpSessionListener sl)
	{
		listeners.add(sl);
	}

	public void removeChainedSessionListener(HttpSessionListener sl)
	{
		listeners.remove(sl);
	}

	public static Map getSessionMap(ServletContext sc)
	{
		Map sessionMap = (Map) sc.getAttribute(SESSION_MAP_ATTRIBUTE);
		if (sessionMap != null)
		{
			return Collections.unmodifiableMap(sessionMap);
		}
		else
		{
			//log error
			return null;
		}

	}

	public static List getSessionList(ServletContext sc)
	{

		Map sessionMap = (Map) sc.getAttribute(SESSION_MAP_ATTRIBUTE);
		if (sessionMap != null)
		{
			return Collections.unmodifiableList(new ArrayList(sessionMap.values()));
		}
		else
		{
			//log error
			return null;
		}
	}

	public static HttpSession getHttpSession(ServletContext sc, String identifier)
	{
		Map sessionMap = (Map) sc.getAttribute(SESSION_MAP_ATTRIBUTE);
		if (sessionMap != null)
		{
			return (HttpSession) sessionMap.get(identifier);
		}
		else
		{
			//log error
			return null;
		}
	}	
	
	
	
}
