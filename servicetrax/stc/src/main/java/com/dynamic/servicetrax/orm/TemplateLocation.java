package com.dynamic.servicetrax.orm;

// Generated Apr 27, 2006 9:55:28 AM by Hibernate Tools 3.1.0.beta5

/**
 * TemplateLocation generated by hbm2java
 */
public class TemplateLocation implements java.io.Serializable
{

	// Fields    

	private Long templateLocationId;

	private String location;

	private String target;

	private Long level1Tab;

	private Long level1Template;

	private Long level2Tab;

	private Long level2Template;

	private Long level3Tab;

	private Long level3Template;

	// Constructors

	/** default constructor */
	public TemplateLocation()
	{
	}

	/** full constructor */
	public TemplateLocation(String location, String target, Long level1Tab, Long level1Template, Long level2Tab, Long level2Template, Long level3Tab, Long level3Template)
	{
		this.location = location;
		this.target = target;
		this.level1Tab = level1Tab;
		this.level1Template = level1Template;
		this.level2Tab = level2Tab;
		this.level2Template = level2Template;
		this.level3Tab = level3Tab;
		this.level3Template = level3Template;
	}

	// Property accessors
	public Long getTemplateLocationId()
	{
		return this.templateLocationId;
	}

	public void setTemplateLocationId(Long templateLocationId)
	{
		this.templateLocationId = templateLocationId;
	}

	public String getLocation()
	{
		return this.location;
	}

	public void setLocation(String location)
	{
		this.location = location;
	}

	public String getTarget()
	{
		return this.target;
	}

	public void setTarget(String target)
	{
		this.target = target;
	}

	public Long getLevel1Tab()
	{
		return this.level1Tab;
	}

	public void setLevel1Tab(Long level1Tab)
	{
		this.level1Tab = level1Tab;
	}

	public Long getLevel1Template()
	{
		return this.level1Template;
	}

	public void setLevel1Template(Long level1Template)
	{
		this.level1Template = level1Template;
	}

	public Long getLevel2Tab()
	{
		return this.level2Tab;
	}

	public void setLevel2Tab(Long level2Tab)
	{
		this.level2Tab = level2Tab;
	}

	public Long getLevel2Template()
	{
		return this.level2Template;
	}

	public void setLevel2Template(Long level2Template)
	{
		this.level2Template = level2Template;
	}

	public Long getLevel3Tab()
	{
		return this.level3Tab;
	}

	public void setLevel3Tab(Long level3Tab)
	{
		this.level3Tab = level3Tab;
	}

	public Long getLevel3Template()
	{
		return this.level3Template;
	}

	public void setLevel3Template(Long level3Template)
	{
		this.level3Template = level3Template;
	}

}
