package com.dynamic.servicetrax.orm;

// Generated Apr 27, 2006 9:55:28 AM by Hibernate Tools 3.1.0.beta5

import java.util.Date;

/**
 * FunctionRightType generated by hbm2java
 */
public class FunctionRightType implements java.io.Serializable
{

	// Fields    

	private Long functionRightTypeId;

	private RightType rightType;

	private Long functionId;

	private String updatableFlag;

	private Date dateCreated;

	private Long createdBy;

	private Date dateModified;

	private Long modifiedBy;

	// Constructors

	/** default constructor */
	public FunctionRightType()
	{
	}

	/** full constructor */
	public FunctionRightType(RightType rightType, Long functionId, String updatableFlag, Date dateCreated, Long createdBy, Date dateModified, Long modifiedBy)
	{
		this.rightType = rightType;
		this.functionId = functionId;
		this.updatableFlag = updatableFlag;
		this.dateCreated = dateCreated;
		this.createdBy = createdBy;
		this.dateModified = dateModified;
		this.modifiedBy = modifiedBy;
	}

	// Property accessors
	public Long getFunctionRightTypeId()
	{
		return this.functionRightTypeId;
	}

	public void setFunctionRightTypeId(Long functionRightTypeId)
	{
		this.functionRightTypeId = functionRightTypeId;
	}

	public RightType getRightType()
	{
		return this.rightType;
	}

	public void setRightType(RightType rightType)
	{
		this.rightType = rightType;
	}

	public Long getFunctionId()
	{
		return this.functionId;
	}

	public void setFunctionId(Long functionId)
	{
		this.functionId = functionId;
	}

	public String getUpdatableFlag()
	{
		return this.updatableFlag;
	}

	public void setUpdatableFlag(String updatableFlag)
	{
		this.updatableFlag = updatableFlag;
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
