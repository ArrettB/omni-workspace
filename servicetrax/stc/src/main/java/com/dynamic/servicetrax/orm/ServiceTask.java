package com.dynamic.servicetrax.orm;

// Generated Apr 27, 2006 9:55:28 AM by Hibernate Tools 3.1.0.beta5

import java.util.Date;

/**
 * ServiceTask generated by hbm2java
 */
public class ServiceTask implements java.io.Serializable
{

	// Fields    

	private Long serviceTaskId;

	private Lookup lookupBySubActTypeId;

	private Service service;

	private Lookup lookupByModifiedBy;

	private User user;

	private Lookup lookupByPhaseTypeId;

	private String phase;

	private long phaseNo;

	private long sequenceNo;

	private String vendorResponsible;

	private String description;

	private Date dateCreated;

	private Date dateModified;

	// Constructors

	/** default constructor */
	public ServiceTask()
	{
	}

	/** minimal constructor */
	public ServiceTask(Lookup lookupBySubActTypeId, Service service, User user, Lookup lookupByPhaseTypeId, String phase, long phaseNo, long sequenceNo, Date dateCreated)
	{
		this.lookupBySubActTypeId = lookupBySubActTypeId;
		this.service = service;
		this.user = user;
		this.lookupByPhaseTypeId = lookupByPhaseTypeId;
		this.phase = phase;
		this.phaseNo = phaseNo;
		this.sequenceNo = sequenceNo;
		this.dateCreated = dateCreated;
	}

	/** full constructor */
	public ServiceTask(Lookup lookupBySubActTypeId, Service service, Lookup lookupByModifiedBy, User user, Lookup lookupByPhaseTypeId, String phase, long phaseNo, long sequenceNo,
			String vendorResponsible, String description, Date dateCreated, Date dateModified)
	{
		this.lookupBySubActTypeId = lookupBySubActTypeId;
		this.service = service;
		this.lookupByModifiedBy = lookupByModifiedBy;
		this.user = user;
		this.lookupByPhaseTypeId = lookupByPhaseTypeId;
		this.phase = phase;
		this.phaseNo = phaseNo;
		this.sequenceNo = sequenceNo;
		this.vendorResponsible = vendorResponsible;
		this.description = description;
		this.dateCreated = dateCreated;
		this.dateModified = dateModified;
	}

	// Property accessors
	public Long getServiceTaskId()
	{
		return this.serviceTaskId;
	}

	public void setServiceTaskId(Long serviceTaskId)
	{
		this.serviceTaskId = serviceTaskId;
	}

	public Lookup getLookupBySubActTypeId()
	{
		return this.lookupBySubActTypeId;
	}

	public void setLookupBySubActTypeId(Lookup lookupBySubActTypeId)
	{
		this.lookupBySubActTypeId = lookupBySubActTypeId;
	}

	public Service getService()
	{
		return this.service;
	}

	public void setService(Service service)
	{
		this.service = service;
	}

	public Lookup getLookupByModifiedBy()
	{
		return this.lookupByModifiedBy;
	}

	public void setLookupByModifiedBy(Lookup lookupByModifiedBy)
	{
		this.lookupByModifiedBy = lookupByModifiedBy;
	}

	public User getUser()
	{
		return this.user;
	}

	public void setUser(User user)
	{
		this.user = user;
	}

	public Lookup getLookupByPhaseTypeId()
	{
		return this.lookupByPhaseTypeId;
	}

	public void setLookupByPhaseTypeId(Lookup lookupByPhaseTypeId)
	{
		this.lookupByPhaseTypeId = lookupByPhaseTypeId;
	}

	public String getPhase()
	{
		return this.phase;
	}

	public void setPhase(String phase)
	{
		this.phase = phase;
	}

	public long getPhaseNo()
	{
		return this.phaseNo;
	}

	public void setPhaseNo(long phaseNo)
	{
		this.phaseNo = phaseNo;
	}

	public long getSequenceNo()
	{
		return this.sequenceNo;
	}

	public void setSequenceNo(long sequenceNo)
	{
		this.sequenceNo = sequenceNo;
	}

	public String getVendorResponsible()
	{
		return this.vendorResponsible;
	}

	public void setVendorResponsible(String vendorResponsible)
	{
		this.vendorResponsible = vendorResponsible;
	}

	public String getDescription()
	{
		return this.description;
	}

	public void setDescription(String description)
	{
		this.description = description;
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
