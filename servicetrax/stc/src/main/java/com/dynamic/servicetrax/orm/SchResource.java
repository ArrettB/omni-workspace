package com.dynamic.servicetrax.orm;

// Generated Apr 27, 2006 9:55:28 AM by Hibernate Tools 3.1.0.beta5

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

/**
 * SchResource generated by hbm2java
 */
public class SchResource implements java.io.Serializable
{

	// Fields    

	private Long schResourceId;

	private Lookup lookupByReasonTypeId;

	private Service serviceByHiddenServiceId;

	private Resource resource;

	private Lookup lookupByResStatusTypeId;

	private Lookup lookupByDateTypeId;

	private Lookup lookupByReportToTypeId;

	private User userByModifiedBy;

	private Service serviceByServiceId;

	private Job job;

	private User userByCreatedBy;

	private SchResource schResource;

	private String foremanFlag;

	private Date resStartDate;

	private Date resStartTime;

	private Date resEndDate;

	private Date resEndTime;

	private Date dateConfirmed;

	private Long resourceQty;

	private Long estHours;

	private String schNotes;

	private String weekendFlag;

	private String sendToPdaFlag;

	private Date dateCreated;

	private Date dateModified;

	private Set schResources = new HashSet(0);

	// Constructors

	/** default constructor */
	public SchResource()
	{
	}

	/** minimal constructor */
	public SchResource(Resource resource, User userByCreatedBy, Date resStartDate, Date dateCreated)
	{
		this.resource = resource;
		this.userByCreatedBy = userByCreatedBy;
		this.resStartDate = resStartDate;
		this.dateCreated = dateCreated;
	}

	/** full constructor */
	public SchResource(Lookup lookupByReasonTypeId, Service serviceByHiddenServiceId, Resource resource, Lookup lookupByResStatusTypeId, Lookup lookupByDateTypeId, Lookup lookupByReportToTypeId,
			User userByModifiedBy, Service serviceByServiceId, Job job, User userByCreatedBy, SchResource schResource, String foremanFlag, Date resStartDate, Date resStartTime, Date resEndDate,
			Date resEndTime, Date dateConfirmed, Long resourceQty, Long estHours, String schNotes, String weekendFlag, String sendToPdaFlag, Date dateCreated, Date dateModified, Set schResources)
	{
		this.lookupByReasonTypeId = lookupByReasonTypeId;
		this.serviceByHiddenServiceId = serviceByHiddenServiceId;
		this.resource = resource;
		this.lookupByResStatusTypeId = lookupByResStatusTypeId;
		this.lookupByDateTypeId = lookupByDateTypeId;
		this.lookupByReportToTypeId = lookupByReportToTypeId;
		this.userByModifiedBy = userByModifiedBy;
		this.serviceByServiceId = serviceByServiceId;
		this.job = job;
		this.userByCreatedBy = userByCreatedBy;
		this.schResource = schResource;
		this.foremanFlag = foremanFlag;
		this.resStartDate = resStartDate;
		this.resStartTime = resStartTime;
		this.resEndDate = resEndDate;
		this.resEndTime = resEndTime;
		this.dateConfirmed = dateConfirmed;
		this.resourceQty = resourceQty;
		this.estHours = estHours;
		this.schNotes = schNotes;
		this.weekendFlag = weekendFlag;
		this.sendToPdaFlag = sendToPdaFlag;
		this.dateCreated = dateCreated;
		this.dateModified = dateModified;
		this.schResources = schResources;
	}

	// Property accessors
	public Long getSchResourceId()
	{
		return this.schResourceId;
	}

	public void setSchResourceId(Long schResourceId)
	{
		this.schResourceId = schResourceId;
	}

	public Lookup getLookupByReasonTypeId()
	{
		return this.lookupByReasonTypeId;
	}

	public void setLookupByReasonTypeId(Lookup lookupByReasonTypeId)
	{
		this.lookupByReasonTypeId = lookupByReasonTypeId;
	}

	public Service getServiceByHiddenServiceId()
	{
		return this.serviceByHiddenServiceId;
	}

	public void setServiceByHiddenServiceId(Service serviceByHiddenServiceId)
	{
		this.serviceByHiddenServiceId = serviceByHiddenServiceId;
	}

	public Resource getResource()
	{
		return this.resource;
	}

	public void setResource(Resource resource)
	{
		this.resource = resource;
	}

	public Lookup getLookupByResStatusTypeId()
	{
		return this.lookupByResStatusTypeId;
	}

	public void setLookupByResStatusTypeId(Lookup lookupByResStatusTypeId)
	{
		this.lookupByResStatusTypeId = lookupByResStatusTypeId;
	}

	public Lookup getLookupByDateTypeId()
	{
		return this.lookupByDateTypeId;
	}

	public void setLookupByDateTypeId(Lookup lookupByDateTypeId)
	{
		this.lookupByDateTypeId = lookupByDateTypeId;
	}

	public Lookup getLookupByReportToTypeId()
	{
		return this.lookupByReportToTypeId;
	}

	public void setLookupByReportToTypeId(Lookup lookupByReportToTypeId)
	{
		this.lookupByReportToTypeId = lookupByReportToTypeId;
	}

	public User getUserByModifiedBy()
	{
		return this.userByModifiedBy;
	}

	public void setUserByModifiedBy(User userByModifiedBy)
	{
		this.userByModifiedBy = userByModifiedBy;
	}

	public Service getServiceByServiceId()
	{
		return this.serviceByServiceId;
	}

	public void setServiceByServiceId(Service serviceByServiceId)
	{
		this.serviceByServiceId = serviceByServiceId;
	}

	public Job getJob()
	{
		return this.job;
	}

	public void setJob(Job job)
	{
		this.job = job;
	}

	public User getUserByCreatedBy()
	{
		return this.userByCreatedBy;
	}

	public void setUserByCreatedBy(User userByCreatedBy)
	{
		this.userByCreatedBy = userByCreatedBy;
	}

	public SchResource getSchResource()
	{
		return this.schResource;
	}

	public void setSchResource(SchResource schResource)
	{
		this.schResource = schResource;
	}

	public String getForemanFlag()
	{
		return this.foremanFlag;
	}

	public void setForemanFlag(String foremanFlag)
	{
		this.foremanFlag = foremanFlag;
	}

	public Date getResStartDate()
	{
		return this.resStartDate;
	}

	public void setResStartDate(Date resStartDate)
	{
		this.resStartDate = resStartDate;
	}

	public Date getResStartTime()
	{
		return this.resStartTime;
	}

	public void setResStartTime(Date resStartTime)
	{
		this.resStartTime = resStartTime;
	}

	public Date getResEndDate()
	{
		return this.resEndDate;
	}

	public void setResEndDate(Date resEndDate)
	{
		this.resEndDate = resEndDate;
	}

	public Date getResEndTime()
	{
		return this.resEndTime;
	}

	public void setResEndTime(Date resEndTime)
	{
		this.resEndTime = resEndTime;
	}

	public Date getDateConfirmed()
	{
		return this.dateConfirmed;
	}

	public void setDateConfirmed(Date dateConfirmed)
	{
		this.dateConfirmed = dateConfirmed;
	}

	public Long getResourceQty()
	{
		return this.resourceQty;
	}

	public void setResourceQty(Long resourceQty)
	{
		this.resourceQty = resourceQty;
	}

	public Long getEstHours()
	{
		return this.estHours;
	}

	public void setEstHours(Long estHours)
	{
		this.estHours = estHours;
	}

	public String getSchNotes()
	{
		return this.schNotes;
	}

	public void setSchNotes(String schNotes)
	{
		this.schNotes = schNotes;
	}

	public String getWeekendFlag()
	{
		return this.weekendFlag;
	}

	public void setWeekendFlag(String weekendFlag)
	{
		this.weekendFlag = weekendFlag;
	}

	public String getSendToPdaFlag()
	{
		return this.sendToPdaFlag;
	}

	public void setSendToPdaFlag(String sendToPdaFlag)
	{
		this.sendToPdaFlag = sendToPdaFlag;
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

	public Set getSchResources()
	{
		return this.schResources;
	}

	public void setSchResources(Set schResources)
	{
		this.schResources = schResources;
	}

}
