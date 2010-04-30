package com.dynamic.servicetrax.orm;

// Generated Apr 27, 2006 9:55:28 AM by Hibernate Tools 3.1.0.beta5

import java.math.BigDecimal;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

/**
 * InvoiceLine generated by hbm2java
 */
public class InvoiceLine implements java.io.Serializable
{

	// Fields    

	private Long invoiceLineId;

	private Item item;
	
	private Service service;

	private Lookup lookup;

	private Invoice invoice;

	private Long invoiceLineNo;

	private String description;

	private BigDecimal unitPrice;

	private BigDecimal qty;

	private BigDecimal extendedPrice;

	private String poNo;

	private String taxableFlag;

	private Date dateCreated;

	private Long createdBy;

	private Date dateModified;

	private Long modifiedBy;

	private Set servInvLines = new HashSet(0);

	// Constructors

	/** default constructor */
	public InvoiceLine()
	{
	}

	/** minimal constructor */
	public InvoiceLine(Invoice invoice, BigDecimal unitPrice, BigDecimal qty, BigDecimal extendedPrice, Date dateCreated)
	{
		this.invoice = invoice;
		this.unitPrice = unitPrice;
		this.qty = qty;
		this.extendedPrice = extendedPrice;
		this.dateCreated = dateCreated;
	}

	/** full constructor */
	public InvoiceLine(Item item, Service service, Lookup lookup, Invoice invoice, Long invoiceLineNo, String description, BigDecimal unitPrice, BigDecimal qty, BigDecimal extendedPrice, String poNo,
			String taxableFlag, Date dateCreated, Long createdBy, Date dateModified, Long modifiedBy, Set servInvLines)
	{
		this.item = item;
		this.service = service;
		this.lookup = lookup;
		this.invoice = invoice;
		this.invoiceLineNo = invoiceLineNo;
		this.description = description;
		this.unitPrice = unitPrice;
		this.qty = qty;
		this.extendedPrice = extendedPrice;
		this.poNo = poNo;
		this.taxableFlag = taxableFlag;
		this.dateCreated = dateCreated;
		this.createdBy = createdBy;
		this.dateModified = dateModified;
		this.modifiedBy = modifiedBy;
		this.servInvLines = servInvLines;
	}

	// Property accessors
	public Long getInvoiceLineId()
	{
		return this.invoiceLineId;
	}

	public void setInvoiceLineId(Long invoiceLineId)
	{
		this.invoiceLineId = invoiceLineId;
	}

	public Item getItem()
	{
		return this.item;
	}

	public void setItem(Item item)
	{
		this.item = item;
	}

	public Lookup getLookup()
	{
		return this.lookup;
	}

	public void setLookup(Lookup lookup)
	{
		this.lookup = lookup;
	}

	public Invoice getInvoice()
	{
		return this.invoice;
	}

	public void setInvoice(Invoice invoice)
	{
		this.invoice = invoice;
	}

	public Long getInvoiceLineNo()
	{
		return this.invoiceLineNo;
	}

	public void setInvoiceLineNo(Long invoiceLineNo)
	{
		this.invoiceLineNo = invoiceLineNo;
	}

	public String getDescription()
	{
		return this.description;
	}

	public void setDescription(String description)
	{
		this.description = description;
	}

	public BigDecimal getUnitPrice()
	{
		return this.unitPrice;
	}

	public void setUnitPrice(BigDecimal unitPrice)
	{
		this.unitPrice = unitPrice;
	}

	public BigDecimal getQty()
	{
		return this.qty;
	}

	public void setQty(BigDecimal qty)
	{
		this.qty = qty;
	}

	public BigDecimal getExtendedPrice()
	{
		return this.extendedPrice;
	}

	public void setExtendedPrice(BigDecimal extendedPrice)
	{
		this.extendedPrice = extendedPrice;
	}

	public String getPoNo()
	{
		return this.poNo;
	}

	public void setPoNo(String poNo)
	{
		this.poNo = poNo;
	}

	public String getTaxableFlag()
	{
		return this.taxableFlag;
	}

	public void setTaxableFlag(String taxableFlag)
	{
		this.taxableFlag = taxableFlag;
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

	public Set getServInvLines()
	{
		return this.servInvLines;
	}

	public void setServInvLines(Set servInvLines)
	{
		this.servInvLines = servInvLines;
	}

	public Service getService() {
		return service;
	}

	public void setService(Service service) {
		this.service = service;
	}

}