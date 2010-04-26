package com.dynamic.servicetrax.dao;
import java.util.Date;

import org.springframework.test.AbstractTransactionalDataSourceSpringContextTests;

import com.dynamic.servicetrax.orm.Organization;
import com.dynamic.servicetrax.orm.User;

public class InvoiceDaoTest extends AbstractTransactionalDataSourceSpringContextTests
{
	private InvoiceDao invoiceDao;
	private HibernateLookupsDao hibernateLookupsDao;

	public HibernateLookupsDao getHibernateLookupsDao()
	{
		return hibernateLookupsDao;
	}


	public void setHibernateLookupsDao(HibernateLookupsDao hibernateLookupsDao)
	{
		this.hibernateLookupsDao = hibernateLookupsDao;
	}


	@Override
	protected String[] getConfigLocations()
	{
		return new String[] {"applicationContext-test.xml"};
	}


	@Override
	protected void onSetUpInTransaction() throws Exception
	{
		super.onSetUpInTransaction();
	}

	public InvoiceDao getInvoiceDao()
	{
		return invoiceDao;
	}

	public void testIt()
	{
		hibernateLookupsDao.loadLookupsMap("yes_no_type");
	}


	public void setInvoiceDao(InvoiceDao invoiceDao)
	{
		this.invoiceDao = invoiceDao;
	}

	public Organization createTestOrganization()
	{
		User testUser = createTestUser();
		
		
		Organization org  = new Organization();
		org.setUserByCreatedBy(testUser);
		
		return org;
	}
	
	public User createTestUser()
	{
		User user = new User();
		user.setActiveFlag("Y");
		user.setDateCreated(new Date());
		user.setLookupByEmploymentTypeId(hibernateLookupsDao.loadLookup("employment_type", "full_time"));
		user.setExtDealerId("100");
		user.setFirstName("Test");
		user.setLastName("User");
		user.setLogin("login");
		user.setPassword("password");
		user.setUserByCreatedBy((User)hibernateLookupsDao.load(User.class, "1"));
		
		hibernateLookupsDao.saveOrUpdate(user);
		
		return user;
	}
	



}
