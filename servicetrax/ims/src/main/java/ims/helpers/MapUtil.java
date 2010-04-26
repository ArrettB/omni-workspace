/*
 * Created on Feb 20, 2004 To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */

package ims.helpers;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.apache.commons.collections.map.CaseInsensitiveMap;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.util.diagnostics.Diagnostics;

/**
 * @author gcase To change the template for this generated type comment go to
 *         Window - Preferences - Java - Code Generation - Code and Comments
 */
public class MapUtil
{
	private static Map<String, Map<String, String>> cache = new HashMap<String, Map<String, String>>();

	/**
	 * getType() returns the values for that type in a hashtable where the key
	 * is the lookup_code like 'active', and value is the lookup_id stored as an
	 * int Note: returns the codes in lowercase
	 */
	public synchronized static Map<String, String> getTypeMap(ConnectionWrapper conn, String aTypeCode) throws Exception
	{
		Diagnostics.trace("MapUtil.getType()");
		Map<String, String> result = cache.get(aTypeCode);
		if (result == null)
		{
			Diagnostics.debug3("Map does not exist for " + aTypeCode + ", loading from database.");

			StringBuffer query = new StringBuffer();
			query.append("SELECT lookup_code, lookup_id FROM lookups_v ");
			query.append("WHERE type_code = ?");

			result = new CaseInsensitiveMap();
			QueryResults rs = conn.select(query, aTypeCode);
			while (rs.next())
			{
				result.put(rs.getString(1), rs.getString(2));
			}
			rs.close();

			cache.put(aTypeCode, result);
		}
		return result;

	}

	public synchronized String getLookupID(ConnectionWrapper conn, String typeCode, String lookupCode) throws Exception
	{
		return (String) getTypeMap(conn, typeCode).get(lookupCode);
	}

	/**
	 * Clean up the map cache before shutdown.
	 *
	 */
	public static void destroy()
	{
		for (Iterator<String> i = cache.keySet().iterator(); i.hasNext(); )
		{
			String mapName = i.next();
			cache.get(mapName).clear();
		}
		cache.clear();
	}

}