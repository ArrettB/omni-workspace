package com.dynamic.servicetrax.service;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.dynamic.charm.service.QueryService;
import com.dynamic.servicetrax.support.ServiceTraxWebObjectSupport;

public class SecurityService extends ServiceTraxWebObjectSupport implements com.dynamic.charm.service.SecurityService
{
	public final static String RIGHT_TYPE_VIEW = "view";
	public final static String RIGHT_TYPE_INSERT = "insert";
	public final static String RIGHT_TYPE_UPDATE = "update";
	public final static String RIGHT_TYPE_DELETE = "delete";

	public final static String SESSION_ATTR_RIGHTS = com.dynamic.charm.service.SecurityService.class.getName() + ".rights";

	private QueryService queryService;

	private final static Logger logger = Logger.getLogger(SecurityService.class);


	@Override
	public void afterPropertiesSetInternal()
	{
	}

	@Override
	public void registerRequiredProperties()
	{
		registerRequiredProperty("queryService");
	}

	public String getUserID(HttpServletRequest request)
	{
		return Integer.toString(getUserId());
	}

	public void logout(HttpServletRequest request, HttpServletResponse response)
	{
	}

	public void login(HttpServletRequest request, HttpServletResponse response)
	{
		request.getSession().removeAttribute(SESSION_ATTR_RIGHTS);
	}

	public boolean hasRight(HttpServletRequest request, String function, String rightType)
	{
		List<String> rights = (List<String>) request.getSession().getAttribute(SESSION_ATTR_RIGHTS);
		if (rights == null)
		{
			rights = loadRights(getUserID(request));
			request.getSession().setAttribute(SESSION_ATTR_RIGHTS, rights);
		}

		String functionRightCode = makeFunctionRightTypeCode(function, rightType);
		boolean result =  rights.contains(functionRightCode);
		if (result)
		{
			logger.info("User GRANTED access to " + functionRightCode);
		}
		else
		{
			logger.info("User DENIED access to " + functionRightCode);
		}
		return result;
	}


	private List<String> loadRights(String userId)
	{
		List queryResults = queryService.namedQueryForList("securityService.rights", userId);
		List<String> result = new ArrayList<String>(queryResults.size());
		for (Iterator iter = queryResults.iterator(); iter.hasNext();)
		{
			Map row = (Map) iter.next();
			String function = (String) row.get("function_code");
			String rightType = (String) row.get("right_type_code");
			logger.debug(row);
			result.add(makeFunctionRightTypeCode(function, rightType));
		}
		logger.info("Loaded " + result.size() + " rights for user: " + userId);
		return result;
	}

	public QueryService getQueryService()
	{
		return queryService;
	}

	public void setQueryService(QueryService queryService)
	{
		this.queryService = queryService;
	}

	private String makeFunctionRightTypeCode(String function, String rightType)
	{
		return function.toUpperCase() + "." + rightType.toUpperCase();
	}

}
