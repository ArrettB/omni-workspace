package com.dynamic.charm.web.tag;

import junit.framework.TestCase;

import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockPageContext;
import org.springframework.mock.web.MockServletContext;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.servlet.DispatcherServlet;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.SimpleWebApplicationContext;
import org.springframework.web.servlet.ThemeResolver;

import org.springframework.web.servlet.i18n.AcceptHeaderLocaleResolver;
import org.springframework.web.servlet.theme.FixedThemeResolver;

public abstract class AbstractTagTest extends TestCase
{

	protected MockPageContext createPageContext()
	{
		MockServletContext sc = new MockServletContext();
		SimpleWebApplicationContext wac = new SimpleWebApplicationContext();
		wac.setServletContext(sc);
		wac.setNamespace("test");
		wac.refresh();

		MockHttpServletRequest request = new MockHttpServletRequest(sc);
		if (inDispatcherServlet())
		{
			request.setAttribute(DispatcherServlet.WEB_APPLICATION_CONTEXT_ATTRIBUTE, wac);
			LocaleResolver lr = new AcceptHeaderLocaleResolver();
			request.setAttribute(DispatcherServlet.LOCALE_RESOLVER_ATTRIBUTE, lr);
			ThemeResolver tr = new FixedThemeResolver();
			request.setAttribute(DispatcherServlet.THEME_RESOLVER_ATTRIBUTE, tr);
		}
		else
		{
			sc.setAttribute(WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE, wac);
		}

		return new MockPageContext(sc, request);
	}

	protected boolean inDispatcherServlet()
	{
		return true;
	}
	
}
