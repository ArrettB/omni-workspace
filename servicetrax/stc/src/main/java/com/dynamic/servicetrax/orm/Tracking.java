package com.dynamic.servicetrax.orm;

// Generated Apr 27, 2006 9:55:28 AM by Hibernate Tools 3.1.0.beta5

import java.util.Date;

/**
 * Tracking generated by hbm2java
 */
public class Tracking implements java.io.Serializable
{

	// Fields    

	private Long trackingId;

	private Lookup lookupByNewStatusId;

	private Lookup lookupByOldStatusId;

	private User userByFromUserId;

	private Lookup lookupByTrackingTypeId;

	private User userByModifiedBy;

	private Service service;

	private Job job;

	private User userByCreatedBy;

	private Contact contact;

	private String notes;

	private Long palmRepId;

	private char emailSentFlag;

	private Date dateCreated;

	private Date dateModified;

	// Constructors

	/** default constructor */
	public Tracking()
	{
	}

	/** minimal constructor */
	public Tracking(Lookup lookupByTrackingTypeId, Job job, User userByCreatedBy, char emailSentFlag, Date dateCreated)
	{
		this.lookupByTrackingTypeId = lookupByTrackingTypeId;
		this.job = job;
		this.userByCreatedBy = userByCreatedBy;
		this.emailSentFlag = emailSentFlag;
		this.dateCreated = dateCreated;
	}

	/** full constructor */
	public Tracking(Lookup lookupByNewStatusId, Lookup lookupByOldStatusId, User userByFromUserId, Lookup lookupByTrackingTypeId, User userByModifiedBy, Service service, Job job,
			User userByCreatedBy, Contact contact, String notes, Long palmRepId, char emailSentFlag, Date dateCreated, Date dateModified)
	{
		this.lookupByNewStatusId = lookupByNewStatusId;
		this.lookupByOldStatusId = lookupByOldStatusId;
		this.userByFromUserId = userByFromUserId;
		this.lookupByTrackingTypeId = lookupByTrackingTypeId;
		this.userByModifiedBy = userByModifiedBy;
		this.service = service;
		this.job = job;
		this.userByCreatedBy = userByCreatedBy;
		this.contact = contact;
		this.notes = notes;
		this.palmRepId = palmRepId;
		this.emailSentFlag = emailSentFlag;
		this.dateCreated = dateCreated;
		this.dateModified = dateModified;
	}

	// Property accessors
	public Long getTrackingId()
	{
		return this.trackingId;
	}

	public void setTrackingId(Long trackingId)
	{
		this.trackingId = trackingId;
	}

	public Lookup getLookupByNewStatusId()
	{
		return this.lookupByNewStatusId;
	}

	public void setLookupByNewStatusId(Lookup lookupByNewStatusId)
	{
		this.lookupByNewStatusId = lookupByNewStatusId;
	}

	public Lookup getLookupByOldStatusId()
	{
		return this.lookupByOldStatusId;
	}

	public void setLookupByOldStatusId(Lookup lookupByOldStatusId)
	{
		this.lookupByOldStatusId = lookupByOldStatusId;
	}

	public User getUserByFromUserId()
	{
		return this.userByFromUserId;
	}

	public void setUserByFromUserId(User userByFromUserId)
	{
		this.userByFromUserId = userByFromUserId;
	}

	public Lookup getLookupByTrackingTypeId()
	{
		return this.lookupByTrackingTypeId;
	}

	public void setLookupByTrackingTypeId(Lookup lookupByTrackingTypeId)
	{
		this.lookupByTrackingTypeId = lookupByTrackingTypeId;
	}

	public User getUserByModifiedBy()
	{
		return this.userByModifiedBy;
	}

	public void setUserByModifiedBy(User userByModifiedBy)
	{
		this.userByModifiedBy = userByModifiedBy;
	}

	public Service getService()
	{
		return this.service;
	}

	public void setService(Service service)
	{
		this.service = service;
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

	public Contact getContact()
	{
		return this.contact;
	}

	public void setContact(Contact contact)
	{
		this.contact = contact;
	}

	public String getNotes()
	{
		return this.notes;
	}

	public void setNotes(String notes)
	{
		this.notes = notes;
	}

	public Long getPalmRepId()
	{
		return this.palmRepId;
	}

	public void setPalmRepId(Long palmRepId)
	{
		this.palmRepId = palmRepId;
	}

	public char getEmailSentFlag()
	{
		return this.emailSentFlag;
	}

	public void setEmailSentFlag(char emailSentFlag)
	{
		this.emailSentFlag = emailSentFlag;
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

}
