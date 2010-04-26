package com.dynamic.servicetrax.support;

import org.apache.commons.lang.builder.ToStringBuilder;

public class LoginCrediantials
{
	private int userId;
	private int organizationId;
	private String paycodeTable;
	
	public String getPaycodeTable()
	{
		return paycodeTable;
	}

	public void setPaycodeTable(String paycodeTable)
	{
		this.paycodeTable = paycodeTable;
	}

	public int getOrganizationId()
	{
		return organizationId;
	}
	
	public void setOrganizationId(int organizationId)
	{
		this.organizationId = organizationId;
	}
	
	public int getUserId()
	{
		return userId;
	}
	
	public void setUserId(int userId)
	{
		this.userId = userId;
	}
	
	@Override
	public String toString()
	{
		return ToStringBuilder.reflectionToString(this);
	}
}
