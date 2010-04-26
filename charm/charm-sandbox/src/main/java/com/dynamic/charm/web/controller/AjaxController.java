package com.dynamic.charm.web.controller;

import java.io.StringWriter;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

import com.dynamic.charm.common.ArrayUtils;
import com.dynamic.charm.service.QueryService;
import com.thoughtworks.xstream.XStream;

public class AjaxController extends BaseController implements Controller
{
	private QueryService queryService;
	
	public void afterPropertiesSetInternal()
	{
	}

	public void registerRequiredProperties()
	{
		registerRequiredProperty("queryService");
	}
	
	
	protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		String requestTarget = StringUtils.getFilename(request.getRequestURI());
		String[] requestParts = requestTarget.split("\\.");
		
		String foo = request.getQueryString();
		
		//check to see if we have a complete file.ext here
		if(requestParts.length < 2)
			return null;
		
		String queryId = requestParts[0];

		//convert parameters to array		
		List paramNames = new ArrayList();
		List paramValues = new ArrayList();
		Iterator iter = request.getParameterMap().keySet().iterator();
		while (iter.hasNext())
		{
			String name = (String) iter.next();
			if (!name.equals("_"))
			{
				paramNames.add(name);
				paramValues.add(request.getParameter(name));
			}
		}

		String[] pn = (String[]) ArrayUtils.toArray(paramNames, String.class);
		String[] pv = (String[]) ArrayUtils.toArray(paramValues, String.class);
		
		List results = queryService.namedQueryForList(queryId, pn, pv);
		XStream xstream = new XStream();
	//	xstream.
		StringWriter tempWriter = new StringWriter();
	//	ObjectOutputStream out = xstream.createObjectOutputStream(tempWriter);
	//	out.writeObject(results);
	//	out.close();
		
		//dom4j stuff
		Document document = DocumentHelper.createDocument();
		Element ajaxResponse = document.addElement("ajax-response");
		Element responseElement = ajaxResponse.addElement("response");
		responseElement.addAttribute("type", "object");
		responseElement.addAttribute("id", "someUpdater");
		
		response.getWriter().write("<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>");
		response.getWriter().write("<ajax-response>");
		response.getWriter().write("<response type=\"object\" id=\"someUpdater\">");
		response.getWriter().write(tempWriter.toString());
		response.getWriter().write("</response>");
		response.getWriter().write("</ajax-response>");
		
		response.setContentType("text/xml");
		
		
		
		return null;
	}

	public QueryService getQueryService()
	{
		return queryService;
	}

	public void setQueryService(QueryService queryService)
	{
		this.queryService = queryService;
	}


	
	
}
