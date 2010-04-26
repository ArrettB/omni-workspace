package com.dynamic.servicetrax.dao;

import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import com.dynamic.servicetrax.orm.Invoice;
import com.dynamic.servicetrax.orm.InvoiceStatus;
import com.dynamic.servicetrax.orm.Job;

public class InvoiceDao extends HibernateDaoSupport
{
	public Invoice getInvoice(long invoiceId)
	{
		return (Invoice) getHibernateTemplate().get(Invoice.class, invoiceId);
	}

	public Invoice createInvoiceForJob(long jobId)
	{
		Job job = (Job) getHibernateTemplate().get(Job.class, jobId);
		
		Invoice invoice = new Invoice();
		invoice.setJob(job);
		invoice.setCustomer(job.getCustomer());
		invoice.setInvoiceStatus(getInvoiceStatus("NEW"));
		
		return invoice;
	}
	
	private InvoiceStatus getInvoiceStatus(String statusCode)
	{
		return (InvoiceStatus) getHibernateTemplate().findByNamedParam("SELECT invoiceStatus FROM InvoiceStatuse invoiceStatus WHERE code = :statusCode", "statusCode", statusCode);
	}
	
}
