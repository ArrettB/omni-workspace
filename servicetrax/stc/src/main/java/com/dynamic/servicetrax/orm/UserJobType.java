package com.dynamic.servicetrax.orm;

// Generated Apr 27, 2006 9:55:28 AM by Hibernate Tools 3.1.0.beta5

import java.util.Date;

/**
 * UserJobType generated by hbm2java
 */
public class UserJobType implements java.io.Serializable
{

	// Fields    

	private Long userJobTypeId;

	private User user;

	private Lookup lookup;

	private long createdBy;

	private Date dateCreated;

	// Constructors

	/** default constructor */
	public UserJobType()
	{
	}

	/** full constructor */
	public UserJobType(User user, Lookup lookup, long createdBy, Date dateCreated)
	{
		this.user = user;
		this.lookup = lookup;
		this.createdBy = createdBy;
		this.dateCreated = dateCreated;
	}

	// Property accessors
	public Long getUserJobTypeId()
	{
		return this.userJobTypeId;
	}

	public void setUserJobTypeId(Long userJobTypeId)
	{
		this.userJobTypeId = userJobTypeId;
	}

	public User getUser()
	{
		return this.user;
	}

	public void setUser(User user)
	{
		this.user = user;
	}

	public Lookup getLookup()
	{
		return this.lookup;
	}

	public void setLookup(Lookup lookup)
	{
		this.lookup = lookup;
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

}