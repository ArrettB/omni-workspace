/*
 *               ApexIT, Inc.
 *
 * This software can only be used with the expressed written
 * consent of ApexIT, Inc. All rights reserved.
 *
 * Copyright 2009 ApexIT, Inc.
 * $Id: EntityRowMapper.java 412 2009-05-28 21:51:04Z bvonhaden $
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL APEXIT, INC.
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

import java.lang.reflect.InvocationTargetException;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.jdbc.core.RowMapper;

/**
 * Used by the JDBC Service to populate a bean from an SQL call.
 * 
 * This does a very simple mapping of the SQL columns to the appropriate
 * properties on the bean.
 * 
 * @version $Id: EntityRowMapper.java 412 2009-05-28 21:51:04Z bvonhaden $
 */
public final class EntityRowMapper implements RowMapper
{
//	private final static Logger logger = Logger.getLogger(EntityRowMapper.class);
	Class entityType;

	public EntityRowMapper(Class entityType)
	{
		this.entityType = entityType;
	}

	public Object mapRow(ResultSet rs, int rowNum) throws SQLException
	{
		Object result = null;
		try
		{
			result = entityType.newInstance();
			ResultSetMetaData meta = rs.getMetaData();
			
			for (int i = 1; i < meta.getColumnCount(); i++)
			{
				String colName = meta.getColumnName(i);
				Object val = rs.getObject(i);
				if (val != null)
					BeanUtils.copyProperty(result, toParameter(colName), val);
			}
		}
		catch (InstantiationException e)
		{
			throw new SQLException("Unable to retrieve data: " + e.toString());
		}
		catch (IllegalAccessException e)
		{
			throw new SQLException("Unable to retrieve data: " + e.toString());
		}
		catch (InvocationTargetException e)
		{
			throw new SQLException("Unable to convert data to object: " + e.toString());
		}
		return result;
	}

	/**
	 * Format the database column format to a Java parameter format.
	 * 
	 * @param txt
	 * @return
	 */
	String toParameter(String txt)
	{
		StringBuffer result = new StringBuffer(txt.toLowerCase());
		
		int idx = result.indexOf("_");
		do
		{
			if (idx > 0)
			{
				String upp = "";
				if (result.length() > idx + 2)
				{
					upp = result.substring(idx+1, idx+2).toUpperCase();
				}
				result.replace(idx, idx+2, upp);
				idx = result.indexOf("_");
			}
		} while (idx > 0);
		
		return result.toString();
	}

}
