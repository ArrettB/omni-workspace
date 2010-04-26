package com.dynamic.charm.web.admin.controllers;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;
import org.springframework.web.servlet.ModelAndView;

import com.dynamic.charm.query.jdbc.JDBCUtils;
import com.dynamic.charm.web.controller.BaseController;

public class DataSourcesController extends BaseController
{

	private final static Logger logger = Logger.getLogger(DataSourcesController.class);

	@Override
	public void afterPropertiesSetInternal() 
	{
	}

	@Override
	public void registerRequiredProperties() 
	{
	}

	private String translateTranslationLevel(int translationInfo)
	{
		switch(translationInfo)
		{
		case Connection.TRANSACTION_NONE:
		return "TRANSACTION_NONE";
		case Connection.TRANSACTION_READ_COMMITTED:
			return "TRANSACTION_NONE";
		case Connection.TRANSACTION_READ_UNCOMMITTED:
			return "TRANSACTION_NONE";
		case Connection.TRANSACTION_REPEATABLE_READ:
			return "TRANSACTION_NONE";
		case Connection.TRANSACTION_SERIALIZABLE:
			return "TRANSACTION_NONE";
		default:
			return "UNKNOWN";
		}
		
	}

	protected Map getBeansOfTypeInner(Class type, ApplicationContext ac)
	{
		ApplicationContext parent = ac.getParent();
		if (parent != null)
		{
			Map parentBeans = getBeansOfTypeInner(type, parent);
			parentBeans.putAll(ac.getBeansOfType(type));
			return parentBeans;
		}
		else
		{
			return ac.getBeansOfType(type);
		}
	}
	
	protected Map getAllBeansOfType(Class type)
	{
		return getBeansOfTypeInner(type, getWebApplicationContext());
	}
	
	protected ModelAndView handleRequestInternal(HttpServletRequest arg0, HttpServletResponse arg1) throws Exception
	{
		ModelAndView result = new ModelAndView("admin/dataSources");
		Connection conn = null;

		Map dataSourceBeans = getAllBeansOfType(DataSource.class);

		Map exposedDataSources = new HashMap();
		for (Iterator iter = dataSourceBeans.entrySet().iterator(); iter.hasNext();)
		{
			Entry entry = (Entry) iter.next();
			DataSource dataSource = (DataSource) entry.getValue();

			try
			{
				conn = dataSource.getConnection();
				DatabaseMetaData meta = conn.getMetaData();

				Map info = new LinkedHashMap();
				info.put("database.databaseProductName", meta.getDatabaseProductName());
				info.put("database.databaseProductVersion", meta.getDatabaseProductVersion());
				info.put("database.driverName", meta.getDriverName());
				info.put("database.driverVersion", meta.getDriverVersion());
				info.put("database.userName", meta.getUserName());
				info.put("database.url", meta.getURL());
				info.put("database.defaultTransactionIsolation", translateTranslationLevel(meta.getDefaultTransactionIsolation()));

				info.put("database.supportsTransaction", Boolean.valueOf(meta.supportsTransactions()));
				info.put("database.supportsTransactionNone", meta.supportsTransactionIsolationLevel(Connection.TRANSACTION_NONE) ? "Supported" : "Not Supported");
				info.put("database.supportsTransactionReadCommitted", meta.supportsTransactionIsolationLevel(Connection.TRANSACTION_READ_COMMITTED) ? "Supported" : "Not Supported");
				info.put("database.supportsTransactionReadUncommitted", meta.supportsTransactionIsolationLevel(Connection.TRANSACTION_READ_UNCOMMITTED) ? "Supported" : "Not Supported");
				info.put("database.supportsTransactionRepeatableRead", meta.supportsTransactionIsolationLevel(Connection.TRANSACTION_REPEATABLE_READ) ? "Supported" : "Not Supported");
				info.put("database.supportsTransactionSerializable", meta.supportsTransactionIsolationLevel(Connection.TRANSACTION_SERIALIZABLE) ? "Supported" : "Not Supported");

				exposedDataSources.put(entry.getKey(), info);

			}
			finally
			{
				JDBCUtils.closeQuietly(conn);
			}

		}

		result.addObject("dataSources", exposedDataSources);

		return result;
	}





}
