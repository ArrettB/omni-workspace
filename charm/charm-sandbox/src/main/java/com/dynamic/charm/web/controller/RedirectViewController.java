package com.dynamic.charm.web.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

public class RedirectViewController implements Controller
{

	public static final String KEY_MODEL = "RedirectViewController.MODEL";
	public static final String KEY_VIEW_NAME = "RedirectViewController.VIEW_NAME";

	private final static Logger logger = Logger.getLogger(RedirectViewController.class);

	public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		logger.debug("getting MODEL and VIEW from session");
		HttpSession session = request.getSession();
		Map model = (Map) session.getAttribute(KEY_MODEL);
		String viewName = (String) session.getAttribute(KEY_VIEW_NAME);
		logger.debug("viewName = " + viewName);

		return new ModelAndView(viewName, model);
	}
}
