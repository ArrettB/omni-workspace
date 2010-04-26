/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.

 * Copyright 2005, Dynamic Information Systems, LLC
 * $Id: RequestUtils.java 199 2006-11-14 23:38:41Z gcase $

 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL DYNAMIC INFORMATIONS SYTEMS, LLC
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
 * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 * ====================================================================
 */

package com.dynamic.charm.web;

import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Enumeration;
import java.util.Map;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import com.dynamic.charm.exception.ParameterMissingException;
import com.dynamic.charm.exception.ParameterParseException;

public abstract class RequestUtils
{
	private final static Logger logger = Logger.getLogger(RequestUtils.class);

	private static final IntParser INT_PARSER = new IntParser();

	private static final LongParser LONG_PARSER = new LongParser();

	private static final FloatParser FLOAT_PARSER = new FloatParser();

	private static final DoubleParser DOUBLE_PARSER = new DoubleParser();

	private static final BooleanParser BOOLEAN_PARSER = new BooleanParser();

	private static final StringParser STRING_PARSER = new StringParser();

	public static String getStringParameter(HttpServletRequest request, String parameterName)
	{
		try
		{
			return (String) STRING_PARSER.getParameter(request, parameterName, null);
		}
		catch (ParameterParseException e)
		{
			// this should never happen with a string parameter
			logger.error("ParameterParserException while parsing a String?", e);
			return null;
		}
	}

	public static String getStringParameter(HttpServletRequest request, String parameterName, String defaultValue)
	{
		try
		{
			return (String) STRING_PARSER.getParameter(request, parameterName, defaultValue);
		}
		catch (ParameterParseException e)
		{
			// this should never happen with a string parameter
			logger.error("ParameterParserException while parsing a String?", e);
			return null;
		}
	}

	public static String getRequiredStringParameter(HttpServletRequest request, String parameterName) throws ParameterMissingException
	{
		try
		{
			return (String) STRING_PARSER.getRequiredParameter(request, parameterName);
		}
		catch (ParameterParseException e)
		{
			// this should never happen with a string parameter
			logger.error("ParameterParserException while parsing a String?", e);
			return null;
		}
	}

	public static Integer getIntegerParameter(HttpServletRequest request, String parameterName) throws ParameterParseException
	{
		return (Integer) INT_PARSER.getParameter(request, parameterName, null);
	}

	public static Integer getIntegerParameter(HttpServletRequest request, String parameterName, Integer defaultValue) throws ParameterParseException
	{
		return (Integer) INT_PARSER.getParameter(request, parameterName, defaultValue);
	}

	public static Integer getIntegerParameter(HttpServletRequest request, String parameterName, int defaultValue) throws ParameterParseException
	{
		return (Integer) INT_PARSER.getParameter(request, parameterName, new Integer(defaultValue));
	}

	public static Integer getRequiredIntegerParameter(HttpServletRequest request, String parameterName) throws ParameterMissingException, ParameterParseException
	{
		return (Integer) INT_PARSER.getRequiredParameter(request, parameterName);
	}

	public static Long getLongParameter(HttpServletRequest request, String parameterName) throws ParameterParseException
	{
		return (Long) LONG_PARSER.getParameter(request, parameterName, null);
	}

	public static Long getLongParameter(HttpServletRequest request, String parameterName, Long defaultValue) throws ParameterParseException
	{
		return (Long) LONG_PARSER.getParameter(request, parameterName, defaultValue);
	}

	public static Long getLongParameter(HttpServletRequest request, String parameterName, long defaultValue) throws ParameterParseException
	{
		return (Long) LONG_PARSER.getParameter(request, parameterName, new Long(defaultValue));
	}

	public static Long getRequiredLongParameter(HttpServletRequest request, String parameterName) throws ParameterMissingException, ParameterParseException
	{
		return (Long) LONG_PARSER.getRequiredParameter(request, parameterName);
	}

	public static Float getFloatParameter(HttpServletRequest request, String parameterName) throws ParameterParseException
	{
		return (Float) FLOAT_PARSER.getParameter(request, parameterName, null);
	}

	public static Float getFloatParameter(HttpServletRequest request, String parameterName, Float defaultValue) throws ParameterParseException
	{
		return (Float) FLOAT_PARSER.getParameter(request, parameterName, defaultValue);
	}

	public static Float getFloatParameter(HttpServletRequest request, String parameterName, float defaultValue) throws ParameterParseException
	{
		return (Float) FLOAT_PARSER.getParameter(request, parameterName, new Float(defaultValue));
	}

	public static Float getRequiredFloatParameter(HttpServletRequest request, String parameterName) throws ParameterMissingException, ParameterParseException
	{
		return (Float) FLOAT_PARSER.getRequiredParameter(request, parameterName);
	}

	public static Double getDoubleParameter(HttpServletRequest request, String parameterName) throws ParameterParseException
	{
		return (Double) DOUBLE_PARSER.getParameter(request, parameterName, null);
	}

	public static Double getDoubleParameter(HttpServletRequest request, String parameterName, Double defaultValue) throws ParameterParseException
	{
		return (Double) DOUBLE_PARSER.getParameter(request, parameterName, defaultValue);
	}

	public static Double getDoubleParameter(HttpServletRequest request, String parameterName, double defaultValue) throws ParameterParseException
	{
		return (Double) DOUBLE_PARSER.getParameter(request, parameterName, new Double(defaultValue));
	}

	public static Double getRequiredDoubleParameter(HttpServletRequest request, String parameterName) throws ParameterMissingException, ParameterParseException
	{
		return (Double) DOUBLE_PARSER.getRequiredParameter(request, parameterName);
	}

	public static Double getDoubleParameter(HttpServletRequest request, String parameterName, String pattern) throws ParameterParseException
	{
		ParameterParser parser = new FormattedDoubleParser(new DecimalFormat(pattern));
		return (Double) parser.getParameter(request, parameterName, null);
	}

	public static Double getDoubleParameter(HttpServletRequest request, String parameterName, String pattern, Double defaultValue) throws ParameterParseException
	{
		ParameterParser parser = new FormattedDoubleParser(new DecimalFormat(pattern));
		return (Double) parser.getParameter(request, parameterName, defaultValue);
	}

	public static Double getDoubleParameter(HttpServletRequest request, String parameterName, String pattern, double defaultValue) throws ParameterParseException
	{
		ParameterParser parser = new FormattedDoubleParser(new DecimalFormat(pattern));
		return (Double) parser.getParameter(request, parameterName, new Double(defaultValue));
	}

	public static Double getRequiredDoubleParameter(HttpServletRequest request, String parameterName, String pattern) throws ParameterMissingException, ParameterParseException
	{
		ParameterParser parser = new FormattedDoubleParser(new DecimalFormat(pattern));
		return (Double) parser.getRequiredParameter(request, parameterName);
	}
	
	public static Double getMoneyParameter(HttpServletRequest request, String parameterName) throws ParameterParseException
	{
		ParameterParser parser = new FormattedDoubleParser(NumberFormat.getCurrencyInstance(request.getLocale()));
		return (Double) parser.getParameter(request, parameterName, null);
	}

	public static Double getMoneyParameter(HttpServletRequest request, String parameterName, Double defaultValue) throws ParameterParseException
	{
		ParameterParser parser = new FormattedDoubleParser(NumberFormat.getCurrencyInstance(request.getLocale()));
		return (Double) parser.getParameter(request, parameterName, defaultValue);
	}

	public static Double getMoneyParameter(HttpServletRequest request, String parameterName, double defaultValue) throws ParameterParseException
	{
		ParameterParser parser = new FormattedDoubleParser(NumberFormat.getCurrencyInstance(request.getLocale()));
		return (Double) parser.getParameter(request, parameterName, new Double(defaultValue));
	}

	public static Double getRequiredMoneyParameter(HttpServletRequest request, String parameterName) throws ParameterMissingException, ParameterParseException
	{
		ParameterParser parser = new FormattedDoubleParser(NumberFormat.getCurrencyInstance(request.getLocale()));
		return (Double) parser.getRequiredParameter(request, parameterName);
	}

	public static Boolean getBooleanParameter(HttpServletRequest request, String parameterName) throws ParameterParseException
	{
		return (Boolean) BOOLEAN_PARSER.getParameter(request, parameterName, null);
	}

	public static Boolean getBooleanParameter(HttpServletRequest request, String parameterName, Boolean defaultValue) throws ParameterParseException
	{
		return (Boolean) BOOLEAN_PARSER.getParameter(request, parameterName, defaultValue);
	}

	public static Boolean getBooleanParameter(HttpServletRequest request, String parameterName, boolean defaultValue) throws ParameterParseException
	{
		return (Boolean) BOOLEAN_PARSER.getParameter(request, parameterName, defaultValue ? Boolean.TRUE : Boolean.FALSE);
	}

	public static Boolean getRequiredBooleanParameter(HttpServletRequest request, String parameterName) throws ParameterMissingException, ParameterParseException
	{
		return (Boolean) BOOLEAN_PARSER.getRequiredParameter(request, parameterName);
	}

	public static Date getDateParameter(HttpServletRequest request, String parameterName, String pattern) throws ParameterParseException
	{
		DateParser parser = new DateParser(new SimpleDateFormat(pattern));
		return (Date) parser.getParameter(request, parameterName, null);
	}

	public static Date getDateParameter(HttpServletRequest request, String parameterName, String pattern, Date defaultValue) throws ParameterParseException
	{
		DateParser parser = new DateParser(new SimpleDateFormat(pattern));
		return (Date) parser.getParameter(request, parameterName, defaultValue);
	}

	public static Date getRequiredDateParameter(HttpServletRequest request, String parameterName, String pattern) throws ParameterMissingException, ParameterParseException
	{
		DateParser parser = new DateParser(new SimpleDateFormat(pattern));
		return (Date) parser.getRequiredParameter(request, parameterName);
	}
	
	private abstract static class ParameterParser
	{
		public Object getParameter(HttpServletRequest request, String parameterName, Object defaultValue) throws ParameterParseException
		{
			try
			{
				return this.parse(parameterName, request.getParameter(parameterName));
			}
			catch (ParameterMissingException ignored)
			{
				return defaultValue;
			}
		}

		public Object getRequiredParameter(HttpServletRequest request, String parameterName) throws ParameterMissingException, ParameterParseException
		{
			return this.parse(parameterName, request.getParameter(parameterName));
		}

		protected final Object parse(String name, String parameter) throws ParameterParseException, ParameterMissingException
		{
			validateRequiredParameter(name, parameter);
			try
			{
				return doParse(parameter);
			}
			catch (NumberFormatException ex)
			{
				throw new ParameterParseException("Required " + getType() + " parameter '" + name + "' with value of '" + parameter + "' is not a valid number");
			}
			catch (ParseException ex)
			{
				throw new ParameterParseException("Required " + getType() + " parameter '" + name + "' with value of '" + parameter + "' is not a valid number");
			}
		}

		protected final void validateRequiredParameter(String name, Object parameter) throws ParameterMissingException
		{
			if (parameter == null)
			{
				throw new ParameterMissingException("Required " + getType() + " parameter '" + name + "' is not present", name);
			}
			if ("".equals(parameter))
			{
				throw new ParameterMissingException("Required " + getType() + " parameter '" + name + "' contains no value", name);
			}
		}

		protected abstract String getType();

		protected abstract Object doParse(String parameter) throws NumberFormatException, ParseException;
	}

	private static class IntParser extends ParameterParser
	{
		protected String getType()
		{
			return "int";
		}

		protected Object doParse(String s) throws NumberFormatException
		{
			return Integer.valueOf(s);
		}

		public int parseInt(String name, String parameter) throws ParameterParseException, ParameterMissingException
		{
			return ((Number) parse(name, parameter)).intValue();
		}

		public int[] parseInts(String name, String[] values) throws ParameterParseException, ParameterMissingException
		{
			validateRequiredParameter(name, values);

			int[] parameters = new int[values.length];
			for (int i = 0; i < values.length; i++)
			{
				parameters[i] = parseInt(name, values[i]);
			}
			return parameters;
		}
	}

	private static class LongParser extends ParameterParser
	{
		protected String getType()
		{
			return "long";
		}

		protected Object doParse(String parameter) throws NumberFormatException
		{
			return Long.valueOf(parameter);
		}

		public long parseLong(String name, String parameter) throws ParameterParseException, ParameterMissingException
		{
			return ((Number) parse(name, parameter)).longValue();
		}

		public long[] parseLongs(String name, String[] values) throws ParameterParseException, ParameterMissingException
		{
			validateRequiredParameter(name, values);

			long[] parameters = new long[values.length];
			for (int i = 0; i < values.length; i++)
			{
				parameters[i] = parseLong(name, values[i]);
			}
			return parameters;
		}
	}

	private static class FloatParser extends ParameterParser
	{
		protected String getType()
		{
			return "float";
		}

		protected Object doParse(String parameter) throws NumberFormatException
		{
			return Float.valueOf(parameter);
		}

		public float parseFloat(String name, String parameter) throws ParameterParseException, ParameterMissingException
		{
			return ((Number) parse(name, parameter)).floatValue();
		}

		public float[] parseFloats(String name, String[] values) throws ParameterParseException, ParameterMissingException
		{
			validateRequiredParameter(name, values);

			float[] parameters = new float[values.length];
			for (int i = 0; i < values.length; i++)
			{
				parameters[i] = parseFloat(name, values[i]);
			}
			return parameters;
		}
	}

	private static class DoubleParser extends ParameterParser
	{
		protected String getType()
		{
			return "double";
		}

		protected Object doParse(String parameter) throws NumberFormatException
		{
			return Double.valueOf(parameter);
		}

		public double parseDouble(String name, String parameter) throws ParameterParseException, ParameterMissingException
		{
			return ((Number) parse(name, parameter)).doubleValue();
		}

		public double[] parseDoubles(String name, String[] values) throws ParameterParseException, ParameterMissingException
		{
			validateRequiredParameter(name, values);

			double[] parameters = new double[values.length];
			for (int i = 0; i < values.length; i++)
			{
				parameters[i] = parseDouble(name, values[i]);
			}
			return parameters;
		}
	}

	private static class BooleanParser extends ParameterParser
	{
		protected String getType()
		{
			return "boolean";
		}

		protected Object doParse(String parameter) throws NumberFormatException
		{
			return ((parameter.equalsIgnoreCase("true") || parameter.equalsIgnoreCase("on") || parameter.equalsIgnoreCase("yes") || parameter.equals("1") || parameter.equalsIgnoreCase("y") || parameter.equalsIgnoreCase("t")) ? Boolean.TRUE : Boolean.FALSE);
		}

		public boolean parseBoolean(String name, String parameter) throws ParameterParseException, ParameterMissingException
		{
			return ((Boolean) parse(name, parameter)).booleanValue();
		}

		public boolean[] parseBooleans(String name, String[] values) throws ParameterParseException, ParameterMissingException
		{
			validateRequiredParameter(name, values);

			boolean[] parameters = new boolean[values.length];
			for (int i = 0; i < values.length; i++)
			{
				parameters[i] = parseBoolean(name, values[i]);
			}
			return parameters;
		}
	}

	private static class StringParser extends ParameterParser
	{
		protected String getType()
		{
			return "string";
		}

		protected Object doParse(String parameter) throws NumberFormatException
		{
			return parameter;
		}

		public String validateRequiredString(String name, String value) throws ParameterParseException, ParameterMissingException
		{
			validateRequiredParameter(name, value);
			return value;
		}

		public String[] validateRequiredStrings(String name, String[] values) throws ParameterParseException, ParameterMissingException
		{
			validateRequiredParameter(name, values);
			for (int i = 0; i < values.length; i++)
			{
				validateRequiredParameter(name, values[i]);
			}
			return values;
		}
	}

	private static class FormattedDoubleParser extends ParameterParser
	{
		private NumberFormat format;

		public FormattedDoubleParser(NumberFormat format)
		{
			this.format = format;
		}

		protected String getType()
		{
			return "formatted double";
		}

		protected Object doParse(String parameter) throws NumberFormatException, ParseException
		{
			return new Double(format.parse(parameter).doubleValue());
		}

		public double parseDouble(String name, String parameter) throws ParameterParseException, ParameterMissingException
		{
			return ((Number) parse(name, parameter)).doubleValue();
		}

		public double[] parseDoubles(String name, String[] values) throws ParameterParseException, ParameterMissingException
		{
			validateRequiredParameter(name, values);

			double[] parameters = new double[values.length];
			for (int i = 0; i < values.length; i++)
			{
				parameters[i] = parseDouble(name, values[i]);
			}
			return parameters;
		}
	}

	private static class DateParser extends ParameterParser
	{
		private DateFormat format;

		public DateParser(DateFormat format)
		{
			this.format = format;
		}

		protected String getType()
		{
			return "date";
		}

		protected Object doParse(String parameter) throws NumberFormatException, ParseException
		{
			return format.parseObject(parameter);
		}

	}	
	
	
	/**
	 * Return a map containing all parameters with the given prefix.
	 * Maps single values to String and multiple values to String array.
	 * <p>For example, with a prefix of "spring_", "spring_param1" and
	 * "spring_param2" result in a Map with "param1" and "param2" as keys.
	 * <p>Similar to Servlet 2.3's <code>ServletRequest.getParameterMap</code>,
	 * but more flexible and compatible with Servlet 2.2.
	 * @param request HTTP request in which to look for parameters
	 * @param prefix the beginning of parameter names
	 * (if this is null or the empty string, all parameters will match)
	 * @return map containing request parameters <b>without the prefix</b>,
	 * containing either a String or a String array as values
	 */
	public static Map getParametersStartingWith(HttpServletRequest request, String prefix) 
	{
		if (prefix == null)
		{
			prefix = "";
		}
		Map result = new TreeMap();

		Enumeration paramNames = request.getParameterNames();
		while (paramNames != null && paramNames.hasMoreElements()) 
		{
			String paramName = (String) paramNames.nextElement();
			if ("".equals(prefix) || paramName.startsWith(prefix)) 
			{
				String unprefixed = paramName.substring(prefix.length());
				String[] values = request.getParameterValues(paramName);
				if (values == null) 
				{
					// do nothing, no values found at all
				}
				else if (values.length > 1) 
				{
					result.put(unprefixed, values);
				}
				else 
				{
					result.put(unprefixed, values[0]);
				}
			}
		}
		return result;
	}	
	
	
}
