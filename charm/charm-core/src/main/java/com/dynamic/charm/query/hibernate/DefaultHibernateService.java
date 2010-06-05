package com.dynamic.charm.query.hibernate;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;

import javax.sql.DataSource;

import org.apache.commons.lang.ArrayUtils;
import org.hibernate.FlushMode;
import org.hibernate.SessionFactory;
import org.hibernate.classic.Session;
import org.hibernate.metadata.ClassMetadata;
import org.hibernate.type.NullableType;
import org.hibernate.type.Type;
import org.springframework.beans.BeanWrapperImpl;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import com.dynamic.charm.exception.CharmException;
import com.dynamic.charm.query.NamedQuery;

public class DefaultHibernateService extends HibernateDaoSupport implements HibernateService
{
	protected DataSource dataSource;
	protected boolean isDefault;
	protected String defaultPackage;

	protected HibernateTemplate createHibernateTemplate(SessionFactory sessionFactory)
	{
		return new CharmTemplate(sessionFactory);
	}
	
	public DataSource getDataSource()
	{
		return dataSource;
	}

	public void setDataSource(DataSource dataSource)
	{
		this.dataSource = dataSource;
	}

	public List queryForList(String query)
	{
		return queryForList(query, ArrayUtils.EMPTY_STRING_ARRAY, ArrayUtils.EMPTY_OBJECT_ARRAY, null);
	}

	public List queryForList(String query, String parameterName, Object parameterValue)
	{
		return queryForList(query, new String[] { parameterName }, new Object[] { parameterValue }, null);
	}

	public List queryForList(String query, String parameterName, Object parameterValue, int parameterType)
	{
		return queryForList(query, new String[] { parameterName }, new Object[] { parameterValue }, new int[] { parameterType });
	}

	public List queryForList(NamedQuery query)
	{
		return queryForList(query, ArrayUtils.EMPTY_STRING_ARRAY, ArrayUtils.EMPTY_OBJECT_ARRAY);
	}

	public List queryForList(NamedQuery query, Object parameterValue)
	{
		String parameterName = query.getSingleParameterName();
		return queryForList(query, new String[] { parameterName }, new Object[] { parameterValue });
	}

	public Object queryForObject(String query)
	{
		return queryForObject(query, ArrayUtils.EMPTY_STRING_ARRAY, ArrayUtils.EMPTY_OBJECT_ARRAY, null);
	}

	public Object queryForObject(String query, String parameterName, Object parameterValue)
	{
		return queryForObject(query, new String[] { parameterName }, new Object[] { parameterValue }, null);
	}

	public Object queryForObject(String query, String parameterName, Object parameterValue, int parameterType)
	{
		return queryForObject(query, new String[] { parameterName }, new Object[] { parameterValue }, new int[] { parameterType });
	}

	public Object queryForObject(String query, String[] parameterNames, Object[] parameterValues, int[] types)
	{
		List results = queryForList(query, parameterNames, parameterValues, types);
		return getExactlyOneResult(results);
	}

	public Object queryForObject(NamedQuery query)
	{
		return queryForObject(query, ArrayUtils.EMPTY_STRING_ARRAY, ArrayUtils.EMPTY_OBJECT_ARRAY);
	}

	public Object queryForObject(NamedQuery query, Object parameterValue)
	{
		String parameterName = query.getSingleParameterName();
		return queryForObject(query, new String[] { parameterName }, new Object[] { parameterValue });
	}

	public Object queryForObject(NamedQuery query, String[] parameterNames, Object[] parameterValues)
	{
		List results = queryForList(query, parameterNames, parameterValues);
		return getExactlyOneResult(results);
	}

	protected Object getExactlyOneResult(List results)
	{
		if (results.size() == 1)
		{
			return results.get(0);
		}
		else if (results.size() > 1)
		{
			throw new CharmException("1 result was requested, and the query returned more than 1 result.");
		}
		return null;
	}

	public boolean getIsDefault()
	{
		return isDefault;
	}

	public void setIsDefault(boolean isDefault)
	{
		this.isDefault = isDefault;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.dynamic.charm.query.AbstractDataService#queryForList(java.lang.String,
	 *      java.lang.String[], java.lang.Object[], int[])
	 */
	public List queryForList(String query, String[] parameterNames, Object[] parameterValues, int[] types)
	{
		if (logger.isInfoEnabled())
		{
			logger.info("Executing query:" + query);
			for (int i = 0; i < parameterValues.length; i++)
			{
				logger.info(parameterNames[i] + " = '" + parameterValues[i] + "'");
			}
		}
		return getHibernateTemplate().findByNamedParam(query, parameterNames, parameterValues);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.dynamic.charm.query.AbstractDataService#queryForList(com.dynamic.charm.query.NamedQuery,
	 *      java.lang.String[], java.lang.Object[], int[])
	 */
	public List queryForList(NamedQuery namedQuery, String[] parameterNames, Object[] parameterValues)
	{
		if (logger.isInfoEnabled())
		{
			logger.info("Executing query:" + namedQuery.getQuery());
			for (int i = 0; i < parameterValues.length; i++)
			{
				logger.info(parameterNames[i] + " = '" + parameterValues[i] + "'");
			}
		}
		return getHibernateTemplate().findByNamedParam(namedQuery.getQuery(), parameterNames, parameterValues);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.dynamic.charm.query.hibernate.HibernateService2#get(java.lang.Class,
	 *      java.io.Serializable)
	 */
	public Object get(Class entityClass, Serializable id)
	{
		id = convertIdentifier(entityClass, id);
		logger.info("Getting " + entityClass.getName() + ", identifier = " + id);
		return getHibernateTemplate().get(entityClass, id);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.dynamic.charm.query.hibernate.HibernateService2#load(java.lang.Class,
	 *      java.io.Serializable)
	 */
	public Object load(Class entityClass, Serializable id)
	{
		id = convertIdentifier(entityClass, id);
		logger.info("Loading " + entityClass.getName() + ", identifier = " + id);
		return getHibernateTemplate().load(entityClass, id);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.dynamic.charm.query.hibernate.HibernateService2#save(java.lang.Object)
	 */
	public Object save(Object instance)
	{
		getHibernateTemplate().save(instance);
		return instance;
	}

	public Object update(Object instance)
	{
		getHibernateTemplate().update(instance);
		return instance;
	}

	public Object saveOrUpdate(Object instance)
	{
		getHibernateTemplate().saveOrUpdate(instance);
		return instance;
	}

	public void delete(Object instance)
	{
		getHibernateTemplate().delete(instance);
	}

	public void deleteAll(Collection entities)
	{
		if (entities != null)
		{
			getHibernateTemplate().deleteAll(entities);
		}
	}

	public Object merge(Object instance)
	{
		return getHibernateTemplate().merge(instance);
	}

	protected Serializable convertIdentifier(Class entityClass, Serializable id)
	{
		ClassMetadata meta = getSessionFactory().getClassMetadata(entityClass);
		Type identifierType = meta.getIdentifierType();
		if (!identifierType.getReturnedClass().equals(id.getClass()))
		{
			if (identifierType instanceof NullableType)
			{
				logger.debug("Converting from " + id.getClass() + " to " + identifierType.getReturnedClass());
				id = (Serializable) ((NullableType) identifierType).fromStringValue(id.toString());
			}
		}
		return id;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.dynamic.charm.query.hibernate.HibernateService2#getIdentifier(java.lang.Object)
	 */
	public Serializable getIdentifier(Class entityClass, Object object)
	{
		ClassMetadata meta = getSessionFactory().getClassMetadata(entityClass);
		String propName = meta.getIdentifierPropertyName();
		BeanWrapperImpl bw = new BeanWrapperImpl(object);
		return (Serializable) bw.getPropertyValue(propName);
	}

	public String getIdentifierName(Class entityClass)
	{
		ClassMetadata meta = getSessionFactory().getClassMetadata(entityClass);
		return meta.getIdentifierPropertyName();
	}

	public boolean isNewObject(Class entityClass, Object instance)
	{
		return (getIdentifier(entityClass, instance) == null);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.dynamic.charm.query.hibernate.HibernateService2#supports(java.lang.Class)
	 */
	public boolean supports(Class entityClass)
	{
		ClassMetadata meta = getSessionFactory().getClassMetadata(entityClass);
		return (meta != null);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.dynamic.charm.query.hibernate.HibernateService2#resolveClassName(java.lang.String)
	 */
	public String resolveClassName(String className)
	{
		boolean isQualified = (className.indexOf(".") >= 0);
		String result = null;
		if (isQualified)
		{
			result = className;
		}
		else if (defaultPackage == null)
		{
			throw new CharmException("Can not determine a fully generated classname, default package is not set.  Add <property name=\"defaultPackage\" value=\"com.dynamic....\" /> element to the <hibernateService> element in your application-context.xml");
		}
		else if (defaultPackage.endsWith("."))
		{
			result = defaultPackage + className;
		}
		else
		{
			result = defaultPackage + "." + className;
		}
		return result;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.dynamic.charm.query.hibernate.HibernateService2#resolveClass(java.lang.String)
	 */
	public Class resolveClass(String classname) throws ClassNotFoundException
	{
		return Class.forName(resolveClassName(classname));
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.dynamic.charm.query.hibernate.HibernateService2#getDefaultPackage()
	 */
	public String getDefaultPackage()
	{
		return defaultPackage;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.dynamic.charm.query.hibernate.HibernateService2#setDefaultPackage(java.lang.String)
	 */
	public void setDefaultPackage(String defaultPackage)
	{
		this.defaultPackage = defaultPackage;
	}

    public void saveOrUpdateAll(Collection collection) {
        HibernateTemplate template = getHibernateTemplate();
        Session session = template.getSessionFactory().getCurrentSession();
        session.setFlushMode(FlushMode.AUTO);
        getHibernateTemplate().saveOrUpdateAll(collection);
    }

    public List findAll(Class entityClass)
	{
		String query = "from " + entityClass.getName() + " as foo";
		return getHibernateTemplate().find(query);
	}

	public Object execute(HibernateCallback callback)
	{
		return getHibernateTemplate().execute(callback);
	}

}
