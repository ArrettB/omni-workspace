package ims.handlers.proj;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.intraframe.templates.components.SmartFormComponent;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;
import ims.helpers.IMSUtil;
import ims.helpers.MapUtil;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.*;

/**
 * @version $Id: PDSPostHandler.java 1491 2009-01-28 19:07:05Z bvonhaden $
 */
public class PDSPostHandler extends BaseHandler
{
	public void setUpHandler(){}

	public void destroy(){}

  	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		Diagnostics.trace("PDSPostHandler.handleEnvironment()");
		boolean result = true;

		/*
		 * Note: Because this is PostHandler with SmartFormHandler, we do NOT
		 * catch the exception or release the resource ourselves
		 */

		//set data for acknowledgement popup window: note ack_email_info was
		// set by PDSEmailHandler
		String button = ic.getParameter("req_button");
		String mode = ic.getParameter(SmartFormComponent.MODE);
		String request_type_code = ic.getParameter("request_type_code");
		String request_status_type_code = ic.getParameter("request_status_type_code");
        Diagnostics.debug("in PDSPostHandler, request_status_type_code='"+request_status_type_code+"'");
		String quoting = (String)ic.getSessionDatum("quoting");
		boolean is_quote_request = false;
		if( StringUtil.hasAValue(quoting) && quoting.equalsIgnoreCase("true") )
			is_quote_request = true;
		String converting = ic.getParameter("converting");
		boolean new_version = StringUtil.hasAValue((String)ic.getTransientDatum("new_version"));
		ConnectionWrapper conn = (ConnectionWrapper)ic.getTransientDatum(SmartFormHandler.CONNECTION);

		if( StringUtil.hasAValue(button) )
		{
			//if created a new version then update the version numbers and
			// archive the old version
			if( new_version )
				result = updateNewVersions(ic, conn);

			//handle custom cols only if it is a workorder (versions must run
			// before this to get the new request_id)
			if( StringUtil.hasAValue(request_type_code) && request_type_code.equalsIgnoreCase("workorder") )
				result = handleCustomColsRecord(ic, conn);

			//if sending a service request, then create a requisition and if
			// needed a job
			if( request_type_code != null && request_type_code.equalsIgnoreCase("service_request") && button.equalsIgnoreCase("Send") )
			{
				result = sendServiceRequest(ic, conn);
				if( !result )
					Diagnostics.error("PDSPostHandler.handleEnvironment() sendServiceRequest method failed");

                boolean email_result = ic.dispatchHandler("ims.handlers.proj.PDSEmailHandler");
                if( !email_result )
                {
                    Diagnostics.error("PDSPostHandler.handleEnvironment() emailing failed.");
                    ic.setTransientDatum("calendar_failed","true");
                }

				ic.setTransientDatum("dont_show_msg","true");
			}

			//if creating a quote from a quote request, remove quote_id from
			// session
			String clear_quote_id = ic.getParameter("clear_quote_id");
			if( result && clear_quote_id != null && clear_quote_id.equalsIgnoreCase("true") )
			{
				result = ic.dispatchHandler("ims.handlers.proj.SetProjectDatumHandler");
			}

			//if converting a project_folder to a service request or quote
			// request, then delete the project_folder request.
			if( result && StringUtil.hasAValue(converting) && converting.equalsIgnoreCase("true")
				 && (button.equalsIgnoreCase("Save") || button.equalsIgnoreCase("Send"))
				 && request_type_code != null && (request_type_code.equalsIgnoreCase("service_request") || request_type_code.equalsIgnoreCase("quote_request")) )
			{
				result = handleProjectRequest(ic, conn);
				if( !result )
					Diagnostics.error("PDSPostHandler.handleEnvironment() handleProjectRequest method failed");
			}

			//if workorder
			if( StringUtil.hasAValue(request_type_code) && request_type_code.equalsIgnoreCase("workorder") )
			{

			 	if( button.equalsIgnoreCase("Save") )
			 	{
			 		//do nothing, smartform already saved request.
			 	}
			 	else if( button.equalsIgnoreCase("Approve") )
			 	{//check if customer contact = approver then send, else
				  // forward to approver

				 	if( request_status_type_code.equalsIgnoreCase("approved") )
					 	result = sendWorkorder(ic, conn);
			 	}
				if( StringUtil.hasAValue(quoting) && quoting.equalsIgnoreCase("true") )
				{//need to mark this workorder as a quote request workorder
					conn.updateEx("UPDATE requests SET quote_request_id = request_id WHERE request_id = "+conn.toSQLString(ic.getParameter("request_id")));
					ic.setParameter("quote_request_id", ic.getParameter("request_id"));
				}

			}

			if( result && button.equalsIgnoreCase("Send") || button.equalsIgnoreCase("Approve") || button.equalsIgnoreCase("Refuse") )
			{//if made it this far and we are sending, then email contacts;
				ic.setTransientDatum("record_id",ic.getParameter("request_id"));
				ic.setTransientDatum("record_type_code",request_type_code);
				ic.setTransientDatum("record_status_type_code",request_status_type_code);
				boolean email_result = ic.dispatchHandler("ims.handlers.proj.PDSCalendarHandler");
				if( !email_result )
				{
					Diagnostics.error("PDSPostHandler.handleEnvironment() calendar failed.");
					ic.setTransientDatum("calendar_failed","true");
				}

			}

			//if created a new project or request, or sending, then show
			// acknowledgement window
			if ( result && (button.equals(SmartFormComponent.Save) || button.equalsIgnoreCase("Send")
					|| button.equalsIgnoreCase("Approve") || button.equalsIgnoreCase("Refuse")
					|| button.equalsIgnoreCase("Archive") ) )
			{
				if( !(button.equals(SmartFormComponent.Save) && mode.equals(SmartFormComponent.Update) )
					&& !button.equalsIgnoreCase("Archive") )
				{//if not saving while in update, show acknowledge window.
					Diagnostics.debug2("Set parameter 'acknowledgement' = true");
					ic.setTransientDatum("acknowledgement","true");
					ic.setTransientDatum("is_sent", ic.getParameter("is_sent") );
					ic.setTransientDatum("button_action","Save");
					ic.setTransientDatum("request_type_code", request_type_code);
					ic.setTransientDatum("request_status_type_code", request_status_type_code);
					if( request_type_code.equalsIgnoreCase("quote") )
					{
						ic.setTransientDatum("request_id", ic.getParameter("quote_id"));
						ic.setTransientDatum("request_no", ic.getParameter("quote_no"));
					}
					else
					{
						ic.setTransientDatum("request_id", ic.getParameter("request_id"));
						ic.setTransientDatum("request_no", ic.getParameter("request_no"));
						ic.setTransientDatum("version_no", ic.getParameter("version_no"));
					}
				}

				if( request_type_code.equalsIgnoreCase("workorder") && is_quote_request)
					ic.setHTMLTemplateName("enet/req/sr_list.html"); //to avoid
																// reloading
																// the huge
																// request page
				else if( request_type_code.equalsIgnoreCase("workorder") )
					ic.setHTMLTemplateName("enet/req/sr_list.html"); //to avoid
																// reloading
																// the huge
																// request page
				else if( request_type_code.equalsIgnoreCase("service_request") )
					ic.setHTMLTemplateName("enet/req/sr_list.html"); //to avoid
																// reloading
																// the huge
																// request page
				else if( request_type_code.equalsIgnoreCase("quote_request") )
					ic.setHTMLTemplateName("enet/req/qr_list.html"); //to avoid
																// reloading
																// the huge
																// request page
				else
					ic.setHTMLTemplateName("enet/proj/pf_list.html"); //to avoid
																 // reloading
																 // the huge
																 // request
																 // page
			}
		}

		Diagnostics.debug2("PDSPostHandler.handleEnvironment() result = "+result);

		return result;
	}


	private boolean handleProjectRequest(InvocationContext ic, ConnectionWrapper conn) throws Exception
	{
		Diagnostics.trace("PDSPostHandler.handleProjectRequest()");
		boolean result = true;

		String project_id = (String)ic.getSessionDatum("project_id");

		Map request_types = MapUtil.getTypeMap(conn, "request_type");
		String request_type_id = (String)request_types.get("project_folder");

		StringBuffer query = new StringBuffer();
		query.append("DELETE FROM requests WHERE project_id = " + conn.toSQLString(project_id));
		query.append(" AND request_type_id = " + conn.toSQLString(request_type_id));
		int rows = conn.updateEx(query);
		if( rows == 1)
		{//found, that means we were converting a project_folder request to
		 // another request
			Diagnostics.error("Found and deleted the converted project_folder request from the requests table.");
		}

		return result;
	}

	private boolean sendServiceRequest(InvocationContext ic, ConnectionWrapper conn) throws Exception
	{
		Diagnostics.trace("PDSPostHandler.sendServiceRequest()");
		boolean result = false;

		result = setModifiedDates(ic, conn);
		if( result )
			result = createJob( ic, conn );
		if( result )
			result = createReq( ic, conn );

		return result;
	}

	private boolean sendWorkorder(InvocationContext ic, ConnectionWrapper conn) throws Exception
	{
		Diagnostics.trace("PDSPostHandler.sendWorkorder()");
		boolean result = false;

		result = setModifiedDates(ic, conn);
		if( result )
			result = createJob( ic, conn );
		if( result )
			result = createReq( ic, conn );
		if( result )
			result = createRequestVendors( ic, conn );

		return result;
	}

	private boolean createJob(InvocationContext ic, ConnectionWrapper conn) throws Exception
	{
		Diagnostics.trace("PDSPostHandler.createJob()");
		boolean result = true;
		String project_id = (String)ic.getSessionDatum("project_id");
		ConnectionWrapper gp_conn = null;

		try
		{
			//detect if job exists, if not, then create
			StringBuffer job_query = new StringBuffer();
			job_query.append("SELECT job_id FROM jobs WHERE project_id = " + conn.toSQLString(project_id));
			Diagnostics.debug2("Existing job query = " + job_query );
			QueryResults rs = conn.resultsQueryEx(job_query);
			if( rs.next() )
			{//remember job_id for creating requisition
				ic.setParameter( "job_id", rs.getString(1) );
			}
			else
			{//no job so create a new job

				rs.close(); //going to reuse this variable
				StringBuffer project_query = new StringBuffer();
				project_query.append("SELECT");
				project_query.append("  project_no");
				project_query.append(", job_name");
				project_query.append(", project_type_id");
				project_query.append(", customer_id");
				project_query.append(", organization_id");
				project_query.append(", customer_name");
				project_query.append(", ext_customer_id");
				project_query.append(", dealer_name");
				project_query.append(", ext_dealer_id");
				project_query.append("  FROM projects_v WHERE project_id = " + conn.toSQLString(project_id));
				Diagnostics.debug2("projects_v query = " + project_query );
				rs = conn.resultsQueryEx( project_query );
				if( !rs.next() )
				{
					Diagnostics.error("Error, failed to find project info from projects_v where project_id = '"+project_id+"'");
					SmartFormHandler.addSmartFormError(ic, "Error, failed to find customer in Great Plains to create job_item_rates.  Please notify the ServiceTRAX sys admin.");
					result = false;
				}
				else
				{//found project info

					//get bill_to_contact_id
					String billingUserId = getUserIdForContactId(conn, ic.getParameter("a_m_contact_id"));

					String amSalesContactId =  ic.getParameter("a_m_sales_contact_id");


					//need to determine ext_price_level_id by ext_customer_id
					// first
					String gp_org = null;
					gp_org = (String)ic.getRequiredSessionDatum("org_resource");
					gp_conn = (ConnectionWrapper)ic.getResource( gp_org );

					StringBuffer price_query = new StringBuffer();
					price_query.append("SELECT rtrim(prclevel) ext_price_level_id FROM RM00101 WHERE custnmbr = "+conn.toSQLString( rs.getString("ext_customer_id") ) );
					Diagnostics.debug2("Customer Price level query = " + price_query );
					QueryResults rs2 = gp_conn.resultsQueryEx( price_query );
					String ext_price_level_id = null;
					if( rs2.next() )
					{
						String extPriceLevelId = rs2.getString("ext_price_level_id" );
						if( StringUtil.hasAValue( extPriceLevelId ) )
						{
							ext_price_level_id = extPriceLevelId;
						}
					}
					IMSUtil.closeQueryResultSet(rs2);

					if( ext_price_level_id == null )
					{//did not find a great plains customer, so search for the
					 // dealer's pricelevel

						StringBuffer price2_query = new StringBuffer();
						price2_query.append("SELECT rtrim(prclevel) ext_price_level_id FROM RM00101 WHERE custnmbr = " +conn.toSQLString( rs.getString("ext_dealer_id") ) );
						Diagnostics.debug2("Did not find customer's, so Dealer Price level query = " + price2_query );
						rs2 = gp_conn.resultsQueryEx(price2_query);
						if( rs2.next() )
						{
							String extPriceLevelId = rs2.getString("ext_price_level_id" );
							if( StringUtil.hasAValue( extPriceLevelId ) )
							{
								ext_price_level_id = extPriceLevelId;
							}
						}
						IMSUtil.closeQueryResultSet(rs2);

						if( ext_price_level_id == null )
						{
							Diagnostics.error("Error, failed to find dealer in Great Plains for project_id '"+project_id+"' and ext_dealer_id = '"+rs.getString("ext_dealer_id")+"', null ext_dealer_id is not okay.");
							SmartFormHandler.addSmartFormError(ic, "Error, failed to find Dealer in Great Plains to create job item rates.  Please notify the ServiceTRAX System Administrator.");
							result = false;
						}
					}

					//default job_status_type_id as new
					Map job_status_types = MapUtil.getTypeMap(conn, "job_status_type");
					String job_status_type_id = (String)job_status_types.get("created");

					String project_type_id = rs.getString("project_type_id");
					String customer_id = rs.getString("customer_id");

					//now insert job
					StringBuffer insert_query = new StringBuffer();
					insert_query.append("INSERT INTO jobs (");
					insert_query.append("  project_id");
					insert_query.append(", job_no");
					insert_query.append(", customer_id");
					insert_query.append(", job_name");
					insert_query.append(", ext_price_level_id");
					insert_query.append(", job_type_id");
					insert_query.append(", job_status_type_id");
					insert_query.append(", billing_user_id");
					insert_query.append(", a_m_sales_contact_id");
					insert_query.append(", created_by");
					insert_query.append(", date_created");
					insert_query.append(") VALUES (");
					insert_query.append("  ").append( conn.toSQLString(project_id) );
					insert_query.append(", ").append( conn.toSQLString(rs.getString("project_no")) );
					insert_query.append(", ").append( conn.toSQLString(customer_id) );
					insert_query.append(", ").append( conn.toSQLString(rs.getString("job_name")) );
					insert_query.append(", ").append( conn.toSQLString(ext_price_level_id) );
					insert_query.append(", ").append( conn.toSQLString(rs.getString("project_type_id")) );
					insert_query.append(", ").append( conn.toSQLString(job_status_type_id) );
					insert_query.append(", ").append( conn.toSQLString(billingUserId) );
					insert_query.append(", ").append( conn.toSQLString(amSalesContactId) );
					insert_query.append(", ").append( conn.toSQLString( (String)ic.getSessionDatum("user_id")) ); //set
																												  // by
																												  // SmartFormPreHandler
					insert_query.append(", ").append( "getDate()" ); //set by
																	 // SmartFormPreHandler
					insert_query.append(")");
					Diagnostics.debug2("Insert Job query = " + insert_query );
					int rows = conn.updateEx(insert_query);
					if( rows != 1 )
					{//failed to insert
						Diagnostics.error("Error, failed to insert new job.");
						SmartFormHandler.addSmartFormError(ic, "Error, failed to insert new job. Please tell the ServiceTRAX sys admin.");
						result = false;
					}
					else
					{//retrieve new job_id
						rs.close(); //reusing
						StringBuffer job2_query = new StringBuffer();
						job2_query.append("SELECT job_id FROM jobs WHERE project_id = " + conn.toSQLString(project_id));
						Diagnostics.debug2("Retrieve new job_id query = " + job2_query );
						rs = conn.resultsQueryEx(job2_query);
						if( rs.next() )
						{//remember job_id for creating requisition
							ic.setParameter( "job_id", rs.getString(1) );
							ic.setParameter( "job_type_id", project_type_id );
							ic.setParameter( "ext_price_level_id", ext_price_level_id);
							ic.setParameter( "customer_id", customer_id);
							ic.setParameter( "load_rates", "true");
							ic.setTransientDatum("dont_show_msg","true");
//Diagnostics.error("job_id='"+rs.getString(1)+"',
// job_type_id='"+job_type_id+"', ext_price_level_id='"+ext_price_level_id+"',
// customer_id='"+customer_id+"'");
							//load items for the new job
							boolean items_result = ic.dispatchHandler("ims.handlers.job_processing.ItemHandler");
							if( !items_result )
								Diagnostics.error("PDSPostHandler.handleEnvironment() ItemHandler failed for creation of project_id ='"+project_id+"'");
						}
						else
						{
							Diagnostics.error("Error, failed to retreive new job_id for project_id = '"+project_id+"'");
							SmartFormHandler.addSmartFormError(ic, "Error, failed to retreive new job_id.  Please tell the ServiceTRAX sys admin.");
						}
					}
				}
			}
			IMSUtil.closeQueryResultSet(rs);
		}
		catch( Exception e )
		{
			throw new Exception("Exception in createJob\n" + e.toString() );
		}
		finally
		{
			if (gp_conn != null)
			{
				gp_conn.release();
			}
		}

		return result;
	}

		private String getUserIdForContactId(ConnectionWrapper conn, String contactId) throws SQLException {
		String userForContactQuery = "SELECT top 1 user_id FROM users WHERE contact_id = " + conn.toSQLString(contactId);
		Diagnostics.debug2("userForContactQuery = " + userForContactQuery);
		String userId = null;
		QueryResults rs = conn.resultsQueryEx(userForContactQuery);
		if (!rs.next())
		{
			Diagnostics.error("Note: failed to find the user that has a contact_id of '" + contactId + "'");
		}
		else
		{
			userId = rs.getString(1);
		}
		rs.close(); // done with this one
		return userId;
	}


	private boolean createReq(InvocationContext ic, ConnectionWrapper conn) throws Exception
	{
		Diagnostics.trace("PDSPostHandler.createReq()");
		boolean result = true;

		String job_id = ic.getParameter("job_id");
		String request_id = ic.getParameter("request_id");
		String version_no = ic.getParameter("version_no");
		String request_type_code = ic.getParameter("request_type_code");
		String service_id = null;
		StringBuffer query = new StringBuffer();
		boolean has_service = false; //assuming will have to insert
		boolean update_service = false; //default is insert
		String delivery_type_id = ic.getParameter("delivery_type_id");
		String schedule_type_id = ic.getParameter("schedule_type_id");

		//detect if req exists first
		query = new StringBuffer();
		query.append("SELECT r.REQUEST_ID, s.SERVICE_ID, s.VERSION_NO FROM dbo.REQUESTS r LEFT OUTER JOIN dbo.SERVICES s ON r.REQUEST_ID = s.REQUEST_ID WHERE ");
		query.append(" r.request_id = " + conn.toSQLString(request_id));
		QueryResults rs = conn.resultsQueryEx(query);
		if( rs.next() )
		{//the request already exists check to see if service does and if same
		 // version
			service_id = rs.getString("service_id");
			has_service = StringUtil.hasAValue( service_id );
			if( has_service && StringUtil.hasAValue(version_no) && !version_no.equalsIgnoreCase(rs.getString("version_no")) )
				update_service = true; //not the same version so update
									   // service request
		}
		IMSUtil.closeQueryResultSet(rs);

		if( !has_service || update_service )
		{//insert or update req

			//default service_type_id as project's long view, if workorder
			// check to see if short view (scheduler does not see)
			Map service_types = MapUtil.getTypeMap(conn, "service_type");
			String service_type_id = (String)service_types.get("long_view");

			if( StringUtil.hasAValue(request_type_code) && request_type_code.equalsIgnoreCase("workorder") )
			{//workorder specific data

				query = new StringBuffer();
				query.append("SELECT 'x' FROM jobs j WHERE j.view_schedule_flag='N' AND job_id = ?");
				rs = conn.select(query , job_id);
				if( rs.next() )
				{//workorder reqs should be short reqs and not visible to
				 // scheduler
					service_type_id = (String)service_types.get("short_view");
				}
				IMSUtil.closeQueryResultSet(rs);

				//need to grab a delivery type since it is required on
				// Requisition.
				Map delivery_types = MapUtil.getTypeMap(conn, "delivery_type");
				delivery_type_id = (String)delivery_types.get("n_a");

				//need to grab a schedule type since it is required on
				// Requisition.
				Map schedule_types = MapUtil.getTypeMap(conn, "schedule_type");
				schedule_type_id = (String)schedule_types.get("date_time");

				//need to grab sch and act dates off of service
			}

			//default service_status_type_id as new
			Map service_status_types = MapUtil.getTypeMap(conn, "service_status_type");
			String serv_status_type_id = (String)service_status_types.get("created");

			String ordered_by = ic.getParameter("modified_by");
			if( !StringUtil.hasAValue(ordered_by) )
				ordered_by = ic.getParameter("created_by");
			String ordered_date = ic.getParameter("date_modified");
			if( ordered_date == null )
				ordered_date = ic.getParameter("date_created");
			if( ordered_date != "getDate()" )
				ordered_date = conn.toSQLString(ordered_date);

			Hashtable fields = new Hashtable();
			fields.put("request_id", 			conn.toSQLString(request_id) );
			fields.put("job_id", 				conn.toSQLString(ic.getParameter("job_id")) );
			fields.put("job_location_id", 	conn.toSQLString(ic.getParameter("job_location_id")) );
			fields.put("service_no", 			conn.toSQLString(ic.getParameter("request_no")) ); //service_no
			fields.put("version_no", 			conn.toSQLString(ic.getParameter("version_no")) ); //version_no
			fields.put("service_type_id", 	conn.toSQLString( service_type_id ) );
			fields.put("serv_status_type_id",serv_status_type_id);
			fields.put("description", 			conn.toSQLString(ic.getParameter("description")) );
			fields.put("internal_req_flag", 	conn.toSQLString("N") );
			fields.put("report_to_loc_id", 	conn.toSQLString(ic.getParameter("job_location_id")) ); //report_to_loc_id
			fields.put("customer_ref_no", 	conn.toSQLString(ic.getParameter("dealer_cust_id")) ); //customer_ref_no
			fields.put("idm_contact_id", 		conn.toSQLString(ic.getParameter("a_m_contact_id")) ); //idm_contact_id
			fields.put("customer_contact_id",conn.toSQLString(ic.getParameter("customer_contact_id")) );
			fields.put("sales_contact_id", 	conn.toSQLString(ic.getParameter("d_sales_rep_contact_id")) ); //sales_contact_id
			fields.put("support_contact_id", conn.toSQLString(ic.getParameter("d_sales_sup_contact_id")) ); //support_contact_id
			fields.put("designer_contact_id",conn.toSQLString(ic.getParameter("d_designer_contact_id")) ); //designer_contact_id
			fields.put("project_mgr_contact_id",conn.toSQLString(ic.getParameter("d_proj_mgr_contact_id")) ); //project_mgr_contact_id
			String po_no = null;
			if( StringUtil.hasAValue(ic.getParameter("dealer_po_no")) )
				po_no = ic.getParameter("dealer_po_no");
			if( StringUtil.hasAValue(ic.getParameter("dealer_po_line_no")) )
				po_no += "-" + ic.getParameter("dealer_po_line_no");
			if( !StringUtil.hasAValue(po_no) )
				po_no = ic.getParameter("customer_po_no");
			fields.put("po_no", 					conn.toSQLString(po_no) );
			fields.put("billing_type_id", 	conn.toSQLString(ic.getParameter("quote_type_id")) ); //billing_type_id
			fields.put("ordered_by", 			ordered_by);
			fields.put("ordered_date", 		ordered_date );
			fields.put("schedule_type_id", 	conn.toSQLString( schedule_type_id ) );
			fields.put("est_start_date", 		conn.toSQLString(ic.getParameter("est_start_date")) );
			fields.put("est_start_time", 		conn.toSQLString(ic.getParameter("est_start_time")) );
			fields.put("est_end_date", 		conn.toSQLString(ic.getParameter("est_end_date")) );
			fields.put("truck_arrival_date", conn.toSQLString(ic.getParameter("product_del_to_wh_date")) ); //truck_arrival_date
			fields.put("delivery_type_id", 	conn.toSQLString( delivery_type_id ) );
			fields.put("warehouse_loc", 		conn.toSQLString(ic.getParameter("warehouse_loc")) );
			fields.put("pri_furn_type_id", 	conn.toSQLString(ic.getParameter("pri_furn_type_id")) );
			fields.put("pri_furn_line_type_id",conn.toSQLString(ic.getParameter("pri_furn_line_type_id")) );
			fields.put("sec_furn_type_id", 	conn.toSQLString(ic.getParameter("sec_furn_type_id")) );
			fields.put("sec_furn_line_type_id",conn.toSQLString(ic.getParameter("sec_furn_line_type_id")) );
			fields.put("num_stations", 		conn.toSQLString(ic.getParameter("case_furn_type_id")) ); //num_stations
			if( StringUtil.hasAValue(request_type_code) && request_type_code.equalsIgnoreCase("workorder") )
				fields.put("product_qty", 		conn.toSQLString(ic.getParameter("qty1")) ); //product_qty
			else
				fields.put("product_qty", 		conn.toSQLString(ic.getParameter("case_furn_line_type_id")) ); //product_qty
			fields.put("wood_product_type_id",conn.toSQLString(ic.getParameter("wood_product_type_id")) ); //wood_product_type_id
			fields.put("blueprint_location",	conn.toSQLString(ic.getParameter("plan_location")) ); //blueprint_location
			fields.put("punchlist_type_id", 	conn.toSQLString(ic.getParameter("punchlist_item_type_id")) );//punchlist_type_id
			fields.put("head_val_flag", 		conn.toSQLString("Y") ); //head_val_flag
			fields.put("loc_val_flag", 		conn.toSQLString("Y") ); //loc_val_flag
			fields.put("prod_val_flag", 		conn.toSQLString("Y") ); //prod_val_flag
			fields.put("sch_val_flag", 		conn.toSQLString("Y") ); //sch_val_flag
			fields.put("task_val_flag",	 	conn.toSQLString("N") ); //task_val_flag
			fields.put("res_val_flag", 		conn.toSQLString("N") ); //res_val_flag
			fields.put("cust_val_flag", 		conn.toSQLString("N") ); //cust_val_flag
			fields.put("bill_val_flag", 		conn.toSQLString("N") ); //bill_val_flag
			fields.put("watch_flag", 			conn.toSQLString("N") ); //watch_flag
			fields.put("taxable_flag", 		conn.toSQLString(ic.getParameter("taxable_flag")) );
			fields.put("product_setup_desc", conn.toSQLString(ic.getParameter("other_conditions")) ); //product_setup_desc
			fields.put("cust_col_1", 			conn.toSQLString(ic.getParameter("cust_col_1")) );
			fields.put("cust_col_2", 			conn.toSQLString(ic.getParameter("cust_col_2")) );
			fields.put("cust_col_3", 			conn.toSQLString(ic.getParameter("cust_col_3")) );
			fields.put("cust_col_4", 			conn.toSQLString(ic.getParameter("cust_col_4")) );
			fields.put("cust_col_5", 			conn.toSQLString(ic.getParameter("cust_col_5")) );
			fields.put("cust_col_6", 			conn.toSQLString(ic.getParameter("cust_col_6")) );
			fields.put("cust_col_7", 			conn.toSQLString(ic.getParameter("cust_col_7")) );
			fields.put("cust_col_8", 			conn.toSQLString(ic.getParameter("cust_col_8")) );
			fields.put("cust_col_9", 			conn.toSQLString(ic.getParameter("cust_col_9")) );
			fields.put("cust_col_10", 			conn.toSQLString(ic.getParameter("cust_col_10")) );
			fields.put("priority_type_id", 	conn.toSQLString(ic.getParameter("priority_type_id")) );
			fields.put("created_by", 			(String)ic.getSessionDatum("user_id")); //set
																						 // by
																						 // SmartFormPreHandler
			fields.put("date_created",			"getDate()" );

			query = new StringBuffer();
			if( has_service )
			{//updating
				query.append("UPDATE services SET ");
				Enumeration columns = fields.keys();
				String key = (String)columns.nextElement();
				query.append( key + "=" + (String)fields.get(key) ); //first
																	 // one no
																	 // commas
				while( columns.hasMoreElements() )
				{
					key = (String)columns.nextElement();
					query.append( ", " + key + "=" + (String)fields.get(key) );
				}
				query.append(" WHERE service_id = " + conn.toSQLString(service_id) );
			}
			else //inserting
			{
				//now insert job
				query.append("INSERT INTO services (");
				Enumeration columns = fields.keys();
				query.append( (String)columns.nextElement() ); //first one no
															   // commas
				while( columns.hasMoreElements() )
				{
					query.append( ", " + (String)columns.nextElement() );
				}
				query.append(") VALUES (");
				columns = fields.elements();
				query.append( (String)columns.nextElement() );
				while( columns.hasMoreElements() )
				{
					query.append( ", " + (String)columns.nextElement() );
				}
				query.append(")");
			}

			int rows = conn.updateEx(query);
			if( rows != 1 )
			{//failed to insert or update
				if( update_service )
					Diagnostics.error("Error, failed to update service.");
				else
					Diagnostics.error("Error, failed to insert service.");

				SmartFormHandler.addSmartFormError(ic, "Error, failed to insert or update requisition. Please tell the ServiceTRAX sys admin.");
				result = false;
			}
			else
			{//make sure service has access to custom cols
				if( !has_service )
					conn.updateEx("UPDATE custom_cols SET service_id = (SELECT @@identity) WHERE request_id = " + conn.toSQLString(request_id));
			}
		}
		return result;
	}


	private boolean createRequestVendors(InvocationContext ic, ConnectionWrapper conn) throws Exception
	{
		Diagnostics.trace("PDSPostHandler.createRequestVendors()");
		boolean result = true;
		//determine all the contact_ids

		//now insert request vendors
		String request_id = ic.getParameter("request_id");
		String[] vendor_contacts =
		{
			"furniture1_contact_id",
			"furniture2_contact_id",
			"a_d_designer_contact_id",
			"gen_contractor_contact_id",
			"electrician_contact_id",
			"data_phone_contact_id",
			"phone_contact_id",
			"carpet_layer_contact_id",
			"mover_contact_id",
			"other_contact_id"
		};
		Map vendor_contact_ids = new HashMap();

		StringBuffer query = new StringBuffer();
		query.append("SELECT ");
		for( int i = 0; i < vendor_contacts.length; i++)
		{//loop through contacts to build select statement
			query.append(vendor_contacts[i]);
			if( i != vendor_contacts.length-1 )
				query.append(", ");
		}
		query.append(" FROM requests WHERE request_id = "+conn.toSQLString(request_id));

		//only create request vendors for filled in vendors...
		QueryResults rs = conn.resultsQueryEx( query );
		QueryResults rs2 = null;
		QueryResults rs3 = null;
		if( rs.next() )
		{//grab each of the ids and place in hashtable for further use
			for( int i = 0; i < vendor_contacts.length; i++)
			{//loop through contacts to add contact_id if not empty

				if( StringUtil.hasAValue(rs.getString(vendor_contacts[i]) ) )
				{//the request has this vendor so make sure this is not an
				 // ignore contact name

					String ignore_contact_name = (String)ic.getAppGlobalDatum("ignoreContactName");
					rs2 = conn.resultsQueryEx("SELECT 'x' FROM contacts WHERE contact_name = "+conn.toSQLString(ignore_contact_name)+" AND contact_id="+conn.toSQLString(rs.getString(vendor_contacts[i])));
					if( rs2.next() )
					{
						//contact name is an ignore contact name so don't
						// create request_vendor
					}
					else
					{//check to see if vendor_contact already a request vendor

						rs3 = conn.resultsQueryEx("SELECT 'x' FROM request_vendors WHERE request_id="+conn.toSQLString(request_id)+" AND vendor_contact_id="+conn.toSQLString(rs.getString(vendor_contacts[i])));
						if( rs3.next() )
						{
							//already exists don't create another
						}
						else
						{//create request vendor
							vendor_contact_ids.put(vendor_contacts[i], rs.getString(vendor_contacts[i]));
	Diagnostics.debug("<><><><><><><>contact: "+vendor_contacts[i]+"', value='"+rs.getString(vendor_contacts[i]));
						}
						rs3.close();
					}
					rs2.close();
				}
			}
		}
		rs.close();

		PreparedStatement stmt = null;
		try {
			stmt = conn.prepareStatement(NewPDSPostHandler.INSERT_REQUEST_VENDORS);
			int rows[] = null;
			Iterator iter = vendor_contact_ids.values().iterator();
			while( iter.hasNext() )
			{
				stmt.setString(1, request_id);
				stmt.setString(2, (String)iter.next());
				stmt.setInt(3, 1);
				stmt.setString(4, "N");
				stmt.setString(5, "N");
				stmt.setString(6,(String)ic.getSessionDatum("user_id"));
				
				stmt.addBatch();
			}
			
			rows = stmt.executeBatch();

			for (int i = 0; i < rows.length; i++) {
				if( rows[i] != 1 ) {//failed to insert
					Diagnostics.error("Error, failed to insert new request_vendor.");
					SmartFormHandler.addSmartFormError(ic, "Error, failed to insert new request vendor record during Workorder Approval. Please tell the ServiceTRAX sys admin.");
					result = false;
				}
			}
		}catch (Exception e) {
			ErrorHandler.handleException(ic, e, "Exception in PDSPostHandler.createRequestVendors()when inserting request vendors.");
			result = false;
		} finally {
			if (stmt != null) stmt.close();
		}

		Diagnostics.debug2("Insert Job query = " + query );

		return result;
	}


	private boolean updateNewVersions(InvocationContext ic, ConnectionWrapper conn) throws Exception
	{
		Diagnostics.trace("PDSPostHandler.updateNewVersions()");
		boolean result = true;
		String request_id = ic.getParameter("request_id");
		String old_version_request_id = (String)ic.getTransientDatum("old_version_request_id");
		String old_version_no = ic.getParameter("version_no");
		String request_type_code = ic.getParameter("request_type_code");

		conn.updateEx("UPDATE requests SET version_no = " + conn.toSQLString(old_version_no) + "+1 WHERE request_id = " + conn.toSQLString(request_id) );
		conn.updateEx("UPDATE requests SET is_copy = 'N', version_no = " + conn.toSQLString(old_version_no) + " WHERE request_id = " + conn.toSQLString(old_version_request_id) );
		PDSPreHandler.archive(ic, conn, request_type_code, old_version_request_id );
		ic.setParameter("version_no", ""+(Integer.parseInt(old_version_no) + 1) );
		return result;
	}


	private boolean setModifiedDates(InvocationContext ic, ConnectionWrapper conn) throws Exception
	{
		Diagnostics.trace("PDSPostHandler.setModifiedDates()");
		boolean result = true;
		String customer_contact_id = ic.getParameter("customer_contact_id");
		String job_location_id = ic.getParameter("job_location_id");
		String request_id = ic.getParameter("request_id");

		StringBuffer query = new StringBuffer();
		query.append("UPDATE requests SET ");
		query.append("cust_contact_mod_date = (SELECT date_modified FROM contacts WHERE contact_id = " + conn.toSQLString(customer_contact_id) + ")");
		query.append(", job_location_mod_date = (SELECT date_modified FROM job_locations WHERE job_location_id = " + conn.toSQLString(job_location_id) + ")");
		query.append(" WHERE request_id = " + conn.toSQLString(request_id) );
		conn.updateExactlyEx(query,1);

		return result;
	}

	/**
	 * Copy the customer custom column settings into a request or service
	 * specific record so that the request or service is unaffected by future
	 * changes to customer custom cols as well as keeping the actual text value
	 * stored on request and service for smarttable display
	 *
	 * @param ic
	 * @param conn
	 * @param isRequest
	 * @return
	 */
	private boolean handleCustomColsRecord(InvocationContext ic, ConnectionWrapper conn) throws Exception
	{
		Diagnostics.trace("PDSPostHandler.handleCustomColsRecord()");
		boolean result = true;

		String user_id = (String)ic.getSessionDatum("user_id");
		String customer_id = ic.getParameter("effective_customer_id");
		String request_id = ic.getParameter( "request_id" );
		String old_version_request_id = (String)ic.getTransientDatum("old_version_request_id");

		//test if custom columns exist
		StringBuffer query = null;
		String count = conn.selectFirst("SELECT count(*) FROM custom_cols WHERE request_id = ?", request_id);
		if( count.equals("0") && !StringUtil.hasAValue(old_version_request_id) )
		{//insert only on a new request
			query = new StringBuffer();
			query.append("INSERT INTO custom_cols (request_id, custom_cust_col_id, col_title, col_sequence, active_flag, is_mandatory, is_droplist, created_by, date_created)");
			query.append(" SELECT " + conn.toSQLString(request_id) + ", custom_cust_col_id, column_desc, col_sequence, active_flag, is_mandatory, is_droplist, " + user_id + ", getDate()");
			query.append(" FROM custom_cust_columns");
			query.append(" WHERE customer_id = " + conn.toSQLString(customer_id) + " ORDER BY col_sequence");
			conn.updateEx(query);
		}

		// update value of custom_cols
		String c_value = null;
		String c_name = null;
		StringBuffer update_string = new StringBuffer();
		for( int i = 1; i < 11; i++)
		{
			//put droplist id or non droplist text into custom_cols
			c_name = "cust_col_" + i;
			c_value = ic.getParameter( "x" + c_name ); //use the x to separate
													   // custom_col table
													   // value from request
													   // table value
			query = new StringBuffer();
			query.append("UPDATE custom_cols SET col_value = " + conn.toSQLString( c_value ) +", modified_by = " + user_id + ", date_modified = getDate()");
			query.append(" WHERE request_id = " + conn.toSQLString(request_id) + " AND col_sequence = " + i );
			conn.updateEx(query);

			//want only text in the request table for smart table display
			// purposes
			if( StringUtil.hasAValue( ic.getParameter( "x" + c_name + "_text") ) )
				c_value = ic.getParameter( "x" + c_name + "_text");
			update_string.append(c_name + " = " + conn.toSQLString(c_value) +", ");
			ic.setParameter(c_name, c_value); //this is for the service
											  // creation when sending request
											  // to service
		}

		if( StringUtil.hasAValue( update_string.toString() ) )
		{//update request to have only text values
			query = new StringBuffer();
			query.append("UPDATE requests SET " + update_string + " modified_by = " + user_id + ", date_modified = getDate()");
			query.append(" WHERE request_id = " + conn.toSQLString(request_id) );
			conn.updateEx(query);
		}

		return result;
	}
}