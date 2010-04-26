package ims.handlers.job_processing;

import ims.helpers.IMSUtil;

import java.sql.PreparedStatement;
import java.sql.ResultSet;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.intraframe.templates.components.SmartFormComponent;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * JobPreHandler validates job info, in particular job_no and quote_no if hit the Reload Item Rates button, then reload item rates
 * and redisplay without saving else if mode=inserting, then if job_no exists, then if job_no is duplicate, then fail and alert user
 * else job_no does not exist, then generateJobNo()
 * 
 * @version $Id: JobPreHandler.java, 29, 3/6/2006 3:46:54 PM, Blake Von Haden$
 */

public class JobPreHandler extends BaseHandler {
	
	public static final String SELECT_PRCLEVEL
		= "SELECT RTRIM(prclevel) ext_price_level_id FROM rm00101 WHERE custnmbr = ?";
	
	public static final String SELECT_CUSTOMER
		= "SELECT customer_id, ext_customer_id, ext_dealer_id FROM customers WHERE customer_id IN (?, ?)";
	
	public void setUpHandler()
	{
	}

	public void destroy()
	{
	}

	public boolean handleEnvironment(InvocationContext ic) throws Exception {
		Diagnostics.trace("JobPreHandler.handleEnvironment()");
		boolean bRet = true;
		ConnectionWrapper conn = null;

		String mode = ic.getRequiredParameter("mode");
		try	{
			conn = (ConnectionWrapper) ic.getTransientDatum(SmartFormHandler.CONNECTION);

			if (bRet && mode.equals(SmartFormComponent.Insert))
				bRet = handleCustomer(ic, conn);

			if (bRet && mode.equals(SmartFormComponent.Insert))	{  // handle job_no
				String job_no = ic.getRequiredParameter("job_no");
				boolean has_job_no = StringUtil.hasAValue(job_no);

				if (mode.equalsIgnoreCase(SmartFormComponent.Insert)) {
					if (has_job_no)	{  // has job_no, so validate job_no, search for duplicates, and update quote if necessary

						bRet = IMSUtil.validateProjectNo(ic, conn, job_no, true);
					} else {           // missing job, autogenerate job_no, implicitely there is no quote if job_no is blank

						job_no = IMSUtil.generateJobNo(ic, conn);
						ic.setParameter("job_no", job_no);
					}
				}
			}
			// test billing_user_id "Job Owner", must test here because extranet creates jobs and may not
			// have a billing_user_id so cannot make mandatory in db, have to do so here instead.
			String billing_user_id = ic.getParameter("billing_user_id");
			if (!StringUtil.hasAValue(billing_user_id))	{
				SmartFormHandler.addSmartFormError(ic, "You must select a Job Owner");
				ic.setTransientDatum("err@billing_user_id", "false");
				bRet = false;
			}
		} catch (Exception e) {
			Diagnostics.debug2("A general exception...please read error output:\n" + e.toString());
			SmartFormHandler.addSmartFormError(ic, "Exception in JobPreHandler, failed while validating job_no and quote_no:"
					+ e.getMessage());
			bRet = false;
		}
		finally	{	// because this is a Pre/PostHandler, we do NOT release the standard connection
		}
		Diagnostics.trace("JobPreHandler.handleEnvironment(" + bRet + ")");
		return bRet;
	}

	public boolean handleCustomer(InvocationContext ic, ConnectionWrapper conn) throws Exception {
		Diagnostics.trace("JobPreHandler.handleCustomer()");
		boolean result = true;
		ConnectionWrapper gp_conn = null;
		String extCustomerId = null;
		String extDealeIid = null;
		String customerId = null;
		String jobTypeId = null;
		String endUserId = null;
		String extEndUserId = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;

		try {
			String extPriceLevelId = ic.getRequiredParameter("ext_price_level_id");

			if (!StringUtil.hasAValue(extPriceLevelId)) {  // missing so default it

				extDealeIid = ic.getRequiredParameter("ext_dealer_id");
				customerId = ic.getRequiredParameter("customer_id");
				jobTypeId = ic.getRequiredParameter("job_type_id");			
				endUserId = ic.getParameter("end_user_id");

				// retrieve ext_customer_id first for price_level defaulting
				stmt = conn.prepareStatement(SELECT_CUSTOMER);
				stmt.setString(1, customerId);
				stmt.setString(2, endUserId);
				rs = stmt.executeQuery();
				
				while (rs.next()) {
					if (customerId.equals(rs.getString("customer_id"))) {
						extCustomerId = rs.getString("ext_customer_id");
						extDealeIid = rs.getString("ext_dealer_id");
					} else {
						extEndUserId = rs.getString("ext_customer_id");
					}
				}

				if (!StringUtil.hasAValue(jobTypeId)) {
					Diagnostics.debug2("User did not select a job_type_id during create job.  Hence, cannot determine pricelevel.");
					ic.setTransientDatum("err@job_type_id", "false");
					ic.setTransientDatum(SmartFormComponent.MAND_FORM_ERR_MSG, "false");
					result = false;
				}
				
				if (!StringUtil.hasAValue(extDealeIid)) {
					Diagnostics.debug2("User did not select a dealer during create job.  Hence, cannot determine pricelevel.");
					ic.setTransientDatum("err@ext_dealer_id", "false");
					result = false;
				}
				
				if (!StringUtil.hasAValue(customerId))	{
					Diagnostics.debug2("User did not select a customer during create job.  Hence, cannot determine pricelevel.");
					ic.setTransientDatum("err@customer_id", "false");
					result = false;
				}
				
				if (result)	{
					// now get customer's pricelevel, if not found, then dealers
					String gp_org = (String) ic.getRequiredSessionDatum("org_resource");
					gp_conn = (ConnectionWrapper) ic.getResource(gp_org);
					stmt = gp_conn.prepareStatement(SELECT_PRCLEVEL);
					boolean useEndUser = true; 
					
				    if (StringUtil.hasAValue(endUserId) && StringUtil.hasAValue(extEndUserId)) {
				    	stmt.setString(1, extEndUserId);
				    } else {
				    	stmt.setString(1, extCustomerId);
				    	useEndUser = false;
				    }
				    
				    rs = stmt.executeQuery();

					if (rs.next()) {  // found customer's default price level
						extPriceLevelId = rs.getString(1);
					} 
					
					if( extPriceLevelId == null && useEndUser) { //no prclevel by end user, try use customer's
						stmt = gp_conn.prepareStatement(SELECT_PRCLEVEL);
						stmt.setString(1, extCustomerId);
						rs = stmt.executeQuery();
						
						if(rs.next()) {
							extPriceLevelId = rs.getString(1);
						}
					}
					
					if( extPriceLevelId == null) {          // customer did not have a default price level, check dealer

						stmt = gp_conn.prepareStatement(SELECT_PRCLEVEL);
						stmt.setString(1, extDealeIid);
						rs = stmt.executeQuery();
						if (rs.next()) {// found dealer's default price level
							extPriceLevelId = rs.getString(1);
						} else {        // no default price level found
							SmartFormHandler.addSmartFormError(ic,
									"No default pricing found.  Before the job is time captured, a Pricelevel must be selected.");
						}
					}
				} else {  // there was an error
					SmartFormHandler.addSmartFormError(ic, "At least one mandatory field was not entered.");
				}

				Diagnostics.debug2("set ext_price_level_id:" + extPriceLevelId);
				ic.setParameter("ext_price_level_id", extPriceLevelId);
			}
		} catch (Exception e) {
			Diagnostics.error("Exception: failed to determine prclevel from Great Plains where ext_customer_id = '"
					+ extCustomerId + "' and/or ext_dealer_id = '" + extDealeIid + "'\n" + e.toString());
			e.printStackTrace();
			result = false;
		} finally	{
			if (rs != null) rs.close();
			if (stmt != null) stmt.close();
			if (gp_conn != null) gp_conn.release();
		}
		return result;
	}

}
