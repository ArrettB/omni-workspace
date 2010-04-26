package com.dynamic.servicetrax.dwr;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.dynamic.charm.common.NumberUtils;
import com.dynamic.charm.query.jdbc.JDBCService;
import com.dynamic.charm.service.QueryService;
import com.dynamic.servicetrax.support.MapCreatorRowCallBackHandler;
import com.dynamic.servicetrax.support.ServiceTraxDWRObjectSupport;

public class LookupSupport extends ServiceTraxDWRObjectSupport
{
	private QueryService queryService;


	@Override
	public void afterPropertiesSetInternal()
	{
	}

	@Override
	public void registerRequiredProperties()
	{
		registerRequiredProperty("queryService");
	}

	public Double getItemCost(int itemId)
	{
		Map result = (Map) queryService.namedQueryForObject("lookupsupport.itemCost", itemId);
		return NumberUtils.asDoubleNullAsZero(firstMapEntry(result));
	}

	public Double getItemBillRate(int itemId, int jobId)
	{
		String[] paramNames = { "item_id", "job_id" };
		Object[] paramValues = { itemId, jobId };
		Map result = (Map) queryService.namedQueryForObject("lookupsupport.itemJobRate", paramNames, paramValues);
		return NumberUtils.asDoubleNullAsZero(firstMapEntry(result));
	}

	public Map<String,String> getOpenReqs(int jobId, int currentServiceId)
	{
		String query = "SELECT service_id, service_no_desc " +
		"FROM tc_services_v " +
		"WHERE (job_id = ? AND serv_status_type_code != 'closed') " +
		"OR service_id = ? " +
		"ORDER BY service_no ";

//		String[] paramNames = { "job_id", "servce_id" };
		Object[] paramValues = { jobId, currentServiceId };

		JDBCService jdbcService =  (JDBCService) queryService.getDataService("JDBCService");
		MapCreatorRowCallBackHandler handler = new MapCreatorRowCallBackHandler();
		jdbcService.getJDBCTemplate().query(query, paramValues, handler);

		return (Map<String,String>)handler.getMap();

	}

	public Map<String,String> getExpenseItems(int jobId, int organizationId, int currentItemId)
	{
		String query = "SELECT i.item_id, i.name" +
				" FROM items_v i INNER JOIN items_by_job_types_v ijt ON ijt.item_id = i.item_id" +
				" WHERE i.item_type_code = 'expense'" +
				" AND i.item_status_type_code = 'active'" +
				" AND i.allow_expense_entry = 'Y'" +
				" AND ijt.job_id = ?" +
				" AND i.organization_id = ?" +
				" UNION" +
				" SELECT item_id, name " +
				" FROM items" +
				" WHERE item_id = ?" +
				" ORDER BY name";

		Object[] paramValues = { jobId, organizationId, currentItemId};

		JDBCService jdbcService =  (JDBCService) queryService.getDataService("JDBCService");
		MapCreatorRowCallBackHandler handler = new MapCreatorRowCallBackHandler();
		jdbcService.getJDBCTemplate().query(query, paramValues, handler);

		return (Map<String,String>)handler.getMap();

	}

	public Integer getResourceIDFromEmpNo(String empNo, int orgId)
	{
		String[] paramNames = { "emp_no", "organization_id" };
		Object[] paramValues = { empNo, orgId };
		Map result = (Map) queryService.namedQueryForObject("lookupsupport.resourceIdFromEmpNo", paramNames, paramValues);
		return NumberUtils.asIntegerNullAsZero(firstMapEntry(result));
	}


	public void setQueryService(QueryService queryService)
	{
		this.queryService = queryService;
	}

	public QueryService getQueryService()
	{
		return queryService;
	}

	private Object onlyMapEntry(Map m)
	{
		if (m != null && m.size() == 1)
		{
			return m.values().iterator().next();
		}
		else
		{
			return null;
		}
	}

	private Object firstMapEntry(Map m)
	{
		if (m != null && m.size() >= 1)
		{
			return m.values().iterator().next();
		}
		else
		{
			return null;
		}
	}

	private Map listOfMapsToMap(List list, String mapKey, String mapValue)
	{
		Map result = new HashMap();
		for (Iterator iter = list.iterator(); iter.hasNext();)
		{
			Map map = (Map) iter.next();
			result.put(map.get(mapKey), map.get(mapValue));
		}
		return result;
	}

}
