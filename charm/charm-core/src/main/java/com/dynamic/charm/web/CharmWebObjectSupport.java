package com.dynamic.charm.web;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang.SystemUtils;
import org.springframework.beans.BeanWrapper;
import org.springframework.beans.BeanWrapperImpl;
import org.springframework.beans.factory.BeanInitializationException;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.web.context.support.WebApplicationObjectSupport;

import com.dynamic.charm.common.ApplicationContextHelper;
import com.dynamic.charm.exception.ParameterMissingException;
import com.dynamic.charm.exception.ParameterParseException;
import com.dynamic.charm.web.context.CharmContext;
import com.dynamic.charm.web.context.CharmContextHolder;
import com.dynamic.charm.web.interceptor.ContextHolderInterceptor;


/**
 * This class is designed to provide a convenient superclass for objects that
 * need to interact with the ApplicationContext and the HttpServletRequest. By
 * using the ContextHolderInterceptor, this class can use the CharmContext to
 * access the servlet request and response
 * 
 * 
 * Here is an example of you would configure this in your dispath-servlet.xml:
 * 
 * <pre>
 * 	&lt;bean id=&quot;urlMapping&quot; class=&quot;org.springframework.web.servlet.handler.SimpleUrlHandlerMapping&quot;&gt;
 * 		&lt;property name=&quot;interceptors&quot;&gt;
 * 			&lt;list&gt;
 * 				&lt;ref bean=&quot;contextInterceptor&quot; /&gt;
 * 			&lt;/list&gt;
 * 		&lt;/property&gt;
 * 		&lt;property name=&quot;mappings&quot;&gt;
 * 			&lt;props&gt;
 * 			&lt;/props&gt;
 * 		&lt;/property&gt;
 * 	&lt;/bean&gt;
 * 
 * 	&lt;bean id=&quot;contextInterceptor&quot; class=&quot;com.dynamic.charm.web.interceptor.ContextHolderInterceptor&quot;&gt;
 * 	&lt;/bean&gt;
 * </pre>
 * 
 * @see CharmContextHolder
 * @see CharmContext
 * @see ContextHolderInterceptor
 * @author gcase
 * 
 */
public abstract class CharmWebObjectSupport extends WebApplicationObjectSupport implements InitializingBean
{
	protected List requiredProperties = new LinkedList();

	protected ApplicationContextHelper applicationContextHelper;

	public CharmWebObjectSupport()
	{
		registerRequiredProperties();
	}

	public abstract void registerRequiredProperties();

	public abstract void afterPropertiesSetInternal();

	public void registerRequiredProperty(String propertyName)
	{
		requiredProperties.add(propertyName);
	}

	public void afterPropertiesSet() throws Exception
	{
		for (Iterator iter = requiredProperties.iterator(); iter.hasNext();)
		{
			String propertyName = (String) iter.next();
			BeanWrapper bw = new BeanWrapperImpl(this);
			if (bw.isReadableProperty(propertyName))
			{
				Object propValue = BeanUtils.getProperty(this, propertyName);
				if (propValue == null) 
				{
					throw new BeanInitializationException(propertyName + " is a required property of " + this.getClass().getName() + ".  Please edit your configuration fiile accordingly."); 
				}
			}
			else
			{
				throw new BeanInitializationException(propertyName + " can not be read on "+ this.getClass().getName() + ".   Make sure the class has a getter for the property."); 
			}

		}

		if (SystemUtils.isJavaVersionAtLeast(1.5f))
		{
			// getClass().getf
		}
		applicationContextHelper = new ApplicationContextHelper(getApplicationContext());

		afterPropertiesSetInternal();
	}

	protected HttpServletRequest getRequest()
	{
		return CharmContextHolder.getContext().getRequest();
	}

	protected HttpServletResponse getResponse()
	{
		return CharmContextHolder.getContext().getResponse();
	}

	protected HttpSession getSession()
	{
		return getRequest().getSession(true);
	}

	public void setSessionAttribute(HttpServletRequest req, String attributeName, Object value)
	{
		getSession().setAttribute(attributeName, value);
	}

	public Object getSessionAttribute(HttpServletRequest req, String attributeName)
	{
		return getSession().getAttribute(attributeName);
	}

	public void removeSessionAttribute(HttpServletRequest req, String attributeName)
	{
		getSession().removeAttribute(attributeName);
	}

	public Boolean getBooleanParameter(String parameterName, boolean defaultValue) throws ParameterParseException
	{
		return RequestUtils.getBooleanParameter(getRequest(), parameterName, defaultValue);
	}

	public Boolean getBooleanParameter(String parameterName, Boolean defaultValue) throws ParameterParseException
	{
		return RequestUtils.getBooleanParameter(getRequest(), parameterName, defaultValue);
	}

	public Boolean getBooleanParameter(String parameterName) throws ParameterParseException
	{
		return RequestUtils.getBooleanParameter(getRequest(), parameterName);
	}

	public Double getDoubleParameter(String parameterName, double defaultValue) throws ParameterParseException
	{
		return RequestUtils.getDoubleParameter(getRequest(), parameterName, defaultValue);
	}

	public Double getDoubleParameter(String parameterName, Double defaultValue) throws ParameterParseException
	{
		return RequestUtils.getDoubleParameter(getRequest(), parameterName, defaultValue);
	}

	public Double getDoubleParameter(String parameterName) throws ParameterParseException
	{
		return RequestUtils.getDoubleParameter(getRequest(), parameterName);
	}

	public Float getFloatParameter(String parameterName, Float defaultValue) throws ParameterParseException
	{
		return RequestUtils.getFloatParameter(getRequest(), parameterName, defaultValue);
	}

	public Float getFloatParameter(String parameterName) throws ParameterParseException
	{
		return RequestUtils.getFloatParameter(getRequest(), parameterName);
	}

	public Float getFloatParameter(String parameterName, float defaultValue) throws ParameterParseException
	{
		return RequestUtils.getFloatParameter(getRequest(), parameterName, defaultValue);
	}

	public Integer getIntegerParameter(String parameterName, int defaultValue) throws ParameterParseException
	{
		return RequestUtils.getIntegerParameter(getRequest(), parameterName, defaultValue);
	}

	public Integer getIntegerParameter(String parameterName, Integer defaultValue) throws ParameterParseException
	{
		return RequestUtils.getIntegerParameter(getRequest(), parameterName, defaultValue);
	}

	public Integer getIntegerParameter(String parameterName) throws ParameterParseException
	{
		return RequestUtils.getIntegerParameter(getRequest(), parameterName);
	}

	public Long getLongParameter(String parameterName, long defaultValue) throws ParameterParseException
	{
		return RequestUtils.getLongParameter(getRequest(), parameterName, defaultValue);
	}

	public Long getLongParameter(String parameterName, Long defaultValue) throws ParameterParseException
	{
		return RequestUtils.getLongParameter(getRequest(), parameterName, defaultValue);
	}

	public Long getLongParameter(String parameterName) throws ParameterParseException
	{
		return RequestUtils.getLongParameter(getRequest(), parameterName);
	}

	public Boolean getRequiredBooleanParameter(String parameterName) throws ParameterMissingException, ParameterParseException
	{
		return RequestUtils.getRequiredBooleanParameter(getRequest(), parameterName);
	}

	public Double getRequiredDoubleParameter(String parameterName) throws ParameterMissingException, ParameterParseException
	{
		return RequestUtils.getRequiredDoubleParameter(getRequest(), parameterName);
	}

	public Float getRequiredFloatParameter(String parameterName) throws ParameterMissingException, ParameterParseException
	{
		return RequestUtils.getRequiredFloatParameter(getRequest(), parameterName);
	}

	public Integer getRequiredIntegerParameter(String parameterName) throws ParameterMissingException, ParameterParseException
	{
		return RequestUtils.getRequiredIntegerParameter(getRequest(), parameterName);
	}

	public Long getRequiredLongParameter(String parameterName) throws ParameterMissingException, ParameterParseException
	{
		return RequestUtils.getRequiredLongParameter(getRequest(), parameterName);
	}

	public String getRequiredStringParameter(String parameterName) throws ParameterMissingException
	{
		return RequestUtils.getRequiredStringParameter(getRequest(), parameterName);
	}

	public String getStringParameter(String parameterName, String defaultValue)
	{
		return RequestUtils.getStringParameter(getRequest(), parameterName, defaultValue);
	}

	public String getStringParameter(String parameterName)
	{
		return RequestUtils.getStringParameter(getRequest(), parameterName);
	}

	public Object getBean(String name, Class requiredType)
	{
		return applicationContextHelper.getBean(name, requiredType);
	}

	public Object getBean(String name)
	{
		return applicationContextHelper.getBean(name);
	}

	public Object[] getBeansOfType(Class requiredType)
	{
		return applicationContextHelper.getBeansOfType(requiredType);
	}

	public String getMessage(String key, Object[] args)
	{
		return applicationContextHelper.getMessage(key, args);
	}

	public String getMessage(String key, String defaultMessage, Object[] args)
	{
		return applicationContextHelper.getMessage(key, defaultMessage, args);
	}

	public String getMessage(String key, String defaultMessage)
	{
		return applicationContextHelper.getMessage(key, defaultMessage);
	}

	public String getMessage(String key)
	{
		return applicationContextHelper.getMessage(key);
	}

	public String getPrefixedMessage(Class prefixClass, String key, Object[] args)
	{
		return applicationContextHelper.getPrefixedMessage(prefixClass, key, args);
	}

	public String getPrefixedMessage(Class prefixClass, String key, String defaultMessage, Object[] args)
	{
		return applicationContextHelper.getPrefixedMessage(prefixClass, key, defaultMessage, args);
	}

	public String getPrefixedMessage(Class prefixClass, String key, String defaultMessage)
	{
		return applicationContextHelper.getPrefixedMessage(prefixClass, key, defaultMessage);
	}

	public String getPrefixedMessage(Class prefixClass, String key)
	{
		return applicationContextHelper.getPrefixedMessage(prefixClass, key);
	}

}
