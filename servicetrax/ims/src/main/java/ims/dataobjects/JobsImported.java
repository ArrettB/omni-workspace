package ims.dataobjects;

import java.util.Date;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class JobsImported extends AbstractDatabaseObject
{

	private int jobImportID;
	private String jobNo;
	private String office;
	private int officeLookupID;
	private String dealer;
	private int dealerLookupID;
	private String dealerContactName;
	private String dealerContactPhone;
	private String poNo;
	private int poLineNo;
	private int poLineQty;
	private double unitPrice;
	private double extendedPrice;
	private Date dateReleased;
	private String wsContactName;
	private String wsContactPhone;
	private String specialInstr;
	private String textToParse;
	private String workSiteCustName;
	private String wsAddress1;
	private String wsAddress2;
	private String wsAddress3;
	private String deliveryCode;
	private int deliveryTypeID;
	private String warehouseCode;
	private String chargeCode;
	private int chargeTypeID;
	private String punchlistCode;
	private int punchlistTypeID;
	private Date estStartDate;
	private Date estStartTime;
	private Date completionDate;
	private String woodProductFlag;
	private String blueprintLocation;
	private String productSetupDesc;
	private Date dateCreated;
	private int createdBy;
	private Date dateModified;
	private int modifiedBy;

	public JobsImported()
	{
		super();
	}


	public static JobsImported fetch(String jobImportID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(jobImportID), ic, null);
	}

	public static JobsImported fetch(String jobImportID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(jobImportID), ic, resourceName);
	}

	public static JobsImported fetch(int jobImportID, InvocationContext ic)
	{
		 return fetch(jobImportID, ic, null);
	}

	public static JobsImported fetch(int jobImportID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("JobsImported.fetch()");

		JobsImported result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT job_import_id ");
			query.append(", job_no ");
			query.append(", office ");
			query.append(", office_lookup_id ");
			query.append(", dealer ");
			query.append(", dealer_lookup_id ");
			query.append(", dealer_contact_name ");
			query.append(", dealer_contact_phone ");
			query.append(", po_no ");
			query.append(", po_line_no ");
			query.append(", po_line_qty ");
			query.append(", unit_price ");
			query.append(", extended_price ");
			query.append(", date_released ");
			query.append(", ws_contact_name ");
			query.append(", ws_contact_phone ");
			query.append(", special_instr ");
			query.append(", text_to_parse ");
			query.append(", work_site_cust_name ");
			query.append(", ws_address1 ");
			query.append(", ws_address2 ");
			query.append(", ws_address3 ");
			query.append(", delivery_code ");
			query.append(", delivery_type_id ");
			query.append(", warehouse_code ");
			query.append(", charge_code ");
			query.append(", charge_type_id ");
			query.append(", punchlist_code ");
			query.append(", punchlist_type_id ");
			query.append(", est_start_date ");
			query.append(", est_start_time ");
			query.append(", completion_date ");
			query.append(", wood_product_flag ");
			query.append(", blueprint_location ");
			query.append(", product_setup_desc ");
			query.append(", date_created ");
			query.append(", created_by ");
			query.append(", date_modified ");
			query.append(", modified_by ");
			query.append("FROM jobs_imported ");
			query.append("WHERE (job_import_id = ").append(jobImportID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new JobsImported();
				result.setJobImportID(rs.getInt(1));
				result.setJobNo(rs.getString(2));
				result.setOffice(rs.getString(3));
				result.setOfficeLookupID(rs.getInt(4));
				result.setDealer(rs.getString(5));
				result.setDealerLookupID(rs.getInt(6));
				result.setDealerContactName(rs.getString(7));
				result.setDealerContactPhone(rs.getString(8));
				result.setPoNo(rs.getString(9));
				result.setPoLineNo(rs.getInt(10));
				result.setPoLineQty(rs.getInt(11));
				result.setUnitPrice(rs.getDouble(12));
				result.setExtendedPrice(rs.getDouble(13));
				result.setDateReleased(rs.getDate(14));
				result.setWsContactName(rs.getString(15));
				result.setWsContactPhone(rs.getString(16));
				result.setSpecialInstr(rs.getString(17));
				result.setTextToParse(rs.getString(18));
				result.setWorkSiteCustName(rs.getString(19));
				result.setWsAddress1(rs.getString(20));
				result.setWsAddress2(rs.getString(21));
				result.setWsAddress3(rs.getString(22));
				result.setDeliveryCode(rs.getString(23));
				result.setDeliveryTypeID(rs.getInt(24));
				result.setWarehouseCode(rs.getString(25));
				result.setChargeCode(rs.getString(26));
				result.setChargeTypeID(rs.getInt(27));
				result.setPunchlistCode(rs.getString(28));
				result.setPunchlistTypeID(rs.getInt(29));
				result.setEstStartDate(rs.getDate(30));
				result.setEstStartTime(rs.getDate(31));
				result.setCompletionDate(rs.getDate(32));
				result.setWoodProductFlag(rs.getString(33));
				result.setBlueprintLocation(rs.getString(34));
				result.setProductSetupDesc(rs.getString(35));
				result.setDateCreated(rs.getDate(36));
				result.setCreatedBy(rs.getInt(37));
				result.setDateModified(rs.getDate(38));
				result.setModifiedBy(rs.getInt(39));
			}
			else
			{
				Diagnostics.error("Error in JobsImported.fetch(), Could not find JobsImported; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in JobsImported.fetch()");
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
		Diagnostics.trace("JobsImported.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE jobs_imported ");
			update.append("SET job_no = ").append(conn.toSQLString(StringUtil.truncate(this.getJobNo(), 30)));
			update.append(", office = ").append(conn.toSQLString(StringUtil.truncate(this.getOffice(), 50)));
			update.append(", office_lookup_id = ").append(this.getOfficeLookupID());
			update.append(", dealer = ").append(conn.toSQLString(StringUtil.truncate(this.getDealer(), 50)));
			update.append(", dealer_lookup_id = ").append(this.getDealerLookupID());
			update.append(", dealer_contact_name = ").append(conn.toSQLString(StringUtil.truncate(this.getDealerContactName(), 100)));
			update.append(", dealer_contact_phone = ").append(conn.toSQLString(StringUtil.truncate(this.getDealerContactPhone(), 50)));
			update.append(", po_no = ").append(conn.toSQLString(StringUtil.truncate(this.getPoNo(), 50)));
			update.append(", po_line_no = ").append(this.getPoLineNo());
			update.append(", po_line_qty = ").append(this.getPoLineQty());
			update.append(", unit_price = ").append(this.getUnitPrice());
			update.append(", extended_price = ").append(this.getExtendedPrice());
			update.append(", date_released = ").append(conn.toSQLString(this.getDateReleased()));
			update.append(", ws_contact_name = ").append(conn.toSQLString(StringUtil.truncate(this.getWsContactName(), 100)));
			update.append(", ws_contact_phone = ").append(conn.toSQLString(StringUtil.truncate(this.getWsContactPhone(), 50)));
			update.append(", special_instr = ").append(conn.toSQLString(StringUtil.truncate(this.getSpecialInstr(), 250)));
			update.append(", text_to_parse = ").append(conn.toSQLString(StringUtil.truncate(this.getTextToParse(), 1000)));
			update.append(", work_site_cust_name = ").append(conn.toSQLString(StringUtil.truncate(this.getWorkSiteCustName(), 100)));
			update.append(", ws_address1 = ").append(conn.toSQLString(StringUtil.truncate(this.getWsAddress1(), 100)));
			update.append(", ws_address2 = ").append(conn.toSQLString(StringUtil.truncate(this.getWsAddress2(), 100)));
			update.append(", ws_address3 = ").append(conn.toSQLString(StringUtil.truncate(this.getWsAddress3(), 100)));
			update.append(", delivery_code = ").append(conn.toSQLString(StringUtil.truncate(this.getDeliveryCode(), 10)));
			update.append(", delivery_type_id = ").append(this.getDeliveryTypeID());
			update.append(", warehouse_code = ").append(conn.toSQLString(StringUtil.truncate(this.getWarehouseCode(), 50)));
			update.append(", charge_code = ").append(conn.toSQLString(StringUtil.truncate(this.getChargeCode(), 10)));
			update.append(", charge_type_id = ").append(this.getChargeTypeID());
			update.append(", punchlist_code = ").append(conn.toSQLString(StringUtil.truncate(this.getPunchlistCode(), 10)));
			update.append(", punchlist_type_id = ").append(this.getPunchlistTypeID());
			update.append(", est_start_date = ").append(conn.toSQLString(this.getEstStartDate()));
			update.append(", est_start_time = ").append(conn.toSQLString(this.getEstStartTime()));
			update.append(", completion_date = ").append(conn.toSQLString(this.getCompletionDate()));
			update.append(", wood_product_flag = ").append(conn.toSQLString(StringUtil.truncate(this.getWoodProductFlag(), 10)));
			update.append(", blueprint_location = ").append(conn.toSQLString(StringUtil.truncate(this.getBlueprintLocation(), 100)));
			update.append(", product_setup_desc = ").append(conn.toSQLString(StringUtil.truncate(this.getProductSetupDesc(), 750)));
			update.append(", date_created = ").append(conn.toSQLString(this.getDateCreated()));
			update.append(", created_by = ").append(this.getCreatedBy());
			update.append(", date_modified = ").append(conn.toSQLString(this.getDateModified()));
			update.append(", modified_by = ").append(this.getModifiedBy());
			update.append("WHERE (job_import_id = ").append(this.getJobImportID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in JobsImported.internalUpdate()");
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
		Diagnostics.trace("JobsImported.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO jobs_imported (");
				insert.append("job_no");
				insert.append(", office");
				insert.append(", office_lookup_id");
				insert.append(", dealer");
				insert.append(", dealer_lookup_id");
				insert.append(", dealer_contact_name");
				insert.append(", dealer_contact_phone");
				insert.append(", po_no");
				insert.append(", po_line_no");
				insert.append(", po_line_qty");
				insert.append(", unit_price");
				insert.append(", extended_price");
				insert.append(", date_released");
				insert.append(", ws_contact_name");
				insert.append(", ws_contact_phone");
				insert.append(", special_instr");
				insert.append(", text_to_parse");
				insert.append(", work_site_cust_name");
				insert.append(", ws_address1");
				insert.append(", ws_address2");
				insert.append(", ws_address3");
				insert.append(", delivery_code");
				insert.append(", delivery_type_id");
				insert.append(", warehouse_code");
				insert.append(", charge_code");
				insert.append(", charge_type_id");
				insert.append(", punchlist_code");
				insert.append(", punchlist_type_id");
				insert.append(", est_start_date");
				insert.append(", est_start_time");
				insert.append(", completion_date");
				insert.append(", wood_product_flag");
				insert.append(", blueprint_location");
				insert.append(", product_setup_desc");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(conn.toSQLString(StringUtil.truncate(this.getJobNo(), 30)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getOffice(), 50)));
				insert.append(", ").append(this.getOfficeLookupID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getDealer(), 50)));
				insert.append(", ").append(this.getDealerLookupID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getDealerContactName(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getDealerContactPhone(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getPoNo(), 50)));
				insert.append(", ").append(this.getPoLineNo());
				insert.append(", ").append(this.getPoLineQty());
				insert.append(", ").append(this.getUnitPrice());
				insert.append(", ").append(this.getExtendedPrice());
				insert.append(", ").append(conn.toSQLString(this.getDateReleased()));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getWsContactName(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getWsContactPhone(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getSpecialInstr(), 250)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getTextToParse(), 1000)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getWorkSiteCustName(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getWsAddress1(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getWsAddress2(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getWsAddress3(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getDeliveryCode(), 10)));
				insert.append(", ").append(this.getDeliveryTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getWarehouseCode(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getChargeCode(), 10)));
				insert.append(", ").append(this.getChargeTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getPunchlistCode(), 10)));
				insert.append(", ").append(this.getPunchlistTypeID());
				insert.append(", ").append(conn.toSQLString(this.getEstStartDate()));
				insert.append(", ").append(conn.toSQLString(this.getEstStartTime()));
				insert.append(", ").append(conn.toSQLString(this.getCompletionDate()));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getWoodProductFlag(), 10)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getBlueprintLocation(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getProductSetupDesc(), 750)));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO jobs_imported (");
				insert.append("job_import_id");
				insert.append(", job_no");
				insert.append(", office");
				insert.append(", office_lookup_id");
				insert.append(", dealer");
				insert.append(", dealer_lookup_id");
				insert.append(", dealer_contact_name");
				insert.append(", dealer_contact_phone");
				insert.append(", po_no");
				insert.append(", po_line_no");
				insert.append(", po_line_qty");
				insert.append(", unit_price");
				insert.append(", extended_price");
				insert.append(", date_released");
				insert.append(", ws_contact_name");
				insert.append(", ws_contact_phone");
				insert.append(", special_instr");
				insert.append(", text_to_parse");
				insert.append(", work_site_cust_name");
				insert.append(", ws_address1");
				insert.append(", ws_address2");
				insert.append(", ws_address3");
				insert.append(", delivery_code");
				insert.append(", delivery_type_id");
				insert.append(", warehouse_code");
				insert.append(", charge_code");
				insert.append(", charge_type_id");
				insert.append(", punchlist_code");
				insert.append(", punchlist_type_id");
				insert.append(", est_start_date");
				insert.append(", est_start_time");
				insert.append(", completion_date");
				insert.append(", wood_product_flag");
				insert.append(", blueprint_location");
				insert.append(", product_setup_desc");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getJobImportID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getJobNo(), 30)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getOffice(), 50)));
				insert.append(", ").append(this.getOfficeLookupID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getDealer(), 50)));
				insert.append(", ").append(this.getDealerLookupID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getDealerContactName(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getDealerContactPhone(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getPoNo(), 50)));
				insert.append(", ").append(this.getPoLineNo());
				insert.append(", ").append(this.getPoLineQty());
				insert.append(", ").append(this.getUnitPrice());
				insert.append(", ").append(this.getExtendedPrice());
				insert.append(", ").append(conn.toSQLString(this.getDateReleased()));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getWsContactName(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getWsContactPhone(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getSpecialInstr(), 250)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getTextToParse(), 1000)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getWorkSiteCustName(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getWsAddress1(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getWsAddress2(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getWsAddress3(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getDeliveryCode(), 10)));
				insert.append(", ").append(this.getDeliveryTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getWarehouseCode(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getChargeCode(), 10)));
				insert.append(", ").append(this.getChargeTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getPunchlistCode(), 10)));
				insert.append(", ").append(this.getPunchlistTypeID());
				insert.append(", ").append(conn.toSQLString(this.getEstStartDate()));
				insert.append(", ").append(conn.toSQLString(this.getEstStartTime()));
				insert.append(", ").append(conn.toSQLString(this.getCompletionDate()));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getWoodProductFlag(), 10)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getBlueprintLocation(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getProductSetupDesc(), 750)));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				jobImportID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in JobsImported.internalInsert()");
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
		Diagnostics.trace("JobsImported.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM jobs_imported ");
			delete.append("WHERE (job_import_id = ").append(this.getJobImportID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in JobsImported.internalDelete()");
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
		if (this.getJobImportID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("JobsImported:\n");
		result.append("  job_import_id = ").append(this.getJobImportID()).append("\n");
		result.append("  job_no = ").append(this.getJobNo()).append("\n");
		result.append("  office = ").append(this.getOffice()).append("\n");
		result.append("  office_lookup_id = ").append(this.getOfficeLookupID()).append("\n");
		result.append("  dealer = ").append(this.getDealer()).append("\n");
		result.append("  dealer_lookup_id = ").append(this.getDealerLookupID()).append("\n");
		result.append("  dealer_contact_name = ").append(this.getDealerContactName()).append("\n");
		result.append("  dealer_contact_phone = ").append(this.getDealerContactPhone()).append("\n");
		result.append("  po_no = ").append(this.getPoNo()).append("\n");
		result.append("  po_line_no = ").append(this.getPoLineNo()).append("\n");
		result.append("  po_line_qty = ").append(this.getPoLineQty()).append("\n");
		result.append("  unit_price = ").append(this.getUnitPrice()).append("\n");
		result.append("  extended_price = ").append(this.getExtendedPrice()).append("\n");
		result.append("  date_released = ").append(this.getDateReleased()).append("\n");
		result.append("  ws_contact_name = ").append(this.getWsContactName()).append("\n");
		result.append("  ws_contact_phone = ").append(this.getWsContactPhone()).append("\n");
		result.append("  special_instr = ").append(this.getSpecialInstr()).append("\n");
		result.append("  text_to_parse = ").append(this.getTextToParse()).append("\n");
		result.append("  work_site_cust_name = ").append(this.getWorkSiteCustName()).append("\n");
		result.append("  ws_address1 = ").append(this.getWsAddress1()).append("\n");
		result.append("  ws_address2 = ").append(this.getWsAddress2()).append("\n");
		result.append("  ws_address3 = ").append(this.getWsAddress3()).append("\n");
		result.append("  delivery_code = ").append(this.getDeliveryCode()).append("\n");
		result.append("  delivery_type_id = ").append(this.getDeliveryTypeID()).append("\n");
		result.append("  warehouse_code = ").append(this.getWarehouseCode()).append("\n");
		result.append("  charge_code = ").append(this.getChargeCode()).append("\n");
		result.append("  charge_type_id = ").append(this.getChargeTypeID()).append("\n");
		result.append("  punchlist_code = ").append(this.getPunchlistCode()).append("\n");
		result.append("  punchlist_type_id = ").append(this.getPunchlistTypeID()).append("\n");
		result.append("  est_start_date = ").append(this.getEstStartDate()).append("\n");
		result.append("  est_start_time = ").append(this.getEstStartTime()).append("\n");
		result.append("  completion_date = ").append(this.getCompletionDate()).append("\n");
		result.append("  wood_product_flag = ").append(this.getWoodProductFlag()).append("\n");
		result.append("  blueprint_location = ").append(this.getBlueprintLocation()).append("\n");
		result.append("  product_setup_desc = ").append(this.getProductSetupDesc()).append("\n");
		result.append("  date_created = ").append(this.getDateCreated()).append("\n");
		result.append("  created_by = ").append(this.getCreatedBy()).append("\n");
		result.append("  date_modified = ").append(this.getDateModified()).append("\n");
		result.append("  modified_by = ").append(this.getModifiedBy()).append("\n");
		return result.toString();
	}


	public int getJobImportID()
	{
		return jobImportID;
	}

	public String getJobNo()
	{
		return jobNo;
	}

	public String getOffice()
	{
		return office;
	}

	public int getOfficeLookupID()
	{
		return officeLookupID;
	}

	public String getDealer()
	{
		return dealer;
	}

	public int getDealerLookupID()
	{
		return dealerLookupID;
	}

	public String getDealerContactName()
	{
		return dealerContactName;
	}

	public String getDealerContactPhone()
	{
		return dealerContactPhone;
	}

	public String getPoNo()
	{
		return poNo;
	}

	public int getPoLineNo()
	{
		return poLineNo;
	}

	public int getPoLineQty()
	{
		return poLineQty;
	}

	public double getUnitPrice()
	{
		return unitPrice;
	}

	public double getExtendedPrice()
	{
		return extendedPrice;
	}

	public Date getDateReleased()
	{
		return dateReleased;
	}

	public String getWsContactName()
	{
		return wsContactName;
	}

	public String getWsContactPhone()
	{
		return wsContactPhone;
	}

	public String getSpecialInstr()
	{
		return specialInstr;
	}

	public String getTextToParse()
	{
		return textToParse;
	}

	public String getWorkSiteCustName()
	{
		return workSiteCustName;
	}

	public String getWsAddress1()
	{
		return wsAddress1;
	}

	public String getWsAddress2()
	{
		return wsAddress2;
	}

	public String getWsAddress3()
	{
		return wsAddress3;
	}

	public String getDeliveryCode()
	{
		return deliveryCode;
	}

	public int getDeliveryTypeID()
	{
		return deliveryTypeID;
	}

	public String getWarehouseCode()
	{
		return warehouseCode;
	}

	public String getChargeCode()
	{
		return chargeCode;
	}

	public int getChargeTypeID()
	{
		return chargeTypeID;
	}

	public String getPunchlistCode()
	{
		return punchlistCode;
	}

	public int getPunchlistTypeID()
	{
		return punchlistTypeID;
	}

	public Date getEstStartDate()
	{
		return estStartDate;
	}

	public Date getEstStartTime()
	{
		return estStartTime;
	}

	public Date getCompletionDate()
	{
		return completionDate;
	}

	public String getWoodProductFlag()
	{
		return woodProductFlag;
	}

	public String getBlueprintLocation()
	{
		return blueprintLocation;
	}

	public String getProductSetupDesc()
	{
		return productSetupDesc;
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

	public void setJobImportID(int jobImportIDIn)
	{
		jobImportID = jobImportIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setJobNo(String jobNoIn)
	{
		jobNo = jobNoIn;
		handleAction(MODIFY_ACTION);
	}

	public void setOffice(String officeIn)
	{
		office = officeIn;
		handleAction(MODIFY_ACTION);
	}

	public void setOfficeLookupID(int officeLookupIDIn)
	{
		officeLookupID = officeLookupIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setDealer(String dealerIn)
	{
		dealer = dealerIn;
		handleAction(MODIFY_ACTION);
	}

	public void setDealerLookupID(int dealerLookupIDIn)
	{
		dealerLookupID = dealerLookupIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setDealerContactName(String dealerContactNameIn)
	{
		dealerContactName = dealerContactNameIn;
		handleAction(MODIFY_ACTION);
	}

	public void setDealerContactPhone(String dealerContactPhoneIn)
	{
		dealerContactPhone = dealerContactPhoneIn;
		handleAction(MODIFY_ACTION);
	}

	public void setPoNo(String poNoIn)
	{
		poNo = poNoIn;
		handleAction(MODIFY_ACTION);
	}

	public void setPoLineNo(int poLineNoIn)
	{
		poLineNo = poLineNoIn;
		handleAction(MODIFY_ACTION);
	}

	public void setPoLineQty(int poLineQtyIn)
	{
		poLineQty = poLineQtyIn;
		handleAction(MODIFY_ACTION);
	}

	public void setUnitPrice(double unitPriceIn)
	{
		unitPrice = unitPriceIn;
		handleAction(MODIFY_ACTION);
	}

	public void setExtendedPrice(double extendedPriceIn)
	{
		extendedPrice = extendedPriceIn;
		handleAction(MODIFY_ACTION);
	}

	public void setDateReleased(Date dateReleasedIn)
	{
		dateReleased = dateReleasedIn;
		handleAction(MODIFY_ACTION);
	}

	public void setWsContactName(String wsContactNameIn)
	{
		wsContactName = wsContactNameIn;
		handleAction(MODIFY_ACTION);
	}

	public void setWsContactPhone(String wsContactPhoneIn)
	{
		wsContactPhone = wsContactPhoneIn;
		handleAction(MODIFY_ACTION);
	}

	public void setSpecialInstr(String specialInstrIn)
	{
		specialInstr = specialInstrIn;
		handleAction(MODIFY_ACTION);
	}

	public void setTextToParse(String textToParseIn)
	{
		textToParse = textToParseIn;
		handleAction(MODIFY_ACTION);
	}

	public void setWorkSiteCustName(String workSiteCustNameIn)
	{
		workSiteCustName = workSiteCustNameIn;
		handleAction(MODIFY_ACTION);
	}

	public void setWsAddress1(String wsAddress1In)
	{
		wsAddress1 = wsAddress1In;
		handleAction(MODIFY_ACTION);
	}

	public void setWsAddress2(String wsAddress2In)
	{
		wsAddress2 = wsAddress2In;
		handleAction(MODIFY_ACTION);
	}

	public void setWsAddress3(String wsAddress3In)
	{
		wsAddress3 = wsAddress3In;
		handleAction(MODIFY_ACTION);
	}

	public void setDeliveryCode(String deliveryCodeIn)
	{
		deliveryCode = deliveryCodeIn;
		handleAction(MODIFY_ACTION);
	}

	public void setDeliveryTypeID(int deliveryTypeIDIn)
	{
		deliveryTypeID = deliveryTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setWarehouseCode(String warehouseCodeIn)
	{
		warehouseCode = warehouseCodeIn;
		handleAction(MODIFY_ACTION);
	}

	public void setChargeCode(String chargeCodeIn)
	{
		chargeCode = chargeCodeIn;
		handleAction(MODIFY_ACTION);
	}

	public void setChargeTypeID(int chargeTypeIDIn)
	{
		chargeTypeID = chargeTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setPunchlistCode(String punchlistCodeIn)
	{
		punchlistCode = punchlistCodeIn;
		handleAction(MODIFY_ACTION);
	}

	public void setPunchlistTypeID(int punchlistTypeIDIn)
	{
		punchlistTypeID = punchlistTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setEstStartDate(Date estStartDateIn)
	{
		estStartDate = estStartDateIn;
		handleAction(MODIFY_ACTION);
	}

	public void setEstStartTime(Date estStartTimeIn)
	{
		estStartTime = estStartTimeIn;
		handleAction(MODIFY_ACTION);
	}

	public void setCompletionDate(Date completionDateIn)
	{
		completionDate = completionDateIn;
		handleAction(MODIFY_ACTION);
	}

	public void setWoodProductFlag(String woodProductFlagIn)
	{
		woodProductFlag = woodProductFlagIn;
		handleAction(MODIFY_ACTION);
	}

	public void setBlueprintLocation(String blueprintLocationIn)
	{
		blueprintLocation = blueprintLocationIn;
		handleAction(MODIFY_ACTION);
	}

	public void setProductSetupDesc(String productSetupDescIn)
	{
		productSetupDesc = productSetupDescIn;
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
