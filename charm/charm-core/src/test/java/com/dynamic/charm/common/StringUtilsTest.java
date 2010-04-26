package com.dynamic.charm.common;

import junit.framework.TestCase;

public class StringUtilsTest extends TestCase
{
	
	public void testIsEmpty()
	{
		assertTrue(StringUtils.isEmpty(null));
		assertTrue(StringUtils.isEmpty(""));
		assertFalse(StringUtils.isEmpty(" "));
		assertFalse(StringUtils.isEmpty("foo"));
		assertFalse(StringUtils.isEmpty(" foo "));
		
	}

	public void testIsNotEmpty()
	{
		assertFalse(StringUtils.isNotEmpty(null));
		assertFalse(StringUtils.isNotEmpty(""));
		assertTrue(StringUtils.isNotEmpty(" "));
		assertTrue(StringUtils.isNotEmpty("foo"));
		assertTrue(StringUtils.isNotEmpty(" foo "));
		
	}
	
	public void testIsBlank()
	{
		assertTrue(StringUtils.isBlank(null));
		assertTrue(StringUtils.isBlank(""));
		assertTrue(StringUtils.isBlank(" "));
		assertFalse(StringUtils.isBlank("foo"));
		assertFalse(StringUtils.isBlank(" foo "));
	}
	
	public void testIsNotBlank()
	{
		assertFalse(StringUtils.isNotBlank(null));
		assertFalse(StringUtils.isNotBlank(""));
		assertFalse(StringUtils.isNotBlank(" "));
		assertTrue(StringUtils.isNotBlank("foo"));
		assertTrue(StringUtils.isNotBlank(" foo "));
	}
	
	public void testIsUpperCase()
	{
		assertTrue(StringUtils.isUpperCase("ABCDEF"));
		assertTrue(StringUtils.isUpperCase("ABCDEF"));
		assertFalse(StringUtils.isUpperCase("abcdef"));
		assertFalse(StringUtils.isUpperCase("AbCdEf"));
		assertFalse(StringUtils.isUpperCase("ABC DEF"));
		assertFalse(StringUtils.isUpperCase("abc def"));
		assertFalse(StringUtils.isUpperCase(" "));
	}
	
	public void testIsLowerCase()
	{
		assertFalse(StringUtils.isLowerCase("ABCDEF"));
		assertFalse(StringUtils.isLowerCase("ABCDEF"));
		assertTrue(StringUtils.isLowerCase("abcdef"));
		assertFalse(StringUtils.isLowerCase("AbCdEf"));
		assertFalse(StringUtils.isLowerCase("ABC DEF"));
		assertFalse(StringUtils.isLowerCase("abc def"));
		assertFalse(StringUtils.isLowerCase(" "));
	}
	
	public void testisLowerCaseOrSpace()
	{
		assertFalse(StringUtils.isLowerCaseOrSpace(null));
		assertFalse(StringUtils.isLowerCaseOrSpace("ABCDEF"));
		assertTrue(StringUtils.isLowerCaseOrSpace("abcdef"));
		assertFalse(StringUtils.isLowerCaseOrSpace("AbCdEf"));
		assertFalse(StringUtils.isLowerCaseOrSpace("ABC DEF"));
		assertTrue(StringUtils.isLowerCaseOrSpace("abc def"));
		assertTrue(StringUtils.isLowerCaseOrSpace(" "));
	}
	
	public void testIsUpperCaseOrSpace()
	{
		assertFalse(StringUtils.isUpperCaseOrSpace(null));
		assertTrue(StringUtils.isUpperCaseOrSpace("ABCDEF"));
		assertFalse(StringUtils.isUpperCaseOrSpace("abcdef"));
		assertFalse(StringUtils.isUpperCaseOrSpace("AbCdEf"));
		assertTrue(StringUtils.isUpperCaseOrSpace("ABC DEF"));
		assertFalse(StringUtils.isUpperCaseOrSpace("abc def"));
		assertTrue(StringUtils.isUpperCaseOrSpace(" "));
	}
	
	public void capitalize()
	{
		assertNull(StringUtils.capitalize(null));
		assertEquals("ABC", StringUtils.capitalize("ABC"));
		assertEquals("Abc", StringUtils.capitalize("Abc"));
		assertEquals("Abc", StringUtils.capitalize("abc"));
		assertEquals("Abc", StringUtils.capitalize("abC"));
		assertEquals("Abc Def", StringUtils.capitalize("abc def"));
	}
}
