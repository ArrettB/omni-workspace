package com.dynamic.servicetrax.orm;

// Generated Apr 27, 2006 9:55:28 AM by Hibernate Tools 3.1.0.beta5

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

/**
 * Punchlist generated by hbm2java
 */
public class Punchlist implements java.io.Serializable
{

	// Fields    

	private Long punchlistId;

	private Project project;

	private Request request;

	private User userByModifiedBy;

	private User userByCreatedBy;

	private Date walkthroughDate;

	private String printLocation;

	private Date dateCreated;

	private Date dateModified;

	private Set punchlistIssues = new HashSet(0);

	// Constructors

	/** default constructor */
	public Punchlist()
	{
	}

	/** minimal constructor */
	public Punchlist(Project project, Request request, User userByCreatedBy, Date dateCreated)
	{
		this.project = project;
		this.request = request;
		this.userByCreatedBy = userByCreatedBy;
		this.dateCreated = dateCreated;
	}

	/** full constructor */
	public Punchlist(Project project, Request request, User userByModifiedBy, User userByCreatedBy, Date walkthroughDate, String printLocation, Date dateCreated, Date dateModified, Set punchlistIssues)
	{
		this.project = project;
		this.request = request;
		this.userByModifiedBy = userByModifiedBy;
		this.userByCreatedBy = userByCreatedBy;
		this.walkthroughDate = walkthroughDate;
		this.printLocation = printLocation;
		this.dateCreated = dateCreated;
		this.dateModified = dateModified;
		this.punchlistIssues = punchlistIssues;
	}

	// Property accessors
	public Long getPunchlistId()
	{
		return this.punchlistId;
	}

	public void setPunchlistId(Long punchlistId)
	{
		this.punchlistId = punchlistId;
	}

	public Project getProject()
	{
		return this.project;
	}

	public void setProject(Project project)
	{
		this.project = project;
	}

	public Request getRequest()
	{
		return this.request;
	}

	public void setRequest(Request request)
	{
		this.request = request;
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

	public Date getWalkthroughDate()
	{
		return this.walkthroughDate;
	}

	public void setWalkthroughDate(Date walkthroughDate)
	{
		this.walkthroughDate = walkthroughDate;
	}

	public String getPrintLocation()
	{
		return this.printLocation;
	}

	public void setPrintLocation(String printLocation)
	{
		this.printLocation = printLocation;
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

	public Set getPunchlistIssues()
	{
		return this.punchlistIssues;
	}

	public void setPunchlistIssues(Set punchlistIssues)
	{
		this.punchlistIssues = punchlistIssues;
	}

}