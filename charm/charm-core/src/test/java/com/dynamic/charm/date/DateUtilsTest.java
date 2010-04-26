package com.dynamic.charm.date;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import junit.framework.TestCase;

public class DateUtilsTest extends TestCase
{
	public static int MILLIS_PER_DAY = 1000 * 60 * 60 * 24;
	
	private Date today;
	private Date today2;
	private Date yesterday; 
	
	protected void setUp() throws Exception
	{
		today = new Date();
		today2 = new Date();
		yesterday = new Date();
		yesterday.setTime(today.getTime() - MILLIS_PER_DAY);
		super.setUp();
	}
	
	public Date createDate(String dateString)
	{
		try
		{
			return new SimpleDateFormat("MM/dd/yyyy HH:mm").parse(dateString);
		}
		catch (ParseException e)
		{
			return null;
		}
	}
	
	public void testIsSameDay()
	{
		assertTrue(DateUtils.isSameDay(today, today));
		assertFalse(DateUtils.isSameDay(null, today));
		assertFalse(DateUtils.isSameDay(today, null));
		assertFalse(DateUtils.isSameDay(today, yesterday));
		assertTrue(DateUtils.isSameDay(createDate("01/01/2001 01:01"), createDate("01/01/2001 01:01")));
		assertTrue(DateUtils.isSameDay(createDate("01/01/2001 01:01"), createDate("01/01/2001 01:02")));
		assertTrue(DateUtils.isSameDay(createDate("01/01/2001 01:01"), createDate("01/01/2001 02:01")));
		assertFalse(DateUtils.isSameDay(createDate("01/01/2001 01:01"), createDate("01/02/2001 01:01")));
		assertFalse(DateUtils.isSameDay(createDate("01/01/2001 01:01"), createDate("02/01/2001 01:01")));
		assertFalse(DateUtils.isSameDay(createDate("01/01/2001 01:01"), createDate("01/01/2002 01:01")));
	}
	
	public void testIsSameTime()
	{
		assertTrue(DateUtils.isSameTime(today, today));
		assertFalse(DateUtils.isSameTime(null, today));
		assertFalse(DateUtils.isSameTime(today, null));
		assertFalse(DateUtils.isSameTime(today, yesterday));
		assertTrue(DateUtils.isSameTime(createDate("01/01/2001 01:01"), createDate("01/01/2001 01:01")));
		assertFalse(DateUtils.isSameTime(createDate("01/01/2001 01:01"), createDate("01/01/2001 01:02")));
		assertFalse(DateUtils.isSameTime(createDate("01/01/2001 01:01"), createDate("01/01/2001 02:01")));
		assertFalse(DateUtils.isSameTime(createDate("01/01/2001 01:01"), createDate("01/02/2001 01:01")));
		assertFalse(DateUtils.isSameTime(createDate("01/01/2001 01:01"), createDate("02/01/2001 01:01")));
		assertFalse(DateUtils.isSameTime(createDate("01/01/2001 01:01"), createDate("01/01/2002 01:01")));	
	}
	
	
	public void testMinutes()
	{
		assertEquals(DateUtils.setMinutes(createDate("01/01/2001 00:00"), 1), createDate("01/01/2001 00:01"));
		assertEquals(DateUtils.setMinutes(createDate("01/01/2001 00:00"), 0), createDate("01/01/2001 00:00"));
		assertEquals(DateUtils.addMinutes(createDate("01/01/2001 00:01"), 10), createDate("01/01/2001 00:11"));
	}

	public void testHours()
	{
		assertEquals(DateUtils.setHour(createDate("01/01/2001 00:00"), 1), createDate("01/01/2001 01:00"));
		assertEquals(DateUtils.setHour(createDate("01/01/2001 00:00"), 0), createDate("01/01/2001 00:00"));
		assertEquals(DateUtils.addHours(createDate("01/01/2001 01:00"), 10), createDate("01/01/2001 11:00"));
	}
	
	public void testDays()
	{
		assertEquals(DateUtils.setDayOfMonth(createDate("01/01/2001 00:00"), 2), createDate("01/02/2001 00:00"));
		assertEquals(DateUtils.addDays(createDate("01/01/2001 00:00"), 10), createDate("01/11/2001 00:00"));
	}
	
	public void testMonths()
	{
		assertEquals(DateUtils.setMonth(createDate("01/01/2001 00:00"), Calendar.FEBRUARY), createDate("02/01/2001 00:00"));
		assertEquals(DateUtils.addMonths(createDate("01/01/2001 00:00"), 10), createDate("11/01/2001 00:00"));
	}

	
}
