package com.dynamic.servicetrax.orm;

// Generated Apr 27, 2006 9:55:28 AM by Hibernate Tools 3.1.0.beta5

/**
 * CustomColList generated by hbm2java
 */
public class CustomColList implements java.io.Serializable
{

	// Fields    

	private Long customColListId;

	private CustomCustColumn customCustColumn;

	private long sequence;

	private String listValue;

	private String activeFlag;

	// Constructors

	/** default constructor */
	public CustomColList()
	{
	}

	/** full constructor */
	public CustomColList(CustomCustColumn customCustColumn, long sequence, String listValue, String activeFlag)
	{
		this.customCustColumn = customCustColumn;
		this.sequence = sequence;
		this.listValue = listValue;
		this.activeFlag = activeFlag;
	}

	// Property accessors
	public Long getCustomColListId()
	{
		return this.customColListId;
	}

	public void setCustomColListId(Long customColListId)
	{
		this.customColListId = customColListId;
	}

	public CustomCustColumn getCustomCustColumn()
	{
		return this.customCustColumn;
	}

	public void setCustomCustColumn(CustomCustColumn customCustColumn)
	{
		this.customCustColumn = customCustColumn;
	}

	public long getSequence()
	{
		return this.sequence;
	}

	public void setSequence(long sequence)
	{
		this.sequence = sequence;
	}

	public String getListValue()
	{
		return this.listValue;
	}

	public void setListValue(String listValue)
	{
		this.listValue = listValue;
	}

	public String getActiveFlag()
	{
		return this.activeFlag;
	}

	public void setActiveFlag(String activeFlag)
	{
		this.activeFlag = activeFlag;
	}

}