package com.dynamic.servicetrax.invoice;

import java.math.BigDecimal;

import com.dynamic.servicetrax.orm.InvoiceLine;

public class InvoiceLineRecord
{
	private long invoiceLineId;
	private long invoiceLineNo;
	private String poNo;
	private String description;
	private long itemId;
	private String itemString;
	private long serviceId;
	private String serviceString;
	private double qty;
	private double rate;
	private String taxableFlag;
	
//	 long, long, string, clob, long, string, big_decimal, big_decimal
	
	public InvoiceLineRecord()
	{
	}

	public InvoiceLineRecord(Long invoiceLineId, Long invoiceLineNo, String poNo, String description, Long itemId, String itemString, Long serviceId, String serviceString, BigDecimal qty, BigDecimal rate, String taxableFlag)
	{
		super();

		this.invoiceLineId = invoiceLineId;
		this.invoiceLineNo = invoiceLineNo;
		this.poNo = poNo;
		this.description = description;
		this.itemId = itemId;
		this.itemString = itemString;
		this.serviceId = serviceId;
		this.serviceString = serviceString;
		this.qty = qty.doubleValue();
		this.rate = rate.doubleValue();
		this.taxableFlag = taxableFlag;
	}
	
	public InvoiceLineRecord(Long invoiceLineId, Long invoiceLineNo, String poNo, String description, Long itemId, String itemString, Long serviceId, Long serviceNo, BigDecimal qty, BigDecimal rate, String taxableFlag)
	{
		super();

		this.invoiceLineId = invoiceLineId;
		this.invoiceLineNo = invoiceLineNo;
		this.poNo = poNo;
		this.description = description;
		this.itemId = itemId;
		this.itemString = itemString;
		this.serviceId = serviceId;
		this.serviceString = String.valueOf(serviceNo);
		this.qty = qty.doubleValue();
		this.rate = rate.doubleValue();
		this.taxableFlag = taxableFlag;
	}

	public InvoiceLineRecord(InvoiceLine line)
	{
		this.setInvoiceLineId(line.getInvoiceLineId().longValue());
		this.setInvoiceLineNo(line.getInvoiceLineNo().longValue());
		this.setDescription(line.getDescription().toString());
		this.setPoNo(line.getPoNo());
		this.setQty(line.getQty().doubleValue());
		this.setRate(line.getExtendedPrice().doubleValue());
		this.setItemId(line.getItem().getItemId().longValue());
		this.setItemString(line.getItem().getName());
		this.setServiceId(line.getService().getServiceId().longValue());
		this.setServiceString(String.valueOf(line.getService().getServiceNo()));
		this.setTaxableFlag(line.getTaxableFlag());

	}
	

	public String getDescription()
	{
		return description;
	}


	public void setDescription(String description)
	{
		this.description = description;
	}


	public long getInvoiceLineId()
	{
		return invoiceLineId;
	}


	public void setInvoiceLineId(long invoiceLineId)
	{
		this.invoiceLineId = invoiceLineId;
	}


	public long getInvoiceLineNo()
	{
		return invoiceLineNo;
	}


	public void setInvoiceLineNo(long invoiceLineNo)
	{
		this.invoiceLineNo = invoiceLineNo;
	}


	public long getItemId()
	{
		return itemId;
	}


	public void setItemId(long itemId)
	{
		this.itemId = itemId;
	}


	public String getItemString()
	{
		return itemString;
	}


	public void setItemString(String itemString)
	{
		this.itemString = itemString;
	}


	public String getPoNo()
	{
		return poNo;
	}


	public void setPoNo(String poNo)
	{
		this.poNo = poNo;
	}


	public double getQty()
	{
		return qty;
	}


	public void setQty(double qty)
	{
		this.qty = qty;
	}


	public double getRate()
	{
		return rate;
	}


	public void setRate(double rate)
	{
		this.rate = rate;
	}
	
	public double getTotal()
	{
		return getQty() * getRate();
	}

	public String getTaxableFlag()
	{
		return taxableFlag;
	}

	public void setTaxableFlag(String taxableFlag)
	{
		this.taxableFlag = taxableFlag;
	}

	public long getServiceId() {
		return serviceId;
	}

	public void setServiceId(long serviceId) {
		this.serviceId = serviceId;
	}

	public String getServiceString() {
		return serviceString;
	}

	public void setServiceString(String serviceString) {
		this.serviceString = serviceString;
	}
	
	

	
}
