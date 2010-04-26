package ims.dataobjects;

import java.util.Date;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class ServiceLine extends AbstractDatabaseObject
{

	private int serviceLineID;
	private int serviceLineNo;
	private Date serviceLineDate;
	private int serviceID;
	private int billServiceID;
	private int statusID;
	private int resourceID;
	private int itemID;
	private String invoicedFlag;
	private Date enteredDate;
	private int enteredBy;
	private String entryMethod;
	private double rate;
	private double qty;
	private String extPayCode;
	private Date overrideDate;
	private int overrideBy;
	private double overrideRate;
	private int overrideQty;
	private double billRate;
	private double billQty;
	private String billableFlag;
	private int overrideReason;
	private Date verifiedDate;
	private int verifiedBy;
	private int invoiceID;
	private int palmRepID;
	private int serviceLineTypeID;
	private int pfServiceID;
	private int payrollStatusTypeID;
	private Date dateCreated;
	private int createdBy;
	private Date dateModified;
	private int modifiedBy;

	public ServiceLine()
	{
		super();
	}


	public static ServiceLine fetch(String serviceLineID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(serviceLineID), ic, null);
	}

	public static ServiceLine fetch(String serviceLineID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(serviceLineID), ic, resourceName);
	}

	public static ServiceLine fetch(int serviceLineID, InvocationContext ic)
	{
		 return fetch(serviceLineID, ic, null);
	}

	public static ServiceLine fetch(int serviceLineID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("ServiceLine.fetch()");

		ServiceLine result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT service_line_id ");
			query.append(", service_line_no ");
			query.append(", service_line_date ");
			query.append(", service_id ");
			query.append(", bill_service_id ");
			query.append(", status_id ");
			query.append(", resource_id ");
			query.append(", item_id ");
			query.append(", invoiced_flag ");
			query.append(", entered_date ");
			query.append(", entered_by ");
			query.append(", entry_method ");
			query.append(", rate ");
			query.append(", qty ");
			query.append(", ext_pay_code ");
			query.append(", override_date ");
			query.append(", override_by ");
			query.append(", override_rate ");
			query.append(", override_qty ");
			query.append(", bill_rate ");
			query.append(", bill_qty ");
			query.append(", billable_flag ");
			query.append(", override_reason ");
			query.append(", verified_date ");
			query.append(", verified_by ");
			query.append(", invoice_id ");
			query.append(", palm_rep_id ");
			query.append(", service_line_type_id ");
			query.append(", pf_service_id ");
			query.append(", payroll_status_type_id ");
			query.append(", date_created ");
			query.append(", created_by ");
			query.append(", date_modified ");
			query.append(", modified_by ");
			query.append("FROM service_lines ");
			query.append("WHERE (service_line_id = ").append(serviceLineID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new ServiceLine();
				result.setServiceLineID(rs.getInt(1));
				result.setServiceLineNo(rs.getInt(2));
				result.setServiceLineDate(rs.getDate(3));
				result.setServiceID(rs.getInt(4));
				result.setBillServiceID(rs.getInt(5));
				result.setStatusID(rs.getInt(6));
				result.setResourceID(rs.getInt(7));
				result.setItemID(rs.getInt(8));
				result.setInvoicedFlag(rs.getString(9));
				result.setEnteredDate(rs.getDate(10));
				result.setEnteredBy(rs.getInt(11));
				result.setEntryMethod(rs.getString(12));
				result.setRate(rs.getDouble(13));
				result.setQty(rs.getDouble(14));
				result.setExtPayCode(rs.getString(15));
				result.setOverrideDate(rs.getDate(16));
				result.setOverrideBy(rs.getInt(17));
				result.setOverrideRate(rs.getDouble(18));
				result.setOverrideQty(rs.getInt(19));
				result.setBillRate(rs.getDouble(20));
				result.setBillQty(rs.getDouble(21));
				result.setBillableFlag(rs.getString(22));
				result.setOverrideReason(rs.getInt(23));
				result.setVerifiedDate(rs.getDate(24));
				result.setVerifiedBy(rs.getInt(25));
				result.setInvoiceID(rs.getInt(26));
				result.setPalmRepID(rs.getInt(27));
				result.setServiceLineTypeID(rs.getInt(28));
				result.setPfServiceID(rs.getInt(29));
				result.setPayrollStatusTypeID(rs.getInt(30));
				result.setDateCreated(rs.getDate(31));
				result.setCreatedBy(rs.getInt(32));
				result.setDateModified(rs.getDate(33));
				result.setModifiedBy(rs.getInt(34));
			}
			else
			{
				Diagnostics.error("Error in ServiceLine.fetch(), Could not find ServiceLine; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ServiceLine.fetch()");
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
		Diagnostics.trace("ServiceLine.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE service_lines ");
			update.append("SET service_line_no = ").append(this.getServiceLineNo());
			update.append(", service_line_date = ").append(conn.toSQLString(this.getServiceLineDate()));
			update.append(", service_id = ").append(this.getServiceID());
			update.append(", bill_service_id = ").append(this.getBillServiceID());
			update.append(", status_id = ").append(this.getStatusID());
			update.append(", resource_id = ").append(this.getResourceID());
			update.append(", item_id = ").append(this.getItemID());
			update.append(", invoiced_flag = ").append(conn.toSQLString(StringUtil.truncate(this.getInvoicedFlag(), 10)));
			update.append(", entered_date = ").append(conn.toSQLString(this.getEnteredDate()));
			update.append(", entered_by = ").append(this.getEnteredBy());
			update.append(", entry_method = ").append(conn.toSQLString(StringUtil.truncate(this.getEntryMethod(), 20)));
			update.append(", rate = ").append(this.getRate());
			update.append(", qty = ").append(this.getQty());
			update.append(", ext_pay_code = ").append(conn.toSQLString(StringUtil.truncate(this.getExtPayCode(), 7)));
			update.append(", override_date = ").append(conn.toSQLString(this.getOverrideDate()));
			update.append(", override_by = ").append(this.getOverrideBy());
			update.append(", override_rate = ").append(this.getOverrideRate());
			update.append(", override_qty = ").append(this.getOverrideQty());
			update.append(", bill_rate = ").append(this.getBillRate());
			update.append(", bill_qty = ").append(this.getBillQty());
			update.append(", billable_flag = ").append(conn.toSQLString(StringUtil.truncate(this.getBillableFlag(), 10)));
			update.append(", override_reason = ").append(this.getOverrideReason());
			update.append(", verified_date = ").append(conn.toSQLString(this.getVerifiedDate()));
			update.append(", verified_by = ").append(this.getVerifiedBy());
			update.append(", invoice_id = ").append(this.getInvoiceID());
			update.append(", palm_rep_id = ").append(this.getPalmRepID());
			update.append(", service_line_type_id = ").append(this.getServiceLineTypeID());
			update.append(", pf_service_id = ").append(this.getPfServiceID());
			update.append(", payroll_status_type_id = ").append(this.getPayrollStatusTypeID());
			update.append(", date_created = ").append(conn.toSQLString(this.getDateCreated()));
			update.append(", created_by = ").append(this.getCreatedBy());
			update.append(", date_modified = ").append(conn.toSQLString(this.getDateModified()));
			update.append(", modified_by = ").append(this.getModifiedBy());
			update.append("WHERE (service_line_id = ").append(this.getServiceLineID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ServiceLine.internalUpdate()");
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
		Diagnostics.trace("ServiceLine.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO service_lines (");
				insert.append("service_line_no");
				insert.append(", service_line_date");
				insert.append(", service_id");
				insert.append(", bill_service_id");
				insert.append(", status_id");
				insert.append(", resource_id");
				insert.append(", item_id");
				insert.append(", invoiced_flag");
				insert.append(", entered_date");
				insert.append(", entered_by");
				insert.append(", entry_method");
				insert.append(", rate");
				insert.append(", qty");
				insert.append(", ext_pay_code");
				insert.append(", override_date");
				insert.append(", override_by");
				insert.append(", override_rate");
				insert.append(", override_qty");
				insert.append(", bill_rate");
				insert.append(", bill_qty");
				insert.append(", billable_flag");
				insert.append(", override_reason");
				insert.append(", verified_date");
				insert.append(", verified_by");
				insert.append(", invoice_id");
				insert.append(", palm_rep_id");
				insert.append(", service_line_type_id");
				insert.append(", pf_service_id");
				insert.append(", payroll_status_type_id");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getServiceLineNo());
				insert.append(", ").append(conn.toSQLString(this.getServiceLineDate()));
				insert.append(", ").append(this.getServiceID());
				insert.append(", ").append(this.getBillServiceID());
				insert.append(", ").append(this.getStatusID());
				insert.append(", ").append(this.getResourceID());
				insert.append(", ").append(this.getItemID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getInvoicedFlag(), 10)));
				insert.append(", ").append(conn.toSQLString(this.getEnteredDate()));
				insert.append(", ").append(this.getEnteredBy());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getEntryMethod(), 20)));
				insert.append(", ").append(this.getRate());
				insert.append(", ").append(this.getQty());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getExtPayCode(), 7)));
				insert.append(", ").append(conn.toSQLString(this.getOverrideDate()));
				insert.append(", ").append(this.getOverrideBy());
				insert.append(", ").append(this.getOverrideRate());
				insert.append(", ").append(this.getOverrideQty());
				insert.append(", ").append(this.getBillRate());
				insert.append(", ").append(this.getBillQty());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getBillableFlag(), 10)));
				insert.append(", ").append(this.getOverrideReason());
				insert.append(", ").append(conn.toSQLString(this.getVerifiedDate()));
				insert.append(", ").append(this.getVerifiedBy());
				insert.append(", ").append(this.getInvoiceID());
				insert.append(", ").append(this.getPalmRepID());
				insert.append(", ").append(this.getServiceLineTypeID());
				insert.append(", ").append(this.getPfServiceID());
				insert.append(", ").append(this.getPayrollStatusTypeID());
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO service_lines (");
				insert.append("service_line_id");
				insert.append(", service_line_no");
				insert.append(", service_line_date");
				insert.append(", service_id");
				insert.append(", bill_service_id");
				insert.append(", status_id");
				insert.append(", resource_id");
				insert.append(", item_id");
				insert.append(", invoiced_flag");
				insert.append(", entered_date");
				insert.append(", entered_by");
				insert.append(", entry_method");
				insert.append(", rate");
				insert.append(", qty");
				insert.append(", ext_pay_code");
				insert.append(", override_date");
				insert.append(", override_by");
				insert.append(", override_rate");
				insert.append(", override_qty");
				insert.append(", bill_rate");
				insert.append(", bill_qty");
				insert.append(", billable_flag");
				insert.append(", override_reason");
				insert.append(", verified_date");
				insert.append(", verified_by");
				insert.append(", invoice_id");
				insert.append(", palm_rep_id");
				insert.append(", service_line_type_id");
				insert.append(", pf_service_id");
				insert.append(", payroll_status_type_id");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getServiceLineID());
				insert.append(", ").append(this.getServiceLineNo());
				insert.append(", ").append(conn.toSQLString(this.getServiceLineDate()));
				insert.append(", ").append(this.getServiceID());
				insert.append(", ").append(this.getBillServiceID());
				insert.append(", ").append(this.getStatusID());
				insert.append(", ").append(this.getResourceID());
				insert.append(", ").append(this.getItemID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getInvoicedFlag(), 10)));
				insert.append(", ").append(conn.toSQLString(this.getEnteredDate()));
				insert.append(", ").append(this.getEnteredBy());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getEntryMethod(), 20)));
				insert.append(", ").append(this.getRate());
				insert.append(", ").append(this.getQty());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getExtPayCode(), 7)));
				insert.append(", ").append(conn.toSQLString(this.getOverrideDate()));
				insert.append(", ").append(this.getOverrideBy());
				insert.append(", ").append(this.getOverrideRate());
				insert.append(", ").append(this.getOverrideQty());
				insert.append(", ").append(this.getBillRate());
				insert.append(", ").append(this.getBillQty());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getBillableFlag(), 10)));
				insert.append(", ").append(this.getOverrideReason());
				insert.append(", ").append(conn.toSQLString(this.getVerifiedDate()));
				insert.append(", ").append(this.getVerifiedBy());
				insert.append(", ").append(this.getInvoiceID());
				insert.append(", ").append(this.getPalmRepID());
				insert.append(", ").append(this.getServiceLineTypeID());
				insert.append(", ").append(this.getPfServiceID());
				insert.append(", ").append(this.getPayrollStatusTypeID());
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
			ErrorHandler.handleException(ic, e, "Exception in ServiceLine.internalInsert()");
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
		Diagnostics.trace("ServiceLine.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM service_lines ");
			delete.append("WHERE (service_line_id = ").append(this.getServiceLineID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ServiceLine.internalDelete()");
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
		result.append("ServiceLine:\n");
		result.append("  service_line_id = ").append(this.getServiceLineID()).append("\n");
		result.append("  service_line_no = ").append(this.getServiceLineNo()).append("\n");
		result.append("  service_line_date = ").append(this.getServiceLineDate()).append("\n");
		result.append("  service_id = ").append(this.getServiceID()).append("\n");
		result.append("  bill_service_id = ").append(this.getBillServiceID()).append("\n");
		result.append("  status_id = ").append(this.getStatusID()).append("\n");
		result.append("  resource_id = ").append(this.getResourceID()).append("\n");
		result.append("  item_id = ").append(this.getItemID()).append("\n");
		result.append("  invoiced_flag = ").append(this.getInvoicedFlag()).append("\n");
		result.append("  entered_date = ").append(this.getEnteredDate()).append("\n");
		result.append("  entered_by = ").append(this.getEnteredBy()).append("\n");
		result.append("  entry_method = ").append(this.getEntryMethod()).append("\n");
		result.append("  rate = ").append(this.getRate()).append("\n");
		result.append("  qty = ").append(this.getQty()).append("\n");
		result.append("  ext_pay_code = ").append(this.getExtPayCode()).append("\n");
		result.append("  override_date = ").append(this.getOverrideDate()).append("\n");
		result.append("  override_by = ").append(this.getOverrideBy()).append("\n");
		result.append("  override_rate = ").append(this.getOverrideRate()).append("\n");
		result.append("  override_qty = ").append(this.getOverrideQty()).append("\n");
		result.append("  bill_rate = ").append(this.getBillRate()).append("\n");
		result.append("  bill_qty = ").append(this.getBillQty()).append("\n");
		result.append("  billable_flag = ").append(this.getBillableFlag()).append("\n");
		result.append("  override_reason = ").append(this.getOverrideReason()).append("\n");
		result.append("  verified_date = ").append(this.getVerifiedDate()).append("\n");
		result.append("  verified_by = ").append(this.getVerifiedBy()).append("\n");
		result.append("  invoice_id = ").append(this.getInvoiceID()).append("\n");
		result.append("  palm_rep_id = ").append(this.getPalmRepID()).append("\n");
		result.append("  service_line_type_id = ").append(this.getServiceLineTypeID()).append("\n");
		result.append("  pf_service_id = ").append(this.getPfServiceID()).append("\n");
		result.append("  payroll_status_type_id = ").append(this.getPayrollStatusTypeID()).append("\n");
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

	public int getServiceLineNo()
	{
		return serviceLineNo;
	}

	public Date getServiceLineDate()
	{
		return serviceLineDate;
	}

	public int getServiceID()
	{
		return serviceID;
	}

	public int getBillServiceID()
	{
		return billServiceID;
	}

	public int getStatusID()
	{
		return statusID;
	}

	public int getResourceID()
	{
		return resourceID;
	}

	public int getItemID()
	{
		return itemID;
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

	public String getExtPayCode()
	{
		return extPayCode;
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

	public double getBillRate()
	{
		return billRate;
	}

	public double getBillQty()
	{
		return billQty;
	}

	public String getBillableFlag()
	{
		return billableFlag;
	}

	public int getOverrideReason()
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

	public int getInvoiceID()
	{
		return invoiceID;
	}

	public int getPalmRepID()
	{
		return palmRepID;
	}

	public int getServiceLineTypeID()
	{
		return serviceLineTypeID;
	}

	public int getPfServiceID()
	{
		return pfServiceID;
	}

	public int getPayrollStatusTypeID()
	{
		return payrollStatusTypeID;
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

	public void setServiceLineNo(int serviceLineNoIn)
	{
		serviceLineNo = serviceLineNoIn;
		handleAction(MODIFY_ACTION);
	}

	public void setServiceLineDate(Date serviceLineDateIn)
	{
		serviceLineDate = serviceLineDateIn;
		handleAction(MODIFY_ACTION);
	}

	public void setServiceID(int serviceIDIn)
	{
		serviceID = serviceIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setBillServiceID(int billServiceIDIn)
	{
		billServiceID = billServiceIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setStatusID(int statusIDIn)
	{
		statusID = statusIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setResourceID(int resourceIDIn)
	{
		resourceID = resourceIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setItemID(int itemIDIn)
	{
		itemID = itemIDIn;
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

	public void setExtPayCode(String extPayCodeIn)
	{
		extPayCode = extPayCodeIn;
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

	public void setBillRate(double billRateIn)
	{
		billRate = billRateIn;
		handleAction(MODIFY_ACTION);
	}

	public void setBillQty(double billQtyIn)
	{
		billQty = billQtyIn;
		handleAction(MODIFY_ACTION);
	}

	public void setBillableFlag(String billableFlagIn)
	{
		billableFlag = billableFlagIn;
		handleAction(MODIFY_ACTION);
	}

	public void setOverrideReason(int overrideReasonIn)
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

	public void setInvoiceID(int invoiceIDIn)
	{
		invoiceID = invoiceIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setPalmRepID(int palmRepIDIn)
	{
		palmRepID = palmRepIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setServiceLineTypeID(int serviceLineTypeIDIn)
	{
		serviceLineTypeID = serviceLineTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setPfServiceID(int pfServiceIDIn)
	{
		pfServiceID = pfServiceIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setPayrollStatusTypeID(int payrollStatusTypeIDIn)
	{
		payrollStatusTypeID = payrollStatusTypeIDIn;
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
