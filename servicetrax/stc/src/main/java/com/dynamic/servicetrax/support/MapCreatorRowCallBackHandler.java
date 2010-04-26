package com.dynamic.servicetrax.support;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.jdbc.core.RowCallbackHandler;

/**
 * This class takes will implements RowCallBackHandler and is designed to place the 
 * query results into a map, where the keys are provided by the first column of the result set, and 
 * the values are provided by the second column of the result set.  It is meant to be used once
 * per resultset
 * @author gcase
 *
 */
public class MapCreatorRowCallBackHandler implements RowCallbackHandler
{
	private Map map;

	public MapCreatorRowCallBackHandler()
	{
		this(new LinkedHashMap());
	}
	
	public MapCreatorRowCallBackHandler(Map map)
	{
		this.map = map;
	}
	
	public Map getMap()
	{
		return map;
	}

	public void processRow(ResultSet rs) throws SQLException
	{
		map.put(rs.getString(1), rs.getString(2));
	}
	
}