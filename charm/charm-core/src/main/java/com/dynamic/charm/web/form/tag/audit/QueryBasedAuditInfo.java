package com.dynamic.charm.web.form.tag.audit;

import java.util.Date;
import java.util.Map;

import org.springframework.beans.BeanWrapper;
import org.springframework.beans.BeanWrapperImpl;

import com.dynamic.charm.common.StringUtils;
import com.dynamic.charm.exception.PropertyNotSetException;

public class QueryBasedAuditInfo extends AbstractAuditInfo implements AuditInfo
{
	private String namedQueryId;

	private String modifiedByIdProperty;

	private String createdByIdProperty;

	private String dateCreatedProperty;

	private String dateModifiedProperty;

	private String nameColumn;

	private String emailColumn;

	private String modifiedByNameValue;

	private String modifiedByEmailValue;

	private String createdByNameValue;

	private String createdByEmailValue;

	public void setAuditedObject(Object auditMe)
	{
		super.setAuditedObject(auditMe);

		Object modifiedById = getProperty(modifiedByIdProperty);
		if (modifiedById != null)
		{
			Object modifiedByResult = queryService.namedQueryForObject(namedQueryId, modifiedById);
			if (modifiedByResult instanceof Map)
			{
				Map result = (Map) modifiedByResult;
				modifiedByNameValue = StringUtils.toStringNullsAsNull(result.get(nameColumn));
				modifiedByEmailValue = StringUtils.toStringNullsAsNull(result.get(emailColumn));
			}
			else
			{
				BeanWrapper wrapper = new BeanWrapperImpl(modifiedByResult);
				modifiedByNameValue = StringUtils.toStringNullsAsNull(wrapper.getPropertyValue(nameColumn));
				modifiedByEmailValue = StringUtils.toStringNullsAsNull(wrapper.getPropertyValue(emailColumn));
			}
		}

		Object createdById = getProperty(createdByIdProperty);
		if (createdByIdProperty != null)
		{
			Object createdByResult = queryService.namedQueryForObject(namedQueryId, createdById);
			if (createdByResult instanceof Map)
			{
				Map result = (Map) createdByResult;
				createdByNameValue = StringUtils.toStringNullsAsNull(result.get(nameColumn));
				createdByEmailValue = StringUtils.toStringNullsAsNull(result.get(emailColumn));
			}
			else
			{
				BeanWrapper wrapper = new BeanWrapperImpl(createdByResult);
				createdByNameValue = StringUtils.toStringNullsAsNull(wrapper.getPropertyValue(nameColumn));
				createdByEmailValue = StringUtils.toStringNullsAsNull(wrapper.getPropertyValue(emailColumn));
			}
		}

	}

	public Date getDateCreated()
	{
		if (StringUtils.isBlank(dateCreatedProperty))
		{
			throw new PropertyNotSetException("dateCreatedProperty", this);
		}
		else
		{
			return (Date) getProperty(dateCreatedProperty, Date.class);
		}
	}

	public Date getDateModified()
	{
		if (StringUtils.isBlank(dateModifiedProperty))
		{
			throw new PropertyNotSetException("dateModifiedProperty", this);
		}
		else
		{
			return (Date) getProperty(dateModifiedProperty, Date.class);
		}
	}

	public String getCreatedByName()
	{
		return createdByNameValue;
	}

	public String getCreatedByEmail()
	{
		return createdByEmailValue;
	}

	public String getModifiedName()
	{
		return modifiedByNameValue;
	}

	public String getModifiedEmail()
	{
		return modifiedByEmailValue;
	}

	public void setCreatedByIdProperty(String createdByIdProperty)
	{
		this.createdByIdProperty = createdByIdProperty;
	}

	public void setDateCreatedProperty(String dateCreatedProperty)
	{
		this.dateCreatedProperty = dateCreatedProperty;
	}

	public void setDateModifiedProperty(String dateModifiedProperty)
	{
		this.dateModifiedProperty = dateModifiedProperty;
	}

	public void setEmailColumn(String emailColumn)
	{
		this.emailColumn = emailColumn;
	}

	public void setModifiedByIdProperty(String modifiedByIdProperty)
	{
		this.modifiedByIdProperty = modifiedByIdProperty;
	}

	public void setNameColumn(String nameColumn)
	{
		this.nameColumn = nameColumn;
	}

	public void setNamedQueryId(String namedQueryId)
	{
		this.namedQueryId = namedQueryId;
	}

}
