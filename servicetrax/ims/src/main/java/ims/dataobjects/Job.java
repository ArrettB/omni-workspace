package ims.dataobjects;

import java.util.Date;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class Job extends AbstractDatabaseObject
{

	private int jobID;
	private int jobImportID;
	private int quoteID;
	private int jobNo;
	private int oldJobNo;
	private String customerName;
	private String extCustID;
	private String jobName;
	private String extJobNameID;
	private String extBillToAddrID;
	private String extPriceLevelID;
	private int jobTypeID;
	private int jobStatusTypeID;
	private String poNo;
	private int billingTypeID;
	private int supResourceID;
	private Date eftStartDate;
	private Date eftEndDate;
	private int createdBy;
	private Date dateCreated;
	private int modifiedBy;
	private Date dateModified;

	public Job()
	{
		super();
	}


	public static Job fetch(String jobID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(jobID), ic, null);
	}

	public static Job fetch(String jobID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(jobID), ic, resourceName);
	}

	public static Job fetch(int jobID, InvocationContext ic)
	{
		 return fetch(jobID, ic, null);
	}

	public static Job fetch(int jobID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("Job.fetch()");

		Job result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT job_id ");
			query.append(", job_import_id ");
			query.append(", quote_id ");
			query.append(", job_no ");
			query.append(", old_job_no ");
			query.append(", customer_name ");
			query.append(", ext_cust_id ");
			query.append(", job_name ");
			query.append(", ext_job_name_id ");
			query.append(", ext_bill_to_addr_id ");
			query.append(", ext_price_level_id ");
			query.append(", job_type_id ");
			query.append(", job_status_type_id ");
			query.append(", po_no ");
			query.append(", billing_type_id ");
			query.append(", sup_resource_id ");
			query.append(", eft_start_date ");
			query.append(", eft_end_date ");
			query.append(", created_by ");
			query.append(", date_created ");
			query.append(", modified_by ");
			query.append(", date_modified ");
			query.append("FROM jobs ");
			query.append("WHERE (job_id = ").append(jobID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new Job();
				result.setJobID(rs.getInt(1));
				result.setJobImportID(rs.getInt(2));
				result.setQuoteID(rs.getInt(3));
				result.setJobNo(rs.getInt(4));
				result.setOldJobNo(rs.getInt(5));
				result.setCustomerName(rs.getString(6));
				result.setExtCustID(rs.getString(7));
				result.setJobName(rs.getString(8));
				result.setExtJobNameID(rs.getString(9));
				result.setExtBillToAddrID(rs.getString(10));
				result.setExtPriceLevelID(rs.getString(11));
				result.setJobTypeID(rs.getInt(12));
				result.setJobStatusTypeID(rs.getInt(13));
				result.setPoNo(rs.getString(14));
				result.setBillingTypeID(rs.getInt(15));
				result.setSupResourceID(rs.getInt(16));
				result.setEftStartDate(rs.getDate(17));
				result.setEftEndDate(rs.getDate(18));
				result.setCreatedBy(rs.getInt(19));
				result.setDateCreated(rs.getDate(20));
				result.setModifiedBy(rs.getInt(21));
				result.setDateModified(rs.getDate(22));
			}
			else
			{
				Diagnostics.error("Error in Job.fetch(), Could not find Job; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Job.fetch()");
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
		Diagnostics.trace("Job.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE jobs ");
			update.append("SET job_import_id = ").append(this.getJobImportID());
			update.append(", quote_id = ").append(this.getQuoteID());
			update.append(", job_no = ").append(this.getJobNo());
			update.append(", old_job_no = ").append(this.getOldJobNo());
			update.append(", customer_name = ").append(conn.toSQLString(StringUtil.truncate(this.getCustomerName(), 100)));
			update.append(", ext_cust_id = ").append(conn.toSQLString(StringUtil.truncate(this.getExtCustID(), 15)));
			update.append(", job_name = ").append(conn.toSQLString(StringUtil.truncate(this.getJobName(), 100)));
			update.append(", ext_job_name_id = ").append(conn.toSQLString(StringUtil.truncate(this.getExtJobNameID(), 15)));
			update.append(", ext_bill_to_addr_id = ").append(conn.toSQLString(StringUtil.truncate(this.getExtBillToAddrID(), 15)));
			update.append(", ext_price_level_id = ").append(conn.toSQLString(StringUtil.truncate(this.getExtPriceLevelID(), 11)));
			update.append(", job_type_id = ").append(this.getJobTypeID());
			update.append(", job_status_type_id = ").append(this.getJobStatusTypeID());
			update.append(", po_no = ").append(conn.toSQLString(StringUtil.truncate(this.getPoNo(), 50)));
			update.append(", billing_type_id = ").append(this.getBillingTypeID());
			update.append(", sup_resource_id = ").append(this.getSupResourceID());
			update.append(", eft_start_date = ").append(conn.toSQLString(this.getEftStartDate()));
			update.append(", eft_end_date = ").append(conn.toSQLString(this.getEftEndDate()));
			update.append(", created_by = ").append(this.getCreatedBy());
			update.append(", date_created = ").append(conn.toSQLString(this.getDateCreated()));
			update.append(", modified_by = ").append(this.getModifiedBy());
			update.append(", date_modified = ").append(conn.toSQLString(this.getDateModified()));
			update.append("WHERE (job_id = ").append(this.getJobID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Job.internalUpdate()");
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
		Diagnostics.trace("Job.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO jobs (");
				insert.append("job_import_id");
				insert.append(", quote_id");
				insert.append(", job_no");
				insert.append(", old_job_no");
				insert.append(", customer_name");
				insert.append(", ext_cust_id");
				insert.append(", job_name");
				insert.append(", ext_job_name_id");
				insert.append(", ext_bill_to_addr_id");
				insert.append(", ext_price_level_id");
				insert.append(", job_type_id");
				insert.append(", job_status_type_id");
				insert.append(", po_no");
				insert.append(", billing_type_id");
				insert.append(", sup_resource_id");
				insert.append(", eft_start_date");
				insert.append(", eft_end_date");
				insert.append(", created_by");
				insert.append(", date_created");
				insert.append(", modified_by");
				insert.append(", date_modified");
				insert.append(") VALUES (");
				insert.append(this.getJobImportID());
				insert.append(", ").append(this.getQuoteID());
				insert.append(", ").append(this.getJobNo());
				insert.append(", ").append(this.getOldJobNo());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCustomerName(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getExtCustID(), 15)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getJobName(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getExtJobNameID(), 15)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getExtBillToAddrID(), 15)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getExtPriceLevelID(), 11)));
				insert.append(", ").append(this.getJobTypeID());
				insert.append(", ").append(this.getJobStatusTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getPoNo(), 50)));
				insert.append(", ").append(this.getBillingTypeID());
				insert.append(", ").append(this.getSupResourceID());
				insert.append(", ").append(conn.toSQLString(this.getEftStartDate()));
				insert.append(", ").append(conn.toSQLString(this.getEftEndDate()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO jobs (");
				insert.append("job_id");
				insert.append(", job_import_id");
				insert.append(", quote_id");
				insert.append(", job_no");
				insert.append(", old_job_no");
				insert.append(", customer_name");
				insert.append(", ext_cust_id");
				insert.append(", job_name");
				insert.append(", ext_job_name_id");
				insert.append(", ext_bill_to_addr_id");
				insert.append(", ext_price_level_id");
				insert.append(", job_type_id");
				insert.append(", job_status_type_id");
				insert.append(", po_no");
				insert.append(", billing_type_id");
				insert.append(", sup_resource_id");
				insert.append(", eft_start_date");
				insert.append(", eft_end_date");
				insert.append(", created_by");
				insert.append(", date_created");
				insert.append(", modified_by");
				insert.append(", date_modified");
				insert.append(") VALUES (");
				insert.append(this.getJobID());
				insert.append(", ").append(this.getJobImportID());
				insert.append(", ").append(this.getQuoteID());
				insert.append(", ").append(this.getJobNo());
				insert.append(", ").append(this.getOldJobNo());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCustomerName(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getExtCustID(), 15)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getJobName(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getExtJobNameID(), 15)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getExtBillToAddrID(), 15)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getExtPriceLevelID(), 11)));
				insert.append(", ").append(this.getJobTypeID());
				insert.append(", ").append(this.getJobStatusTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getPoNo(), 50)));
				insert.append(", ").append(this.getBillingTypeID());
				insert.append(", ").append(this.getSupResourceID());
				insert.append(", ").append(conn.toSQLString(this.getEftStartDate()));
				insert.append(", ").append(conn.toSQLString(this.getEftEndDate()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				jobID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Job.internalInsert()");
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
		Diagnostics.trace("Job.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM jobs ");
			delete.append("WHERE (job_id = ").append(this.getJobID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Job.internalDelete()");
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
		if (this.getJobID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("Job:\n");
		result.append("  job_id = ").append(this.getJobID()).append("\n");
		result.append("  job_import_id = ").append(this.getJobImportID()).append("\n");
		result.append("  quote_id = ").append(this.getQuoteID()).append("\n");
		result.append("  job_no = ").append(this.getJobNo()).append("\n");
		result.append("  old_job_no = ").append(this.getOldJobNo()).append("\n");
		result.append("  customer_name = ").append(this.getCustomerName()).append("\n");
		result.append("  ext_cust_id = ").append(this.getExtCustID()).append("\n");
		result.append("  job_name = ").append(this.getJobName()).append("\n");
		result.append("  ext_job_name_id = ").append(this.getExtJobNameID()).append("\n");
		result.append("  ext_bill_to_addr_id = ").append(this.getExtBillToAddrID()).append("\n");
		result.append("  ext_price_level_id = ").append(this.getExtPriceLevelID()).append("\n");
		result.append("  job_type_id = ").append(this.getJobTypeID()).append("\n");
		result.append("  job_status_type_id = ").append(this.getJobStatusTypeID()).append("\n");
		result.append("  po_no = ").append(this.getPoNo()).append("\n");
		result.append("  billing_type_id = ").append(this.getBillingTypeID()).append("\n");
		result.append("  sup_resource_id = ").append(this.getSupResourceID()).append("\n");
		result.append("  eft_start_date = ").append(this.getEftStartDate()).append("\n");
		result.append("  eft_end_date = ").append(this.getEftEndDate()).append("\n");
		result.append("  created_by = ").append(this.getCreatedBy()).append("\n");
		result.append("  date_created = ").append(this.getDateCreated()).append("\n");
		result.append("  modified_by = ").append(this.getModifiedBy()).append("\n");
		result.append("  date_modified = ").append(this.getDateModified()).append("\n");
		return result.toString();
	}


	public int getJobID()
	{
		return jobID;
	}

	public int getJobImportID()
	{
		return jobImportID;
	}

	public int getQuoteID()
	{
		return quoteID;
	}

	public int getJobNo()
	{
		return jobNo;
	}

	public int getOldJobNo()
	{
		return oldJobNo;
	}

	public String getCustomerName()
	{
		return customerName;
	}

	public String getExtCustID()
	{
		return extCustID;
	}

	public String getJobName()
	{
		return jobName;
	}

	public String getExtJobNameID()
	{
		return extJobNameID;
	}

	public String getExtBillToAddrID()
	{
		return extBillToAddrID;
	}

	public String getExtPriceLevelID()
	{
		return extPriceLevelID;
	}

	public int getJobTypeID()
	{
		return jobTypeID;
	}

	public int getJobStatusTypeID()
	{
		return jobStatusTypeID;
	}

	public String getPoNo()
	{
		return poNo;
	}

	public int getBillingTypeID()
	{
		return billingTypeID;
	}

	public int getSupResourceID()
	{
		return supResourceID;
	}

	public Date getEftStartDate()
	{
		return eftStartDate;
	}

	public Date getEftEndDate()
	{
		return eftEndDate;
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

	public void setJobID(int jobIDIn)
	{
		jobID = jobIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setJobImportID(int jobImportIDIn)
	{
		jobImportID = jobImportIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setQuoteID(int quoteIDIn)
	{
		quoteID = quoteIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setJobNo(int jobNoIn)
	{
		jobNo = jobNoIn;
		handleAction(MODIFY_ACTION);
	}

	public void setOldJobNo(int oldJobNoIn)
	{
		oldJobNo = oldJobNoIn;
		handleAction(MODIFY_ACTION);
	}

	public void setCustomerName(String customerNameIn)
	{
		customerName = customerNameIn;
		handleAction(MODIFY_ACTION);
	}

	public void setExtCustID(String extCustIDIn)
	{
		extCustID = extCustIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setJobName(String jobNameIn)
	{
		jobName = jobNameIn;
		handleAction(MODIFY_ACTION);
	}

	public void setExtJobNameID(String extJobNameIDIn)
	{
		extJobNameID = extJobNameIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setExtBillToAddrID(String extBillToAddrIDIn)
	{
		extBillToAddrID = extBillToAddrIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setExtPriceLevelID(String extPriceLevelIDIn)
	{
		extPriceLevelID = extPriceLevelIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setJobTypeID(int jobTypeIDIn)
	{
		jobTypeID = jobTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setJobStatusTypeID(int jobStatusTypeIDIn)
	{
		jobStatusTypeID = jobStatusTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setPoNo(String poNoIn)
	{
		poNo = poNoIn;
		handleAction(MODIFY_ACTION);
	}

	public void setBillingTypeID(int billingTypeIDIn)
	{
		billingTypeID = billingTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setSupResourceID(int supResourceIDIn)
	{
		supResourceID = supResourceIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setEftStartDate(Date eftStartDateIn)
	{
		eftStartDate = eftStartDateIn;
		handleAction(MODIFY_ACTION);
	}

	public void setEftEndDate(Date eftEndDateIn)
	{
		eftEndDate = eftEndDateIn;
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
