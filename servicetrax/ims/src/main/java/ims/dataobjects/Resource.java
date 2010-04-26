package ims.dataobjects;

import java.util.Date;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class Resource extends AbstractDatabaseObject
{

	private int resourceID;
	private String resourceNo;
	private String name;
	private int resCategoryTypeID;
	private int resourceTypeID;
	private int userID;
	private String empExtID;
	private String vendorExtID;
	private String activeFlag;
	private String supervisorFlag;
	private String pin;
	private Date dateCreated;
	private int createdBy;
	private Date dateModified;
	private String modifiedBy;

	public Resource()
	{
		super();
	}


	public static Resource fetch(String resourceID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(resourceID), ic, null);
	}

	public static Resource fetch(String resourceID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(resourceID), ic, resourceName);
	}

	public static Resource fetch(int resourceID, InvocationContext ic)
	{
		 return fetch(resourceID, ic, null);
	}

	public static Resource fetch(int resourceID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("Resource.fetch()");

		Resource result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT resource_id ");
			query.append(", resource_no ");
			query.append(", name ");
			query.append(", res_category_type_id ");
			query.append(", resource_type_id ");
			query.append(", user_id ");
			query.append(", emp_ext_id ");
			query.append(", vendor_ext_id ");
			query.append(", active_flag ");
			query.append(", supervisor_flag ");
			query.append(", pin ");
			query.append(", date_created ");
			query.append(", created_by ");
			query.append(", date_modified ");
			query.append(", modified_by ");
			query.append("FROM resources ");
			query.append("WHERE (resource_id = ").append(resourceID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new Resource();
				result.setResourceID(rs.getInt(1));
				result.setResourceNo(rs.getString(2));
				result.setName(rs.getString(3));
				result.setResCategoryTypeID(rs.getInt(4));
				result.setResourceTypeID(rs.getInt(5));
				result.setUserID(rs.getInt(6));
				result.setEmpExtID(rs.getString(7));
				result.setVendorExtID(rs.getString(8));
				result.setActiveFlag(rs.getString(9));
				result.setSupervisorFlag(rs.getString(10));
				result.setPin(rs.getString(11));
				result.setDateCreated(rs.getDate(12));
				result.setCreatedBy(rs.getInt(13));
				result.setDateModified(rs.getDate(14));
				result.setModifiedBy(rs.getString(15));
			}
			else
			{
				Diagnostics.error("Error in Resource.fetch(), Could not find Resource; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Resource.fetch()");
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
		Diagnostics.trace("Resource.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE resources ");
			update.append("SET resource_no = ").append(conn.toSQLString(StringUtil.truncate(this.getResourceNo(), 50)));
			update.append(", name = ").append(conn.toSQLString(StringUtil.truncate(this.getName(), 200)));
			update.append(", res_category_type_id = ").append(this.getResCategoryTypeID());
			update.append(", resource_type_id = ").append(this.getResourceTypeID());
			update.append(", user_id = ").append(this.getUserID());
			update.append(", emp_ext_id = ").append(conn.toSQLString(StringUtil.truncate(this.getEmpExtID(), 30)));
			update.append(", vendor_ext_id = ").append(conn.toSQLString(StringUtil.truncate(this.getVendorExtID(), 30)));
			update.append(", active_flag = ").append(conn.toSQLString(StringUtil.truncate(this.getActiveFlag(), 1)));
			update.append(", supervisor_flag = ").append(conn.toSQLString(StringUtil.truncate(this.getSupervisorFlag(), 1)));
			update.append(", pin = ").append(conn.toSQLString(StringUtil.truncate(this.getPin(), 10)));
			update.append(", date_created = ").append(conn.toSQLString(this.getDateCreated()));
			update.append(", created_by = ").append(this.getCreatedBy());
			update.append(", date_modified = ").append(conn.toSQLString(this.getDateModified()));
			update.append(", modified_by = ").append(conn.toSQLString(StringUtil.truncate(this.getModifiedBy(), 30)));
			update.append("WHERE (resource_id = ").append(this.getResourceID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Resource.internalUpdate()");
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
		Diagnostics.trace("Resource.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO resources (");
				insert.append("resource_no");
				insert.append(", name");
				insert.append(", res_category_type_id");
				insert.append(", resource_type_id");
				insert.append(", user_id");
				insert.append(", emp_ext_id");
				insert.append(", vendor_ext_id");
				insert.append(", active_flag");
				insert.append(", supervisor_flag");
				insert.append(", pin");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(conn.toSQLString(StringUtil.truncate(this.getResourceNo(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getName(), 200)));
				insert.append(", ").append(this.getResCategoryTypeID());
				insert.append(", ").append(this.getResourceTypeID());
				insert.append(", ").append(this.getUserID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getEmpExtID(), 30)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getVendorExtID(), 30)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getActiveFlag(), 1)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getSupervisorFlag(), 1)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getPin(), 10)));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getModifiedBy(), 30)));
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO resources (");
				insert.append("resource_id");
				insert.append(", resource_no");
				insert.append(", name");
				insert.append(", res_category_type_id");
				insert.append(", resource_type_id");
				insert.append(", user_id");
				insert.append(", emp_ext_id");
				insert.append(", vendor_ext_id");
				insert.append(", active_flag");
				insert.append(", supervisor_flag");
				insert.append(", pin");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getResourceID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getResourceNo(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getName(), 200)));
				insert.append(", ").append(this.getResCategoryTypeID());
				insert.append(", ").append(this.getResourceTypeID());
				insert.append(", ").append(this.getUserID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getEmpExtID(), 30)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getVendorExtID(), 30)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getActiveFlag(), 1)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getSupervisorFlag(), 1)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getPin(), 10)));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getModifiedBy(), 30)));
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				resourceID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Resource.internalInsert()");
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
		Diagnostics.trace("Resource.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM resources ");
			delete.append("WHERE (resource_id = ").append(this.getResourceID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Resource.internalDelete()");
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
		if (this.getResourceID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("Resource:\n");
		result.append("  resource_id = ").append(this.getResourceID()).append("\n");
		result.append("  resource_no = ").append(this.getResourceNo()).append("\n");
		result.append("  name = ").append(this.getName()).append("\n");
		result.append("  res_category_type_id = ").append(this.getResCategoryTypeID()).append("\n");
		result.append("  resource_type_id = ").append(this.getResourceTypeID()).append("\n");
		result.append("  user_id = ").append(this.getUserID()).append("\n");
		result.append("  emp_ext_id = ").append(this.getEmpExtID()).append("\n");
		result.append("  vendor_ext_id = ").append(this.getVendorExtID()).append("\n");
		result.append("  active_flag = ").append(this.getActiveFlag()).append("\n");
		result.append("  supervisor_flag = ").append(this.getSupervisorFlag()).append("\n");
		result.append("  pin = ").append(this.getPin()).append("\n");
		result.append("  date_created = ").append(this.getDateCreated()).append("\n");
		result.append("  created_by = ").append(this.getCreatedBy()).append("\n");
		result.append("  date_modified = ").append(this.getDateModified()).append("\n");
		result.append("  modified_by = ").append(this.getModifiedBy()).append("\n");
		return result.toString();
	}


	public int getResourceID()
	{
		return resourceID;
	}

	public String getResourceNo()
	{
		return resourceNo;
	}

	public String getName()
	{
		return name;
	}

	public int getResCategoryTypeID()
	{
		return resCategoryTypeID;
	}

	public int getResourceTypeID()
	{
		return resourceTypeID;
	}

	public int getUserID()
	{
		return userID;
	}

	public String getEmpExtID()
	{
		return empExtID;
	}

	public String getVendorExtID()
	{
		return vendorExtID;
	}

	public String getActiveFlag()
	{
		return activeFlag;
	}

	public String getSupervisorFlag()
	{
		return supervisorFlag;
	}

	public String getPin()
	{
		return pin;
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

	public String getModifiedBy()
	{
		return modifiedBy;
	}

	public void setResourceID(int resourceIDIn)
	{
		resourceID = resourceIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setResourceNo(String resourceNoIn)
	{
		resourceNo = resourceNoIn;
		handleAction(MODIFY_ACTION);
	}

	public void setName(String nameIn)
	{
		name = nameIn;
		handleAction(MODIFY_ACTION);
	}

	public void setResCategoryTypeID(int resCategoryTypeIDIn)
	{
		resCategoryTypeID = resCategoryTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setResourceTypeID(int resourceTypeIDIn)
	{
		resourceTypeID = resourceTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setUserID(int userIDIn)
	{
		userID = userIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setEmpExtID(String empExtIDIn)
	{
		empExtID = empExtIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setVendorExtID(String vendorExtIDIn)
	{
		vendorExtID = vendorExtIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setActiveFlag(String activeFlagIn)
	{
		activeFlag = activeFlagIn;
		handleAction(MODIFY_ACTION);
	}

	public void setSupervisorFlag(String supervisorFlagIn)
	{
		supervisorFlag = supervisorFlagIn;
		handleAction(MODIFY_ACTION);
	}

	public void setPin(String pinIn)
	{
		pin = pinIn;
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

	public void setModifiedBy(String modifiedByIn)
	{
		modifiedBy = modifiedByIn;
		handleAction(MODIFY_ACTION);
	}
}
