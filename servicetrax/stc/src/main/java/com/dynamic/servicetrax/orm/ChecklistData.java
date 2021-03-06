package com.dynamic.servicetrax.orm;

// Generated Apr 27, 2006 9:55:28 AM by Hibernate Tools 3.1.0.beta5

/**
 * ChecklistData generated by hbm2java
 */
public class ChecklistData implements java.io.Serializable
{

	// Fields    

	private Long checklistDataId;

	private Checklist checklist;

	private String dataName;

	private String dataValue;

	private Long numStations;

	// Constructors

	/** default constructor */
	public ChecklistData()
	{
	}

	/** minimal constructor */
	public ChecklistData(Checklist checklist, String dataName, String dataValue)
	{
		this.checklist = checklist;
		this.dataName = dataName;
		this.dataValue = dataValue;
	}

	/** full constructor */
	public ChecklistData(Checklist checklist, String dataName, String dataValue, Long numStations)
	{
		this.checklist = checklist;
		this.dataName = dataName;
		this.dataValue = dataValue;
		this.numStations = numStations;
	}

	// Property accessors
	public Long getChecklistDataId()
	{
		return this.checklistDataId;
	}

	public void setChecklistDataId(Long checklistDataId)
	{
		this.checklistDataId = checklistDataId;
	}

	public Checklist getChecklist()
	{
		return this.checklist;
	}

	public void setChecklist(Checklist checklist)
	{
		this.checklist = checklist;
	}

	public String getDataName()
	{
		return this.dataName;
	}

	public void setDataName(String dataName)
	{
		this.dataName = dataName;
	}

	public String getDataValue()
	{
		return this.dataValue;
	}

	public void setDataValue(String dataValue)
	{
		this.dataValue = dataValue;
	}

	public Long getNumStations()
	{
		return this.numStations;
	}

	public void setNumStations(Long numStations)
	{
		this.numStations = numStations;
	}

}
