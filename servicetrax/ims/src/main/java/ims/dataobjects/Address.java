package ims.dataobjects;

import java.util.Date;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class Address extends AbstractDatabaseObject
{

	private int addressID;
	private int addressTypeID;
	private int companyID;
	private String addressName;
	private String street1;
	private String street2;
	private String street3;
	private String city;
	private String state;
	private String zip;
	private String extAddressID;
	private int workSiteContactID;
	private int bldgMgmtContactID;
	private String directions;
	private int multiLevelTypeID;
	private String passageSize;
	private int floorProtTypeID;
	private int loadingDockTypeID;
	private int securityTypeID;
	private Date dateCreated;
	private int createdBy;
	private Date dateModified;
	private int modifiedBy;

	public Address()
	{
		super();
	}


	public static Address fetch(String addressID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(addressID), ic, null);
	}

	public static Address fetch(String addressID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(addressID), ic, resourceName);
	}

	public static Address fetch(int addressID, InvocationContext ic)
	{
		 return fetch(addressID, ic, null);
	}

	public static Address fetch(int addressID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("Address.fetch()");

		Address result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT address_id ");
			query.append(", address_type_id ");
			query.append(", company_id ");
			query.append(", address_name ");
			query.append(", street1 ");
			query.append(", street2 ");
			query.append(", street3 ");
			query.append(", city ");
			query.append(", state ");
			query.append(", zip ");
			query.append(", ext_address_id ");
			query.append(", work_site_contact_id ");
			query.append(", bldg_mgmt_contact_id ");
			query.append(", directions ");
			query.append(", multi_level_type_id ");
			query.append(", passage_size ");
			query.append(", floor_prot_type_id ");
			query.append(", loading_dock_type_id ");
			query.append(", security_type_id ");
			query.append(", date_created ");
			query.append(", created_by ");
			query.append(", date_modified ");
			query.append(", modified_by ");
			query.append("FROM addresses ");
			query.append("WHERE (address_id = ").append(addressID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new Address();
				result.setAddressID(rs.getInt(1));
				result.setAddressTypeID(rs.getInt(2));
				result.setCompanyID(rs.getInt(3));
				result.setAddressName(rs.getString(4));
				result.setStreet1(rs.getString(5));
				result.setStreet2(rs.getString(6));
				result.setStreet3(rs.getString(7));
				result.setCity(rs.getString(8));
				result.setState(rs.getString(9));
				result.setZip(rs.getString(10));
				result.setExtAddressID(rs.getString(11));
				result.setWorkSiteContactID(rs.getInt(12));
				result.setBldgMgmtContactID(rs.getInt(13));
				result.setDirections(rs.getString(14));
				result.setMultiLevelTypeID(rs.getInt(15));
				result.setPassageSize(rs.getString(16));
				result.setFloorProtTypeID(rs.getInt(17));
				result.setLoadingDockTypeID(rs.getInt(18));
				result.setSecurityTypeID(rs.getInt(19));
				result.setDateCreated(rs.getDate(20));
				result.setCreatedBy(rs.getInt(21));
				result.setDateModified(rs.getDate(22));
				result.setModifiedBy(rs.getInt(23));
			}
			else
			{
				Diagnostics.error("Error in Address.fetch(), Could not find Address; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Address.fetch()");
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
		Diagnostics.trace("Address.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE addresses ");
			update.append("SET address_type_id = ").append(this.getAddressTypeID());
			update.append(", company_id = ").append(this.getCompanyID());
			update.append(", address_name = ").append(conn.toSQLString(StringUtil.truncate(this.getAddressName(), 50)));
			update.append(", street1 = ").append(conn.toSQLString(StringUtil.truncate(this.getStreet1(), 200)));
			update.append(", street2 = ").append(conn.toSQLString(StringUtil.truncate(this.getStreet2(), 200)));
			update.append(", street3 = ").append(conn.toSQLString(StringUtil.truncate(this.getStreet3(), 200)));
			update.append(", city = ").append(conn.toSQLString(StringUtil.truncate(this.getCity(), 200)));
			update.append(", state = ").append(conn.toSQLString(StringUtil.truncate(this.getState(), 2)));
			update.append(", zip = ").append(conn.toSQLString(StringUtil.truncate(this.getZip(), 10)));
			update.append(", ext_address_id = ").append(conn.toSQLString(StringUtil.truncate(this.getExtAddressID(), 30)));
			update.append(", work_site_contact_id = ").append(this.getWorkSiteContactID());
			update.append(", bldg_mgmt_contact_id = ").append(this.getBldgMgmtContactID());
			update.append(", directions = ").append(conn.toSQLString(StringUtil.truncate(this.getDirections(), 500)));
			update.append(", multi_level_type_id = ").append(this.getMultiLevelTypeID());
			update.append(", passage_size = ").append(conn.toSQLString(StringUtil.truncate(this.getPassageSize(), 50)));
			update.append(", floor_prot_type_id = ").append(this.getFloorProtTypeID());
			update.append(", loading_dock_type_id = ").append(this.getLoadingDockTypeID());
			update.append(", security_type_id = ").append(this.getSecurityTypeID());
			update.append(", date_created = ").append(conn.toSQLString(this.getDateCreated()));
			update.append(", created_by = ").append(this.getCreatedBy());
			update.append(", date_modified = ").append(conn.toSQLString(this.getDateModified()));
			update.append(", modified_by = ").append(this.getModifiedBy());
			update.append("WHERE (address_id = ").append(this.getAddressID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Address.internalUpdate()");
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
		Diagnostics.trace("Address.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO addresses (");
				insert.append("address_type_id");
				insert.append(", company_id");
				insert.append(", address_name");
				insert.append(", street1");
				insert.append(", street2");
				insert.append(", street3");
				insert.append(", city");
				insert.append(", state");
				insert.append(", zip");
				insert.append(", ext_address_id");
				insert.append(", work_site_contact_id");
				insert.append(", bldg_mgmt_contact_id");
				insert.append(", directions");
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
				insert.append(this.getAddressTypeID());
				insert.append(", ").append(this.getCompanyID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getAddressName(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getStreet1(), 200)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getStreet2(), 200)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getStreet3(), 200)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCity(), 200)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getState(), 2)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getZip(), 10)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getExtAddressID(), 30)));
				insert.append(", ").append(this.getWorkSiteContactID());
				insert.append(", ").append(this.getBldgMgmtContactID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getDirections(), 500)));
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
				insert.append("INSERT INTO addresses (");
				insert.append("address_id");
				insert.append(", address_type_id");
				insert.append(", company_id");
				insert.append(", address_name");
				insert.append(", street1");
				insert.append(", street2");
				insert.append(", street3");
				insert.append(", city");
				insert.append(", state");
				insert.append(", zip");
				insert.append(", ext_address_id");
				insert.append(", work_site_contact_id");
				insert.append(", bldg_mgmt_contact_id");
				insert.append(", directions");
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
				insert.append(this.getAddressID());
				insert.append(", ").append(this.getAddressTypeID());
				insert.append(", ").append(this.getCompanyID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getAddressName(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getStreet1(), 200)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getStreet2(), 200)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getStreet3(), 200)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCity(), 200)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getState(), 2)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getZip(), 10)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getExtAddressID(), 30)));
				insert.append(", ").append(this.getWorkSiteContactID());
				insert.append(", ").append(this.getBldgMgmtContactID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getDirections(), 500)));
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
				addressID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Address.internalInsert()");
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
		Diagnostics.trace("Address.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM addresses ");
			delete.append("WHERE (address_id = ").append(this.getAddressID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Address.internalDelete()");
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
		if (this.getAddressID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("Address:\n");
		result.append("  address_id = ").append(this.getAddressID()).append("\n");
		result.append("  address_type_id = ").append(this.getAddressTypeID()).append("\n");
		result.append("  company_id = ").append(this.getCompanyID()).append("\n");
		result.append("  address_name = ").append(this.getAddressName()).append("\n");
		result.append("  street1 = ").append(this.getStreet1()).append("\n");
		result.append("  street2 = ").append(this.getStreet2()).append("\n");
		result.append("  street3 = ").append(this.getStreet3()).append("\n");
		result.append("  city = ").append(this.getCity()).append("\n");
		result.append("  state = ").append(this.getState()).append("\n");
		result.append("  zip = ").append(this.getZip()).append("\n");
		result.append("  ext_address_id = ").append(this.getExtAddressID()).append("\n");
		result.append("  work_site_contact_id = ").append(this.getWorkSiteContactID()).append("\n");
		result.append("  bldg_mgmt_contact_id = ").append(this.getBldgMgmtContactID()).append("\n");
		result.append("  directions = ").append(this.getDirections()).append("\n");
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


	public int getAddressID()
	{
		return addressID;
	}

	public int getAddressTypeID()
	{
		return addressTypeID;
	}

	public int getCompanyID()
	{
		return companyID;
	}

	public String getAddressName()
	{
		return addressName;
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

	public String getExtAddressID()
	{
		return extAddressID;
	}

	public int getWorkSiteContactID()
	{
		return workSiteContactID;
	}

	public int getBldgMgmtContactID()
	{
		return bldgMgmtContactID;
	}

	public String getDirections()
	{
		return directions;
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

	public void setAddressID(int addressIDIn)
	{
		addressID = addressIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setAddressTypeID(int addressTypeIDIn)
	{
		addressTypeID = addressTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setCompanyID(int companyIDIn)
	{
		companyID = companyIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setAddressName(String addressNameIn)
	{
		addressName = addressNameIn;
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

	public void setExtAddressID(String extAddressIDIn)
	{
		extAddressID = extAddressIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setWorkSiteContactID(int workSiteContactIDIn)
	{
		workSiteContactID = workSiteContactIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setBldgMgmtContactID(int bldgMgmtContactIDIn)
	{
		bldgMgmtContactID = bldgMgmtContactIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setDirections(String directionsIn)
	{
		directions = directionsIn;
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
