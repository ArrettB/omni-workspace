/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: CharmTemplate.java 210 2006-12-11 17:54:08Z gcase $

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


package com.dynamic.charm.query.hibernate;

import java.util.ArrayList;
import java.util.List;
import java.util.TreeMap;

import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.HibernateTemplate;


public class CharmTemplate extends HibernateTemplate
{
    public CharmTemplate(SessionFactory sessionFactory)
    {
        super(sessionFactory);
    }

    public List findByNamedParam(final String queryString, final String[] paramNames, final Object[] values) throws DataAccessException
	{
		if (paramNames.length != values.length)
		{
			throw new IllegalArgumentException("Length of paramNames array must match length of values array");
		}
		
		return (List) execute(new HibernateCallback()
		{
			public Object doInHibernate(Session session) throws HibernateException
			{
				Query queryObject = session.createQuery(queryString);
				queryObject.setCacheable(true);
				prepareQuery(queryObject);
				if (values != null)
				{
					for (int i = 0; i < values.length; i++)
					{
						applyNamedParameterToQuery(queryObject, paramNames[i], values[i]);
					}
				}
				return convertyQueryResults(queryObject);
			}
		}, true);
	}

    public List findByNamedParam(final String queryString, final String[] paramNames, final Object[] values, final int offset, final int pageSize) throws DataAccessException
	{
		if (paramNames.length != values.length)
		{
			throw new IllegalArgumentException("Length of paramNames array must match length of values array");
		}
		
		return (List) execute(new HibernateCallback()
		{
			public Object doInHibernate(Session session) throws HibernateException
			{
				Query queryObject = session.createQuery(queryString);
				queryObject.setCacheable(true);
				queryObject.setFirstResult(offset);
				queryObject.setMaxResults(pageSize);
				prepareQuery(queryObject);
				if (values != null)
				{
					for (int i = 0; i < values.length; i++)
					{
						applyNamedParameterToQuery(queryObject, paramNames[i], values[i]);
					}
				}
				return convertyQueryResults(queryObject);
			}
		}, true);
	}
    
    
    protected List convertyQueryResults(Query query)
    {
        List original = query.list();

        if ((original == null) || (original.size() == 0))
        {
            return original;
        }

        Object firstRow = original.get(0);
        if (firstRow instanceof Object[])
        {
            String[] columnNames = query.getReturnAliases();

            List converted = new ArrayList(original.size());
            for (int i = 0, n = original.size(); i < n; i++)
            {
                Object[] row = (Object[]) original.get(i);
                TreeMap convertedRow = new TreeMap();
                converted.add(convertedRow);
                for (int j = 0; j < columnNames.length; j++)
                {
                    convertedRow.put(columnNames[j], row[j]);
                }
            }
            return converted;
        }
        else
        {
            return original;
        }
    }
}
