package com.dynamic.servicetrax.orm;

// Generated Apr 27, 2006 9:55:28 AM by Hibernate Tools 3.1.0.beta5

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

/**
 * Job generated by hbm2java
 */
public class Job implements java.io.Serializable
{

	// Fields    

	private Long jobId;

	private User userByBillingUserId;

	private Resource resource;

	private Project project;

	private Lookup lookupByJobStatusTypeId;

	private Customer customer;
	
	private Customer endUser;

	private User userByModifiedBy;

	private User userByCreatedBy;

	private Lookup lookupByJobTypeId;

	private Long jobNo;

	private String jobName;

	private String extPriceLevelId;

	private String watchFlag;

	private String viewScheduleFlag;

	private Date dateCreated;

	private Date dateModified;

	private String spreadsheetBillingFlag;

	private Set services = new HashSet(0);

	private Set jobItemRates = new HashSet(0);

	private Set resourceEstimates = new HashSet(0);

	private Set jobDistributions = new HashSet(0);

	private Set schResources = new HashSet(0);

	private Set trackings = new HashSet(0);

	private Set invoices = new HashSet(0);

	// Constructors

	/** default constructor */
	public Job()
	{
	}

	/** minimal constructor */
	public Job(Lookup lookupByJobStatusTypeId, Customer customer, User userByCreatedBy, Lookup lookupByJobTypeId, Date dateCreated, String spreadsheetBillingFlag)
	{
		this.lookupByJobStatusTypeId = lookupByJobStatusTypeId;
		this.customer = customer;
		this.userByCreatedBy = userByCreatedBy;
		this.lookupByJobTypeId = lookupByJobTypeId;
		this.dateCreated = dateCreated;
		this.spreadsheetBillingFlag = spreadsheetBillingFlag;
	}

	/** full constructor */
	public Job(User userByBillingUserId, Resource resource, Project project, Lookup lookupByJobStatusTypeId, Customer customer, Customer endUser, User userByModifiedBy, User userByCreatedBy, Lookup lookupByJobTypeId,
			Long jobNo, String jobName, String extPriceLevelId, String watchFlag, String viewScheduleFlag, Date dateCreated, Date dateModified, String spreadsheetBillingFlag, Set services, Set jobItemRates,
			Set resourceEstimates, Set jobDistributions, Set schResources, Set trackings, Set invoices)
	{
		this.userByBillingUserId = userByBillingUserId;
		this.resource = resource;
		this.project = project;
		this.lookupByJobStatusTypeId = lookupByJobStatusTypeId;
		this.customer = customer;
		this.endUser = endUser;
		this.userByModifiedBy = userByModifiedBy;
		this.userByCreatedBy = userByCreatedBy;
		this.lookupByJobTypeId = lookupByJobTypeId;
		this.jobNo = jobNo;
		this.jobName = jobName;
		this.extPriceLevelId = extPriceLevelId;
		this.watchFlag = watchFlag;
		this.viewScheduleFlag = viewScheduleFlag;
		this.dateCreated = dateCreated;
		this.dateModified = dateModified;
		this.spreadsheetBillingFlag = spreadsheetBillingFlag;
		this.services = services;
		this.jobItemRates = jobItemRates;
		this.resourceEstimates = resourceEstimates;
		this.jobDistributions = jobDistributions;
		this.schResources = schResources;
		this.trackings = trackings;
		this.invoices = invoices;
	}

	// Property accessors
	public Long getJobId()
	{
		return this.jobId;
	}

	public void setJobId(Long jobId)
	{
		this.jobId = jobId;
	}

	public User getUserByBillingUserId()
	{
		return this.userByBillingUserId;
	}

	public void setUserByBillingUserId(User userByBillingUserId)
	{
		this.userByBillingUserId = userByBillingUserId;
	}

	public Resource getResource()
	{
		return this.resource;
	}

	public void setResource(Resource resource)
	{
		this.resource = resource;
	}

	public Project getProject()
	{
		return this.project;
	}

	public void setProject(Project project)
	{
		this.project = project;
	}

	public Lookup getLookupByJobStatusTypeId()
	{
		return this.lookupByJobStatusTypeId;
	}

	public void setLookupByJobStatusTypeId(Lookup lookupByJobStatusTypeId)
	{
		this.lookupByJobStatusTypeId = lookupByJobStatusTypeId;
	}

	public Customer getCustomer()
	{
		return this.customer;
	}

	public void setCustomer(Customer customer)
	{
		this.customer = customer;
	}

	public User getUserByModifiedBy()
	{
		return this.userByModifiedBy;
	}

	public void setUserByModifiedBy(User userByModifiedBy)
	{
		this.userByModifiedBy = userByModifiedBy;
	}

	public User getUserByCreatedBy()
	{
		return this.userByCreatedBy;
	}

	public void setUserByCreatedBy(User userByCreatedBy)
	{
		this.userByCreatedBy = userByCreatedBy;
	}

	public Lookup getLookupByJobTypeId()
	{
		return this.lookupByJobTypeId;
	}

	public void setLookupByJobTypeId(Lookup lookupByJobTypeId)
	{
		this.lookupByJobTypeId = lookupByJobTypeId;
	}

	public Long getJobNo()
	{
		return this.jobNo;
	}

	public void setJobNo(Long jobNo)
	{
		this.jobNo = jobNo;
	}

	public String getJobName()
	{
		return this.jobName;
	}

	public void setJobName(String jobName)
	{
		this.jobName = jobName;
	}

	public String getExtPriceLevelId()
	{
		return this.extPriceLevelId;
	}

	public void setExtPriceLevelId(String extPriceLevelId)
	{
		this.extPriceLevelId = extPriceLevelId;
	}

	public String getWatchFlag()
	{
		return this.watchFlag;
	}

	public void setWatchFlag(String watchFlag)
	{
		this.watchFlag = watchFlag;
	}

	public String getViewScheduleFlag()
	{
		return this.viewScheduleFlag;
	}

	public void setViewScheduleFlag(String viewScheduleFlag)
	{
		this.viewScheduleFlag = viewScheduleFlag;
	}

	public Date getDateCreated()
	{
		return this.dateCreated;
	}

	public void setDateCreated(Date dateCreated)
	{
		this.dateCreated = dateCreated;
	}

	public Date getDateModified()
	{
		return this.dateModified;
	}

	public void setDateModified(Date dateModified)
	{
		this.dateModified = dateModified;
	}

	public String getSpreadsheetBillingFlag()
	{
		return this.spreadsheetBillingFlag;
	}

	public void setSpreadsheetBillingFlag(String spreadsheetBillingFlag)
	{
		this.spreadsheetBillingFlag = spreadsheetBillingFlag;
	}

	public Set getServices()
	{
		return this.services;
	}

	public void setServices(Set services)
	{
		this.services = services;
	}

	public Set getJobItemRates()
	{
		return this.jobItemRates;
	}

	public void setJobItemRates(Set jobItemRates)
	{
		this.jobItemRates = jobItemRates;
	}

	public Set getResourceEstimates()
	{
		return this.resourceEstimates;
	}

	public void setResourceEstimates(Set resourceEstimates)
	{
		this.resourceEstimates = resourceEstimates;
	}

	public Set getJobDistributions()
	{
		return this.jobDistributions;
	}

	public void setJobDistributions(Set jobDistributions)
	{
		this.jobDistributions = jobDistributions;
	}

	public Set getSchResources()
	{
		return this.schResources;
	}

	public void setSchResources(Set schResources)
	{
		this.schResources = schResources;
	}

	public Set getTrackings()
	{
		return this.trackings;
	}

	public void setTrackings(Set trackings)
	{
		this.trackings = trackings;
	}

	public Set getInvoices()
	{
		return this.invoices;
	}

	public void setInvoices(Set invoices)
	{
		this.invoices = invoices;
	}

	public Customer getEndUser() {
		return endUser;
	}

	public void setEndUser(Customer endUser) {
		this.endUser = endUser;
	}

}
