package com.dynamic.charm.web.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.dynamic.charm.web.context.CharmContext;
import com.dynamic.charm.web.context.CharmContextHolder;

/**
 * 
 * 
 * The ContextHolderInterceptor is a HandlerInterceptor which populates the CharmContext with the servlet request and response
 * at the beginning of a request.  It should be the first interceptor defined in the HandlerMapping.
 * 
 *  <pre>
 *	&lt;bean id="urlMapping" class="org.springframework.web.servlet.handler.SimpleUrlHandlerMapping"&gt;
 *		&lt;property name="interceptors"&gt;
 *			&lt;list&gt;
 *				&lt;ref bean="contextInterceptor" /&gt;
 *			&lt;/list&gt;
 *		&lt;/property&gt;
 *		&lt;property name="mappings"&gt;
 *			&lt;props&gt;
 *			&lt;/props&gt;
 *		&lt;/property&gt;
 *	&lt;/bean&gt;
 *
 *	&lt;bean id="contextInterceptor" class="com.dynamic.charm.web.interceptor.ContextHolderInterceptor"&gt;
 *	&lt;/bean&gt;
 * </pre>
 * 
 * 
 * @author gcase
 *
 *@see HandlerInterceptor
 *@see CharmContext
 *@see CharmContextHolder
 */
public class ContextHolderInterceptor implements HandlerInterceptor
{

	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception
	{
		CharmContext context = CharmContextHolder.getContext();
		context.setRequest(request);
		context.setResponse(response);
		return true;
	}
	
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception
	{
	}

	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception e) throws Exception
	{
		CharmContextHolder.clearContext();
	}

}
