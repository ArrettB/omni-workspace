/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: QueryService.java 365 2009-02-02 16:35:44Z bvonhaden $

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
import java.util.List;
import java.util.Map;

import com.dynamic.charm.exception.CharmException;
import com.dynamic.charm.query.DataService;
import com.dynamic.charm.query.NamedQuery;
import com.dynamic.charm.query.NamedQueryLoader;
import com.dynamic.charm.query.hibernate.HibernateService;
import com.dynamic.charm.query.jdbc.JDBCService;


public interface QueryService extends DataService
{
    public static final String DEFAULT_QUERY_SERVICE_NAME = "queryService";
    public static final String DEFAULT_HIBERNATE_SERVICE_NAME = "hibernateService";
    public static final String DEFAULT_JDBC_SERVICE_NAME = "jdbcService";

    public NamedQuery getNamedQuery(String identifier) throws CharmException;

    public DataService getDataService(String dataServiceName);

    public DataService getDefaultService();

    public HibernateService getHibernateService();
    public JDBCService getJdbcService();

    public Map getDataServices();

    public void setDataServices(Map dataServices);

    public NamedQueryLoader getNamedQueryLoader();

    public void setNamedQueryLoader(NamedQueryLoader namedQueryLoader);

    public List queryForList(String serviceName, String query, String[] parameterNames,
        Object[] parameterValues, int[] types);

    public Object get(Class entityClass, Serializable id);

    public Object load(Class entityClass, Serializable id);

    public void save(Object saveMe);

    public void update(Object updateMe);

    public void saveOrUpdate(Object saveOrUpdateMe);

    public void delete(Object deleteMe);

    public void deleteAll(Collection deleteMe);

    /**
     *  Using the namedQueryId, this will grab the NamedQuery instance, and then execute it.
     *  @param namedQueryId The id of the NamedQuery, as defined in one of the namedQueryFiles
     *  @result the results of the query
     */
    public List namedQueryForList(String namedQueryId);

    /**
     *  Using the namedQueryId, this will grab the NamedQuery instance, and then execute it.
     *  @param namedQueryId The id of the NamedQuery, as defined in one of the namedQueryFiles
     *  @param parameterValue The value of the parameter, when the NamedQuery only contains a single parameter
     *  @result the results of the query
     */
    public List namedQueryForList(String namedQueryId, Object parameterValue);

    /**
     *  Using the namedQueryId, this will grab the NamedQuery instance, and then execute it.
     *  @param namedQueryId The id of the NamedQuery, as defined in one of the namedQueryFiles
     *  @param parameterNames an array of parameter names, which need to match the NamedQuery definition
     *  @param parameterValues an array of parameter values, one for each parameterName
     *  @result the results of the query
     */
    public List namedQueryForList(String namedQueryId, String[] parameterNames,
        Object[] parameterValues);

    /**
     *  Using the namedQueryId, this will grab the NamedQuery instance, and then execute it.
     *  @param namedQueryId The id of the NamedQuery, as defined in one of the namedQueryFiles
     *  @result the result of the query, null if not found
     */
    public Object namedQueryForObject(String namedQueryId);

    /**
     *  Using the namedQueryId, this will grab the NamedQuery instance, and then execute it.
     *  @param namedQueryId The id of the NamedQuery, as defined in one of the namedQueryFiles
     *  @param parameterValue The value of the parameter, when the NamedQuery only contains a single parameter
     *  @result the result of the query, null if not found
     */
    public Object namedQueryForObject(String namedQueryId, Object parameterValue);

    /**
     *  Using the namedQueryId, this will grab the NamedQuery instance, and then execute it.
     *  @param namedQueryId The id of the NamedQuery, as defined in one of the namedQueryFiles
     *  @param parameterNames an array of parameter names, which need to match the NamedQuery definition
     *  @param parameterValues an array of parameter values, one for each parameterName
     *  @result the result of the query, null if not found
     */
    public Object namedQueryForObject(String namedQueryId, String[] parameterNames,
        Object[] parameterValues);
}
