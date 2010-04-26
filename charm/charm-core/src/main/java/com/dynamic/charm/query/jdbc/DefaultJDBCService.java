/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.

 * Copyright 2005, Dynamic Information Systems, LLC
 * $Id: DefaultJDBCService.java 412 2009-05-28 21:51:04Z bvonhaden $

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


package com.dynamic.charm.query.jdbc;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.jdbc.core.JdbcTemplate;

import com.dynamic.charm.query.AbstractDataService;
import com.dynamic.charm.query.DataService;
import com.dynamic.charm.query.NamedQuery;
import com.dynamic.charm.query.NamedQueryLoaderAware;
import com.dynamic.charm.query.QueryParameter;
import com.dynamic.charm.query.core.ParameterBundle;


/**
 * @author gcase
 *
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class DefaultJDBCService extends AbstractDataService implements DataService, JDBCService, NamedQueryLoaderAware
{
    private static final Logger logger = Logger.getLogger(DefaultJDBCService.class);
    private Map queryStorage = new HashMap();

    public JdbcTemplate getJDBCTemplate()
    {
        return new JdbcTemplate(getDataSource());
    }

    public void afterLoad()
	{
		queryStorage.clear();	
	}
    
    protected QueryParser retrieveQueryParser(NamedQuery namedQuery)
    {
        QueryParser result = (QueryParser) queryStorage.get(namedQuery.getId());
        if (result == null)
        {
            Map typeMap = namedQuery.getParameterMap();
            ParameterBundle bundle = new ParameterBundle();
            for (Iterator iter = typeMap.keySet().iterator(); iter.hasNext();)
            {
                String parameterName = (String) iter.next();
                QueryParameter qp = (QueryParameter) typeMap.get(parameterName);
                bundle.addParameter(parameterName, JDBCUtils.getJdbcType(qp.getTypeName()).intValue());
            }

            result = new QueryParser(namedQuery.getQuery(), bundle);
            queryStorage.put(namedQuery.getId(), result);
        }

        return result;
    }

    protected QueryParser retrieveQueryParser(String query)
    {
        QueryParser result = (QueryParser) queryStorage.get(query);
        if (result == null)
        {
            result = new QueryParser(query);
            queryStorage.put(query, result);
        }
        return result;
    }

    public List queryForListByPosition(String query, Object parameterValue)
    {
        logQuery(query, parameterValue);
        return getJDBCTemplate().queryForList(query, new Object[] { parameterValue });
    }

    public List queryForListByPosition(String query, Object parameterValue, int type)
    {
        logQuery(query, parameterValue);
        return getJDBCTemplate().queryForList(query, new Object[] { parameterValue }, new int[] { type });
    }

    public List queryForListByPosition(String query, Object[] parameterValues)
    {
        logQuery(query, parameterValues);
        return getJDBCTemplate().queryForList(query, parameterValues);
    }

    public List queryForListByPosition(String query, Object[] parameterValues, int[] types)
    {
        logQuery(query, parameterValues);
        return getJDBCTemplate().queryForList(query, parameterValues, types);
    }

    public List queryForListByPosition(String query, Object[] parameterValues, int[] types, Class entityType)
    {
        logQuery(query, parameterValues);
        return getJDBCTemplate().query(query, parameterValues, types, new EntityRowMapper(entityType));
    }

    public Object queryForObjectByPosition(String query, Object parameterValue)
    {
        logQuery(query, parameterValue);

        List results = getJDBCTemplate().queryForList(query, new Object[] { parameterValue });
        return getExactlyOneResult(results);
    }

    public Object queryForObjectByPosition(String query, Object parameterValue, int type)
    {
        logQuery(query, parameterValue);

        List results = getJDBCTemplate().queryForList(query, new Object[] { parameterValue }, new int[] { type });
        return getExactlyOneResult(results);
    }

    public Object queryForObjectByPosition(String query, Object[] parameterValues)
    {
        List results = getJDBCTemplate().queryForList(query, parameterValues);
        return getExactlyOneResult(results);
    }

    public Object queryForObjectByPosition(String query, String[] parameterNames,
        Object[] parameterValues, int[] types)
    {
        logQuery(query, parameterValues);

        List results = queryForList(query, parameterNames, parameterValues, types);
        return getExactlyOneResult(results);
    }

    public List queryForListByName(String query, String[] parameterNames, Object[] parameterValues,
        int[] types)
    {
        if (logger.isDebugEnabled())
        {
            logger.debug("Original query: " + query);
        }

        QueryParser qp = retrieveQueryParser(query);
        ParameterBundle bundle = qp.getParameterBundle();
        bundle.fillInValues(parameterNames, parameterValues);
        return queryForListByPosition(qp.getSql(), bundle.toValueArrayByPosition(), bundle.toTypeArrayByPosition());
    }

    /**
     * Needed to implement DataService
     */
    public List queryForList(NamedQuery query, String[] parameterNames, Object[] parameterValues)
    {
        if (logger.isDebugEnabled())
        {
            logger.debug("Original NamedQuery: " + query);
        }

        QueryParser qp = retrieveQueryParser(query);
        ParameterBundle bundle = qp.getParameterBundle();
        bundle.fillInValues(parameterNames, parameterValues);
        
        if (query.getEntityType() != null)
            return queryForListByPosition(qp.getSql(), bundle.toValueArrayByPosition(), bundle.toTypeArrayByPosition(), query.getEntityTypeClass());
        else
        	return queryForListByPosition(qp.getSql(), bundle.toValueArrayByPosition(), bundle.toTypeArrayByPosition());
    }

    /**
     * Needed to implement DataService
     */
    public List queryForList(String query, String[] parameterNames, Object[] parameterValues, int[] types)
    {
        return queryForListByName(query, parameterNames, parameterValues, types);
    }

    protected void logQuery(String query)
    {
        if (logger.isDebugEnabled())
        {
            logger.debug("Executing query: " + query);
        }
    }

    protected void logQuery(String query, Object parameterValue)
    {
        if (logger.isDebugEnabled())
        {
            logger.debug("Executing query: " + query);
            logger.debug("Expanded query: " + JDBCUtils.expandSQL(query, new Object[] { parameterValue }));
        }
    }

    protected void logQuery(String query, Object[] parameterValues)
    {
        if (logger.isDebugEnabled())
        {
            logger.debug("Executing query: " + query);
            logger.debug("Expanded query: " + JDBCUtils.expandSQL(query, parameterValues));
        }
    }

    public int update(String sql)
    {
        return getJDBCTemplate().update(sql);
    }

    public int update(String sql, Object[] parameterValues)
    {
        return getJDBCTemplate().update(sql, parameterValues);
    }

    public int update(String sql, Object[] parameterValues, int[] types)
    {
        return getJDBCTemplate().update(sql, parameterValues, types);
    }

	
}
