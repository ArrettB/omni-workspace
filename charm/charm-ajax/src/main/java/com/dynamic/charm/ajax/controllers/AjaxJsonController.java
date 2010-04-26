package com.dynamic.charm.ajax.controllers;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

public class AjaxJsonController extends AbstractAjaxController
{
   
    private final static Logger logger = Logger.getLogger(AjaxJsonController.class);
    
	public Map extractQueryParameters(Map allparameters)
	{
		Map result = new HashMap();
		result.putAll(allparameters);
		if (result.containsKey("name"))
		{
			result.put("name", result.get("name") + "%");
		}
		return result;
	}

	public List extractQueryResults(HttpServletRequest request, List queryResults)
	{
		return queryResults;
	}

	public void writeResults(HttpServletRequest request, HttpServletResponse response, List results, Map allParameters) throws IOException
	{
		writeResultsAsJson(response, results);
   }
}
