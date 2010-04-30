package com.dynamic.servicetrax.orm;

// Generated Apr 27, 2006 9:55:28 AM by Hibernate Tools 3.1.0.beta5

import java.math.BigDecimal;
import java.util.Date;

/**
 * ResourceItem generated by hbm2java
 */
public class ResourceItem implements java.io.Serializable
{

	// Fields    

	private Long resourceItemId;

	private Item item;

	private Resource resource;

	private User userByModifiedBy;

	private User userByCreatedBy;

	private String defaultItemFlag;

	private BigDecimal maxAmount;

	private Date dateCreated;

	private Date dateModified;

	// Constructors

	/** default constructor */
	public ResourceItem()
	{
	}

	/** minimal constructor */
	public ResourceItem(Item item, Resource resource, User userByCreatedBy, String defaultItemFlag, Date dateCreated)
	{
		this.item = item;
		this.resource = resource;
		this.userByCreatedBy = userByCreatedBy;
		this.defaultItemFlag = defaultItemFlag;
		this.dateCreated = dateCreated;
	}

	/** full constructor */
	public ResourceItem(Item item, Resource resource, User userByModifiedBy, User userByCreatedBy, String defaultItemFlag, BigDecimal maxAmount, Date dateCreated, Date dateModified)
	{
		this.item = item;
		this.resource = resource;
		this.userByModifiedBy = userByModifiedBy;
		this.userByCreatedBy = userByCreatedBy;
		this.defaultItemFlag = defaultItemFlag;
		this.maxAmount = maxAmount;
		this.dateCreated = dateCreated;
		this.dateModified = dateModified;
	}

	// Property accessors
	public Long getResourceItemId()
	{
		return this.resourceItemId;
	}

	public void setResourceItemId(Long resourceItemId)
	{
		this.resourceItemId = resourceItemId;
	}

	public Item getItem()
	{
		return this.item;
	}

	public void setItem(Item item)
	{
		this.item = item;
	}

	public Resource getResource()
	{
		return this.resource;
	}

	public void setResource(Resource resource)
	{
		this.resource = resource;
	}

	public User getUserByModifiedBy()
	{
		return this.userByModifiedBy;
	}

	public void setUserByModifiedBy(User userByModifiedBy)
	{
		this.userByModifiedBy = userByModifiedBy;
	}

	public User getUserByCreatedBy()
	{
		return this.userByCreatedBy;
	}

	public void setUserByCreatedBy(User userByCreatedBy)
	{
		this.userByCreatedBy = userByCreatedBy;
	}

	public String getDefaultItemFlag()
	{
		return this.defaultItemFlag;
	}

	public void setDefaultItemFlag(String defaultItemFlag)
	{
		this.defaultItemFlag = defaultItemFlag;
	}

	public BigDecimal getMaxAmount()
	{
		return this.maxAmount;
	}

	public void setMaxAmount(BigDecimal maxAmount)
	{
		this.maxAmount = maxAmount;
	}

	public Date getDateCreated()
	{
		return this.dateCreated;
	}

	public void setDateCreated(Date dateCreated)
	{
		this.dateCreated = dateCreated;
	}

	public Date getDateModified()
	{
		return this.dateModified;
	}

	public void setDateModified(Date dateModified)
	{
		this.dateModified = dateModified;
	}

}