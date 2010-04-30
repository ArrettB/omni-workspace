package com.dynamic.servicetrax.orm;

// Generated Apr 27, 2006 9:55:28 AM by Hibernate Tools 3.1.0.beta5

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

/**
 * Customer generated by hbm2java
 */
public class Customer implements java.io.Serializable
{

	// Fields    

	private Long customerId;

	private Customer customer;

	private Organization organization;

	private String extDealerId;

	private String dealerName;

	private String extCustomerId;

	private String customerName;

	private String activeFlag;

	private Date dateCreated;

	private long createdBy;

	private Date dateModified;

	private Long modifiedBy;

	private Long AMFurniture1ContactId;

	private Long surveyFrequency;

	private Long surveyLastCount;

	private String surveyLocation;

	private String refusalEmailInfo;

	private Set projects = new HashSet(0);

	private Set jobLocations = new HashSet(0);

	private Set jobs = new HashSet(0);

	private Set users = new HashSet(0);

	private Set userApprovers = new HashSet(0);

	private Set contacts = new HashSet(0);

	private Set customers = new HashSet(0);

	private Set invoices = new HashSet(0);

	private Set customCustColumns = new HashSet(0);

	// Constructors

	/** default constructor */
	public Customer()
	{
	}

	/** minimal constructor */
	public Customer(Organization organization, String extDealerId, String customerName, String activeFlag, Date dateCreated, long createdBy)
	{
		this.organization = organization;
		this.extDealerId = extDealerId;
		this.customerName = customerName;
		this.activeFlag = activeFlag;
		this.dateCreated = dateCreated;
		this.createdBy = createdBy;
	}

	/** full constructor */
	public Customer(Customer customer, Organization organization, String extDealerId, String dealerName, String extCustomerId, String customerName, String activeFlag, Date dateCreated,
			long createdBy, Date dateModified, Long modifiedBy, Long AMFurniture1ContactId, Long surveyFrequency, Long surveyLastCount, String surveyLocation, String refusalEmailInfo,
			Set projects, Set jobLocations, Set jobs, Set users, Set userApprovers, Set contacts, Set customers, Set invoices, Set customCustColumns)
	{
		this.customer = customer;
		this.organization = organization;
		this.extDealerId = extDealerId;
		this.dealerName = dealerName;
		this.extCustomerId = extCustomerId;
		this.customerName = customerName;
		this.activeFlag = activeFlag;
		this.dateCreated = dateCreated;
		this.createdBy = createdBy;
		this.dateModified = dateModified;
		this.modifiedBy = modifiedBy;
		this.AMFurniture1ContactId = AMFurniture1ContactId;
		this.surveyFrequency = surveyFrequency;
		this.surveyLastCount = surveyLastCount;
		this.surveyLocation = surveyLocation;
		this.refusalEmailInfo = refusalEmailInfo;
		this.projects = projects;
		this.jobLocations = jobLocations;
		this.jobs = jobs;
		this.users = users;
		this.userApprovers = userApprovers;
		this.contacts = contacts;
		this.customers = customers;
		this.invoices = invoices;
		this.customCustColumns = customCustColumns;
	}

	// Property accessors
	public Long getCustomerId()
	{
		return this.customerId;
	}

	public void setCustomerId(Long customerId)
	{
		this.customerId = customerId;
	}

	public Customer getCustomer()
	{
		return this.customer;
	}

	public void setCustomer(Customer customer)
	{
		this.customer = customer;
	}

	public Organization getOrganization()
	{
		return this.organization;
	}

	public void setOrganization(Organization organization)
	{
		this.organization = organization;
	}

	public String getExtDealerId()
	{
		return this.extDealerId;
	}

	public void setExtDealerId(String extDealerId)
	{
		this.extDealerId = extDealerId;
	}

	public String getDealerName()
	{
		return this.dealerName;
	}

	public void setDealerName(String dealerName)
	{
		this.dealerName = dealerName;
	}

	public String getExtCustomerId()
	{
		return this.extCustomerId;
	}

	public void setExtCustomerId(String extCustomerId)
	{
		this.extCustomerId = extCustomerId;
	}

	public String getCustomerName()
	{
		return this.customerName;
	}

	public void setCustomerName(String customerName)
	{
		this.customerName = customerName;
	}

	public String getActiveFlag()
	{
		return this.activeFlag;
	}

	public void setActiveFlag(String activeFlag)
	{
		this.activeFlag = activeFlag;
	}

	public Date getDateCreated()
	{
		return this.dateCreated;
	}

	public void setDateCreated(Date dateCreated)
	{
		this.dateCreated = dateCreated;
	}

	public long getCreatedBy()
	{
		return this.createdBy;
	}

	public void setCreatedBy(long createdBy)
	{
		this.createdBy = createdBy;
	}

	public Date getDateModified()
	{
		return this.dateModified;
	}

	public void setDateModified(Date dateModified)
	{
		this.dateModified = dateModified;
	}

	public Long getModifiedBy()
	{
		return this.modifiedBy;
	}

	public void setModifiedBy(Long modifiedBy)
	{
		this.modifiedBy = modifiedBy;
	}

	public Long getAMFurniture1ContactId()
	{
		return this.AMFurniture1ContactId;
	}

	public void setAMFurniture1ContactId(Long AMFurniture1ContactId)
	{
		this.AMFurniture1ContactId = AMFurniture1ContactId;
	}

	public Long getSurveyFrequency()
	{
		return this.surveyFrequency;
	}

	public void setSurveyFrequency(Long surveyFrequency)
	{
		this.surveyFrequency = surveyFrequency;
	}

	public Long getSurveyLastCount()
	{
		return this.surveyLastCount;
	}

	public void setSurveyLastCount(Long surveyLastCount)
	{
		this.surveyLastCount = surveyLastCount;
	}

	public String getSurveyLocation()
	{
		return this.surveyLocation;
	}

	public void setSurveyLocation(String surveyLocation)
	{
		this.surveyLocation = surveyLocation;
	}

	public String getRefusalEmailInfo()
	{
		return this.refusalEmailInfo;
	}

	public void setRefusalEmailInfo(String refusalEmailInfo)
	{
		this.refusalEmailInfo = refusalEmailInfo;
	}

	public Set getProjects()
	{
		return this.projects;
	}

	public void setProjects(Set projects)
	{
		this.projects = projects;
	}

	public Set getJobLocations()
	{
		return this.jobLocations;
	}

	public void setJobLocations(Set jobLocations)
	{
		this.jobLocations = jobLocations;
	}

	public Set getJobs()
	{
		return this.jobs;
	}

	public void setJobs(Set jobs)
	{
		this.jobs = jobs;
	}

	public Set getUsers()
	{
		return this.users;
	}

	public void setUsers(Set users)
	{
		this.users = users;
	}

	public Set getUserApprovers()
	{
		return this.userApprovers;
	}

	public void setUserApprovers(Set userApprovers)
	{
		this.userApprovers = userApprovers;
	}

	public Set getContacts()
	{
		return this.contacts;
	}

	public void setContacts(Set contacts)
	{
		this.contacts = contacts;
	}

	public Set getCustomers()
	{
		return this.customers;
	}

	public void setCustomers(Set customers)
	{
		this.customers = customers;
	}

	public Set getInvoices()
	{
		return this.invoices;
	}

	public void setInvoices(Set invoices)
	{
		this.invoices = invoices;
	}

	public Set getCustomCustColumns()
	{
		return this.customCustColumns;
	}

	public void setCustomCustColumns(Set customCustColumns)
	{
		this.customCustColumns = customCustColumns;
	}

}