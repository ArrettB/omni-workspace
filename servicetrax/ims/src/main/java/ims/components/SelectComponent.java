// Decompiled by Jad v1.5.8f. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) 
// Source File Name:   SelectComponent.java

package ims.components;

import ims.helpers.IMSUtil;

import java.sql.PreparedStatement;
import java.sql.ResultSet;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.templates.TemplateComponent;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class SelectComponent extends TemplateComponent
{

    public SelectComponent()
        throws Exception
    {
        registerRequiredAttribute("name");
        registerRequiredAttribute("query");
        registerAttribute("autoSelect", "false");
        registerAttribute("currentValue", "-1");
        registerAttribute("filter", "");
        registerAttribute("firstOption", null);
        registerAttribute("firstOptionValue", "XXX");
        registerAttribute("hide", "false");
        registerAttribute("lastOption", null);
        registerAttribute("lastOptionValue", "YYY");
        registerAttribute("resourceName", null);
        allowsExtendedAttributes();
    }

    public String includeInternal(InvocationContext ic)
        throws Exception
    {
        StringBuffer result = new StringBuffer();
        ConnectionWrapper conn = null;
        try
        {
            boolean autoSelect = getBoolean(ic, "autoSelect");
            String currentValue = getString(ic, "currentValue");
            String filter = getString(ic, "filter");
            String firstOption = getString(ic, "firstOption");
            String firstOptionValue = getString(ic, "firstOptionValue");
            String lastOption = getString(ic, "lastOption");
            String lastOptionValue = getString(ic, "lastOptionValue");
            boolean hide = getBoolean(ic, "hide");
            String name = getString(ic, "name");
            String query = getString(ic, "query");
            String resourceName = getString(ic, "resourceName");
            conn = (ConnectionWrapper)ic.getResource(resourceName);
            result.append("<select name=\"" + name + "\"");
            result.append(getExtendedAttributesString(ic));
            result.append(">\n");
            int count = 0;
            if(firstOption != null)
            {
                result.append("<option value=\"" + firstOptionValue + "\">" + firstOption + "</option>\n");
                if (StringUtil.hasAValue(firstOption))
                	count++;
            }
            if(filter.length() > 0)
                query = ic.processFilter(query, filter);
            Diagnostics.debug("SelectComponent.include() SQL: " + query);

            // new prepared statement code
            PreparedStatement pstmt = null;
            ResultSet psRS = null;
            QueryResults rs = null;

            String id = null;
            String display = null;
            try
            {
	            pstmt = IMSUtil.queryToPreparedStatement(conn, new StringBuffer(query));
	            psRS = pstmt.executeQuery();
	            rs = new QueryResults(conn, pstmt, psRS);
	
	            while(rs.next()) 
	            {
	                id = rs.getString(1);
	                display = rs.getString(2);
	                result.append("<option value=\"" + id + "\"");
	                if(id != null && currentValue != null && id.equals(currentValue))
	                    result.append(" selected");
	                result.append(">" + display + "</option>\n");
	                count++;
	            }
            }
            finally
            {
            	if (rs != null)
            		rs.close();
            	if (psRS != null)
            		psRS.close();
            	if (pstmt != null)
            		pstmt.close();
            }
            if(lastOption != null)
            {
                result.append("<option value=\"" + lastOptionValue + "\">" + lastOption + "</option>\n");
                if (StringUtil.hasAValue(lastOption))
                	count++;
            }
            result.append("</select>\n");
            if(count == 1)
                if(autoSelect)
                {
                    result.setLength(0);
                    result.append("<select name=\"" + name + "\"");
                    result.append(getExtendedAttributesString(ic));
                    result.append(">\n");
                    result.append("<option value=\"" + id + "\" selected> " + display + "</option>\n");
                    ic.setParameter(name, id);
                } else
                if(hide)
                {
                    result.setLength(0);
                    result.append(display);
                    result.append("<input type=\"hidden\" name=\"" + name + "\" value=\"" + id + "\">\n");
                }
        }
        finally
        {
            try
            {
                if(conn != null)
                    conn.release(false);
            }
            catch(Exception e) { }
        }
        return result.toString();
    }
}
