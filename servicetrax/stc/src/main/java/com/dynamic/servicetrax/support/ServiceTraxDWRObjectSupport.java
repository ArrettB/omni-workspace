package com.dynamic.servicetrax.support;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import uk.ltd.getahead.dwr.WebContextFactory;

public abstract class ServiceTraxDWRObjectSupport extends ServiceTraxWebObjectSupport
{
	@Override
	protected HttpServletRequest getRequest()
	{
		return WebContextFactory.get().getHttpServletRequest();
	}
	
	@Override
	protected HttpSession getSession()
	{
		return WebContextFactory.get().getSession(true);
	}
	
	@Override
	protected HttpServletResponse getResponse()
	{
		return null;
	}

}
