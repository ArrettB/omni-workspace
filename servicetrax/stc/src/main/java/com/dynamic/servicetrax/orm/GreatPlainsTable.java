package com.dynamic.servicetrax.orm;

// Generated Apr 27, 2006 9:55:28 AM by Hibernate Tools 3.1.0.beta5

/**
 * GreatPlainsTable generated by hbm2java
 */
public class GreatPlainsTable implements java.io.Serializable
{

	// Fields    

	private Long tableId;

	private String tableName;

	private String gpPhysicalName;

	private String gpDisplayName;

	// Constructors

	/** default constructor */
	public GreatPlainsTable()
	{
	}

	/** full constructor */
	public GreatPlainsTable(String tableName, String gpPhysicalName, String gpDisplayName)
	{
		this.tableName = tableName;
		this.gpPhysicalName = gpPhysicalName;
		this.gpDisplayName = gpDisplayName;
	}

	// Property accessors
	public Long getTableId()
	{
		return this.tableId;
	}

	public void setTableId(Long tableId)
	{
		this.tableId = tableId;
	}

	public String getTableName()
	{
		return this.tableName;
	}

	public void setTableName(String tableName)
	{
		this.tableName = tableName;
	}

	public String getGpPhysicalName()
	{
		return this.gpPhysicalName;
	}

	public void setGpPhysicalName(String gpPhysicalName)
	{
		this.gpPhysicalName = gpPhysicalName;
	}

	public String getGpDisplayName()
	{
		return this.gpDisplayName;
	}

	public void setGpDisplayName(String gpDisplayName)
	{
		this.gpDisplayName = gpDisplayName;
	}

}
