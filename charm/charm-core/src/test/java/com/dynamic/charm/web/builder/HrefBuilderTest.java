package com.dynamic.charm.web.builder;

import java.util.LinkedHashMap;

import junit.framework.TestCase;

public class HrefBuilderTest extends TestCase
{
	public void testBuilder()
	{
		HrefBuilder builder = new HrefBuilder("foo.html");
		assertEquals("foo.html", builder.toString());
		
		builder.addParameter("a", "1");
		assertEquals("foo.html?a=1", builder.toString());

		builder.addParameter("b", "2");
		assertEquals("foo.html?a=1&b=2", builder.toString());
		
	}

	public void testWithContext()
	{
		HrefBuilder builder = new HrefBuilder("foo.html", "myApp");
		assertEquals("myApp/foo.html", builder.toString());

		builder = new HrefBuilder("foo.html", "/myApp");
		assertEquals("/myApp/foo.html", builder.toString());
		
		builder = new HrefBuilder("foo.html", "/myApp/");
		assertEquals("/myApp/foo.html", builder.toString());
		
		builder = new HrefBuilder("/foo.html", "myApp");
		assertEquals("myApp/foo.html", builder.toString());

		builder = new HrefBuilder("/foo.html", "/myApp");
		assertEquals("/myApp/foo.html", builder.toString());
		
		builder = new HrefBuilder("/foo.html", "/myApp/");
		assertEquals("/myApp/foo.html", builder.toString());

		
	}
	
	public void testContainsParam()
	{
		HrefBuilder builder = new HrefBuilder("foo.html?a=1");
		builder.addParameter("b", "2");
		assertEquals("foo.html?a=1&b=2", builder.toString());

		builder.addParameter("c", "3");
		assertEquals("foo.html?a=1&b=2&c=3", builder.toString());
		
	}
	
	public void testMap()
	{
		HrefBuilder builder = new HrefBuilder("foo.html");
		LinkedHashMap map = new LinkedHashMap();
		map.put("a", "1");
		map.put("b", "2");
		map.put("c", "3");
		
		builder.addAllParameters(map);
		assertEquals("foo.html?a=1&b=2&c=3", builder.toString());
	}
	
	public void testNulls()
	{
		HrefBuilder builder = new HrefBuilder("foo.html");
		builder.addParameter("a", null);
		assertEquals("foo.html", builder.toString());

		builder = new HrefBuilder("foo.html");
		builder.addParameter(null, "a");
		assertEquals("foo.html", builder.toString());

		builder = new HrefBuilder("#");
		assertEquals("#", builder.toString());
		
	}
}
