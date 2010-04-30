package com.dynamic.servicetrax.orm;

// Generated Apr 27, 2006 9:55:28 AM by Hibernate Tools 3.1.0.beta5

import java.util.Date;

/**
 * RoleFunctionRight generated by hbm2java
 */
public class RoleFunctionRight implements java.io.Serializable
{

	// Fields    

	private Long roleFunctionRightId;

	private Role role;

	private Function function;

	private User userByModifiedBy;

	private User userByCreatedBy;

	private RightType rightType;

	private Date dateCreated;

	private Date dateModified;

	// Constructors

	/** default constructor */
	public RoleFunctionRight()
	{
	}

	/** minimal constructor */
	public RoleFunctionRight(Role role, Function function, User userByCreatedBy, Date dateCreated)
	{
		this.role = role;
		this.function = function;
		this.userByCreatedBy = userByCreatedBy;
		this.dateCreated = dateCreated;
	}

	/** full constructor */
	public RoleFunctionRight(Role role, Function function, User userByModifiedBy, User userByCreatedBy, RightType rightType, Date dateCreated, Date dateModified)
	{
		this.role = role;
		this.function = function;
		this.userByModifiedBy = userByModifiedBy;
		this.userByCreatedBy = userByCreatedBy;
		this.rightType = rightType;
		this.dateCreated = dateCreated;
		this.dateModified = dateModified;
	}

	// Property accessors
	public Long getRoleFunctionRightId()
	{
		return this.roleFunctionRightId;
	}

	public void setRoleFunctionRightId(Long roleFunctionRightId)
	{
		this.roleFunctionRightId = roleFunctionRightId;
	}

	public Role getRole()
	{
		return this.role;
	}

	public void setRole(Role role)
	{
		this.role = role;
	}

	public Function getFunction()
	{
		return this.function;
	}

	public void setFunction(Function function)
	{
		this.function = function;
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

	public RightType getRightType()
	{
		return this.rightType;
	}

	public void setRightType(RightType rightType)
	{
		this.rightType = rightType;
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