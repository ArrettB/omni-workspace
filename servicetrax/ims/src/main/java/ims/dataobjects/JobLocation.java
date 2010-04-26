package ims.dataobjects;

import java.util.Date;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class JobLocation extends AbstractDatabaseObject
{

	private int jobLocationID;
	private String extJobNameID;
	private String jobLocationName;
	private int locationTypeID;
	private String extAddressID;
	private String street1;
	private String street2;
	private String street3;
	private String city;
	private String state;
	private String zip;
	private String country;
	private String directions;
	private int jobLocContactID;
	private int bldgMgmtContactID;
	private int multiLevelTypeID;
	private String passageSize;
	private int floorProtTypeID;
	private int loadingDockTypeID;
	private int securityTypeID;
	private Date dateCreated;
	private int createdBy;
	private Date dateModified;
	private int modifiedBy;

	public JobLocation()
	{
		super();
	}


	public static JobLocation fetch(String jobLocationID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(jobLocationID), ic, null);
	}

	public static JobLocation fetch(String jobLocationID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(jobLocationID), ic, resourceName);
	}

	public static JobLocation fetch(int jobLocationID, InvocationContext ic)
	{
		 return fetch(jobLocationID, ic, null);
	}

	public static JobLocation fetch(int jobLocationID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("JobLocation.fetch()");

		JobLocation result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT job_location_id ");
			query.append(", ext_job_name_id ");
			query.append(", job_location_name ");
			query.append(", location_type_id ");
			query.append(", ext_address_id ");
			query.append(", street1 ");
			query.append(", street2 ");
			query.append(", street3 ");
			query.append(", city ");
			query.append(", state ");
			query.append(", zip ");
			query.append(", country ");
			query.append(", directions ");
			query.append(", job_loc_contact_id ");
			query.append(", bldg_mgmt_contact_id ");
			query.append(", multi_level_type_id ");
			query.append(", passage_size ");
			query.append(", floor_prot_type_id ");
			query.append(", loading_dock_type_id ");
			query.append(", security_type_id ");
			query.append(", date_created ");
			query.append(", created_by ");
			query.append(", date_modified ");
			query.append(", modified_by ");
			query.append("FROM job_locations ");
			query.append("WHERE (job_location_id = ").append(jobLocationID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new JobLocation();
				result.setJobLocationID(rs.getInt(1));
				result.setExtJobNameID(rs.getString(2));
				result.setJobLocationName(rs.getString(3));
				result.setLocationTypeID(rs.getInt(4));
				result.setExtAddressID(rs.getString(5));
				result.setStreet1(rs.getString(6));
				result.setStreet2(rs.getString(7));
				result.setStreet3(rs.getString(8));
				result.setCity(rs.getString(9));
				result.setState(rs.getString(10));
				result.setZip(rs.getString(11));
				result.setCountry(rs.getString(12));
				result.setDirections(rs.getString(13));
				result.setJobLocContactID(rs.getInt(14));
				result.setBldgMgmtContactID(rs.getInt(15));
				result.setMultiLevelTypeID(rs.getInt(16));
				result.setPassageSize(rs.getString(17));
				result.setFloorProtTypeID(rs.getInt(18));
				result.setLoadingDockTypeID(rs.getInt(19));
				result.setSecurityTypeID(rs.getInt(20));
				result.setDateCreated(rs.getDate(21));
				result.setCreatedBy(rs.getInt(22));
				result.setDateModified(rs.getDate(23));
				result.setModifiedBy(rs.getInt(24));
			}
			else
			{
				Diagnostics.error("Error in JobLocation.fetch(), Could not find JobLocation; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in JobLocation.fetch()");
		}
		finally
		{
			if (conn != null)
			{
				conn.release();
			}
		}

		 if (result != null) result.handleAction(FETCH_ACTION);
		return result;
	}

	protected void internalUpdate(InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("JobLocation.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE job_locations ");
			update.append("SET ext_job_name_id = ").append(conn.toSQLString(StringUtil.truncate(this.getExtJobNameID(), 100)));
			update.append(", job_location_name = ").append(conn.toSQLString(StringUtil.truncate(this.getJobLocationName(), 50)));
			update.append(", location_type_id = ").append(this.getLocationTypeID());
			update.append(", ext_address_id = ").append(conn.toSQLString(StringUtil.truncate(this.getExtAddressID(), 30)));
			update.append(", street1 = ").append(conn.toSQLString(StringUtil.truncate(this.getStreet1(), 100)));
			update.append(", street2 = ").append(conn.toSQLString(StringUtil.truncate(this.getStreet2(), 100)));
			update.append(", street3 = ").append(conn.toSQLString(StringUtil.truncate(this.getStreet3(), 100)));
			update.append(", city = ").append(conn.toSQLString(StringUtil.truncate(this.getCity(), 50)));
			update.append(", state = ").append(conn.toSQLString(StringUtil.truncate(this.getState(), 2)));
			update.append(", zip = ").append(conn.toSQLString(StringUtil.truncate(this.getZip(), 10)));
			update.append(", country = ").append(conn.toSQLString(StringUtil.truncate(this.getCountry(), 100)));
			update.append(", directions = ").append(conn.toSQLString(StringUtil.truncate(this.getDirections(), 500)));
			update.append(", job_loc_contact_id = ").append(this.getJobLocContactID());
			update.append(", bldg_mgmt_contact_id = ").append(this.getBldgMgmtContactID());
			update.append(", multi_level_type_id = ").append(this.getMultiLevelTypeID());
			update.append(", passage_size = ").append(conn.toSQLString(StringUtil.truncate(this.getPassageSize(), 50)));
			update.append(", floor_prot_type_id = ").append(this.getFloorProtTypeID());
			update.append(", loading_dock_type_id = ").append(this.getLoadingDockTypeID());
			update.append(", security_type_id = ").append(this.getSecurityTypeID());
			update.append(", date_created = ").append(conn.toSQLString(this.getDateCreated()));
			update.append(", created_by = ").append(this.getCreatedBy());
			update.append(", date_modified = ").append(conn.toSQLString(this.getDateModified()));
			update.append(", modified_by = ").append(this.getModifiedBy());
			update.append("WHERE (job_location_id = ").append(this.getJobLocationID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in JobLocation.internalUpdate()");
		}
		finally
		{
			if (conn != null)
			{
				conn.release();
			}
		}
	}

	protected void internalInsert(InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("JobLocation.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO job_locations (");
				insert.append("ext_job_name_id");
				insert.append(", job_location_name");
				insert.append(", location_type_id");
				insert.append(", ext_address_id");
				insert.append(", street1");
				insert.append(", street2");
				insert.append(", street3");
				insert.append(", city");
				insert.append(", state");
				insert.append(", zip");
				insert.append(", country");
				insert.append(", directions");
				insert.append(", job_loc_contact_id");
				insert.append(", bldg_mgmt_contact_id");
				insert.append(", multi_level_type_id");
				insert.append(", passage_size");
				insert.append(", floor_prot_type_id");
				insert.append(", loading_dock_type_id");
				insert.append(", security_type_id");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(conn.toSQLString(StringUtil.truncate(this.getExtJobNameID(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getJobLocationName(), 50)));
				insert.append(", ").append(this.getLocationTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getExtAddressID(), 30)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getStreet1(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getStreet2(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getStreet3(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCity(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getState(), 2)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getZip(), 10)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCountry(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getDirections(), 500)));
				insert.append(", ").append(this.getJobLocContactID());
				insert.append(", ").append(this.getBldgMgmtContactID());
				insert.append(", ").append(this.getMultiLevelTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getPassageSize(), 50)));
				insert.append(", ").append(this.getFloorProtTypeID());
				insert.append(", ").append(this.getLoadingDockTypeID());
				insert.append(", ").append(this.getSecurityTypeID());
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO job_locations (");
				insert.append("job_location_id");
				insert.append(", ext_job_name_id");
				insert.append(", job_location_name");
				insert.append(", location_type_id");
				insert.append(", ext_address_id");
				insert.append(", street1");
				insert.append(", street2");
				insert.append(", street3");
				insert.append(", city");
				insert.append(", state");
				insert.append(", zip");
				insert.append(", country");
				insert.append(", directions");
				insert.append(", job_loc_contact_id");
				insert.append(", bldg_mgmt_contact_id");
				insert.append(", multi_level_type_id");
				insert.append(", passage_size");
				insert.append(", floor_prot_type_id");
				insert.append(", loading_dock_type_id");
				insert.append(", security_type_id");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getJobLocationID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getExtJobNameID(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getJobLocationName(), 50)));
				insert.append(", ").append(this.getLocationTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getExtAddressID(), 30)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getStreet1(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getStreet2(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getStreet3(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCity(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getState(), 2)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getZip(), 10)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCountry(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getDirections(), 500)));
				insert.append(", ").append(this.getJobLocContactID());
				insert.append(", ").append(this.getBldgMgmtContactID());
				insert.append(", ").append(this.getMultiLevelTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getPassageSize(), 50)));
				insert.append(", ").append(this.getFloorProtTypeID());
				insert.append(", ").append(this.getLoadingDockTypeID());
				insert.append(", ").append(this.getSecurityTypeID());
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				jobLocationID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in JobLocation.internalInsert()");
		}
		finally
		{
			if (conn != null)
			{
				conn.release();
			}
		}
	}

	protected void internalDelete(InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("JobLocation.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM job_locations ");
			delete.append("WHERE (job_location_id = ").append(this.getJobLocationID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in JobLocation.internalDelete()");
		}
		finally
		{
			if (conn != null)
			{
				conn.release();
			}
		}
	}

	private boolean skipPrimaryKey()
	{
		boolean skipPrimaryKey = false;
		if (this.getJobLocationID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("JobLocation:\n");
		result.append("  job_location_id = ").append(this.getJobLocationID()).append("\n");
		result.append("  ext_job_name_id = ").append(this.getExtJobNameID()).append("\n");
		result.append("  job_location_name = ").append(this.getJobLocationName()).append("\n");
		result.append("  location_type_id = ").append(this.getLocationTypeID()).append("\n");
		result.append("  ext_address_id = ").append(this.getExtAddressID()).append("\n");
		result.append("  street1 = ").append(this.getStreet1()).append("\n");
		result.append("  street2 = ").append(this.getStreet2()).append("\n");
		result.append("  street3 = ").append(this.getStreet3()).append("\n");
		result.append("  city = ").append(this.getCity()).append("\n");
		result.append("  state = ").append(this.getState()).append("\n");
		result.append("  zip = ").append(this.getZip()).append("\n");
		result.append("  country = ").append(this.getCountry()).append("\n");
		result.append("  directions = ").append(this.getDirections()).append("\n");
		result.append("  job_loc_contact_id = ").append(this.getJobLocContactID()).append("\n");
		result.append("  bldg_mgmt_contact_id = ").append(this.getBldgMgmtContactID()).append("\n");
		result.append("  multi_level_type_id = ").append(this.getMultiLevelTypeID()).append("\n");
		result.append("  passage_size = ").append(this.getPassageSize()).append("\n");
		result.append("  floor_prot_type_id = ").append(this.getFloorProtTypeID()).append("\n");
		result.append("  loading_dock_type_id = ").append(this.getLoadingDockTypeID()).append("\n");
		result.append("  security_type_id = ").append(this.getSecurityTypeID()).append("\n");
		result.append("  date_created = ").append(this.getDateCreated()).append("\n");
		result.append("  created_by = ").append(this.getCreatedBy()).append("\n");
		result.append("  date_modified = ").append(this.getDateModified()).append("\n");
		result.append("  modified_by = ").append(this.getModifiedBy()).append("\n");
		return result.toString();
	}


	public int getJobLocationID()
	{
		return jobLocationID;
	}

	public String getExtJobNameID()
	{
		return extJobNameID;
	}

	public String getJobLocationName()
	{
		return jobLocationName;
	}

	public int getLocationTypeID()
	{
		return locationTypeID;
	}

	public String getExtAddressID()
	{
		return extAddressID;
	}

	public String getStreet1()
	{
		return street1;
	}

	public String getStreet2()
	{
		return street2;
	}

	public String getStreet3()
	{
		return street3;
	}

	public String getCity()
	{
		return city;
	}

	public String getState()
	{
		return state;
	}

	public String getZip()
	{
		return zip;
	}

	public String getCountry()
	{
		return country;
	}

	public String getDirections()
	{
		return directions;
	}

	public int getJobLocContactID()
	{
		return jobLocContactID;
	}

	public int getBldgMgmtContactID()
	{
		return bldgMgmtContactID;
	}

	public int getMultiLevelTypeID()
	{
		return multiLevelTypeID;
	}

	public String getPassageSize()
	{
		return passageSize;
	}

	public int getFloorProtTypeID()
	{
		return floorProtTypeID;
	}

	public int getLoadingDockTypeID()
	{
		return loadingDockTypeID;
	}

	public int getSecurityTypeID()
	{
		return securityTypeID;
	}

	public Date getDateCreated()
	{
		return dateCreated;
	}

	public int getCreatedBy()
	{
		return createdBy;
	}

	public Date getDateModified()
	{
		return dateModified;
	}

	public int getModifiedBy()
	{
		return modifiedBy;
	}

	public void setJobLocationID(int jobLocationIDIn)
	{
		jobLocationID = jobLocationIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setExtJobNameID(String extJobNameIDIn)
	{
		extJobNameID = extJobNameIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setJobLocationName(String jobLocationNameIn)
	{
		jobLocationName = jobLocationNameIn;
		handleAction(MODIFY_ACTION);
	}

	public void setLocationTypeID(int locationTypeIDIn)
	{
		locationTypeID = locationTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setExtAddressID(String extAddressIDIn)
	{
		extAddressID = extAddressIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setStreet1(String street1In)
	{
		street1 = street1In;
		handleAction(MODIFY_ACTION);
	}

	public void setStreet2(String street2In)
	{
		street2 = street2In;
		handleAction(MODIFY_ACTION);
	}

	public void setStreet3(String street3In)
	{
		street3 = street3In;
		handleAction(MODIFY_ACTION);
	}

	public void setCity(String cityIn)
	{
		city = cityIn;
		handleAction(MODIFY_ACTION);
	}

	public void setState(String stateIn)
	{
		state = stateIn;
		handleAction(MODIFY_ACTION);
	}

	public void setZip(String zipIn)
	{
		zip = zipIn;
		handleAction(MODIFY_ACTION);
	}

	public void setCountry(String countryIn)
	{
		country = countryIn;
		handleAction(MODIFY_ACTION);
	}

	public void setDirections(String directionsIn)
	{
		directions = directionsIn;
		handleAction(MODIFY_ACTION);
	}

	public void setJobLocContactID(int jobLocContactIDIn)
	{
		jobLocContactID = jobLocContactIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setBldgMgmtContactID(int bldgMgmtContactIDIn)
	{
		bldgMgmtContactID = bldgMgmtContactIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setMultiLevelTypeID(int multiLevelTypeIDIn)
	{
		multiLevelTypeID = multiLevelTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setPassageSize(String passageSizeIn)
	{
		passageSize = passageSizeIn;
		handleAction(MODIFY_ACTION);
	}

	public void setFloorProtTypeID(int floorProtTypeIDIn)
	{
		floorProtTypeID = floorProtTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setLoadingDockTypeID(int loadingDockTypeIDIn)
	{
		loadingDockTypeID = loadingDockTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setSecurityTypeID(int securityTypeIDIn)
	{
		securityTypeID = securityTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setDateCreated(Date dateCreatedIn)
	{
		dateCreated = dateCreatedIn;
		handleAction(MODIFY_ACTION);
	}

	public void setCreatedBy(int createdByIn)
	{
		createdBy = createdByIn;
		handleAction(MODIFY_ACTION);
	}

	public void setDateModified(Date dateModifiedIn)
	{
		dateModified = dateModifiedIn;
		handleAction(MODIFY_ACTION);
	}

	public void setModifiedBy(int modifiedByIn)
	{
		modifiedBy = modifiedByIn;
		handleAction(MODIFY_ACTION);
	}
}
