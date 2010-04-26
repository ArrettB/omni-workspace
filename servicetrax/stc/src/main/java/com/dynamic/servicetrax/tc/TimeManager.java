package com.dynamic.servicetrax.tc;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.directwebremoting.WebContextFactory;
import org.springframework.beans.support.PropertyComparator;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;

import com.dynamic.charm.common.ArrayUtils;
import com.dynamic.charm.query.jdbc.JDBCService;
import com.dynamic.charm.service.QueryService;
import com.dynamic.servicetrax.dao.LookupsDao;
import com.dynamic.servicetrax.support.MapCreatorRowCallBackHandler;
import com.dynamic.servicetrax.support.ServiceTraxDWRObjectSupport;

public class TimeManager extends ServiceTraxDWRObjectSupport
{
	private QueryService queryService;
	private LookupsDao lookupsDao;

	private int maxItems = 30;

	private static int nextId = 10;
	private static final String SESSION_ATTR_RECORDS = TimeManager.class.getName() + ".records";
	private static final String SESSION_ATTR_PAYCODES = TimeManager.class.getName() + ".paycodes";

	public void clearSession(HttpSession session)
	{
		session.removeAttribute(SESSION_ATTR_PAYCODES);
		session.removeAttribute(SESSION_ATTR_RECORDS);
	}

	public void clearSession()
	{
		clearSession(getSession());
	}

	@Override
	public void afterPropertiesSetInternal()
	{
	}

	@Override
	public void registerRequiredProperties()
	{
//		registerRequiredProperty("queryService");
//		registerRequiredProperty("lookupsDao");
	}

	public void setQueryService(QueryService queryService)
	{
		this.queryService = queryService;
	}

	public void setMaxItems(int maxItems)
	{
		this.maxItems = maxItems;
	}

	public void setLookupsDao(LookupsDao lookupsDao)
	{
		this.lookupsDao = lookupsDao;
	}

	public Map<String, String> getRequisitions(String jobId)
	{

		List queryResults = queryService.namedQueryForList("reqsByJob", jobId);
		Map<String,String> result = new LinkedHashMap<String,String>(queryResults.size());
		for (Iterator iter = queryResults.iterator(); iter.hasNext();)
		{
			Map row = (Map) iter.next();
			String serviceId = getMapValue(row, "service_id");
			String desc = getMapValue(row, "description");

			if (desc.length() > 40)
				desc = desc.toString().substring(0, 40) + "...";

			Object serviceNo =  getMapValue(row, "service_no");

			result.put(serviceId, serviceNo + ":" + desc);

		}

		return result;
	}

	public List<JobInfo> getJobInfos(String jobString)
	{
		List<JobInfo> queryResults = null;
		if (isAllDigits(jobString))
		{
			jobString += "%";
			String[] paramNames =  new String[] {"organization_id", "number"};
			Object[] paramValues = new Object[] {new Long(getOrganizationId()), jobString};
			queryResults = queryService.namedQueryForList("hibernate.openJobsByNumber", paramNames, paramValues);
		}
		else
		{
			jobString += "%";
			String[] paramNames =  new String[] {"organization_id", "endUserName"};
			Object[] paramValues = new Object[] {new Long(getOrganizationId()), jobString};
			queryResults = queryService.namedQueryForList("hibernate.openJobsByEndUser", paramNames, paramValues);
		}

		if (queryResults != null)
		{
			if (queryResults.size() >= maxItems)
			{
				queryResults = queryResults.subList(0, maxItems-1);
			}
			return queryResults;

		}
		else
		{
			return null;
		}
	}


	private Map<String,String> loadPaycodes()
	{
		logger.debug("loadPaycodes");
		String payCodeTable = getLoginCrediantials().getPaycodeTable();
		String query = "SELECT payrcord, dscriptn FROM  " + payCodeTable + " ORDER BY payrcord";

		JDBCService jdbcService =  (JDBCService) queryService.getDataService("JDBCService");
		MapCreatorRowCallBackHandler handler = new MapCreatorRowCallBackHandler();
		jdbcService.getJDBCTemplate().query(query, handler);

		return (Map<String,String>)handler.getMap();
	}



	public synchronized Map<String,String> getPaycodes()
	{
		HttpSession session = WebContextFactory.get().getSession();
		Map<String,String> payCodes =(Map<String, String>) session.getAttribute(SESSION_ATTR_PAYCODES);
		if (payCodes == null)
		{
			payCodes = loadPaycodes();
			session.setAttribute(SESSION_ATTR_PAYCODES, payCodes);
		}
		return payCodes;
	}




	public List<ResourceInfo> getResources(String resourceString)
	{
		logger.debug("getResources resourceString");
		List queryResults = null;
	//	if (isAllDigits(resourceString))
		if (false)
		{
			resourceString += "%";
			String[] paramNames =  new String[] {"organization_id", "employee_no"};
			Object[] paramValues = new Object[] {new Integer(getOrganizationId()), resourceString};
			queryResults = queryService.namedQueryForList("resourcesByEmployeeNo", paramNames, paramValues);
		}
		else
		{
			resourceString = "%" + resourceString + "%";
			String[] paramNames =  new String[] {"organization_id", "name"};
			Object[] paramValues = new Object[] {new Integer(getOrganizationId()), resourceString};
			queryResults = queryService.namedQueryForList("resourcesByName", paramNames, paramValues);
		}

		if (queryResults != null)
		{
			List<ResourceInfo> result = new ArrayList<ResourceInfo>(queryResults.size());
			for (Iterator iter = queryResults.iterator(); iter.hasNext();)
			{
				Map row = (Map) iter.next();
				String id = getMapValue(row, "resource_id");
				String name = getMapValue(row, "resource_name");
				String number = getMapValue(row, "employee_no");

				ResourceInfo info = new ResourceInfo();
				info.setResourceId(id);
				info.setResourceName(name);
				info.setEmployeeNumber(number);

				result.add(info);

				if (result.size() >= maxItems)
					break;
			}

			logger.debug("result = " + result);

//			ResourceInfo ri = new ResourceInfo();
//			ri.setResourceId("1");
//			ri.setEmployeeNumber("11111");
//			ri.setResourceName("Grand Master Funkron");
//			result.add(ri);

			return result;
		}
		else
		{
			return null;
		}

	}



	public Map<String,String> getItems(String resourceId, String jobId)
	{
		logger.debug("getItems");
		logger.debug("resourceId = " + resourceId);
		logger.debug("jobId = " + jobId);

		String[] paramNames = new String[] {"organization_id", "resource_id", "job_id"};
		Object[] paramValues = new Object[] {new Integer(getOrganizationId()), resourceId, jobId};
		List queryResults = queryService.namedQueryForList("itemsByResourceJob", paramNames, paramValues);
		Map<String,String> result = new LinkedHashMap<String,String>(queryResults.size());
		for (Iterator iter = queryResults.iterator(); iter.hasNext();)
		{
			Map row = (Map) iter.next();
			String id = getMapValue(row, "item_id");
			String name =  getMapValue(row, "item_name");

			result.put(id, name);
		}
		return result;
	}


	public Collection<TimeRecord> getAllRecords()
	{
		Map<Integer, TimeRecord> records = getRecords();
		List<TimeRecord> values = new ArrayList<TimeRecord>(records.values());
		Collections.sort(values, new PropertyComparator("date", false, true));
	    return values;
	}

	public TimeRecord getRecord(int id)
	{
		Map<Integer, TimeRecord> records = getRecords();
	    return records.get(id);
	}


	public Map<String,Double> getSubTotals()
	{
		Map<String,Double> result = new LinkedHashMap<String,Double>();
		Map<Integer, TimeRecord> records = getRecords();
		for (TimeRecord record : records.values())
		{
			Double subtotal = result.get(record.getPaycodeString());
			if (subtotal == null)
			{
				subtotal = Double.valueOf(0);
			}
			result.put(record.getPaycodeString(), Double.valueOf(subtotal.doubleValue() + record.getQty()));
		}

		return result;
	}

	public String addRecord(TimeRecord toAdd)
	{
		logger.debug("toAdd.getResourceId = "  + toAdd.getResourceId());
		logger.debug("toAdd.getJobId = "  + toAdd.getJobId());
		logger.debug("toAdd.getServiceId = "  + toAdd.getServiceId());
		logger.debug("toAdd.getItemId = "  + toAdd.getItemId());


	    if (toAdd.getId() == -1)
	    {
	        toAdd.setId(nextId++);
	    }
		Map<Integer, TimeRecord> records = getRecords();
	    records.put(toAdd.getId(), toAdd);

	    updateTimeRecord(toAdd);

	    return getMessage("servicetrax.tc.time.msgs.add");
	}

	public String deleteRecord(TimeRecord toDelete)
	{
		Map<Integer, TimeRecord> records = getRecords();
	    records.remove(toDelete.getId());

	    return getMessage("servicetrax.tc.time.msgs.delete");
	}

	public String clearRecords()
	{
		Map<Integer, TimeRecord> records = getRecords();
		int numRecords= records.size();
		records.clear();

		return getMessage("servicetrax.tc.time.msgs.clear", new Object[] {numRecords});
	}

	public String commitRecords()
	{
		Map<Integer, TimeRecord> records = getRecords();
		int numRecords= records.size();
		Updater updater = new Updater(records);
		updater.performUpdate();
		records.clear();

		return getMessage("servicetrax.tc.time.msgs.commit", new Object[] {numRecords});
	}


	private void updateTimeRecord(TimeRecord tr)
	{
		Map result = (Map) queryService.namedQueryForObject("serviceNoFromId", tr.getServiceId());
		tr.setPaycodeString(getPaycodes().get(tr.getPaycode()));
		tr.setServiceString(getMapValue(result, "service_no"));
	}

	private boolean isAllDigits(String s)
	{
		char[] chars = s.toCharArray();
		for (int i = 0; i < chars.length; i++)
		{
			if (!Character.isDigit(chars[i]))
			{
				return false;
			}
		}
		return true;
	}

	private String getMapValue(Map row, String key)
	{
		Object value = row.get(key);
		if (value != null)
		{
			return value.toString();
		}
		else
		{
			return "N/A";
		}
	}



	private Map<Integer,TimeRecord> getRecords()
	{
		HttpSession session = WebContextFactory.get().getSession();
		Map<Integer,TimeRecord> result =(Map<Integer, TimeRecord>) session.getAttribute(SESSION_ATTR_RECORDS);
		if (result == null)
		{
			result = new LinkedHashMap<Integer,TimeRecord>();
			session.setAttribute(SESSION_ATTR_RECORDS, result);
		}
		return result;
	}



	class Updater implements BatchPreparedStatementSetter
	{

		private static final String ENTRY_METHOD_WEB = "WEB_NEW";


		private static final String BILLABLE_YES = "Y";


		String update = "INSERT INTO service_lines (" +
				" service_line_date" +
				", tc_job_id" +
				", tc_service_id" +
				", status_id" +
				", item_id" +
				", resource_id" +
				", tc_rate" +
				", tc_qty" +
				", ext_pay_code" +
				", entered_date" +
				", entered_by" +
				", entry_method" +
				", billable_flag" +
				", date_created" +
				", created_by" +
				") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";


		private TimeRecord[] needsUpdate;
		private double rate = 0;
		private int statusId;
		private int userId;
		private Date now = new Date(System.currentTimeMillis());

		public Updater(Map records)
		{
			this.userId = getUserId();
			this.statusId = Integer.parseInt(lookupsDao.loadServiceLineStatusMap().get("submitted").toString());
			this.rate = 0;
			this.needsUpdate = (TimeRecord[]) ArrayUtils.toArray(records.values(), TimeRecord.class);
		}


		public void performUpdate()
		{
			JDBCService service = (JDBCService) queryService.getDataService("JDBCService");
			JdbcTemplate jdbcTemplate = service.getJDBCTemplate();
			jdbcTemplate.batchUpdate(update, this);

		}

		public void setValues(PreparedStatement ps, int i) throws SQLException
		{
			TimeRecord record = needsUpdate[i];
			ps.setDate(1, new Date(record.getDate().getTime()));
			ps.setInt(2, Integer.parseInt(record.getJobId()));
			ps.setInt(3, Integer.parseInt(record.getServiceId()));
			ps.setInt(4, statusId);
			ps.setInt(5, Integer.parseInt(record.getItemId()));
			ps.setInt(6, Integer.parseInt(record.getResourceId()));
			ps.setDouble(7, rate);
			ps.setDouble(8, record.getQty());
			ps.setString(9, record.getPaycode());
			ps.setDate(10, now);
			ps.setInt(11, userId);
			ps.setString(12, ENTRY_METHOD_WEB);
			ps.setString(13, BILLABLE_YES);
			ps.setDate(14, now);
			ps.setInt(15, userId);
		}

		public int getBatchSize()
		{
			return needsUpdate.length;
		}

	}



}
