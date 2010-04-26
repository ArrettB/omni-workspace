package com.dynamic.servicetrax.orm;

// Generated Apr 27, 2006 9:55:28 AM by Hibernate Tools 3.1.0.beta5

import java.math.BigDecimal;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

/**
 * Quote generated by hbm2java
 */
public class Quote implements java.io.Serializable
{

	// Fields    

	private Long quoteId;

	private User userByQuotedByUserId;

	private Lookup lookupByQuoteStatusTypeId;

	private Lookup lookupByQuoteTypeId;

	private Request request;

	private User userByModifiedBy;

	private Lookup lookupByRequestTypeId;

	private User userByCreatedBy;

	private String isSent;

	private long quoteNo;

	private String quotersTitle;

	private String description;

	private BigDecimal quoteTotal;

	private String taxableFlag;

	private BigDecimal taxableAmount;

	private String warehouseFeeFlag;

	private Date dateQuoted;

	private Date datePrinted;

	private String extraConditions;

	private Date dateCreated;

	private Date dateModified;

	private Set quoteConditions = new HashSet(0);

	// Constructors

	/** default constructor */
	public Quote()
	{
	}

	/** minimal constructor */
	public Quote(Lookup lookupByQuoteStatusTypeId, Lookup lookupByQuoteTypeId, Request request, Lookup lookupByRequestTypeId, User userByCreatedBy, String isSent, long quoteNo, Date dateCreated)
	{
		this.lookupByQuoteStatusTypeId = lookupByQuoteStatusTypeId;
		this.lookupByQuoteTypeId = lookupByQuoteTypeId;
		this.request = request;
		this.lookupByRequestTypeId = lookupByRequestTypeId;
		this.userByCreatedBy = userByCreatedBy;
		this.isSent = isSent;
		this.quoteNo = quoteNo;
		this.dateCreated = dateCreated;
	}

	/** full constructor */
	public Quote(User userByQuotedByUserId, Lookup lookupByQuoteStatusTypeId, Lookup lookupByQuoteTypeId, Request request, User userByModifiedBy, Lookup lookupByRequestTypeId, User userByCreatedBy,
			String isSent, long quoteNo, String quotersTitle, String description, BigDecimal quoteTotal, String taxableFlag, BigDecimal taxableAmount, String warehouseFeeFlag, Date dateQuoted,
			Date datePrinted, String extraConditions, Date dateCreated, Date dateModified, Set quoteConditions)
	{
		this.userByQuotedByUserId = userByQuotedByUserId;
		this.lookupByQuoteStatusTypeId = lookupByQuoteStatusTypeId;
		this.lookupByQuoteTypeId = lookupByQuoteTypeId;
		this.request = request;
		this.userByModifiedBy = userByModifiedBy;
		this.lookupByRequestTypeId = lookupByRequestTypeId;
		this.userByCreatedBy = userByCreatedBy;
		this.isSent = isSent;
		this.quoteNo = quoteNo;
		this.quotersTitle = quotersTitle;
		this.description = description;
		this.quoteTotal = quoteTotal;
		this.taxableFlag = taxableFlag;
		this.taxableAmount = taxableAmount;
		this.warehouseFeeFlag = warehouseFeeFlag;
		this.dateQuoted = dateQuoted;
		this.datePrinted = datePrinted;
		this.extraConditions = extraConditions;
		this.dateCreated = dateCreated;
		this.dateModified = dateModified;
		this.quoteConditions = quoteConditions;
	}

	// Property accessors
	public Long getQuoteId()
	{
		return this.quoteId;
	}

	public void setQuoteId(Long quoteId)
	{
		this.quoteId = quoteId;
	}

	public User getUserByQuotedByUserId()
	{
		return this.userByQuotedByUserId;
	}

	public void setUserByQuotedByUserId(User userByQuotedByUserId)
	{
		this.userByQuotedByUserId = userByQuotedByUserId;
	}

	public Lookup getLookupByQuoteStatusTypeId()
	{
		return this.lookupByQuoteStatusTypeId;
	}

	public void setLookupByQuoteStatusTypeId(Lookup lookupByQuoteStatusTypeId)
	{
		this.lookupByQuoteStatusTypeId = lookupByQuoteStatusTypeId;
	}

	public Lookup getLookupByQuoteTypeId()
	{
		return this.lookupByQuoteTypeId;
	}

	public void setLookupByQuoteTypeId(Lookup lookupByQuoteTypeId)
	{
		this.lookupByQuoteTypeId = lookupByQuoteTypeId;
	}

	public Request getRequest()
	{
		return this.request;
	}

	public void setRequest(Request request)
	{
		this.request = request;
	}

	public User getUserByModifiedBy()
	{
		return this.userByModifiedBy;
	}

	public void setUserByModifiedBy(User userByModifiedBy)
	{
		this.userByModifiedBy = userByModifiedBy;
	}

	public Lookup getLookupByRequestTypeId()
	{
		return this.lookupByRequestTypeId;
	}

	public void setLookupByRequestTypeId(Lookup lookupByRequestTypeId)
	{
		this.lookupByRequestTypeId = lookupByRequestTypeId;
	}

	public User getUserByCreatedBy()
	{
		return this.userByCreatedBy;
	}

	public void setUserByCreatedBy(User userByCreatedBy)
	{
		this.userByCreatedBy = userByCreatedBy;
	}

	public String getIsSent()
	{
		return this.isSent;
	}

	public void setIsSent(String isSent)
	{
		this.isSent = isSent;
	}

	public long getQuoteNo()
	{
		return this.quoteNo;
	}

	public void setQuoteNo(long quoteNo)
	{
		this.quoteNo = quoteNo;
	}

	public String getQuotersTitle()
	{
		return this.quotersTitle;
	}

	public void setQuotersTitle(String quotersTitle)
	{
		this.quotersTitle = quotersTitle;
	}

	public String getDescription()
	{
		return this.description;
	}

	public void setDescription(String description)
	{
		this.description = description;
	}

	public BigDecimal getQuoteTotal()
	{
		return this.quoteTotal;
	}

	public void setQuoteTotal(BigDecimal quoteTotal)
	{
		this.quoteTotal = quoteTotal;
	}

	public String getTaxableFlag()
	{
		return this.taxableFlag;
	}

	public void setTaxableFlag(String taxableFlag)
	{
		this.taxableFlag = taxableFlag;
	}

	public BigDecimal getTaxableAmount()
	{
		return this.taxableAmount;
	}

	public void setTaxableAmount(BigDecimal taxableAmount)
	{
		this.taxableAmount = taxableAmount;
	}

	public String getWarehouseFeeFlag()
	{
		return this.warehouseFeeFlag;
	}

	public void setWarehouseFeeFlag(String warehouseFeeFlag)
	{
		this.warehouseFeeFlag = warehouseFeeFlag;
	}

	public Date getDateQuoted()
	{
		return this.dateQuoted;
	}

	public void setDateQuoted(Date dateQuoted)
	{
		this.dateQuoted = dateQuoted;
	}

	public Date getDatePrinted()
	{
		return this.datePrinted;
	}

	public void setDatePrinted(Date datePrinted)
	{
		this.datePrinted = datePrinted;
	}

	public String getExtraConditions()
	{
		return this.extraConditions;
	}

	public void setExtraConditions(String extraConditions)
	{
		this.extraConditions = extraConditions;
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

	public Set getQuoteConditions()
	{
		return this.quoteConditions;
	}

	public void setQuoteConditions(Set quoteConditions)
	{
		this.quoteConditions = quoteConditions;
	}

}
