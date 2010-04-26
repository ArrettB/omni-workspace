/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.

 * Copyright 2005, Dynamic Information Systems, LLC
 * $Id: NamedQuery.java 412 2009-05-28 21:51:04Z bvonhaden $

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


package com.dynamic.charm.query;

import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import com.dynamic.charm.exception.CharmException;
import com.dynamic.charm.query.jdbc.JDBCUtils;


/**
 * @author gcase
 *
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class NamedQuery
{
    private String id;
    private String query;
    private Map parameterMap;
    private String service;
    private String parsedQuery;
    private String entityType;

    public NamedQuery()
    {
        parameterMap = new HashMap();
    }

    public String getId()
    {
        return id;
    }

    public void setId(String id)
    {
        this.id = id;
    }

    public String getQuery()
    {
        return query;
    }

    public void setQuery(String queryText)
    {
        this.query = queryText;
    }

    public void addQueryParameter(QueryParameter qp)
    {
        parameterMap.put(qp.getName(), qp);
    }

    public String toString()
    {
        return "<" + id + "> " + query;
    }

    public Map getParameterMap()
    {
        return Collections.unmodifiableMap(parameterMap);
    }

    public void setParameterMap(Map parameterTypeMap)
    {
        this.parameterMap = parameterTypeMap;
    }

    public String getService()
    {
        return service;
    }

    public void setService(String service)
    {
        this.service = service;
    }

    public int[] getParameterJDBCTypes(String[] parameterNames)
    {
        if (parameterNames.length != parameterMap.size())
        {
            throw new CharmException("Size of parameter names does not match internal size");
        }

        int[] result = new int[parameterNames.length];
        for (int i = 0; i < result.length; i++)
        {
            QueryParameter qp = getQueryParameter(parameterNames[i]);
            if (qp == null)
            {
                throw new CharmException("Parameter " + parameterNames[i] + " not defined in namedQuery: " + this.toString());
            }

            Integer jdbctype = JDBCUtils.getJdbcType(qp.getTypeName());
            if (jdbctype == null)
            {
                throw new CharmException("Unrecognized parameter type " + qp.getTypeName());
            }
            result[i] = jdbctype.intValue();
        }
        return result;
    }


    public Class[] getParameterClassTypes(String[] parameterNames)
    {
        if (parameterNames.length != parameterMap.size())
        {
            throw new CharmException("Size of parameter names does not match internal size");
        }

        Class[] result = new Class[parameterNames.length];
        for (int i = 0; i < result.length; i++)
        {
            QueryParameter qp = getQueryParameter(parameterNames[i]);
            if (qp == null)
            {
                throw new CharmException("Parameter " + parameterNames[i] + " not defined in namedQuery: " + this.toString());
            }

			try
			{
				String typeName = qp.getTypeName();
				if ("Date".equalsIgnoreCase(typeName))
				{
					result[i] = Date.class;
				}
				else
				{
					if (typeName.indexOf(".") < 0)
					{
						typeName = "java.lang." + com.dynamic.charm.common.StringUtils.capitalize(typeName.toLowerCase());
					}
					Class type = Class.forName(typeName);
					result[i] = type;
				}
				
			}
			catch (ClassNotFoundException e)
			{
				throw new CharmException("Unrecognized parameter type " + qp.getTypeName(), e);
			}

        }
        return result;
    }

    /**
     *
     * 
     * @return the class for the specified entity type.
     */
    public Class getEntityTypeClass()
    {
		Class type = null;
		try
		{
			type = Class.forName(entityType);
    	}
    	catch (ClassNotFoundException e)
    	{
    		throw new CharmException("Entity type " + entityType, e);
    	}
    	
		return type;
    }


    public QueryParameter getQueryParameter(String parameterName)
    {
        return (QueryParameter) parameterMap.get(parameterName);
    }

    public String getSingleParameterName()
    {
        if (parameterMap.size() == 1)
        {
            return (String) parameterMap.keySet().iterator().next();
        }
        else
        {
            throw new CharmException("NamedQuery does not contain exactly one parameter, namedQuery:" + this.toString());
        }
    }

	public String getParsedQuery()
	{
		return parsedQuery;
	}

	public void setParsedQuery(String parsedQuery)
	{
		this.parsedQuery = parsedQuery;
	}

	public String getEntityType()
	{
		return entityType;
	}

	public void setEntityType(String entityType)
	{
		this.entityType = entityType;
	}
}
