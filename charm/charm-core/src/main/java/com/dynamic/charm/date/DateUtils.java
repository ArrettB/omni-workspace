package com.dynamic.charm.date;

import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

public class DateUtils
{
	public static final int MILLIS_PER_DAY = 24 * 60 * 60 * 1000;

	private static Calendar getCalendarInstance(Date d)
	{
		Calendar cal = Calendar.getInstance();
		cal.setTime(d);
		return cal;
	}

	public static boolean isSameDay(Date date1, Date date2)
	{
		if (date1 != null && date2 != null)
		{
			return isSameDay(getCalendarInstance(date1), getCalendarInstance(date2));
		}
		else
		{
			return false;
		}
	}

	public static boolean isSameDay(Calendar cal1, Calendar cal2)
	{
		if (cal1 != null && cal2 != null)
		{
			return cal1.get(Calendar.YEAR) == cal2.get(Calendar.YEAR) && 
			       cal1.get(Calendar.DAY_OF_YEAR) == cal2.get(Calendar.DAY_OF_YEAR);
		}
		else
		{
			return false;
		}
	}

	public static boolean isSameTime(Date date1, Date date2)
	{
		if (date1 != null && date2 != null)
		{
			return isSameTime(getCalendarInstance(date1), getCalendarInstance(date2));
		}
		else
		{
			return false;
		}
	}

	public static boolean isSameTime(Calendar cal1, Calendar cal2)
	{
		if (cal1 != null && cal2 != null)
		{
			return cal1.get(Calendar.YEAR) == cal2.get(Calendar.YEAR) && 
			       cal1.get(Calendar.DAY_OF_YEAR) == cal2.get(Calendar.DAY_OF_YEAR) && 
			       cal1.get(Calendar.HOUR_OF_DAY) == cal2.get(Calendar.HOUR_OF_DAY) && 
			       cal1.get(Calendar.MINUTE) == cal2.get(Calendar.MINUTE);
		}
		else
		{
			return false;
		}

	}

	public static boolean isSameInstant(Date date1, Date date2)
	{
		if (date1 != null && date2 != null)
		{
			return isSameInstant(getCalendarInstance(date1), getCalendarInstance(date2));
		}
		else
		{
			return false;
		}
	}

	public static boolean isSameInstant(Calendar cal1, Calendar cal2)
	{
		if (cal1 != null && cal2 != null)
		{
			return cal1.getTimeInMillis() == cal2.getTimeInMillis();
		}
		else
		{
			return false;
		}
	}

	public static Date truncateTime(Date in)
	{
		Calendar cal = getCalendarInstance(in);
		cal.set(Calendar.HOUR_OF_DAY, 0);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);
		cal.set(Calendar.MILLISECOND, 0);
		return cal.getTime();
	}
	
	/**
	 * The seconds of the minute (0-59).
	 */
	public static int getSeconds(Date in)
	{
		Calendar cal = getCalendarInstance(in);
		return cal.get(Calendar.SECOND);
	}

	/**
	 * The minute of the hour (0-59).
	 */
	public static int getMinute(Date in)
	{
		Calendar cal = getCalendarInstance(in);
		return cal.get(Calendar.MINUTE);
	}

	/**
	 * The hour of the day (0-23).
	 */
	public static int getHour(Date in)
	{
		Calendar cal = getCalendarInstance(in);
		return cal.get(Calendar.HOUR_OF_DAY);
	}

	/**
	 * The week of the year (0-53)
	 */
	public static int getWeek(Date in)
	{
		Calendar cal = getCalendarInstance(in);
		return cal.get(Calendar.WEEK_OF_YEAR);
	}

	/**
	 * The day of the week (1-7), 1 = Sunday
	 */
	public static int getDayOfWeek(Date in)
	{
		Calendar cal = getCalendarInstance(in);
		return cal.get(Calendar.DAY_OF_WEEK);
	}

	/**
	 * The month of the year (0-11)
	 */
	public static int getMonth(Date in)
	{
		Calendar cal = getCalendarInstance(in);
		return cal.get(Calendar.MONTH);
	}

	/**
	 * The day of the month (1-31)
	 */
	public static int getDayOfMonth(Date in)
	{
		Calendar cal = getCalendarInstance(in);
		return cal.get(Calendar.DAY_OF_MONTH);
	}

	/**
	 * The four-digit year, e.g. 2001
	 */
	public static int getYear(Date in)
	{
		Calendar cal = getCalendarInstance(in);
		return cal.get(Calendar.YEAR);
	}

	/**
	 * Set the second of the minute (0-59).
	 */
	public static Date setSeconds(Date in, int seconds)
	{
		Calendar cal = getCalendarInstance(in);
		cal.set(Calendar.SECOND, seconds);
		return cal.getTime();
	}

	/**
	 * Set minute of the hour (0-59).
	 */
	public static Date setMinutes(Date in, int minutes)
	{
		Calendar cal = getCalendarInstance(in);
		cal.set(Calendar.MINUTE, minutes);
		return cal.getTime();
	}

	/**
	 * Set the hour of the day (0-23).
	 */
	public static Date setHour(Date in, int hour)
	{
		Calendar cal = getCalendarInstance(in);
		cal.set(Calendar.HOUR, hour);
		return cal.getTime();
	}

	/**
	 * Set the day of the month (1-31).
	 */
	public static Date setDayOfMonth(Date in, int day)
	{
		Calendar cal = getCalendarInstance(in);
		cal.set(Calendar.DAY_OF_MONTH, day);
		return cal.getTime();
	}

	/**
	 * Set the month of the year (0-11).
	 */
	public static Date setMonth(Date in, int month)
	{
		Calendar cal = getCalendarInstance(in);
		cal.set(Calendar.MONTH, month);
		return cal.getTime();
	}

	/**
	 * Set the year (adjusts two digit years with fixYear()).
	 */
	public static Date setYear(Date in, int year)
	{
		Calendar cal = getCalendarInstance(in);
		cal.set(Calendar.YEAR, fixYear(year));
		return cal.getTime();
	}

	public static Date addSeconds(Date in, int seconds)
	{
		Calendar cal = getCalendarInstance(in);
		cal.add(Calendar.SECOND, seconds);
		return cal.getTime();
	}

	public static Date addMinutes(Date in, int minutes)
	{
		Calendar cal = getCalendarInstance(in);
		cal.add(Calendar.MINUTE, minutes);
		return cal.getTime();
	}

	public static Date addHours(Date in, int hours)
	{
		Calendar cal = getCalendarInstance(in);
		cal.add(Calendar.HOUR, hours);
		return cal.getTime();
	}

	public static Date addDays(Date in, int days)
	{
		Calendar cal = getCalendarInstance(in);
		cal.add(Calendar.DATE, days);
		return cal.getTime();
	}

	public static Date addWeeks(Date in, int weeks)
	{
		Calendar cal = getCalendarInstance(in);
		cal.add(Calendar.DATE, weeks * 7);
		return cal.getTime();
	}

	public static Date addMonths(Date in, int months)
	{
		Calendar cal = getCalendarInstance(in);
		cal.add(Calendar.MONTH, months);
		return cal.getTime();
	}

	public static Date addYears(Date in, int years)
	{
		Calendar cal = getCalendarInstance(in);
		cal.add(Calendar.YEAR, years);
		return cal.getTime();
	}


	/**
	 * Covert a two digit year into a four digit year intelligently. For
	 * example: If the current century is 2000, then 00-24 = 2000-2024 and 25-99 =
	 * 1925-1999
	 */
	public static int fixYear(int year)
	{
		if (year >= 100)
			return year;

		GregorianCalendar cal = new GregorianCalendar();
		int century = ((int) (cal.get(Calendar.YEAR) / 100)) * 100;

		if (year < 25)
			return century + year;
		else
			return century + year - 100;
	}

	

}
