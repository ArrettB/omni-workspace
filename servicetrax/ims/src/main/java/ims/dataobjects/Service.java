package ims.dataobjects;

import java.util.Date;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class Service extends AbstractDatabaseObject
{

	private int serviceID;
	private int jobID;
	private int jobLocationID;
	private int serviceNo;
	private String description;
	private String billingInstructions;
	private int servStatusTypeID;
	private int activityTypeID;
	private String customerRefNo;
	private int companyID;
	private int idmContactID;
	private int salesContactID;
	private int supportContactID;
	private int designerContactID;
	private String poNo;
	private int termsID;
	private String orderedBy;
	private Date orderedDate;
	private Date completeByDate;
	private Date estStartDate;
	private Date estStartTime;
	private Date estEndDate;
	private Date actStartDate;
	private Date actEndDate;
	private Date truckShipDate;
	private Date truckArrivalDate;
	private String productSetupDesc;
	private int deliveryTypeID;
	private String warehouse;
	private int priFurnTypeID;
	private int priFurnLineTypeID;
	private int secFurnTypeID;
	private int secFurnLineTypeID;
	private String numStations;
	private int woodProductTypeID;
	private String blueprintLocationCode;
	private int punchlistTypeID;
	private String headValFlag;
	private String locValFlag;
	private String prodValFlag;
	private String schValFlag;
	private String taskValFlag;
	private String resValFlag;
	private String custValFlag;
	private String billValFlag;
	private String custCol1;
	private String custCol2;
	private String custCol3;
	private String custCol4;
	private String custCol5;
	private String custCol6;
	private String custCol7;
	private String custCol8;
	private String custCol9;
	private String custCol10;
	private Date dateCreated;
	private int createdBy;
	private Date dateModified;
	private int modifiedBy;

	public Service()
	{
		super();
	}


	public static Service fetch(String serviceID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(serviceID), ic, null);
	}

	public static Service fetch(String serviceID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(serviceID), ic, resourceName);
	}

	public static Service fetch(int serviceID, InvocationContext ic)
	{
		 return fetch(serviceID, ic, null);
	}

	public static Service fetch(int serviceID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("Service.fetch()");

		Service result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT service_id ");
			query.append(", job_id ");
			query.append(", job_location_id ");
			query.append(", service_no ");
			query.append(", description ");
			query.append(", billing_instructions ");
			query.append(", serv_status_type_id ");
			query.append(", activity_type_id ");
			query.append(", customer_ref_no ");
			query.append(", company_id ");
			query.append(", idm_contact_id ");
			query.append(", sales_contact_id ");
			query.append(", support_contact_id ");
			query.append(", designer_contact_id ");
			query.append(", po_no ");
			query.append(", terms_id ");
			query.append(", ordered_by ");
			query.append(", ordered_date ");
			query.append(", complete_by_date ");
			query.append(", est_start_date ");
			query.append(", est_start_time ");
			query.append(", est_end_date ");
			query.append(", act_start_date ");
			query.append(", act_end_date ");
			query.append(", truck_ship_date ");
			query.append(", truck_arrival_date ");
			query.append(", product_setup_desc ");
			query.append(", delivery_type_id ");
			query.append(", warehouse ");
			query.append(", pri_furn_type_id ");
			query.append(", pri_furn_line_type_id ");
			query.append(", sec_furn_type_id ");
			query.append(", sec_furn_line_type_id ");
			query.append(", num_stations ");
			query.append(", wood_product_type_id ");
			query.append(", blueprint_location_code ");
			query.append(", punchlist_type_id ");
			query.append(", head_val_flag ");
			query.append(", loc_val_flag ");
			query.append(", prod_val_flag ");
			query.append(", sch_val_flag ");
			query.append(", task_val_flag ");
			query.append(", res_val_flag ");
			query.append(", cust_val_flag ");
			query.append(", bill_val_flag ");
			query.append(", cust_col_1 ");
			query.append(", cust_col_2 ");
			query.append(", cust_col_3 ");
			query.append(", cust_col_4 ");
			query.append(", cust_col_5 ");
			query.append(", cust_col_6 ");
			query.append(", cust_col_7 ");
			query.append(", cust_col_8 ");
			query.append(", cust_col_9 ");
			query.append(", cust_col_10 ");
			query.append(", date_created ");
			query.append(", created_by ");
			query.append(", date_modified ");
			query.append(", modified_by ");
			query.append("FROM services ");
			query.append("WHERE (service_id = ").append(serviceID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new Service();
				result.setServiceID(rs.getInt(1));
				result.setJobID(rs.getInt(2));
				result.setJobLocationID(rs.getInt(3));
				result.setServiceNo(rs.getInt(4));
				result.setDescription(rs.getString(5));
				result.setBillingInstructions(rs.getString(6));
				result.setServStatusTypeID(rs.getInt(7));
				result.setActivityTypeID(rs.getInt(8));
				result.setCustomerRefNo(rs.getString(9));
				result.setCompanyID(rs.getInt(10));
				result.setIDmContactID(rs.getInt(11));
				result.setSalesContactID(rs.getInt(12));
				result.setSupportContactID(rs.getInt(13));
				result.setDesignerContactID(rs.getInt(14));
				result.setPoNo(rs.getString(15));
				result.setTermsID(rs.getInt(16));
				result.setOrderedBy(rs.getString(17));
				result.setOrderedDate(rs.getDate(18));
				result.setCompleteByDate(rs.getDate(19));
				result.setEstStartDate(rs.getDate(20));
				result.setEstStartTime(rs.getDate(21));
				result.setEstEndDate(rs.getDate(22));
				result.setActStartDate(rs.getDate(23));
				result.setActEndDate(rs.getDate(24));
				result.setTruckShipDate(rs.getDate(25));
				result.setTruckArrivalDate(rs.getDate(26));
				result.setProductSetupDesc(rs.getString(27));
				result.setDeliveryTypeID(rs.getInt(28));
				result.setWarehouse(rs.getString(29));
				result.setPriFurnTypeID(rs.getInt(30));
				result.setPriFurnLineTypeID(rs.getInt(31));
				result.setSecFurnTypeID(rs.getInt(32));
				result.setSecFurnLineTypeID(rs.getInt(33));
				result.setNumStations(rs.getString(34));
				result.setWoodProductTypeID(rs.getInt(35));
				result.setBlueprintLocationCode(rs.getString(36));
				result.setPunchlistTypeID(rs.getInt(37));
				result.setHeadValFlag(rs.getString(38));
				result.setLocValFlag(rs.getString(39));
				result.setProdValFlag(rs.getString(40));
				result.setSchValFlag(rs.getString(41));
				result.setTaskValFlag(rs.getString(42));
				result.setResValFlag(rs.getString(43));
				result.setCustValFlag(rs.getString(44));
				result.setBillValFlag(rs.getString(45));
				result.setCustCol1(rs.getString(46));
				result.setCustCol2(rs.getString(47));
				result.setCustCol3(rs.getString(48));
				result.setCustCol4(rs.getString(49));
				result.setCustCol5(rs.getString(50));
				result.setCustCol6(rs.getString(51));
				result.setCustCol7(rs.getString(52));
				result.setCustCol8(rs.getString(53));
				result.setCustCol9(rs.getString(54));
				result.setCustCol10(rs.getString(55));
				result.setDateCreated(rs.getDate(56));
				result.setCreatedBy(rs.getInt(57));
				result.setDateModified(rs.getDate(58));
				result.setModifiedBy(rs.getInt(59));
			}
			else
			{
				Diagnostics.error("Error in Service.fetch(), Could not find Service; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Service.fetch()");
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
		Diagnostics.trace("Service.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE services ");
			update.append("SET job_id = ").append(this.getJobID());
			update.append(", job_location_id = ").append(this.getJobLocationID());
			update.append(", service_no = ").append(this.getServiceNo());
			update.append(", description = ").append(conn.toSQLString(StringUtil.truncate(this.getDescription(), 500)));
			update.append(", billing_instructions = ").append(conn.toSQLString(StringUtil.truncate(this.getBillingInstructions(), 50)));
			update.append(", serv_status_type_id = ").append(this.getServStatusTypeID());
			update.append(", activity_type_id = ").append(this.getActivityTypeID());
			update.append(", customer_ref_no = ").append(conn.toSQLString(StringUtil.truncate(this.getCustomerRefNo(), 240)));
			update.append(", company_id = ").append(this.getCompanyID());
			update.append(", idm_contact_id = ").append(this.getIDmContactID());
			update.append(", sales_contact_id = ").append(this.getSalesContactID());
			update.append(", support_contact_id = ").append(this.getSupportContactID());
			update.append(", designer_contact_id = ").append(this.getDesignerContactID());
			update.append(", po_no = ").append(conn.toSQLString(StringUtil.truncate(this.getPoNo(), 100)));
			update.append(", terms_id = ").append(this.getTermsID());
			update.append(", ordered_by = ").append(conn.toSQLString(StringUtil.truncate(this.getOrderedBy(), 100)));
			update.append(", ordered_date = ").append(conn.toSQLString(this.getOrderedDate()));
			update.append(", complete_by_date = ").append(conn.toSQLString(this.getCompleteByDate()));
			update.append(", est_start_date = ").append(conn.toSQLString(this.getEstStartDate()));
			update.append(", est_start_time = ").append(conn.toSQLString(this.getEstStartTime()));
			update.append(", est_end_date = ").append(conn.toSQLString(this.getEstEndDate()));
			update.append(", act_start_date = ").append(conn.toSQLString(this.getActStartDate()));
			update.append(", act_end_date = ").append(conn.toSQLString(this.getActEndDate()));
			update.append(", truck_ship_date = ").append(conn.toSQLString(this.getTruckShipDate()));
			update.append(", truck_arrival_date = ").append(conn.toSQLString(this.getTruckArrivalDate()));
			update.append(", product_setup_desc = ").append(conn.toSQLString(StringUtil.truncate(this.getProductSetupDesc(), 500)));
			update.append(", delivery_type_id = ").append(this.getDeliveryTypeID());
			update.append(", warehouse = ").append(conn.toSQLString(StringUtil.truncate(this.getWarehouse(), 60)));
			update.append(", pri_furn_type_id = ").append(this.getPriFurnTypeID());
			update.append(", pri_furn_line_type_id = ").append(this.getPriFurnLineTypeID());
			update.append(", sec_furn_type_id = ").append(this.getSecFurnTypeID());
			update.append(", sec_furn_line_type_id = ").append(this.getSecFurnLineTypeID());
			update.append(", num_stations = ").append(conn.toSQLString(StringUtil.truncate(this.getNumStations(), 20)));
			update.append(", wood_product_type_id = ").append(this.getWoodProductTypeID());
			update.append(", blueprint_location_code = ").append(conn.toSQLString(StringUtil.truncate(this.getBlueprintLocationCode(), 100)));
			update.append(", punchlist_type_id = ").append(this.getPunchlistTypeID());
			update.append(", head_val_flag = ").append(conn.toSQLString(StringUtil.truncate(this.getHeadValFlag(), 1)));
			update.append(", loc_val_flag = ").append(conn.toSQLString(StringUtil.truncate(this.getLocValFlag(), 1)));
			update.append(", prod_val_flag = ").append(conn.toSQLString(StringUtil.truncate(this.getProdValFlag(), 1)));
			update.append(", sch_val_flag = ").append(conn.toSQLString(StringUtil.truncate(this.getSchValFlag(), 1)));
			update.append(", task_val_flag = ").append(conn.toSQLString(StringUtil.truncate(this.getTaskValFlag(), 1)));
			update.append(", res_val_flag = ").append(conn.toSQLString(StringUtil.truncate(this.getResValFlag(), 1)));
			update.append(", cust_val_flag = ").append(conn.toSQLString(StringUtil.truncate(this.getCustValFlag(), 1)));
			update.append(", bill_val_flag = ").append(conn.toSQLString(StringUtil.truncate(this.getBillValFlag(), 1)));
			update.append(", cust_col_1 = ").append(conn.toSQLString(StringUtil.truncate(this.getCustCol1(), 20)));
			update.append(", cust_col_2 = ").append(conn.toSQLString(StringUtil.truncate(this.getCustCol2(), 20)));
			update.append(", cust_col_3 = ").append(conn.toSQLString(StringUtil.truncate(this.getCustCol3(), 20)));
			update.append(", cust_col_4 = ").append(conn.toSQLString(StringUtil.truncate(this.getCustCol4(), 20)));
			update.append(", cust_col_5 = ").append(conn.toSQLString(StringUtil.truncate(this.getCustCol5(), 20)));
			update.append(", cust_col_6 = ").append(conn.toSQLString(StringUtil.truncate(this.getCustCol6(), 20)));
			update.append(", cust_col_7 = ").append(conn.toSQLString(StringUtil.truncate(this.getCustCol7(), 20)));
			update.append(", cust_col_8 = ").append(conn.toSQLString(StringUtil.truncate(this.getCustCol8(), 20)));
			update.append(", cust_col_9 = ").append(conn.toSQLString(StringUtil.truncate(this.getCustCol9(), 20)));
			update.append(", cust_col_10 = ").append(conn.toSQLString(StringUtil.truncate(this.getCustCol10(), 20)));
			update.append(", date_created = ").append(conn.toSQLString(this.getDateCreated()));
			update.append(", created_by = ").append(this.getCreatedBy());
			update.append(", date_modified = ").append(conn.toSQLString(this.getDateModified()));
			update.append(", modified_by = ").append(this.getModifiedBy());
			update.append("WHERE (service_id = ").append(this.getServiceID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Service.internalUpdate()");
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
		Diagnostics.trace("Service.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO services (");
				insert.append("job_id");
				insert.append(", job_location_id");
				insert.append(", service_no");
				insert.append(", description");
				insert.append(", billing_instructions");
				insert.append(", serv_status_type_id");
				insert.append(", activity_type_id");
				insert.append(", customer_ref_no");
				insert.append(", company_id");
				insert.append(", idm_contact_id");
				insert.append(", sales_contact_id");
				insert.append(", support_contact_id");
				insert.append(", designer_contact_id");
				insert.append(", po_no");
				insert.append(", terms_id");
				insert.append(", ordered_by");
				insert.append(", ordered_date");
				insert.append(", complete_by_date");
				insert.append(", est_start_date");
				insert.append(", est_start_time");
				insert.append(", est_end_date");
				insert.append(", act_start_date");
				insert.append(", act_end_date");
				insert.append(", truck_ship_date");
				insert.append(", truck_arrival_date");
				insert.append(", product_setup_desc");
				insert.append(", delivery_type_id");
				insert.append(", warehouse");
				insert.append(", pri_furn_type_id");
				insert.append(", pri_furn_line_type_id");
				insert.append(", sec_furn_type_id");
				insert.append(", sec_furn_line_type_id");
				insert.append(", num_stations");
				insert.append(", wood_product_type_id");
				insert.append(", blueprint_location_code");
				insert.append(", punchlist_type_id");
				insert.append(", head_val_flag");
				insert.append(", loc_val_flag");
				insert.append(", prod_val_flag");
				insert.append(", sch_val_flag");
				insert.append(", task_val_flag");
				insert.append(", res_val_flag");
				insert.append(", cust_val_flag");
				insert.append(", bill_val_flag");
				insert.append(", cust_col_1");
				insert.append(", cust_col_2");
				insert.append(", cust_col_3");
				insert.append(", cust_col_4");
				insert.append(", cust_col_5");
				insert.append(", cust_col_6");
				insert.append(", cust_col_7");
				insert.append(", cust_col_8");
				insert.append(", cust_col_9");
				insert.append(", cust_col_10");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getJobID());
				insert.append(", ").append(this.getJobLocationID());
				insert.append(", ").append(this.getServiceNo());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getDescription(), 500)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getBillingInstructions(), 50)));
				insert.append(", ").append(this.getServStatusTypeID());
				insert.append(", ").append(this.getActivityTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCustomerRefNo(), 240)));
				insert.append(", ").append(this.getCompanyID());
				insert.append(", ").append(this.getIDmContactID());
				insert.append(", ").append(this.getSalesContactID());
				insert.append(", ").append(this.getSupportContactID());
				insert.append(", ").append(this.getDesignerContactID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getPoNo(), 100)));
				insert.append(", ").append(this.getTermsID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getOrderedBy(), 100)));
				insert.append(", ").append(conn.toSQLString(this.getOrderedDate()));
				insert.append(", ").append(conn.toSQLString(this.getCompleteByDate()));
				insert.append(", ").append(conn.toSQLString(this.getEstStartDate()));
				insert.append(", ").append(conn.toSQLString(this.getEstStartTime()));
				insert.append(", ").append(conn.toSQLString(this.getEstEndDate()));
				insert.append(", ").append(conn.toSQLString(this.getActStartDate()));
				insert.append(", ").append(conn.toSQLString(this.getActEndDate()));
				insert.append(", ").append(conn.toSQLString(this.getTruckShipDate()));
				insert.append(", ").append(conn.toSQLString(this.getTruckArrivalDate()));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getProductSetupDesc(), 500)));
				insert.append(", ").append(this.getDeliveryTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getWarehouse(), 60)));
				insert.append(", ").append(this.getPriFurnTypeID());
				insert.append(", ").append(this.getPriFurnLineTypeID());
				insert.append(", ").append(this.getSecFurnTypeID());
				insert.append(", ").append(this.getSecFurnLineTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getNumStations(), 20)));
				insert.append(", ").append(this.getWoodProductTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getBlueprintLocationCode(), 100)));
				insert.append(", ").append(this.getPunchlistTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getHeadValFlag(), 1)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getLocValFlag(), 1)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getProdValFlag(), 1)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getSchValFlag(), 1)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getTaskValFlag(), 1)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getResValFlag(), 1)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCustValFlag(), 1)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getBillValFlag(), 1)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCustCol1(), 20)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCustCol2(), 20)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCustCol3(), 20)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCustCol4(), 20)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCustCol5(), 20)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCustCol6(), 20)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCustCol7(), 20)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCustCol8(), 20)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCustCol9(), 20)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCustCol10(), 20)));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO services (");
				insert.append("service_id");
				insert.append(", job_id");
				insert.append(", job_location_id");
				insert.append(", service_no");
				insert.append(", description");
				insert.append(", billing_instructions");
				insert.append(", serv_status_type_id");
				insert.append(", activity_type_id");
				insert.append(", customer_ref_no");
				insert.append(", company_id");
				insert.append(", idm_contact_id");
				insert.append(", sales_contact_id");
				insert.append(", support_contact_id");
				insert.append(", designer_contact_id");
				insert.append(", po_no");
				insert.append(", terms_id");
				insert.append(", ordered_by");
				insert.append(", ordered_date");
				insert.append(", complete_by_date");
				insert.append(", est_start_date");
				insert.append(", est_start_time");
				insert.append(", est_end_date");
				insert.append(", act_start_date");
				insert.append(", act_end_date");
				insert.append(", truck_ship_date");
				insert.append(", truck_arrival_date");
				insert.append(", product_setup_desc");
				insert.append(", delivery_type_id");
				insert.append(", warehouse");
				insert.append(", pri_furn_type_id");
				insert.append(", pri_furn_line_type_id");
				insert.append(", sec_furn_type_id");
				insert.append(", sec_furn_line_type_id");
				insert.append(", num_stations");
				insert.append(", wood_product_type_id");
				insert.append(", blueprint_location_code");
				insert.append(", punchlist_type_id");
				insert.append(", head_val_flag");
				insert.append(", loc_val_flag");
				insert.append(", prod_val_flag");
				insert.append(", sch_val_flag");
				insert.append(", task_val_flag");
				insert.append(", res_val_flag");
				insert.append(", cust_val_flag");
				insert.append(", bill_val_flag");
				insert.append(", cust_col_1");
				insert.append(", cust_col_2");
				insert.append(", cust_col_3");
				insert.append(", cust_col_4");
				insert.append(", cust_col_5");
				insert.append(", cust_col_6");
				insert.append(", cust_col_7");
				insert.append(", cust_col_8");
				insert.append(", cust_col_9");
				insert.append(", cust_col_10");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getServiceID());
				insert.append(", ").append(this.getJobID());
				insert.append(", ").append(this.getJobLocationID());
				insert.append(", ").append(this.getServiceNo());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getDescription(), 500)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getBillingInstructions(), 50)));
				insert.append(", ").append(this.getServStatusTypeID());
				insert.append(", ").append(this.getActivityTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCustomerRefNo(), 240)));
				insert.append(", ").append(this.getCompanyID());
				insert.append(", ").append(this.getIDmContactID());
				insert.append(", ").append(this.getSalesContactID());
				insert.append(", ").append(this.getSupportContactID());
				insert.append(", ").append(this.getDesignerContactID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getPoNo(), 100)));
				insert.append(", ").append(this.getTermsID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getOrderedBy(), 100)));
				insert.append(", ").append(conn.toSQLString(this.getOrderedDate()));
				insert.append(", ").append(conn.toSQLString(this.getCompleteByDate()));
				insert.append(", ").append(conn.toSQLString(this.getEstStartDate()));
				insert.append(", ").append(conn.toSQLString(this.getEstStartTime()));
				insert.append(", ").append(conn.toSQLString(this.getEstEndDate()));
				insert.append(", ").append(conn.toSQLString(this.getActStartDate()));
				insert.append(", ").append(conn.toSQLString(this.getActEndDate()));
				insert.append(", ").append(conn.toSQLString(this.getTruckShipDate()));
				insert.append(", ").append(conn.toSQLString(this.getTruckArrivalDate()));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getProductSetupDesc(), 500)));
				insert.append(", ").append(this.getDeliveryTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getWarehouse(), 60)));
				insert.append(", ").append(this.getPriFurnTypeID());
				insert.append(", ").append(this.getPriFurnLineTypeID());
				insert.append(", ").append(this.getSecFurnTypeID());
				insert.append(", ").append(this.getSecFurnLineTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getNumStations(), 20)));
				insert.append(", ").append(this.getWoodProductTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getBlueprintLocationCode(), 100)));
				insert.append(", ").append(this.getPunchlistTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getHeadValFlag(), 1)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getLocValFlag(), 1)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getProdValFlag(), 1)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getSchValFlag(), 1)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getTaskValFlag(), 1)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getResValFlag(), 1)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCustValFlag(), 1)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getBillValFlag(), 1)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCustCol1(), 20)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCustCol2(), 20)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCustCol3(), 20)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCustCol4(), 20)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCustCol5(), 20)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCustCol6(), 20)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCustCol7(), 20)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCustCol8(), 20)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCustCol9(), 20)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCustCol10(), 20)));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				serviceID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Service.internalInsert()");
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
		Diagnostics.trace("Service.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM services ");
			delete.append("WHERE (service_id = ").append(this.getServiceID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Service.internalDelete()");
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
		if (this.getServiceID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("Service:\n");
		result.append("  service_id = ").append(this.getServiceID()).append("\n");
		result.append("  job_id = ").append(this.getJobID()).append("\n");
		result.append("  job_location_id = ").append(this.getJobLocationID()).append("\n");
		result.append("  service_no = ").append(this.getServiceNo()).append("\n");
		result.append("  description = ").append(this.getDescription()).append("\n");
		result.append("  billing_instructions = ").append(this.getBillingInstructions()).append("\n");
		result.append("  serv_status_type_id = ").append(this.getServStatusTypeID()).append("\n");
		result.append("  activity_type_id = ").append(this.getActivityTypeID()).append("\n");
		result.append("  customer_ref_no = ").append(this.getCustomerRefNo()).append("\n");
		result.append("  company_id = ").append(this.getCompanyID()).append("\n");
		result.append("  idm_contact_id = ").append(this.getIDmContactID()).append("\n");
		result.append("  sales_contact_id = ").append(this.getSalesContactID()).append("\n");
		result.append("  support_contact_id = ").append(this.getSupportContactID()).append("\n");
		result.append("  designer_contact_id = ").append(this.getDesignerContactID()).append("\n");
		result.append("  po_no = ").append(this.getPoNo()).append("\n");
		result.append("  terms_id = ").append(this.getTermsID()).append("\n");
		result.append("  ordered_by = ").append(this.getOrderedBy()).append("\n");
		result.append("  ordered_date = ").append(this.getOrderedDate()).append("\n");
		result.append("  complete_by_date = ").append(this.getCompleteByDate()).append("\n");
		result.append("  est_start_date = ").append(this.getEstStartDate()).append("\n");
		result.append("  est_start_time = ").append(this.getEstStartTime()).append("\n");
		result.append("  est_end_date = ").append(this.getEstEndDate()).append("\n");
		result.append("  act_start_date = ").append(this.getActStartDate()).append("\n");
		result.append("  act_end_date = ").append(this.getActEndDate()).append("\n");
		result.append("  truck_ship_date = ").append(this.getTruckShipDate()).append("\n");
		result.append("  truck_arrival_date = ").append(this.getTruckArrivalDate()).append("\n");
		result.append("  product_setup_desc = ").append(this.getProductSetupDesc()).append("\n");
		result.append("  delivery_type_id = ").append(this.getDeliveryTypeID()).append("\n");
		result.append("  warehouse = ").append(this.getWarehouse()).append("\n");
		result.append("  pri_furn_type_id = ").append(this.getPriFurnTypeID()).append("\n");
		result.append("  pri_furn_line_type_id = ").append(this.getPriFurnLineTypeID()).append("\n");
		result.append("  sec_furn_type_id = ").append(this.getSecFurnTypeID()).append("\n");
		result.append("  sec_furn_line_type_id = ").append(this.getSecFurnLineTypeID()).append("\n");
		result.append("  num_stations = ").append(this.getNumStations()).append("\n");
		result.append("  wood_product_type_id = ").append(this.getWoodProductTypeID()).append("\n");
		result.append("  blueprint_location_code = ").append(this.getBlueprintLocationCode()).append("\n");
		result.append("  punchlist_type_id = ").append(this.getPunchlistTypeID()).append("\n");
		result.append("  head_val_flag = ").append(this.getHeadValFlag()).append("\n");
		result.append("  loc_val_flag = ").append(this.getLocValFlag()).append("\n");
		result.append("  prod_val_flag = ").append(this.getProdValFlag()).append("\n");
		result.append("  sch_val_flag = ").append(this.getSchValFlag()).append("\n");
		result.append("  task_val_flag = ").append(this.getTaskValFlag()).append("\n");
		result.append("  res_val_flag = ").append(this.getResValFlag()).append("\n");
		result.append("  cust_val_flag = ").append(this.getCustValFlag()).append("\n");
		result.append("  bill_val_flag = ").append(this.getBillValFlag()).append("\n");
		result.append("  cust_col_1 = ").append(this.getCustCol1()).append("\n");
		result.append("  cust_col_2 = ").append(this.getCustCol2()).append("\n");
		result.append("  cust_col_3 = ").append(this.getCustCol3()).append("\n");
		result.append("  cust_col_4 = ").append(this.getCustCol4()).append("\n");
		result.append("  cust_col_5 = ").append(this.getCustCol5()).append("\n");
		result.append("  cust_col_6 = ").append(this.getCustCol6()).append("\n");
		result.append("  cust_col_7 = ").append(this.getCustCol7()).append("\n");
		result.append("  cust_col_8 = ").append(this.getCustCol8()).append("\n");
		result.append("  cust_col_9 = ").append(this.getCustCol9()).append("\n");
		result.append("  cust_col_10 = ").append(this.getCustCol10()).append("\n");
		result.append("  date_created = ").append(this.getDateCreated()).append("\n");
		result.append("  created_by = ").append(this.getCreatedBy()).append("\n");
		result.append("  date_modified = ").append(this.getDateModified()).append("\n");
		result.append("  modified_by = ").append(this.getModifiedBy()).append("\n");
		return result.toString();
	}


	public int getServiceID()
	{
		return serviceID;
	}

	public int getJobID()
	{
		return jobID;
	}

	public int getJobLocationID()
	{
		return jobLocationID;
	}

	public int getServiceNo()
	{
		return serviceNo;
	}

	public String getDescription()
	{
		return description;
	}

	public String getBillingInstructions()
	{
		return billingInstructions;
	}

	public int getServStatusTypeID()
	{
		return servStatusTypeID;
	}

	public int getActivityTypeID()
	{
		return activityTypeID;
	}

	public String getCustomerRefNo()
	{
		return customerRefNo;
	}

	public int getCompanyID()
	{
		return companyID;
	}

	public int getIDmContactID()
	{
		return idmContactID;
	}

	public int getSalesContactID()
	{
		return salesContactID;
	}

	public int getSupportContactID()
	{
		return supportContactID;
	}

	public int getDesignerContactID()
	{
		return designerContactID;
	}

	public String getPoNo()
	{
		return poNo;
	}

	public int getTermsID()
	{
		return termsID;
	}

	public String getOrderedBy()
	{
		return orderedBy;
	}

	public Date getOrderedDate()
	{
		return orderedDate;
	}

	public Date getCompleteByDate()
	{
		return completeByDate;
	}

	public Date getEstStartDate()
	{
		return estStartDate;
	}

	public Date getEstStartTime()
	{
		return estStartTime;
	}

	public Date getEstEndDate()
	{
		return estEndDate;
	}

	public Date getActStartDate()
	{
		return actStartDate;
	}

	public Date getActEndDate()
	{
		return actEndDate;
	}

	public Date getTruckShipDate()
	{
		return truckShipDate;
	}

	public Date getTruckArrivalDate()
	{
		return truckArrivalDate;
	}

	public String getProductSetupDesc()
	{
		return productSetupDesc;
	}

	public int getDeliveryTypeID()
	{
		return deliveryTypeID;
	}

	public String getWarehouse()
	{
		return warehouse;
	}

	public int getPriFurnTypeID()
	{
		return priFurnTypeID;
	}

	public int getPriFurnLineTypeID()
	{
		return priFurnLineTypeID;
	}

	public int getSecFurnTypeID()
	{
		return secFurnTypeID;
	}

	public int getSecFurnLineTypeID()
	{
		return secFurnLineTypeID;
	}

	public String getNumStations()
	{
		return numStations;
	}

	public int getWoodProductTypeID()
	{
		return woodProductTypeID;
	}

	public String getBlueprintLocationCode()
	{
		return blueprintLocationCode;
	}

	public int getPunchlistTypeID()
	{
		return punchlistTypeID;
	}

	public String getHeadValFlag()
	{
		return headValFlag;
	}

	public String getLocValFlag()
	{
		return locValFlag;
	}

	public String getProdValFlag()
	{
		return prodValFlag;
	}

	public String getSchValFlag()
	{
		return schValFlag;
	}

	public String getTaskValFlag()
	{
		return taskValFlag;
	}

	public String getResValFlag()
	{
		return resValFlag;
	}

	public String getCustValFlag()
	{
		return custValFlag;
	}

	public String getBillValFlag()
	{
		return billValFlag;
	}

	public String getCustCol1()
	{
		return custCol1;
	}

	public String getCustCol2()
	{
		return custCol2;
	}

	public String getCustCol3()
	{
		return custCol3;
	}

	public String getCustCol4()
	{
		return custCol4;
	}

	public String getCustCol5()
	{
		return custCol5;
	}

	public String getCustCol6()
	{
		return custCol6;
	}

	public String getCustCol7()
	{
		return custCol7;
	}

	public String getCustCol8()
	{
		return custCol8;
	}

	public String getCustCol9()
	{
		return custCol9;
	}

	public String getCustCol10()
	{
		return custCol10;
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

	public void setServiceID(int serviceIDIn)
	{
		serviceID = serviceIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setJobID(int jobIDIn)
	{
		jobID = jobIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setJobLocationID(int jobLocationIDIn)
	{
		jobLocationID = jobLocationIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setServiceNo(int serviceNoIn)
	{
		serviceNo = serviceNoIn;
		handleAction(MODIFY_ACTION);
	}

	public void setDescription(String descriptionIn)
	{
		description = descriptionIn;
		handleAction(MODIFY_ACTION);
	}

	public void setBillingInstructions(String billingInstructionsIn)
	{
		billingInstructions = billingInstructionsIn;
		handleAction(MODIFY_ACTION);
	}

	public void setServStatusTypeID(int servStatusTypeIDIn)
	{
		servStatusTypeID = servStatusTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setActivityTypeID(int activityTypeIDIn)
	{
		activityTypeID = activityTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setCustomerRefNo(String customerRefNoIn)
	{
		customerRefNo = customerRefNoIn;
		handleAction(MODIFY_ACTION);
	}

	public void setCompanyID(int companyIDIn)
	{
		companyID = companyIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setIDmContactID(int idmContactIDIn)
	{
		idmContactID = idmContactIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setSalesContactID(int salesContactIDIn)
	{
		salesContactID = salesContactIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setSupportContactID(int supportContactIDIn)
	{
		supportContactID = supportContactIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setDesignerContactID(int designerContactIDIn)
	{
		designerContactID = designerContactIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setPoNo(String poNoIn)
	{
		poNo = poNoIn;
		handleAction(MODIFY_ACTION);
	}

	public void setTermsID(int termsIDIn)
	{
		termsID = termsIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setOrderedBy(String orderedByIn)
	{
		orderedBy = orderedByIn;
		handleAction(MODIFY_ACTION);
	}

	public void setOrderedDate(Date orderedDateIn)
	{
		orderedDate = orderedDateIn;
		handleAction(MODIFY_ACTION);
	}

	public void setCompleteByDate(Date completeByDateIn)
	{
		completeByDate = completeByDateIn;
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

	public void setEstEndDate(Date estEndDateIn)
	{
		estEndDate = estEndDateIn;
		handleAction(MODIFY_ACTION);
	}

	public void setActStartDate(Date actStartDateIn)
	{
		actStartDate = actStartDateIn;
		handleAction(MODIFY_ACTION);
	}

	public void setActEndDate(Date actEndDateIn)
	{
		actEndDate = actEndDateIn;
		handleAction(MODIFY_ACTION);
	}

	public void setTruckShipDate(Date truckShipDateIn)
	{
		truckShipDate = truckShipDateIn;
		handleAction(MODIFY_ACTION);
	}

	public void setTruckArrivalDate(Date truckArrivalDateIn)
	{
		truckArrivalDate = truckArrivalDateIn;
		handleAction(MODIFY_ACTION);
	}

	public void setProductSetupDesc(String productSetupDescIn)
	{
		productSetupDesc = productSetupDescIn;
		handleAction(MODIFY_ACTION);
	}

	public void setDeliveryTypeID(int deliveryTypeIDIn)
	{
		deliveryTypeID = deliveryTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setWarehouse(String warehouseIn)
	{
		warehouse = warehouseIn;
		handleAction(MODIFY_ACTION);
	}

	public void setPriFurnTypeID(int priFurnTypeIDIn)
	{
		priFurnTypeID = priFurnTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setPriFurnLineTypeID(int priFurnLineTypeIDIn)
	{
		priFurnLineTypeID = priFurnLineTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setSecFurnTypeID(int secFurnTypeIDIn)
	{
		secFurnTypeID = secFurnTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setSecFurnLineTypeID(int secFurnLineTypeIDIn)
	{
		secFurnLineTypeID = secFurnLineTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setNumStations(String numStationsIn)
	{
		numStations = numStationsIn;
		handleAction(MODIFY_ACTION);
	}

	public void setWoodProductTypeID(int woodProductTypeIDIn)
	{
		woodProductTypeID = woodProductTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setBlueprintLocationCode(String blueprintLocationCodeIn)
	{
		blueprintLocationCode = blueprintLocationCodeIn;
		handleAction(MODIFY_ACTION);
	}

	public void setPunchlistTypeID(int punchlistTypeIDIn)
	{
		punchlistTypeID = punchlistTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setHeadValFlag(String headValFlagIn)
	{
		headValFlag = headValFlagIn;
		handleAction(MODIFY_ACTION);
	}

	public void setLocValFlag(String locValFlagIn)
	{
		locValFlag = locValFlagIn;
		handleAction(MODIFY_ACTION);
	}

	public void setProdValFlag(String prodValFlagIn)
	{
		prodValFlag = prodValFlagIn;
		handleAction(MODIFY_ACTION);
	}

	public void setSchValFlag(String schValFlagIn)
	{
		schValFlag = schValFlagIn;
		handleAction(MODIFY_ACTION);
	}

	public void setTaskValFlag(String taskValFlagIn)
	{
		taskValFlag = taskValFlagIn;
		handleAction(MODIFY_ACTION);
	}

	public void setResValFlag(String resValFlagIn)
	{
		resValFlag = resValFlagIn;
		handleAction(MODIFY_ACTION);
	}

	public void setCustValFlag(String custValFlagIn)
	{
		custValFlag = custValFlagIn;
		handleAction(MODIFY_ACTION);
	}

	public void setBillValFlag(String billValFlagIn)
	{
		billValFlag = billValFlagIn;
		handleAction(MODIFY_ACTION);
	}

	public void setCustCol1(String custCol1In)
	{
		custCol1 = custCol1In;
		handleAction(MODIFY_ACTION);
	}

	public void setCustCol2(String custCol2In)
	{
		custCol2 = custCol2In;
		handleAction(MODIFY_ACTION);
	}

	public void setCustCol3(String custCol3In)
	{
		custCol3 = custCol3In;
		handleAction(MODIFY_ACTION);
	}

	public void setCustCol4(String custCol4In)
	{
		custCol4 = custCol4In;
		handleAction(MODIFY_ACTION);
	}

	public void setCustCol5(String custCol5In)
	{
		custCol5 = custCol5In;
		handleAction(MODIFY_ACTION);
	}

	public void setCustCol6(String custCol6In)
	{
		custCol6 = custCol6In;
		handleAction(MODIFY_ACTION);
	}

	public void setCustCol7(String custCol7In)
	{
		custCol7 = custCol7In;
		handleAction(MODIFY_ACTION);
	}

	public void setCustCol8(String custCol8In)
	{
		custCol8 = custCol8In;
		handleAction(MODIFY_ACTION);
	}

	public void setCustCol9(String custCol9In)
	{
		custCol9 = custCol9In;
		handleAction(MODIFY_ACTION);
	}

	public void setCustCol10(String custCol10In)
	{
		custCol10 = custCol10In;
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
