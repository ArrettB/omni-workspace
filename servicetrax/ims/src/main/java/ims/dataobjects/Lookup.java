package ims.dataobjects;

import java.util.Date;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class Lookup extends AbstractDatabaseObject
{

	private int lookupID;
	private int lookupTypeID;
	private String code;
	private String name;
	private int sequenceNo;
	private String activeFlag;
	private String updatableFlag;
	private int parentLookupID;
	private String extID;
	private String attribute1;
	private String attribute2;
	private String attribute3;
	private Date dateCreated;
	private int createdBy;
	private Date dateModified;
	private int modifiedBy;

	public Lookup()
	{
		super();
	}


	public static Lookup fetch(String lookupID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(lookupID), ic, null);
	}

	public static Lookup fetch(String lookupID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(lookupID), ic, resourceName);
	}

	public static Lookup fetch(int lookupID, InvocationContext ic)
	{
		 return fetch(lookupID, ic, null);
	}

	public static Lookup fetch(int lookupID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("Lookup.fetch()");

		Lookup result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT lookup_id ");
			query.append(", lookup_type_id ");
			query.append(", code ");
			query.append(", name ");
			query.append(", sequence_no ");
			query.append(", active_flag ");
			query.append(", updatable_flag ");
			query.append(", parent_lookup_id ");
			query.append(", ext_id ");
			query.append(", attribute1 ");
			query.append(", attribute2 ");
			query.append(", attribute3 ");
			query.append(", date_created ");
			query.append(", created_by ");
			query.append(", date_modified ");
			query.append(", modified_by ");
			query.append("FROM lookups ");
			query.append("WHERE (lookup_id = ").append(lookupID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new Lookup();
				result.setLookupID(rs.getInt(1));
				result.setLookupTypeID(rs.getInt(2));
				result.setCode(rs.getString(3));
				result.setName(rs.getString(4));
				result.setSequenceNo(rs.getInt(5));
				result.setActiveFlag(rs.getString(6));
				result.setUpdatableFlag(rs.getString(7));
				result.setParentLookupID(rs.getInt(8));
				result.setExtID(rs.getString(9));
				result.setAttribute1(rs.getString(10));
				result.setAttribute2(rs.getString(11));
				result.setAttribute3(rs.getString(12));
				result.setDateCreated(rs.getDate(13));
				result.setCreatedBy(rs.getInt(14));
				result.setDateModified(rs.getDate(15));
				result.setModifiedBy(rs.getInt(16));
			}
			else
			{
				Diagnostics.error("Error in Lookup.fetch(), Could not find Lookup; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Lookup.fetch()");
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
		Diagnostics.trace("Lookup.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE lookups ");
			update.append("SET lookup_type_id = ").append(this.getLookupTypeID());
			update.append(", code = ").append(conn.toSQLString(StringUtil.truncate(this.getCode(), 30)));
			update.append(", name = ").append(conn.toSQLString(StringUtil.truncate(this.getName(), 100)));
			update.append(", sequence_no = ").append(this.getSequenceNo());
			update.append(", active_flag = ").append(conn.toSQLString(StringUtil.truncate(this.getActiveFlag(), 1)));
			update.append(", updatable_flag = ").append(conn.toSQLString(StringUtil.truncate(this.getUpdatableFlag(), 1)));
			update.append(", parent_lookup_id = ").append(this.getParentLookupID());
			update.append(", ext_id = ").append(conn.toSQLString(StringUtil.truncate(this.getExtID(), 50)));
			update.append(", attribute1 = ").append(conn.toSQLString(StringUtil.truncate(this.getAttribute1(), 100)));
			update.append(", attribute2 = ").append(conn.toSQLString(StringUtil.truncate(this.getAttribute2(), 100)));
			update.append(", attribute3 = ").append(conn.toSQLString(StringUtil.truncate(this.getAttribute3(), 100)));
			update.append(", date_created = ").append(conn.toSQLString(this.getDateCreated()));
			update.append(", created_by = ").append(this.getCreatedBy());
			update.append(", date_modified = ").append(conn.toSQLString(this.getDateModified()));
			update.append(", modified_by = ").append(this.getModifiedBy());
			update.append("WHERE (lookup_id = ").append(this.getLookupID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Lookup.internalUpdate()");
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
		Diagnostics.trace("Lookup.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO lookups (");
				insert.append("lookup_type_id");
				insert.append(", code");
				insert.append(", name");
				insert.append(", sequence_no");
				insert.append(", active_flag");
				insert.append(", updatable_flag");
				insert.append(", parent_lookup_id");
				insert.append(", ext_id");
				insert.append(", attribute1");
				insert.append(", attribute2");
				insert.append(", attribute3");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getLookupTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCode(), 30)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getName(), 100)));
				insert.append(", ").append(this.getSequenceNo());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getActiveFlag(), 1)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getUpdatableFlag(), 1)));
				insert.append(", ").append(this.getParentLookupID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getExtID(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getAttribute1(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getAttribute2(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getAttribute3(), 100)));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO lookups (");
				insert.append("lookup_id");
				insert.append(", lookup_type_id");
				insert.append(", code");
				insert.append(", name");
				insert.append(", sequence_no");
				insert.append(", active_flag");
				insert.append(", updatable_flag");
				insert.append(", parent_lookup_id");
				insert.append(", ext_id");
				insert.append(", attribute1");
				insert.append(", attribute2");
				insert.append(", attribute3");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getLookupID());
				insert.append(", ").append(this.getLookupTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCode(), 30)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getName(), 100)));
				insert.append(", ").append(this.getSequenceNo());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getActiveFlag(), 1)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getUpdatableFlag(), 1)));
				insert.append(", ").append(this.getParentLookupID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getExtID(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getAttribute1(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getAttribute2(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getAttribute3(), 100)));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				lookupID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Lookup.internalInsert()");
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
		Diagnostics.trace("Lookup.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM lookups ");
			delete.append("WHERE (lookup_id = ").append(this.getLookupID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Lookup.internalDelete()");
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
		if (this.getLookupID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("Lookup:\n");
		result.append("  lookup_id = ").append(this.getLookupID()).append("\n");
		result.append("  lookup_type_id = ").append(this.getLookupTypeID()).append("\n");
		result.append("  code = ").append(this.getCode()).append("\n");
		result.append("  name = ").append(this.getName()).append("\n");
		result.append("  sequence_no = ").append(this.getSequenceNo()).append("\n");
		result.append("  active_flag = ").append(this.getActiveFlag()).append("\n");
		result.append("  updatable_flag = ").append(this.getUpdatableFlag()).append("\n");
		result.append("  parent_lookup_id = ").append(this.getParentLookupID()).append("\n");
		result.append("  ext_id = ").append(this.getExtID()).append("\n");
		result.append("  attribute1 = ").append(this.getAttribute1()).append("\n");
		result.append("  attribute2 = ").append(this.getAttribute2()).append("\n");
		result.append("  attribute3 = ").append(this.getAttribute3()).append("\n");
		result.append("  date_created = ").append(this.getDateCreated()).append("\n");
		result.append("  created_by = ").append(this.getCreatedBy()).append("\n");
		result.append("  date_modified = ").append(this.getDateModified()).append("\n");
		result.append("  modified_by = ").append(this.getModifiedBy()).append("\n");
		return result.toString();
	}


	public int getLookupID()
	{
		return lookupID;
	}

	public int getLookupTypeID()
	{
		return lookupTypeID;
	}

	public String getCode()
	{
		return code;
	}

	public String getName()
	{
		return name;
	}

	public int getSequenceNo()
	{
		return sequenceNo;
	}

	public String getActiveFlag()
	{
		return activeFlag;
	}

	public String getUpdatableFlag()
	{
		return updatableFlag;
	}

	public int getParentLookupID()
	{
		return parentLookupID;
	}

	public String getExtID()
	{
		return extID;
	}

	public String getAttribute1()
	{
		return attribute1;
	}

	public String getAttribute2()
	{
		return attribute2;
	}

	public String getAttribute3()
	{
		return attribute3;
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

	public void setLookupID(int lookupIDIn)
	{
		lookupID = lookupIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setLookupTypeID(int lookupTypeIDIn)
	{
		lookupTypeID = lookupTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setCode(String codeIn)
	{
		code = codeIn;
		handleAction(MODIFY_ACTION);
	}

	public void setName(String nameIn)
	{
		name = nameIn;
		handleAction(MODIFY_ACTION);
	}

	public void setSequenceNo(int sequenceNoIn)
	{
		sequenceNo = sequenceNoIn;
		handleAction(MODIFY_ACTION);
	}

	public void setActiveFlag(String activeFlagIn)
	{
		activeFlag = activeFlagIn;
		handleAction(MODIFY_ACTION);
	}

	public void setUpdatableFlag(String updatableFlagIn)
	{
		updatableFlag = updatableFlagIn;
		handleAction(MODIFY_ACTION);
	}

	public void setParentLookupID(int parentLookupIDIn)
	{
		parentLookupID = parentLookupIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setExtID(String extIDIn)
	{
		extID = extIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setAttribute1(String attribute1In)
	{
		attribute1 = attribute1In;
		handleAction(MODIFY_ACTION);
	}

	public void setAttribute2(String attribute2In)
	{
		attribute2 = attribute2In;
		handleAction(MODIFY_ACTION);
	}

	public void setAttribute3(String attribute3In)
	{
		attribute3 = attribute3In;
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
