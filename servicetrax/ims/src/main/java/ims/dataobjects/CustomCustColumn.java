package ims.dataobjects;

import java.util.Date;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class CustomCustColumn extends AbstractDatabaseObject
{

	private int customCustColID;
	private String extJobNameID;
	private String jobName;
	private String columnDesc;
	private int colSequence;
	private String enabled;
	private int createdBy;
	private Date dateCreated;
	private int modifiedBy;
	private Date dateModified;

	public CustomCustColumn()
	{
		super();
	}


	public static CustomCustColumn fetch(String customCustColID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(customCustColID), ic, null);
	}

	public static CustomCustColumn fetch(String customCustColID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(customCustColID), ic, resourceName);
	}

	public static CustomCustColumn fetch(int customCustColID, InvocationContext ic)
	{
		 return fetch(customCustColID, ic, null);
	}

	public static CustomCustColumn fetch(int customCustColID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("CustomCustColumn.fetch()");

		CustomCustColumn result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT custom_cust_col_id ");
			query.append(", ext_job_name_id ");
			query.append(", job_name ");
			query.append(", column_desc ");
			query.append(", col_sequence ");
			query.append(", enabled ");
			query.append(", created_by ");
			query.append(", date_created ");
			query.append(", modified_by ");
			query.append(", date_modified ");
			query.append("FROM custom_cust_columns ");
			query.append("WHERE (custom_cust_col_id = ").append(customCustColID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new CustomCustColumn();
				result.setCustomCustColID(rs.getInt(1));
				result.setExtJobNameID(rs.getString(2));
				result.setJobName(rs.getString(3));
				result.setColumnDesc(rs.getString(4));
				result.setColSequence(rs.getInt(5));
				result.setEnabled(rs.getString(6));
				result.setCreatedBy(rs.getInt(7));
				result.setDateCreated(rs.getDate(8));
				result.setModifiedBy(rs.getInt(9));
				result.setDateModified(rs.getDate(10));
			}
			else
			{
				Diagnostics.error("Error in CustomCustColumn.fetch(), Could not find CustomCustColumn; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in CustomCustColumn.fetch()");
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
		Diagnostics.trace("CustomCustColumn.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE custom_cust_columns ");
			update.append("SET ext_job_name_id = ").append(conn.toSQLString(StringUtil.truncate(this.getExtJobNameID(), 15)));
			update.append(", job_name = ").append(conn.toSQLString(StringUtil.truncate(this.getJobName(), 100)));
			update.append(", column_desc = ").append(conn.toSQLString(StringUtil.truncate(this.getColumnDesc(), 25)));
			update.append(", col_sequence = ").append(this.getColSequence());
			update.append(", enabled = ").append(conn.toSQLString(StringUtil.truncate(this.getEnabled(), 1)));
			update.append(", created_by = ").append(this.getCreatedBy());
			update.append(", date_created = ").append(conn.toSQLString(this.getDateCreated()));
			update.append(", modified_by = ").append(this.getModifiedBy());
			update.append(", date_modified = ").append(conn.toSQLString(this.getDateModified()));
			update.append("WHERE (custom_cust_col_id = ").append(this.getCustomCustColID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in CustomCustColumn.internalUpdate()");
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
		Diagnostics.trace("CustomCustColumn.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO custom_cust_columns (");
				insert.append("ext_job_name_id");
				insert.append(", job_name");
				insert.append(", column_desc");
				insert.append(", col_sequence");
				insert.append(", enabled");
				insert.append(", created_by");
				insert.append(", date_created");
				insert.append(", modified_by");
				insert.append(", date_modified");
				insert.append(") VALUES (");
				insert.append(conn.toSQLString(StringUtil.truncate(this.getExtJobNameID(), 15)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getJobName(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getColumnDesc(), 25)));
				insert.append(", ").append(this.getColSequence());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getEnabled(), 1)));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO custom_cust_columns (");
				insert.append("custom_cust_col_id");
				insert.append(", ext_job_name_id");
				insert.append(", job_name");
				insert.append(", column_desc");
				insert.append(", col_sequence");
				insert.append(", enabled");
				insert.append(", created_by");
				insert.append(", date_created");
				insert.append(", modified_by");
				insert.append(", date_modified");
				insert.append(") VALUES (");
				insert.append(this.getCustomCustColID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getExtJobNameID(), 15)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getJobName(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getColumnDesc(), 25)));
				insert.append(", ").append(this.getColSequence());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getEnabled(), 1)));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				customCustColID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in CustomCustColumn.internalInsert()");
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
		Diagnostics.trace("CustomCustColumn.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM custom_cust_columns ");
			delete.append("WHERE (custom_cust_col_id = ").append(this.getCustomCustColID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in CustomCustColumn.internalDelete()");
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
		if (this.getCustomCustColID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("CustomCustColumn:\n");
		result.append("  custom_cust_col_id = ").append(this.getCustomCustColID()).append("\n");
		result.append("  ext_job_name_id = ").append(this.getExtJobNameID()).append("\n");
		result.append("  job_name = ").append(this.getJobName()).append("\n");
		result.append("  column_desc = ").append(this.getColumnDesc()).append("\n");
		result.append("  col_sequence = ").append(this.getColSequence()).append("\n");
		result.append("  enabled = ").append(this.getEnabled()).append("\n");
		result.append("  created_by = ").append(this.getCreatedBy()).append("\n");
		result.append("  date_created = ").append(this.getDateCreated()).append("\n");
		result.append("  modified_by = ").append(this.getModifiedBy()).append("\n");
		result.append("  date_modified = ").append(this.getDateModified()).append("\n");
		return result.toString();
	}


	public int getCustomCustColID()
	{
		return customCustColID;
	}

	public String getExtJobNameID()
	{
		return extJobNameID;
	}

	public String getJobName()
	{
		return jobName;
	}

	public String getColumnDesc()
	{
		return columnDesc;
	}

	public int getColSequence()
	{
		return colSequence;
	}

	public String getEnabled()
	{
		return enabled;
	}

	public int getCreatedBy()
	{
		return createdBy;
	}

	public Date getDateCreated()
	{
		return dateCreated;
	}

	public int getModifiedBy()
	{
		return modifiedBy;
	}

	public Date getDateModified()
	{
		return dateModified;
	}

	public void setCustomCustColID(int customCustColIDIn)
	{
		customCustColID = customCustColIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setExtJobNameID(String extJobNameIDIn)
	{
		extJobNameID = extJobNameIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setJobName(String jobNameIn)
	{
		jobName = jobNameIn;
		handleAction(MODIFY_ACTION);
	}

	public void setColumnDesc(String columnDescIn)
	{
		columnDesc = columnDescIn;
		handleAction(MODIFY_ACTION);
	}

	public void setColSequence(int colSequenceIn)
	{
		colSequence = colSequenceIn;
		handleAction(MODIFY_ACTION);
	}

	public void setEnabled(String enabledIn)
	{
		enabled = enabledIn;
		handleAction(MODIFY_ACTION);
	}

	public void setCreatedBy(int createdByIn)
	{
		createdBy = createdByIn;
		handleAction(MODIFY_ACTION);
	}

	public void setDateCreated(Date dateCreatedIn)
	{
		dateCreated = dateCreatedIn;
		handleAction(MODIFY_ACTION);
	}

	public void setModifiedBy(int modifiedByIn)
	{
		modifiedBy = modifiedByIn;
		handleAction(MODIFY_ACTION);
	}

	public void setDateModified(Date dateModifiedIn)
	{
		dateModified = dateModifiedIn;
		handleAction(MODIFY_ACTION);
	}
}
