/*
 *                 Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.
 *
 * Copyright 2005, Dynamic Information Systems, LLC
 * $Header: C:\work\ims\src\ims\handlers\proj\PDSPreHandler.java, 58, 3/22/2006 6:09:31 PM, Blake Von Haden$
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL DYNAMIC INFORMATIONS SYTEMS, LLC
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
 * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 * ====================================================================
 */

package ims.handlers.proj;

import ims.helpers.IMSUtil;
import ims.helpers.MapUtil;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.intraframe.templates.components.SmartFormComponent;
import dynamic.util.date.StdDate;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * @version $Id: PDSPreHandler.java 1496 2009-02-07 00:59:49Z bvonhaden $
 */
public class PDSPreHandler extends BaseHandler
{
	private static final String REQUEST_TYPE_WOQ = "woq";
	private static final String REQUEST_TYPE_PF = "pf";
	private static final String REQUEST_TYPE_SR = "sr";
	private static final String REQUEST_TYPE_QR = "qr";
	private static final String REQUEST_TYPE_WO = "wo";

	private static final String FIELD_TYPE_SUFFIX_STRING =  "_strings";
	private static final String FIELD_TYPE_SUFFIX_INT =  "_ints";
	private static final String FIELD_TYPE_SUFFIX_EXTRA =  "_extra_data";
	private static final String FIELD_TYPE_SUFFIX_DATE =  "_dates";

	private static final String MANDATORY_FORM_ERROR_MESSAGE = "MANDATORY_FORM_ERROR_MESSAGE";
	private Map mandatoryFields = null;


	private static void setupRequiredFields(String requestTypeKey, Map fieldMap, String[] stringFields, String[] intFields, String[] dateFields, List<String> extraFields)
	{
		fieldMap.put(requestTypeKey + FIELD_TYPE_SUFFIX_STRING, stringFields);
		fieldMap.put(requestTypeKey + FIELD_TYPE_SUFFIX_INT, intFields);
		fieldMap.put(requestTypeKey + FIELD_TYPE_SUFFIX_DATE, dateFields);
		fieldMap.put(requestTypeKey + FIELD_TYPE_SUFFIX_EXTRA, extraFields);
	}

	private String[] getRequiredFields(String requestTypeKey, String fieldTypeKey)
	{
		return (String[]) mandatoryFields.get(requestTypeKey + fieldTypeKey);
	}


	private List getRequiredFieldList(String requestTypeKey, String fieldTypeKey)
	{
		return (List) mandatoryFields.get(requestTypeKey + fieldTypeKey);
	}
	public void setUpHandler()
	{
		Diagnostics.trace("PDSPreHandler.setUpHandler()");

		String[] requiredStringFields = null;
		String[] requiredIntFields = null;
		String[] requiredDateFields = null;
		List<String> extraFields = null;

		mandatoryFields = new HashMap();

		//************* Mandatory Project Folder fields  ******************

		requiredStringFields = new String[] {};
		requiredIntFields = new String[] { "project_type_id", "customer_id" };
		requiredDateFields = new String[] {};
		extraFields = new ArrayList<String>();

		setupRequiredFields(REQUEST_TYPE_PF, mandatoryFields, requiredStringFields, requiredIntFields, requiredDateFields, extraFields);




		//************* Mandatory Service Request fields  ******************

		requiredStringFields = new String[]{
				"dealer_po_no",
				"description",
				"furniture_type",
				"plan_location",
				"taxable_flag",
				"warehouse_loc"
			};

		requiredIntFields = new String[]{
				"customer_id",
				"dealer_po_line_no",
				"job_location_id",
				"customer_contact_id",
				"d_sales_rep_contact_id",
				"d_sales_sup_contact_id",
				"d_designer_contact_id",
				"a_m_contact_id",
				"delivery_type_id",
				"furn_plan_type_id",
				"furn_spec_type_id",
				"furniture_qty",
				"workstation_typical_type_id",
				"punchlist_item_type_id",
				"wall_mount_type_id",
				"schedule_type_id",
				"approval_req_type_id",
				"cost_to_cust_type_id",
				"cost_to_vend_type_id",
				"cost_to_job_type_id",
				"warehouse_fee_type_id",
				"dumpster_type_id",
				"staging_area_type_id",
				"new_site_type_id",
				"occupied_site_type_id",
				"prod_disp_id",
				"wood_product_type_id"
			};

		requiredDateFields = new String[]{
				"est_start_date",
				"est_end_date"
			};

		extraFields = new ArrayList<String>();
		extraFields.add("dock_reserv_req_type_id");
		extraFields.add("doorway_prot_type_id");
		extraFields.add("elevator_avail_type_id");
		extraFields.add("elevator_reserv_req_type_id");
		extraFields.add("floor_protection_type_id");
		extraFields.add("loading_dock_type_id");
		extraFields.add("quote_type_id");
		extraFields.add("semi_access_type_id");
		extraFields.add("stair_carry_type_id");
		extraFields.add("wall_protection_type_id");

		setupRequiredFields(REQUEST_TYPE_SR, mandatoryFields, requiredStringFields, requiredIntFields, requiredDateFields, extraFields);



		//********** Mandatory Quote Request fields  ******************

		requiredStringFields =  new String[]{
				"description",
				"furniture_type",
				"taxable_flag"
			};

		requiredIntFields = new String[]{
				"customer_id",
				"job_location_id",
				"quote_type_id",
				"customer_contact_id",
				"d_sales_rep_contact_id",
				"d_sales_sup_contact_id",
				"a_m_contact_id",
				"delivery_type_id",
				"furn_plan_type_id",
				"furn_spec_type_id",
				"furniture_qty",
				"workstation_typical_type_id",
				"punchlist_item_type_id",
				"wall_mount_type_id",
				"regular_hours_type_id",
				"evening_hours_type_id",
				"weekend_hours_type_id",
				"union_labor_req_type_id",
				"duration_time_uom_type_id",
				"duration_qty",
				"phased_install_type_id",
				"dumpster_type_id",
				"new_site_type_id",
				"occupied_site_type_id",
				"prod_disp_id",
				"staging_area_type_id"
			};

		requiredDateFields = new String[]{
			"quote_needed_by",
		};

		extraFields = new ArrayList<String>();
		extraFields.add("loading_dock_type_id");
		extraFields.add("semi_access_type_id");
		extraFields.add("elevator_avail_type_id");
		extraFields.add("stair_carry_type_id");

		setupRequiredFields(REQUEST_TYPE_QR, mandatoryFields, requiredStringFields, requiredIntFields, requiredDateFields, extraFields);


		//********** Mandatory Workorder fields (need to update Workorder Quote Too ******************


		requiredStringFields = new String[]{
				"customer_po_no",
				"description",
				"taxable_flag"
			};

		requiredIntFields = new String[]{
				"customer_id",
				"project_id",
				"customer_contact_id",
				"job_location_id",
				"furniture1_contact_id",
				"activity_type_id1",
				"qty1",
				"activity_cat_type_id1",
				"priority_type_id",
				"approver_contact_id"
			};

		requiredDateFields = new String[]{
				"est_start_date",
				"work_order_received_date"
		};

		extraFields = new ArrayList<String>();
		mandatoryFields.put("wo_extra_data", extraFields);

		setupRequiredFields(REQUEST_TYPE_WO, mandatoryFields, requiredStringFields, requiredIntFields, requiredDateFields, extraFields);


		//********** Mandatory Workorder Quote fields (need to update WorkOrder Too ******************


		requiredStringFields  = new String[]{
				"description",
				"taxable_flag"
			};

		requiredIntFields = new String[]{
				"customer_id",
				"project_id",
				"customer_contact_id",
				"job_location_id",
				"furniture1_contact_id",
				"a_m_contact_id",
				"activity_type_id1",
				"qty1",
				"activity_cat_type_id1",
				"priority_type_id",
				"quote_type_id",
				"delivery_type_id",
				"furn_plan_type_id",
				"furn_spec_type_id",
				"workstation_typical_type_id",
				"regular_hours_type_id",
				"evening_hours_type_id",
				"weekend_hours_type_id",
				"union_labor_req_type_id",
				"duration_time_uom_type_id",
				"duration_qty",
				"phased_install_type_id",
				"d_sales_rep_contact_id",
				"d_sales_sup_contact_id"
			};

		requiredDateFields = new String[]{
			"quote_needed_by"
		};

		extraFields = new ArrayList<String>();

		setupRequiredFields(REQUEST_TYPE_WOQ, mandatoryFields, requiredStringFields, requiredIntFields, requiredDateFields, extraFields);

	}

	public void destroy()
	{
		Diagnostics.trace("PDSPreHandler.destroy()");
	}

	public String getProjectID(InvocationContext ic)
	{
		// only use the project id stored in the session if the parameter is
		// omitted
		String result = (String) ic.getParameter("project_id");
		if (!StringUtil.hasAValue(result))
		{
			result = (String) ic.getSessionDatum("project_id");
		}
		else
		{
			ic.setSessionDatum("project_id", result);

		}
		return result;

	}

	/**
	 * Handle Environment for Projects and Requests of the Extranet
	 */

	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		Diagnostics.trace("PDSPreHandler.HandleEnvironment()");
		boolean success = true;

		ConnectionWrapper conn = (ConnectionWrapper) ic.getTransientDatum(SmartFormHandler.CONNECTION);

		String button = ic.getParameter("req_button");
		String mode = ic.getRequiredParameter("mode");
		String request_type_code = ic.getParameter("request_type_code");
		String quoting = (String) ic.getSessionDatum("quoting");

		// 04/01/04 GC
		// only use the project id stored in the session if the parameter is
		// omitted
		String projectId = getProjectID(ic);
		ic.setSessionDatum("project_id", projectId);

		String request_id = ic.getParameter("request_id");
		boolean created_project = false;

		Diagnostics.error("button='" + button + "' mode='" + mode + "' request_type_code='" + request_type_code + "' quoting='" + quoting + "'");

		if (StringUtil.hasAValue(button))
		{
			//case no project (FYI: workorders have projects)
			String description = ic.getParameter("description");
			if (description != null)
				ic.setParameter("description", StringUtil.toUpperCase(description));

			if (button.equalsIgnoreCase("Save") && StringUtil.hasAValue(request_type_code) && request_type_code.equalsIgnoreCase("project_folder"))
			{
				success = sendRequest(ic, conn, REQUEST_TYPE_PF);
			}

			//case no request
			if ((button.equalsIgnoreCase("Save") || button.equalsIgnoreCase("Send") || button.equalsIgnoreCase("Approve") || button.equalsIgnoreCase("Refuse"))
					&& mode.equals(SmartFormComponent.Insert))
			{//inserting new request
				if (success && !StringUtil.hasAValue(projectId))
				{
					if (!request_type_code.equalsIgnoreCase("workorder"))
					{
						Diagnostics.debug2("creating new project ='" + projectId + "'");
						success = created_project = createProject(ic, conn);
					}
					else if (button.equalsIgnoreCase("Save"))
					{//special case when there is no project_id and saving,
					 // must have project_id
						ic.setTransientDatum("err", "True");
						ic.setTransientDatum("err@project_id", "This is a required field.  Please enter it before continuing.");
						SmartFormHandler.addSmartFormError(ic, "At least one mandatory field was not filled in:");
						success = false;
					}
				}

				//now create the actual request if id doesn't exist
				if (success && !StringUtil.hasAValue(request_id))
				{
					Diagnostics.debug("Creating new request of type: '" + request_type_code + "'");
					success = createRequest(ic, conn, request_type_code);
				}
			}

			//case have project and request so handle buttons
			if (success)
			{
				if (button.equalsIgnoreCase("archive"))
				{
					success = archive(ic, conn, request_type_code, request_id);
				}
				else if (button.equalsIgnoreCase("archive_project"))
				{
					success = archiveProject(ic, conn);
				}
				else
				{
					//check if new version
					int current_status_seq_no = Integer.parseInt(conn.queryEx("SELECT isnull(sequence_no,0) FROM lookups WHERE lookup_id = "
							+ conn.toSQLString(ic.getParameter("request_status_type_id"))));
					int sent_status_seq_no = 9999; //just a high number higher
												   // then all other statuses
					if (request_type_code.equalsIgnoreCase("workorder"))
						sent_status_seq_no = Integer.parseInt(conn.queryEx("SELECT sequence_no FROM workorder_status_types_v WHERE lookup_code = 'Approved'"));
					else if (request_type_code.equalsIgnoreCase("service_request"))
						sent_status_seq_no = Integer.parseInt(conn.queryEx("SELECT sequence_no FROM serv_req_status_types_v WHERE lookup_code = 'Sent'"));
					else if (request_type_code.equalsIgnoreCase("quote_request"))
						sent_status_seq_no = Integer.parseInt(conn.queryEx("SELECT sequence_no FROM quote_req_status_types_v WHERE lookup_code = 'Sent'"));
					if (current_status_seq_no >= sent_status_seq_no && mode.equalsIgnoreCase(SmartFormComponent.Update)
							&& (button.equalsIgnoreCase("Save") || button.equalsIgnoreCase("Send") || button.equalsIgnoreCase("Approve")))
					{//most be in update mode, most have status >= approved and
					 // action must be saving, sending, or approving.
						success = createNewVersion(ic, conn);
					}

					if (success && StringUtil.hasAValue(request_type_code)
							&& (button.equalsIgnoreCase("Send") || button.equalsIgnoreCase("Refuse") || button.equalsIgnoreCase("Approve")))
					{
						Diagnostics.debug2(button + "'ing workorder, service, or quote request, or a quote.");
						if (request_type_code.equalsIgnoreCase("workorder"))
						{
							//special case, load the customer custom columns
							// that are mandatory for validation

							if (StringUtil.hasAValue(quoting) && quoting.equalsIgnoreCase("true"))
							{
								success = sendRequest(ic, conn, REQUEST_TYPE_WOQ);
							}
							else
							{
								success = sendRequest(ic, conn, REQUEST_TYPE_WO);
							}
						}
						else if (request_type_code.equalsIgnoreCase("quote_request"))
						{
							success = sendRequest(ic, conn, REQUEST_TYPE_QR);
						}
						else if (request_type_code.equalsIgnoreCase("service_request"))
						{
							success = sendRequest(ic, conn, REQUEST_TYPE_SR);
						}
						ic.setTransientDatum("button", "Save"); //to be used by
																// SmartForm to
																// save record
					}
				}
			}
		}

		if (created_project && !success)
		{
			//created project, but failed to create request, so remove
			// project_id from session data
			ic.removeSessionDatum("project_id");
			ic.removeParameter("project_id");
		}

		Diagnostics.trace("PDSPreHandler success='" + success + "'");
		return success;
	}

	public boolean createProject(InvocationContext ic, ConnectionWrapper conn) throws Exception
	{
		Diagnostics.trace("PDSPreHandler.createProject()");
		boolean result = false;
		String project_type_id = ic.getParameter("project_type_id");

		if (StringUtil.hasAValue(project_type_id))
			result = insertProject(project_type_id, ic, conn);
		else
		{
			SmartFormHandler.addSmartFormError(ic, "At least one mandatory field was not entered: Project Type");
		}
		return result;
	}

	public boolean insertProject(String project_type_id, InvocationContext ic, ConnectionWrapper conn) throws Exception
	{
		boolean bRet = false;

		String project_no = ic.getParameter("project_no");
		String customer_id = ic.getParameter("customer_id");
		String job_name = StringUtil.toUpperCase(ic.getParameter("job_name"));

		//determine project#
		if (StringUtil.hasAValue(project_no))
		{//has job_no, so validate job_no, search for duplicates, and update
		 // quote if necessary
			bRet = IMSUtil.validateJobNo(ic, conn, project_no, true);
		}
		else
		{//missing job, autogenerate job_no, implicitely there is no quote if
		 // job_no is blank
			project_no = IMSUtil.generateJobNo(ic, conn);
		}

		//get new projects status
		Map<String, String> project_statuses = MapUtil.getTypeMap(conn, "project_status_type");
		String project_status_type_id = (String) project_statuses.get("folder_created");

		String created_by = (String) ic.getRequiredSessionDatum("user_id");

		StringBuffer query = new StringBuffer();
		query.append("INSERT INTO projects(project_no, project_type_id, project_status_type_id, customer_id, job_name, date_created, created_by) ");
		query.append("VALUES (").append(conn.toSQLString(project_no));
		query.append(", " + conn.toSQLString(project_type_id));
		query.append(", " + conn.toSQLString(project_status_type_id));
		query.append(", " + conn.toSQLString(customer_id));
		query.append(", " + conn.toSQLString(job_name));
		query.append(", getDate()");
		query.append(", " + conn.toSQLString(created_by));
		query.append(")");

		int rows = conn.updateEx(query, true);	// force a commit so the project is around for retries.
		if (rows != 1)
		{
			Diagnostics.error("Failed to create project.");
			SmartFormHandler.addSmartFormError(ic, "Exception in JobPreHandler, failed to create Project record.");
			bRet = false;
		}
		else
		{//retrieve new project_id
			QueryResults rs = conn.select("SELECT @@IDENTITY");
			if (rs.next())
			{
				String projectId = rs.getString(1); 
				Diagnostics.debug3("New project_id = '" + projectId + "'");
				ic.setSessionDatum("project_id", projectId); //need for application
				ic.setParameter("project_id", projectId); //need for smartform to save request
				bRet = true;
			}
			else
			{
				Diagnostics.error("Failed to retrieve new project_id, no rows returned from query.");
				SmartFormHandler.addSmartFormError(ic, "Exception in PDSPreHandler, failed to create Project record.");
			}
			rs.close();
		}

		return bRet;
	}

	public boolean createRequest(InvocationContext ic, ConnectionWrapper conn, String request_type_code) throws Exception
	{
		Diagnostics.trace("PDSPreHandler.createRequest()");
		boolean bRet = false;
		String request_no = ic.getParameter("request_no");

		// 04/01/04 GC
		// only use the project id stored in the session if the parameter is
		// omitted
		String project_id = getProjectID(ic);

		if (StringUtil.hasAValue(request_type_code) && StringUtil.hasAValue(project_id))
		{
			//determine request_no (might have one because when coverting from
			// quote_request to service request, need to keep same number.
			if (!StringUtil.hasAValue(request_no))
			{
				int newRequestNo = getNewRequestNo(conn, project_id);
				if (newRequestNo <= 0)
				{
					newRequestNo = 1;
					Diagnostics.debug3("Could not find next request_no (if Requesting Service, that is expected) defaulting to 1.");
				}
				request_no = Integer.toString(newRequestNo);

			}

			//set version_number to 1 since first version
			ic.setParameter("version_no", "1");

			//determine request_type_id to determine status_type
			Map<String, String> request_types = MapUtil.getTypeMap(conn, "request_type");
			String request_type_id = null;
			request_type_id = (String) request_types.get(request_type_code);

			//used for request_status_type_id
			Map<String, String> request_statuses = null;
			String request_status_type_id = null;

			//Determine request_status_type_id
			if (request_type_code.equalsIgnoreCase("project_folder"))
			{
				request_statuses = MapUtil.getTypeMap(conn, "project_status_type");
				request_status_type_id = (String) request_statuses.get("folder_created");
			}
			else if (request_type_code.equalsIgnoreCase("service_request"))
			{
				request_statuses = MapUtil.getTypeMap(conn, "serv_req_status_type");
				request_status_type_id = (String) request_statuses.get("created");
			}
			else if (request_type_code.equalsIgnoreCase("quote_request"))
			{
				request_statuses = MapUtil.getTypeMap(conn, "quote_req_status_type");
				request_status_type_id = (String) request_statuses.get("created");
			}
			else if (request_type_code.equalsIgnoreCase("workorder"))
			{
				request_statuses = MapUtil.getTypeMap(conn, "workorder_status_type");
				request_status_type_id = (String) request_statuses.get("created");
			}
			else
				Diagnostics.error("PDSPreHandler.createRequest() Unknown request_type_code '" + request_type_code + "'");

			//all done, SmartForm will take it from here.
			if (StringUtil.hasAValue(request_no) && StringUtil.hasAValue(request_type_id) && StringUtil.hasAValue(request_status_type_id))
			{//success
				ic.setParameter("request_no", request_no);
				ic.setParameter("request_type_id", request_type_id);
				ic.setParameter("request_status_type_id", request_status_type_id);
				bRet = true;
			}
			else
				Diagnostics.error("Failed to create one of the following: request_no='" + request_no + "' request_type_id='" + request_type_id
						+ "' request_status_type_id='" + request_status_type_id + "'");

			Diagnostics.debug2("Details for creating Request: request_no='" + request_no + "' request_type_id='" + request_type_id
					+ "' request_status_type_id='" + request_status_type_id + "'");

		}
		else
			Diagnostics.error("missing parameter: request_type_code '" + request_type_code + "' or project_id '" + project_id + "'");

		return bRet;
	}

	/**
	 * Current handles Service Requests "sr" and Quote Requests "qr" and
	 * Workorders "wo"
	 */

	private boolean sendRequest(InvocationContext ic, ConnectionWrapper conn, String request_type) throws Exception
	{
		Diagnostics.trace("PDSPreHandler.sendRequest()");
		boolean result = true;
		boolean is_valid = true;

		result = checkRequiredDateFields(ic, request_type);
		if (!result)
			is_valid = false;

		result = checkRequiredIntFields(ic, request_type);
		if (!result)
			is_valid = false;

		result = checkRequiredStringFields(ic, request_type);
		if (!result)
			is_valid = false;

		result = checkRequiredExtraFields(ic, request_type);
		if (!result)
			is_valid = false;

		result = checkRequiredTempFields(ic, conn, request_type);
		if (!result)
			is_valid = false;

		if (request_type.equalsIgnoreCase(REQUEST_TYPE_SR))
		{
			result = checkJobLocation(ic, conn);
			if (!result)
				is_valid = false;
		}


		if (!is_valid)
		{//validation failed
			SmartFormHandler.addSmartFormError(ic, "At least one mandatory field was not filled in:");
			if (request_type.equalsIgnoreCase(REQUEST_TYPE_PF))
				SmartFormHandler.addSmartFormError(ic, "Please ensure you have selected a customer and filled in all mandatory fields.");
			SmartFormHandler.addSmartFormError(ic, (String)ic.getTransientDatum(MANDATORY_FORM_ERROR_MESSAGE));
		}
		else
		{//success so change status and indicate it is sent

			if (request_type.equalsIgnoreCase(REQUEST_TYPE_PF))
			{
				//do nothing
			}
			else if (request_type.equalsIgnoreCase(REQUEST_TYPE_SR))
			{
				Map<String, String> statuses = MapUtil.getTypeMap(conn, "serv_req_status_type");
				ic.setParameter("request_status_type_id", (String) statuses.get("sent"));
				ic.setParameter("is_sent", "Y");
				ic.setParameter("is_sent_date", conn.now());
			}
			else if (request_type.equalsIgnoreCase(REQUEST_TYPE_QR))
			{
				Map<String, String> statuses = MapUtil.getTypeMap(conn, "quote_req_status_type");
				ic.setParameter("request_status_type_id", (String) statuses.get("sent"));
				ic.setParameter("is_sent", "Y");
				ic.setParameter("is_sent_date", conn.now());
			}
			else if (request_type.equalsIgnoreCase(REQUEST_TYPE_WO) || request_type.equalsIgnoreCase(REQUEST_TYPE_WOQ))
			{
				Map<String, String> statuses = MapUtil.getTypeMap(conn, "workorder_status_type");
				String quoting = (String) ic.getSessionDatum("quoting");
				String is_quoted = ic.getParameter("is_quoted");
				String button = ic.getParameter("req_button");

				if (StringUtil.hasAValue(button))
				{//figure out the work order status

					if (button.equalsIgnoreCase("send"))
					{//sending so must not be the approver
						ic.setParameter("request_status_type_id", (String) statuses.get("unapproved"));
						ic.setParameter("request_status_type_code", "unapproved"); //used
																				   // in
																				   // PDSPostHandler
						ic.setParameter("is_sent", "N");
						ic.setParameter("is_sent_date", null);
					}
					else if (button.equalsIgnoreCase("refuse"))
					{//refusing
						ic.setParameter("request_status_type_id", (String) statuses.get("refused"));
						ic.setParameter("request_status_type_code", "refused"); //used
																				// in
																				// PDSPostHandler
						ic.setParameter("is_sent", "N");
						ic.setParameter("is_sent_date", null);
					}
					else if (StringUtil.hasAValue(quoting) && quoting.equalsIgnoreCase("true"))
					{//if quoting, need to set status to needs_quote

						if (StringUtil.hasAValue(is_quoted) && is_quoted.equalsIgnoreCase("Y"))
						{//if already quoted, need to set status to approved
							ic.setParameter("request_status_type_id", (String) statuses.get("approved"));
							ic.setParameter("request_status_type_code", "approved"); //used
																					 // in
																					 // PDSPostHandler
							ic.setParameter("is_sent", "Y");
							ic.setParameter("is_sent_date", conn.now());
						}
						else
						{//does not have a quote as yet leave, set status to
						 // needs_quote
							ic.setParameter("request_status_type_id", (String) statuses.get("needs_quote"));
							ic.setParameter("request_status_type_code", "needs_quote"); //used
																						// in
																						// PDSPostHandler
							ic.setParameter("is_sent", "N");
							ic.setParameter("is_sent_date", null);
						}
					}
					else if (button.equalsIgnoreCase("approve"))
					{//approving

						ic.setParameter("request_status_type_id", (String) statuses.get("approved"));
						ic.setParameter("request_status_type_code", "approved"); //used
																				 // in
																				 // PDSPostHandler
						ic.setParameter("is_sent", "Y");
						ic.setParameter("is_sent_date", conn.now());
					}
				}
				Diagnostics.debug("setting request_status_type_code to '" + ic.getParameter("request_status_type_code") + "'");
			}
			else
				Diagnostics.error("PDSPreHandler.sendRequest() Unknown request_type '" + request_type + "'");
		}
		return is_valid;
	}

	private boolean checkJobLocation(InvocationContext ic, ConnectionWrapper conn) throws SQLException
	{
		String jobLocationId = ic.getParameter("job_location_id");
		String state = conn.selectFirst("SELECT state FROM job_locations WHERE job_location_id = ?", jobLocationId);

		boolean result = true;
		if (!StringUtil.hasAValue(state))
		{
			ic.setTransientDatum("err", "True");
			String message = "The Job Location must have a State specified.  Please edit the job location and supply the State before continuing.";
			ic.setTransientDatum("err@job_location_id", message);
			addMandatoryMessage(ic, message);
			result = false;
		}

		return result;
	}

	public static void addMandatoryMessage(InvocationContext ic, String newMessage)
	{
		if (newMessage == null)
		{
			return;
		}
		String currentMessage = (String)ic.getTransientDatum(MANDATORY_FORM_ERROR_MESSAGE);
		if (currentMessage == null)
		{
			currentMessage = newMessage + "<br>\n";
		}
		else
		{
			currentMessage = currentMessage + newMessage + "<br>\n";
		}
		ic.setTransientDatum(MANDATORY_FORM_ERROR_MESSAGE, currentMessage);
	}


	private boolean checkRequiredStringFields(InvocationContext ic, String hash_key)
	{
		Diagnostics.trace("PDSPreHandler.checkRequiredStringField()");
		boolean bRet = true;
		String val = null;
		String param = null;
		String[] requiredStringFields = getRequiredFields(hash_key, FIELD_TYPE_SUFFIX_STRING);

		for (int i = 0; i < requiredStringFields.length; i++)
		{
			param = requiredStringFields[i];
			val = ic.getParameter(param);
			if (!StringUtil.hasAValue(val))
			{
				Diagnostics.warning("Mandatory string field " + param + " is not present");
				ic.setTransientDatum("err", "True");
				ic.setTransientDatum("err@" + param, "This is a required field.  Please enter it before continuing.");
				bRet = false;
			}
		}

		return bRet;
	}

	private boolean checkRequiredIntFields(InvocationContext ic, String hash_key)
	{
		Diagnostics.trace("PDSPreHandler.checkRequiredIntField()");
		boolean bRet = true;
		String val = null;
		String param = null;
		String[] requiredIntFields = getRequiredFields(hash_key, FIELD_TYPE_SUFFIX_INT);

		for (int i = 0; i < requiredIntFields.length; i++)
		{
			param = requiredIntFields[i];
			val = ic.getParameter(param);
			if (!StringUtil.hasAValue(val))
			{
				Diagnostics.warning("Mandatory integer field " + param + " is not present");
				ic.setTransientDatum("err", "True");
				ic.setTransientDatum("err@" + param, "This is a required field.  Please enter it before continuing.");
				bRet = false;
			}

			try
			{
				Integer.parseInt(val);
			}
			catch (NumberFormatException e)
			{
				Diagnostics.warning("Mandatory integer field " + param + " could not be parsed, value is " + val);
				ic.setTransientDatum("err", "True");
				ic.setTransientDatum("err@" + param, "This is a required field.  Please enter it before continuing.");
			}
		}

		return bRet;
	}

	private boolean checkRequiredExtraFields(InvocationContext ic, String hash_key)
	{
		Diagnostics.trace("PDSPreHandler.checkRequiredExtraFields()");
		boolean bRet = true;
		String val = null;

		List<String> requiredExtraFields = getRequiredFieldList(hash_key, FIELD_TYPE_SUFFIX_EXTRA);
		for (String param: requiredExtraFields)
		{
			val = ic.getParameter(param);
			if (!StringUtil.hasAValue(val))
			{
				Diagnostics.warning("Mandatory field " + param + " is not present");
				ic.setTransientDatum("err", "True");
				ic.setTransientDatum("err@" + param, "This is a required field.  Please enter it before continuing.");
				bRet = false;
			}
		}

		return bRet;
	}


	private boolean checkRequiredTempFields(InvocationContext ic, ConnectionWrapper conn, String hash_key) throws Exception
	{
		Diagnostics.trace("PDSPreHandler.checkRequiredTempFields()");
		boolean bRet = true;
		String val = null;
		String customer_id = ic.getParameter("customer_id");
		if (hash_key.equals(REQUEST_TYPE_WO) || hash_key.equals(REQUEST_TYPE_WOQ))
		{
			List<String> requiredTempFields = addCustomFieldValidation(conn, customer_id);

			for (String param: requiredTempFields)
			{
				val = ic.getParameter(param);
				if (!StringUtil.hasAValue(val))
				{
					Diagnostics.warning("Mandatory field " + param + " is not present");
					ic.setTransientDatum("err", "True");
					ic.setTransientDatum("err@" + param, "This is a required field.  Please enter it before continuing.");
					bRet = false;
				}
			}
		}
		return bRet;
	}

	private boolean checkRequiredDateFields(InvocationContext ic, String hash_key)
	{
		Diagnostics.trace("PDSPreHandler.checkRequiredDateField()");
		boolean bRet = true;
		String val = null;
		String param = null;
		String[] requiredDateFields = getRequiredFields(hash_key, FIELD_TYPE_SUFFIX_DATE);

		try
		{

			for (int i = 0; i < requiredDateFields.length; i++)
			{
				param = requiredDateFields[i];
				val = ic.getParameter(param);
				if (!StringUtil.hasAValue(val))
				{
					Diagnostics.warning("Mandatory date field " + param + " is not present");
					ic.setTransientDatum("err", "True");
					ic.setTransientDatum("err@" + param, "This is a required field.  Please enter it before continuing.");
					bRet = false;
				}

				new StdDate(val);
			}

			if (bRet && hash_key.equalsIgnoreCase(REQUEST_TYPE_SR))
			{
				String est_start_date = ic.getParameter("est_start_date");
				String est_end_date = ic.getParameter("est_end_date");
				if (StringUtil.hasAValue(est_start_date) && StringUtil.hasAValue(est_end_date))
				{
					StdDate start_date = new StdDate(est_start_date);
					StdDate end_date = new StdDate(est_end_date);
					if (start_date.after(end_date))
					{//user defined error, start_date > end_date not allowed.
						bRet = false;
						SmartFormHandler.addSmartFormError(ic, "Start Date is after End Date, please ensure Start Date is before End Date.");
						ic.setTransientDatum("err@est_start_date", "false");
						ic.setTransientDatum("err@est_end_date", "false");
					}
				}
			}
		}
		catch (ParseException e)
		{
			Diagnostics.warning("Mandatory date field " + param + " could not be parsed, value is " + val);
			ic.setTransientDatum("err", "True");
			ic.setTransientDatum("err@" + param, "This is a required field.  Please enter it before continuing.");
			bRet = false;
		}
		return bRet;
	}

	private boolean archiveProject(InvocationContext ic, ConnectionWrapper conn) throws Exception
	{
		Diagnostics.trace("PDSPreHandler.archiveProject()");
		boolean success = true;
		boolean result = false;

		//handle project
		String project_id = (String) ic.getSessionDatum("project_id");
		success = archive(ic, conn, "project", project_id);

		//handle requests and quotes
		if (success)
		{
			String query = "SELECT record_type_code, record_id FROM projects_all_requests_v WHERE project_id = ?";
			QueryResults rs = conn.select(query, project_id);
			while (rs.next())
			{//found, that means we were converting a project_folder request to
			 // another request
				result = archive(ic, conn, rs.getString(1), rs.getString(2));
				if (!result)
				{
					success = false;
					break;
				}
			}
			rs.close();
		}

		if (!success)
		{
			Diagnostics.error("Failed to archive project_id '" + project_id + "'");
			SmartFormHandler.addSmartFormError(ic, "Error in JobPreHandler, failed to archive Project Folder.  Please notify your System Admin.");
		}
		else
			Diagnostics.debug2("Successfully archived project_id '" + project_id + "' and all its requests.");

		return success;
	}

	/**
	 * String record_id is the request_id, quote_id, or project_id if archiving
	 * project.
	 */
	public static boolean archive(InvocationContext ic, ConnectionWrapper conn, String recordTypeCode, String recordId) throws Exception
	{
		Diagnostics.trace("PDSPreHandler.archive()");
		boolean bRet = false;

		String table = null; //used in query
		String id_field = null; //used in query
		String status_field = null;//used in query
		Map<String, String> statuses = null; //used in query
		String status_code = null; //used for diagnostics

		String userId = (String) ic.getRequiredSessionDatum("user_id");

		//change status of project or request
		if (recordTypeCode.equalsIgnoreCase("workorder"))
		{
			table = "requests";
			id_field = "request_id";
			status_field = "request_status_type_id";
			status_code = "closed";
			statuses = MapUtil.getTypeMap(conn, "workorder_status_type");
		}
		else if (recordTypeCode.equalsIgnoreCase("project"))
		{
			table = "projects";
			id_field = "project_id";
			status_field = "project_status_type_id";
			status_code = "folder_closed";
			statuses = MapUtil.getTypeMap(conn, "project_status_type");
		}
		else if (recordTypeCode.equalsIgnoreCase("project_folder"))
		{
			table = "requests";
			id_field = "request_id";
			status_field = "request_status_type_id";
			status_code = "folder_closed";
			statuses = MapUtil.getTypeMap(conn, "project_status_type");
		}
		else if (recordTypeCode.equalsIgnoreCase("quote_request"))
		{
			table = "requests";
			id_field = "request_id";
			status_field = "request_status_type_id";
			status_code = "closed";
			statuses = MapUtil.getTypeMap(conn, "quote_req_status_type");
		}
		else if (recordTypeCode.equalsIgnoreCase("service_request"))
		{
			table = "requests";
			id_field = "request_id";
			status_field = "request_status_type_id";
			status_code = "closed";
			statuses = MapUtil.getTypeMap(conn, "serv_req_status_type");
		}
		else if (recordTypeCode.equalsIgnoreCase("quote"))
		{
			table = "quotes";
			id_field = "quote_id";
			status_field = "quote_status_type_id";
			status_code = "closed";
			statuses = MapUtil.getTypeMap(conn, "quote_status_type");
		} else if ("job".equals(recordTypeCode)) {
			table = "jobs";
			id_field = "job_id";
			status_field = "job_status_type_id";
			status_code = "closed";
			statuses = MapUtil.getTypeMap(conn, "job_status_type");
		}

		if (StringUtil.hasAValue(table))
		{
			//to be used on the form when the form redisplays
			String status_type_id = (String) statuses.get(status_code);
			//ic.setParameter(status_field, status_type_id);

			StringBuffer query = new StringBuffer();
			query.append("UPDATE ").append(table);
			query.append(" SET ").append(status_field).append(" = ").append(conn.toSQLString(status_type_id));
			query.append(", modified_by = ").append(userId).append(", date_modified = getdate()");
			query.append(" WHERE ").append(id_field).append(" = ").append(conn.toSQLString(recordId));

			int rows = conn.updateEx(query);
			if (rows == 1)
			{//found, that means we were converting a project_folder request to
			 // another request
				Diagnostics.debug("Found and updated the '" + table + "' table's '" + status_field + "' to status_type_code='" + status_code + "' where ID = '"
						+ recordId + "'");
				bRet = true;
			}
			else
			{
				Diagnostics.error("Failed to update the '" + table + "' table's '" + status_field + "' to status_type_code='" + status_code + "'");
			}
		}
		return bRet;
	}


	/**
	 * String record_id is the request_id, quote_id, or project_id if archiving
	 * project.
	 */
	public static boolean unarchive(InvocationContext ic, ConnectionWrapper conn, String recordTypeCode, String recordId) throws Exception
	{
		Diagnostics.trace("PDSPreHandler.archive()");
		boolean bRet = false;

		String table = null; //used in query
		String id_field = null; //used in query
		String status_field = null;//used in query
		Map<String, String> statuses = null; //used in query
		String status_code = null; //used for diagnostics

		String userId = (String) ic.getRequiredSessionDatum("user_id");

		//change status of project or request
		if (recordTypeCode.equalsIgnoreCase("workorder"))
		{
			table = "requests";
			id_field = "request_id";
			status_field = "request_status_type_id";
			status_code = "created";
			statuses = MapUtil.getTypeMap(conn, "workorder_status_type");
		}
		else if (recordTypeCode.equalsIgnoreCase("project"))
		{
			table = "projects";
			id_field = "project_id";
			status_field = "project_status_type_id";
			status_code = "folder_created";
			statuses = MapUtil.getTypeMap(conn, "project_status_type");
		}
		else if (recordTypeCode.equalsIgnoreCase("project_folder"))
		{
			table = "requests";
			id_field = "request_id";
			status_field = "request_status_type_id";
			status_code = "folder_created";
			statuses = MapUtil.getTypeMap(conn, "project_status_type");
		}
		else if (recordTypeCode.equalsIgnoreCase("quote_request"))
		{
			table = "requests";
			id_field = "request_id";
			status_field = "request_status_type_id";
			status_code = "created";
			statuses = MapUtil.getTypeMap(conn, "quote_req_status_type");
		}
		else if (recordTypeCode.equalsIgnoreCase("service_request"))
		{
			table = "requests";
			id_field = "request_id";
			status_field = "request_status_type_id";
			status_code = "created";
			statuses = MapUtil.getTypeMap(conn, "serv_req_status_type");
		}
		else if (recordTypeCode.equalsIgnoreCase("quote"))
		{
			table = "quotes";
			id_field = "quote_id";
			status_field = "quote_status_type_id";
			status_code = "created";
			statuses = MapUtil.getTypeMap(conn, "quote_status_type");
		}
		else if ("job".equals(recordTypeCode))
		{
			table = "jobs";
			id_field = "job_id";
			status_field = "job_status_type_id";
			status_code = "created";
			statuses = MapUtil.getTypeMap(conn, "job_status_type");
		}

		if (StringUtil.hasAValue(table))
		{
			//to be used on the form when the form redisplays
			String status_type_id = (String) statuses.get(status_code);
			//ic.setParameter(status_field, status_type_id);

			StringBuffer query = new StringBuffer();
			query.append("UPDATE ").append(table);
			query.append(" SET ").append(status_field).append(" = ").append(conn.toSQLString(status_type_id));
			query.append(", modified_by = ").append(userId).append(", date_modified = getdate()");
			query.append(" WHERE ").append(id_field).append(" = ").append(conn.toSQLString(recordId));

			int rows = conn.updateEx(query);
			if (rows == 1)
			{//found, that means we were converting a project_folder request to
			 // another request
				Diagnostics.debug("Found and updated the '" + table + "' table's '" + status_field + "' to status_type_code='" + status_code + "' where ID = '"
						+ recordId + "'");
				bRet = true;
			}
			else
			{
				Diagnostics.error("Failed to update the '" + table + "' table's '" + status_field + "' to status_type_code='" + status_code + "'");
			}
		}
		return bRet;
	}


	/**
	 * String customer_id is used to lookup custom customer columns
	 */
	public List<String> addCustomFieldValidation(ConnectionWrapper conn, String customer_id) throws Exception
	{
		Diagnostics.trace("PDSPreHandler.addCustomFieldValidation()");
		List<String> tempRequiredFields = new ArrayList<String>();
		String query = "SELECT col_sequence, is_mandatory FROM custom_cust_columns WHERE active_flag='Y' AND is_mandatory = 'Y' AND customer_id = ?";
		QueryResults rs = conn.select(query, customer_id);
		while (rs.next())
		{
			tempRequiredFields.add("xcust_col_" + rs.getString("col_sequence"));
		}
		IMSUtil.closeQueryResultSet(rs);
		return tempRequiredFields;
	}

	/**
	 *
	 */
	public boolean createNewVersion(InvocationContext ic, ConnectionWrapper conn) throws Exception
	{
		Diagnostics.trace("PDSPreHandler.addCustomFieldValidation()");
		boolean result = true;
		String project_id = ic.getParameter("project_id");
		String request_no = ic.getParameter("request_no");
		String version_no = ic.getParameter("version_no");

		//remove any temp version handing out there if there is any
		String query = "DELETE FROM requests WHERE project_id = ?"
		+ " AND request_no = ?"
		+ " AND is_copy = 'Y'";
		conn.update(query, new String[] {project_id, request_no});
		//make a copy of the this request before smartform changes it

		query = "INSERT INTO dbo.requests SELECT * from dbo.versions_copy_v WHERE project_id = ? "
		+ " AND request_no = ? "
		+ " AND version_no = ? ";

		conn.update(query, new Integer[] {new Integer(project_id), new Integer(request_no), new Integer(version_no)});

		//in the PDSPostHandler will update and archive the older version, and
		// set new version
		ic.setTransientDatum("new_version", "true");
		ic.setTransientDatum("old_version_request_id", "" + Integer.parseInt(conn.selectFirst("SELECT @@identity")));

		return result;
	}

	public int queryResultsAsInt(ConnectionWrapper conn, String query) throws SQLException
	{
		int result = 0;
		String stringResult = conn.selectFirst(query);
		if (stringResult != null && stringResult.length() > 0)
		{
			try
			{
				result = Integer.parseInt(stringResult);
			}
			catch (NumberFormatException e)
			{
			}
		}
		return result;
	}

	public int getNewRequestNo(ConnectionWrapper conn, String projectID) throws SQLException
	{
		String query = "select max(request_no) + 1"
		+ " from requests"
		+ " where project_id = " + projectID;

		int mrResult = queryResultsAsInt(conn, query);

		query = "select max(s.service_no) + 1"
		+ " from services s, jobs j"
		+ " where j.project_id = " + projectID
		+ " and s.job_id = j.job_id";

		int srResult = queryResultsAsInt(conn, query);

		return Math.max(mrResult, srResult);
	}

}