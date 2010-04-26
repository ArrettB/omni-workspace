package com.dynamic.servicetrax.tc;

import com.dynamic.charm.web.builder.HTMLElement;

public class ResourceInfo
{
	private String resourceName;
	private String employeeNumber;
	private String resourceId;
	
	
	public String getResourceId()
	{
		return resourceId;
	}
	
	public void setResourceId(String resourceId)
	{
		this.resourceId = resourceId;
	}
	
	public String getEmployeeNumber()
	{
		return employeeNumber;
	}
	
	public void setEmployeeNumber(String employeeNumber)
	{
		this.employeeNumber = employeeNumber;
	}
	
	public String getResourceName()
	{
		return resourceName;
	}

	public void setResourceName(String resourceName)
	{
		this.resourceName = resourceName;
	}
		
	private String toHtml()
	{
		HTMLElement root = HTMLElement.createRootElement();
		HTMLElement major = root.createElement("div");
		major.setText(resourceName);
		major.css("autoMajor");
		HTMLElement minor = root.createElement("div");
		minor.setText(employeeNumber);
		minor.css("autoMinor");
		
		return root.evaluateChildren();
	}

	public String getHtml()
	{
		return toHtml();
	}

	public String toString()
	{
		return resourceId+ "-" + resourceName + "-" + employeeNumber;
	}
	
}
