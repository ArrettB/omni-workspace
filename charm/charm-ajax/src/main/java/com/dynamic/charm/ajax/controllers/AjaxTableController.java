package com.dynamic.charm.ajax.controllers;
import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.dynamic.charm.common.Constants;
import com.dynamic.charm.exception.CharmException;
import com.dynamic.charm.exception.ParameterParseException;
import com.dynamic.charm.web.builder.HTMLElement;
import com.dynamic.charm.web.builder.RowElement;
import com.dynamic.charm.web.builder.TableElement;

public class AjaxTableController extends AbstractAjaxController
{
   
    private final static Logger logger = Logger.getLogger(AjaxTableController.class);
    
    
	public Map extractQueryParameters(Map allparameters)
	{
		Map result = new HashMap();
		result.putAll(allparameters);
		result.remove("page_size");
		result.remove("offset");
		result.remove("id");
		return result;
	}

	public List extractQueryResults(HttpServletRequest request, List queryResults)
	{
		List results = null;
		try
		{
			Integer offset = getIntegerParameter(request, "offset");
			Integer pageSize = getIntegerParameter(request, "page_size");
			if (offset != null)
			{
				// sublist is backed by original list Changes to sublist will
				// affect origina1!
				results = queryResults.subList(offset.intValue(), offset.intValue() + pageSize.intValue());
			}
			else
			{
				results = queryResults;
			}
		}
		
		catch (ParameterParseException e)
		{
			throw new CharmException("Parameter cant be parsed for ", e);
		}
		return results;
	}

	public void writeResults(HttpServletRequest request, HttpServletResponse response, List results, Map allParameters) throws IOException
	{
		HTMLElement root = HTMLElement.createRootElement();
		TableElement table = root.createTableElement();
		for (Iterator iter = results.iterator(); iter.hasNext();)
		{
			RowElement tr = table.createRow();
//			City city = (City) iter.next();
//			tr.createCell().setText(city.getCityId().toString());
//			tr.createCell().setText(city.getName().toString());
//			tr.createCell().setText(city.getState().toString());
		}

		StringBuffer rows = new StringBuffer();
		rows.append("<rows update_ui=\"true\">" + Constants.LINE_SEP);
		rows.append(table.evaluateChildren());
		rows.append("</rows>" + Constants.LINE_SEP);
		
		String ajaxXML = wrapAsPrototypeResponse("data_grid_updater", rows.toString());
		sendResults(response, ajaxXML, "text/xml");
		
	}
	
	
	

	public String wrapAsPrototypeResponse(String id, String contents)
	{
		StringBuffer result = new StringBuffer();
		result.append("<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>");
		result.append("<ajax-response>");
		result.append("<response type=\"object\" id=\"" + id + "\">");
		result.append(contents);
		result.append("</response>");
		result.append("</ajax-response>");

		return result.toString();
		
	}
	
}
