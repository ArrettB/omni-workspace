package ims.dataobjects;

import java.util.Date;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class Organization extends AbstractDatabaseObject
{

	private int organizationID;
	private String name;
	private String resourceName;
	private String code;
	private String dbPrefix;
	private String payCodeTable;
	private String extDirectDealerID;
	private Date dateCreated;
	private int createdBy;
	private Date dateModified;
	private int modifiedBy;

	public Organization()
	{
		super();
	}


	public static Organization fetch(String organizationID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(organizationID), ic, null);
	}

	public static Organization fetch(String organizationID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(organizationID), ic, resourceName);
	}

	public static Organization fetch(int organizationID, InvocationContext ic)
	{
		 return fetch(organizationID, ic, null);
	}

	public static Organization fetch(int organizationID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("Organization.fetch()");

		Organization result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT organization_id ");
			query.append(", name ");
			query.append(", code ");
			query.append(", resource_name ");
			query.append(", db_prefix ");
			query.append(", pay_code_table ");
			query.append(", ext_direct_dealer_id ");
			query.append(", date_created ");
			query.append(", created_by ");
			query.append(", date_modified ");
			query.append(", modified_by ");
			query.append("FROM organizations ");
			query.append("WHERE organization_id = ?");

			QueryResults rs = null;
			try
			{
				rs = conn.select(query, organizationID);
				if (rs.next())
				{
					result = new Organization();
					result.setOrganizationID(rs.getInt("organization_id"));
					result.setName(rs.getString("name"));
					result.setCode(rs.getString("code"));
					result.setResourceName(rs.getString("resource_name"));
					result.setDbPrefix(rs.getString("db_prefix"));
					result.setPayCodeTable(rs.getString("pay_code_table"));				
					result.setExtDirectDealerID(rs.getString("ext_direct_dealer_id"));
					result.setDateCreated(rs.getDate("date_created"));
					result.setCreatedBy(rs.getInt("created_by"));
					result.setDateModified(rs.getDate("date_modified"));
					result.setModifiedBy(rs.getInt("modified_by"));
				}
				else
				{
					Diagnostics.error("Error in Organization.fetch(), Could not find Organization; Select was:" + query);
				}
			}
			finally
			{
				if (rs != null) rs.close();
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Organization.fetch()");
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
		Diagnostics.trace("Organization.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE organizations ");
			update.append("SET name = ").append(conn.toSQLString(StringUtil.truncate(getName(), 100)));
			update.append(", code = ").append(conn.toSQLString(StringUtil.truncate(getCode(), 50)));
			update.append(", resource_name = ").append(conn.toSQLString(StringUtil.truncate(this.getResourceName(), 20)));
			update.append(", db_prefix = ").append(conn.toSQLString(StringUtil.truncate(this.getDbPrefix(), 30)));
			update.append(", pay_code_table = ").append(conn.toSQLString(StringUtil.truncate(this.getPayCodeTable(), 30)));
			update.append(", date_created = ").append(conn.toSQLString(this.getDateCreated()));
			update.append(", created_by = ").append(this.getCreatedBy());
			update.append(", date_modified = ").append(conn.toSQLString(this.getDateModified()));
			update.append(", modified_by = ").append(this.getModifiedBy());
			update.append("WHERE (organization_id = ").append(this.getOrganizationID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Organization.internalUpdate()");
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
		Diagnostics.trace("Organization.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO organizations (");
				insert.append("name");
				insert.append(", code");
				insert.append(", resource_name");
				insert.append(", db_prefix");
				insert.append(", pay_code_table");				
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(conn.toSQLString(StringUtil.truncate(this.getName(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCode(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getResourceName(), 20)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getDbPrefix(), 30)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getPayCodeTable(), 50)));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO organizations (");
				insert.append("organization_id");
				insert.append(", name");
				insert.append(", code");
				insert.append(", resource_name");
				insert.append(", db_prefix");
				insert.append(", pay_code_table");				
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getOrganizationID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getName(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCode(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getResourceName(), 20)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getDbPrefix(), 30)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getPayCodeTable(), 50)));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				organizationID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Organization.internalInsert()");
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
		Diagnostics.trace("Organization.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM organizations ");
			delete.append("WHERE (organization_id = ").append(this.getOrganizationID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Organization.internalDelete()");
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
		if (this.getOrganizationID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("Organization:\n");
		result.append("  organization_id = ").append(this.getOrganizationID()).append("\n");
		result.append("  name = ").append(this.getName()).append("\n");
		result.append("  code = ").append(this.getCode()).append("\n");
		result.append("  resource_name = ").append(this.getResourceName()).append("\n");
		result.append("  db_prefix = ").append(this.getDbPrefix()).append("\n");
		result.append("  pay_code_table = ").append(this.getPayCodeTable()).append("\n");
		result.append("  ext_direct_dealer)id = ").append(this.getExtDirectDealerID()).append("\n");
		result.append("  date_created = ").append(this.getDateCreated()).append("\n");
		result.append("  created_by = ").append(this.getCreatedBy()).append("\n");
		result.append("  date_modified = ").append(this.getDateModified()).append("\n");
		result.append("  modified_by = ").append(this.getModifiedBy()).append("\n");
		return result.toString();
	}


	public int getOrganizationID()
	{
		return organizationID;
	}

	public String getName()
	{
		return name;
	}

	public String getCode()
	{
		return code;
	}

	public String getResourceName()
	{
		return resourceName;
	}

	public String getDbPrefix()
	{
		return dbPrefix;
	}

	public String getPayCodeTable()
	{
		return payCodeTable;
	}

	public String getExtDirectDealerID()
	{
		return extDirectDealerID;
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

	public void setOrganizationID(int organizationIDIn)
	{
		organizationID = organizationIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setName(String nameIn)
	{
		name = nameIn;
		handleAction(MODIFY_ACTION);
	}

	public void setCode(String code)
	{
		this.code = code;
		handleAction(MODIFY_ACTION);
	}

	public void setResourceName(String resourceNameIn)
	{
		resourceName = resourceNameIn;
		handleAction(MODIFY_ACTION);
	}

	public void setDbPrefix(String dbPrefixIn)
	{
		dbPrefix = dbPrefixIn;
		handleAction(MODIFY_ACTION);
	}

	public void setPayCodeTable(String payCodeTableIn)
	{
		payCodeTable = payCodeTableIn;
		handleAction(MODIFY_ACTION);
	}

	public void setExtDirectDealerID(String extDirectDealerIDIn)
	{
		extDirectDealerID = extDirectDealerIDIn;
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
