package com.dynamic.servicetrax.dao;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.dynamic.charm.service.DefaultQueryService;
import com.dynamic.servicetrax.orm.Lookup;

public class HibernateLookupsDao extends DefaultQueryService
{

	public Map loadLookupsMap(String lookupTypeCode)
	{
		List data = namedQueryForList("lookups", lookupTypeCode);
		Map result = new HashMap(data.size());
		for (Iterator iter = data.iterator(); iter.hasNext();)
		{
			Lookup l = (Lookup) iter.next();
			result.put(l.getCode(), l);
		}
		return result;

	}
	
	public Lookup loadLookup(String lookupTypeCode, String lookupCode)
	{
		String[] paramNames = new String[] { "lookupTypeCode", "lookupCode" };
		Object[] paramValues = new Object[] { lookupTypeCode, lookupCode };
		Lookup result = (Lookup) namedQueryForList("lookup", paramNames, paramValues);
		return result;

	}
}
