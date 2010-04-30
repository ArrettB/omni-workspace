package com.dynamic.servicetrax.orm;

// Generated Apr 27, 2006 9:55:28 AM by Hibernate Tools 3.1.0.beta5

import java.util.Date;

/**
 * InvoiceTracking generated by hbm2java
 */
public class InvoiceTracking implements java.io.Serializable
{

	// Fields    

	private Long invoiceTrackingId;

	private Lookup lookup;

	private InvoiceStatus invoiceStatusByNewStatusId;

	private InvoiceStatus invoiceStatusByOldStatusId;

	private Invoice invoice;

	private Contact contact;

	private Long fromUserId;

	private String notes;

	private Character emailSentFlag;

	private long createdBy;

	private Date dateCreated;

	private Long modifiedBy;

	private Date dateModified;

	// Constructors

	/** default constructor */
	public InvoiceTracking()
	{
	}

	/** minimal constructor */
	public InvoiceTracking(Lookup lookup, Invoice invoice, long createdBy, Date dateCreated)
	{
		this.lookup = lookup;
		this.invoice = invoice;
		this.createdBy = createdBy;
		this.dateCreated = dateCreated;
	}

	/** full constructor */
	public InvoiceTracking(Lookup lookup, InvoiceStatus invoiceStatuseByNewStatusId, InvoiceStatus invoiceStatuseByOldStatusId, Invoice invoice, Contact contact, Long fromUserId, String notes,
			Character emailSentFlag, long createdBy, Date dateCreated, Long modifiedBy, Date dateModified)
	{
		this.lookup = lookup;
		this.invoiceStatusByNewStatusId = invoiceStatuseByNewStatusId;
		this.invoiceStatusByOldStatusId = invoiceStatuseByOldStatusId;
		this.invoice = invoice;
		this.contact = contact;
		this.fromUserId = fromUserId;
		this.notes = notes;
		this.emailSentFlag = emailSentFlag;
		this.createdBy = createdBy;
		this.dateCreated = dateCreated;
		this.modifiedBy = modifiedBy;
		this.dateModified = dateModified;
	}

	// Property accessors
	public Long getInvoiceTrackingId()
	{
		return this.invoiceTrackingId;
	}

	public void setInvoiceTrackingId(Long invoiceTrackingId)
	{
		this.invoiceTrackingId = invoiceTrackingId;
	}

	public Lookup getLookup()
	{
		return this.lookup;
	}

	public void setLookup(Lookup lookup)
	{
		this.lookup = lookup;
	}

	public InvoiceStatus getInvoiceStatusByNewStatusId()
	{
		return this.invoiceStatusByNewStatusId;
	}

	public void setInvoiceStatusByNewStatusId(InvoiceStatus invoiceStatuseByNewStatusId)
	{
		this.invoiceStatusByNewStatusId = invoiceStatuseByNewStatusId;
	}

	public InvoiceStatus getInvoiceStatusByOldStatusId()
	{
		return this.invoiceStatusByOldStatusId;
	}

	public void setInvoiceStatusByOldStatusId(InvoiceStatus invoiceStatuseByOldStatusId)
	{
		this.invoiceStatusByOldStatusId = invoiceStatuseByOldStatusId;
	}

	public Invoice getInvoice()
	{
		return this.invoice;
	}

	public void setInvoice(Invoice invoice)
	{
		this.invoice = invoice;
	}

	public Contact getContact()
	{
		return this.contact;
	}

	public void setContact(Contact contact)
	{
		this.contact = contact;
	}

	public Long getFromUserId()
	{
		return this.fromUserId;
	}

	public void setFromUserId(Long fromUserId)
	{
		this.fromUserId = fromUserId;
	}

	public String getNotes()
	{
		return this.notes;
	}

	public void setNotes(String notes)
	{
		this.notes = notes;
	}

	public Character getEmailSentFlag()
	{
		return this.emailSentFlag;
	}

	public void setEmailSentFlag(Character emailSentFlag)
	{
		this.emailSentFlag = emailSentFlag;
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

}