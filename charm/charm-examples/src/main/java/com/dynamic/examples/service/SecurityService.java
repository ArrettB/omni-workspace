package com.dynamic.examples.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dynamic.charm.web.CharmWebObjectSupport;

public class SecurityService extends CharmWebObjectSupport implements com.dynamic.charm.service.SecurityService
{

	public void afterPropertiesSetInternal()
	{
	}

	public void registerRequiredProperties()
	{
	}

	public String getUserID(HttpServletRequest request)
	{
		return "1";
	}

	public void logout(HttpServletRequest request, HttpServletResponse response)
	{
	}

}
