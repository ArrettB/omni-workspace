/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.

 * Copyright 2005, Dynamic Information Systems, LLC
 * $Id: JDBCUtils.java 207 2006-12-08 20:17:40Z gcase $

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

import java.io.IOException;
import java.io.Reader;
import java.lang.reflect.Field;
import java.sql.Clob;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.collections.map.CaseInsensitiveMap;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Logger;
import org.springframework.jdbc.core.SqlTypeValue;


/**
 * @author gcase
 *
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class JDBCUtils
{
    static Map nameToTypeMap;
    static Map typeToNameMap;
    private static final Logger logger = Logger.getLogger(JDBCUtils.class);
    
    
    public static void main(String[] args)
	{
		System.out.println(getJdbcType(("String")));
		System.out.println(getJdbcType(("Date")));
		System.out.println(getJdbcTypeName(java.sql.Types.DATE));
		System.out.println(getJdbcTypeName(java.sql.Types.VARCHAR));
		
		System.out.println(java.sql.Date.valueOf("11/24/2006"));
	}
    
    private static void addToMaps(String typeName, Integer typeValue)
    {
        typeToNameMap.put(typeValue, typeName);
        nameToTypeMap.put(typeName, typeValue);
    }

    private static void addToMaps(String typeName, int typeValue)
    {
    	addToMaps(typeName, new Integer(typeValue));
    }
   
    private static void initMaps()
    {
        typeToNameMap = new CaseInsensitiveMap();
        nameToTypeMap = new CaseInsensitiveMap();

        Field[] fields = java.sql.Types.class.getFields();

        for (int i = 0; i < fields.length; i++)
        {
            try
            {
                // Get field name
                String typeName = fields[i].getName();

                // Get field value
                Integer typeValue = (Integer) fields[i].get(null);

                // Add to maps
               addToMaps(typeName, typeValue);
                
            }
            catch (IllegalAccessException e)
            {
            }
        }

        addToMaps("string", Types.VARCHAR);
        addToMaps("long", Types.BIGINT);
        addToMaps("date", Types.DATE);
 
		addToMaps(String.class.getName(), Types.VARCHAR);
        addToMaps(Date.class.getName(), Types.DATE);
		addToMaps(Integer.class.getName(), Types.INTEGER);
		addToMaps(Long.class.getName(), Types.BIGINT);
		addToMaps(Float.class.getName(), Types.FLOAT);
		addToMaps(Double.class.getName(), Types.DOUBLE);

		
        addToMaps("UNKNOWN", SqlTypeValue.TYPE_UNKNOWN);
    
        System.out.println(nameToTypeMap);
    
    }

    /**
     * This method returns the name of a JDBC type. Returns null if jdbcType is
     * not recognized.
     */
    public static String getJdbcTypeName(int jdbcType)
    {
        if (typeToNameMap == null)
        {
            initMaps();
        }

        // Return the JDBC type name
        return (String) typeToNameMap.get(new Integer(jdbcType));
    }

    /**
     * This method returns the name of a JDBC type. Returns null if jdbcType is
     * not recognized.
     */
    public static Integer getJdbcType(String typeName)
    {
        if (nameToTypeMap == null)
        {
            initMaps();
        }

        // Return the JDBC type name
        return (Integer) nameToTypeMap.get(typeName);
    }

    public static String expandSQL(String sql, Object[] params)
    {
        StringBuffer buffer = new StringBuffer(sql);

        String s;
        int pos = 0;
        for (int i = 0; (params != null) && (i < params.length); i++)
        {
            Object o = params[i];
            if (o instanceof String)
            {
                s = "'" + toSQLString((String) o) + "'";
            }
            else if (o instanceof Date)
            {
                s = toSQLString((Date) o);
            }
            else if (o == null)
            {
                s = "NULL";
            }
            else
            {
                s = o.toString();
            }

            pos = buffer.indexOf("?", pos);
            if (pos > 0)
            {
                buffer.replace(pos, pos + 1, s);
                pos += s.length();
            }
            else
            {
                logger.warn("Too many parameters to expand into SQL Statement: params.length = " + params.length + ", statement = " + sql);
                break;
            }
        }
        // if (params != null && params.length > 0)
        // sb.append(" --
        // params=").append(StringUtil.arrayToString(params,","));

        return buffer.toString();
    }

    protected static String toSQLString(String s)
    {
        return StringEscapeUtils.escapeSql(s);
    }

    protected static String toSQLString(Date d)
    {
        return StringEscapeUtils.escapeSql(d.toString());
    }

    public static void closeQuietly(Connection conn)
    {
        if (conn != null)
        {
            try
            {
                conn.close();
            }
            catch (SQLException ignored)
            {
            }
        }
    }

    public static void closeQuietly(Statement stmt)
    {
        if (stmt != null)
        {
            try
            {
                stmt.close();
            }
            catch (SQLException ignored)
            {
            }
        }
    }

    public static void closeQuietly(ResultSet rs)
    {
        if (rs != null)
        {
            try
            {
                rs.close();
            }
            catch (SQLException ignored)
            {
            }
        }
    }

    public static void closeQuietly(Connection conn, ResultSet rs)
    {
        closeQuietly(rs);
        closeQuietly(conn);
    }

    public static String clobToString(Clob clob)
    {
        if (clob == null)
        {
            return null;
        }

        StringBuffer buffer = new StringBuffer();

        Reader clobReader = null;
        try
        {
            clobReader = clob.getCharacterStream();

            int bytesRead = 0;
            char[] charbuffer = new char[4096];
            while ((bytesRead = clobReader.read(charbuffer)) != -1)
            {
                buffer.append(charbuffer, 0, bytesRead);
            }
        }
        catch (SQLException e)
        {
            logger.error("Exception reading clob", e);
        }
        catch (IOException e)
        {
            logger.error("Exception reading clob", e);
        }
        finally
        {
            IOUtils.closeQuietly(clobReader);
        }

        return buffer.toString();
    }
}
