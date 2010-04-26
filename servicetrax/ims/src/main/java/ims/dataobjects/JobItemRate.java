package ims.dataobjects;

import java.util.Date;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class JobItemRate extends AbstractDatabaseObject
{

	private int jobItemRateID;
	private int jobID;
	private int itemID;
	private double rate;
	private String extRateID;
	private int uomTypeID;
	private String extUomName;
	private Date dateCreated;
	private int createdBy;
	private Date dateModified;
	private int modifiedBy;

	public JobItemRate()
	{
		super();
	}


	public static JobItemRate fetch(String jobItemRateID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(jobItemRateID), ic, null);
	}

	public static JobItemRate fetch(String jobItemRateID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(jobItemRateID), ic, resourceName);
	}

	public static JobItemRate fetch(int jobItemRateID, InvocationContext ic)
	{
		 return fetch(jobItemRateID, ic, null);
	}

	public static JobItemRate fetch(int jobItemRateID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("JobItemRate.fetch()");

		JobItemRate result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT job_item_rate_id ");
			query.append(", job_id ");
			query.append(", item_id ");
			query.append(", rate ");
			query.append(", ext_rate_id ");
			query.append(", uom_type_id ");
			query.append(", ext_uom_name ");
			query.append(", date_created ");
			query.append(", created_by ");
			query.append(", date_modified ");
			query.append(", modified_by ");
			query.append("FROM job_item_rates ");
			query.append("WHERE (job_item_rate_id = ").append(jobItemRateID).append(") ");

			QueryResults rs = null;
			try
			{
				rs = conn.resultsQueryEx(query);
				if (rs.next())
				{
					result = new JobItemRate();
					result.setJobItemRateID(rs.getInt(1));
					result.setJobID(rs.getInt(2));
					result.setItemID(rs.getInt(3));
					result.setRate(rs.getDouble(4));
					result.setExtRateID(rs.getString(5));
					result.setUomTypeID(rs.getInt(6));
					result.setExtUomName(rs.getString(7));
					result.setDateCreated(rs.getDate(8));
					result.setCreatedBy(rs.getInt(9));
					result.setDateModified(rs.getDate(10));
					result.setModifiedBy(rs.getInt(11));
				}
				else
				{
					Diagnostics.error("Error in JobItemRate.fetch(), Could not find JobItemRate; Select was:" + query);
				}
			}
			finally
			{
				if (rs != null)
					rs.close();
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in JobItemRate.fetch()");
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
		Diagnostics.trace("JobItemRate.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE job_item_rates ");
			update.append("SET job_id = ").append(this.getJobID());
			update.append(", item_id = ").append(this.getItemID());
			update.append(", rate = ").append(this.getRate());
			update.append(", ext_rate_id = ").append(conn.toSQLString(StringUtil.truncate(this.getExtRateID(), 15)));
			update.append(", uom_type_id = ").append(this.getUomTypeID());
			update.append(", ext_uom_name = ").append(conn.toSQLString(StringUtil.truncate(this.getExtUomName(), 50)));
			update.append(", date_created = ").append(conn.toSQLString(this.getDateCreated()));
			update.append(", created_by = ").append(this.getCreatedBy());
			update.append(", date_modified = ").append(conn.toSQLString(this.getDateModified()));
			update.append(", modified_by = ").append(this.getModifiedBy());
			update.append("WHERE (job_item_rate_id = ").append(this.getJobItemRateID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in JobItemRate.internalUpdate()");
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
		Diagnostics.trace("JobItemRate.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO job_item_rates (");
				insert.append("job_id");
				insert.append(", item_id");
				insert.append(", rate");
				insert.append(", ext_rate_id");
				insert.append(", uom_type_id");
				insert.append(", ext_uom_name");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getJobID());
				insert.append(", ").append(this.getItemID());
				insert.append(", ").append(this.getRate());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getExtRateID(), 15)));
				insert.append(", ").append(this.getUomTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getExtUomName(), 50)));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO job_item_rates (");
				insert.append("job_item_rate_id");
				insert.append(", job_id");
				insert.append(", item_id");
				insert.append(", rate");
				insert.append(", ext_rate_id");
				insert.append(", uom_type_id");
				insert.append(", ext_uom_name");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getJobItemRateID());
				insert.append(", ").append(this.getJobID());
				insert.append(", ").append(this.getItemID());
				insert.append(", ").append(this.getRate());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getExtRateID(), 15)));
				insert.append(", ").append(this.getUomTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getExtUomName(), 50)));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				jobItemRateID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in JobItemRate.internalInsert()");
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
		Diagnostics.trace("JobItemRate.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM job_item_rates ");
			delete.append("WHERE (job_item_rate_id = ").append(this.getJobItemRateID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in JobItemRate.internalDelete()");
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
		if (this.getJobItemRateID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("JobItemRate:\n");
		result.append("  job_item_rate_id = ").append(this.getJobItemRateID()).append("\n");
		result.append("  job_id = ").append(this.getJobID()).append("\n");
		result.append("  item_id = ").append(this.getItemID()).append("\n");
		result.append("  rate = ").append(this.getRate()).append("\n");
		result.append("  ext_rate_id = ").append(this.getExtRateID()).append("\n");
		result.append("  uom_type_id = ").append(this.getUomTypeID()).append("\n");
		result.append("  ext_uom_name = ").append(this.getExtUomName()).append("\n");
		result.append("  date_created = ").append(this.getDateCreated()).append("\n");
		result.append("  created_by = ").append(this.getCreatedBy()).append("\n");
		result.append("  date_modified = ").append(this.getDateModified()).append("\n");
		result.append("  modified_by = ").append(this.getModifiedBy()).append("\n");
		return result.toString();
	}


	public int getJobItemRateID()
	{
		return jobItemRateID;
	}

	public int getJobID()
	{
		return jobID;
	}

	public int getItemID()
	{
		return itemID;
	}

	public double getRate()
	{
		return rate;
	}

	public String getExtRateID()
	{
		return extRateID;
	}

	public int getUomTypeID()
	{
		return uomTypeID;
	}

	public String getExtUomName()
	{
		return extUomName;
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

	public void setJobItemRateID(int jobItemRateIDIn)
	{
		jobItemRateID = jobItemRateIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setJobID(int jobIDIn)
	{
		jobID = jobIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setItemID(int itemIDIn)
	{
		itemID = itemIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setRate(double rateIn)
	{
		rate = rateIn;
		handleAction(MODIFY_ACTION);
	}

	public void setExtRateID(String extRateIDIn)
	{
		extRateID = extRateIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setUomTypeID(int uomTypeIDIn)
	{
		uomTypeID = uomTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setExtUomName(String extUomNameIn)
	{
		extUomName = extUomNameIn;
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
