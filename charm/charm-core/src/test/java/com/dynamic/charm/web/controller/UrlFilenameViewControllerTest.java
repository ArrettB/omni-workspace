package com.dynamic.charm.web.controller;

import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.mock.web.MockServletContext;

import junit.framework.TestCase;


public class UrlFilenameViewControllerTest extends TestCase
{
	
	private UrlFilenameViewController controller;
	private MockHttpServletResponse response;
	private MockServletContext context;
	
	protected void setUp() throws Exception
	{
		super.setUp();
		this.controller = new UrlFilenameViewController();
		this.response = new MockHttpServletResponse();
		this.context = new MockServletContext();
	}
	
	
	public void testController()
	{
		MockHttpServletRequest request = new MockHttpServletRequest();
		request.setRequestURI("context/foo.html");
		request.setContextPath("context");
		assertEquals("foo", controller.handleRequest(request, response).getViewName());

		request = new MockHttpServletRequest();
		request.setRequestURI("context/foo.html?a=b");
		request.setContextPath("context");
		assertEquals("foo", controller.handleRequest(request, response).getViewName());
		
		request = new MockHttpServletRequest();
		request.setRequestURI("context/foo/bar.html?a=b");
		request.setContextPath("context");
		assertEquals("foo/bar", controller.handleRequest(request, response).getViewName());
		
	}
}
