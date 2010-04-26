package com.dynamic.servicetrax.orm;

// Generated Apr 27, 2006 9:55:28 AM by Hibernate Tools 3.1.0.beta5

import java.util.Date;

/**
 * ExpensesBatch generated by hbm2java
 */
public class ExpensesBatch implements java.io.Serializable
{

	// Fields    

	private Long intBatchId;

	private String extBatchId;

	private long organizationId;

	private Date beginDate;

	private Date endDate;

	private Long expensesBatchStatusTypeId;

	private Date dateCreated;

	private Long createdBy;

	// Constructors

	/** default constructor */
	public ExpensesBatch()
	{
	}

	/** minimal constructor */
	public ExpensesBatch(String extBatchId, long organizationId, Date beginDate, Date endDate)
	{
		this.extBatchId = extBatchId;
		this.organizationId = organizationId;
		this.beginDate = beginDate;
		this.endDate = endDate;
	}

	/** full constructor */
	public ExpensesBatch(String extBatchId, long organizationId, Date beginDate, Date endDate, Long expensesBatchStatusTypeId, Date dateCreated, Long createdBy)
	{
		this.extBatchId = extBatchId;
		this.organizationId = organizationId;
		this.beginDate = beginDate;
		this.endDate = endDate;
		this.expensesBatchStatusTypeId = expensesBatchStatusTypeId;
		this.dateCreated = dateCreated;
		this.createdBy = createdBy;
	}

	// Property accessors
	public Long getIntBatchId()
	{
		return this.intBatchId;
	}

	public void setIntBatchId(Long intBatchId)
	{
		this.intBatchId = intBatchId;
	}

	public String getExtBatchId()
	{
		return this.extBatchId;
	}

	public void setExtBatchId(String extBatchId)
	{
		this.extBatchId = extBatchId;
	}

	public long getOrganizationId()
	{
		return this.organizationId;
	}

	public void setOrganizationId(long organizationId)
	{
		this.organizationId = organizationId;
	}

	public Date getBeginDate()
	{
		return this.beginDate;
	}

	public void setBeginDate(Date beginDate)
	{
		this.beginDate = beginDate;
	}

	public Date getEndDate()
	{
		return this.endDate;
	}

	public void setEndDate(Date endDate)
	{
		this.endDate = endDate;
	}

	public Long getExpensesBatchStatusTypeId()
	{
		return this.expensesBatchStatusTypeId;
	}

	public void setExpensesBatchStatusTypeId(Long expensesBatchStatusTypeId)
	{
		this.expensesBatchStatusTypeId = expensesBatchStatusTypeId;
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

}
