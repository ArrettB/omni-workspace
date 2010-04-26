package com.dynamic.charm.web.form.tag.audit;

import java.util.Date;

import org.apache.log4j.Logger;

import com.dynamic.charm.common.StringUtils;
import com.dynamic.charm.exception.PropertyNotSetException;

public class PropertyBasedAuditInfo extends AbstractAuditInfo implements AuditInfo
{
	private String dateCreatedProperty = null;
	private String dateModifiedProperty = null;
	private String createdByNameProperty = null;
	private String createdByEmailProperty = null;
	private String modifiedByNameProperty = null;
	private String modifiedByEmailProperty = null;

	private final static Logger logger = Logger.getLogger(PropertyBasedAuditInfo.class);
	
	
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
		if (StringUtils.isBlank(createdByNameProperty))
		{
			throw new PropertyNotSetException("createdByNameProperty", this);
		}
		else
		{
			return StringUtils.toStringNullsAsNull(getProperty(createdByNameProperty));
		}
	}

	public String getCreatedByEmail()
	{
		if (StringUtils.isBlank(createdByNameProperty))
		{
			throw new PropertyNotSetException("createdByEmailProperty", this);
		}
		else
		{
			return StringUtils.toStringNullsAsNull(getProperty(createdByEmailProperty));
		}
	}

	public String getModifiedName()
	{
		if (StringUtils.isBlank(createdByNameProperty))
		{
			throw new PropertyNotSetException("modifiedByNameProperty", this);
		}
		else
		{
			return StringUtils.toStringNullsAsNull(getProperty(modifiedByNameProperty));
		}
	}

	public String getModifiedEmail()
	{
		if (StringUtils.isBlank(createdByNameProperty))
		{
			throw new PropertyNotSetException("modifiedByEmailProperty", this);
		}
		else
		{
			return StringUtils.toStringNullsAsNull(getProperty(modifiedByEmailProperty));
		}
	}

	public void setCreatedByEmailProperty(String createdByEmailProperty)
	{
		this.createdByEmailProperty = createdByEmailProperty;
	}

	public void setCreatedByNameProperty(String createdByNameProperty)
	{
		this.createdByNameProperty = createdByNameProperty;
	}

	public void setDateCreatedProperty(String dateCreatedProperty)
	{
		this.dateCreatedProperty = dateCreatedProperty;
	}

	public void setDateModifiedProperty(String dateModifiedProperty)
	{
		this.dateModifiedProperty = dateModifiedProperty;
	}

	public void setModifiedByEmailProperty(String modifiedByEmailProperty)
	{
		this.modifiedByEmailProperty = modifiedByEmailProperty;
	}

	public void setModifiedByNameProperty(String modifiedByNameProperty)
	{
		this.modifiedByNameProperty = modifiedByNameProperty;
	}




}
