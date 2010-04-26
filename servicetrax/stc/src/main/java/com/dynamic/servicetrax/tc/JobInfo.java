package com.dynamic.servicetrax.tc;

import com.dynamic.charm.web.builder.HTMLElement;
import com.dynamic.servicetrax.orm.Job;

public class JobInfo
{
	private Long jobId;
	private Long jobNo;
	private String jobName;
	private String endUserName;
	
	public JobInfo(Long jobId, Long jobNo, String jobName, String endUserName)
	{
		super();
		this.jobId = jobId;
		this.jobNo = jobNo;
		this.jobName = jobName;
		this.endUserName = endUserName;
	}
	
	public JobInfo(Job job)
	{
		super();
		this.jobId = job.getJobId();
		this.jobNo = job.getJobNo();
		this.jobName = job.getJobName();
		if (job.getEndUser() == null) {
			this.endUserName = job.getCustomer().getCustomerName();
		} else {
			this.endUserName = job.getEndUser().getCustomerName();
		}
	}
	
	public String getEndUserName() {
		return endUserName;
	}

	public void setEndUserName(String endUserName) {
		this.endUserName = endUserName;
	}	

	public Long getJobId()
	{
		return jobId;
	}
	public void setJobId(Long jobId)
	{
		this.jobId = jobId;
	}
	public String getJobName()
	{
		return jobName;
	}
	public void setJobName(String jobName)
	{
		this.jobName = jobName;
	}
	public Long getJobNo()
	{
		return jobNo;
	}
	public void setJobNo(Long jobNo)
	{
		this.jobNo = jobNo;
	}
	
	private String toHtml()
	{
		HTMLElement root = HTMLElement.createRootElement();
		HTMLElement major = root.createElement("span");
		major.setText(jobNo.toString());
		major.css("autoMajor");
		HTMLElement secondary = root.createElement("span");
		secondary.setText(endUserName);
		secondary.css("autoSecondary");
		HTMLElement minor = root.createElement("div");
		minor.setText(jobName);
		minor.css("autoMinor");
		
		return root.evaluateChildren();
	}

	public String getHtml()
	{
		return toHtml();
	}

}
