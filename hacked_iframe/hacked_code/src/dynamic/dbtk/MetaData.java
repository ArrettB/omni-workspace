/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) radix(10) lradix(10) 
// Source File Name:   MetaData.java

package dynamic.dbtk;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import java.sql.*;
import java.util.Hashtable;
import java.util.Vector;

// Referenced classes of package dynamic.dbtk:
//            MetaDataColumn

public class MetaData
{

    private void init(ResultSetMetaData meta)
        throws SQLException
    {
        for(int i = 1; i <= meta.getColumnCount(); i++)
            columns.addElement(new MetaDataColumn(meta, i));

    }

    public MetaData()
    {
        columns = new Vector();
    }

    public MetaData(ResultSetMetaData meta)
        throws SQLException
    {
        columns = new Vector();
        init(meta);
    }

    public MetaData(ConnectionWrapper conn, String table)
        throws SQLException
    {
        columns = new Vector();
        String query = "SELECT * FROM " + table + " WHERE NULL = NULL ";
        QueryResults rs = conn.resultsQueryEx(query);
        init(rs.getMetaData());
        rs.close();
    }

    public String toString()
    {
        StringBuffer sb = new StringBuffer();
        for(int i = 0; i < columns.size(); i++)
            sb.append(columns.elementAt(i).toString() + "\n");

        return sb.toString();
    }

    public int getColumnCount()
    {
        return columns.size();
    }

    public MetaDataColumn findMetaDataColumn(int x)
    {
        if(x >= 1 && x <= columns.size())
            return (MetaDataColumn)columns.elementAt(x - 1);
        else
            return new MetaDataColumn();
    }

    public String getColumnName(int x)
    {
        return findMetaDataColumn(x).getColumnName();
    }

    public String getColumnTypeName(int x)
    {
        return findMetaDataColumn(x).getColumnTypeName();
    }

    public int getColumnDisplaySize(int x)
    {
        return findMetaDataColumn(x).getColumnDisplaySize();
    }

    public boolean isColumnMandatory(int x)
    {
        return findMetaDataColumn(x).isColumnMandatory();
    }

    public int findColumn(String name)
    {
        for(int i = 1; i <= getColumnCount(); i++)
            if(getColumnName(i).equalsIgnoreCase(name))
                return i;

        return 0;
    }

    public String getColumnTypeName(String column)
    {
        return getColumnTypeName(findColumn(column));
    }

    public int getColumnDisplaySize(String column)
    {
        return getColumnDisplaySize(findColumn(column));
    }

    public boolean isColumnMandatory(String column)
    {
        return isColumnMandatory(findColumn(column));
    }

    public static boolean isView(InvocationContext ic, ConnectionWrapper conn, String aTableName, String aSchema)
    {
        boolean bRet = false;
        if(conn != null)
        {
            Hashtable list_of_views = (Hashtable)ic.getSessionDatum(conn.getName().toLowerCase() + ":list_of_views");
            if(list_of_views == null)
            {
                list_of_views = new Hashtable();
                try
                {
                    DatabaseMetaData db_metadata = conn.getMetaData();
                    String types[] = new String[1];
                    types[0] = "VIEW";
                    for(ResultSet table_names = db_metadata.getTables(null, aSchema, "%", types); table_names.next();)
                        if(table_names.getString("TABLE_TYPE").equalsIgnoreCase("view"))
                            list_of_views.put(table_names.getString("TABLE_NAME").toLowerCase(), "");

                    ic.setSessionDatum(conn.getName().toLowerCase() + ":list_of_views", list_of_views);
                }
                catch(Exception e)
                {
                    ErrorHandler.handleException(ic, e, "MetaData.isView() failed to get DatabaseMetaData from conneection.");
                }
                finally
                {
                    conn.releaseResource();
                }
            }
            bRet = list_of_views.containsKey(aTableName.toLowerCase());
        }
        return bRet;
    }

    private Vector columns;
}



/***** DECOMPILATION REPORT *****

	DECOMPILED FROM: C:\Documents and Settings\dzhao.APEXIT.000\.m2\repository\com\dynamic\iFrame2-ims\1.1\iFrame2-ims-1.1.jar


	TOTAL TIME: 31 ms


	JAD REPORTED MESSAGES/ERRORS:


	EXIT STATUS:	0


	CAUGHT EXCEPTIONS:

 ********************************/