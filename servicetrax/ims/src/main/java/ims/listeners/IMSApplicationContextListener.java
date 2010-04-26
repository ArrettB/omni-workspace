package ims.listeners;

import ims.helpers.MapUtil;

import java.sql.SQLException;
import java.util.Iterator;
import java.util.Map;

import org.apache.commons.collections.map.CaseInsensitiveMap;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.ApplicationContext;
import dynamic.intraframe.engine.ApplicationContextListener;
import dynamic.intraframe.engine.Configuration;
import dynamic.util.diagnostics.Diagnostics;

/**
 *
 * @version $Id: IMSApplicationContextListener.java 1072 2008-02-27 20:44:27Z bvonhaden $
 */
public class IMSApplicationContextListener implements ApplicationContextListener
{
	public static String PRODUCT_DISPOSITION_TYPE_MAP = "productDispositionTypeMap";
	public static String RESOURCE_STATUS_TYPE_MAP = "resourceStatusTypesVMap";
	public static String SERVICE_LINE_STATUS_MAP = "ServiceLineStatusMap";
	public static String TRACKING_TYPE_MAP = "trackingTypeMap";
	public static String CUSTOMER_TYPE = "customerType";

	public void beforeContextDestroyed(ApplicationContext ac){}
	public void destroy()
	{
		MapUtil.destroy();
	}
	public void initialize(Configuration config){}


	public void afterContextCreated(ApplicationContext ac)
	{
		Diagnostics.trace("IMSApplicationContextListener.afterContextCreated()");
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ac.getResource();
			Map appGlobalMap = null;

			appGlobalMap = populateMapForLookup("product_disposition_type", conn);
			Diagnostics.debug("Setting appGlobalDatum of " + PRODUCT_DISPOSITION_TYPE_MAP + " to " + appGlobalMap);
			setAppGlobal(ac, PRODUCT_DISPOSITION_TYPE_MAP, appGlobalMap);;

			appGlobalMap = populateMap("resource_status_types_v", "lookup_code", "lookup_id", conn);
			Diagnostics.debug("Setting appGlobalDatum of " + RESOURCE_STATUS_TYPE_MAP + " to " + appGlobalMap);
			setAppGlobal(ac, RESOURCE_STATUS_TYPE_MAP, appGlobalMap);

			appGlobalMap = populateMap("service_line_statuses", "code", "status_id", conn);
			Diagnostics.debug("Setting appGlobalDatum of " + SERVICE_LINE_STATUS_MAP + " to " + appGlobalMap);
			setAppGlobal(ac, SERVICE_LINE_STATUS_MAP, appGlobalMap);

			appGlobalMap = populateMapForLookup("tracking_type", conn);
			Diagnostics.debug("Setting appGlobalDatum of " + TRACKING_TYPE_MAP + " to " + appGlobalMap);
			setAppGlobal(ac, TRACKING_TYPE_MAP, appGlobalMap);
			
			appGlobalMap = populateMapForLookup("customer_type", conn);
			Diagnostics.debug("Setting appGlobalDatum of " + CUSTOMER_TYPE + " to " + appGlobalMap);
			setAppGlobal(ac, CUSTOMER_TYPE, appGlobalMap);
		}
		catch(Exception e)
		{
			Diagnostics.error("Exception in IMSApplicationContextListener.afterContextCreated()", e);
		}
		finally
		{
			if (conn != null)
				conn.release();
		}
	}


	public static Map populateMap(String table, String keyColumn, String valueColumn, ConnectionWrapper conn) throws SQLException
	{

		int count = Integer.parseInt(conn.queryEx("SELECT count(*) FROM " + table));
		Map result = new CaseInsensitiveMap((int)(count));

		StringBuffer query = new StringBuffer();
		query.append("SELECT ").append(keyColumn).append(" theKey, ").append(valueColumn).append(" FROM ").append(table).append(" ORDER BY 1");
		QueryResults rs = null;
		try
		{
			rs = conn.resultsQueryEx(query);
			while (rs.next())
			{
				result.put(rs.getString(1), rs.getString(2));
			}
		}
		finally
		{
			if (rs != null)
				rs.close();
		}
		return result;
	}

	public static Map populateMapForLookup(String lookupTypeCode, ConnectionWrapper conn) throws SQLException
	{
		String tableName = 	"lookups_v WHERE type_code = " + conn.toSQLString(lookupTypeCode);
		return populateMap(tableName, "lookup_code", "lookup_id", conn);
	}
	
	public static void setAppGlobal(ApplicationContext ac, String name, Map data) {
		for (Iterator iter = data.keySet().iterator(); iter.hasNext();) {
			String code = (String) iter.next();
			ac.setAppGlobalDatum(name + ":" + code, data.get(code));
		}
		
	}

}
