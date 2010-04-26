package com.dynamic.charm.web.form.tag.audit;

import org.springframework.beans.BeanWrapper;
import org.springframework.beans.BeanWrapperImpl;
import org.springframework.context.ApplicationContext;

import com.dynamic.charm.exception.CharmException;
import com.dynamic.charm.service.QueryService;

public abstract class AbstractAuditInfo implements AuditInfo
{
	protected BeanWrapper wrapper;	
	protected ApplicationContext applicationContext;
	protected QueryService queryService;

	public void setApplicationContext(ApplicationContext context)
	{
		this.applicationContext = context;
		this.queryService = (QueryService) context.getBean(QueryService.DEFAULT_QUERY_SERVICE_NAME, QueryService.class);
	}

	public void setAuditedObject(Object auditMe)
	{
		this.wrapper = new BeanWrapperImpl(auditMe);
	}
	
	protected Object getProperty(String propertyName)
	{
		Object result = null;
		if (wrapper.isReadableProperty(propertyName))
		{
			result = wrapper.getPropertyValue(propertyName);
		}
		else
		{
			throw new CharmException(propertyName + " can not be read on " + wrapper.getWrappedInstance());
		}
		return result;
	}
	
	protected Object getProperty(String propertyName, Class expectedClass)
	{
		Object result = null;
		if (wrapper.isReadableProperty(propertyName))
		{
			if (expectedClass.isAssignableFrom(wrapper.getPropertyType(propertyName)))
			{
				result = wrapper.getPropertyValue(propertyName);
			}
			else
			{
				throw new CharmException("Value of " + propertyName + " from target " + wrapper.getWrappedInstance() + " can not be assigned to " + expectedClass.getName());
			}
		}
		else
		{
			throw new CharmException(propertyName + " can not be read on " + wrapper.getWrappedInstance());

		}
		return result;
	}



}
