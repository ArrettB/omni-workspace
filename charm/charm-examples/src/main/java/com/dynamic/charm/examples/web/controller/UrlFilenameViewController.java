package com.dynamic.charm.examples.web.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

/**
 * Acts similiarly to the org.springframework.web.servlet.mvc.UrlFilenameViewController, except it does
 * not remove the path information after the context.
 * @author gcase
 *
 */
public class UrlFilenameViewController implements Controller
{
	private final static Logger logger = Logger.getLogger(UrlFilenameViewController.class);
	
	public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response)
	{
		logger.debug("handleRequest()");
		
		String uri = request.getRequestURI();
		String pathInfo = request.getPathInfo();
		String context = request.getContextPath();
		
		logger.debug("uri = " + uri);
		logger.debug("pathInfo = " + pathInfo);
		logger.debug("context = " + context);
		
		//remove the context
		int begin = context.length() + 1;
		
/*		
 		int begin = uri.lastIndexOf('/');
		if (begin == -1)
		{
			begin = 0;
		} else
		{
			begin++;
		}
*/
		int end;
		if (uri.indexOf(";") != -1)
		{
			end = uri.indexOf(";");
		} else if (uri.indexOf("?") != -1)
		{
			end = uri.indexOf("?");
		} else
		{
			end = uri.length();
		}
		String fileName = uri.substring(begin, end);
		if (fileName.indexOf(".") != -1)
		{
			fileName = fileName.substring(0, fileName.lastIndexOf("."));
		}
		return new ModelAndView(fileName);
	}

}
