package com.dynamic.charm.query;

import java.sql.Types;
import java.util.Date;

import junit.framework.TestCase;

public class NamedQueryTest extends TestCase
{
	
	public void testIntParameters()
	{
		NamedQuery nq = new NamedQuery();
		
		QueryParameter param1 = new QueryParameter();
		param1.setName("param1");
		param1.setTypeName("integer");

		QueryParameter param2 = new QueryParameter();
		param2.setName("param2");
		param2.setTypeName("java.lang.Integer");
		
		nq.addQueryParameter(param1);
		nq.addQueryParameter(param2);
				
		assertEquals(2, nq.getParameterMap().size());	
		assertEquals(new int[] {Types.INTEGER, Types.INTEGER}, nq.getParameterJDBCTypes(new String[] {"param1", "param2"}));
		assertEquals(new Class[] {Integer.class, Integer.class}, nq.getParameterClassTypes(new String[] {"param1", "param2"}));
	}
	
		
	public void testLongParameters()
	{
		NamedQuery nq = new NamedQuery();
		
		QueryParameter param1 = new QueryParameter();
		param1.setName("param1");
		param1.setTypeName("long");

		QueryParameter param2 = new QueryParameter();
		param2.setName("param2");
		param2.setTypeName("java.lang.Long");
		
		nq.addQueryParameter(param1);
		nq.addQueryParameter(param2);
				
		assertEquals(2, nq.getParameterMap().size());	
		assertEquals(new int[] {Types.BIGINT, Types.BIGINT}, nq.getParameterJDBCTypes(new String[] {"param1", "param2"}));
		assertEquals(new Class[] {Long.class, Long.class}, nq.getParameterClassTypes(new String[] {"param1", "param2"}));
				
	}
	
	public void testDoubleParameters()
	{
		NamedQuery nq = new NamedQuery();
		
		QueryParameter param1 = new QueryParameter();
		param1.setName("param1");
		param1.setTypeName("double");

		QueryParameter param2 = new QueryParameter();
		param2.setName("param2");
		param2.setTypeName("java.lang.Double");
		
		nq.addQueryParameter(param1);
		nq.addQueryParameter(param2);
				
		assertEquals(2, nq.getParameterMap().size());	
		assertEquals(new int[] {Types.DOUBLE, Types.DOUBLE}, nq.getParameterJDBCTypes(new String[] {"param1", "param2"}));
		assertEquals(new Class[] {Double.class, Double.class}, nq.getParameterClassTypes(new String[] {"param1", "param2"}));
				
	}
	
	public void testFloatParameters()
	{
		NamedQuery nq = new NamedQuery();
		
		QueryParameter param1 = new QueryParameter();
		param1.setName("param1");
		param1.setTypeName("float");

		QueryParameter param2 = new QueryParameter();
		param2.setName("param2");
		param2.setTypeName("java.lang.Float");
		
		nq.addQueryParameter(param1);
		nq.addQueryParameter(param2);
				
		assertEquals(2, nq.getParameterMap().size());	
		assertEquals(new int[] {Types.FLOAT, Types.FLOAT}, nq.getParameterJDBCTypes(new String[] {"param1", "param2"}));
		assertEquals(new Class[] {Float.class, Float.class}, nq.getParameterClassTypes(new String[] {"param1", "param2"}));
				
	}
	
	public void testStringParameters()
	{
		NamedQuery nq = new NamedQuery();
		
		QueryParameter param1 = new QueryParameter();
		param1.setName("param1");
		param1.setTypeName("string");

		QueryParameter param2 = new QueryParameter();
		param2.setName("param2");
		param2.setTypeName("java.lang.String");
			
		nq.addQueryParameter(param1);
		nq.addQueryParameter(param2);
				
		assertEquals(2, nq.getParameterMap().size());	
		assertEquals(new int[] {Types.VARCHAR, Types.VARCHAR}, nq.getParameterJDBCTypes(new String[] {"param1", "param2"}));
		assertEquals(new Class[] {String.class, String.class}, nq.getParameterClassTypes(new String[] {"param1", "param2"}));
		
	}
	
	public void testDateParameters()
	{
		NamedQuery nq = new NamedQuery();
		
		QueryParameter param1 = new QueryParameter();
		param1.setName("param1");
		param1.setTypeName("date");

		QueryParameter param2 = new QueryParameter();
		param2.setName("param2");
		param2.setTypeName("java.util.Date");
		
		nq.addQueryParameter(param1);
		nq.addQueryParameter(param2);
				
		assertEquals(2, nq.getParameterMap().size());	
		assertEquals(new int[] {Types.DATE, Types.DATE}, nq.getParameterJDBCTypes(new String[] {"param1", "param2"}));
		assertEquals(new Class[] {Date.class, Date.class}, nq.getParameterClassTypes(new String[] {"param1", "param2"}));
			
	}

	public void testNoParameters()
	{
		NamedQuery nq = new NamedQuery();
		assertEquals(0, nq.getParameterMap().size());	
		
		try
		{
			nq.getSingleParameterName();
			fail("Should have thrown a CharmException here");
		}
		catch(Exception e)
		{
		}
	}
	
	public void testSingleParameter()
	{
		NamedQuery nq = new NamedQuery();
		
		QueryParameter param = new QueryParameter();
		param.setName("floatParam");
		param.setTypeName("float");

		nq.addQueryParameter(param);
		
		assertEquals(1, nq.getParameterMap().size());	
		
		assertEquals("floatParam", nq.getSingleParameterName());
		
	}

	public void testMultipleParameters()
	{
		NamedQuery nq = new NamedQuery();
		
		QueryParameter floatParam = new QueryParameter();
		floatParam.setName("floatParam");
		floatParam.setTypeName("float");

		QueryParameter integerParam = new QueryParameter();
		integerParam.setName("integerParam");
		integerParam.setTypeName("integer");
		
		nq.addQueryParameter(floatParam);
		nq.addQueryParameter(integerParam);
		
		assertEquals(2, nq.getParameterMap().size());	
		assertEquals(new int[] {Types.FLOAT, Types.INTEGER}, nq.getParameterJDBCTypes(new String[] {"floatParam", "integerParam"}));
		assertEquals(new int[] {Types.INTEGER, Types.FLOAT}, nq.getParameterJDBCTypes(new String[] {"integerParam", "floatParam"}));
	
		assertEquals(new Class[] {Float.class, Integer.class}, nq.getParameterClassTypes(new String[] {"floatParam", "integerParam"}));
		assertEquals(new Class[] {Integer.class, Float.class}, nq.getParameterClassTypes(new String[] {"integerParam", "floatParam"}));

	
		try
		{
			nq.getSingleParameterName();
			fail("Should have thrown a CharmException here");
		}
		catch(Exception e)
		{
		}
		
		
	}
	
	public void assertEquals(int[] expected, int[] actual)
	{
		assertEquals("Array sizes must be the same", expected.length, actual.length);
		for (int i = 0; i < actual.length; i++)
		{
			assertEquals("Element #" + i + " in array does not match", expected[i], actual[i]);
		}
	}
	
	public void assertEquals(Object[] expected, Object[] actual)
	{
		assertEquals("Array sizes must be the same", expected.length, actual.length);
		for (int i = 0; i < actual.length; i++)
		{
			assertEquals("Element #" + i + " in array does not match", expected[i], actual[i]);
		}
	}
}
