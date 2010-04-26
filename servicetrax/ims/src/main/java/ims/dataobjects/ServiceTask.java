package ims.dataobjects;

import java.util.Date;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class ServiceTask extends AbstractDatabaseObject
{

	private int serviceTaskID;
	private int serviceID;
	private String phase;
	private int phaseNo;
	private int phaseTypeID;
	private int sequenceNo;
	private int subActTypeID;
	private String vendorResponsible;
	private String description;
	private Date dateCreated;
	private int createdBy;
	private Date dateModified;
	private int modifiedBy;

	public ServiceTask()
	{
		super();
	}


	public static ServiceTask fetch(String serviceTaskID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(serviceTaskID), ic, null);
	}

	public static ServiceTask fetch(String serviceTaskID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(serviceTaskID), ic, resourceName);
	}

	public static ServiceTask fetch(int serviceTaskID, InvocationContext ic)
	{
		 return fetch(serviceTaskID, ic, null);
	}

	public static ServiceTask fetch(int serviceTaskID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("ServiceTask.fetch()");

		ServiceTask result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT service_task_id ");
			query.append(", service_id ");
			query.append(", phase ");
			query.append(", phase_no ");
			query.append(", phase_type_id ");
			query.append(", sequence_no ");
			query.append(", sub_act_type_id ");
			query.append(", vendor_responsible ");
			query.append(", description ");
			query.append(", date_created ");
			query.append(", created_by ");
			query.append(", date_modified ");
			query.append(", modified_by ");
			query.append("FROM service_tasks ");
			query.append("WHERE (service_task_id = ").append(serviceTaskID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new ServiceTask();
				result.setServiceTaskID(rs.getInt(1));
				result.setServiceID(rs.getInt(2));
				result.setPhase(rs.getString(3));
				result.setPhaseNo(rs.getInt(4));
				result.setPhaseTypeID(rs.getInt(5));
				result.setSequenceNo(rs.getInt(6));
				result.setSubActTypeID(rs.getInt(7));
				result.setVendorResponsible(rs.getString(8));
				result.setDescription(rs.getString(9));
				result.setDateCreated(rs.getDate(10));
				result.setCreatedBy(rs.getInt(11));
				result.setDateModified(rs.getDate(12));
				result.setModifiedBy(rs.getInt(13));
			}
			else
			{
				Diagnostics.error("Error in ServiceTask.fetch(), Could not find ServiceTask; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ServiceTask.fetch()");
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
		Diagnostics.trace("ServiceTask.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE service_tasks ");
			update.append("SET service_id = ").append(this.getServiceID());
			update.append(", phase = ").append(conn.toSQLString(StringUtil.truncate(this.getPhase(), 50)));
			update.append(", phase_no = ").append(this.getPhaseNo());
			update.append(", phase_type_id = ").append(this.getPhaseTypeID());
			update.append(", sequence_no = ").append(this.getSequenceNo());
			update.append(", sub_act_type_id = ").append(this.getSubActTypeID());
			update.append(", vendor_responsible = ").append(conn.toSQLString(StringUtil.truncate(this.getVendorResponsible(), 50)));
			update.append(", description = ").append(conn.toSQLString(StringUtil.truncate(this.getDescription(), 500)));
			update.append(", date_created = ").append(conn.toSQLString(this.getDateCreated()));
			update.append(", created_by = ").append(this.getCreatedBy());
			update.append(", date_modified = ").append(conn.toSQLString(this.getDateModified()));
			update.append(", modified_by = ").append(this.getModifiedBy());
			update.append("WHERE (service_task_id = ").append(this.getServiceTaskID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ServiceTask.internalUpdate()");
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
		Diagnostics.trace("ServiceTask.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO service_tasks (");
				insert.append("service_id");
				insert.append(", phase");
				insert.append(", phase_no");
				insert.append(", phase_type_id");
				insert.append(", sequence_no");
				insert.append(", sub_act_type_id");
				insert.append(", vendor_responsible");
				insert.append(", description");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getServiceID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getPhase(), 50)));
				insert.append(", ").append(this.getPhaseNo());
				insert.append(", ").append(this.getPhaseTypeID());
				insert.append(", ").append(this.getSequenceNo());
				insert.append(", ").append(this.getSubActTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getVendorResponsible(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getDescription(), 500)));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO service_tasks (");
				insert.append("service_task_id");
				insert.append(", service_id");
				insert.append(", phase");
				insert.append(", phase_no");
				insert.append(", phase_type_id");
				insert.append(", sequence_no");
				insert.append(", sub_act_type_id");
				insert.append(", vendor_responsible");
				insert.append(", description");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getServiceTaskID());
				insert.append(", ").append(this.getServiceID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getPhase(), 50)));
				insert.append(", ").append(this.getPhaseNo());
				insert.append(", ").append(this.getPhaseTypeID());
				insert.append(", ").append(this.getSequenceNo());
				insert.append(", ").append(this.getSubActTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getVendorResponsible(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getDescription(), 500)));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				serviceTaskID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ServiceTask.internalInsert()");
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
		Diagnostics.trace("ServiceTask.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM service_tasks ");
			delete.append("WHERE (service_task_id = ").append(this.getServiceTaskID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ServiceTask.internalDelete()");
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
		if (this.getServiceTaskID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("ServiceTask:\n");
		result.append("  service_task_id = ").append(this.getServiceTaskID()).append("\n");
		result.append("  service_id = ").append(this.getServiceID()).append("\n");
		result.append("  phase = ").append(this.getPhase()).append("\n");
		result.append("  phase_no = ").append(this.getPhaseNo()).append("\n");
		result.append("  phase_type_id = ").append(this.getPhaseTypeID()).append("\n");
		result.append("  sequence_no = ").append(this.getSequenceNo()).append("\n");
		result.append("  sub_act_type_id = ").append(this.getSubActTypeID()).append("\n");
		result.append("  vendor_responsible = ").append(this.getVendorResponsible()).append("\n");
		result.append("  description = ").append(this.getDescription()).append("\n");
		result.append("  date_created = ").append(this.getDateCreated()).append("\n");
		result.append("  created_by = ").append(this.getCreatedBy()).append("\n");
		result.append("  date_modified = ").append(this.getDateModified()).append("\n");
		result.append("  modified_by = ").append(this.getModifiedBy()).append("\n");
		return result.toString();
	}


	public int getServiceTaskID()
	{
		return serviceTaskID;
	}

	public int getServiceID()
	{
		return serviceID;
	}

	public String getPhase()
	{
		return phase;
	}

	public int getPhaseNo()
	{
		return phaseNo;
	}

	public int getPhaseTypeID()
	{
		return phaseTypeID;
	}

	public int getSequenceNo()
	{
		return sequenceNo;
	}

	public int getSubActTypeID()
	{
		return subActTypeID;
	}

	public String getVendorResponsible()
	{
		return vendorResponsible;
	}

	public String getDescription()
	{
		return description;
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

	public void setServiceTaskID(int serviceTaskIDIn)
	{
		serviceTaskID = serviceTaskIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setServiceID(int serviceIDIn)
	{
		serviceID = serviceIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setPhase(String phaseIn)
	{
		phase = phaseIn;
		handleAction(MODIFY_ACTION);
	}

	public void setPhaseNo(int phaseNoIn)
	{
		phaseNo = phaseNoIn;
		handleAction(MODIFY_ACTION);
	}

	public void setPhaseTypeID(int phaseTypeIDIn)
	{
		phaseTypeID = phaseTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setSequenceNo(int sequenceNoIn)
	{
		sequenceNo = sequenceNoIn;
		handleAction(MODIFY_ACTION);
	}

	public void setSubActTypeID(int subActTypeIDIn)
	{
		subActTypeID = subActTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setVendorResponsible(String vendorResponsibleIn)
	{
		vendorResponsible = vendorResponsibleIn;
		handleAction(MODIFY_ACTION);
	}

	public void setDescription(String descriptionIn)
	{
		description = descriptionIn;
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
