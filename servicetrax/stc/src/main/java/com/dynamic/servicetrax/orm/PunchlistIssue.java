package com.dynamic.servicetrax.orm;

// Generated Apr 27, 2006 9:55:28 AM by Hibernate Tools 3.1.0.beta5

import java.util.Date;

/**
 * PunchlistIssue generated by hbm2java
 */
public class PunchlistIssue implements java.io.Serializable
{

	// Fields    

	private Long punchlistIssueId;

	private Lookup lookupByRootCauseId;

	private Punchlist punchlist;

	private Lookup lookupByStatusId;

	private User userByModifiedBy;

	private User userByCreatedBy;

	private long issueNo;

	private String stationArea;

	private String problemDesc;

	private Date completeDate;

	private String solutionBy;

	private String solutionDesc;

	private Date solutionDate;

	private String installDesc;

	private Date installDate;

	private String orderNo;

	private Date shipDate;

	private Date dateCreated;

	private Date dateModified;

	// Constructors

	/** default constructor */
	public PunchlistIssue()
	{
	}

	/** minimal constructor */
	public PunchlistIssue(Punchlist punchlist, Lookup lookupByStatusId, User userByCreatedBy, long issueNo, Date dateCreated)
	{
		this.punchlist = punchlist;
		this.lookupByStatusId = lookupByStatusId;
		this.userByCreatedBy = userByCreatedBy;
		this.issueNo = issueNo;
		this.dateCreated = dateCreated;
	}

	/** full constructor */
	public PunchlistIssue(Lookup lookupByRootCauseId, Punchlist punchlist, Lookup lookupByStatusId, User userByModifiedBy, User userByCreatedBy, long issueNo, String stationArea, String problemDesc,
			Date completeDate, String solutionBy, String solutionDesc, Date solutionDate, String installDesc, Date installDate, String orderNo, Date shipDate, Date dateCreated, Date dateModified)
	{
		this.lookupByRootCauseId = lookupByRootCauseId;
		this.punchlist = punchlist;
		this.lookupByStatusId = lookupByStatusId;
		this.userByModifiedBy = userByModifiedBy;
		this.userByCreatedBy = userByCreatedBy;
		this.issueNo = issueNo;
		this.stationArea = stationArea;
		this.problemDesc = problemDesc;
		this.completeDate = completeDate;
		this.solutionBy = solutionBy;
		this.solutionDesc = solutionDesc;
		this.solutionDate = solutionDate;
		this.installDesc = installDesc;
		this.installDate = installDate;
		this.orderNo = orderNo;
		this.shipDate = shipDate;
		this.dateCreated = dateCreated;
		this.dateModified = dateModified;
	}

	// Property accessors
	public Long getPunchlistIssueId()
	{
		return this.punchlistIssueId;
	}

	public void setPunchlistIssueId(Long punchlistIssueId)
	{
		this.punchlistIssueId = punchlistIssueId;
	}

	public Lookup getLookupByRootCauseId()
	{
		return this.lookupByRootCauseId;
	}

	public void setLookupByRootCauseId(Lookup lookupByRootCauseId)
	{
		this.lookupByRootCauseId = lookupByRootCauseId;
	}

	public Punchlist getPunchlist()
	{
		return this.punchlist;
	}

	public void setPunchlist(Punchlist punchlist)
	{
		this.punchlist = punchlist;
	}

	public Lookup getLookupByStatusId()
	{
		return this.lookupByStatusId;
	}

	public void setLookupByStatusId(Lookup lookupByStatusId)
	{
		this.lookupByStatusId = lookupByStatusId;
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

	public long getIssueNo()
	{
		return this.issueNo;
	}

	public void setIssueNo(long issueNo)
	{
		this.issueNo = issueNo;
	}

	public String getStationArea()
	{
		return this.stationArea;
	}

	public void setStationArea(String stationArea)
	{
		this.stationArea = stationArea;
	}

	public String getProblemDesc()
	{
		return this.problemDesc;
	}

	public void setProblemDesc(String problemDesc)
	{
		this.problemDesc = problemDesc;
	}

	public Date getCompleteDate()
	{
		return this.completeDate;
	}

	public void setCompleteDate(Date completeDate)
	{
		this.completeDate = completeDate;
	}

	public String getSolutionBy()
	{
		return this.solutionBy;
	}

	public void setSolutionBy(String solutionBy)
	{
		this.solutionBy = solutionBy;
	}

	public String getSolutionDesc()
	{
		return this.solutionDesc;
	}

	public void setSolutionDesc(String solutionDesc)
	{
		this.solutionDesc = solutionDesc;
	}

	public Date getSolutionDate()
	{
		return this.solutionDate;
	}

	public void setSolutionDate(Date solutionDate)
	{
		this.solutionDate = solutionDate;
	}

	public String getInstallDesc()
	{
		return this.installDesc;
	}

	public void setInstallDesc(String installDesc)
	{
		this.installDesc = installDesc;
	}

	public Date getInstallDate()
	{
		return this.installDate;
	}

	public void setInstallDate(Date installDate)
	{
		this.installDate = installDate;
	}

	public String getOrderNo()
	{
		return this.orderNo;
	}

	public void setOrderNo(String orderNo)
	{
		this.orderNo = orderNo;
	}

	public Date getShipDate()
	{
		return this.shipDate;
	}

	public void setShipDate(Date shipDate)
	{
		this.shipDate = shipDate;
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
