package com.dynamic.servicetrax.dao;

import java.util.Map;

import org.springframework.test.AbstractTransactionalDataSourceSpringContextTests;

import com.dynamic.servicetrax.orm.Lookup;

public class LookupsDaoTest extends AbstractTransactionalDataSourceSpringContextTests
{
	private LookupsDao lookupsDao;
	private HibernateLookupsDao hibernateLookupsDao;

	public void testServiceLineStatuses()
	{
		Map serviceLineStatuses = lookupsDao.loadServiceLineStatusMap();
		assertEquals("JDBC query must show the same number of service_line_statuses", jdbcTemplate.queryForInt("SELECT COUNT(*) FROM service_line_statuses"), serviceLineStatuses.size());

	}

	public void testLookupMap()
	{
		Map yesNoMap = lookupsDao.loadLookupMap("yes_no_type");
		assertEquals(2, yesNoMap.size());
		assertTrue(yesNoMap.containsKey("N"));
		assertTrue(yesNoMap.containsKey("Y"));
	}

	public void testHibernateLookupMap()
	{
		Map yesNoMap = hibernateLookupsDao.loadLookupsMap("yes_no_type");
		assertEquals(2, yesNoMap.size());
		assertTrue(yesNoMap.containsKey("N"));
		assertTrue(yesNoMap.containsKey("Y"));
		Lookup yes = (Lookup) yesNoMap.get("Y");
		assertEquals("Yes", yes.getName());
		Lookup no = (Lookup) yesNoMap.get("N");
		assertEquals("No", no.getName());
	}

	@Override
	protected String[] getConfigLocations()
	{

		return new String[] { "applicationContext-test.xml" };
	}

	public LookupsDao getLookupsDao()
	{
		return lookupsDao;
	}

	public void setLookupsDao(LookupsDao lookupsDao)
	{
		this.lookupsDao = lookupsDao;
	}

	public HibernateLookupsDao getHibernateLookupsDao()
	{
		return hibernateLookupsDao;
	}

	public void setHibernateLookupsDao(HibernateLookupsDao hibernateLookupsDao)
	{
		this.hibernateLookupsDao = hibernateLookupsDao;
	}
}
