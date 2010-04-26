package ims.dataobjects;

import java.util.Date;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class InvoiceLine extends AbstractDatabaseObject
{

	private int invoiceLineID;
	private int invoiceID;
	private int itemID;
	private int invoiceLineNo;
	private String description;
	private double unitPrice;
	private int qty;
	private double extendedPrice;
	private Date dateCreated;
	private int createdBy;
	private Date dateModified;
	private int modifiedBy;

	public InvoiceLine()
	{
		super();
	}


	public static InvoiceLine fetch(String invoiceLineID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(invoiceLineID), ic, null);
	}

	public static InvoiceLine fetch(String invoiceLineID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(invoiceLineID), ic, resourceName);
	}

	public static InvoiceLine fetch(int invoiceLineID, InvocationContext ic)
	{
		 return fetch(invoiceLineID, ic, null);
	}

	public static InvoiceLine fetch(int invoiceLineID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("InvoiceLine.fetch()");

		InvoiceLine result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT invoice_line_id ");
			query.append(", invoice_id ");
			query.append(", item_id ");
			query.append(", invoice_line_no ");
			query.append(", description ");
			query.append(", unit_price ");
			query.append(", qty ");
			query.append(", extended_price ");
			query.append(", date_created ");
			query.append(", created_by ");
			query.append(", date_modified ");
			query.append(", modified_by ");
			query.append("FROM invoice_lines ");
			query.append("WHERE (invoice_line_id = ").append(invoiceLineID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new InvoiceLine();
				result.setInvoiceLineID(rs.getInt(1));
				result.setInvoiceID(rs.getInt(2));
				result.setItemID(rs.getInt(3));
				result.setInvoiceLineNo(rs.getInt(4));
				result.setDescription(rs.getString(5));
				result.setUnitPrice(rs.getDouble(6));
				result.setQty(rs.getInt(7));
				result.setExtendedPrice(rs.getDouble(8));
				result.setDateCreated(rs.getDate(9));
				result.setCreatedBy(rs.getInt(10));
				result.setDateModified(rs.getDate(11));
				result.setModifiedBy(rs.getInt(12));
			}
			else
			{
				Diagnostics.error("Error in InvoiceLine.fetch(), Could not find InvoiceLine; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in InvoiceLine.fetch()");
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
		Diagnostics.trace("InvoiceLine.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE invoice_lines ");
			update.append("SET invoice_id = ").append(this.getInvoiceID());
			update.append(", item_id = ").append(this.getItemID());
			update.append(", invoice_line_no = ").append(this.getInvoiceLineNo());
			update.append(", description = ").append(conn.toSQLString(StringUtil.truncate(this.getDescription(), 2147483647)));
			update.append(", unit_price = ").append(this.getUnitPrice());
			update.append(", qty = ").append(this.getQty());
			update.append(", extended_price = ").append(this.getExtendedPrice());
			update.append(", date_created = ").append(conn.toSQLString(this.getDateCreated()));
			update.append(", created_by = ").append(this.getCreatedBy());
			update.append(", date_modified = ").append(conn.toSQLString(this.getDateModified()));
			update.append(", modified_by = ").append(this.getModifiedBy());
			update.append("WHERE (invoice_line_id = ").append(this.getInvoiceLineID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in InvoiceLine.internalUpdate()");
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
		Diagnostics.trace("InvoiceLine.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO invoice_lines (");
				insert.append("invoice_id");
				insert.append(", item_id");
				insert.append(", invoice_line_no");
				insert.append(", description");
				insert.append(", unit_price");
				insert.append(", qty");
				insert.append(", extended_price");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getInvoiceID());
				insert.append(", ").append(this.getItemID());
				insert.append(", ").append(this.getInvoiceLineNo());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getDescription(), 2147483647)));
				insert.append(", ").append(this.getUnitPrice());
				insert.append(", ").append(this.getQty());
				insert.append(", ").append(this.getExtendedPrice());
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO invoice_lines (");
				insert.append("invoice_line_id");
				insert.append(", invoice_id");
				insert.append(", item_id");
				insert.append(", invoice_line_no");
				insert.append(", description");
				insert.append(", unit_price");
				insert.append(", qty");
				insert.append(", extended_price");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getInvoiceLineID());
				insert.append(", ").append(this.getInvoiceID());
				insert.append(", ").append(this.getItemID());
				insert.append(", ").append(this.getInvoiceLineNo());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getDescription(), 2147483647)));
				insert.append(", ").append(this.getUnitPrice());
				insert.append(", ").append(this.getQty());
				insert.append(", ").append(this.getExtendedPrice());
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				invoiceLineID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in InvoiceLine.internalInsert()");
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
		Diagnostics.trace("InvoiceLine.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM invoice_lines ");
			delete.append("WHERE (invoice_line_id = ").append(this.getInvoiceLineID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in InvoiceLine.internalDelete()");
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
		if (this.getInvoiceLineID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("InvoiceLine:\n");
		result.append("  invoice_line_id = ").append(this.getInvoiceLineID()).append("\n");
		result.append("  invoice_id = ").append(this.getInvoiceID()).append("\n");
		result.append("  item_id = ").append(this.getItemID()).append("\n");
		result.append("  invoice_line_no = ").append(this.getInvoiceLineNo()).append("\n");
		result.append("  description = ").append(this.getDescription()).append("\n");
		result.append("  unit_price = ").append(this.getUnitPrice()).append("\n");
		result.append("  qty = ").append(this.getQty()).append("\n");
		result.append("  extended_price = ").append(this.getExtendedPrice()).append("\n");
		result.append("  date_created = ").append(this.getDateCreated()).append("\n");
		result.append("  created_by = ").append(this.getCreatedBy()).append("\n");
		result.append("  date_modified = ").append(this.getDateModified()).append("\n");
		result.append("  modified_by = ").append(this.getModifiedBy()).append("\n");
		return result.toString();
	}


	public int getInvoiceLineID()
	{
		return invoiceLineID;
	}

	public int getInvoiceID()
	{
		return invoiceID;
	}

	public int getItemID()
	{
		return itemID;
	}

	public int getInvoiceLineNo()
	{
		return invoiceLineNo;
	}

	public String getDescription()
	{
		return description;
	}

	public double getUnitPrice()
	{
		return unitPrice;
	}

	public int getQty()
	{
		return qty;
	}

	public double getExtendedPrice()
	{
		return extendedPrice;
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

	public void setInvoiceLineID(int invoiceLineIDIn)
	{
		invoiceLineID = invoiceLineIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setInvoiceID(int invoiceIDIn)
	{
		invoiceID = invoiceIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setItemID(int itemIDIn)
	{
		itemID = itemIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setInvoiceLineNo(int invoiceLineNoIn)
	{
		invoiceLineNo = invoiceLineNoIn;
		handleAction(MODIFY_ACTION);
	}

	public void setDescription(String descriptionIn)
	{
		description = descriptionIn;
		handleAction(MODIFY_ACTION);
	}

	public void setUnitPrice(double unitPriceIn)
	{
		unitPrice = unitPriceIn;
		handleAction(MODIFY_ACTION);
	}

	public void setQty(int qtyIn)
	{
		qty = qtyIn;
		handleAction(MODIFY_ACTION);
	}

	public void setExtendedPrice(double extendedPriceIn)
	{
		extendedPrice = extendedPriceIn;
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
