/*
 *               ApexIT, Inc.
 *
 * This software can only be used with the expressed written
 * consent of ApexIT, Inc. All rights reserved.
 *
 * Copyright 2009 ApexIT, Inc.
 * $Id: DateRange.java 175 2009-01-30 00:08:47Z bvonhaden $
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL APEXIT, INC.
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
 * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 * ====================================================================
 */
package com.dynamic.charm.ajax.controllers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.commons.beanutils.MethodUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.BeanWrapper;
import org.springframework.beans.BeanWrapperImpl;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.ModelAndView;

import com.dynamic.charm.common.LogUtil;
import com.dynamic.charm.service.QueryService;
import com.dynamic.charm.web.builder.CellElement;
import com.dynamic.charm.web.builder.HTMLElement;
import com.dynamic.charm.web.builder.ListItemElement;
import com.dynamic.charm.web.builder.RowElement;
import com.dynamic.charm.web.builder.TableElement;
import com.dynamic.charm.web.builder.UnorderedListElement;
import com.dynamic.charm.web.controller.BaseController;

/**
 * 
 * @version $Id$
 */
public abstract class AbstractAjaxController extends BaseController
{
	private QueryService queryService;

	private final static Logger logger = Logger.getLogger(AbstractAjaxController.class);

	public void registerRequiredProperties()
	{
		registerRequiredProperty("queryService");
	}

	public void afterPropertiesSetInternal()
	{}

	/**
	 * This will take requests in the form of [namedQueryId].ajx?[param1]=[value1]&[param2]=[value2]&[paramN]=[valueN]. 
	 */
	protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		String requestTarget = StringUtils.getFilename(request.getRequestURI());
		String[] requestParts = requestTarget.split("\\.");

		//check to see if we have a complete file.ext here
		if (requestParts.length < 2)
			return null;

		String queryId = requestParts[0];

		// copy to a map
		Map allParameters = new HashMap();
		Iterator iter = request.getParameterMap().keySet().iterator();
		while (iter.hasNext())
		{
			String name = (String) iter.next();
			if (!name.equals("_"))
			{
				allParameters.put(name, request.getParameter(name));
			}
		}

		Map queryParameters = extractQueryParameters(allParameters);

		//convert to parallel arrays
		List paramNames = new ArrayList();
		List paramValues = new ArrayList();

		for (Iterator iterator = queryParameters.entrySet().iterator(); iterator.hasNext();)
		{
			Entry entry = (Entry) iterator.next();
			if (!"prefix".equalsIgnoreCase((String) entry.getKey()) && !"idMethod".equalsIgnoreCase((String) entry.getKey())
					&& !"valueMethod".equalsIgnoreCase((String) entry.getKey()))
			{
				paramNames.add((String) entry.getKey());
				paramValues.add(entry.getValue());
			}
		}
		LogUtil.debugArray(logger, paramNames.toArray(), "paramNames");
		LogUtil.debugArray(logger, paramValues.toArray(), "paramValues");

		String[] pn = new String[paramNames.size()];
		for (int i = 0; i < paramNames.size(); i++)
		{
			pn[i] = (String) paramNames.get(i);
		}

		List results = queryService.namedQueryForList(queryId, pn, paramValues.toArray());

		results = extractQueryResults(request, results);

		writeResults(request, response, results, allParameters);

		return null;
	}

	/**
	 * Must implement this method in order to pull out which parameters from the request should actually be handed off to the namedQuery
	 * @param allparameters
	 * @return a new map containing the query specific parameters
	 */
	public abstract Map extractQueryParameters(Map allparameters);

	/**
	 * Must implement this method which will be used to manipulate the query results.  For instance, if was
	 * necessary to limit the result set to 20 items, you could do that here
	 * @param request
	 * @param queryResults
	 * @return
	 */
	public abstract List extractQueryResults(HttpServletRequest request, List queryResults);

	/**
	 * Write out your results to the response however you see fit
	 * @param request
	 * @param response
	 * @param results
	 * @param allParameters
	 * @throws IOException
	 */
	public abstract void writeResults(HttpServletRequest request, HttpServletResponse response, List results, Map allParameters)
			throws IOException, Exception;

	public void writeResultPairsAsUnorderedList(HttpServletResponse response, List results, String idPrefix, String idMethod,
			String valueMethod) throws IOException, Exception
	{
		writeResultPairsAsUnorderedList(response, results, idPrefix, idMethod, valueMethod, false);
	}
	
	public void writeResultPairsAsUnorderedListFromMap(HttpServletResponse response, List results, String idPrefix, String idMethod,
			String valueMethod) throws IOException, Exception
	{
		writeResultPairsAsUnorderedList(response, results, idPrefix, idMethod, valueMethod, true);
	}
	
	/**
	 * 
	 * @param response the servlet response
	 * @param results the list of data to put in the list
	 * @param idPrefix the prefix text to put before the ID value.
	 * @param idMethod the name of the getter method for the ID.
	 * @param valueMethod the name of the getter method for the value.
	 * @param fromMap true if the data is stored in a map instead of an object.
	 * @throws IOException
	 * @throws Exception
	 */
	public void writeResultPairsAsUnorderedList(HttpServletResponse response, List results, String idPrefix, String idMethod,
			String valueMethod, boolean fromMap) throws IOException, Exception
	{
		logger.debug("results = " + results);
		HTMLElement root = HTMLElement.createRootElement();
		UnorderedListElement ul = root.createUnorderedListElement();
		for (Iterator iter = results.iterator(); iter.hasNext();)
		{
			Object obj = iter.next();
			Object id = null;
			if (fromMap)
				id = (Object) MethodUtils.invokeExactMethod(obj, "get", new Object[]{idMethod}, new Class[]{Object.class});
			else
				id = (Object) MethodUtils.invokeExactMethod(obj, idMethod, null);
			Object value = null;
			if (fromMap)
				value = (Object) MethodUtils.invokeExactMethod(obj, "get", new Object[]{valueMethod}, new Class[]{Object.class});
			else
				value = (Object) MethodUtils.invokeExactMethod(obj, valueMethod, null);
				
			ListItemElement li = ul.createListItem();
			li.setAttribute("id", idPrefix + "_" + id);
			li.setText("" + value);
		}
		sendResults(response, ul.evaluate());
	}

	public void writeResultsAsUnorderedList(HttpServletResponse response, List results) throws IOException
	{
		logger.debug("results = " + results);
		HTMLElement root = HTMLElement.createRootElement();
		UnorderedListElement ul = root.createUnorderedListElement();
		for (Iterator iter = results.iterator(); iter.hasNext();)
		{
			ListItemElement li = ul.createListItem();
			li.setText(iter.next().toString());
		}

		sendResults(response, ul.evaluate());
	}

	public void writeResultsAsTable(HttpServletResponse response, List results) throws IOException
	{
		logger.debug("results = " + results);
		HTMLElement root = HTMLElement.createRootElement();
		TableElement table = root.createTableElement();
		for (Iterator iter = results.iterator(); iter.hasNext();)
		{
			RowElement tr = table.createRow();
			CellElement td = tr.createCell();
			td.setText((String) iter.next());
		}

		sendResults(response, table.evaluate());
	}

	public void writeResultsAsJson(HttpServletResponse response, List results) throws IOException
	{
		logger.debug("results = " + results);

		String classname = "Unknown";
		if (results.size() > 0)
			classname = results.get(0).getClass().getName();

		JSONObject resultSet = new JSONObject();
		resultSet.put("numResultsAvailable", new Integer(results.size()));
		resultSet.put("numResultsReturned", new Integer(results.size()));
		resultSet.put("resultsClass", classname);
		resultSet.put("results", results);

		JSONObject resultContainer = new JSONObject();
		resultContainer.put("ResultSet", resultSet);

		sendResults(response, resultContainer.toString());
	}

	/**
	 * Convenience method for writing out text to the browser.  This will set the contentType to <code>text/html</code>
	 * @param response
	 * @param text
	 * @param contentType
	 * @throws IOException
	 */
	public void sendResults(HttpServletResponse response, String text) throws IOException
	{
		sendResults(response, text, "text/html");
	}

	/**
	 * Convenience method for writing out text to the browser
	 * @param response
	 * @param text
	 * @param contentType
	 * @throws IOException
	 */
	public void sendResults(HttpServletResponse response, String text, String contentType) throws IOException
	{
		response.setContentType(contentType);
		response.setContentLength(text.length());
		if (true)
		{
			response.getOutputStream().print(text);
			response.getOutputStream().flush();
		}
		else
		{
			response.getWriter().write(text);
			response.getWriter().flush();
		}
	}

	public QueryService getQueryService()
	{
		return queryService;
	}

	public void setQueryService(QueryService queryService)
	{
		this.queryService = queryService;
	}

	/**
	 * Todo:  Move this to collectionUtils?
	 * @param c
	 * @param delim
	 * @return
	 */
	public String collectionToString(Collection c, String delim)
	{
		StringBuffer result = new StringBuffer();
		for (Iterator iter = c.iterator(); iter.hasNext();)
		{
			result.append(iter.next()).append(delim);
		}
		return result.toString();
	}

	/**
	 * Todo:  Move this to collectionUtils?
	 * @param c
	 * @param delim
	 * @return
	 */
	public String collectionToString(Collection c, String propertyName, String delim)
	{
		StringBuffer result = new StringBuffer();
		BeanWrapper bw = new BeanWrapperImpl();
		for (Iterator iter = c.iterator(); iter.hasNext();)
		{
			bw.setWrappedInstance(iter.next());
			result.append(bw.getPropertyValue(propertyName)).append(delim);
		}
		return result.toString();
	}

}
