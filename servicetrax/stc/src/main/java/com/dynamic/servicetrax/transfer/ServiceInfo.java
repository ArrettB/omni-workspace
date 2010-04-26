package com.dynamic.servicetrax.transfer;

public class ServiceInfo
{
	private String serviceId;
	private String serviceNo;
		
	
	public ServiceInfo(String serviceId, String serviceNo)
	{
		super();
		this.serviceId = serviceId;
		this.serviceNo = serviceNo;
	}
	
	public String getServiceId()
	{
		return serviceId;
	}
	public void setServiceId(String serviceId)
	{
		this.serviceId = serviceId;
	}
	public String getServiceNo()
	{
		return serviceNo;
	}
	public void setServiceNo(String serviceNo)
	{
		this.serviceNo = serviceNo;
	}
}
