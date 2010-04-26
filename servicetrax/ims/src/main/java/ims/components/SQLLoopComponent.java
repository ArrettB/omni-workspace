// Decompiled by Jad v1.5.8f. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) 
// Source File Name:   SQLLoopComponent.java

package ims.components;

import ims.helpers.IMSUtil;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.templates.TemplateComponent;
import dynamic.util.string.StringUtil;

public class SQLLoopComponent extends TemplateComponent
{

    public SQLLoopComponent()
        throws Exception
    {
        headerComponent = null;
        footerComponent = null;
        noDataComponent = null;
        moreRowsComponent = null;
        registerRequiredAttribute("query");
        registerAttribute("alternator1", null);
        registerAttribute("alternator2", null);
        registerAttribute("filter", "");
        registerAttribute("maxRows", "0");
        registerAttribute("name", "q1");
        registerAttribute("resourceName", null);
        requiresEndTag();
        allowsExtendedAttributes();
    }

    public void addComponent(TemplateComponent child)
        throws Exception
    {
        if(child.getName().equalsIgnoreCase("SQLHEADER"))
            headerComponent = child;
        else
        if(child.getName().equalsIgnoreCase("SQLFOOTER"))
            footerComponent = child;
        else
        if(child.getName().equalsIgnoreCase("SQLNODATA"))
            noDataComponent = child;
        else
        if(child.getName().equalsIgnoreCase("SQLMOREROWS"))
            moreRowsComponent = child;
        else
            super.addComponent(child);
    }

    public String includeInternal(InvocationContext ic)
        throws Exception
    {
        StringBuffer result = new StringBuffer();
        ConnectionWrapper conn = null;
        PreparedStatement pstmt = null;
        try
        {
            String alt1 = getString(ic, "alternator1");
            String alt2 = getString(ic, "alternator2");
            String filter = getString(ic, "filter");
            String name = getString(ic, "name");
            int maxRowCount = getInt(ic, "maxRows");
            String query = getString(ic, "query");
            String resourceName = getString(ic, "resourceName");
            String alt1_1 = null;
            String alt1_2 = null;
            if(alt1 != null && alt1.length() > 0)
            {
                Vector tvect = StringUtil.stringToVector(alt1, ':');
                alt1_1 = (String)tvect.elementAt(0);
                alt1_2 = (String)tvect.elementAt(1);
            }
            String alt2_1 = null;
            String alt2_2 = null;
            if(alt2 != null && alt2.length() > 0)
            {
                Vector tvect = StringUtil.stringToVector(alt2, ':');
                alt2_1 = (String)tvect.elementAt(0);
                alt2_2 = (String)tvect.elementAt(1);
            }
            conn = (ConnectionWrapper)ic.getResource(resourceName);
            int rowid = 0;
            ic.setTransientDatum(name + ":rowid", "0");
            if(filter.length() > 0)
                query = ic.processFilter(query, filter);
//            QueryResults rs = conn.resultsQueryEx(query);
            
            // new prepared statement code
            pstmt = IMSUtil.queryToPreparedStatement(conn, new StringBuffer(query));
            ResultSet psRS = pstmt.executeQuery();
            QueryResults rs = new QueryResults(conn, pstmt, psRS);
            
            ic.setTransientDatum(CURSOR_VAR_PREFIX + name, rs);
            while(rs.next()) 
            {
                if(rowid == 0 && headerComponent != null)
                    result.append(headerComponent.include(ic));
                rowid++;
                ic.setTransientDatum(name + ":rowid", "" + rowid);
                if(rowid % 2 == 0)
                {
                    if(alt1_2 != null)
                        ic.setTransientDatum(name + ":alt1", alt1_2);
                    if(alt2_2 != null)
                        ic.setTransientDatum(name + ":alt2", alt2_2);
                } else
                {
                    if(alt1_1 != null)
                        ic.setTransientDatum(name + ":alt1", alt1_1);
                    if(alt2_1 != null)
                        ic.setTransientDatum(name + ":alt2", alt2_1);
                }
                result.append(includeChildren(ic));
                if(maxRowCount != 0 && rowid >= maxRowCount)
                    break;
            }
            rs.close();
            if(rowid == 0 && noDataComponent != null)
                result.append(noDataComponent.include(ic));
            if(rowid != 0 && footerComponent != null)
                result.append(footerComponent.include(ic));
            if(maxRowCount != 0 && rowid >= maxRowCount && moreRowsComponent != null)
                result.append(moreRowsComponent.include(ic));
            rowid++;
            ic.setTransientDatum(name + ":rowid", "" + rowid);
        }
        finally
        {
         	if(pstmt != null)
         		pstmt.close();        	
            if(conn != null)
                conn.release();
        }
        return result.toString();
    }

    public static String CURSOR_VAR_PREFIX = "__cursor:";
    private TemplateComponent headerComponent;
    private TemplateComponent footerComponent;
    private TemplateComponent noDataComponent;
    private TemplateComponent moreRowsComponent;

}
