package com.dynamic.servicetrax.dao;

import java.util.Map;

import org.springframework.jdbc.core.support.JdbcDaoSupport;

import com.dynamic.servicetrax.support.MapCreatorRowCallBackHandler;
 
public class LookupsDao extends JdbcDaoSupport 
{
	
	private String lookupMapQuery;
	
	public LookupsDao()
	{
		StringBuffer query = new StringBuffer();
		query.append("SELECT l.code, l.lookup_id");
		query.append(" FROM lookups l, lookup_types lt");
		query.append(" WHERE l.lookup_type_id = lt.lookup_type_id");
		query.append(" AND lt.code = ?");
		query.append(" AND l.active_flag = 'Y'");
		
		lookupMapQuery = query.toString();
	}
	
	public Map loadLookupMap(String lookupTypeCode)
	{
		MapCreatorRowCallBackHandler handler = new MapCreatorRowCallBackHandler();
		getJdbcTemplate().query(lookupMapQuery, new Object[] {lookupTypeCode}, handler);
		logger.info("Lookups for " + lookupTypeCode + " = " + handler.getMap());
		return handler.getMap();	
	}
		
	public String getLookupId(String lookupTypeCode, String lookupCode)
	{
		Map lookupMap = loadLookupMap(lookupTypeCode);
		return (String) lookupMap.get(lookupCode);
	}
	
	public Map loadGenericMap(String table, String keyColumn, String valueColumn)
	{
		String query = "SELECT " + keyColumn + ", " + valueColumn + " FROM " + table;
		
		MapCreatorRowCallBackHandler handler = new MapCreatorRowCallBackHandler();
		getJdbcTemplate().query(query, handler);
		return handler.getMap();

	}
	
	public Map loadServiceLineStatusMap()
	{
		return loadGenericMap("service_line_statuses", "LOWER(code)",  "status_id");
	}
	
	
	
	
}

