package ims.dataobjects;

import java.util.Date;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class Quote extends AbstractDatabaseObject
{

	private int quoteID;
	private String quoteNo;
	private int revisionNo;
	private int quoteTypeID;
	private int quoteStatusTypeID;
	private Date dateEffectiveTo;
	private String customerName;
	private String extCustID;
	private int contactID;
	private String jobName;
	private String quoteCode;
	private String extJobNameID;
	private String jobLocationID;
	private String quotedBy;
	private String quotersTitle;
	private String description;
	private int quoteTotal;
	private Date datePrinted;
	private Date dateConvertedToJob;
	private Date dateCreated;
	private int createdBy;
	private Date dateModified;
	private int modifiedBy;

	public Quote()
	{
		super();
	}


	public static Quote fetch(String quoteID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(quoteID), ic, null);
	}

	public static Quote fetch(String quoteID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(quoteID), ic, resourceName);
	}

	public static Quote fetch(int quoteID, InvocationContext ic)
	{
		 return fetch(quoteID, ic, null);
	}

	public static Quote fetch(int quoteID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("Quote.fetch()");

		Quote result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT quote_id ");
			query.append(", quote_no ");
			query.append(", revision_no ");
			query.append(", quote_type_id ");
			query.append(", quote_status_type_id ");
			query.append(", date_effective_to ");
			query.append(", customer_name ");
			query.append(", ext_cust_id ");
			query.append(", contact_id ");
			query.append(", job_name ");
			query.append(", quote_code ");
			query.append(", ext_job_name_id ");
			query.append(", job_location_id ");
			query.append(", quoted_by ");
			query.append(", quoters_title ");
			query.append(", description ");
			query.append(", quote_total ");
			query.append(", date_printed ");
			query.append(", date_converted_to_job ");
			query.append(", date_created ");
			query.append(", created_by ");
			query.append(", date_modified ");
			query.append(", modified_by ");
			query.append("FROM quotes ");
			query.append("WHERE (quote_id = ").append(quoteID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new Quote();
				result.setQuoteID(rs.getInt(1));
				result.setQuoteNo(rs.getString(2));
				result.setRevisionNo(rs.getInt(3));
				result.setQuoteTypeID(rs.getInt(4));
				result.setQuoteStatusTypeID(rs.getInt(5));
				result.setDateEffectiveTo(rs.getDate(6));
				result.setCustomerName(rs.getString(7));
				result.setExtCustID(rs.getString(8));
				result.setContactID(rs.getInt(9));
				result.setJobName(rs.getString(10));
				result.setQuoteCode(rs.getString(11));
				result.setExtJobNameID(rs.getString(12));
				result.setJobLocationID(rs.getString(13));
				result.setQuotedBy(rs.getString(14));
				result.setQuotersTitle(rs.getString(15));
				result.setDescription(rs.getString(16));
				result.setQuoteTotal(rs.getInt(17));
				result.setDatePrinted(rs.getDate(18));
				result.setDateConvertedToJob(rs.getDate(19));
				result.setDateCreated(rs.getDate(20));
				result.setCreatedBy(rs.getInt(21));
				result.setDateModified(rs.getDate(22));
				result.setModifiedBy(rs.getInt(23));
			}
			else
			{
				Diagnostics.error("Error in Quote.fetch(), Could not find Quote; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Quote.fetch()");
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
		Diagnostics.trace("Quote.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE quotes ");
			update.append("SET quote_no = ").append(conn.toSQLString(StringUtil.truncate(this.getQuoteNo(), 20)));
			update.append(", revision_no = ").append(this.getRevisionNo());
			update.append(", quote_type_id = ").append(this.getQuoteTypeID());
			update.append(", quote_status_type_id = ").append(this.getQuoteStatusTypeID());
			update.append(", date_effective_to = ").append(conn.toSQLString(this.getDateEffectiveTo()));
			update.append(", customer_name = ").append(conn.toSQLString(StringUtil.truncate(this.getCustomerName(), 100)));
			update.append(", ext_cust_id = ").append(conn.toSQLString(StringUtil.truncate(this.getExtCustID(), 15)));
			update.append(", contact_id = ").append(this.getContactID());
			update.append(", job_name = ").append(conn.toSQLString(StringUtil.truncate(this.getJobName(), 100)));
			update.append(", quote_code = ").append(conn.toSQLString(StringUtil.truncate(this.getQuoteCode(), 50)));
			update.append(", ext_job_name_id = ").append(conn.toSQLString(StringUtil.truncate(this.getExtJobNameID(), 15)));
			update.append(", job_location_id = ").append(conn.toSQLString(StringUtil.truncate(this.getJobLocationID(), 50)));
			update.append(", quoted_by = ").append(conn.toSQLString(StringUtil.truncate(this.getQuotedBy(), 50)));
			update.append(", quoters_title = ").append(conn.toSQLString(StringUtil.truncate(this.getQuotersTitle(), 100)));
			update.append(", description = ").append(conn.toSQLString(StringUtil.truncate(this.getDescription(), 1000)));
			update.append(", quote_total = ").append(this.getQuoteTotal());
			update.append(", date_printed = ").append(conn.toSQLString(this.getDatePrinted()));
			update.append(", date_converted_to_job = ").append(conn.toSQLString(this.getDateConvertedToJob()));
			update.append(", date_created = ").append(conn.toSQLString(this.getDateCreated()));
			update.append(", created_by = ").append(this.getCreatedBy());
			update.append(", date_modified = ").append(conn.toSQLString(this.getDateModified()));
			update.append(", modified_by = ").append(this.getModifiedBy());
			update.append("WHERE (quote_id = ").append(this.getQuoteID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Quote.internalUpdate()");
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
		Diagnostics.trace("Quote.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO quotes (");
				insert.append("quote_no");
				insert.append(", revision_no");
				insert.append(", quote_type_id");
				insert.append(", quote_status_type_id");
				insert.append(", date_effective_to");
				insert.append(", customer_name");
				insert.append(", ext_cust_id");
				insert.append(", contact_id");
				insert.append(", job_name");
				insert.append(", quote_code");
				insert.append(", ext_job_name_id");
				insert.append(", job_location_id");
				insert.append(", quoted_by");
				insert.append(", quoters_title");
				insert.append(", description");
				insert.append(", quote_total");
				insert.append(", date_printed");
				insert.append(", date_converted_to_job");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(conn.toSQLString(StringUtil.truncate(this.getQuoteNo(), 20)));
				insert.append(", ").append(this.getRevisionNo());
				insert.append(", ").append(this.getQuoteTypeID());
				insert.append(", ").append(this.getQuoteStatusTypeID());
				insert.append(", ").append(conn.toSQLString(this.getDateEffectiveTo()));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCustomerName(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getExtCustID(), 15)));
				insert.append(", ").append(this.getContactID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getJobName(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getQuoteCode(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getExtJobNameID(), 15)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getJobLocationID(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getQuotedBy(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getQuotersTitle(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getDescription(), 1000)));
				insert.append(", ").append(this.getQuoteTotal());
				insert.append(", ").append(conn.toSQLString(this.getDatePrinted()));
				insert.append(", ").append(conn.toSQLString(this.getDateConvertedToJob()));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO quotes (");
				insert.append("quote_id");
				insert.append(", quote_no");
				insert.append(", revision_no");
				insert.append(", quote_type_id");
				insert.append(", quote_status_type_id");
				insert.append(", date_effective_to");
				insert.append(", customer_name");
				insert.append(", ext_cust_id");
				insert.append(", contact_id");
				insert.append(", job_name");
				insert.append(", quote_code");
				insert.append(", ext_job_name_id");
				insert.append(", job_location_id");
				insert.append(", quoted_by");
				insert.append(", quoters_title");
				insert.append(", description");
				insert.append(", quote_total");
				insert.append(", date_printed");
				insert.append(", date_converted_to_job");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getQuoteID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getQuoteNo(), 20)));
				insert.append(", ").append(this.getRevisionNo());
				insert.append(", ").append(this.getQuoteTypeID());
				insert.append(", ").append(this.getQuoteStatusTypeID());
				insert.append(", ").append(conn.toSQLString(this.getDateEffectiveTo()));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCustomerName(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getExtCustID(), 15)));
				insert.append(", ").append(this.getContactID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getJobName(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getQuoteCode(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getExtJobNameID(), 15)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getJobLocationID(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getQuotedBy(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getQuotersTitle(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getDescription(), 1000)));
				insert.append(", ").append(this.getQuoteTotal());
				insert.append(", ").append(conn.toSQLString(this.getDatePrinted()));
				insert.append(", ").append(conn.toSQLString(this.getDateConvertedToJob()));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				quoteID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Quote.internalInsert()");
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
		Diagnostics.trace("Quote.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM quotes ");
			delete.append("WHERE (quote_id = ").append(this.getQuoteID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Quote.internalDelete()");
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
		if (this.getQuoteID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("Quote:\n");
		result.append("  quote_id = ").append(this.getQuoteID()).append("\n");
		result.append("  quote_no = ").append(this.getQuoteNo()).append("\n");
		result.append("  revision_no = ").append(this.getRevisionNo()).append("\n");
		result.append("  quote_type_id = ").append(this.getQuoteTypeID()).append("\n");
		result.append("  quote_status_type_id = ").append(this.getQuoteStatusTypeID()).append("\n");
		result.append("  date_effective_to = ").append(this.getDateEffectiveTo()).append("\n");
		result.append("  customer_name = ").append(this.getCustomerName()).append("\n");
		result.append("  ext_cust_id = ").append(this.getExtCustID()).append("\n");
		result.append("  contact_id = ").append(this.getContactID()).append("\n");
		result.append("  job_name = ").append(this.getJobName()).append("\n");
		result.append("  quote_code = ").append(this.getQuoteCode()).append("\n");
		result.append("  ext_job_name_id = ").append(this.getExtJobNameID()).append("\n");
		result.append("  job_location_id = ").append(this.getJobLocationID()).append("\n");
		result.append("  quoted_by = ").append(this.getQuotedBy()).append("\n");
		result.append("  quoters_title = ").append(this.getQuotersTitle()).append("\n");
		result.append("  description = ").append(this.getDescription()).append("\n");
		result.append("  quote_total = ").append(this.getQuoteTotal()).append("\n");
		result.append("  date_printed = ").append(this.getDatePrinted()).append("\n");
		result.append("  date_converted_to_job = ").append(this.getDateConvertedToJob()).append("\n");
		result.append("  date_created = ").append(this.getDateCreated()).append("\n");
		result.append("  created_by = ").append(this.getCreatedBy()).append("\n");
		result.append("  date_modified = ").append(this.getDateModified()).append("\n");
		result.append("  modified_by = ").append(this.getModifiedBy()).append("\n");
		return result.toString();
	}


	public int getQuoteID()
	{
		return quoteID;
	}

	public String getQuoteNo()
	{
		return quoteNo;
	}

	public int getRevisionNo()
	{
		return revisionNo;
	}

	public int getQuoteTypeID()
	{
		return quoteTypeID;
	}

	public int getQuoteStatusTypeID()
	{
		return quoteStatusTypeID;
	}

	public Date getDateEffectiveTo()
	{
		return dateEffectiveTo;
	}

	public String getCustomerName()
	{
		return customerName;
	}

	public String getExtCustID()
	{
		return extCustID;
	}

	public int getContactID()
	{
		return contactID;
	}

	public String getJobName()
	{
		return jobName;
	}

	public String getQuoteCode()
	{
		return quoteCode;
	}

	public String getExtJobNameID()
	{
		return extJobNameID;
	}

	public String getJobLocationID()
	{
		return jobLocationID;
	}

	public String getQuotedBy()
	{
		return quotedBy;
	}

	public String getQuotersTitle()
	{
		return quotersTitle;
	}

	public String getDescription()
	{
		return description;
	}

	public int getQuoteTotal()
	{
		return quoteTotal;
	}

	public Date getDatePrinted()
	{
		return datePrinted;
	}

	public Date getDateConvertedToJob()
	{
		return dateConvertedToJob;
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

	public void setQuoteID(int quoteIDIn)
	{
		quoteID = quoteIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setQuoteNo(String quoteNoIn)
	{
		quoteNo = quoteNoIn;
		handleAction(MODIFY_ACTION);
	}

	public void setRevisionNo(int revisionNoIn)
	{
		revisionNo = revisionNoIn;
		handleAction(MODIFY_ACTION);
	}

	public void setQuoteTypeID(int quoteTypeIDIn)
	{
		quoteTypeID = quoteTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setQuoteStatusTypeID(int quoteStatusTypeIDIn)
	{
		quoteStatusTypeID = quoteStatusTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setDateEffectiveTo(Date dateEffectiveToIn)
	{
		dateEffectiveTo = dateEffectiveToIn;
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

	public void setContactID(int contactIDIn)
	{
		contactID = contactIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setJobName(String jobNameIn)
	{
		jobName = jobNameIn;
		handleAction(MODIFY_ACTION);
	}

	public void setQuoteCode(String quoteCodeIn)
	{
		quoteCode = quoteCodeIn;
		handleAction(MODIFY_ACTION);
	}

	public void setExtJobNameID(String extJobNameIDIn)
	{
		extJobNameID = extJobNameIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setJobLocationID(String jobLocationIDIn)
	{
		jobLocationID = jobLocationIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setQuotedBy(String quotedByIn)
	{
		quotedBy = quotedByIn;
		handleAction(MODIFY_ACTION);
	}

	public void setQuotersTitle(String quotersTitleIn)
	{
		quotersTitle = quotersTitleIn;
		handleAction(MODIFY_ACTION);
	}

	public void setDescription(String descriptionIn)
	{
		description = descriptionIn;
		handleAction(MODIFY_ACTION);
	}

	public void setQuoteTotal(int quoteTotalIn)
	{
		quoteTotal = quoteTotalIn;
		handleAction(MODIFY_ACTION);
	}

	public void setDatePrinted(Date datePrintedIn)
	{
		datePrinted = datePrintedIn;
		handleAction(MODIFY_ACTION);
	}

	public void setDateConvertedToJob(Date dateConvertedToJobIn)
	{
		dateConvertedToJob = dateConvertedToJobIn;
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
