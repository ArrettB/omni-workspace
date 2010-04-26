package com.dynamic.charm.common.formats;

import java.text.DecimalFormat;
import java.text.FieldPosition;
import java.text.Format;
import java.text.ParsePosition;

/**
 * A formatter for formatting time lengths.
 *
 */
public class IntervalFormat extends Format
{

	/**
	 * Formats a long which represent a number of bytes.
	 */
	public String format(long ms)
	{
		return format(new Long(ms));
	}

	/**
	 * Formats a long which represent a number of kilobytes.
	 */
	public String formatSeconds(long seconds)
	{
		return format(new Long(seconds * 1000));
	}

	/**
	 * Format the given object (must be a Long).
	 *
	 * @param obj assumed to be the number of bytes as a Long.
	 * @param buf the StringBuffer to append to.
	 * @param pos
	 * @return A formatted string representing the given bytes in more human-readable form.
	 */
	public StringBuffer format(Object obj, StringBuffer buf, FieldPosition pos)
	{
		if (obj instanceof Long)
		{
			long interval = ((Long) obj).longValue();
			long days = interval / (1000 * 60 * 60 * 24);
			interval = interval % (1000 * 60 * 60 * 24);
			long hours = interval / (1000 * 60 * 60);
			interval = interval % (1000 * 60 * 60);
			long minutes = interval / (1000 * 60);
			interval = interval % (1000 * 60);
			long seconds = interval / 1000;
			interval = interval % 1000;
			long milliseconds = interval;

			
			if (days > 0)
			{
				buf.append(days + " day");
				if (days != 1) buf.append("s");
				buf.append(" ");
			}
			if (days > 0 || hours > 0)
			{
				buf.append(hours + " hour");
				if (hours != 1) buf.append("s");
				buf.append(" ");
			}
			if (days > 0 || hours > 0 || minutes > 0)
			{
				buf.append(minutes + " minute");
				if (minutes != 1) buf.append("s");
				buf.append(" ");
			}
			if (days == 0 && hours == 0)
			{
				if (minutes == 0 && seconds == 0)
				{
					buf.append(milliseconds);
					buf.append("ms");
				}
				else if (seconds > 0)
				{
					buf.append(seconds);
					if (minutes == 0 && milliseconds > 0)
						buf.append(".").append(new DecimalFormat("000").format(milliseconds));
					buf.append(" second");
					if (seconds != 1 || milliseconds > 0)
						buf.append("s");
				}
			}

		}
		return buf;
	}

	/**
	 * In this implementation, returns null always.
	 *
	 * @param source
	 * @param pos
	 * @return returns null in this implementation.
	 */
	public Object parseObject(String source, ParsePosition pos)
	{
		return null;
	}
	
	
}
