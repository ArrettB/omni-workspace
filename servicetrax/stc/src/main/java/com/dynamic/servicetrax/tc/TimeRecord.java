package com.dynamic.servicetrax.tc;

import java.util.Date;

import org.apache.log4j.Logger;

import com.dynamic.charm.common.StringUtils;

public class TimeRecord
{
	private final static Logger logger = Logger.getLogger(TimeRecord.class);
	
	private Date date;
	private double qty;
	private String jobId;
	private String jobString;
	private String serviceId;
	private String serviceString;
	private String resourceId;
	private String resourceString;
	private String itemId;
	private String itemString;
	private int id;
	private String paycode;
	private String paycodeString;

	public boolean isPaycodeValid()
	{
		boolean result = true;
		logger.debug("isPaycodeValid");
		if (StringUtils.isNotBlank(itemString) && StringUtils.isNotBlank(paycodeString))
		{
			// check to see if the itemname has a qualifer to it, such as "Installer
			// Time - Reg");
			int index = itemString.lastIndexOf("-");
			if (index > 0)
			{
				String itemQualif = itemString.substring(index + 1).trim();

				// now check the paycodename also for a qualifier
				index = paycodeString.lastIndexOf("-");
				if (index > 0)
				{
					String payCodeQualif = paycodeString.substring(index + 1).trim();
					logger.debug("payCodeQualif = " + payCodeQualif);

					if (!(itemQualif.equalsIgnoreCase(payCodeQualif)))
					{
						result = false;
						logger.warn("Paycode '" + paycodeString + "' not allowed for this item:" + itemString);
					}
				}
				else
				{
					logger.debug("No qualifier on paycode name, allowing paycode");
				}
			}
			else
			{
				logger.debug("No qualifier on item name, allowing paycode");
			}
			
		}
		
		return result;
	}
	
	
	
	public String getPaycode()
	{
		return paycode;
	}
	public void setPaycode(String paycode)
	{
		this.paycode = paycode;
	}
	public String getPaycodeString()
	{
		return paycodeString;
	}
	public void setPaycodeString(String paycodeString)
	{
		this.paycodeString = paycodeString;
	}
	public int getId()
	{
		return id;
	}
	public void setId(int id)
	{
		this.id = id;
	}
	public Date getDate()
	{
		return date;
	}
	public void setDate(Date date)
	{
		this.date = date;
	}
	public String getItemId()
	{
		return itemId;
	}
	public void setItemId(String itemId)
	{
		this.itemId = itemId;
	}
	public String getItemString()
	{
		return itemString;
	}
	public void setItemString(String itemName)
	{
		this.itemString = itemName;
	}
	public String getJobId()
	{
		return jobId;
	}
	public void setJobId(String jobId)
	{
		this.jobId = jobId;
	}
	public String getJobString()
	{
		return jobString;
	}
	public void setJobString(String jobString)
	{
		this.jobString = jobString;
	}
	public double getQty()
	{
		return qty;
	}
	public void setQty(double qty)
	{
		this.qty = qty;
	}
	public String getResourceId()
	{
		return resourceId;
	}
	public void setResourceId(String resourceId)
	{
		this.resourceId = resourceId;
	}
	public String getResourceString()
	{
		return resourceString;
	}
	public void setResourceString(String resourceName)
	{
		this.resourceString = resourceName;
	}
	public String getServiceId()
	{
		return serviceId;
	}
	public void setServiceId(String serviceId)
	{
		this.serviceId = serviceId;
	}
	public String getServiceString()
	{
		return serviceString;
	}
	public void setServiceString(String serviceString)
	{
		this.serviceString = serviceString;
	}
}
