package ims.dataobjects;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;

public class XrefJob extends AbstractDatabaseObject
{

	private int xrefJobID;
	private int jobID;
	private int repID;
	private int palmUserID;

	public XrefJob()
	{
		super();
	}


	public static XrefJob fetch(String xrefJobID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(xrefJobID), ic, null);
	}

	public static XrefJob fetch(String xrefJobID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(xrefJobID), ic, resourceName);
	}

	public static XrefJob fetch(int xrefJobID, InvocationContext ic)
	{
		 return fetch(xrefJobID, ic, null);
	}

	public static XrefJob fetch(int xrefJobID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("XrefJob.fetch()");

		XrefJob result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT xref_job_id ");
			query.append(", job_id ");
			query.append(", rep_id ");
			query.append(", palm_user_id ");
			query.append("FROM xref_jobs ");
			query.append("WHERE (xref_job_id = ").append(xrefJobID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new XrefJob();
				result.setXrefJobID(rs.getInt(1));
				result.setJobID(rs.getInt(2));
				result.setRepID(rs.getInt(3));
				result.setPalmUserID(rs.getInt(4));
			}
			else
			{
				Diagnostics.error("Error in XrefJob.fetch(), Could not find XrefJob; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in XrefJob.fetch()");
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
		Diagnostics.trace("XrefJob.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE xref_jobs ");
			update.append("SET job_id = ").append(this.getJobID());
			update.append(", rep_id = ").append(this.getRepID());
			update.append(", palm_user_id = ").append(this.getPalmUserID());
			update.append("WHERE (xref_job_id = ").append(this.getXrefJobID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in XrefJob.internalUpdate()");
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
		Diagnostics.trace("XrefJob.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO xref_jobs (");
				insert.append("job_id");
				insert.append(", rep_id");
				insert.append(", palm_user_id");
				insert.append(") VALUES (");
				insert.append(this.getJobID());
				insert.append(", ").append(this.getRepID());
				insert.append(", ").append(this.getPalmUserID());
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO xref_jobs (");
				insert.append("xref_job_id");
				insert.append(", job_id");
				insert.append(", rep_id");
				insert.append(", palm_user_id");
				insert.append(") VALUES (");
				insert.append(this.getXrefJobID());
				insert.append(", ").append(this.getJobID());
				insert.append(", ").append(this.getRepID());
				insert.append(", ").append(this.getPalmUserID());
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				xrefJobID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in XrefJob.internalInsert()");
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
		Diagnostics.trace("XrefJob.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM xref_jobs ");
			delete.append("WHERE (xref_job_id = ").append(this.getXrefJobID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in XrefJob.internalDelete()");
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
		if (this.getXrefJobID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("XrefJob:\n");
		result.append("  xref_job_id = ").append(this.getXrefJobID()).append("\n");
		result.append("  job_id = ").append(this.getJobID()).append("\n");
		result.append("  rep_id = ").append(this.getRepID()).append("\n");
		result.append("  palm_user_id = ").append(this.getPalmUserID()).append("\n");
		return result.toString();
	}


	public int getXrefJobID()
	{
		return xrefJobID;
	}

	public int getJobID()
	{
		return jobID;
	}

	public int getRepID()
	{
		return repID;
	}

	public int getPalmUserID()
	{
		return palmUserID;
	}

	public void setXrefJobID(int xrefJobIDIn)
	{
		xrefJobID = xrefJobIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setJobID(int jobIDIn)
	{
		jobID = jobIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setRepID(int repIDIn)
	{
		repID = repIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setPalmUserID(int palmUserIDIn)
	{
		palmUserID = palmUserIDIn;
		handleAction(MODIFY_ACTION);
	}
}
