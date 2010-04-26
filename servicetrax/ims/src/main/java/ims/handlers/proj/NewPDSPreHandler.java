/*
 *                 Apex IT
 *
 * This software can only be used with the expressed written
 * consent of Apex IT. All rights reserved.
 *
 * Copyright 2007, Apex IT
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

import java.sql.PreparedStatement;
import java.sql.ResultSet;
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
 * @version $Id: NewPDSPreHandler.java, 1098, 3/6/2008 9:28:04 AM, David Zhao $
 */
public class NewPDSPreHandler extends BaseHandler
{
	public static final String INSERT_PROJECT
		= "INSERT INTO projects(project_no,"
		+ "                     project_type_id,"
		+ "                     project_status_type_id,"
		+ "                     customer_id,"
		+ "                     end_user_id,"
		+ "                     job_name,"
		+ "                     date_created,"
		+ "                     created_by) "
		+ " VALUES (?, ?, ?, ?, ?, ?, getdate(), ?)";
	
	public static final String SELECT_VERSION
		= "SELECT ISNULL(MAX(version_no), 0) + 1 version_no "
		+ "  FROM requests "
		+ " WHERE project_id = ? "
		+ "   AND request_no = ?";
	
	public static final String INSERT_VERSION_COPY
		= "INSERT INTO requests SELECT * FROM versions_copy_v WHERE project_id = ? AND request_no = ? AND version_no = ? AND request_type_id = ?";
	
	
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
	private Map<String, List<String>> mandatoryFields = null;


	private static void setupRequiredFields(String requestTypeKey, Map<String, List<String>> fieldMap, List<String> stringFields, List<String> intFields, List<String> dateFields, List<String> extraFields)
	{
		fieldMap.put(requestTypeKey + FIELD_TYPE_SUFFIX_STRING, stringFields);
		fieldMap.put(requestTypeKey + FIELD_TYPE_SUFFIX_INT, intFields);
		fieldMap.put(requestTypeKey + FIELD_TYPE_SUFFIX_DATE, dateFields);
		fieldMap.put(requestTypeKey + FIELD_TYPE_SUFFIX_EXTRA, extraFields);
	}

	private List<String> getRequiredFields(String requestTypeKey, String fieldTypeKey)
	{
		return  mandatoryFields.get(requestTypeKey + fieldTypeKey);
	}


	private List<String> getRequiredFieldList(String requestTypeKey, String fieldTypeKey)
	{
		return mandatoryFields.get(requestTypeKey + fieldTypeKey);
	}
	public void setUpHandler()
	{
		Diagnostics.trace("NewPDSPreHandler.setUpHandler()");

		List<String> requiredStringFields = null;
		List<String> requiredIntFields = null;
		List<String> requiredDateFields = null;
		List<String> extraFields = null;

		mandatoryFields = new HashMap<String, List<String>>();

		
		//************* Mandatory Project Folder fields  ******************
		requiredStringFields = new ArrayList<String>();
		requiredIntFields = new ArrayList<String>();
		requiredDateFields = new ArrayList<String>();
		extraFields = new ArrayList<String>();
		
		requiredIntFields.add("project_type_id");
		requiredIntFields.add( "customer_id");

		setupRequiredFields(REQUEST_TYPE_PF, mandatoryFields, requiredStringFields, requiredIntFields, requiredDateFields, extraFields);

		
		//************* Mandatory Service Request fields  ******************
		requiredStringFields = new ArrayList<String>();
//		requiredStringFields.add("schedule_with_client_flag");
		requiredStringFields.add("dealer_po_no");
		requiredStringFields.add("taxable_flag");
		requiredStringFields.add("description");
//		requiredStringFields.add("is_stair_carry_required");

		requiredIntFields =  new ArrayList<String>();
		requiredIntFields.add("a_m_contact_id");
		requiredIntFields.add("a_m_sales_contact_id");
		requiredIntFields.add("customer_id");
		requiredIntFields.add("end_user_id");
		requiredIntFields.add("job_location_id");
		requiredIntFields.add("customer_contact_id");
		requiredIntFields.add("job_location_contact_id");
		requiredIntFields.add("schedule_type_id");
//		requiredIntFields.add("system_furniture_line_type_id");
		requiredIntFields.add("delivery_type_id");
//		requiredIntFields.add("other_furniture_type_id");
//		requiredIntFields.add("other_delivery_type_id");
//		requiredIntFields.add("prod_disp_id");
//		requiredIntFields.add("wall_mount_type_id");
//		requiredIntFields.add("elevator_avail_type_id");
		requiredIntFields.add("dealer_po_line_no");
//		requiredIntFields.add("quote_type_id");
//		requiredIntFields.add("order_type_id");
		requiredIntFields.add("customer_costing_type_id");
//		requiredIntFields.add("days_to_complete");

		requiredDateFields =new ArrayList<String>();
		requiredDateFields.add("est_start_date");
		requiredDateFields.add("est_end_date");

		extraFields = new ArrayList<String>();

		setupRequiredFields(REQUEST_TYPE_SR, mandatoryFields, requiredStringFields, requiredIntFields, requiredDateFields, extraFields);

		
		//********** Mandatory Quote Request fields  ******************
		requiredStringFields =  new ArrayList<String>();
		requiredStringFields.add("taxable_flag");
		requiredStringFields.add("description");
		requiredStringFields.add("is_stair_carry_required");

		requiredIntFields = new ArrayList<String>();
		requiredIntFields.add("a_m_contact_id");
		requiredIntFields.add("a_m_sales_contact_id");
		requiredIntFields.add("customer_id");
		requiredIntFields.add("end_user_id");
		requiredIntFields.add("job_location_id");
		requiredIntFields.add("customer_contact_id");
		requiredIntFields.add("job_location_contact_id");
		requiredIntFields.add("system_furniture_line_type_id");
		requiredIntFields.add("delivery_type_id");
		requiredIntFields.add("other_furniture_type_id");
		requiredIntFields.add("other_delivery_type_id");
		requiredIntFields.add("prod_disp_id");
		requiredIntFields.add("wall_mount_type_id");
		requiredIntFields.add("elevator_avail_type_id");
		requiredIntFields.add("quote_type_id");
		requiredIntFields.add("customer_costing_type_id");
		requiredIntFields.add("days_to_complete");

		requiredDateFields = new ArrayList<String>();
		requiredDateFields.add("est_start_date");
		requiredDateFields.add("est_end_date");

		extraFields = new ArrayList<String>();

		setupRequiredFields(REQUEST_TYPE_QR, mandatoryFields, requiredStringFields, requiredIntFields, requiredDateFields, extraFields);


		//********** Mandatory Workorder fields (need to update Workorder Quote Too ******************
		requiredStringFields = new ArrayList<String>();
		requiredStringFields.add("customer_po_no");
		requiredStringFields.add("description");
		requiredStringFields.add("taxable_flag");

		requiredIntFields = new ArrayList<String>();
		requiredIntFields.add("customer_id");
		requiredIntFields.add("project_id");
		requiredIntFields.add("customer_contact_id");
		requiredIntFields.add("job_location_id");
		requiredIntFields.add("furniture1_contact_id");
		requiredIntFields.add("activity_type_id1");
		requiredIntFields.add("qty1");
		requiredIntFields.add("activity_cat_type_id1");
		requiredIntFields.add("priority_type_id");
		requiredIntFields.add("approver_contact_id");

		requiredDateFields = new ArrayList<String>();
		requiredDateFields.add("est_start_date");
		requiredDateFields.add("work_order_received_date");

		extraFields =new ArrayList<String>();
		mandatoryFields.put("wo_extra_data", extraFields);

		setupRequiredFields(REQUEST_TYPE_WO, mandatoryFields, requiredStringFields, requiredIntFields, requiredDateFields, extraFields);


		//********** Mandatory Workorder Quote fields (need to update WorkOrder Too ******************
		requiredStringFields  = new ArrayList<String>();
		requiredStringFields.add("description");
		requiredStringFields.add("taxable_flag");

		requiredIntFields = new ArrayList<String>();
		requiredIntFields.add("customer_id");
		requiredIntFields.add("project_id");
		requiredIntFields.add("customer_contact_id");
		requiredIntFields.add("job_location_id");
		requiredIntFields.add("furniture1_contact_id");
		requiredIntFields.add("a_m_contact_id");
		requiredIntFields.add("activity_type_id1");
		requiredIntFields.add("qty1");
		requiredIntFields.add("activity_cat_type_id1");
		requiredIntFields.add("priority_type_id");
		requiredIntFields.add("quote_type_id");
		requiredIntFields.add("delivery_type_id");
		requiredIntFields.add("furn_plan_type_id");
		requiredIntFields.add("furn_spec_type_id");
		requiredIntFields.add("workstation_typical_type_id");
		requiredIntFields.add("regular_hours_type_id");
		requiredIntFields.add("evening_hours_type_id");
		requiredIntFields.add("weekend_hours_type_id");
		requiredIntFields.add("union_labor_req_type_id");
		requiredIntFields.add("duration_time_uom_type_id");
		requiredIntFields.add("duration_qty");
		requiredIntFields.add("phased_install_type_id");
		requiredIntFields.add("d_sales_rep_contact_id");
		requiredIntFields.add("d_sales_sup_contact_id");

		requiredDateFields = new ArrayList<String>();
		requiredDateFields.add("quote_needed_by");

		extraFields = new ArrayList<String>();

		setupRequiredFields(REQUEST_TYPE_WOQ, mandatoryFields, requiredStringFields, requiredIntFields, requiredDateFields, extraFields);

	}

	public void destroy()
	{
		Diagnostics.trace("NewPDSPreHandler.destroy()");
	}

	public String getProjectID(InvocationContext ic)
	{
		Diagnostics.trace("NewPDSPreHandler.getProjectID()");
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
		Diagnostics.trace("NewPDSPreHandler.HandleEnvironment()");
		boolean success = true;

		ConnectionWrapper conn = (ConnectionWrapper) ic.getTransientDatum(SmartFormHandler.CONNECTION);
		
		String button = ic.getParameter("req_button");
		String mode = ic.getRequiredParameter("mode");
		String request_type_code = ic.getParameter("request_type_code");
		String quoting = (String) ic.getSessionDatum("quoting");
		
		String endUserId = ic.getParameter("end_user_id");
		String jobLocationId = ic.getParameter("job_location_id");
		String jobLOcationContactId = ic.getParameter("job_location_contact_id");
		String imsAction = ic.getParameter("ims_action");
		
		
		ic.setSessionDatum("end_user_id", endUserId);
		ic.setSessionDatum("job_location_id", jobLocationId);
		ic.setSessionDatum("job_location_contact_id", jobLOcationContactId);

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
			if ((button.equalsIgnoreCase("Save") || button.equalsIgnoreCase("Send") || button.equalsIgnoreCase("Approve") || button.equalsIgnoreCase("Refuse")) && mode.equals(SmartFormComponent.Insert))
			{
				//inserting new request
				if (success && !StringUtil.hasAValue(projectId))
				{
					if (!request_type_code.equalsIgnoreCase("workorder"))
					{
						Diagnostics.debug2("creating new project ='" + projectId + "'");
						success = created_project = IMSUtil.createProject(ic, conn, endUserId);
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
			} else if ("create_quote_request".equalsIgnoreCase(button) && "new_qr_version".equalsIgnoreCase(imsAction)) {
				String requestNo = ic.getParameter("request_no");
				
				int newVersion = getNewVersionNo(conn, projectId, requestNo);
				
				ic.setParameter("request_no", requestNo);
				ic.setParameter("version_no", "" + newVersion);
			} else if ("create_service_request".equalsIgnoreCase(button) && "keep_version".equalsIgnoreCase(imsAction)) {
				String requestNo = ic.getParameter("request_no");
				String versionNo = ic.getParameter("version_no");
				
				ic.setParameter("request_no", requestNo);
				ic.setParameter("version_no", versionNo);
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
					int sent_status_seq_no = 9999; //just a high number higher then all other statuses
					if (request_type_code.equalsIgnoreCase("workorder")) {
						sent_status_seq_no = Integer.parseInt(conn.queryEx("SELECT sequence_no FROM workorder_status_types_v WHERE lookup_code = 'Approved'"));
					} else if (request_type_code.equalsIgnoreCase("service_request")) {
						sent_status_seq_no = Integer.parseInt(conn.queryEx("SELECT sequence_no FROM serv_req_status_types_v WHERE lookup_code = 'Sent'"));
					} else if (request_type_code.equalsIgnoreCase("quote_request")) {
						sent_status_seq_no = Integer.parseInt(conn.queryEx("SELECT sequence_no FROM quote_req_status_types_v WHERE lookup_code = 'Sent'"));
					}
					
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
						ic.setTransientDatum("button", "Save"); //to be used by SmartForm to save record
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

		Diagnostics.trace("NewPDSPreHandler success='" + success + "'");
		return success;
	}

	public boolean createProject(InvocationContext ic, ConnectionWrapper conn, String endUserId) throws Exception {
		Diagnostics.trace("NewPDSPreHandler.createProject()");
		boolean result = false;
		PreparedStatement stmt = null;
		QueryResults rs = null;
		int insertedRows = 0;

		String projectTypeId = ic.getParameter("project_type_id");
		String projectNo = ic.getParameter("project_no");
		String customerId = ic.getParameter("customer_id");
		String jobName = StringUtil.toUpperCase(ic.getParameter("job_name"));
		
		if (StringUtil.hasAValue(jobName) && jobName.length() > 50) {
			jobName = jobName.substring(0, 50);
		}

		//determine project#
		if (StringUtil.hasAValue(projectNo))
		{//has job_no, so validate job_no, search for duplicates, and update quote if necessary
			result = IMSUtil.validateProjectNo(ic, conn, projectNo, true);
		}
		else
		{//missing job, autogenerate job_no, implicitly there is no quote if job_no is blank
			projectNo = IMSUtil.generateJobNo(ic, conn);
		}

		//get new projects status
		Map<String, String> projectStatuses = MapUtil.getTypeMap(conn, "project_status_type");
		String projectStatusTypeId = (String) projectStatuses.get("folder_created");

		String logonUserId = (String) ic.getRequiredSessionDatum("user_id");
		
		try {
			stmt = conn.prepareStatement(INSERT_PROJECT);
			
			stmt.setString(1, projectNo);
			stmt.setString(2, projectTypeId);
			stmt.setString(3, projectStatusTypeId);
			stmt.setString(4, customerId);
			stmt.setString(5, endUserId);
			stmt.setString(6, jobName);
			stmt.setString(7, logonUserId);
			
			insertedRows = stmt.executeUpdate();
		} catch (Exception e) {
			Diagnostics.error("************Exception inserting project for (projectNo=" + projectNo 
								                                       + ", projectTypeId=" + projectTypeId
								                                       + ", projectStatusTypeId=" + projectStatusTypeId
								                                       + ", customerId=" + customerId 
								                                       + ", endUserId=" + endUserId
								                                       + ", jobName=" + jobName
								                                       + ", created_by=" + logonUserId + "): "
								                                       + e);	
			result = false;
		} finally {
			if (stmt != null) stmt.close();
		}

		if (insertedRows != 1) {
			Diagnostics.error("Failed to create project.");
			SmartFormHandler.addSmartFormError(ic, "Exception in NewPDSPreHandler.createProject(), failed to create Project record.");
			result = false;
		} else {//retrieve new project_id
			try {
				rs = conn.resultsQueryEx("SELECT @@IDENTITY");
				if (rs.next()) {
					Diagnostics.debug3("New project_id = '" + rs.getString(1) + "'");
					ic.setSessionDatum("project_id", rs.getString(1)); //need for application
					ic.setParameter("project_id", rs.getString(1)); //need for smartform to save request
					result = true;
				} else	{
					Diagnostics.error("Failed to retrieve new project_id, no rows returned from query.");
					SmartFormHandler.addSmartFormError(ic, "Exception in PDSPreHandler, failed to create Project record.");
				}
			} catch (Exception e) {
				Diagnostics.error("Exception selecting project_id :" + e);
				result = false;
			} finally {
				if (rs != null) rs.close();
			}
		}

		return result;
	}

	public boolean createRequest(InvocationContext ic, ConnectionWrapper conn, String request_type_code) throws Exception
	{
		Diagnostics.trace("NewPDSPreHandler.createRequest()");
		boolean bRet = false;
		String request_no = ic.getParameter("request_no");
		String versionNo = ic.getParameter("version_no");

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
			
//			set version_number to 1 since first version
			if (!StringUtil.hasAValue(versionNo)) {
				versionNo = "1";
			}
			
			ic.setParameter("version_no", versionNo);


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
				Diagnostics.error("NewPDSPreHandler.createRequest() Unknown request_type_code '" + request_type_code + "'");

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
		Diagnostics.trace("NewPDSPreHandler.sendRequest()");
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
			
			if (REQUEST_TYPE_QR.equalsIgnoreCase(request_type) || REQUEST_TYPE_SR.equalsIgnoreCase(request_type))
			{
				syncCustomerCosting(ic, conn);
			}

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
				Diagnostics.error("NewPDSPreHandler.sendRequest() Unknown request_type '" + request_type + "'");
		}
		return is_valid;
	}

	/**
	 * The new and old customer costing needs to be kept in sync.
	 * 
	 * The new customer costing is just one field where the cost is applied to the job, customer, vendor, or warehouse.
	 * The old costing could be to any/all of them.
	 * 
	 * @param conn
	 * @throws SQLException 
	 */
	private void syncCustomerCosting(InvocationContext ic, ConnectionWrapper conn) throws SQLException
	{
		String customerCostingTypeId = ic.getParameter("customer_costing_type_id");
		
		String noVal = conn.selectFirst("SELECT lookup_id FROM yes_no_type_v WHERE yes_no_type_code = 'n'");
		
		setCostTo("cost_to_cust_type_id", "to_customer", customerCostingTypeId, noVal, ic, conn);
		setCostTo("cost_to_vend_type_id", "to_vendor", customerCostingTypeId, noVal, ic, conn);
		setCostTo("cost_to_job_type_id", "to_job", customerCostingTypeId, noVal, ic, conn);
		setCostTo("warehouse_fee_type_id", "warehouse_feet", customerCostingTypeId, noVal, ic, conn);
	}

	/**
	 * Translate the customer cost lookup value to a yes/no value for the given column and associated cost type.
	 * 
	 * @param column
	 * @param typeName
	 * @param customerCostingTypeId
	 * @param ic
	 * @param conn
	 * @throws SQLException
	 */
	private void setCostTo(String column, String typeName, String customerCostingTypeId, String noVal, InvocationContext ic, ConnectionWrapper conn) throws SQLException
	{
		String query = "SELECT y.lookup_id"
            + " FROM LOOKUPS_V cust, yes_no_type_v y"
            + "	WHERE cust.lookup_id = ?"
            + "    AND cust.type_code = 'customer_costing_type'"
            + "    AND cust.lookup_code = ?"
            + "	AND y.yes_no_type_code = 'y'";
		
		String yesVal = conn.selectFirst(query, new String[] {customerCostingTypeId, typeName});
		
		String yesNoVal = noVal;
		if (yesVal != null)
			yesNoVal = yesVal;
		
		ic.setParameter(column, yesNoVal);
	}

	private boolean checkJobLocation(InvocationContext ic, ConnectionWrapper conn) throws SQLException
	{
		Diagnostics.trace("NewPDSPreHandler.checkJobLocation()");
		String jobLocationId = ic.getParameter("job_location_id");
		String state = conn.queryEx("SELECT state FROM job_locations WHERE job_location_id = " + conn.toSQLString(jobLocationId));

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
		Diagnostics.trace("NewPDSPreHandler.addMandatoryMessage()");
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
		Diagnostics.trace("NewPDSPreHandler.checkRequiredStringField()");
		boolean bRet = true;
		String val = null;
		List<String> requiredStringFields = getRequiredFields(hash_key, FIELD_TYPE_SUFFIX_STRING);

		for (String param: requiredStringFields) {
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
		Diagnostics.trace("NewPDSPreHandler.checkRequiredIntField()");
		boolean bRet = true;
		String val = null;
		List<String> requiredIntFields = getRequiredFields(hash_key, FIELD_TYPE_SUFFIX_INT);

		for (String param: requiredIntFields) {
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
		Diagnostics.trace("NewPDSPreHandler.checkRequiredExtraFields()");
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
		Diagnostics.trace("NewPDSPreHandler.checkRequiredTempFields()");
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
		Diagnostics.trace("NewPDSPreHandler.checkRequiredDateField()");
		boolean bRet = true;
		String errParam = null;
		String val = null;
		List<String> requiredDateFields = getRequiredFields(hash_key, FIELD_TYPE_SUFFIX_DATE);

		try
		{

			for (String param:  requiredDateFields) {
				errParam = param;
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
			Diagnostics.warning("Mandatory date field " + errParam + " could not be parsed, value is " + val);
			ic.setTransientDatum("err", "True");
			ic.setTransientDatum("err@" + errParam, "This is a required field.  Please enter it before continuing.");
			bRet = false;
		}
		return bRet;
	}

	private boolean archiveProject(InvocationContext ic, ConnectionWrapper conn) throws Exception
	{
		Diagnostics.trace("NewPDSPreHandler.archiveProject()");
		boolean success = true;
		boolean result = false;

		//handle project
		String project_id = (String) ic.getSessionDatum("project_id");
		success = archive(ic, conn, "project", project_id);

		//handle requests and quotes
		if (success)
		{
			StringBuffer query = new StringBuffer();
			query.append("SELECT record_type_code, record_id FROM projects_all_requests_v WHERE project_id = " + conn.toSQLString(project_id));
			QueryResults rs = conn.resultsQueryEx(query);
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
	public static boolean archive(InvocationContext ic, ConnectionWrapper conn, String record_type_code, String record_id) throws Exception
	{
		Diagnostics.trace("NewPDSPreHandler.archive()");
		boolean bRet = false;

		String table = null; //used in query
		String id_field = null; //used in query
		String status_field = null;//used in query
		Map<String, String> statuses = null; //used in query
		String status_code = null; //used for diagnostics

		//change status of project or request
		if (record_type_code.equalsIgnoreCase("workorder"))
		{
			table = "requests";
			id_field = "request_id";
			status_field = "request_status_type_id";
			status_code = "closed";
			statuses = MapUtil.getTypeMap(conn, "workorder_status_type");
		}
		else if (record_type_code.equalsIgnoreCase("project"))
		{
			table = "projects";
			id_field = "project_id";
			status_field = "project_status_type_id";
			status_code = "folder_closed";
			statuses = MapUtil.getTypeMap(conn, "project_status_type");
		}
		else if (record_type_code.equalsIgnoreCase("project_folder"))
		{
			table = "requests";
			id_field = "request_id";
			status_field = "request_status_type_id";
			status_code = "folder_closed";
			statuses = MapUtil.getTypeMap(conn, "project_status_type");
		}
		else if (record_type_code.equalsIgnoreCase("quote_request"))
		{
			table = "requests";
			id_field = "request_id";
			status_field = "request_status_type_id";
			status_code = "closed";
			statuses = MapUtil.getTypeMap(conn, "quote_req_status_type");
		}
		else if (record_type_code.equalsIgnoreCase("service_request"))
		{
			table = "requests";
			id_field = "request_id";
			status_field = "request_status_type_id";
			status_code = "closed";
			statuses = MapUtil.getTypeMap(conn, "serv_req_status_type");
		}
		else if (record_type_code.equalsIgnoreCase("quote"))
		{
			table = "quotes";
			id_field = "quote_id";
			status_field = "quote_status_type_id";
			status_code = "closed";
			statuses = MapUtil.getTypeMap(conn, "quote_status_type");
		}

		if (StringUtil.hasAValue(table))
		{
			//to be used on the form when the form redisplays
			String status_type_id = (String) statuses.get(status_code);
			ic.setParameter(status_field, status_type_id);

			StringBuffer query = new StringBuffer();
			query.append("UPDATE ").append(table);
			query.append(" SET ").append(status_field).append(" = ").append(conn.toSQLString(status_type_id));
			query.append(" WHERE ").append(id_field).append(" = ").append(conn.toSQLString(record_id));

			int rows = conn.updateEx(query);
			if (rows == 1)
			{//found, that means we were converting a project_folder request to
			 // another request
				Diagnostics.debug("Found and updated the '" + table + "' table's '" + status_field + "' to status_type_code='" + status_code + "' where ID = '"
						+ record_id + "'");
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
		Diagnostics.trace("NewPDSPreHandler.addCustomFieldValidation()");
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
		Diagnostics.trace("NewPDSPreHandler.createNewVersion()");
		boolean result = true;
			
		String projectId = ic.getParameter("project_id");
		String requestNo = ic.getParameter("request_no");
		String versionNo = ic.getParameter("version_no");
		String requestTypeCode = ic.getParameter("request_type_code");

		//remove any temp version handing out there if there is any
		String query = "DELETE FROM requests WHERE project_id=?"
		+ " AND request_no=?"
		+ " AND is_copy='Y'";
		conn.update(query, new String[]{projectId, requestNo});
		
		//make a copy of the this request before smartform changes it
		Map<String, String> request_types = MapUtil.getTypeMap(conn, "request_type");
		String requestTypeId = null;
		requestTypeId = (String) request_types.get(requestTypeCode);
		
		conn.update(INSERT_VERSION_COPY, new String[]{projectId, requestNo, versionNo, requestTypeId});

		//in the PDSPostHandler will update and archive the older version, and set new version
		ic.setTransientDatum("new_version", "true");
		ic.setTransientDatum("old_version_request_id", "" + Integer.parseInt(conn.queryEx("SELECT @@identity")));

		return result;
	}

	public int queryResultsAsInt(ConnectionWrapper conn, String query) throws SQLException
	{
		Diagnostics.trace("NewPDSPreHandler.queryResultsAsInt()");
		int result = 0;
		String stringResult = conn.queryEx(query);
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
		Diagnostics.trace("NewPDSPreHandler.getNewRequestNo()");
		StringBuffer mrQuery = new StringBuffer();
		mrQuery.append("select max(request_no) + 1");
		mrQuery.append(" from requests");
		mrQuery.append(" where project_id = " + projectID);

		StringBuffer srQuery = new StringBuffer();
		srQuery.append("select max(s.service_no) + 1");
		srQuery.append(" from services s, jobs j");
		srQuery.append(" where j.project_id = " + projectID);
		srQuery.append(" and s.job_id = j.job_id");

		int mrResult = queryResultsAsInt(conn, mrQuery.toString());
		int srResult = queryResultsAsInt(conn, srQuery.toString());

		return Math.max(mrResult, srResult);
	}
	
	private int getNewVersionNo(ConnectionWrapper conn, String projectId, String requestNo) throws SQLException
	{
		Diagnostics.trace("NewPDSPreHandler.getNewVersionNo()");
		int result = 0;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		try {
			stmt = conn.prepareStatement(SELECT_VERSION);
			
			stmt.setString(1, projectId);
			stmt.setString(2, requestNo);
			
			rs = stmt.executeQuery();
			
			if (rs.next()) {
				result = rs.getInt("version_no");
			}
		}catch (Exception e) {
			Diagnostics.error("Error get new version # for project_id = " + projectId + " and request_no = " + requestNo + ":" + e);
		} finally {
			if (rs != null) rs.close();
			if (stmt != null) stmt.close();
		}

		return result;
	}

}
