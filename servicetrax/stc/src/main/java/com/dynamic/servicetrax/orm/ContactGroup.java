package com.dynamic.servicetrax.orm;

// Generated Apr 27, 2006 9:55:28 AM by Hibernate Tools 3.1.0.beta5

import java.util.Date;

/**
 * ContactGroup generated by hbm2java
 */
public class ContactGroup implements java.io.Serializable
{

	// Fields    

	private Long contactGroupId;

	private Contact contact;

	private Lookup lookup;

	private Date dateCreated;

	private Long createdBy;

	private Date dateModified;

	private Long modifiedBy;

	// Constructors

	/** default constructor */
	public ContactGroup()
	{
	}

	/** full constructor */
	public ContactGroup(Contact contact, Lookup lookup, Date dateCreated, Long createdBy, Date dateModified, Long modifiedBy)
	{
		this.contact = contact;
		this.lookup = lookup;
		this.dateCreated = dateCreated;
		this.createdBy = createdBy;
		this.dateModified = dateModified;
		this.modifiedBy = modifiedBy;
	}

	// Property accessors
	public Long getContactGroupId()
	{
		return this.contactGroupId;
	}

	public void setContactGroupId(Long contactGroupId)
	{
		this.contactGroupId = contactGroupId;
	}

	public Contact getContact()
	{
		return this.contact;
	}

	public void setContact(Contact contact)
	{
		this.contact = contact;
	}

	public Lookup getLookup()
	{
		return this.lookup;
	}

	public void setLookup(Lookup lookup)
	{
		this.lookup = lookup;
	}

	public Date getDateCreated()
	{
		return this.dateCreated;
	}

	public void setDateCreated(Date dateCreated)
	{
		this.dateCreated = dateCreated;
	}

	public Long getCreatedBy()
	{
		return this.createdBy;
	}

	public void setCreatedBy(Long createdBy)
	{
		this.createdBy = createdBy;
	}

	public Date getDateModified()
	{
		return this.dateModified;
	}

	public void setDateModified(Date dateModified)
	{
		this.dateModified = dateModified;
	}

	public Long getModifiedBy()
	{
		return this.modifiedBy;
	}

	public void setModifiedBy(Long modifiedBy)
	{
		this.modifiedBy = modifiedBy;
	}

}
