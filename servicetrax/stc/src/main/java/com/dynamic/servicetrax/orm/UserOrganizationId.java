package com.dynamic.servicetrax.orm;

// Generated Apr 27, 2006 9:55:28 AM by Hibernate Tools 3.1.0.beta5

/**
 * UserOrganizationId generated by hbm2java
 */
public class UserOrganizationId implements java.io.Serializable
{

	// Fields    

	private long userId;

	private long organizationId;

	// Constructors

	/** default constructor */
	public UserOrganizationId()
	{
	}

	/** full constructor */
	public UserOrganizationId(long userId, long organizationId)
	{
		this.userId = userId;
		this.organizationId = organizationId;
	}

	// Property accessors
	public long getUserId()
	{
		return this.userId;
	}

	public void setUserId(long userId)
	{
		this.userId = userId;
	}

	public long getOrganizationId()
	{
		return this.organizationId;
	}

	public void setOrganizationId(long organizationId)
	{
		this.organizationId = organizationId;
	}

	public boolean equals(Object other)
	{
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof UserOrganizationId))
			return false;
		UserOrganizationId castOther = (UserOrganizationId) other;

		return (this.getUserId() == castOther.getUserId()) && (this.getOrganizationId() == castOther.getOrganizationId());
	}

	public int hashCode()
	{
		int result = 17;

		result = 37 * result + (int) this.getUserId();
		result = 37 * result + (int) this.getOrganizationId();
		return result;
	}

}
