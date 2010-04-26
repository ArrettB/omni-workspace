package com.dynamic.charm.web.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class RedirectInterceptor extends HandlerInterceptorAdapter
{

	private final static Logger logger = Logger.getLogger(RedirectInterceptor.class);

	private static final String PREFIX = "redirect:";
	private static final String SUFFIX = ".rdr";

	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception
	{
		logger.debug("postHandle()");
		
//		String viewName = modelAndView.getViewName();
//		if (viewName != null && viewName.startsWith(PREFIX) && !viewName.endsWith(SUFFIX))
//		{
//			logger.debug("putting MODEL and VIEW in session");
//			logger.debug("viewName =" + viewName);
//			HrefBuilder builder = new HrefBuilder("Redirect.rdr");			
//						
//			viewName = viewName.substring(PREFIX.length());
////			builder.addAllParameters(request);
//
//			Map model = modelAndView.getModel();
//			request.getSession().setAttribute(RedirectViewController.KEY_MODEL, model);
//			request.getSession().setAttribute(RedirectViewController.KEY_VIEW_NAME, viewName);
//			
//			logger.debug("redirecting to " + builder.evaluate());
//			modelAndView.clear();
//			modelAndView.setViewName("redirect:" + builder.evaluate());
//			
//			
//		}
	}

}
