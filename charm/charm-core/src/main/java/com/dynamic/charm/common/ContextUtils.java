package com.dynamic.charm.common;

import java.util.Map;

import org.springframework.context.ApplicationContext;

public class ContextUtils
{
	public Map getBeansOfTypeUsingAncestors(Class type, ApplicationContext ac)
	{
		ApplicationContext parent = ac.getParent();
		if (parent != null)
		{
			Map parentBeans = getBeansOfTypeUsingAncestors(type, parent);
			parentBeans.putAll(ac.getBeansOfType(type));
			return parentBeans;
		}
		else
		{
			return ac.getBeansOfType(type);
		}
	}
	
	
}
