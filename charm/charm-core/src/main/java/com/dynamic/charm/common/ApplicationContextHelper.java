package com.dynamic.charm.common;

import java.util.Locale;
import java.util.Map;

import org.springframework.context.ApplicationContext;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.context.support.MessageSourceAccessor;

import com.dynamic.charm.web.CharmWebObjectSupport;
import com.dynamic.charm.web.controller.BaseController;

/**
 * This class contains a handful of convenience methods for accessing application context resources.
 * It is used internally by CharmWebObjectSupport and BaseController to provide conistent methods to access messsages
 * and beans from the applicationcontext
 * 
 * @see CharmWebObjectSupport
 * @see BaseController
 * 
 * @author gcase
 *
 */
public class ApplicationContextHelper
{
	private ApplicationContext applicationContext;
	private MessageSourceAccessor messageSourceAccessor;

	public ApplicationContextHelper(ApplicationContext context)
	{
		this.applicationContext = context;
		this.messageSourceAccessor = new MessageSourceAccessor(context);
	}
	
	public Object getBean(String name)
	{
		return getApplicationContext().getBean(name);
	}

	public Object getBean(String name, Class requiredType)
	{
		return getApplicationContext().getBean(name, requiredType);
	}

	public Object[] getBeansOfType(Class requiredType)
	{
		Map beans = getApplicationContext().getBeansOfType(requiredType, false, false);
		return beans.values().toArray();
	}

	public String getMessage(String key)
	{
		return getMessage(key, null, null);
	}

	public String getMessage(String key, String defaultMessage)
	{
		return getMessage(key, defaultMessage, null);
	}

	public String getMessage(String key, Object[] args)
	{
		return getMessage(key, null, args);
	}
	
	public String getMessage(String key, String defaultMessage, Object[] args)
	{
		if (defaultMessage == null)
			defaultMessage = "???" + key + "???";
		return getMessageSourceAccessor().getMessage(key, args, defaultMessage, getLocale());
	}	
	
	public String getRawMessage(String key)
	{
		return getRawMessage(key, null);
	}

	public String getRawMessage(String key, Object[] args)
	{
		return getMessageSourceAccessor().getMessage(key, args, getLocale());
	}	
	
	public String getPrefixedMessage(Class prefixClass, String key)
	{
		key = prefixClass.getName() + "." + key;
		return getMessage(key, null, null);
	}

	public String getPrefixedMessage(Class prefixClass, String key, String defaultMessage)
	{
		key = prefixClass.getName() + "." + key;
		return getMessage(key, defaultMessage, null);
	}

	public String getPrefixedMessage(Class prefixClass, String key, Object[] args)
	{
		key = prefixClass.getName() + "." + key;
		return getMessage(key, null, args);
	}
	
	public String getPrefixedMessage(Class prefixClass, String key, String defaultMessage, Object[] args)
	{
		key = prefixClass.getName() + "." + key;
		return getMessage(key, defaultMessage, args);
	}	
	
 	
	public Locale getLocale()
	{
		return LocaleContextHolder.getLocale();
	}
	
	private MessageSourceAccessor getMessageSourceAccessor()
	{
		return messageSourceAccessor;
	}

	private ApplicationContext getApplicationContext()
	{
		return applicationContext;
	}

}
