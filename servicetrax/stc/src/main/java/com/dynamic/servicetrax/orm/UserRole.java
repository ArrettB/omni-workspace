package com.dynamic.servicetrax.orm;

// Generated Apr 27, 2006 9:55:28 AM by Hibernate Tools 3.1.0.beta5

import java.util.Date;

/**
 * UserRole generated by hbm2java
 */
public class UserRole implements java.io.Serializable
{

	// Fields    

	private UserRoleId id;

	private User userByUserId;

	private Role role;

	private User userByModifiedBy;

	private User userByCreatedBy;

	private Date dateCreated;

	private Date dateModified;

	// Constructors

	/** default constructor */
	public UserRole()
	{
	}

	/** minimal constructor */
	public UserRole(User userByUserId, Role role, User userByCreatedBy, Date dateCreated)
	{
		this.userByUserId = userByUserId;
		this.role = role;
		this.userByCreatedBy = userByCreatedBy;
		this.dateCreated = dateCreated;
	}

	/** full constructor */
	public UserRole(User userByUserId, Role role, User userByModifiedBy, User userByCreatedBy, Date dateCreated, Date dateModified)
	{
		this.userByUserId = userByUserId;
		this.role = role;
		this.userByModifiedBy = userByModifiedBy;
		this.userByCreatedBy = userByCreatedBy;
		this.dateCreated = dateCreated;
		this.dateModified = dateModified;
	}

	// Property accessors
	public UserRoleId getId()
	{
		return this.id;
	}

	public void setId(UserRoleId id)
	{
		this.id = id;
	}

	public User getUserByUserId()
	{
		return this.userByUserId;
	}

	public void setUserByUserId(User userByUserId)
	{
		this.userByUserId = userByUserId;
	}

	public Role getRole()
	{
		return this.role;
	}

	public void setRole(Role role)
	{
		this.role = role;
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
