package ims.handlers.time_capture;

import ims.Constants;
import ims.helpers.RightsHelper;

import java.sql.Date;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class ServiceLineFieldHandler extends BaseHandler
{
	public void setUpHandler()
	{
		Diagnostics.debug2("ServiceLineFieldHandler.setUpHandler()");
	}

	public void destroy()
	{
		Diagnostics.debug2("ServiceLineFieldHandler.destroy()");
	}



  	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		Diagnostics.trace("ServiceLineFieldHandler.handleEnvironment()");
		boolean result = true;

		ConnectionWrapper conn = null;
		String query = null;
		QueryResults rs = null;

		String service_line_id = null;
		String module = null;
		String button = null;
		String level = null;

		String tc_job_id = null;
		String tc_service_id = null;
		String bill_job_id = null;
		String bill_service_id = null;
		String job_id = (String)ic.getSessionDatum("job_id"); //used to default job_id when creating
		String service_id = (String)ic.getSessionDatum("service_id"); //userd to default service_d when creating
		String item_id = null;
		String item_type_code = null;
		String status_id = null;
		String redisplay = null;
		String error_msg = null;

		boolean not_closed   = true;
		boolean not_exported = true;
		boolean not_pooled   = true;
		boolean not_billed   = true;
		boolean not_posted   = true;
		boolean not_internal_req = false;
		boolean redisplaying = false;
		boolean billing      = false;

		try
		{
			conn = (ConnectionWrapper)ic.getResource();
			service_line_id = ic.getParameter("service_line_id");
			module = ic.getParameter("module");
			button = ic.getParameter("button");
			level = ic.getParameter("level");
			tc_job_id = ic.getParameter("tc_job_id");
			tc_service_id = ic.getParameter("tc_service_id");
			bill_job_id = ic.getParameter("bill_job_id");
			bill_service_id = ic.getParameter("bill_service_id");
			item_id = ic.getParameter("item_id");
			item_type_code = ic.getParameter("item_type_code");
			status_id = ic.getParameter("status_id");
			redisplay = ic.getParameter("redisplayed");

			setLevel(ic, conn, level);

			if( StringUtil.hasAValue(module) && module.equalsIgnoreCase("bill") )
				billing = true;
Diagnostics.trace("module = '"+module+"'");
			//case when at main level, so time capture temp list shows all jobs and reqs
			if( (StringUtil.hasAValue(level) && level.equalsIgnoreCase("main")) ||
				(StringUtil.hasAValue(module) && module.equalsIgnoreCase("payroll")) ||
				(StringUtil.hasAValue(module) && module.equalsIgnoreCase("expenses"))
				)
			{
				ic.setSessionDatum("job_id","");
				ic.setSessionDatum("service_id","");
			}
			//case when changing the job, need to blank the req so it does not display same req again incorrectly
			if( !StringUtil.hasAValue(tc_service_id) )  //redisplay, rowdatum is remembered, don't want that
				ic.setTransientDatum("tc_service_id","-1");
			else
				ic.setTransientDatum("tc_service_id",""+tc_service_id);
			ic.setTransientDatum("bill_job_id",""+bill_job_id);
			//case when changing the job, need to blank the req so it does not display same req again incorrectly
			if( !StringUtil.hasAValue(bill_service_id) )  //redisplay, rowdatum is remembered, don't want that
				ic.setTransientDatum("bill_service_id","-1");
			else
				ic.setTransientDatum("bill_service_id",""+bill_service_id);
			//case when changing the resource, need to blank the item so it does not display same item again incorrectly
			if( !StringUtil.hasAValue(item_id) )  //redisplay, rowdatum is remembered, don't want that
				ic.setTransientDatum("item_id","-1");
			else
				ic.setTransientDatum("item_id",""+item_id);

			if( StringUtil.hasAValue(redisplay) && redisplay.equalsIgnoreCase("true") )
				redisplaying = true;

			if( StringUtil.hasAValue(service_line_id) )
			{//updating in some manor or other vs. creating
Diagnostics.trace("ServiceLineFieldHandler.handleEnvironment() Existing Line");

				query = "SELECT tc_job_id, tc_service_id, bill_job_id, bill_service_id, exported_flag, pooled_flag, billed_flag, posted_flag, internal_req_flag, item_id, item_type_code, status_id, getDate() cur_date FROM service_lines WHERE service_line_id = " + conn.toSQLString( service_line_id );

				rs = conn.resultsQueryEx(query);
				if( rs.next() )
				{
					not_exported = (rs.getString("exported_flag").equalsIgnoreCase("N") ? true : false);
					not_pooled   = (rs.getString("pooled_flag").equalsIgnoreCase("N") ? true : false);
					not_billed   = (rs.getString("billed_flag").equalsIgnoreCase("N") ? true : false);
					not_posted   = (rs.getString("posted_flag").equalsIgnoreCase("N") ? true : false);
					not_internal_req = (rs.getString("internal_req_flag").equalsIgnoreCase("N") ? true : false);
					item_type_code = rs.getString("item_type_code");
					ic.setParameter("item_type_code",item_type_code); //used on the template
					if( !redisplaying )
					{
						tc_job_id = rs.getString("tc_job_id");
						tc_service_id = rs.getString("tc_service_id");
						bill_job_id = rs.getString("bill_job_id");
						bill_service_id = rs.getString("bill_service_id");
						item_id = rs.getString("item_id");
						status_id = rs.getString("status_id");
						ic.setTransientDatum("tc_job_id",tc_job_id);
						ic.setTransientDatum("tc_service_id",tc_service_id);
						ic.setTransientDatum("bill_job_id",bill_job_id);
						ic.setTransientDatum("bill_service_id",bill_service_id);
						ic.setTransientDatum("item_id", item_id);
						ic.setTransientDatum("status_id", status_id);
					}
				}
				rs.close();
				if( !not_pooled )
					error_msg = "<span class='MandatoryLabel'>(Pooled)</span>";
				if( !not_billed )
					error_msg = "<span class='MandatoryLabel'>(Billed)</span>";
				if( !not_exported )
					error_msg = "<span class='MandatoryLabel'>(Exported)</span>";
				if( !not_posted )
					error_msg = "<span class='MandatoryLabel'>(Posted)</span>";

				//GET JOB and SERVICE statuses
				String job_status_type_code = null;
				if( billing )
					query = "SELECT job_status_type_code FROM jobs_v WHERE job_id = " + conn.toSQLString( bill_job_id );
				else
					query = "SELECT job_status_type_code FROM jobs_v WHERE job_id = " + conn.toSQLString( tc_job_id );
				rs = conn.resultsQueryEx(query);
				if( rs.next() )
					job_status_type_code = rs.getString("job_status_type_code");
				rs.close();

				String serv_status_type_code = null;
				if( billing )
					query = "SELECT l.code serv_status_type_code FROM services s, lookups l WHERE s.serv_status_type_id = l.lookup_id AND service_id = " + conn.toSQLString( bill_service_id );
				else
					query = "SELECT l.code serv_status_type_code FROM services s, lookups l WHERE s.serv_status_type_id = l.lookup_id AND service_id = " + conn.toSQLString( tc_service_id );
				rs = conn.resultsQueryEx(query);
				if( rs.next() )
					serv_status_type_code = rs.getString("serv_status_type_code");
				rs.close();

				//JOB
				if( not_pooled && not_posted
					&& !(StringUtil.hasAValue(job_status_type_code) && job_status_type_code.equalsIgnoreCase("closed"))
					&& !(StringUtil.hasAValue(serv_status_type_code) && serv_status_type_code.equalsIgnoreCase("closed"))
				  )
				{
					ic.setTransientDatum("sl_job","regular"); //indicates to show field and what css class to show
					ic.setTransientDatum("sl_job_r","false"); //indicates if field is readonly
				}
				else
				{
					ic.setTransientDatum("sl_job","readonly"); //indicates to show field and what css class to show
					ic.setTransientDatum("sl_job_r","true"); //indicates if field is readonly
					ic.setTransientDatum("sl_job_msg",error_msg);
					if( StringUtil.hasAValue(job_status_type_code) && job_status_type_code.equalsIgnoreCase("closed") )
					{
						ic.setTransientDatum("sl_job_msg","<span class='MandatoryLabel'>(Closed)</span>");
						not_closed = false;
					}
				}

				//SERVICE
				if( not_pooled && not_posted && not_closed && !(StringUtil.hasAValue(serv_status_type_code) && serv_status_type_code.equalsIgnoreCase("closed")) )
				{
					ic.setTransientDatum("sl_service","regular"); //indicates to show field and what css class to show
					ic.setTransientDatum("sl_service_r","false"); //indicates if field is readonly
				}
				else
				{
					ic.setTransientDatum("sl_service","readonly"); //indicates to show field and what css class to show
					ic.setTransientDatum("sl_service_r","true"); //indicates if field is readonly
					ic.setTransientDatum("sl_service_msg",error_msg);
					if( StringUtil.hasAValue(serv_status_type_code) && serv_status_type_code.equalsIgnoreCase("closed") )
					{
						ic.setTransientDatum("sl_service_msg","<span class='MandatoryLabel'>(Closed)</span>");
						not_closed = false;
					}
				}

				//SERVICE_LINE_NO
				ic.setTransientDatum("sl_no","readonly"); //indicates to show field and what css class to show
				ic.setTransientDatum("sl_no_r","true"); //indicates if field is readonly


				//SERVICE_LINE_STATUS
				ic.setTransientDatum("sl_status","readonly"); //indicates to show field and what css class to show
				ic.setTransientDatum("sl_status_r","true"); //indicates if field is readonly

				//STATUS handle case when copying a service line
				if( StringUtil.hasAValue(button) && button.equalsIgnoreCase("Copy") )
				{
					if( billing )
						ic.setTransientDatum("bill_service_line_no"," ");
					else
					{
						ic.setTransientDatum("tc_service_line_no"," "); //time, payroll, or expenses
						ic.setTransientDatum("item_id","-1"); // reset on copy
						ic.setTransientDatum("status_id","0");
						ic.setParameter("module_mode","create");
					}
				}

				//SERVICE_LINE_DATE
				if (not_closed && RightsHelper.hasViewRight(ic, Constants.FUNCTION_TIME_MODIFY_DATE))
				{
					ic.setTransientDatum("sl_date","regular"); //indicates to show field and what css class to show
					ic.setTransientDatum("sl_date_r","false"); //indicates if field is readonly
				}
				else
				{
					ic.setTransientDatum("sl_date","readonly"); //indicates to show field and what css class to show
					ic.setTransientDatum("sl_date_r","true"); //indicates if field is readonly
					ic.setTransientDatum("sl_date_msg",error_msg);
				}

				//RESOURCE
				if( not_pooled && not_posted && not_billed && not_closed)
				{
					ic.setTransientDatum("sl_resource","regular"); //indicates to show field and what css class to show
					ic.setTransientDatum("sl_resource_r","false"); //indicates if field is readonly
				}
				else
				{
					ic.setTransientDatum("sl_resource","readonly"); //indicates to show field and what css class to show
					ic.setTransientDatum("sl_resource_r","true"); //indicates if field is readonly
					ic.setTransientDatum("sl_resource_msg",error_msg);
				}

				//ITEM
				if( (not_pooled && not_posted && not_billed && not_closed) &&
					( (!billing ) || billing ) )
				{
					ic.setTransientDatum("sl_item","regular"); //indicates to show field and what css class to show
					ic.setTransientDatum("sl_item_r","false"); //indicates if field is readonly
				}
				else
				{
					ic.setTransientDatum("sl_item","readonly"); //indicates to show field and what css class to show
					ic.setTransientDatum("sl_item_r","true"); //indicates if field is readonly
					ic.setTransientDatum("sl_item_msg",error_msg);
				}

				//FIGURE OUT IF WE NEED TO DETERMINE RATE
			    if( StringUtil.hasAValue(item_id) && redisplaying &&
			    	(StringUtil.hasAValue(tc_job_id) || StringUtil.hasAValue(bill_job_id)) )
				{
					query = "SELECT TOP 1 RATE FROM JOB_ITEM_RATES WHERE ITEM_ID = " + conn.toSQLString(item_id);
					if( !billing && StringUtil.hasAValue(item_type_code) && item_type_code.equalsIgnoreCase("expense") )
					{
						query += " AND JOB_ID = " + conn.toSQLString(tc_job_id);
					}
					else if( billing )
					{
						query += " AND JOB_ID = " + conn.toSQLString(bill_job_id);
					}
					else
					{
						query += " AND JOB_ID = " + conn.toSQLString(tc_job_id);
					}
					rs = conn.resultsQueryEx(query);
					if( rs.next() )
					{
						if( not_pooled && not_posted && (StringUtil.hasAValue(item_type_code) && item_type_code.equalsIgnoreCase("expense")) )
						{
							String costQuery = "SELECT cost_per_uom FROM items WHERE item_id = " + conn.toSQLString(item_id);
							String cost = conn.queryEx(costQuery);
							
							ic.setTransientDatum("tc_rate", cost);
							ic.setTransientDatum("bill_rate",rs.getString("rate"));
						}
						else if( not_pooled && not_posted && billing )
						{
							ic.setTransientDatum("bill_rate",rs.getString("rate"));
						}
						else if( not_pooled )
						{
							ic.setTransientDatum("tc_rate",rs.getString("rate"));
						}
					}
					else
						SmartFormHandler.addSmartFormError(ic, "Could not find rate for the selected item.  Double Check that rates are loaded for this Job.");
					rs.close();
				}

				//BILL_QTY
				if( billing )
				{
					if( not_pooled && not_posted && not_internal_req && not_closed)
					{
						ic.setTransientDatum("sl_bill_qty","regular"); //indicates to show field and what css class to show
						ic.setTransientDatum("sl_bill_qty_r","false"); //indicates if field is readonly
					}
					else
					{
						ic.setTransientDatum("sl_bill_qty","readonly"); //indicates to show field and what css class to show
						ic.setTransientDatum("sl_bill_qty_r","true"); //indicates if field is readonly
						ic.setTransientDatum("sl_bill_qty_msg",error_msg);
					}
				}
				//BILL_RATE
				if( billing || (StringUtil.hasAValue(item_type_code) && item_type_code.equalsIgnoreCase("expense")) )
				{
					if( not_pooled && not_posted && not_billed && not_closed)
					{
						ic.setTransientDatum("sl_bill_rate","regular"); //indicates to show field and what css class to show
						ic.setTransientDatum("sl_bill_rate_r","false"); //indicates if field is readonly
					}
					else
					{
						ic.setTransientDatum("sl_bill_rate","readonly"); //indicates to show field and what css class to show
						ic.setTransientDatum("sl_bill_rate_r","true"); //indicates if field is readonly
						ic.setTransientDatum("sl_bill_rate_msg",error_msg);
					}
				}

				//TC_QTY & TC_RATE
				if( !billing  )
				{// module most be time

					if( not_exported && not_pooled && not_closed)
					{
						ic.setTransientDatum("sl_tc_qty","regular"); //indicates to show field and what css class to show
						ic.setTransientDatum("sl_tc_qty_r","false"); //indicates if field is readonly
						if( StringUtil.hasAValue(item_type_code) && item_type_code.equalsIgnoreCase("expense") )
						{
							ic.setTransientDatum("sl_tc_rate","regular"); //indicates to show field and what css class to show
							ic.setTransientDatum("sl_tc_rate_r","false"); //indicates if field is readonly
						}
					}
					else
					{
						ic.setTransientDatum("sl_tc_qty","readonly"); //indicates to show field and what css class to show
						ic.setTransientDatum("sl_tc_qty_r","true"); //indicates if field is readonly
						if( StringUtil.hasAValue(item_type_code) && item_type_code.equalsIgnoreCase("expense") )
						{
							ic.setTransientDatum("sl_tc_rate","readonly"); //indicates to show field and what css class to show
							ic.setTransientDatum("sl_tc_rate_r","true"); //indicates if field is readonly
						}
						ic.setTransientDatum("sl_tc_msg",error_msg);
					}
				}

				//HOURLY PAY CODE
				if( !billing && StringUtil.hasAValue(item_type_code) && item_type_code.equalsIgnoreCase("hours") )

				{
					if( not_exported && not_closed)
					{
						ic.setTransientDatum("sl_paycode","regular"); //indicates to show field and what css class to show
						ic.setTransientDatum("sl_paycode_r","false"); //indicates if field is readonly
					}
					else
					{
						ic.setTransientDatum("sl_paycode","readonly"); //indicates to show field and what css class to show
						ic.setTransientDatum("sl_paycode_r","true"); //indicates if field is readonly
						ic.setTransientDatum("sl_paycode_msg",error_msg);
					}
				}

				//AUDIT INFO
				ic.setTransientDatum("audit_info","true");

				//DELETE BUTTON
				if( not_pooled && not_posted && not_billed && not_exported && not_closed)
					ic.setTransientDatum("sl_delete","true");
				else if( !not_pooled && not_internal_req ) //case of allocated line, still want to be able to delete
					ic.setTransientDatum("sl_delete","true");
				else
					ic.setTransientDatum("sl_delete","false");
			}
			else //----------------------------THIS IS A NEW SERVICE_LINE-----------------------
			{
Diagnostics.trace("ServiceLineFieldHandler.handleEnvironment() New Line");

				if( ic.getParameter("service_line_date") == null )
				{//get date
					query = "SELECT getDate() cur_date";
					rs = conn.resultsQueryEx(query);
					if( rs.next() )
					{
						Date cur_date = rs.getDate("cur_date");
						ic.setTransientDatum("service_line_date", ic.format(cur_date,"date"));
					}
					rs.close();
				}
				//STATUSES
				if( billing )
					ic.setTransientDatum("status_id","4");

				String job_status_type_code = null;
				if( StringUtil.hasAValue(job_id) )
				{
					query = "SELECT job_status_type_code FROM jobs_v WHERE job_id = " + conn.toSQLString( job_id );
					rs = conn.resultsQueryEx(query);
					if( rs.next() )
						job_status_type_code = rs.getString("job_status_type_code");
					rs.close();
				}
				String serv_status_type_code = null;
				if( StringUtil.hasAValue(service_id) )
				{
					query = "SELECT l.code serv_status_type_code FROM services s, lookups l WHERE s.serv_status_type_id = l.lookup_id AND service_id = " + conn.toSQLString( service_id );
					rs = conn.resultsQueryEx(query);
					if( rs.next() )
						serv_status_type_code = rs.getString("serv_status_type_code");
					rs.close();
				}

				//JOB
				if( billing && !StringUtil.hasAValue(bill_job_id)) //set default job
					ic.setTransientDatum("bill_job_id",job_id);
				else if( !StringUtil.hasAValue(tc_job_id) )
					ic.setTransientDatum("tc_job_id", job_id);
				if( !(StringUtil.hasAValue(job_status_type_code) && job_status_type_code.equalsIgnoreCase("closed")) )
				{
					ic.setTransientDatum("sl_job","regular"); //indicates to show field and what css class to show
					ic.setTransientDatum("sl_job_r","false"); //indicates if field is readonly
				}
				else
				{
					ic.setTransientDatum("sl_job","readonly"); //indicates to show field and what css class to show
					ic.setTransientDatum("sl_job_r","true"); //indicates if field is readonly
					ic.setTransientDatum("sl_job_msg","<span class='MandatoryLabel'>(Closed)</span>");
					not_closed = false;
				}

				//SERVICE
				if( billing && !StringUtil.hasAValue(bill_service_id) ) //set default service
					ic.setTransientDatum("bill_service_id", service_id);
				else if( !StringUtil.hasAValue(tc_service_id) )
					ic.setTransientDatum("tc_service_id", service_id);
				if( !(StringUtil.hasAValue(serv_status_type_code) && serv_status_type_code.equalsIgnoreCase("closed")) && not_closed)
				{
					ic.setTransientDatum("sl_service","regular"); //indicates to show field and what css class to show
					ic.setTransientDatum("sl_service_r","false"); //indicates if field is readonly
				}
				else
				{
					ic.setTransientDatum("sl_service","readonly"); //indicates to show field and what css class to show
					ic.setTransientDatum("sl_service_r","true"); //indicates if field is readonly
					ic.setTransientDatum("sl_service_msg","<span class='MandatoryLabel'>(Closed)</span>");
					not_closed = false;
				}

				//SERVICE_LINE_NO
				ic.setTransientDatum("sl_no","readonly"); //indicates to show field and what css class to show
				ic.setTransientDatum("sl_no_r","true"); //indicates if field is readonly

				//SERVICE_LINE_STATUS
				ic.setTransientDatum("sl_status","readonly"); //indicates to show field and what css class to show
				ic.setTransientDatum("sl_status_r","true"); //indicates if field is readonly

				//SERVICE_LINE_DATE
				if (not_closed && RightsHelper.hasViewRight(ic, Constants.FUNCTION_TIME_MODIFY_DATE))
				{
					ic.setTransientDatum("sl_date","regular"); //indicates to show field and what css class to show
					ic.setTransientDatum("sl_date_r","false"); //indicates if field is readonly
				}
				else
				{
					ic.setTransientDatum("sl_date","readonly"); //indicates to show field and what css class to show
					ic.setTransientDatum("sl_date_r","true"); //indicates if field is readonly
				}

				//RESOURCE
				if( not_closed )
				{
					ic.setTransientDatum("sl_resource","regular"); //indicates to show field and what css class to show
					ic.setTransientDatum("sl_resource_r","false"); //indicates if field is readonly
				}
				else
				{
					ic.setTransientDatum("sl_resource","readonly"); //indicates to show field and what css class to show
					ic.setTransientDatum("sl_resource_r","true"); //indicates if field is readonly
				}


				//FIGURE OUT IF WE NEED TO DETERMINE RATE
			    if( StringUtil.hasAValue(item_id) && redisplaying &&
			    	(StringUtil.hasAValue(tc_job_id) || StringUtil.hasAValue(bill_job_id)) )
				{
					query = "SELECT TOP 1 RATE FROM JOB_ITEM_RATES WHERE ITEM_ID = " + conn.toSQLString(item_id);
					if( !billing && StringUtil.hasAValue(item_type_code) && item_type_code.equalsIgnoreCase("expense") )
					{
						query += " AND JOB_ID = " + conn.toSQLString(tc_job_id);
					}
					else if( billing )
					{
						query += " AND JOB_ID = " + conn.toSQLString(bill_job_id);
					}
					else
					{
						query += " AND JOB_ID = " + conn.toSQLString(tc_job_id);
					}
					rs = conn.resultsQueryEx(query);
					if( rs.next() )
					{
						if( StringUtil.hasAValue(item_type_code) && item_type_code.equalsIgnoreCase("expense") )
						{
							ic.setTransientDatum("tc_rate",rs.getString("rate"));
							ic.setTransientDatum("bill_rate",rs.getString("rate"));
						}
						else if( billing )
							ic.setTransientDatum("bill_rate",rs.getString("rate"));
						else
							ic.setTransientDatum("tc_rate",rs.getString("rate"));
					}
					else
						SmartFormHandler.addSmartFormError(ic, "Could not find rate for the selected item.  Double Check that rates are loaded for this Job.");
					rs.close();
				}

				//ITEM
				if( not_closed )
				{
					ic.setTransientDatum("sl_item","regular"); //indicates to show field and what css class to show
					ic.setTransientDatum("sl_item_r","false"); //indicates if field is readonly
				}
				else
				{
					ic.setTransientDatum("sl_item","readonly"); //indicates to show field and what css class to show
					ic.setTransientDatum("sl_item_r","true"); //indicates if field is readonly
				}

				//BILL_QTY
				if( billing )
				{
					if( not_closed )
					{
						ic.setTransientDatum("sl_bill_qty","regular"); //indicates to show field and what css class to show
						ic.setTransientDatum("sl_bill_qty_r","false"); //indicates if field is readonly
					}
					else
					{
						ic.setTransientDatum("sl_bill_qty","readonly"); //indicates to show field and what css class to show
						ic.setTransientDatum("sl_bill_qty_r","true"); //indicates if field is readonly
					}
				}
				//BILL_RATE
				if( billing || (StringUtil.hasAValue(item_type_code) && item_type_code.equalsIgnoreCase("expense") ) )
				{
					if( not_closed )
					{
						ic.setTransientDatum("sl_bill_rate","regular"); //indicates to show field and what css class to show
						ic.setTransientDatum("sl_bill_rate_r","false"); //indicates if field is readonly
					}
					else
					{
						ic.setTransientDatum("sl_bill_rate","readonly"); //indicates to show field and what css class to show
						ic.setTransientDatum("sl_bill_rate_r","true"); //indicates if field is readonly
					}
				}
				//TC_QTY & TC_RATE
				if( !billing )
				{// module most be "time"
					if( not_closed )
					{
						ic.setTransientDatum("sl_tc_qty","regular"); //indicates to show field and what css class to show
						ic.setTransientDatum("sl_tc_qty_r","false"); //indicates if field is readonly
						if( StringUtil.hasAValue(item_type_code) && item_type_code.equalsIgnoreCase("expense") )
						{
							ic.setTransientDatum("sl_tc_rate","regular"); //indicates to show field and what css class to show
							ic.setTransientDatum("sl_tc_rate_r","false"); //indicates if field is readonly
						}
					}
					else
					{
						ic.setTransientDatum("sl_tc_qty","readonly"); //indicates to show field and what css class to show
						ic.setTransientDatum("sl_tc_qty_r","true"); //indicates if field is readonly
						ic.setTransientDatum("sl_tc_rate","readonly"); //indicates to show field and what css class to show
						ic.setTransientDatum("sl_tc_rate_r","true"); //indicates if field is readonly
					}
				}

				//HOURLY PAY CODE
				if( !billing && StringUtil.hasAValue(item_type_code) && item_type_code.equalsIgnoreCase("hours") )
				{
					if( not_closed )
					{
						ic.setTransientDatum("sl_paycode","regular"); //indicates to show field and what css class to show
						ic.setTransientDatum("sl_paycode_r","false"); //indicates if field is readonly
					}
					else
					{
						ic.setTransientDatum("sl_paycode","readonly"); //indicates to show field and what css class to show
						ic.setTransientDatum("sl_paycode_r","true"); //indicates if field is readonly
					}
				}
			}
		}
		finally
		{
			if (conn != null) conn.release();
		}

		Diagnostics.error("not_exported = '"+not_exported+"'");
		Diagnostics.error("not_pooled = '"+not_pooled+"'");
		Diagnostics.error("not_billed = '"+not_billed+"'");
		Diagnostics.error("not_posted = '"+not_posted+"'");
		Diagnostics.error("not_closed = '"+not_closed+"'");
		Diagnostics.error("not_internal_req = '"+not_internal_req+"'");
		Diagnostics.error("redisplaying = '"+redisplaying+"'");
		Diagnostics.error("billing = '"+billing+"'");
		Diagnostics.debug2("ServiceLineFieldHandler.handleEnvironment() is returning " + result);

		return result;
	}


	public boolean setLevel(InvocationContext ic, ConnectionWrapper conn, String level)
	{
		Diagnostics.trace("ServiceLineFieldHandler.setLevel()");
		boolean result = true;

		if( !StringUtil.hasAValue(level) )
			level = ic.getParameter("level");
		if( StringUtil.hasAValue(level) )
		{
			if( level.equalsIgnoreCase("main") )
			{
				ic.removeSessionDatum("job_id");
				ic.removeSessionDatum("service_id");
				Diagnostics.debug("removing job_id and service_id from session because level is '" + level + "'");
			}
			else if( level.equalsIgnoreCase("job") )
			{
				ic.removeSessionDatum("service_id");
				Diagnostics.debug("removing job_id and service_id from session because level is '" + level + "'");
			}
			else if( level.equalsIgnoreCase("line") )
			{
				//do nothing
				Diagnostics.debug("not removing job_id and service_id from session because level is '" + level + "'");
			}
			else
			{
				Diagnostics.debug("not removing job_id and service_id from session because level is '" + level + "'");
			}
		}
		return result;
	}
}
