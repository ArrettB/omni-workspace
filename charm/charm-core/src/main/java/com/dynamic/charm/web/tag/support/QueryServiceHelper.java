/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: QueryServiceHelper.java 199 2006-11-14 23:38:41Z gcase $

* THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
* OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED.  IN NO EVENT SHALL DYNAMIC INFORMATIONS SYTEMS, LLC
* BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
* SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
* LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
* USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
* OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
* SUCH DAMAGE.
* ====================================================================
*/


package com.dynamic.charm.web.tag.support;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;
import org.springframework.util.StringUtils;

import com.dynamic.charm.exception.CharmException;
import com.dynamic.charm.query.DataService;
import com.dynamic.charm.query.hibernate.HibernateService;
import com.dynamic.charm.service.DefaultQueryService;
import com.dynamic.charm.service.QueryService;


public class QueryServiceHelper
{
    private final static Logger logger = Logger.getLogger(QueryServiceHelper.class);
    private String queryService;
    private String dataService;

    public HibernateService getDefaultHibernateService(ApplicationContext context)
        throws CharmException
    {
        return (HibernateService) getQueryServiceInstance(context).getHibernateService();
    }

    public QueryService getQueryServiceInstance(ApplicationContext context)
    {
        String serviceName = StringUtils.hasText(queryService) ? queryService : DefaultQueryService.DEFAULT_QUERY_SERVICE_NAME;
        return (QueryService) context.getBean(serviceName);
    }

    public DataService getDataServiceInstance(ApplicationContext context)
    {
        if (StringUtils.hasText(dataService))
        {
            return getQueryServiceInstance(context).getDataService(dataService);
        }
        else
        {
            logger.debug("dataService not set, requesting default service from queryService");
            return getQueryServiceInstance(context).getDefaultService();
        }
    }

    public String getDataService()
    {
        return dataService;
    }

    public void setDataService(String dataService)
    {
        this.dataService = dataService;
    }

    public String getQueryService()
    {
        return queryService;
    }

    public void setQueryService(String queryService)
    {
        this.queryService = queryService;
    }
}
