package com.dynamic.charm;

import java.io.Serializable;
import java.util.Date;

import org.springframework.beans.BeanWrapper;
import org.springframework.beans.BeanWrapperImpl;
import org.springframework.context.ApplicationContext;

import com.dynamic.charm.examples.orm.User;
import com.dynamic.charm.query.hibernate.HibernateService;
import com.dynamic.charm.service.QueryService;
import com.dynamic.charm.web.form.tag.audit.AuditInfo;


public class SomeAuditInfo implements AuditInfo
{
	private String dateCreatedProperty = "dateCreated";
	private String dateModifiedProperty = "dateModified";
	private String createdByProperty = "createdBy";
	private String modifiedByProperty = "modifiedBy";

	private HibernateService hibernateService;
	private BeanWrapper wrapper;
	private ApplicationContext applicationContext;

	public void setApplicationContext(ApplicationContext context)
	{
		this.applicationContext = context;
		this.hibernateService = (HibernateService) context.getBean(QueryService.DEFAULT_HIBERNATE_SERVICE_NAME, HibernateService.class);
	}

	public void setAuditedObject(Object auditMe)
	{
		this.wrapper = new BeanWrapperImpl(auditMe);
	}

	public Date getDateCreated()
	{
		if (wrapper.isReadableProperty(dateCreatedProperty))
		{
			if (Date.class.equals(wrapper.getPropertyType(dateCreatedProperty)))
			{
				return (Date) wrapper.getPropertyValue(dateCreatedProperty);
			}
		}
		return null;
	}

	public Date getDateModified()
	{
		if (wrapper.isReadableProperty(dateModifiedProperty))
		{
			if (Date.class.equals(wrapper.getPropertyType(dateModifiedProperty)))
			{
				return (Date) wrapper.getPropertyValue(dateModifiedProperty);
			}
		}
		return null;
	}

	public String getCreatedByName()
	{
		if (wrapper.isReadableProperty(createdByProperty))
		{
			Object createdById = wrapper.getPropertyValue(createdByProperty);
			if (createdById != null)
			{
				User user = (User) hibernateService.get(User.class, (Serializable) createdById);
				return (user != null) ? user.getFirstName() + " " + user.getLastName() : null;
			}
		}
		return null;
	}


	public String getCreatedByEmail()
	{
		if (wrapper.isReadableProperty(createdByProperty))
		{
			Object createdById = wrapper.getPropertyValue(createdByProperty);
			if (createdById != null)
			{
				User user = (User) hibernateService.get(User.class, (Serializable) createdById);
				return (user != null) ? user.getEmail() : null;
			}
		}
		return null;
	}

	public String getModifiedName()
	{
		if (wrapper.isReadableProperty(modifiedByProperty))
		{
			Object createdById = wrapper.getPropertyValue(modifiedByProperty);
			if (createdById != null)
			{
				User user = (User) hibernateService.get(User.class, (Serializable) createdById);
				return (user != null) ? user.getFirstName() + " " + user.getLastName() : null;
			}
		}
		return null;
	}

	public String getModifiedEmail()
	{
		if (wrapper.isReadableProperty(modifiedByProperty))
		{
			Object createdById = wrapper.getPropertyValue(modifiedByProperty);
			if (createdById != null)
			{
				User user = (User) hibernateService.get(User.class, (Serializable) createdById);
				return (user != null) ? user.getEmail() : null;
			}
		}
		return null;
	}



}
