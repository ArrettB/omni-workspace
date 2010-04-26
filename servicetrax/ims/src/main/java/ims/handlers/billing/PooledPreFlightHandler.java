package ims.handlers.billing;

import ims.helpers.IMSUtil;

import java.sql.PreparedStatement;
import java.sql.ResultSet;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;

public class PooledPreFlightHandler extends BaseHandler
{


	public void setUpHandler()
	{
		Diagnostics.debug2("PooledPreFlightHandler.setUpHandler()");
	}

	public void destroy()
	{
		Diagnostics.debug2("PooledPreFlightHandler.destroy()");
	}

	public boolean handleEnvironment(InvocationContext ic)
	{
		Diagnostics.debug2("PooledPreFlightHandler.handleEnvironment()");
		Diagnostics.debug2("PooledPreFlightHandler.Test()");
		boolean result = true;

		ConnectionWrapper conn = null;

		try
		{
			conn = (ConnectionWrapper)ic.getResource();

			//determine this from parameter data
			String jobID = (String)ic.getSessionDatum("job_id");

			StringBuffer countQuery = new StringBuffer();

			countQuery.append(" SELECT COUNT(DISTINCT convert(varchar, phc.item_id) + '_' + convert(varchar, phc.rate)) + 1 AS itemCountPlus1");
			countQuery.append(", COUNT(DISTINCT convert(varchar, phc.item_id) + '_' + convert(varchar, phc.rate)) + 2 AS itemCountPlus2");
			countQuery.append(", COUNT(DISTINCT convert(varchar, phc.item_id) + '_' + convert(varchar, phc.rate)) + 3 AS itemCountPlus3");
			countQuery.append(", COUNT(DISTINCT convert(varchar, phc.item_id) + '_' + convert(varchar, phc.rate)) + 4 AS itemCountPlus4");
			countQuery.append(", COUNT(DISTINCT convert(varchar, phc.item_id) + '_' + convert(varchar, phc.rate)) + 5 AS itemCountPlus5");
			countQuery.append(", COUNT(DISTINCT convert(varchar, phc.item_id) + '_' + convert(varchar, phc.rate)) + 6 AS itemCountPlus6");
			countQuery.append(" FROM pooled_hours_calc phc INNER JOIN services s ON phc.service_id = s.service_id");
			countQuery.append(" WHERE s.job_id = ?");

			PreparedStatement countQueryPStmt = conn.prepareStatement(countQuery.toString());
			countQueryPStmt.setInt(1, Integer.parseInt(jobID));
			
	        ResultSet psRS = countQueryPStmt.executeQuery();
	        QueryResults rs = new QueryResults(conn, countQueryPStmt, psRS);	
//			QueryResults rs = conn.resultsQueryEx(countQuery);
			if (rs.next())
			{
				ic.setTransientDatum("itemCountPlus1", rs.getString("itemCountPlus1"));
				ic.setTransientDatum("itemCountPlus2", rs.getString("itemCountPlus2"));
				ic.setTransientDatum("itemCountPlus3", rs.getString("itemCountPlus3"));
				ic.setTransientDatum("itemCountPlus4", rs.getString("itemCountPlus4"));
				ic.setTransientDatum("itemCountPlus5", rs.getString("itemCountPlus5"));
				ic.setTransientDatum("itemCountPlus6", rs.getString("itemCountPlus6"));
			}
			IMSUtil.closeQueryResultSet(rs);
		}
		catch(Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in PooledPreFlightHandler");
		}
		finally
		{
			if (conn != null)
			{
				conn.release();
			}
		}
		return result;
	}

}

/*
			StringBuffer countQuery = new StringBuffer();
			countQuery.append("SELECT COUNT (DISTINCT sl.item_id) + 1 AS itemCountPlus1, COUNT (DISTINCT sl.item_id) + 2 AS itemCountPlus2");
			countQuery.append(" FROM services s, service_lines sl, items i, lookups l");
			countQuery.append(" WHERE s.job_id = ").append(jobID);
			countQuery.append(" AND s.service_id = sl.service_id");
			countQuery.append(" AND sl.item_id = i.item_id");
			countQuery.append(" AND i.item_type_id = l.lookup_id");
			countQuery.append(" AND l.code = 'hours'");

			QueryResults rs = conn.resultsQueryEx(countQuery);
			if (rs.next())
			{
				ic.setTransientDatum("hoursItemCountPlus1", rs.getString("itemCountPlus1"));
				ic.setTransientDatum("hoursItemCountPlus2", rs.getString("itemCountPlus2"));
			}
			rs.close();

			countQuery = new StringBuffer();
			countQuery.append("SELECT COUNT (DISTINCT sl.item_id) + 1 AS itemCountPlus1, COUNT (DISTINCT sl.item_id) + 2 AS itemCountPlus2");
			countQuery.append(" FROM services s, service_lines sl, items i, lookups l");
			countQuery.append(" WHERE s.job_id = ").append(jobID);
			countQuery.append(" AND s.service_id = sl.service_id");
			countQuery.append(" AND sl.item_id = i.item_id");
			countQuery.append(" AND i.item_type_id = l.lookup_id");
			countQuery.append(" AND l.code = 'expense'");

			rs = conn.resultsQueryEx(countQuery);
			if (rs.next())
			{
				ic.setTransientDatum("expenseItemCountPlus1", rs.getString("itemCountPlus1"));
				ic.setTransientDatum("expenseItemCountPlus2", rs.getString("itemCountPlus2"));
			}
			rs.close();

*/