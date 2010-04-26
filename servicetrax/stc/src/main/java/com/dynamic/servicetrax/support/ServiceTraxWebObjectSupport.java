package com.dynamic.servicetrax.support;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.InitializingBean;

import com.dynamic.charm.web.CharmWebObjectSupport;
import com.dynamic.servicetrax.interceptors.LoginInterceptor;

public abstract class ServiceTraxWebObjectSupport extends CharmWebObjectSupport implements InitializingBean
{
	public LoginCrediantials getLoginCrediantials()
	{
		HttpSession session = getSession();
		LoginCrediantials lc = (LoginCrediantials) session.getAttribute(LoginInterceptor.SESSION_ATTR_LOGIN);
		return lc;

	}

	public int getUserId()
	{
		return getLoginCrediantials().getUserId();
	}
	
	public int getOrganizationId()
	{
		return getLoginCrediantials().getOrganizationId();
	}


}
