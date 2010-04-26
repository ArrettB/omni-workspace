package com.dynamic.servicetrax.orm;

// Generated Apr 27, 2006 9:55:28 AM by Hibernate Tools 3.1.0.beta5

/**
 * ServInvLineId generated by hbm2java
 */
public class ServInvLineId implements java.io.Serializable
{

	// Fields    

	private long serviceLineId;

	private long invoiceLineId;

	// Constructors

	/** default constructor */
	public ServInvLineId()
	{
	}

	/** full constructor */
	public ServInvLineId(long serviceLineId, long invoiceLineId)
	{
		this.serviceLineId = serviceLineId;
		this.invoiceLineId = invoiceLineId;
	}

	// Property accessors
	public long getServiceLineId()
	{
		return this.serviceLineId;
	}

	public void setServiceLineId(long serviceLineId)
	{
		this.serviceLineId = serviceLineId;
	}

	public long getInvoiceLineId()
	{
		return this.invoiceLineId;
	}

	public void setInvoiceLineId(long invoiceLineId)
	{
		this.invoiceLineId = invoiceLineId;
	}

	public boolean equals(Object other)
	{
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof ServInvLineId))
			return false;
		ServInvLineId castOther = (ServInvLineId) other;

		return (this.getServiceLineId() == castOther.getServiceLineId()) && (this.getInvoiceLineId() == castOther.getInvoiceLineId());
	}

	public int hashCode()
	{
		int result = 17;

		result = 37 * result + (int) this.getServiceLineId();
		result = 37 * result + (int) this.getInvoiceLineId();
		return result;
	}

}
