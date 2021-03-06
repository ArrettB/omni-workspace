package com.dynamic.servicetrax.orm;

// Generated Apr 27, 2006 9:55:28 AM by Hibernate Tools 3.1.0.beta5

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

/**
 * CustomCustColumn generated by hbm2java
 */
public class CustomCustColumn implements java.io.Serializable
{

	// Fields    

	private Long customCustColId;

	private Customer customer;

	private String columnDesc;

	private int colSequence;

	private String activeFlag;

	private long createdBy;

	private Date dateCreated;

	private Long modifiedBy;

	private Date dateModified;

	private String isDroplist;

	private String isMandatory;

	private Set customColLists = new HashSet(0);

	// Constructors

	/** default constructor */
	public CustomCustColumn()
	{
	}

	/** minimal constructor */
	public CustomCustColumn(Customer customer, String columnDesc, int colSequence, String activeFlag, long createdBy, Date dateCreated, String isDroplist, String isMandatory)
	{
		this.customer = customer;
		this.columnDesc = columnDesc;
		this.colSequence = colSequence;
		this.activeFlag = activeFlag;
		this.createdBy = createdBy;
		this.dateCreated = dateCreated;
		this.isDroplist = isDroplist;
		this.isMandatory = isMandatory;
	}

	/** full constructor */
	public CustomCustColumn(Customer customer, String columnDesc, int colSequence, String activeFlag, long createdBy, Date dateCreated, Long modifiedBy, Date dateModified, String isDroplist,
			String isMandatory, Set customColLists)
	{
		this.customer = customer;
		this.columnDesc = columnDesc;
		this.colSequence = colSequence;
		this.activeFlag = activeFlag;
		this.createdBy = createdBy;
		this.dateCreated = dateCreated;
		this.modifiedBy = modifiedBy;
		this.dateModified = dateModified;
		this.isDroplist = isDroplist;
		this.isMandatory = isMandatory;
		this.customColLists = customColLists;
	}

	// Property accessors
	public Long getCustomCustColId()
	{
		return this.customCustColId;
	}

	public void setCustomCustColId(Long customCustColId)
	{
		this.customCustColId = customCustColId;
	}

	public Customer getCustomer()
	{
		return this.customer;
	}

	public void setCustomer(Customer customer)
	{
		this.customer = customer;
	}

	public String getColumnDesc()
	{
		return this.columnDesc;
	}

	public void setColumnDesc(String columnDesc)
	{
		this.columnDesc = columnDesc;
	}

	public int getColSequence()
	{
		return this.colSequence;
	}

	public void setColSequence(int colSequence)
	{
		this.colSequence = colSequence;
	}

	public String getActiveFlag()
	{
		return this.activeFlag;
	}

	public void setActiveFlag(String activeFlag)
	{
		this.activeFlag = activeFlag;
	}

	public long getCreatedBy()
	{
		return this.createdBy;
	}

	public void setCreatedBy(long createdBy)
	{
		this.createdBy = createdBy;
	}

	public Date getDateCreated()
	{
		return this.dateCreated;
	}

	public void setDateCreated(Date dateCreated)
	{
		this.dateCreated = dateCreated;
	}

	public Long getModifiedBy()
	{
		return this.modifiedBy;
	}

	public void setModifiedBy(Long modifiedBy)
	{
		this.modifiedBy = modifiedBy;
	}

	public Date getDateModified()
	{
		return this.dateModified;
	}

	public void setDateModified(Date dateModified)
	{
		this.dateModified = dateModified;
	}

	public String getIsDroplist()
	{
		return this.isDroplist;
	}

	public void setIsDroplist(String isDroplist)
	{
		this.isDroplist = isDroplist;
	}

	public String getIsMandatory()
	{
		return this.isMandatory;
	}

	public void setIsMandatory(String isMandatory)
	{
		this.isMandatory = isMandatory;
	}

	public Set getCustomColLists()
	{
		return this.customColLists;
	}

	public void setCustomColLists(Set customColLists)
	{
		this.customColLists = customColLists;
	}

}
