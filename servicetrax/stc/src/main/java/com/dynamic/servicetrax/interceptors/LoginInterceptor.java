package com.dynamic.servicetrax.interceptors;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.dynamic.charm.common.StringUtils;
import com.dynamic.charm.web.CharmWebObjectSupport;
import com.dynamic.servicetrax.dao.LoginDao;
import com.dynamic.servicetrax.service.SecurityService;
import com.dynamic.servicetrax.support.LoginCrediantials;
import com.dynamic.servicetrax.tc.TimeManager;

public class LoginInterceptor extends CharmWebObjectSupport implements HandlerInterceptor
{
	private String errorPageRedirect;
	private LoginDao loginDao;
	private SecurityService securityService;

	private String environment;

	public final static String SESSION_ATTR_LOGIN = LoginInterceptor.class.getName() + ".loginCrediantials";

	private static final String PARAM_AUTH = "auth";
	private static final String ENV_DEV = "Dev";


	@Override
	public void afterPropertiesSetInternal()
	{
	}

	@Override
	public void registerRequiredProperties()
	{
//		 registerRequiredProperty("errorPageRedirect");
//		 registerRequiredProperty("loginDao");
	}


	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception
	{
		if (ENV_DEV.equals(environment))
		{
			logger.warn("CREATING FAKE LOGIN CREDENTIALS - DEVELOPMENT PURPOSES ONLY");
			LoginCrediantials lc = new LoginCrediantials();
			lc.setUserId(580);
			lc.setOrganizationId(2);
			lc.setPaycodeTable("GP_MPLS_PAY_CODE_V");

			HttpSession session = request.getSession();
			session.setAttribute(LoginInterceptor.SESSION_ATTR_LOGIN, lc);

			return handleSuccess(request, response);
		}

		logger.info("getRequestURI = " + request.getRequestURI());
		String contextPath = request.getContextPath();
		String requestURI = request.getRequestURI();
		String requestPart = requestURI.substring(contextPath.length() + 1);
		HttpSession session = request.getSession();

		if (!errorPageRedirect.equals(requestPart))
		{
			String auth = request.getParameter(PARAM_AUTH);
			if (StringUtils.isBlank(auth))
			{
				LoginCrediantials lc = (LoginCrediantials) session.getAttribute(SESSION_ATTR_LOGIN);
				if (lc == null)
				{
					return handleError(request, response);
				}
				else
				{
					return handleSuccess(request, response);
				}
			}
			else
			{
				LoginCrediantials lc = loginDao.attempLogin(auth);
				if (lc == null)
				{
					return handleError(request, response);
				}
				else
				{
					session.setAttribute(SESSION_ATTR_LOGIN, lc);
					TimeManager tm = (TimeManager) getBean("timeManager");
					tm.clearSession(session);
					return handleSuccess(request, response);
				}
			}
		}
		else
		{
			return handleSuccess(request, response);
		}

	}


	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception
	{
	}

	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception modelAndView) throws Exception
	{
	}

	private boolean handleError(HttpServletRequest request, HttpServletResponse response) throws IOException
	{
		response.sendRedirect(errorPageRedirect);
		return false;
	}

	private boolean handleSuccess(HttpServletRequest request, HttpServletResponse response)
	{
		securityService.login(request, response);
		return true;
	}

	public void setErrorPageRedirect(String errorPageRedirect)
	{
		this.errorPageRedirect = errorPageRedirect;
	}

	public void setLoginDao(LoginDao loginDao)
	{
		this.loginDao = loginDao;
	}

	public void setEnvironment(String environment)
	{
		this.environment = environment;
	}

	public SecurityService getSecurityService() {
		return securityService;
	}

	public void setSecurityService(SecurityService securityService) {
		this.securityService = securityService;
	}


}
