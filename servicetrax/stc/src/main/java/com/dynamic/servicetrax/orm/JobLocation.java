package com.dynamic.servicetrax.orm;

// Generated Apr 27, 2006 9:55:28 AM by Hibernate Tools 3.1.0.beta5

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

/**
 * JobLocation generated by hbm2java
 */
public class JobLocation implements java.io.Serializable
{

	// Fields    

	private Long jobLocationId;

	private Lookup lookupByWallProtectionTypeId;

	private Lookup lookupByMultiLevelTypeId;

	private Lookup lookupByElevatorAvailTypeId;

	private Lookup lookupByDockReservReqTypeId;

	private Lookup lookupBySecurityTypeId;

	private Lookup lookupByDoorwayProtTypeId;

	private User userByModifiedBy;

	private Contact contactByJobLocContactId;

	private Contact contactByBldgMgmtContactId;

	private Lookup lookupBySemiAccessTypeId;

	private Lookup lookupByLoadingDockTypeId;

	private Lookup lookupByLocationTypeId;

	private Lookup lookupByStairCarryTypeId;

	private Customer customer;

	private Lookup lookupByFloorProtectionTypeId;

	private User userByCreatedBy;

	private Lookup lookupByElevatorReservReqTypeId;

	private String jobLocationName;

	private String extAddressId;

	private String street1;

	private String street2;

	private String street3;

	private String city;

	private String state;

	private String zip;

	private String country;

	private String directions;

	private String dockAvailableTime;

	private String dockHeight;

	private Long stairCarryFlights;

	private String stairCarryStairs;

	private String smallestDoorElevWidth;

	private Date dateCreated;

	private Date dateModified;

	private Set requests = new HashSet(0);

	private Set servicesForReportToLocId = new HashSet(0);

	private Set servicesForJobLocationId = new HashSet(0);

	private Set servicesForJobLocationId_1 = new HashSet(0);

	// Constructors

	/** default constructor */
	public JobLocation()
	{
	}

	/** minimal constructor */
	public JobLocation(Lookup lookupByLocationTypeId, Customer customer, User userByCreatedBy, String jobLocationName, Date dateCreated)
	{
		this.lookupByLocationTypeId = lookupByLocationTypeId;
		this.customer = customer;
		this.userByCreatedBy = userByCreatedBy;
		this.jobLocationName = jobLocationName;
		this.dateCreated = dateCreated;
	}

	/** full constructor */
	public JobLocation(Lookup lookupByWallProtectionTypeId, Lookup lookupByMultiLevelTypeId, Lookup lookupByElevatorAvailTypeId, Lookup lookupByDockReservReqTypeId, Lookup lookupBySecurityTypeId,
			Lookup lookupByDoorwayProtTypeId, User userByModifiedBy, Contact contactByJobLocContactId, Contact contactByBldgMgmtContactId, Lookup lookupBySemiAccessTypeId,
			Lookup lookupByLoadingDockTypeId, Lookup lookupByLocationTypeId, Lookup lookupByStairCarryTypeId, Customer customer, Lookup lookupByFloorProtectionTypeId, User userByCreatedBy,
			Lookup lookupByElevatorReservReqTypeId, String jobLocationName, String extAddressId, String street1, String street2, String street3, String city, String state, String zip, String country,
			String directions, String dockAvailableTime, String dockHeight, Long stairCarryFlights, String stairCarryStairs, String smallestDoorElevWidth, Date dateCreated, Date dateModified,
			Set requests, Set servicesForReportToLocId, Set servicesForJobLocationId, Set servicesForJobLocationId_1)
	{
		this.lookupByWallProtectionTypeId = lookupByWallProtectionTypeId;
		this.lookupByMultiLevelTypeId = lookupByMultiLevelTypeId;
		this.lookupByElevatorAvailTypeId = lookupByElevatorAvailTypeId;
		this.lookupByDockReservReqTypeId = lookupByDockReservReqTypeId;
		this.lookupBySecurityTypeId = lookupBySecurityTypeId;
		this.lookupByDoorwayProtTypeId = lookupByDoorwayProtTypeId;
		this.userByModifiedBy = userByModifiedBy;
		this.contactByJobLocContactId = contactByJobLocContactId;
		this.contactByBldgMgmtContactId = contactByBldgMgmtContactId;
		this.lookupBySemiAccessTypeId = lookupBySemiAccessTypeId;
		this.lookupByLoadingDockTypeId = lookupByLoadingDockTypeId;
		this.lookupByLocationTypeId = lookupByLocationTypeId;
		this.lookupByStairCarryTypeId = lookupByStairCarryTypeId;
		this.customer = customer;
		this.lookupByFloorProtectionTypeId = lookupByFloorProtectionTypeId;
		this.userByCreatedBy = userByCreatedBy;
		this.lookupByElevatorReservReqTypeId = lookupByElevatorReservReqTypeId;
		this.jobLocationName = jobLocationName;
		this.extAddressId = extAddressId;
		this.street1 = street1;
		this.street2 = street2;
		this.street3 = street3;
		this.city = city;
		this.state = state;
		this.zip = zip;
		this.country = country;
		this.directions = directions;
		this.dockAvailableTime = dockAvailableTime;
		this.dockHeight = dockHeight;
		this.stairCarryFlights = stairCarryFlights;
		this.stairCarryStairs = stairCarryStairs;
		this.smallestDoorElevWidth = smallestDoorElevWidth;
		this.dateCreated = dateCreated;
		this.dateModified = dateModified;
		this.requests = requests;
		this.servicesForReportToLocId = servicesForReportToLocId;
		this.servicesForJobLocationId = servicesForJobLocationId;
		this.servicesForJobLocationId_1 = servicesForJobLocationId_1;
	}

	// Property accessors
	public Long getJobLocationId()
	{
		return this.jobLocationId;
	}

	public void setJobLocationId(Long jobLocationId)
	{
		this.jobLocationId = jobLocationId;
	}

	public Lookup getLookupByWallProtectionTypeId()
	{
		return this.lookupByWallProtectionTypeId;
	}

	public void setLookupByWallProtectionTypeId(Lookup lookupByWallProtectionTypeId)
	{
		this.lookupByWallProtectionTypeId = lookupByWallProtectionTypeId;
	}

	public Lookup getLookupByMultiLevelTypeId()
	{
		return this.lookupByMultiLevelTypeId;
	}

	public void setLookupByMultiLevelTypeId(Lookup lookupByMultiLevelTypeId)
	{
		this.lookupByMultiLevelTypeId = lookupByMultiLevelTypeId;
	}

	public Lookup getLookupByElevatorAvailTypeId()
	{
		return this.lookupByElevatorAvailTypeId;
	}

	public void setLookupByElevatorAvailTypeId(Lookup lookupByElevatorAvailTypeId)
	{
		this.lookupByElevatorAvailTypeId = lookupByElevatorAvailTypeId;
	}

	public Lookup getLookupByDockReservReqTypeId()
	{
		return this.lookupByDockReservReqTypeId;
	}

	public void setLookupByDockReservReqTypeId(Lookup lookupByDockReservReqTypeId)
	{
		this.lookupByDockReservReqTypeId = lookupByDockReservReqTypeId;
	}

	public Lookup getLookupBySecurityTypeId()
	{
		return this.lookupBySecurityTypeId;
	}

	public void setLookupBySecurityTypeId(Lookup lookupBySecurityTypeId)
	{
		this.lookupBySecurityTypeId = lookupBySecurityTypeId;
	}

	public Lookup getLookupByDoorwayProtTypeId()
	{
		return this.lookupByDoorwayProtTypeId;
	}

	public void setLookupByDoorwayProtTypeId(Lookup lookupByDoorwayProtTypeId)
	{
		this.lookupByDoorwayProtTypeId = lookupByDoorwayProtTypeId;
	}

	public User getUserByModifiedBy()
	{
		return this.userByModifiedBy;
	}

	public void setUserByModifiedBy(User userByModifiedBy)
	{
		this.userByModifiedBy = userByModifiedBy;
	}

	public Contact getContactByJobLocContactId()
	{
		return this.contactByJobLocContactId;
	}

	public void setContactByJobLocContactId(Contact contactByJobLocContactId)
	{
		this.contactByJobLocContactId = contactByJobLocContactId;
	}

	public Contact getContactByBldgMgmtContactId()
	{
		return this.contactByBldgMgmtContactId;
	}

	public void setContactByBldgMgmtContactId(Contact contactByBldgMgmtContactId)
	{
		this.contactByBldgMgmtContactId = contactByBldgMgmtContactId;
	}

	public Lookup getLookupBySemiAccessTypeId()
	{
		return this.lookupBySemiAccessTypeId;
	}

	public void setLookupBySemiAccessTypeId(Lookup lookupBySemiAccessTypeId)
	{
		this.lookupBySemiAccessTypeId = lookupBySemiAccessTypeId;
	}

	public Lookup getLookupByLoadingDockTypeId()
	{
		return this.lookupByLoadingDockTypeId;
	}

	public void setLookupByLoadingDockTypeId(Lookup lookupByLoadingDockTypeId)
	{
		this.lookupByLoadingDockTypeId = lookupByLoadingDockTypeId;
	}

	public Lookup getLookupByLocationTypeId()
	{
		return this.lookupByLocationTypeId;
	}

	public void setLookupByLocationTypeId(Lookup lookupByLocationTypeId)
	{
		this.lookupByLocationTypeId = lookupByLocationTypeId;
	}

	public Lookup getLookupByStairCarryTypeId()
	{
		return this.lookupByStairCarryTypeId;
	}

	public void setLookupByStairCarryTypeId(Lookup lookupByStairCarryTypeId)
	{
		this.lookupByStairCarryTypeId = lookupByStairCarryTypeId;
	}

	public Customer getCustomer()
	{
		return this.customer;
	}

	public void setCustomer(Customer customer)
	{
		this.customer = customer;
	}

	public Lookup getLookupByFloorProtectionTypeId()
	{
		return this.lookupByFloorProtectionTypeId;
	}

	public void setLookupByFloorProtectionTypeId(Lookup lookupByFloorProtectionTypeId)
	{
		this.lookupByFloorProtectionTypeId = lookupByFloorProtectionTypeId;
	}

	public User getUserByCreatedBy()
	{
		return this.userByCreatedBy;
	}

	public void setUserByCreatedBy(User userByCreatedBy)
	{
		this.userByCreatedBy = userByCreatedBy;
	}

	public Lookup getLookupByElevatorReservReqTypeId()
	{
		return this.lookupByElevatorReservReqTypeId;
	}

	public void setLookupByElevatorReservReqTypeId(Lookup lookupByElevatorReservReqTypeId)
	{
		this.lookupByElevatorReservReqTypeId = lookupByElevatorReservReqTypeId;
	}

	public String getJobLocationName()
	{
		return this.jobLocationName;
	}

	public void setJobLocationName(String jobLocationName)
	{
		this.jobLocationName = jobLocationName;
	}

	public String getExtAddressId()
	{
		return this.extAddressId;
	}

	public void setExtAddressId(String extAddressId)
	{
		this.extAddressId = extAddressId;
	}

	public String getStreet1()
	{
		return this.street1;
	}

	public void setStreet1(String street1)
	{
		this.street1 = street1;
	}

	public String getStreet2()
	{
		return this.street2;
	}

	public void setStreet2(String street2)
	{
		this.street2 = street2;
	}

	public String getStreet3()
	{
		return this.street3;
	}

	public void setStreet3(String street3)
	{
		this.street3 = street3;
	}

	public String getCity()
	{
		return this.city;
	}

	public void setCity(String city)
	{
		this.city = city;
	}

	public String getState()
	{
		return this.state;
	}

	public void setState(String state)
	{
		this.state = state;
	}

	public String getZip()
	{
		return this.zip;
	}

	public void setZip(String zip)
	{
		this.zip = zip;
	}

	public String getCountry()
	{
		return this.country;
	}

	public void setCountry(String country)
	{
		this.country = country;
	}

	public String getDirections()
	{
		return this.directions;
	}

	public void setDirections(String directions)
	{
		this.directions = directions;
	}

	public String getDockAvailableTime()
	{
		return this.dockAvailableTime;
	}

	public void setDockAvailableTime(String dockAvailableTime)
	{
		this.dockAvailableTime = dockAvailableTime;
	}

	public String getDockHeight()
	{
		return this.dockHeight;
	}

	public void setDockHeight(String dockHeight)
	{
		this.dockHeight = dockHeight;
	}

	public Long getStairCarryFlights()
	{
		return this.stairCarryFlights;
	}

	public void setStairCarryFlights(Long stairCarryFlights)
	{
		this.stairCarryFlights = stairCarryFlights;
	}

	public String getStairCarryStairs()
	{
		return this.stairCarryStairs;
	}

	public void setStairCarryStairs(String stairCarryStairs)
	{
		this.stairCarryStairs = stairCarryStairs;
	}

	public String getSmallestDoorElevWidth()
	{
		return this.smallestDoorElevWidth;
	}

	public void setSmallestDoorElevWidth(String smallestDoorElevWidth)
	{
		this.smallestDoorElevWidth = smallestDoorElevWidth;
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

	public Set getRequests()
	{
		return this.requests;
	}

	public void setRequests(Set requests)
	{
		this.requests = requests;
	}

	public Set getServicesForReportToLocId()
	{
		return this.servicesForReportToLocId;
	}

	public void setServicesForReportToLocId(Set servicesForReportToLocId)
	{
		this.servicesForReportToLocId = servicesForReportToLocId;
	}

	public Set getServicesForJobLocationId()
	{
		return this.servicesForJobLocationId;
	}

	public void setServicesForJobLocationId(Set servicesForJobLocationId)
	{
		this.servicesForJobLocationId = servicesForJobLocationId;
	}

	public Set getServicesForJobLocationId_1()
	{
		return this.servicesForJobLocationId_1;
	}

	public void setServicesForJobLocationId_1(Set servicesForJobLocationId_1)
	{
		this.servicesForJobLocationId_1 = servicesForJobLocationId_1;
	}

}
