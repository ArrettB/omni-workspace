package com.dynamic.charm.web;


import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.HandlerExecutionChain;
import org.springframework.web.servlet.HandlerMapping;
import org.springframework.web.servlet.handler.SimpleUrlHandlerMapping;

/**
 * @see org.springframework.web.servlet.handler.SimpleUrlHandlerMapping
 */
public class MultiDelegatingHandlerMapping extends SimpleUrlHandlerMapping
{
	protected List handlerMappings = new ArrayList();
	
	private final static Logger logger = Logger.getLogger(MultiDelegatingHandlerMapping.class);
	
	public void registerHandlerMapping(HandlerMapping handlerMapping)
	{
		handlerMappings.add(handlerMapping);
	}
	
	public boolean removeHandlerMapping(HandlerMapping handlerMapping)
	{
		return handlerMappings.remove(handlerMapping);
	}
	
	
	
	
	protected Object getHandlerInternal(HttpServletRequest request) throws Exception
	{
		//ask each of the delegates, last non-null result wins
		Object result = null;
		for (Iterator iter = handlerMappings.iterator(); iter.hasNext();)
		{
			HandlerMapping mapping = (HandlerMapping) iter.next();
			HandlerExecutionChain chain = mapping.getHandler(request);
			if (chain != null)
			{
				result = chain.getHandler();
				logger.info(request.getRequestURI() + " will be handled by " + result + " defined in " + mapping);
			}
		}
		
		if (result == null)
			return super.getHandlerInternal(request);
		return 
			result;
	}
	

}

