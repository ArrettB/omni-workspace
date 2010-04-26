package com.dynamic.charm.examples;


import java.util.Collection;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.collections.CollectionUtils;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.AbstractTransactionalSpringContextTests;


import com.dynamic.charm.AuditUtil;
import com.dynamic.charm.service.QueryService;

public class DummyDataSupport extends AbstractTransactionalSpringContextTests
{
	protected QueryService queryService;

	public DummyDataSupport()
	{
		setPopulateProtectedVariables(true);
	}

	protected String[] getConfigLocations()
	{
		return new String[] { "classpath:testApplicationContext.xml" };
	}

	/**
	 * Runs the given SQL query, grabs the first result as a number, and ensures it is equal to the given count
	 * @param query
	 * @param count
	 */
	public void assertQueryResultEquals(String query, int expectedResult)
	{
		flushHibernate();

		int actualResult = getQueryService().getJdbcService().getJDBCTemplate().queryForInt(query);

		assertEquals(expectedResult, actualResult);
	}

	public void assertQueryResultEquals(String query, String expectedResult)
	{
		flushHibernate();

		String actualResult = (String) getQueryService().getJdbcService().getJDBCTemplate().queryForObject(query, String.class);
		assertEquals(expectedResult, actualResult);
	}

	public void saveOrUpdate(Object o)
	{
		AuditUtil.updateAuditColumns(o, com.dynamic.charm.Constants.SYSTEM_USER_ID);
		getQueryService().saveOrUpdate(o);
		getQueryService().getHibernateService().getHibernateTemplate().flush();
	}

	public void saveOrUpdateAll(Collection c)
	{
		for (Iterator iter = c.iterator(); iter.hasNext();)
		{
			Object o = iter.next();
			AuditUtil.updateAuditColumns(o, com.dynamic.charm.Constants.SYSTEM_USER_ID);
			getQueryService().saveOrUpdate(o);
		}
		flushHibernate();
	}


	public void assertQueryResultsSame(String paramaterizedQuery, Object param1, Object param2)
	{
		JdbcTemplate jdbcTemplate = getQueryService().getJdbcService().getJDBCTemplate();
		List result1 = jdbcTemplate.queryForList(paramaterizedQuery, new Object[] {param1});
		List result2 = jdbcTemplate.queryForList(paramaterizedQuery, new Object[] {param2});
		assertTrue(result1.size() > 0);
		assertTrue(result2.size() > 0);
		assertTrue(CollectionUtils.isEqualCollection(result1, result2));
	}

	public void assertQueryResultsSame(String paramaterizedQuery, Object[] params1, Object[] params2)
	{
		JdbcTemplate jdbcTemplate = getQueryService().getJdbcService().getJDBCTemplate();
		List result1 = jdbcTemplate.queryForList(paramaterizedQuery, params1);
		List result2 = jdbcTemplate.queryForList(paramaterizedQuery, params2);
		assertTrue(result1.size() > 0);
		assertTrue(result2.size() > 0);
		assertTrue(CollectionUtils.isEqualCollection(result1, result2));
	}

	public void flushHibernate()
	{
		getQueryService().getHibernateService().getHibernateTemplate().flush();
	}

	public QueryService getQueryService()
	{
		return queryService;
	}

	public void setQueryService(QueryService queryService)
	{
		this.queryService = queryService;
	}


}
