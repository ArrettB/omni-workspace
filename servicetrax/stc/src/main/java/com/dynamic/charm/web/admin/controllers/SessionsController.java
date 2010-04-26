package com.dynamic.charm.web.admin.controllers;

import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;

import com.dynamic.charm.web.admin.interceptor.SessionDataPopulator;
import com.dynamic.charm.web.controller.BaseController;
import com.dynamic.charm.web.listeners.SessionListener;

public class SessionsController extends BaseController
{
	@Override
	public void afterPropertiesSetInternal() 
	{
	}

	@Override
	public void registerRequiredProperties() 
	{
	}
	
	protected ModelAndView handleRequestInternal(HttpServletRequest req, HttpServletResponse resp) throws Exception
	{
			ModelAndView result = new ModelAndView("admin/sessions");
			List sessionList = SessionListener.getSessionList(getServletContext());
			if (sessionList != null)
			{
				
			}
			else
			{
				result.addObject("message", "No session list object found, probably because CharmSessionListener has not been configured");
			}
			Map[] sessionInfo = new Map[sessionList.size()];
			int index = 0;
			for (Iterator iter = sessionList.iterator(); iter.hasNext();)
			{
				HttpSession session = (HttpSession) iter.next();
				Map sessionMap = new HashMap();
				sessionMap.put("id", session.getId());
				sessionMap.put("dateCreated", new Date(session.getCreationTime()));
				sessionMap.put("dateAccessed", new Date(session.getLastAccessedTime()));
				sessionMap.put("agent", session.getAttribute(SessionDataPopulator.ATTRIBUTE_AGENT));
				sessionMap.put("host", session.getAttribute(SessionDataPopulator.ATTRIBUTE_HOST));
				sessionMap.put("ipAddress", session.getAttribute(SessionDataPopulator.ATTRIBUTE_IP_ADDRESS));
				sessionMap.put("referer", session.getAttribute(SessionDataPopulator.ATTRIBUTE_REFERER));
				sessionMap.put("user", session.getAttribute(SessionDataPopulator.ATTRIBUTE_USER));

				sessionInfo[index++] = sessionMap;
			}
			result.addObject("sessions", sessionInfo);
		
		
			String id = getStringParameter(req, "id");
			if (id != null)
			{
				HttpSession session = SessionListener.getHttpSession(getServletContext(), id);
				if (session != null)
				{
					Map sessionData = new TreeMap();
					for (Enumeration enumeration = session.getAttributeNames(); enumeration.hasMoreElements();)
					{
						String attributeName = (String) enumeration.nextElement();
						sessionData.put(attributeName,session.getAttribute(attributeName));
					}
					result.addObject("selectedSession", sessionData);
				}
				
			}
			
			
		
		
		
		return result;
	}



	

}
