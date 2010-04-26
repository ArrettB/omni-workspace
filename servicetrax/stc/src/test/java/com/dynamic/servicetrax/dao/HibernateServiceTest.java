package com.dynamic.servicetrax.dao;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

import org.hibernate.EntityMode;
import org.hibernate.metadata.ClassMetadata;
import org.springframework.beans.BeanWrapper;
import org.springframework.beans.BeanWrapperImpl;
import org.springframework.test.AbstractTransactionalDataSourceSpringContextTests;

import com.dynamic.charm.query.hibernate.HibernateService;
import com.dynamic.charm.service.QueryService;

public class HibernateServiceTest extends AbstractTransactionalDataSourceSpringContextTests
{
	
	private HibernateService hibernateService;
	private QueryService queryService;

	@Override
	public int getAutowireMode()
	{
		return AbstractTransactionalDataSourceSpringContextTests.AUTOWIRE_BY_NAME;
	}
	

	
	@Override
	protected String[] getConfigLocations()
	{
		return new String[] { "classpath:applicationContext-test.xml" };
	}

	@Override
	protected void onSetUpInTransaction() throws Exception
	{
		super.onSetUpInTransaction();
	}

	public void testFetches()
	{
		Map classMeta = hibernateService.getSessionFactory().getAllClassMetadata();
		for (Iterator iter = classMeta.entrySet().iterator(); iter.hasNext();)
		{
			Entry entry = (Entry) iter.next();
			String className = (String) entry.getKey();
			ClassMetadata meta = (ClassMetadata) entry.getValue();
			System.out.println("Testing " + className);
			Class mapped = meta.getMappedClass(EntityMode.POJO);
			
		//	List data = hibernateService.findAll(mapped);
		//	System.out.println("Found " + data.size() + " objects from table:" + meta.getEntityName());
		}
	}
	
	public void testAudit()
	{
		Object result = queryService.namedQueryForList("auditInformation", new Long(580));
		System.out.println(result);
	}

	
	
	public HibernateService getHibernateService()
	{
		return hibernateService;
	}

	public void setHibernateService(HibernateService hibernateService)
	{
		this.hibernateService = hibernateService;
	}

	public QueryService getQueryService()
	{
		return queryService;
	}

	public void setQueryService(QueryService queryService)
	{
		this.queryService = queryService;
	}
	
	public static void main(String[] args)
	{
		Map test = new HashMap();
		test.put("color", "red");
		test.put("fruit", "apple");
	
	
		BeanWrapper bw = new BeanWrapperImpl(test);
		System.out.println(bw.getPropertyValue("color"));
		System.out.println(Arrays.toString(bw.getPropertyDescriptors()));
	}
	
}
