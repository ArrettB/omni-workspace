/*
 *               Apex IT
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.
 *
 * Copyright 2000-2008, Apex IT
 * $Id: LoadPODetailHandler.java, , 4/6/2008, David Zhao$
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO
 * EVENT SHALL DYNAMIC INFORMATIONS SYTEMS, LLC BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * ====================================================================
 */
package ims.handlers.po;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * @version $Id: POReportHandler.java 1 2008-04-11 dzhao $
 */
public class POReportHandler extends BaseHandler
{
	public static final String SELECT
		= "SELECT CONVERT(VARCHAR, p.project_no) + '-' + CONVERT(VARCHAR, r.request_no) + '-' + CONVERT(VARCHAR, po.po_no) po_no,"
		+ "       po.ext_vendor_id,"
		+ "       po.ext_vendor_address_id,"
		+ "       po.vendor_name,"
		+ "       po.po_total,"
		+ "       po.description,"
		+ "       po.created_by,"
		+ "       CONVERT(VARCHAR,po.date_created,110) date_created,"
		+ "       po.modified_by,"
		+ "       CONVERT(VARCHAR,po.date_modified,110) date_modified,"
		+ "       billing_type.name billing_type,"
		+ "       r.a_m_contact_id,"
		+ "       r.a_m_sales_contact_id,"
		+ "       r.job_location_contact_id,"
		+ "       CASE WHEN r.schedule_with_client_flag='y' THEN 'Yes' ELSE 'No' END schedule_with_client_flag,"
		+ "       r.schedule_type_id,"
		+ "       CONVERT(VARCHAR,r.est_start_date,110) est_start_date,"
		+ "       r.est_start_time,"
		+ "       CONVERT(VARCHAR,r.est_end_date,110) est_end_date,"
		+ "       r.days_to_complete,"
		+ "       r.system_furniture_line_type_id,"
		+ "       r.delivery_type_id,"
		+ "       r.other_furniture_type_id,"
		+ "       r.other_delivery_type_id,"
		+ "       r.prod_disp_id,"
		+ "       r.wall_mount_type_id,"
		+ "       r.elevator_avail_type_id,"
		+ "       CASE WHEN r.is_stair_carry_required='y' THEN 'Yes' ELSE 'No' END is_stair_carry_required,"
		+ "       CASE WHEN r.taxable_flag='y' THEN 'Yes' ELSE 'No' END taxable_flag,"
		+ "       r.order_type_id,"
		+ "       r.customer_costing_type_id,"
		+ "       r.other_conditions,"
		+ "       jl.job_location_name,"
		+ "       jl.street1,"
		+ "       jl.street2,"
		+ "       jl.street3," 
		+ "       jl.city + ',  ' + jl.state + ' ' + jl.zip city,"
		+ "       p.job_name,"
		+ "       project_type.name project_type,"
		+ "       eu.customer_name end_user_name "
		+ "  FROM purchase_orders po INNER JOIN "
		+ "       lookups billing_type ON po.billing_type_id = billing_type.lookup_id INNER JOIN "
		+ "       requests r ON po.request_id = r.request_id INNER JOIN "
		+ "       job_locations jl ON r.job_location_id = jl.job_location_id INNER JOIN "
		+ "       projects p ON r.project_id = p.project_id INNER JOIN "
		+ "       lookups project_type ON p.project_type_id = project_type.lookup_id INNER JOIN "
		+ "       customers eu ON p.end_user_id = eu.customer_id "
		+ " WHERE po.po_id = ? ";

	public void setUpHandler() {}

	public void destroy() {}

	public boolean handleEnvironment(InvocationContext ic)
	{
		Diagnostics.debug2("POReportHandler.handleEnvironment()");
		boolean result = true;
		ConnectionWrapper conn = null;
		
//		ConnectionWrapper gp_conn = null;

		try	{
			conn = (ConnectionWrapper) ic.getResource();
//			String gp_org = (String)ic.getRequiredSessionDatum("org_resource");
//			gp_conn = (ConnectionWrapper)ic.getResource(gp_org);
			result = getData(ic, conn);

		} catch (Exception e) {
			ErrorHandler.handleException(ic, e, "Exception in POReportHandler");
			result = false;
		} finally {
			if (conn != null) conn.release();
		}

		// set template if available
		String template_name = ic.getParameter("templateName");
		if (StringUtil.hasAValue(template_name))
			ic.setHTMLTemplateName(template_name);

		return result;
	}

	private boolean getData(InvocationContext ic, ConnectionWrapper conn) throws SQLException {
		boolean result = true;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		String poId = ic.getParameter("po_id");
		
		if (StringUtil.hasAValue(poId)) {

			try {
				stmt = conn.prepareStatement(SELECT);
				stmt.setInt(1, Integer.parseInt(poId));
				rs = stmt.executeQuery();
				if (rs.next()) {
					ic.setTransientDatum("po_id", poId);
					ic.setTransientDatum("ext_vendor_id", rs.getString("ext_vendor_id"));
					ic.setTransientDatum("ext_vendor_address_id", rs.getString("ext_vendor_address_id"));
					ic.setTransientDatum("po_no", rs.getString("po_no"));
					ic.setTransientDatum("vendor_name", rs.getString("vendor_name"));
					ic.setTransientDatum("po_total", rs.getString("po_total"));
					ic.setTransientDatum("description", rs.getString("description"));
					ic.setTransientDatum("created_by", rs.getString("created_by"));
					ic.setTransientDatum("date_created", rs.getString("date_created"));
					ic.setTransientDatum("modified_by", rs.getString("modified_by"));
					ic.setTransientDatum("date_modified", rs.getString("date_modified"));
					ic.setTransientDatum("billing_type", rs.getString("billing_type"));
					ic.setTransientDatum("a_m_contact_id", rs.getString("a_m_contact_id"));
					ic.setTransientDatum("a_m_sales_contact_id", rs.getString("a_m_sales_contact_id"));
					ic.setTransientDatum("job_location_contact_id", rs.getString("job_location_contact_id"));
					ic.setTransientDatum("schedule_with_client_flag", rs.getString("schedule_with_client_flag"));
					ic.setTransientDatum("schedule_type_id", rs.getString("schedule_type_id"));
					ic.setTransientDatum("est_start_date", rs.getString("est_start_date"));
					ic.setTransientDatum("est_start_time", rs.getDate("est_start_time"));
					ic.setTransientDatum("est_end_date", rs.getString("est_end_date"));
					ic.setTransientDatum("days_to_complete", rs.getString("days_to_complete"));
					ic.setTransientDatum("system_furniture_line_type_id", rs.getString("system_furniture_line_type_id"));
					ic.setTransientDatum("delivery_type_id", rs.getString("delivery_type_id"));
					ic.setTransientDatum("other_furniture_type_id", rs.getString("other_furniture_type_id"));
					ic.setTransientDatum("other_delivery_type_id", rs.getString("other_delivery_type_id"));
					ic.setTransientDatum("prod_disp_id", rs.getString("prod_disp_id"));
					ic.setTransientDatum("wall_mount_type_id", rs.getString("wall_mount_type_id"));
					ic.setTransientDatum("elevator_avail_type_id", rs.getString("elevator_avail_type_id"));
					ic.setTransientDatum("is_stair_carry_required", rs.getString("is_stair_carry_required"));
					ic.setTransientDatum("taxable_flag", rs.getString("taxable_flag"));
					ic.setTransientDatum("order_type_id", rs.getString("order_type_id"));
					ic.setTransientDatum("customer_costing_type_id", rs.getString("customer_costing_type_id"));
					ic.setTransientDatum("other_conditions", rs.getString("other_conditions"));
					ic.setTransientDatum("job_location_name", rs.getString("job_location_name"));
					ic.setTransientDatum("street1", rs.getString("street1"));
					ic.setTransientDatum("street2", rs.getString("street2"));
					ic.setTransientDatum("street3", rs.getString("street3"));
					ic.setTransientDatum("city", rs.getString("city"));
					ic.setTransientDatum("job_name", rs.getString("job_name"));
					ic.setTransientDatum("project_type", rs.getString("project_type"));
					ic.setTransientDatum("end_user_name", rs.getString("end_user_name"));

				}
			} catch (Exception e) {
				ErrorHandler.handleException(ic, e, "Problem in POReportHandler.getData");
			} finally {
				if (stmt != null) stmt.close();
				if (rs != null) rs.close();
			}
		}

		return result;

	}

}
