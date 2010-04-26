package ims.dataobjects;

import java.util.Date;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class ServiceLinesTemp extends AbstractDatabaseObject
{

	private int serviceLineID;
	private int serviceID;
	private int billingServiceID;
	private int statusID;
	private int serviceLineNo;
	private int resourceID;
	private int resourceItemID;
	private String invoicedFlag;
	private Date enteredDate;
	private int enteredBy;
	private String entryMethod;
	private double rate;
	private double qty;
	private Date overrideDate;
	private int overrideBy;
	private double overrideRate;
	private int overrideQty;
	private double billingRate;
	private int billingQty;
	private String overrideReason;
	private Date verifiedDate;
	private int verifiedBy;
	private Date serviceLineDate;
	private Date dateCreated;
	private int createdBy;
	private Date dateModified;
	private int modifiedBy;

	public ServiceLinesTemp()
	{
		super();
	}


	public static ServiceLinesTemp fetch(String serviceLineID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(serviceLineID), ic, null);
	}

	public static ServiceLinesTemp fetch(String serviceLineID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(serviceLineID), ic, resourceName);
	}

	public static ServiceLinesTemp fetch(int serviceLineID, InvocationContext ic)
	{
		 return fetch(serviceLineID, ic, null);
	}

	public static ServiceLinesTemp fetch(int serviceLineID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("ServiceLinesTemp.fetch()");

		ServiceLinesTemp result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT service_line_id ");
			query.append(", service_id ");
			query.append(", billing_service_id ");
			query.append(", status_id ");
			query.append(", service_line_no ");
			query.append(", resource_id ");
			query.append(", resource_item_id ");
			query.append(", invoiced_flag ");
			query.append(", entered_date ");
			query.append(", entered_by ");
			query.append(", entry_method ");
			query.append(", rate ");
			query.append(", qty ");
			query.append(", override_date ");
			query.append(", override_by ");
			query.append(", override_rate ");
			query.append(", override_qty ");
			query.append(", billing_rate ");
			query.append(", billing_qty ");
			query.append(", override_reason ");
			query.append(", verified_date ");
			query.append(", verified_by ");
			query.append(", service_line_date ");
			query.append(", date_created ");
			query.append(", created_by ");
			query.append(", date_modified ");
			query.append(", modified_by ");
			query.append("FROM service_lines_temp ");
			query.append("WHERE (service_line_id = ").append(serviceLineID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new ServiceLinesTemp();
				result.setServiceLineID(rs.getInt(1));
				result.setServiceID(rs.getInt(2));
				result.setBillingServiceID(rs.getInt(3));
				result.setStatusID(rs.getInt(4));
				result.setServiceLineNo(rs.getInt(5));
				result.setResourceID(rs.getInt(6));
				result.setResourceItemID(rs.getInt(7));
				result.setInvoicedFlag(rs.getString(8));
				result.setEnteredDate(rs.getDate(9));
				result.setEnteredBy(rs.getInt(10));
				result.setEntryMethod(rs.getString(11));
				result.setRate(rs.getDouble(12));
				result.setQty(rs.getDouble(13));
				result.setOverrideDate(rs.getDate(14));
				result.setOverrideBy(rs.getInt(15));
				result.setOverrideRate(rs.getDouble(16));
				result.setOverrideQty(rs.getInt(17));
				result.setBillingRate(rs.getDouble(18));
				result.setBillingQty(rs.getInt(19));
				result.setOverrideReason(rs.getString(20));
				result.setVerifiedDate(rs.getDate(21));
				result.setVerifiedBy(rs.getInt(22));
				result.setServiceLineDate(rs.getDate(23));
				result.setDateCreated(rs.getDate(24));
				result.setCreatedBy(rs.getInt(25));
				result.setDateModified(rs.getDate(26));
				result.setModifiedBy(rs.getInt(27));
			}
			else
			{
				Diagnostics.error("Error in ServiceLinesTemp.fetch(), Could not find ServiceLinesTemp; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ServiceLinesTemp.fetch()");
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
		Diagnostics.trace("ServiceLinesTemp.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE service_lines_temp ");
			update.append("SET service_id = ").append(this.getServiceID());
			update.append(", billing_service_id = ").append(this.getBillingServiceID());
			update.append(", status_id = ").append(this.getStatusID());
			update.append(", service_line_no = ").append(this.getServiceLineNo());
			update.append(", resource_id = ").append(this.getResourceID());
			update.append(", resource_item_id = ").append(this.getResourceItemID());
			update.append(", invoiced_flag = ").append(conn.toSQLString(StringUtil.truncate(this.getInvoicedFlag(), 240)));
			update.append(", entered_date = ").append(conn.toSQLString(this.getEnteredDate()));
			update.append(", entered_by = ").append(this.getEnteredBy());
			update.append(", entry_method = ").append(conn.toSQLString(StringUtil.truncate(this.getEntryMethod(), 20)));
			update.append(", rate = ").append(this.getRate());
			update.append(", qty = ").append(this.getQty());
			update.append(", override_date = ").append(conn.toSQLString(this.getOverrideDate()));
			update.append(", override_by = ").append(this.getOverrideBy());
			update.append(", override_rate = ").append(this.getOverrideRate());
			update.append(", override_qty = ").append(this.getOverrideQty());
			update.append(", billing_rate = ").append(this.getBillingRate());
			update.append(", billing_qty = ").append(this.getBillingQty());
			update.append(", override_reason = ").append(conn.toSQLString(StringUtil.truncate(this.getOverrideReason(), 2147483647)));
			update.append(", verified_date = ").append(conn.toSQLString(this.getVerifiedDate()));
			update.append(", verified_by = ").append(this.getVerifiedBy());
			update.append(", service_line_date = ").append(conn.toSQLString(this.getServiceLineDate()));
			update.append(", date_created = ").append(conn.toSQLString(this.getDateCreated()));
			update.append(", created_by = ").append(this.getCreatedBy());
			update.append(", date_modified = ").append(conn.toSQLString(this.getDateModified()));
			update.append(", modified_by = ").append(this.getModifiedBy());
			update.append("WHERE (service_line_id = ").append(this.getServiceLineID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ServiceLinesTemp.internalUpdate()");
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
		Diagnostics.trace("ServiceLinesTemp.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO service_lines_temp (");
				insert.append("service_id");
				insert.append(", billing_service_id");
				insert.append(", status_id");
				insert.append(", service_line_no");
				insert.append(", resource_id");
				insert.append(", resource_item_id");
				insert.append(", invoiced_flag");
				insert.append(", entered_date");
				insert.append(", entered_by");
				insert.append(", entry_method");
				insert.append(", rate");
				insert.append(", qty");
				insert.append(", override_date");
				insert.append(", override_by");
				insert.append(", override_rate");
				insert.append(", override_qty");
				insert.append(", billing_rate");
				insert.append(", billing_qty");
				insert.append(", override_reason");
				insert.append(", verified_date");
				insert.append(", verified_by");
				insert.append(", service_line_date");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getServiceID());
				insert.append(", ").append(this.getBillingServiceID());
				insert.append(", ").append(this.getStatusID());
				insert.append(", ").append(this.getServiceLineNo());
				insert.append(", ").append(this.getResourceID());
				insert.append(", ").append(this.getResourceItemID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getInvoicedFlag(), 240)));
				insert.append(", ").append(conn.toSQLString(this.getEnteredDate()));
				insert.append(", ").append(this.getEnteredBy());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getEntryMethod(), 20)));
				insert.append(", ").append(this.getRate());
				insert.append(", ").append(this.getQty());
				insert.append(", ").append(conn.toSQLString(this.getOverrideDate()));
				insert.append(", ").append(this.getOverrideBy());
				insert.append(", ").append(this.getOverrideRate());
				insert.append(", ").append(this.getOverrideQty());
				insert.append(", ").append(this.getBillingRate());
				insert.append(", ").append(this.getBillingQty());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getOverrideReason(), 2147483647)));
				insert.append(", ").append(conn.toSQLString(this.getVerifiedDate()));
				insert.append(", ").append(this.getVerifiedBy());
				insert.append(", ").append(conn.toSQLString(this.getServiceLineDate()));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO service_lines_temp (");
				insert.append("service_line_id");
				insert.append(", service_id");
				insert.append(", billing_service_id");
				insert.append(", status_id");
				insert.append(", service_line_no");
				insert.append(", resource_id");
				insert.append(", resource_item_id");
				insert.append(", invoiced_flag");
				insert.append(", entered_date");
				insert.append(", entered_by");
				insert.append(", entry_method");
				insert.append(", rate");
				insert.append(", qty");
				insert.append(", override_date");
				insert.append(", override_by");
				insert.append(", override_rate");
				insert.append(", override_qty");
				insert.append(", billing_rate");
				insert.append(", billing_qty");
				insert.append(", override_reason");
				insert.append(", verified_date");
				insert.append(", verified_by");
				insert.append(", service_line_date");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getServiceLineID());
				insert.append(", ").append(this.getServiceID());
				insert.append(", ").append(this.getBillingServiceID());
				insert.append(", ").append(this.getStatusID());
				insert.append(", ").append(this.getServiceLineNo());
				insert.append(", ").append(this.getResourceID());
				insert.append(", ").append(this.getResourceItemID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getInvoicedFlag(), 240)));
				insert.append(", ").append(conn.toSQLString(this.getEnteredDate()));
				insert.append(", ").append(this.getEnteredBy());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getEntryMethod(), 20)));
				insert.append(", ").append(this.getRate());
				insert.append(", ").append(this.getQty());
				insert.append(", ").append(conn.toSQLString(this.getOverrideDate()));
				insert.append(", ").append(this.getOverrideBy());
				insert.append(", ").append(this.getOverrideRate());
				insert.append(", ").append(this.getOverrideQty());
				insert.append(", ").append(this.getBillingRate());
				insert.append(", ").append(this.getBillingQty());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getOverrideReason(), 2147483647)));
				insert.append(", ").append(conn.toSQLString(this.getVerifiedDate()));
				insert.append(", ").append(this.getVerifiedBy());
				insert.append(", ").append(conn.toSQLString(this.getServiceLineDate()));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				serviceLineID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ServiceLinesTemp.internalInsert()");
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
		Diagnostics.trace("ServiceLinesTemp.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM service_lines_temp ");
			delete.append("WHERE (service_line_id = ").append(this.getServiceLineID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ServiceLinesTemp.internalDelete()");
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
		if (this.getServiceLineID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("ServiceLinesTemp:\n");
		result.append("  service_line_id = ").append(this.getServiceLineID()).append("\n");
		result.append("  service_id = ").append(this.getServiceID()).append("\n");
		result.append("  billing_service_id = ").append(this.getBillingServiceID()).append("\n");
		result.append("  status_id = ").append(this.getStatusID()).append("\n");
		result.append("  service_line_no = ").append(this.getServiceLineNo()).append("\n");
		result.append("  resource_id = ").append(this.getResourceID()).append("\n");
		result.append("  resource_item_id = ").append(this.getResourceItemID()).append("\n");
		result.append("  invoiced_flag = ").append(this.getInvoicedFlag()).append("\n");
		result.append("  entered_date = ").append(this.getEnteredDate()).append("\n");
		result.append("  entered_by = ").append(this.getEnteredBy()).append("\n");
		result.append("  entry_method = ").append(this.getEntryMethod()).append("\n");
		result.append("  rate = ").append(this.getRate()).append("\n");
		result.append("  qty = ").append(this.getQty()).append("\n");
		result.append("  override_date = ").append(this.getOverrideDate()).append("\n");
		result.append("  override_by = ").append(this.getOverrideBy()).append("\n");
		result.append("  override_rate = ").append(this.getOverrideRate()).append("\n");
		result.append("  override_qty = ").append(this.getOverrideQty()).append("\n");
		result.append("  billing_rate = ").append(this.getBillingRate()).append("\n");
		result.append("  billing_qty = ").append(this.getBillingQty()).append("\n");
		result.append("  override_reason = ").append(this.getOverrideReason()).append("\n");
		result.append("  verified_date = ").append(this.getVerifiedDate()).append("\n");
		result.append("  verified_by = ").append(this.getVerifiedBy()).append("\n");
		result.append("  service_line_date = ").append(this.getServiceLineDate()).append("\n");
		result.append("  date_created = ").append(this.getDateCreated()).append("\n");
		result.append("  created_by = ").append(this.getCreatedBy()).append("\n");
		result.append("  date_modified = ").append(this.getDateModified()).append("\n");
		result.append("  modified_by = ").append(this.getModifiedBy()).append("\n");
		return result.toString();
	}


	public int getServiceLineID()
	{
		return serviceLineID;
	}

	public int getServiceID()
	{
		return serviceID;
	}

	public int getBillingServiceID()
	{
		return billingServiceID;
	}

	public int getStatusID()
	{
		return statusID;
	}

	public int getServiceLineNo()
	{
		return serviceLineNo;
	}

	public int getResourceID()
	{
		return resourceID;
	}

	public int getResourceItemID()
	{
		return resourceItemID;
	}

	public String getInvoicedFlag()
	{
		return invoicedFlag;
	}

	public Date getEnteredDate()
	{
		return enteredDate;
	}

	public int getEnteredBy()
	{
		return enteredBy;
	}

	public String getEntryMethod()
	{
		return entryMethod;
	}

	public double getRate()
	{
		return rate;
	}

	public double getQty()
	{
		return qty;
	}

	public Date getOverrideDate()
	{
		return overrideDate;
	}

	public int getOverrideBy()
	{
		return overrideBy;
	}

	public double getOverrideRate()
	{
		return overrideRate;
	}

	public int getOverrideQty()
	{
		return overrideQty;
	}

	public double getBillingRate()
	{
		return billingRate;
	}

	public int getBillingQty()
	{
		return billingQty;
	}

	public String getOverrideReason()
	{
		return overrideReason;
	}

	public Date getVerifiedDate()
	{
		return verifiedDate;
	}

	public int getVerifiedBy()
	{
		return verifiedBy;
	}

	public Date getServiceLineDate()
	{
		return serviceLineDate;
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

	public void setServiceLineID(int serviceLineIDIn)
	{
		serviceLineID = serviceLineIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setServiceID(int serviceIDIn)
	{
		serviceID = serviceIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setBillingServiceID(int billingServiceIDIn)
	{
		billingServiceID = billingServiceIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setStatusID(int statusIDIn)
	{
		statusID = statusIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setServiceLineNo(int serviceLineNoIn)
	{
		serviceLineNo = serviceLineNoIn;
		handleAction(MODIFY_ACTION);
	}

	public void setResourceID(int resourceIDIn)
	{
		resourceID = resourceIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setResourceItemID(int resourceItemIDIn)
	{
		resourceItemID = resourceItemIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setInvoicedFlag(String invoicedFlagIn)
	{
		invoicedFlag = invoicedFlagIn;
		handleAction(MODIFY_ACTION);
	}

	public void setEnteredDate(Date enteredDateIn)
	{
		enteredDate = enteredDateIn;
		handleAction(MODIFY_ACTION);
	}

	public void setEnteredBy(int enteredByIn)
	{
		enteredBy = enteredByIn;
		handleAction(MODIFY_ACTION);
	}

	public void setEntryMethod(String entryMethodIn)
	{
		entryMethod = entryMethodIn;
		handleAction(MODIFY_ACTION);
	}

	public void setRate(double rateIn)
	{
		rate = rateIn;
		handleAction(MODIFY_ACTION);
	}

	public void setQty(double qtyIn)
	{
		qty = qtyIn;
		handleAction(MODIFY_ACTION);
	}

	public void setOverrideDate(Date overrideDateIn)
	{
		overrideDate = overrideDateIn;
		handleAction(MODIFY_ACTION);
	}

	public void setOverrideBy(int overrideByIn)
	{
		overrideBy = overrideByIn;
		handleAction(MODIFY_ACTION);
	}

	public void setOverrideRate(double overrideRateIn)
	{
		overrideRate = overrideRateIn;
		handleAction(MODIFY_ACTION);
	}

	public void setOverrideQty(int overrideQtyIn)
	{
		overrideQty = overrideQtyIn;
		handleAction(MODIFY_ACTION);
	}

	public void setBillingRate(double billingRateIn)
	{
		billingRate = billingRateIn;
		handleAction(MODIFY_ACTION);
	}

	public void setBillingQty(int billingQtyIn)
	{
		billingQty = billingQtyIn;
		handleAction(MODIFY_ACTION);
	}

	public void setOverrideReason(String overrideReasonIn)
	{
		overrideReason = overrideReasonIn;
		handleAction(MODIFY_ACTION);
	}

	public void setVerifiedDate(Date verifiedDateIn)
	{
		verifiedDate = verifiedDateIn;
		handleAction(MODIFY_ACTION);
	}

	public void setVerifiedBy(int verifiedByIn)
	{
		verifiedBy = verifiedByIn;
		handleAction(MODIFY_ACTION);
	}

	public void setServiceLineDate(Date serviceLineDateIn)
	{
		serviceLineDate = serviceLineDateIn;
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
