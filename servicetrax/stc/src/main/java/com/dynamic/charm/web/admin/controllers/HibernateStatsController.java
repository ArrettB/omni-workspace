	package com.dynamic.charm.web.admin.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hibernate.stat.Statistics;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

import com.dynamic.charm.service.QueryService;
import com.dynamic.charm.web.CharmWebObjectSupport;
import com.dynamic.charm.web.admin.transfer.StatsTransfer;


public class HibernateStatsController extends CharmWebObjectSupport implements Controller, InitializingBean
{
	private QueryService queryService;
	
	public QueryService getQueryService()
	{
		return queryService;
	}
	public void setQueryService(QueryService queryService)
	{
		this.queryService = queryService;
	}

	@Override
	public void afterPropertiesSetInternal() 
	{
		Statistics stats = queryService.getHibernateService().getSessionFactory().getStatistics();
		stats.setStatisticsEnabled(true);		
	}

	@Override
	public void registerRequiredProperties() 
	{
		registerRequiredProperty("queryService");
	}

	public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		if (getStringParameter("clearCache") != null)
		{
			queryService.getHibernateService().getSessionFactory().evictQueries();
			queryService.getHibernateService().getSessionFactory().getStatistics().clear();
			ModelAndView result = new ModelAndView("redirect:/admin/hibernateStats.html");
			return result;
		}
		else
		{
			Statistics stats = queryService.getHibernateService().getSessionFactory().getStatistics();
			stats.logSummary();

			String[] queries = stats.getQueries();
			StatsTransfer[] statsTransfer = new StatsTransfer[queries.length];
			for (int i = 0; i < queries.length; i++)
			{
				
				statsTransfer[i] = new StatsTransfer(queries[i], stats.getQueryStatistics(queries[i]));
			}

			ModelAndView result = new ModelAndView("/admin/hibernateStats");
			result.addObject( "statistics", statsTransfer);
			return result;
			
		}
	}



	

}
