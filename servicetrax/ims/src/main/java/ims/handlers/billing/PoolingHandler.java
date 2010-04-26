package ims.handlers.billing;

import ims.handlers.job_processing.SetServiceLineStatusHandler;
import ims.helpers.IMSUtil;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Set;

import dynamic.dbtk.InClause;
import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.intraframe.templates.components.SmartFormComponent;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * Pre-handler and regular handler - so connection must be handled both ways.
 * 
 * @version $Id: PoolingHandler.java 1161 2008-04-02 21:27:59Z dzhao $
 */
public class PoolingHandler extends BaseHandler
{
	private final static String POOL_PAGE = "bill/pooled.html";
	private final static String POOL_DETAIL_PAGE = "bill/pooled_detail.html";
	
	public static final String SELECT_QTY_LEFT
	 	= "SELECT qty_left FROM pooled_hours_calc_v WHERE service_id = ? AND item_id = ? AND rate = ?";
	
	public static final String INSERT_SERVICE_LINES
		= "INSERT INTO service_lines (service_line_date, status_id, tc_job_id, tc_service_id, bill_job_id,"
		+ "                           bill_service_id, ph_service_id, item_id, billable_flag, tc_qty,"
		+ "                           tc_rate, bill_qty, bill_rate, entered_date, entered_by,"
		+ "                           entry_method, date_created, created_by) "
		+ " VALUES (getDate(), ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, getDate(), ?, ?, getDate(), ?)";
	
	public static final String SELECT_SERVICES
		= "SELECT s.service_id "
	    + "  FROM services s, lookups l "
	    + " WHERE s.serv_status_type_id = l.lookup_id "
	    + "   AND l.code <> 'closed' "
		+ "   AND s.internal_req_flag = 'N' "
	    + "   AND s.job_id = ? "
	    + "   AND s.service_id != ? "
		+ " ORDER BY s.service_id";
	
	public static final String SELECT_DEALLOCATES
		= "SELECT TOP 50 sl1.service_line_id, sl1.tc_qty, sl1.allocated_qty, sl2.bill_qty "
	    + "  FROM service_lines sl1 INNER JOIN "
	    + "       service_lines sl2 ON sl1.tc_service_id = sl2.ph_service_id AND sl1.item_id = sl2.item_id AND ISNULL(sl1.bill_rate, 0) = sl2.bill_rate "   
	    + " WHERE (sl1.fully_allocated_flag = 'Y' or sl1.partially_allocated_flag = 'Y') "
	    + "   AND sl2.ph_service_id IS NOT NULL "
		+ "   AND sl2.service_line_id = ? "
	    + " ORDER BY sl1.service_line_date DESC ";

	public static final String UPDATE_SERVICE_LINE
	 	= "UPDATE service_lines SET allocated_qty = ? WHERE service_line_id = ?";
	
	
	
	public void setUpHandler() {}

	public void destroy() {}

	public boolean handleEnvironment(InvocationContext ic)
	{
		Diagnostics.debug2("PoolingHandler.handleEnvironment()");
		boolean result = true;
		boolean regularHandler = false;
		ConnectionWrapper conn = (ConnectionWrapper) ic.getTransientDatum(SmartFormHandler.CONNECTION); // do not release, smartform
		try
		{
			if (conn == null)
			{
				regularHandler = true;
				conn = (ConnectionWrapper) ic.getResource();
				conn.setAutoCommit(false);
			}
	
			String action = ic.getAction();
			String pool_action = ic.getParameter("pool_action");
			SetServiceLineStatusHandler.copyParametersToTransient(ic);
	
			if (action.equalsIgnoreCase("allocate"))
			{
				result = previewAllocation(ic, conn);
			}
			else if (StringUtil.hasAValue(pool_action) && pool_action.equalsIgnoreCase("deallocate"))
			{
				deallocate(ic, conn);
			}
			else if (action.equalsIgnoreCase("confirm"))
			{
				result = confirmAllocation(ic, conn);
			}
		}
		catch (Exception e)
		{
			result = false;
			ErrorHandler.handleException(ic, e,  "Exception in PoolingHandler");
		}
		finally
		{
			if (regularHandler && conn != null)
			{
				try
				{
					if (result)
						conn.commit();
					else
						conn.rollback();
				}
				catch (SQLException ignore){}
				finally
				{
					try
					{
						conn.setAutoCommit(true);
					}
					catch (SQLException ignore){}
				}
				conn.release();
			}
		}

		return result;
	}

	private double getTotalForItemRate(String[] sentToServices, String itemID, String rateID, ConnectionWrapper conn)
			throws Exception
	{
		Diagnostics.debug("PoolingHandler.getTotalForItemRate()");

		// get our total number of hours for these req
		InClause clause = new InClause();
		clause.add(sentToServices);

		StringBuffer totalQuery = new StringBuffer();
		totalQuery.append("SELECT ISNULL(SUM(total_qty),0) ");
		totalQuery.append(" FROM pooled_hours_totals_v");
		totalQuery.append(" WHERE ");
		totalQuery.append(clause.getInClause("service_id"));
		Diagnostics.debug("totalQuery = " + totalQuery);

		double total = Double.parseDouble(conn.queryEx(totalQuery));
		Diagnostics.debug("total = " + total);
		return total;
	}

	private Hashtable getWeightingHash(double total, String[] sentToServices, String itemID, String rateID, ConnectionWrapper conn)
			throws Exception
	{
		Diagnostics.trace("PoolingHandler.getWeightingHash(for '" + sentToServices.length + "' reqs)");

		Hashtable<String, Double> result = new Hashtable<String, Double>();

		// get our total number of hours for these req
		InClause clause = new InClause();
		clause.add(sentToServices);

		if (total >= 0.0049) // double is not exactly zero, so this insures it is >0.01 else it is 0.00.
		{
			Diagnostics.debug("total sendToServices=" + sentToServices[0]);
			StringBuffer percentQuery = new StringBuffer();
			percentQuery.append("SELECT service_id, SUM(total_qty)/").append(total).append(" AS percentage");
			percentQuery.append(" FROM pooled_hours_totals_v");
			percentQuery.append(" WHERE ");
			percentQuery.append(clause.getInClause("service_id"));
			percentQuery.append(" GROUP BY service_id");

			Diagnostics.debug("percentQuery = " + percentQuery);
			QueryResults rs = conn.resultsQueryEx(percentQuery);
			while (rs.next())
			{
				result.put(rs.getString("service_id"), new Double(rs.getDouble("percentage")));
			}
			rs.close();
		}
		else
		{
			Diagnostics.debug("sendToServices=" + sentToServices[0]);
			Double percent = new Double((double) (1.0 / sentToServices.length));
			for (int i = 0; i < sentToServices.length; i++)
			{
				result.put(sentToServices[i], percent);
			}
		}
		Diagnostics.debug("result = " + result);
		return result;
	}

	private boolean previewAllocation(InvocationContext ic, ConnectionWrapper conn) throws Exception
	{
		boolean result = true;
		Diagnostics.debug2("PoolingHandler.previewAllocation()");
		DecimalFormat formatter = new DecimalFormat("#,##0.00");
		String jobID = ic.getParameter("job_id");
		String fromServiceID = ic.getParameter("service_id");
		String itemID = ic.getParameter("item_id");
		String rateID = ic.getParameter("rate_id");
		String rate = ic.getParameter("rate");

		Diagnostics.debug("jobID = " + jobID);
		Diagnostics.debug("fromServiceID = " + fromServiceID);
		Diagnostics.debug("itemID = " + itemID);
		Diagnostics.debug("rateID = " + rateID);
		Diagnostics.debug("rate = " + rate);

		// first, make sure they selected something to send hours to
		String[] sendToServices = ic.getParameterValues("sendToCheckBox");
		if (sendToServices == null || sendToServices.length == 0)
		{
			ic.setHTMLTemplateName(POOL_DETAIL_PAGE);
			ic.setTransientDatum("errMsg", "You must choose at least one service to allocate hours to.");
		}
		else
		{
			String paramName = "all_" + fromServiceID + "_" + itemID + "_" + rateID;
			try
			{
				Diagnostics.debug("Retrieving value for service_id= " + fromServiceID + ", itemID=" + itemID + ", rate_id="
						+ rateID);
				Double howMuch = Double.valueOf(ic.getParameter(paramName));
				Diagnostics.debug("Allocating " + howMuch + " for service_id= " + fromServiceID + ", itemID=" + itemID
						+ ", rate_id=" + rateID);
				double total = getTotalForItemRate(sendToServices, itemID, rateID, conn);
				Hashtable weightingHash = getWeightingHash(total, sendToServices, itemID, rateID, conn);

				// sum up the weighted values for each service_id-item_id pair
				for (int i = 0; i < sendToServices.length; i++)
				{
					String sendToServiceID = sendToServices[i];

					Double percentage = (Double) weightingHash.get(sendToServiceID);
					if (percentage != null)
					{
						double weighted = round(4 * howMuch.doubleValue() * percentage.doubleValue(), 0);
						weighted = round(weighted / 4, 2);
						String datumName = "conf_" + sendToServiceID + "_" + itemID + "_" + rateID;
						Diagnostics.debug("setting " + datumName + "=" + weighted);
						ic.setTransientDatum(datumName, formatter.format(weighted));

					}
					else
					{
						Diagnostics.warning("Could not get a weighting where sendToServiceID = " + sendToServiceID);
					}
				}
			}
			catch (NumberFormatException e)
			{
				ErrorHandler.handleException(ic, e, "Exception in PoolingHandler: Invalid Calculation in Preview");
				result = false;
			}

			ic.setHTMLTemplateName(POOL_DETAIL_PAGE);
		}
		return result;
	}

	private boolean confirmAllocation(InvocationContext ic, ConnectionWrapper conn) throws Exception
	{
		Diagnostics.trace("PoolingHandler.confirmAllocation()");
		boolean result = true;
		
		PreparedStatement maxQueryStmt = null;
		PreparedStatement queryStmt = null;
		PreparedStatement insertStmt = null;
		
		ResultSet maxRs = null;
		QueryResults maxQr = null;
		ResultSet rs = null;
		QueryResults qr = null;

		String jobID = ic.getParameter("job_id");
		String itemID = ic.getParameter("item_id");
		String rateID = ic.getParameter("rate_id");
		String rate = ic.getParameter("rate");

//		String today = conn.queryEx("SELECT CONVERT(VARCHAR(12), GETDATE(), 101)");
//		Diagnostics.debug("today = " + today);

		Diagnostics.debug("Getting fromServiceID");
		int fromServiceID = Integer.parseInt(ic.getParameter("service_id"));
		Diagnostics.debug("Got fromServiceID");

		int userID = Integer.parseInt(ic.getSessionDatum("user_id").toString());

		// used to determine the total number of hours we have left to work with for a particular item
		double maxQty = 0;
		
		try {
			maxQueryStmt = conn.prepareStatement(SELECT_QTY_LEFT);
			maxQueryStmt.setInt(1, fromServiceID);
			maxQueryStmt.setInt(2, Integer.parseInt(itemID));
			maxQueryStmt.setString(3, rate);
	
			maxRs = maxQueryStmt.executeQuery();
			maxQr = new QueryResults(conn, maxQueryStmt, maxRs);
			
			if (maxQr.next())
			{
				maxQty = maxQr.getDouble("qty_left");
			}
		} catch (Exception e) {
			Diagnostics.error("Exception when fetching qty left in PoolingHandler.confirmAllocation(): ", e);
		} finally {
			IMSUtil.closeQueryResultSet(maxQr);
			if (maxRs != null) maxRs.close();
			if (maxQueryStmt != null) maxQueryStmt.close();
		}
		Diagnostics.debug("maxQty = " + maxQty);
		

		// variables to track allocated vs qty available
		double currentQty = 0;
		boolean exceeded = false;

		// we need to grab the values for each service_id-item_id pair
		try {
			int submittedStatusID = Integer.parseInt(conn.queryEx("SELECT status_id FROM service_line_statuses_v WHERE code = 'Submitted'"));
	
			insertStmt = conn.prepareStatement(INSERT_SERVICE_LINES);
			Diagnostics.debug("insert = " + INSERT_SERVICE_LINES);
			
			try {
				queryStmt = conn.prepareStatement(SELECT_SERVICES);
				queryStmt.setInt(1, Integer.parseInt(jobID));
				queryStmt.setInt(2, fromServiceID);
				Diagnostics.debug2("service_id-item_id query = " + SELECT_SERVICES);
		
				rs = queryStmt.executeQuery();
				qr = new QueryResults(conn, queryStmt, rs);
				
				while (qr.next() && !exceeded)
				{
					int serviceID = qr.getInt("service_id");
		
					String paramName = "conf_" + serviceID + "_" + itemID + "_" + rateID;
					Diagnostics.debug("Getting value for " + paramName);
		
					String qtyString = ic.getParameter(paramName);
					if (qtyString != null && qtyString.length() != 0)
					{
						try
						{
							double qty = Double.parseDouble(qtyString);
							Diagnostics.debug("qty = " + qty);
		
							if (qty > 0)
							{
								// check to see if we have exceeded our max available
								currentQty += qty;
								Diagnostics.debug("currentQty = " + currentQty);
								if (currentQty > maxQty)
								{
									exceeded = true; // this will break us out of our loop
								}
								else
								{
									insertStmt.setInt(1, submittedStatusID);
									insertStmt.setInt(2, Integer.parseInt(jobID));
									insertStmt.setInt(3, serviceID);
									insertStmt.setInt(4, Integer.parseInt(jobID));
									insertStmt.setInt(5, serviceID);	
									insertStmt.setInt(6, fromServiceID);
									insertStmt.setInt(7, Integer.parseInt(itemID));
									insertStmt.setString(8, "Y");
									insertStmt.setDouble(9, qty);
									insertStmt.setString(10, rate);
									insertStmt.setDouble(11, qty);
									insertStmt.setString(12, rate);
									insertStmt.setInt(13, userID);
									insertStmt.setString(14, "SYSTEM");
									insertStmt.setInt(15, userID);
					
									insertStmt.addBatch();
								}
							}
						}
						catch (NumberFormatException e)
						{
							ErrorHandler.handleException(ic, e, "Exception in PoolingHandler: Invalid Calculation in Confirm Allocation");
							result = false;
						}
					}
					else
					{
						Diagnostics.warning("WARNING - No value found for " + paramName);
					}
				}
			} catch (Exception e) {
				ErrorHandler.handleException(ic, e, "Exception in PoolingHandler.confirmAllocation(): selecting invoice ids");
			} finally {
				IMSUtil.closeQueryResultSet(qr);
				if (rs != null) rs.close();
				if (queryStmt != null) queryStmt.close();
			}
			
			insertStmt.executeBatch();
			
		} catch (Exception e) {
			ErrorHandler.handleException(ic, e, "Exception in PoolingHandler.confirmAllocation(): inserting service lines");
		} finally {
			if (insertStmt != null) insertStmt.close();
		}
		
		if (exceeded)
		{
			result = false;
			Diagnostics.warning("The total number of hours/expenses allocated exceeded the number available, changes have been rolled back.");
			ic.setTransientDatum("errMsg", "You may not allocate more hours or expenses than the quantity left.");
		}
		else
		{
			try
			{
				Diagnostics.debug("allocating service_lines...");
				StringBuffer allocateQuery = new StringBuffer();
				allocateQuery.append("SELECT service_line_id, tc_qty, allocated_qty");
				allocateQuery.append(" FROM service_lines ");
				allocateQuery.append(" WHERE tc_service_id = ?");
				allocateQuery.append("   AND item_id = ?");
				allocateQuery.append("   AND isnull(bill_rate, 0) = ?");
				allocateQuery.append("   AND fully_allocated_flag = 'N'");
				allocateQuery.append(" ORDER BY service_line_date");

				PreparedStatement allocateQueryPStmt = conn.prepareStatement(allocateQuery.toString());
				allocateQueryPStmt.setInt(1, fromServiceID);
				allocateQueryPStmt.setInt(2, Integer.parseInt(itemID));
				allocateQueryPStmt.setString(3, rate);

				BigDecimal zero = new BigDecimal(0).setScale(2, BigDecimal.ROUND_HALF_DOWN);
				BigDecimal orig_qty = null;
				BigDecimal allocated_qty = null;
				BigDecimal avail_qty = null;
				BigDecimal total = new BigDecimal(currentQty).setScale(2, BigDecimal.ROUND_HALF_DOWN);

				ResultSet psRS2 = allocateQueryPStmt.executeQuery();
				QueryResults rs2 = new QueryResults(conn, allocateQueryPStmt, psRS2);
				String update1 = "UPDATE service_lines SET allocated_qty = tc_qty WHERE service_line_id = ?";
				PreparedStatement updatePStmt1 = conn.prepareStatement(update1);
				String update2 = "UPDATE service_lines SET allocated_qty = ? WHERE service_line_id = ?";
				PreparedStatement updatePStmt2 = conn.prepareStatement(update2);
				while (rs2.next())
				{
					orig_qty = new BigDecimal(rs2.getDouble("tc_qty"));
					orig_qty.setScale(2, BigDecimal.ROUND_HALF_DOWN);
					allocated_qty = new BigDecimal(rs2.getDouble("allocated_qty"));
					allocated_qty.setScale(2, BigDecimal.ROUND_HALF_DOWN);
					avail_qty = orig_qty.subtract(allocated_qty);
					Diagnostics.debug("total to allocate=" + total + ", orig_qty=" + orig_qty + ", allocated_qty=" + allocated_qty
							+ ", avail_qty=" + avail_qty);

					int serviceLineId = Integer.parseInt(rs2.getString("service_line_id"));
					if (total.compareTo(zero) <= 0)
						break;
					else if (avail_qty.compareTo(zero) < 0)
					{// cannot have allocated qty > orig_qty so fix db, this line is already fully allocated
						updatePStmt1.setInt(1, serviceLineId);
						updatePStmt1.executeUpdate();
					}
					else if (avail_qty.compareTo(total) < 0)
					{// not enough qty on this line, must use more service_lines, so use up all on this line
						updatePStmt1.setInt(1, serviceLineId);
						total = total.subtract(avail_qty);
						updatePStmt1.executeUpdate();
					}
					else
					{// enough qty on this line to complete the allocation
						updatePStmt2.setBigDecimal(1, allocated_qty.add(total));
						updatePStmt2.setInt(2, serviceLineId);
						total = zero;
						updatePStmt2.executeUpdate();
					}
				}
				rs2.close();
				updatePStmt1.close();
				updatePStmt2.close();
			}
			catch (Exception e)
			{
				result = false;
				ErrorHandler.handleException(ic, e, "Exception in PoolingHandler: Failed to allocate hours or expenses...");
				ic.setTransientDatum("errMsg",
						"Failed to allocate hours or expenses...please see your System Administrator immediately.");
			}
		}

		ic.setHTMLTemplateName(POOL_PAGE);
		return result;
	}
	
//	private void deallocate(InvocationContext ic, ConnectionWrapper conn) throws Exception
//	{
//		Diagnostics.trace("PoolingHandler.deallocate()");
//		String button = ic.getParameter(SmartFormComponent.BUTTON);
//		
//		Set zeroSet = new HashSet();
//		Set nonZeroSet = new HashSet();
//
//		String service_line_id = null;
//		if (button.equalsIgnoreCase(SmartFormComponent.Delete))
//			service_line_id = ic.getParameter("service_line_id");
//		Diagnostics.error("service_line_id=" + service_line_id);
//		if (StringUtil.hasAValue(service_line_id))
//		{
//			Diagnostics.debug("loading info of line to deallocate, service_line_id = " + service_line_id);
//			StringBuffer infoQuery = new StringBuffer();
//			infoQuery.append("SELECT ph_service_id, item_id, bill_rate, bill_qty FROM service_lines WHERE ph_service_id IS NOT NULL AND service_line_id = "
//						+ service_line_id);
//
//			String fromServiceID = null;
//			String itemID = null;
//			String rate = null;
//			BigDecimal total = null;
//
//			QueryResults rs = conn.resultsQueryEx(infoQuery);
//			if (rs.next())
//			{
//				Diagnostics.debug("deallocating service_line_id = " + service_line_id);
//				fromServiceID = rs.getString("ph_service_id");
//				itemID = rs.getString("item_id");
//				rate = rs.getString("bill_rate");
//
//				StringBuffer deallocateQuery = new StringBuffer();
//				deallocateQuery.append("SELECT top 50 service_line_id, tc_qty, allocated_qty");
//				deallocateQuery.append(" FROM service_lines ");
//				deallocateQuery.append(" WHERE tc_service_id = ").append(fromServiceID);
//				deallocateQuery.append("   AND item_id = ").append(itemID);
//				deallocateQuery.append("   AND isnull(bill_rate, 0) = ").append(rate);
//				deallocateQuery.append("   AND (fully_allocated_flag = 'Y' or partially_allocated_flag = 'Y')");
//				deallocateQuery.append(" ORDER BY service_line_date desc");
//
//				BigDecimal zero = new BigDecimal(0).setScale(2, BigDecimal.ROUND_HALF_DOWN);
//				BigDecimal orig_qty = null;
//				BigDecimal allocated_qty = null;
//				BigDecimal avail_qty = null;
//				total = new BigDecimal(rs.getDouble("bill_qty")).setScale(2, BigDecimal.ROUND_HALF_DOWN);
//
//				String update = null;
//
//				QueryResults rs2 = conn.resultsQueryEx(deallocateQuery);
//				while (rs2.next())
//				{
//					orig_qty = new BigDecimal(rs2.getDouble("tc_qty"));
//					orig_qty.setScale(2, BigDecimal.ROUND_HALF_DOWN);
//					allocated_qty = new BigDecimal(rs2.getDouble("allocated_qty"));
//					allocated_qty.setScale(2, BigDecimal.ROUND_HALF_DOWN);
//					Diagnostics.debug("total to deallocate=" + total + ", orig_qty=" + orig_qty + ", allocated_qty="
//							+ allocated_qty + ", avail_qty=" + avail_qty);
//
//					if (total.compareTo(zero) <= 0)
//						break;
//					else if (allocated_qty.compareTo(zero) < 0)
//					{// cannot have allocated qty < 0 so fix db, this line is already fully deallocated
//						update = "UPDATE service_lines SET allocated_qty = 0 WHERE service_line_id = "
//								+ rs2.getString("service_line_id");
//					}
//					else if (allocated_qty.compareTo(total) < 0)
//					{// not enough qty on this line, must use more service_lines, so use up all on this line
//						update = "UPDATE service_lines SET allocated_qty = 0 WHERE service_line_id = "
//								+ rs2.getString("service_line_id");
//						total = total.subtract(allocated_qty);
//					}
//					else
//					{// enough qty on this line to complete the allocation
//						update = "UPDATE service_lines SET allocated_qty = " + allocated_qty.subtract(total)
//								+ " WHERE service_line_id = " + rs2.getString("service_line_id");
//						total = zero;
//					}
//					conn.updateEx(update);
//				}
//				rs2.close();
//			}
//			IMSUtil.closeQueryResultSet(rs);
//		}
//	}

	private void deallocate(InvocationContext ic, ConnectionWrapper conn) throws Exception
	{
		Diagnostics.trace("PoolingHandler.deallocate()");
		String button = ic.getParameter(SmartFormComponent.BUTTON);
		PreparedStatement stmt = null;
		ResultSet rs = null;
		Set<String> zeroSet = new HashSet<String>();
		Set<String> nonZeroSet = new HashSet<String>();
		
		BigDecimal total = null;
		BigDecimal zero = new BigDecimal(0).setScale(2, BigDecimal.ROUND_HALF_DOWN);
		BigDecimal orig_qty = null;
		BigDecimal allocated_qty = null;
		BigDecimal avail_qty = null;

		String serviceLineId = null;
		if (button.equalsIgnoreCase(SmartFormComponent.Delete))
			serviceLineId = ic.getParameter("service_line_id");
		Diagnostics.error("service_line_id=" + serviceLineId);
		if (StringUtil.hasAValue(serviceLineId))
		{
			Diagnostics.debug("loading info of line to deallocate, service_line_id = " + serviceLineId);
			
			try {
				stmt = conn.prepareStatement(SELECT_DEALLOCATES);
				stmt.setString(1, serviceLineId);
				rs = stmt.executeQuery();
				
				while (rs.next()) {
					if (total == null) {
						total = new BigDecimal(rs.getDouble("bill_qty")).setScale(2, BigDecimal.ROUND_HALF_DOWN);
					}
					
					orig_qty = new BigDecimal(rs.getDouble("tc_qty"));
					orig_qty.setScale(2, BigDecimal.ROUND_HALF_DOWN);
					allocated_qty = new BigDecimal(rs.getDouble("allocated_qty"));
					allocated_qty.setScale(2, BigDecimal.ROUND_HALF_DOWN);
					Diagnostics.debug("total to deallocate=" + total + ", orig_qty=" + orig_qty + ", allocated_qty="
							+ allocated_qty + ", avail_qty=" + avail_qty);

					if (total.compareTo(zero) <= 0) {
						break;
					} else if (allocated_qty.compareTo(zero) < 0) {// cannot have allocated qty < 0 so fix db, this line is already fully deallocated
						zeroSet.add(rs.getString("service_line_id"));
					} else if (allocated_qty.compareTo(total) < 0) {// not enough qty on this line, must use more service_lines, so use up all on this line
						zeroSet.add(rs.getString("service_line_id"));
						total = total.subtract(allocated_qty);
					} else {// enough qty on this line to complete the allocation
						nonZeroSet.add(rs.getString("service_line_id"));
						total = zero;
					}
					
				}
			} catch (Exception e) {
				Diagnostics.error("Exception in PoolingHandler.deallocate(): +" + SELECT_DEALLOCATES + ". service_line_id=" + serviceLineId + e);
			} finally {
				if (rs != null) rs.close();
				if (stmt != null) stmt.close();
			}
			
			if (zeroSet.size() > 0) {
				try {
					stmt = conn.prepareStatement(UPDATE_SERVICE_LINE);
					
					for (Iterator iter = zeroSet.iterator(); iter.hasNext();) {
						stmt.setInt(1, 0);
						stmt.setString(2, (String) iter.next());
						stmt.addBatch();
					}
					
					stmt.executeBatch();
					
				} catch (Exception e) {
					Diagnostics.error("Exception in PoolingHandler.deallocate(): +" + UPDATE_SERVICE_LINE + ". service_line_id=" + serviceLineId + e);
				} finally {
					if (stmt != null) stmt.close();
				}
			}
			
			if (nonZeroSet.size() > 0) {
				try {
					stmt = conn.prepareStatement(UPDATE_SERVICE_LINE);
					
					for (Iterator iter = nonZeroSet.iterator(); iter.hasNext();) {
						stmt.setBigDecimal(1, total);
						stmt.setString(2, (String) iter.next());
						stmt.addBatch();
					}
					
					stmt.executeBatch();
				} catch (Exception e) {
					Diagnostics.error("Exception in PoolingHandler.deallocate(): +" + UPDATE_SERVICE_LINE + ". service_line_id=" + serviceLineId + e);
				} finally {
					if (stmt != null) stmt.close();
				}
			}
			
		}
	}

	private double round(double roundMe, int places)
	{
		return Math.round(roundMe * Math.pow(10, places)) / Math.pow(10, places);
	}

}
