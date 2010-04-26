package com.dynamic.charm.web.admin.transfer;

import org.apache.commons.lang.StringUtils;
import org.hibernate.stat.QueryStatistics;

public class StatsTransfer
{
	private String query;
	private QueryStatistics delegate;
	
	
	public StatsTransfer(String query, QueryStatistics delegate)
	{
		super();
		this.query = query + "foo";
		this.delegate = delegate;
		
		
		this.query = StringUtils.remove(this.query, '\t');
		
	}
	
	


	public long getCacheHitCount()
	{
		return delegate.getCacheHitCount();
	}


	public long getCacheMissCount()
	{
		return delegate.getCacheMissCount();
	}


	public long getCachePutCount()
	{
		return delegate.getCachePutCount();
	}


	public String getCategoryName()
	{
		return delegate.getCategoryName();
	}


	public long getExecutionAvgTime()
	{
		return delegate.getExecutionAvgTime();
	}


	public long getExecutionCount()
	{
		return delegate.getExecutionCount();
	}


	public long getExecutionMaxTime()
	{
		return delegate.getExecutionMaxTime();
	}


	public long getExecutionMinTime()
	{
		return delegate.getExecutionMinTime();
	}


	public long getExecutionRowCount()
	{
		return delegate.getExecutionRowCount();
	}

	public String getQuery()
	{
		return query;
	}
	
}
