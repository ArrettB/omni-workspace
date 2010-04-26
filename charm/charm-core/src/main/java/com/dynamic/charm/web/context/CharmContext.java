package com.dynamic.charm.web.context;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public interface CharmContext
{
	public HttpServletRequest getRequest();
	public void setRequest(HttpServletRequest request);
	public HttpServletResponse getResponse();
	public void setResponse(HttpServletResponse response);
}
