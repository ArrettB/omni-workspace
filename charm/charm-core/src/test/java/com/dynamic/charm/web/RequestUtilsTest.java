package com.dynamic.charm.web;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import junit.framework.TestCase;

import org.springframework.mock.web.MockHttpServletRequest;

import com.dynamic.charm.date.DateUtils;
import com.dynamic.charm.exception.ParameterMissingException;
import com.dynamic.charm.exception.ParameterParseException;


public class RequestUtilsTest extends TestCase
{

//	public void testRejectMethod() throws ServletRequestBindingException
//	{
//		String methodGet = "GET";
//		String methodPost = "POST";
//
//		MockHttpServletRequest request = new MockHttpServletRequest();
//		request.setMethod(methodPost);
//
//		try
//		{
//			RequestUtils.rejectRequestMethod(request, methodGet);
//		}
//		catch (ServletException ex)
//		{
//			fail("Shouldn't have thrown ServletException");
//		}
//		try
//		{
//			RequestUtils.rejectRequestMethod(request, methodPost);
//			fail("Should have thrown ServletException");
//		}
//		catch (ServletException ex)
//		{
//		}
//	}

	public void testIntParameter() throws ParameterParseException, ParameterMissingException
	{
		MockHttpServletRequest request = new MockHttpServletRequest();
		request.addParameter("param1", "5");
		request.addParameter("param2", "e");
		request.addParameter("paramEmpty", "");

		assertEquals(RequestUtils.getIntegerParameter(request, "param1"), new Integer(5));
		assertEquals(RequestUtils.getIntegerParameter(request, "param1", 6), new Integer(5));
		assertEquals(RequestUtils.getRequiredIntegerParameter(request, "param1"),  new Integer(5));

		try
		{
			RequestUtils.getRequiredIntegerParameter(request, "param2");
			fail("Should have thrown ParameterParseException");
		}
		catch (ParameterParseException ex)
		{
			// expected
		}

		assertEquals(RequestUtils.getIntegerParameter(request, "param3"), null);
		assertEquals(RequestUtils.getIntegerParameter(request, "param3", 6), new Integer(6));
		try
		{
			RequestUtils.getRequiredIntegerParameter(request, "param3");
			fail("Should have thrown ServletRequestBindingException");
		}
		catch (ParameterMissingException ex)
		{
			// expected
		}

		try
		{
			RequestUtils.getRequiredIntegerParameter(request, "paramEmpty");
			fail("Should have thrown ParameterMissingException");
		}
		catch (ParameterMissingException ex)
		{
			// expected
		}
	}

//	public void testIntParameters() throws ServletRequestBindingException
//	{
//		MockHttpServletRequest request = new MockHttpServletRequest();
//		request.addParameter("param", new String[] { "1", "2", "3" });
//
//		request.addParameter("param2", "1");
//		request.addParameter("param2", "2");
//		request.addParameter("param2", "bogus");
//
//		int[] array = new int[] { 1, 2, 3 };
//		int[] values = RequestUtils.getRequiredIntParameters(request, "param");
//		assertEquals(3, values.length);
//		for (int i = 0; i < array.length; i++)
//		{
//			assertEquals(array[i], values[i]);
//		}
//
//		try
//		{
//			RequestUtils.getRequiredIntParameters(request, "param2");
//			fail("Should have thrown ServletRequestBindingException");
//		}
//		catch (ServletRequestBindingException ex)
//		{
//			// expected
//		}
//
//	}

	public void testLongParameter() throws ParameterParseException, ParameterMissingException
	{
		MockHttpServletRequest request = new MockHttpServletRequest();
		request.addParameter("param1", "5");
		request.addParameter("param2", "e");
		request.addParameter("paramEmpty", "");

		assertEquals(RequestUtils.getLongParameter(request, "param1"), new Long(5));
		assertEquals(RequestUtils.getLongParameter(request, "param1", 6), new Long(5));
		assertEquals(RequestUtils.getRequiredLongParameter(request, "param1"),  new Long(5));

		try
		{
			RequestUtils.getRequiredLongParameter(request, "param2");
			fail("Should have thrown ParameterParseException");
		}
		catch (ParameterParseException ex)
		{
			// expected
		}

		assertEquals(RequestUtils.getLongParameter(request, "param3"), null);
		assertEquals(RequestUtils.getLongParameter(request, "param3", 6), new Long(6));
		try
		{
			RequestUtils.getRequiredLongParameter(request, "param3");
			fail("Should have thrown ServletRequestBindingException");
		}
		catch (ParameterMissingException ex)
		{
			// expected
		}

		try
		{
			RequestUtils.getRequiredLongParameter(request, "paramEmpty");
			fail("Should have thrown ParameterMissingException");
		}
		catch (ParameterMissingException ex)
		{
			// expected
		}
	}


//	public void testLongParameters() throws ServletRequestBindingException
//	{
//		MockHttpServletRequest request = new MockHttpServletRequest();
//		request.addParameter("param", new String[] { "1", "2", "3" });
//
//		request.addParameter("param2", "1");
//		request.addParameter("param2", "2");
//		request.addParameter("param2", "bogus");
//
//		long[] array = new long[] { 1L, 2L, 3L };
//		long[] values = RequestUtils.getRequiredLongParameters(request, "param");
//		assertEquals(3, values.length);
//		for (int i = 0; i < array.length; i++)
//		{
//			assertEquals(array[i], values[i]);
//		}
//
//		try
//		{
//			RequestUtils.getRequiredLongParameters(request, "param2");
//			fail("Should have thrown ServletRequestBindingException");
//		}
//		catch (ServletRequestBindingException ex)
//		{
//			// expected
//		}
//	}

	public void testFloatParameter() throws ParameterParseException, ParameterMissingException
	{
		MockHttpServletRequest request = new MockHttpServletRequest();
		request.addParameter("param1", "5.5");
		request.addParameter("param2", "e");
		request.addParameter("paramEmpty", "");

		assertEquals(RequestUtils.getFloatParameter(request, "param1"), new Float(5.5));
		assertEquals(RequestUtils.getFloatParameter(request, "param1", 6.5f), new Float(5.5));
		assertEquals(RequestUtils.getRequiredFloatParameter(request, "param1"),  new Float(5.5));

		try
		{
			RequestUtils.getRequiredFloatParameter(request, "param2");
			fail("Should have thrown ParameterParseException");
		}
		catch (ParameterParseException ex)
		{
			// expected
		}

		assertEquals(RequestUtils.getFloatParameter(request, "param3"), null);
		assertEquals(RequestUtils.getFloatParameter(request, "param3", 6.5f), new Float(6.5));
		try
		{
			RequestUtils.getRequiredFloatParameter(request, "param3");
			fail("Should have thrown ServletRequestBindingException");
		}
		catch (ParameterMissingException ex)
		{
			// expected
		}

		try
		{
			RequestUtils.getRequiredFloatParameter(request, "paramEmpty");
			fail("Should have thrown ParameterMissingException");
		}
		catch (ParameterMissingException ex)
		{
			// expected
		}
	}

//	public void testFloatParameters() throws ServletRequestBindingException
//	{
//		MockHttpServletRequest request = new MockHttpServletRequest();
//		request.addParameter("param", new String[] { "1.5", "2.5", "3" });
//
//		request.addParameter("param2", "1.5");
//		request.addParameter("param2", "2");
//		request.addParameter("param2", "bogus");
//
//		float[] array = new float[] { 1.5F, 2.5F, 3 };
//		float[] values = RequestUtils.getRequiredFloatParameters(request, "param");
//		assertEquals(3, values.length);
//		for (int i = 0; i < array.length; i++)
//		{
//			assertEquals(array[i], values[i], 0);
//		}
//
//		try
//		{
//			RequestUtils.getRequiredFloatParameters(request, "param2");
//			fail("Should have thrown ServletRequestBindingException");
//		}
//		catch (ServletRequestBindingException ex)
//		{
//			// expected
//		}
//	}

	public void testDoubleParameter() throws ParameterParseException, ParameterMissingException
	{
		MockHttpServletRequest request = new MockHttpServletRequest();
		request.addParameter("param1", "5.5");
		request.addParameter("param2", "e");
		request.addParameter("paramEmpty", "");

		assertEquals(RequestUtils.getDoubleParameter(request, "param1"), new Double(5.5));
		assertEquals(RequestUtils.getDoubleParameter(request, "param1", 6.5d), new Double(5.5));
		assertEquals(RequestUtils.getRequiredDoubleParameter(request, "param1"),  new Double(5.5));

		try
		{
			RequestUtils.getRequiredDoubleParameter(request, "param2");
			fail("Should have thrown ParameterParseException");
		}
		catch (ParameterParseException ex)
		{
			// expected
		}

		assertEquals(RequestUtils.getDoubleParameter(request, "param3"), null);
		assertEquals(RequestUtils.getDoubleParameter(request, "param3", 6.5d), new Double(6.5));
		try
		{
			RequestUtils.getRequiredDoubleParameter(request, "param3");
			fail("Should have thrown ServletRequestBindingException");
		}
		catch (ParameterMissingException ex)
		{
			// expected
		}

		try
		{
			RequestUtils.getRequiredDoubleParameter(request, "paramEmpty");
			fail("Should have thrown ParameterMissingException");
		}
		catch (ParameterMissingException ex)
		{
			// expected
		}
	}

//	public void testDoubleParameters() throws ServletRequestBindingException
//	{
//		MockHttpServletRequest request = new MockHttpServletRequest();
//		request.addParameter("param", new String[] { "1.5", "2.5", "3" });
//
//		request.addParameter("param2", "1.5");
//		request.addParameter("param2", "2");
//		request.addParameter("param2", "bogus");
//
//		double[] array = new double[] { 1.5, 2.5, 3 };
//		double[] values = RequestUtils.getRequiredDoubleParameters(request, "param");
//		assertEquals(3, values.length);
//		for (int i = 0; i < array.length; i++)
//		{
//			assertEquals(array[i], values[i], 0);
//		}
//
//		try
//		{
//			RequestUtils.getRequiredDoubleParameters(request, "param2");
//			fail("Should have thrown ServletRequestBindingException");
//		}
//		catch (ServletRequestBindingException ex)
//		{
//			// expected
//		}
//	}

	public void testBooleanParameter() throws ParameterParseException, ParameterMissingException
	{
		MockHttpServletRequest request = new MockHttpServletRequest();
		request.addParameter("param1", "true");
		request.addParameter("param2", "e");
		request.addParameter("param4", "yes");
		request.addParameter("param5", "1");
		request.addParameter("paramEmpty", "");

		assertTrue(RequestUtils.getBooleanParameter(request, "param1").booleanValue());
		assertTrue(RequestUtils.getBooleanParameter(request, "param1", false).booleanValue());
		assertTrue(RequestUtils.getRequiredBooleanParameter(request, "param1").booleanValue());

		assertFalse(RequestUtils.getBooleanParameter(request, "param2", true).booleanValue());
		assertFalse(RequestUtils.getRequiredBooleanParameter(request, "param2").booleanValue());

		assertNull(RequestUtils.getBooleanParameter(request, "param3"));
		assertTrue(RequestUtils.getBooleanParameter(request, "param3", true).booleanValue());
		try
		{
			RequestUtils.getRequiredBooleanParameter(request, "param3");
			fail("Should have thrown ParameterMissingException");
		}
		catch (ParameterMissingException  ex)
		{
			// expected
		}

		assertTrue(RequestUtils.getBooleanParameter(request, "param4", false).booleanValue());
		assertTrue(RequestUtils.getRequiredBooleanParameter(request, "param4").booleanValue());

		assertTrue(RequestUtils.getBooleanParameter(request, "param5", false).booleanValue());
		assertTrue(RequestUtils.getRequiredBooleanParameter(request, "param5").booleanValue());
		try
		{
			RequestUtils.getRequiredBooleanParameter(request, "paramEmpty");
			fail("Should have thrown ParameterMissingException");
		}
		catch (ParameterMissingException ex)
		{
			// expected
		}
	}

//	public void testBooleanParameters() throws ServletRequestBindingException
//	{
//		MockHttpServletRequest request = new MockHttpServletRequest();
//		request.addParameter("param", new String[] { "true", "yes", "off", "1", "bogus" });
//
//		request.addParameter("param2", "false");
//		request.addParameter("param2", "true");
//		request.addParameter("param2", "");
//
//		boolean[] array = new boolean[] { true, true, false, true, false };
//		boolean[] values = RequestUtils.getRequiredBooleanParameters(request, "param");
//		assertEquals(5, values.length);
//		for (int i = 0; i < array.length; i++)
//		{
//			assertEquals(array[i], values[i]);
//		}
//
//		try
//		{
//			RequestUtils.getRequiredBooleanParameters(request, "param2");
//			fail("Should have thrown ServletRequestBindingException");
//		}
//		catch (ServletRequestBindingException ex)
//		{
//			// expected
//		}
//	}

	public void testStringParameter() throws ParameterMissingException
	{
		MockHttpServletRequest request = new MockHttpServletRequest();
		request.addParameter("param1", "str");
		request.addParameter("paramEmpty", "");

		assertEquals(RequestUtils.getStringParameter(request, "param1"), "str");
		assertEquals(RequestUtils.getStringParameter(request, "param1", "string"), "str");
		assertEquals(RequestUtils.getRequiredStringParameter(request, "param1"), "str");

		assertEquals(RequestUtils.getStringParameter(request, "param3"), null);
		assertEquals(RequestUtils.getStringParameter(request, "param3", "string"), "string");
		try
		{
			RequestUtils.getRequiredStringParameter(request, "param3");
			fail("Should have thrown param");
		}
		catch (ParameterMissingException ex)
		{
			// expected
		}

		try
		{
			RequestUtils.getRequiredStringParameter(request, "paramEmpty");
			fail("Should have thrown ParameterMissingException");
		}
		catch (ParameterMissingException ex)
		{
			// expected
		}
		try
		{
			RequestUtils.getRequiredStringParameter(request, "paramEmpty");
			fail("Should have thrown ParameterMissingException");
		}
		catch (ParameterMissingException ex)
		{
			// expected
		}
	}
	
	public void testDoubleParameterPattern() throws ParameterParseException, ParameterMissingException
	{
		MockHttpServletRequest request = new MockHttpServletRequest();
		request.addParameter("paramPos", "5.5");
		request.addParameter("paramNeg", "(5.5)");
		request.addParameter("param2", "e");
		request.addParameter("paramEmpty", "");

		assertEquals(RequestUtils.getDoubleParameter(request, "paramPos", "#.#;(#.#)"), new Double(5.5));
		assertEquals(RequestUtils.getDoubleParameter(request, "paramNeg", "#.#;(#.#)"), new Double(-5.5));
		assertEquals(RequestUtils.getDoubleParameter(request, "paramPos","#.#;(#.#)", 6.5d), new Double(5.5));
		assertEquals(RequestUtils.getRequiredDoubleParameter(request, "paramPos"),  new Double(5.5));

		try
		{
			RequestUtils.getRequiredDoubleParameter(request, "param2", "#.#;(#.#)");
			fail("Should have thrown ParameterParseException");
		}
		catch (ParameterParseException ex)
		{
			// expected
		}

		assertEquals(RequestUtils.getDoubleParameter(request, "param3", "#.#;(#.#)"), null);
		assertEquals(RequestUtils.getDoubleParameter(request, "param3", "#.#;(#.#)", 6.5d), new Double(6.5));
		try
		{
			RequestUtils.getRequiredDoubleParameter(request, "param3", "#.#;(#.#)");
			fail("Should have thrown ServletRequestBindingException");
		}
		catch (ParameterMissingException ex)
		{
			// expected
		}

		try
		{
			RequestUtils.getRequiredDoubleParameter(request, "paramEmpty", "#.#;(#.#)");
			fail("Should have thrown ParameterMissingException");
		}
		catch (ParameterMissingException ex)
		{
			// expected
		}
	}
	
	public void testMoneyParameter() throws ParameterParseException, ParameterMissingException
	{
		MockHttpServletRequest request = new MockHttpServletRequest();
		request.addParameter("param1", "$5.50");
		request.addParameter("param2", "e");
		request.addParameter("paramEmpty", "");
		request.addPreferredLocale(Locale.getDefault());
			
		assertEquals(RequestUtils.getMoneyParameter(request, "param1"), new Double(5.5));
		assertEquals(RequestUtils.getMoneyParameter(request, "param1", 6.5d), new Double(5.5));
		assertEquals(RequestUtils.getRequiredMoneyParameter(request, "param1"),  new Double(5.5));

		try
		{
			RequestUtils.getRequiredDoubleParameter(request, "param2");
			fail("Should have thrown ParameterParseException");
		}
		catch (ParameterParseException ex)
		{
			// expected
		}

		assertNull(RequestUtils.getDoubleParameter(request, "param3"));
		assertEquals(RequestUtils.getDoubleParameter(request, "param3", 6.5d), new Double(6.5));
		try
		{
			RequestUtils.getRequiredMoneyParameter(request, "param3");
			fail("Should have thrown ParameterMissingException");
		}
		catch (ParameterMissingException ex)
		{
			// expected
		}

		try
		{
			RequestUtils.getRequiredMoneyParameter(request, "paramEmpty");
			fail("Should have thrown ParameterMissingException");
		}
		catch (ParameterMissingException ex)
		{
			// expected
		}
	}
	
	public void testDateParameter() throws ParameterParseException, ParameterMissingException
	{
		String datePattern = "MM/dd/yyyy";
		SimpleDateFormat format = new SimpleDateFormat(datePattern);
		Date today = new Date();
		today = DateUtils.truncateTime(today);
		
		Date yesterday = new Date();
		yesterday.setTime(yesterday.getTime() - DateUtils.MILLIS_PER_DAY);
		
		MockHttpServletRequest request = new MockHttpServletRequest();
		request.addParameter("param1", format.format(today));
		request.addParameter("param2", "e");
		request.addParameter("paramEmpty", "");
		request.addPreferredLocale(Locale.getDefault());
			
		assertEquals(RequestUtils.getDateParameter(request, "param1", datePattern), today);
		assertEquals(RequestUtils.getDateParameter(request, "param1", datePattern, yesterday), today);
		assertEquals(RequestUtils.getRequiredDateParameter(request, "param1", datePattern),  today);

		try
		{
			RequestUtils.getRequiredDateParameter(request, "param2", datePattern);
			fail("Should have thrown ParameterParseException");
		}
		catch (ParameterParseException ex)
		{
			// expected
		}

		assertNull(RequestUtils.getDateParameter(request, "param3", datePattern));
		assertEquals(RequestUtils.getDateParameter(request, "param3", datePattern, today), today);
		try
		{
			RequestUtils.getRequiredDateParameter(request, "param3", datePattern);
			fail("Should have thrown ParameterMissingException");
		}
		catch (ParameterMissingException ex)
		{
			// expected
		}

		try
		{
			RequestUtils.getRequiredMoneyParameter(request, "paramEmpty");
			fail("Should have thrown ParameterMissingException");
		}
		catch (ParameterMissingException ex)
		{
			// expected
		}
	}	
	
	
}
