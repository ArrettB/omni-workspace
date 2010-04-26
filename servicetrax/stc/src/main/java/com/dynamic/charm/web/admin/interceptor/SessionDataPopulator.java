package com.dynamic.charm.web.admin.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.dynamic.charm.web.listeners.SessionListener;

public class SessionDataPopulator implements InitializingBean, HandlerInterceptor, HttpSessionListener
{
	private final static Logger logger = Logger.getLogger(SessionDataPopulator.class);
	
	private final static String ATTRIBUTE_INIT = SessionDataPopulator.class.getName()+ ".init";
	
	/**
	 * The value assoicated with this key is the ip address of the client
	 */
	public static final String ATTRIBUTE_IP_ADDRESS = SessionDataPopulator.class.getName()+".ipAddress";

	/**
	 * The value assoicated with this key is the user agent (browser version string) of the client.
	 */
	public static final String ATTRIBUTE_AGENT = SessionDataPopulator.class.getName()+".userAgent";

	/**
	 * The value assoicated with this key is the referrring site, which an external site linking to us.
	 */
	public static final String ATTRIBUTE_REFERER = SessionDataPopulator.class.getName()+".referer";	
	
	/**
	 * The value assoicated with this key is the referrring site, which an external site linking to us.
	 */
	public static final String ATTRIBUTE_USER = SessionDataPopulator.class.getName()+".user";	

	/**
	 * The value assoicated with this key is the referrring site, which an external site linking to us.
	 */
	public static final String ATTRIBUTE_HOST = SessionDataPopulator.class.getName()+".host";	

	
	public void afterPropertiesSet() throws Exception
	{
		SessionListener csl = SessionListener.getInstance();
		if (csl != null)
		{
			csl.addChainedSessionListener(this);
		}
		else
		{
			logger.error("Could not find a CharmSessionListener instance!");
		}
	}


	public boolean preHandle(HttpServletRequest req, HttpServletResponse resp, Object handler) throws Exception
	{
		
		return true; //continue with other interceptors
	}


	public void postHandle(HttpServletRequest req, HttpServletResponse resp, Object handler, ModelAndView modelAndView) throws Exception
	{
		logger.debug("postHandle");
		HttpSession session  = req.getSession(false);
		if (session != null && session.getAttribute(ATTRIBUTE_INIT) != null)
		{
			logger.debug("Setting Session Data");

			session.setAttribute(ATTRIBUTE_AGENT, req.getHeader("User-Agent"));
			session.setAttribute(ATTRIBUTE_REFERER, req.getHeader("Referer"));
			session.setAttribute(ATTRIBUTE_IP_ADDRESS, req.getRemoteAddr());
			session.setAttribute(ATTRIBUTE_HOST, req.getRemoteHost());
			session.setAttribute(ATTRIBUTE_USER, req.getRemoteUser());

			if (logger.isDebugEnabled())
			{

				logger.debug("Agent = " + req.getHeader("User-Agent"));
				logger.debug("Referer = " + req.getHeader("Referer"));
				logger.debug("Address = " + req.getRemoteAddr());
				logger.debug("Host = " + req.getRemoteHost());
				logger.debug("User = " + req.getRemoteUser());
			}

			session.removeAttribute(ATTRIBUTE_INIT);
		}
		
		
		
	}


	public void afterCompletion(HttpServletRequest req, HttpServletResponse resp, Object handler, Exception e) throws Exception
	{
		
	}


	public void sessionCreated(HttpSessionEvent se)
	{
		se.getSession().setAttribute(ATTRIBUTE_INIT, Boolean.TRUE);
	}


	public void sessionDestroyed(HttpSessionEvent se)
	{
	}

}
