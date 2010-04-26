package com.dynamic.charm.common;

import java.math.BigDecimal;
import java.text.NumberFormat;
import java.text.ParseException;

import org.apache.log4j.Logger;

public class NumberUtils
{
	public static Double ZERO_DOUBLE = new Double(0);
	public static BigDecimal ZERO_BIG_DECIMAL = new BigDecimal(0);
	public static Integer ZERO_INTEGER = new Integer(0);
	
	private final static Logger logger = Logger.getLogger(NumberUtils.class);
	
	
	public static long nullSafeLongValue(Number n)
	{
		return n != null ? n.longValue() : 0;
	}
	
	public static int nullSafeIntValue(Number n)
	{
		return n != null ? n.intValue() : 0;
	}

	public static double nullSafeDoubleValue(Number n)
	{
		return n != null ? n.doubleValue() : 0;
	}
	
	public static float nullSafeFloatValue(Number n)
	{
		return n != null ? n.floatValue() : 0;
	}
	
	public static boolean nullSafeBooleanValue(Boolean b)
	{
		return b != null ? b.booleanValue() : false;
	}

	public static BigDecimal nullSafeBigDecimalValue(Number n)
	{
		if (n == null)
		{
			return ZERO_BIG_DECIMAL;
		}
		else if (n.getClass().equals(BigDecimal.class))
		{
			return (BigDecimal) n;
		}
		else
		{
			return new BigDecimal(n.doubleValue());
		}
	}
	
	
	public static long maxLong(Number n1, Number n2)
	{
		long l1 = nullSafeLongValue(n1);
		long l2 = nullSafeLongValue(n2);
		return (l1 >= l2) ? l1 : l2;
	}

	public static int maxInt(Number n1, Number n2)
	{
		int i1 = nullSafeIntValue(n1);
		int i2 = nullSafeIntValue(n2);
		return (i1 >= i2) ? i1 : i2;
	}

	public static double maxDouble(Number n1, Number n2)
	{
		double d1 = nullSafeDoubleValue(n1);
		double d2 = nullSafeDoubleValue(n2);
		return (d1 >= d2) ? d1 : d2;
	}

	public static float maxFloat(Number n1, Number n2)
	{
		float f1 = nullSafeFloatValue(n1);
		float f2 = nullSafeFloatValue(n2);
		return (f1 >= f2) ? f1 : f2;
	}

	public static long minLong(Number n1, Number n2)
	{
		long l1 = nullSafeLongValue(n1);
		long l2 = nullSafeLongValue(n2);
		return (l1 <= l2) ? l1 : l2;
	}

	public static int minInt(Number n1, Number n2)
	{
		int i1 = nullSafeIntValue(n1);
		int i2 = nullSafeIntValue(n2);
		return (i1 <= i2) ? i1 : i2;
	}

	public static double minDouble(Number n1, Number n2)
	{
		double d1 = nullSafeDoubleValue(n1);
		double d2 = nullSafeDoubleValue(n2);
		return (d1 <= d2) ? d1 : d2;
	}

	public static float minFloat(Number n1, Number n2)
	{
		float f1 = nullSafeFloatValue(n1);
		float f2 = nullSafeFloatValue(n2);
		return (f1 <= f2) ? f1 : f2;
	}


	public static boolean areEqual(Double d1, Double d2, int precision)
	{
		if (d1 == null)
		{
			return false;
		}
		if (d2 == null)
		{
			return false;
		}
		
		long i1 =  Math.round(d1.doubleValue() * Math.pow(10, precision));
		long i2 =  Math.round(d2.doubleValue() * Math.pow(10, precision));
		
		return i1 == i2;
	}
	
	public static boolean areEqual(double d1, double d2, int precision)
	{
		long i1 =  Math.round(d1 * Math.pow(10, precision));
		long i2 =  Math.round(d2  *Math.pow(10, precision));
		
		return i1 == i2;
	}
	
	
	public static double mult(Number d1, Number d2)
	{
		if (d1 == null || d2 == null)
			return 0;
		else
			return d1.doubleValue() * d2.doubleValue();
	}

	public static double mult(Number d1, double d2)
	{
		if (d1 == null)
			return 0;
		else
			return d1.doubleValue() * d2;
	}

	public static double mult(double d1, Number d2)
	{
		if (d2 == null)
			return 0;
		else
			return d1 * d2.doubleValue();
	}

	public static double div(Number dividend, Number divisor)
	{
		if (divisor == null)
			return Double.NaN;
		else if (dividend  == null)
			return 0;
		else
			return dividend.doubleValue() / divisor.doubleValue();
	}

	public static double div(Number dividend, double divisor)
	{
		if (dividend == null)
			return 0;
		else
			return dividend.doubleValue() / divisor;
	}

	public static double div(double dividend, Number divisor)
	{
		if (divisor == null)
			return Double.NaN;
		else
			return dividend / divisor.doubleValue();
	}	
	
	public static double add(Number d1, Number d2)
	{
		return (d1 != null ? d1.doubleValue() : 0) + (d2 != null ? d2.doubleValue() : 0);
	}

	public static double add(Number d1, double d2)
	{
		return (d1 != null ? d1.doubleValue() : 0) + d2;
	}

	public static double add(double d1, Number d2)
	{
		return d1 + (d2 != null ? d2.doubleValue() : 0);
	}

	public static double sub(Number d1, Number d2)
	{
		return (d1 != null ? d1.doubleValue() : 0) - (d2 != null ? d2.doubleValue() : 0);
	}

	public static double sub(Number d1, double d2)
	{
		return (d1 != null ? d1.doubleValue() : 0) - d2;
	}

	public static double sub(double d1, Number d2)
	{
		return d1 - (d2 != null ? d2.doubleValue() : 0);
	}

	public static boolean isGreater(Number d1, Number d2)
	{
		if (d1 == null)
			return false;
		if (d2 == null)
			return true;

		return (d1.doubleValue() > d2.doubleValue());

	}	

	public static Integer asInteger(Object value)
	{
		return asInteger(value, false);
	}
	
	public static Integer asIntegerNullAsZero(Object value)
	{
		return asInteger(value, true);
	}

	private static Integer asInteger(Object value, boolean nullAsZero)
	{
		if (value == null)
		{
			return nullAsZero ? ZERO_INTEGER : null;
		}
		else if (value.getClass().equals(Integer.class))
		{
			return (Integer) value;
		}
		else if (value.getClass().equals(Number.class))
		{
			return new Integer(((Number)value).intValue());
		}
		else
		{
			String asString = value.toString().trim();
			{
				
		        try
		        {
		            if (asString.equals("-"))
		            {
		                return ZERO_INTEGER;
		            }
		            else if (asString.endsWith("%"))
		            {
		                return new Integer(NumberFormat.getPercentInstance().parse(asString).intValue());
		            }
		            else
		            {
		                return new Integer(NumberFormat.getNumberInstance().parse(asString).intValue());
		            }

		        }
		        catch (ParseException e)
		        {
		            try
		            {
		                return new Integer(NumberFormat.getCurrencyInstance().parse(asString).intValue());
		            }
		            catch (ParseException e1)
		            {
		            	logger.warn("Could not parse " + asString);
		            	return ZERO_INTEGER;
		            }
		        }
				
			}
		}
		
	}

	public static Double asDouble(Object value)
	{
		return asDouble(value, false);
	}
	
	public static Double asDoubleNullAsZero(Object value)
	{
		return asDouble(value, true);
	}

	private static Double asDouble(Object value, boolean nullAsZero)
	{
		if (value == null)
		{
			return nullAsZero ? ZERO_DOUBLE : null;
		}
		else if (value.getClass().equals(Double.class))
		{
			return (Double) value;
		}
		else if (value.getClass().equals(Number.class))
		{
			return new Double(((Number)value).doubleValue());
		}
		else
		{
			String asString = value.toString().trim();
			{
				
		        try
		        {
		            if (asString.equals("-"))
		            {
		                return ZERO_DOUBLE;
		            }
		            else if (asString.endsWith("%"))
		            {
		                return new Double(NumberFormat.getPercentInstance().parse(asString).doubleValue());
		            }
		            else
		            {
		                return new Double(NumberFormat.getNumberInstance().parse(asString).doubleValue());
		            }

		        }
		        catch (ParseException e)
		        {
		            try
		            {
		                return new Double(NumberFormat.getCurrencyInstance().parse(asString).doubleValue());
		            }
		            catch (ParseException e1)
		            {
		            	logger.warn("Could not parse " + asString);
		            	return ZERO_DOUBLE;
		            }
		        }
				
			}
		}
		
	}
	
	public static BigDecimal asBigDecimal(Object value)
	{
		return asBigDecimal(value, false);		
	}

	public static BigDecimal asBigDecimalNullAsZero(Object value)
	{
		return asBigDecimal(value, true);		
	}

	private static BigDecimal asBigDecimal(Object value, boolean nullAsZero)
	{
		if (value == null)
		{
			return nullAsZero ? ZERO_BIG_DECIMAL : null;
		}
		else if (value.getClass().equals(BigDecimal.class))
		{
			return (BigDecimal) value;
		}
		else if (value.getClass().equals(Number.class))
		{
			return new BigDecimal(((Number)value).doubleValue());
		}
		else
		{
			String asString = value.toString().trim();
			{
				
		        try
		        {
		            if (asString.equals("-"))
		            {
		                return ZERO_BIG_DECIMAL;
		            }
		            else if (asString.endsWith("%"))
		            {
		                return new BigDecimal(NumberFormat.getPercentInstance().parse(asString).doubleValue());
		            }
		            else
		            {
		                return new BigDecimal(NumberFormat.getNumberInstance().parse(asString).doubleValue());
		            }

		        }
		        catch (ParseException e)
		        {
		            try
		            {
		                return new BigDecimal(NumberFormat.getCurrencyInstance().parse(asString).doubleValue());
		            }
		            catch (ParseException e1)
		            {
		            	logger.warn("Could not parse " + asString);
		            	return ZERO_BIG_DECIMAL;
		            }
		        }
				
			}
		}
		
	}
	
	
	
}
