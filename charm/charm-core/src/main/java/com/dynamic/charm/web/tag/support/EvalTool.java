package com.dynamic.charm.web.tag.support;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.Tag;

import org.apache.taglibs.standard.lang.support.ExpressionEvaluatorManager;

public class EvalTool
{

	private PageContext context;
	private Tag tag;

	public EvalTool(Tag tag, PageContext context)
	{
		this.tag = tag;
		this.context = context;
	}

	private Object eval(String propertyName, String expression, Class intendedClass) throws JspException
	{
		if (propertyName != null && expression != null)
		{
			return ExpressionEvaluatorManager.evaluate(propertyName, expression, intendedClass, this.tag, this.context);
		}
		else
		{
			return null;
		}
	}

	public Object evaluateAsObject(String propertyName, String expression) throws JspException
	{
		return eval(propertyName, expression, Object.class);
	}

	public String evaluateAsString(String propertyName, String expression, String defaultValue) throws JspException
	{
		String result = (String) eval(propertyName, expression, String.class);
		if (result == null)
		{
			result = defaultValue;
		}
		return result;
	}

	
	public String evaluateAsString(String propertyName, String expression) throws JspException
	{
		return (String) eval(propertyName, expression, String.class);
	}
	
	public boolean evaluateAsBoolean(String propertyName, String expression, boolean defaultValue) throws JspException
	{
		Boolean evaluated = (Boolean) eval(propertyName, expression, Boolean.class);
		if (evaluated != null)
		{
			return evaluated.booleanValue();
		}
		else
		{
			return defaultValue;
		}
	}
	
	public long evaluateAsLong(String propertyName, String expression) throws JspException
	{
		Long evaluated = (Long) eval(propertyName, expression, Long.class);
		if (evaluated != null)
		{
			return evaluated.longValue();
		}
		else
		{
			return 0L;
		}
	}
	
	public int evaluateAsInteger(String propertyName, String expression) throws JspException
	{
		Integer evaluated = (Integer) eval(propertyName, expression, Integer.class);
		if (evaluated != null)
		{
			return evaluated.intValue();
		}
		else
		{
			return 0;
		}
	}

}
