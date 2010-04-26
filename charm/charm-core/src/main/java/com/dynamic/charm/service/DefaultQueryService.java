/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.

 * Copyright 2005, Dynamic Information Systems, LLC
 * $Id: DefaultQueryService.java 266 2007-08-02 01:42:43Z bvonhaden $

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


package com.dynamic.charm.service;

import java.io.Serializable;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.BeanCreationException;
import org.springframework.beans.factory.InitializingBean;

import com.dynamic.charm.exception.CharmException;
import com.dynamic.charm.query.AbstractDataService;
import com.dynamic.charm.query.DataService;
import com.dynamic.charm.query.NamedQuery;
import com.dynamic.charm.query.NamedQueryLoader;
import com.dynamic.charm.query.hibernate.HibernateService;
import com.dynamic.charm.query.jdbc.JDBCService;
import com.dynamic.charm.reflect.ConvertUtils;


/**
 * @author gcase
 *
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class DefaultQueryService extends AbstractDataService implements InitializingBean, DataService, QueryService
{
    private NamedQueryLoader namedQueryLoader;
    private Map dataServices;

    /* (non-Javadoc)
     * @see com.dynamic.charm.service.QueryService#afterPropertiesSet()
     */
    public void afterPropertiesSet() throws BeanCreationException
    {
        if (namedQueryLoader == null)
        {
            throw new BeanCreationException("namedQueryLoader is required for [" + this.getClass().getName() + "]");
        }
        if (dataServices == null)
        {
            throw new BeanCreationException("dataServices is required for [" + this.getClass().getName() + "]");
        }
    }

    /* (non-Javadoc)
     * @see com.dynamic.charm.service.QueryService#getNamedQuery(java.lang.String)
     */
    public NamedQuery getNamedQuery(String identifier) throws CharmException
    {
        try
        {
            NamedQuery result = namedQueryLoader.findNamedQuery(identifier);
            if (result == null)
            {
                throw new CharmException("NamedQuery [" + identifier + "] does not exist.");
            }

            return result;
        }
        catch (Exception e)
        {
            throw new CharmException("Could not retrieve query with identifer " + identifier, e);
        }
    }

    /* (non-Javadoc)
     * @see com.dynamic.charm.service.QueryService#getDataService(java.lang.String)
     */
    public DataService getDataService(String dataServiceName)
    {
    	DataService dataService = null;
    	if (dataServiceName == null)
    	{
    		dataService = getDefaultService();
    	}
    	else
    	{
	        dataService = (DataService) dataServices.get(dataServiceName);
	        if (dataService == null)
	        {
	            throw new CharmException("DataService [" + dataServiceName + "] does not exist.");
	        }
    	}
        return dataService;
    }

    /* (non-Javadoc)
     * @see com.dynamic.charm.service.QueryService#getDefaultService()
     */
    public DataService getDefaultService()
    {
        DataService result = null;
        for (Iterator iter = dataServices.values().iterator(); iter.hasNext();)
        {
            DataService dataService = (DataService) iter.next();
            if (dataService.getIsDefault())
            {
                result = dataService;
                break;
            }
        }

        if (result != null)
        {
            return result;
        }
        else
        {
            throw new CharmException("Default dataService does not exist");
        }
    }

    /* (non-Javadoc)
     * @see com.dynamic.charm.service.QueryService#getHibernateService()
     */
    public HibernateService getHibernateService()
    {
        return (HibernateService) getDataService(DEFAULT_HIBERNATE_SERVICE_NAME);
    }
    
    /* (non-Javadoc)
     * @see com.dynamic.charm.service.QueryService#getHibernateService()
     */
    public JDBCService getJdbcService()
    {
        return (JDBCService) getDataService(DEFAULT_JDBC_SERVICE_NAME);
    }

    /*
     * (non-Javadoc)
     *
     * @see com.dynamic.charm.query.AbstractDataService#queryForList(java.lang.String,
     *      java.lang.String[], java.lang.Object[], int[])
     */
    /* (non-Javadoc)
     * @see com.dynamic.charm.service.QueryService#queryForList(java.lang.String, java.lang.String[], java.lang.Object[], int[])
     */
    public List queryForList(String query, String[] parameterNames, Object[] parameterValues,int[] types)
    {
        return queryForList(null, query, parameterNames, parameterValues, types);
    }

    /* (non-Javadoc)
     * @see com.dynamic.charm.service.QueryService#queryForList(java.lang.String, java.lang.String, java.lang.String[], java.lang.Object[], int[])
     */
    public List queryForList(String serviceName, String query, String[] parameterNames, Object[] parameterValues, int[] types)
    {
        DataService service = getDataService(serviceName);
        return service.queryForList(query, parameterNames, parameterValues, types);
    }

    /*
     * (non-Javadoc)
     *
     * @see com.dynamic.charm.query.AbstractDataService#queryForList(com.dynamic.charm.query.NamedQuery,
     *      java.lang.String[], java.lang.Object[], int[])
     */
    /* (non-Javadoc)
     * @see com.dynamic.charm.service.QueryService#queryForList(com.dynamic.charm.query.NamedQuery, java.lang.String[], java.lang.Object[], int[])
     */
    public List queryForList(NamedQuery query, String[] parameterNames, Object[] parameterValues)
    {
        String serviceName = query.getService();
        DataService service = getDataService(serviceName);
        return service.queryForList(query, parameterNames, parameterValues);
    }

    /* (non-Javadoc)
     * @see com.dynamic.charm.service.QueryService#get(java.lang.Class, java.io.Serializable)
     */
    public Object get(Class entityClass, Serializable id)
    {
        return getHibernateService().get(entityClass, id);
    }

    /* (non-Javadoc)
     * @see com.dynamic.charm.service.QueryService#load(java.lang.Class, java.io.Serializable)
     */
    public Object load(Class entityClass, Serializable id)
    {
        return getHibernateService().load(entityClass, id);
    }

    /* (non-Javadoc)
     * @see com.dynamic.charm.service.QueryService#save(java.lang.Object)
     */
    public void save(Object saveMe)
    {
        getHibernateService().save(saveMe);
    }

    /* (non-Javadoc)
     * @see com.dynamic.charm.service.QueryService#update(java.lang.Object)
     */
    public void saveOrUpdate(Object updateMe)
    {
        getHibernateService().saveOrUpdate(updateMe);
    }

    /* (non-Javadoc)
     * @see com.dynamic.charm.service.QueryService#update(java.lang.Object)
     */
    public void update(Object updateMe)
    {
        getHibernateService().update(updateMe);
    }

    /* (non-Javadoc)
     * @see com.dynamic.charm.service.QueryService#delete(java.lang.Object)
     */
    public void delete(Object deleteMe)
    {
        getHibernateService().delete(deleteMe);
    }

    /* (non-Javadoc)
     * @see com.dynamic.charm.service.QueryService#deleteAll(java.util.Collection)
     */
    public void deleteAll(Collection deleteMe)
    {
        getHibernateService().deleteAll(deleteMe);
    }

    /* (non-Javadoc)
     * @see com.dynamic.charm.service.QueryService#getDataServices()
     */
    public Map getDataServices()
    {
        return dataServices;
    }

    /* (non-Javadoc)
     * @see com.dynamic.charm.service.QueryService#setDataServices(java.util.Map)
     */
    public void setDataServices(Map dataServices)
    {
        this.dataServices = dataServices;
    }

    /* (non-Javadoc)
     * @see com.dynamic.charm.service.QueryService#getNamedQueryLoader()
     */
    public NamedQueryLoader getNamedQueryLoader()
    {
        return namedQueryLoader;
    }

    /* (non-Javadoc)
     * @see com.dynamic.charm.service.QueryService#setNamedQueryLoader(com.dynamic.charm.query.NamedQueryLoader)
     */
    public void setNamedQueryLoader(NamedQueryLoader namedQueryLoader)
    {
        this.namedQueryLoader = namedQueryLoader;
    }

    public List namedQueryForList(String namedQueryId)
    {
        NamedQuery query = getNamedQuery(namedQueryId);
        return queryForList(query);
    }

    public List namedQueryForList(String namedQueryId, Object parameterValue) 
    {
        NamedQuery query = getNamedQuery(namedQueryId);
        String[] paramNames = new String[] {query.getSingleParameterName()};
        return queryForList(query, paramNames, new Object[] {parameterValue});
    }
    
    public List namedQueryForList(String namedQueryId, String[] parameterNames, Object[] parameterValues)
    {
        NamedQuery query = getNamedQuery(namedQueryId);
        Class[] paramTypes = query.getParameterClassTypes(parameterNames);
        parameterValues = ConvertUtils.convert(parameterValues, paramTypes);
        return queryForList(query, parameterNames, parameterValues);
    }

    public Object namedQueryForObject(String namedQueryId)
    {
        NamedQuery query = getNamedQuery(namedQueryId);
        return queryForObject(query);
    }

    public Object namedQueryForObject(String namedQueryId, Object parameterValue)
    {
        NamedQuery query = getNamedQuery(namedQueryId);
        String[] paramNames = new String[] {query.getSingleParameterName()};
        return queryForObject(query, paramNames, new Object[] {parameterValue});
    }

    public Object namedQueryForObject(String namedQueryId, String[] parameterNames, Object[] parameterValues)
	{
		NamedQuery query = getNamedQuery(namedQueryId);
		Class[] paramTypes = query.getParameterClassTypes(parameterNames);
		parameterValues = ConvertUtils.convert(parameterValues, paramTypes);
		return queryForObject(query, parameterNames, parameterValues);
	}
    

    
}
