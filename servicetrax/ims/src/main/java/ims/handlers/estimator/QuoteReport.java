/*
 *               ApexIT, Inc.
 *
 * This software can only be used with the expressed written
 * consent of ApexIT, Inc. All rights reserved.
 *
 * Copyright 2009 ApexIT, Inc.
 * $Id$
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL APEXIT, INC.
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
package ims.handlers.estimator;

import ims.helpers.EstimatorConfig;

import java.io.FileNotFoundException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Vector;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.intraframe.templates.Template;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * Generate a quote report.
 *
 * @version $Id$
 */
public class QuoteReport extends BaseHandler
{

	private EstimatorConfig estimatorConfig;

	public void setUpHandler() throws Exception
	{
		estimatorConfig = new EstimatorConfig(getConfigDocument());
	}

	public void destroy(){}

	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		ConnectionWrapper conn = null;
		boolean result = true;
        String codeName = null;
		try
		{
			Diagnostics.trace("QuoteReport.handleEnvironment()");
			conn = (ConnectionWrapper) ic.getResource();

			QueryResults rs = null;
			try
			{
				String quoteId = ic.getRequiredParameter("quote_id");
				rs = conn.select("execute sp_estimator 10, NULL, ?, NULL, NULL, NULL, NULL", quoteId);
				if( rs.next() )
				{

					// get data and place in return
					String contact = rs.getString("c_contact");
					if(contact==null)
						contact = "";
					if(contact.indexOf("-") > 0)
						contact = contact.substring(0, contact.indexOf("-"));

					ic.setTransientDatum("contact_name", contact);
					ic.setTransientDatum("company_name", rs.getString("c_name"));
					ic.setTransientDatum("company_address", rs.getString("c_address"));
					ic.setTransientDatum("company_city", rs.getString("c_city"));
					ic.setTransientDatum("company_state", rs.getString("c_state"));
					ic.setTransientDatum("company_zip", rs.getString("c_zip"));

					// get the contacts first name
					if(contact.indexOf(" ") > 0)
						contact = contact.substring(0, contact.indexOf(" "));
					ic.setTransientDatum("contact_first_name", contact);

					ic.setTransientDatum("end_name", rs.getString("e_name"));
					ic.setTransientDatum("end_address", rs.getString("e_address"));
					ic.setTransientDatum("end_city", rs.getString("e_city"));
					ic.setTransientDatum("end_state", rs.getString("e_state"));
					ic.setTransientDatum("end_zip", rs.getString("e_zip"));

					ic.setTransientDatum("dealer_name", rs.getString("dealer_name"));


					StringBuilder description = new StringBuilder();
					description.append(formatItem(rs.getString("total_panels_non-powered"), "Non-powered panels"));
					description.append(formatItem(rs.getString("total_panels_powered"), "Powered panels"));
					description.append(formatItem(rs.getString("total_tiles"), "Tiles"));
					description.append(formatItem(rs.getString("total_stack-on_frame_fabric"), "Stack-on frame fabric"));
					description.append(formatItem(rs.getString("total_stack-on_frame_glass"), "Stack-on frame glass"));
					description.append(formatItem(rs.getString("total_worksurfaces"), "Worksurfaces"));
					description.append(formatItem(rs.getString("total_overheads"), "Overheads"));
					description.append(formatItem(rs.getString("total_pedestals"), "Pedestals"));
					description.append(formatItem(rs.getString("total_tasklights"), "Tasklights"));
					description.append(formatItem(rs.getString("total_keyboard_trays"), "Keyboard Trays"));
					description.append(formatItem(rs.getString("total_walltrack"), "Walltrack"));
					description.append(formatItem(rs.getString("total_doors"), "Doors"));
					description.append(formatItem(rs.getString("total_accessories"), "Accessories"));
					ic.setTransientDatum("description", description.toString());


					String access = formatString(trim(rs.getString("select_job_site_move-stage_environment")));
					if(access.compareTo("")!=0)
					{
						access = "with " + access;
					}
					else
					{
						access = "";
					}
					ic.setTransientDatum("access", access);
					
					// load standard conditions.
					loadStandardConditions(quoteId, conn, ic);

					// load the typical workstation configurations.
					loadTypicalWorkstations(quoteId, conn, ic);

					// other furniture
					loadOtherFurniture(quoteId, conn, ic);

					// specify services
					loadOtherServices(quoteId, conn, ic);
					
					// other furniture ad-hoc
					loadOtherFurnitureAdHoc(quoteId, conn, ic);

					// total
					ic.setTransientDatum("total", formatMoney(rs.getString("total")));

					// quote number
					ic.setTransientDatum("quote_num", rs.getString("quote_num"));

					// descriptions
					ic.setTransientDatum("description_text", rs.getString("description"));
					ic.setTransientDatum("other_conditions", rs.getString("other_conditions"));
					ic.setTransientDatum("estimator_comments", rs.getString("estimator_comments"));

					// days to completion
					ic.setTransientDatum("days", rs.getString("days"));


					//dates
					String date_quoted = rs.getString("date_quoted");
					if(date_quoted!=null)
					{
						Date cDate = new SimpleDateFormat("yyyy-M-d").parse(date_quoted);
						String sdf = new SimpleDateFormat( "MMM d, yyyy" ).format(cDate);
						ic.setTransientDatum("date_quoted", sdf.toString());
					}
					else
					{
						ic.setTransientDatum("date_quoted", "");
					}


					String date_created = rs.getString("date_created");
					if(date_created!=null)
					{
						Date cDate = new SimpleDateFormat("yyyy-M-d").parse(date_created);
						String sdf = new SimpleDateFormat( "MMM d, yyyy" ).format(cDate);
						ic.setTransientDatum("date_created", sdf);
					}
					else
					{
						ic.setTransientDatum("date_created", "");
					}

					// omni affiliate name
					String code = trim(rs.getString("code"));
					if (StringUtil.hasAValue(code)) {
						codeName = trim(rs.getString("code_name"));
						if (!codeName.equals("NTLSV"))
						{
							int firstSpace = code.indexOf(" ");
							if (firstSpace > 0 && firstSpace < code.length()) {
								code = code.substring(0, code.indexOf(" "));
							}
						}
						else
						{
							code = "Omni National Services";
						}
					}
					ic.setTransientDatum("code", code);


					// project name
					ic.setTransientDatum("project_name", rs.getString("project_name"));

					String createdBy = rs.getString("created_by_user");
					String modifiedBy = rs.getString("modified_by_user");

					Date date = new java.util.Date();
					String username = (StringUtil.hasAValue(modifiedBy) ?  modifiedBy : createdBy) + " " + date;
					ic.setTransientDatum("username", username);
				}
				rs.close();
			}
			finally
			{
				if (rs != null)
					rs.close();
			}

			String filter = "";
			if (ic.getSessionDatum("org_id").equals(estimatorConfig.getEstimatorTemplate2OrgId()))
			{
				filter = "2";
			}
			
			boolean compact = StringUtil.toBoolean(ic.getParameter("compact"));
			String compactStr = "";
			if (compact)
			{
				compactStr = "_compact";
			}

			String header = ic.getHttpServletRequest().getHeader("user-agent");
            String templatePath = null;
            if(codeName.equals("AIA") || codeName.equals("NTLSV")) {
                templatePath = "enet/rep/" + codeName + "/quote_report" + filter + "_IE7" + compactStr + ".html";

                if(header.indexOf("MSIE 6.0;")>0)
                {
                    templatePath = "enet/rep/" + codeName + "/quote_report" + filter + "_IE6" + compactStr + ".html";
                }
            } else {
                templatePath = "enet/rep/quote_report" + filter + "_IE7" + compactStr + ".html";

                if(header.indexOf("MSIE 6.0;")>0)
                {
                    templatePath = "enet/rep/quote_report" + filter + "_IE6" + compactStr + ".html";
                }
            }


			try
			{
				ic.getTemplate(templatePath);
				// use custom if the template was found
				ic.setHTMLTemplateName(templatePath);
			}
			catch (FileNotFoundException e)
			{
				// use default
				ic.setHTMLTemplateName("enet/rep/quote_report" + filter + "_IE7.html");
			}
		}
		catch (Exception e)
		{
			result = false;
			ErrorHandler.handleException(ic, e,  "Exception in QuoteReport");
		}
		finally
		{
			if (conn != null) conn.release();
		}

		return result;
	}


	private void loadOtherFurniture(String quoteId, ConnectionWrapper conn, InvocationContext ic) throws SQLException
	{
		Vector<QuoteOtherDetail> otherServices = new Vector<QuoteOtherDetail>();
		
		String sql = "SELECT * FROM quote_other_furniture WHERE quote_id = ? ORDER BY set_number";
		
		QueryResults rs = null;
		try
		{
			rs = conn.select(sql, quoteId);
			while (rs.next())
			{
				QuoteOtherDetail adHoc = new QuoteOtherDetail();
				adHoc.setDescription(rs.getString("description"));
				adHoc.setValue(rs.getString("qty"));
				otherServices.add(adHoc);
			}
		}
		finally
		{
			if (rs != null) rs.close();
		}
		
		if (otherServices.size() > 0)
			ic.setTransientDatum("otherFurniture", otherServices);
	}


	private void loadOtherServices(String quoteId, ConnectionWrapper conn, InvocationContext ic) throws SQLException
	{
		Vector<QuoteOtherDetail> otherServices = new Vector<QuoteOtherDetail>();
		
		String sql = "SELECT * FROM quote_specify_other_services WHERE quote_id = ? ORDER BY set_number";
		
		QueryResults rs = null;
		try
		{
			rs = conn.select(sql, quoteId);
			while (rs.next())
			{
				QuoteOtherDetail adHoc = new QuoteOtherDetail();
				adHoc.setDescription(rs.getString("specify_service"));
				adHoc.setValue(rs.getString("bill"));
				otherServices.add(adHoc);
			}
		}
		finally
		{
			if (rs != null) rs.close();
		}
		
		if (otherServices.size() > 0)
			ic.setTransientDatum("specifyOtherServices", otherServices);
	}

	private void loadOtherFurnitureAdHoc(String quoteId, ConnectionWrapper conn, InvocationContext ic) throws SQLException
	{
		Vector<QuoteOtherDetail> otherFurniture = new Vector<QuoteOtherDetail>();
		
		String sql = "SELECT * FROM quote_other_furniture_ad_hoc WHERE quote_id = ? ORDER BY set_number";
		
		QueryResults rs = null;
		try
		{
			rs = conn.select(sql, quoteId);
			while (rs.next())
			{
				QuoteOtherDetail adHoc = new QuoteOtherDetail();
				adHoc.setDescription(rs.getString("description"));
				adHoc.setValue(rs.getString("bill"));
				otherFurniture.add(adHoc);
			}
		}
		finally
		{
			if (rs != null) rs.close();
		}
		
		if (otherFurniture.size() > 0)
			ic.setTransientDatum("otherFurnitureAH", otherFurniture);
	}

	public class QuoteOtherDetail
	{
		String description;
		String value;
		
		public String getDescription()
		{
			return description;
		}
		public void setDescription(String description)
		{
			this.description = description;
		}
		public String getValue()
		{
			return value;
		}
		public void setValue(String value)
		{
			this.value = value;
		}
	}
	
	/**
	 * Load up the typical workstation configuration information for the quote.
	 * 
	 * @param quoteId
	 * @param conn
	 * @param ic
	 * @throws SQLException
	 */
	private void loadTypicalWorkstations(String quoteId, ConnectionWrapper conn, InvocationContext ic) throws SQLException
	{
		StringBuffer workstationDescription = new StringBuffer();

		QueryResults rs = null;

		try
		{
			rs = conn.select("SELECT * FROM quote_workstation_configurations WHERE quote_id = ? ORDER BY set_number", quoteId);
			
			while (rs.next())
			{
				String setNumber = rs.getString("set_number");
				workstationDescription.append(formatWriting(trim(rs.getString("typical")),
						trim(rs.getString("workstation_count"))));

				ic.setTransientDatum("t"+setNumber+"_typical", rs.getString("typical"));

				ic.setTransientDatum("t"+setNumber+"_count", rs.getString("workstation_count"));
				
				// typical price
				ic.setTransientDatum("price_" + setNumber, formatMoney(rs.getString("typical_price")));

				// extended price
				ic.setTransientDatum("extended_" + setNumber, formatMoney(rs.getString("typical_extended_price")));
			}
		}
		finally
		{
			if (rs != null)
				rs.close();
		}

		ic.setTransientDatum("workstationDescription", workstationDescription.toString());
	}


	/**
	 * Get the standard conditions selected for the quote.
	 * 
	 * @param quoteId
	 * @param conn
	 * @param ic
	 * @throws Exception 
	 */
	private void loadStandardConditions(String quoteId, ConnectionWrapper conn, InvocationContext ic) throws Exception
	{
		String query = "SELECT sc.name"
			+ " FROM standard_conditions sc INNER JOIN quote_standard_conditions qsc ON sc.standard_condition_id = qsc.standard_condition_id"
			+ " AND qsc.quote_id = ?"
			+ " ORDER BY sc.sequence_no";
		QueryResults rs = null;
		Vector<String> standardConditions = new Vector<String>();
		try
		{
			rs = conn.select(query, quoteId);
			while (rs.next())
			{
				Template txt = new Template();
				txt.initialize(null, null, null, rs.getString("name"), 0);
				standardConditions.add(txt.include(ic));
			}
		}
		finally
		{
			if (rs != null)
				rs.close();
		}
		
		ic.setTransientDatum("standard_conditions", standardConditions);
	}

	private String formatItem(String value, String name)
	{
		String result = "";
		if(value==null){ value = ""; }
		value = value.replace("-", "");
		value = value.trim();
		if((value.compareTo("")!=0)&&(value.compareTo("0")!=0))
		{
			result = value + " " + name + "<br />";
		}

		return result;
	}

	private String formatWriting(String typical, String count)
	{
		if(typical==null){ typical = ""; }
		String result = "";
		if(typical.compareTo("")!=0)
		{
			result = count + " " + typical + " workstations. ";
		}
		return result;
	}

	private String formatMoney(String string)
	{
		if (StringUtil.hasAValue(string)) {
			string = string.replace("$", "");
			string = string.trim();
			if(string.compareTo("-")==0)  string = "";
			if(string.compareTo("")!=0) string = "$ " + string;
		}

		return string;
	}

	private String formatString(String string)
	{
		if(string==null) string = "";
		return string;
	}

	private String trim(String inString)
	{
		if(StringUtil.hasAValue(inString)){
			return inString.trim();
		} else {
			return inString;
		}
	}
}
