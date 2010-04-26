// Decompiled by Jad v1.5.8f. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) 
// Source File Name:   ChooserComponent.java

package ims.components;

import java.util.Vector;

import dynamic.dbtk.MetaData;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.templates.Template;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

// Referenced classes of package dynamic.intraframe.templates.components:
//            SmartTableComponent

public class ChooserComponent extends SmartTableComponent
{

    public ChooserComponent()
        throws Exception
    {
        registerRequiredAttribute("chooserBasePath");
        registerDeprecatedAttribute("returnColumns", null);
        registerRequiredAttribute("rowSelectedClass");
    }

    public String includeInternal(InvocationContext ic)
        throws Exception
    {
        StringBuffer header = new StringBuffer();
        StringBuffer body = new StringBuffer();
        StringBuffer footer = new StringBuffer();
        StringBuffer script = new StringBuffer();
        String name = getString(ic, "name");
        ic.setTransientDatum("hasColorRowClasses", "false");
        main(ic, name, "_top", header, body, footer, script);
        header.insert(0, table(ic, name)).append("</table>\n");
        body.insert(0, table(ic, name)).append("</table>\n");
        footer.insert(0, table(ic, name)).append("</table>\n");
        ic.setSessionDatum("__chooser_top", header.toString());
        ic.setSessionDatum("__chooser_middle", body.toString());
        ic.setSessionDatum("__chooser_bottom", footer.toString());
        String chooserBasePath = getString(ic, "chooserBasePath");
        Template t = ic.getTemplate(chooserBasePath + "_frameset.html");
        StringBuffer result = new StringBuffer();
        result.append(script);
        result.append(t.include(ic));
        return result.toString();
    }

    protected String body(InvocationContext ic, String name, QueryResults rs, MetaData meta, int startWithRow, int maxRowCount)
        throws Exception
    {
        StringBuffer body = new StringBuffer();
        String selectFirstRow = "";
        int height = getInt(ic, "rowHeight");
        int rowid = 0;
        int rowCount = startWithRow;
        String alt1 = getString(ic, "alternator1");
        String alt2 = getString(ic, "alternator2");
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
        for(rowid = 1; rowid < startWithRow && rs.next(); rowid++);
        while(rs.next()) 
        {
            ic.setTransientDatum("rowid", "" + rowid);
            if(maxRowCount != 0 && rowid >= maxRowCount + startWithRow)
                break;
            body.append("<a href=\"JavaScript:");
            String temp = "select(" + (rowid - startWithRow) + ",";
            for(int i = 1; i <= meta.getColumnCount(); i++)
            {
                if(i > 1)
                    temp = temp + ",";
                temp = temp + StringUtil.toHTML(StringUtil.toJavaScriptString(rs.getString(i)));
            }

            temp = temp + ")";
            if(rowid == 1)
                selectFirstRow = temp;
            body.append(temp);
            body.append("\">\n");
            body.append("<tr rowid=\"" + rowid + "\"");
            if(height > 0)
                body.append(" height=\"" + height + "\"");
            body.append(" style=\"cursor:hand\"");
            String rowRolloverClass = getString(ic, "rowRolloverClass");
            if(rowRolloverClass != null)
            {
                body.append(" onMouseOver=\"setRowClass(" + (rowid - startWithRow) + ",'" + rowRolloverClass + "')\"");
                body.append(" onMouseOut=\"resetRowClass(" + (rowid - startWithRow) + ")\"");
            }
            body.append(">\n");
            ic.setTransientDatum("row", "1");
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
            body.append(includeChildren(ic));
            body.append("</tr>\n");
            body.append("</a>\n");
            rowid++;
            rowCount++;
        }
        
        // calc rest of row count
        Diagnostics.debug("rowCount = " + rowCount);
        Diagnostics.debug("Looping through extra rows");  
        while (rs.next())
            rowCount++;
        Diagnostics.debug("Done!");
        Diagnostics.debug("rowCount = " + rowCount);
        ic.setTransientDatum("rowCount", Integer.toString(rowCount));
        
        rs.close();
        if(rowid == startWithRow)
        {
            String numcols = (String)ic.getRequiredTransientDatum("numcols");
            body.append("<tr><td");
            body.append(" colspan=\"" + numcols + "\"");
            if(height > 0)
                body.append(" height=\"" + height + "\"");
            String css = getRowClass(ic, rowid, getString(ic, "class"));
            if(css != null)
                body.append(" class=\"" + css + "\"");
            body.append(">");
            body.append("No items in the list");
            body.append("</td>\n");
            body.append("</tr>\n");
        }
        body.append(getScript(ic, name, meta, selectFirstRow, rowid));
        return body.toString();
    }

    protected StringBuffer getScript(InvocationContext ic, String name, MetaData meta, String selectFirstRow, int rowid)
        throws Exception
    {
        StringBuffer script = new StringBuffer();
        String rowSelectedClass = getString(ic, "rowSelectedClass");
        script.append("<script type=\"text/javascript\">\n");
        script.append("<!--//\n");
        script.append("var currentRow = -1;\n");
        script.append("var defaultClassName;\n");
        script.append("var archiveClassName;");
        script.append("\n");
        script.append("function selectFirstRow()\n");
        script.append("{\n");
        if(rowid == 2)
            script.append("\t" + selectFirstRow + "\n");
        script.append("}\n");
        script.append("function setRowClass(row,className)\n");
        script.append("{\n");
        script.append("\tdefaultClassName = document.all." + name + ".rows[row].cells[0].className\n");
        script.append("\tif (row == currentRow) className='" + rowSelectedClass + "';\n");
        script.append("\tfor (i = 0; i < document.all." + name + ".rows[row].cells.length; i++)\n");
        script.append("\t\tdocument.all." + name + ".rows[row].cells[i].className = className;\n");
        script.append("}\n");
        script.append("\n");
        script.append("function resetRowClass(row)\n");
        script.append("{\n");
        script.append("\tsetRowClass(row, defaultClassName)\n");
        script.append("}\n");
        script.append("\n");
        script.append("function select(row");
        for(int i = 1; i <= meta.getColumnCount(); i++)
            script.append("," + meta.getColumnName(i));

        script.append(")\n");
        script.append("{\n");
        script.append("\tif (row == currentRow) return; //already selected\n");
        script.append("\ttmp = currentRow;\n");
        script.append("\tcurrentRow = row;\n");
        script.append("\tarchive = defaultClassName;\n");
        script.append("\tif (tmp != -1) setRowClass(tmp, archiveClassName);\n");
        script.append("\tarchiveClassName = archive;\n");
        script.append("\tsetRowClass(currentRow, 'ChooserTableRowSelected');\n");
        script.append("\t//save the data for this row\n");
        for(int i = 1; i <= meta.getColumnCount(); i++)
            script.append("\tparent." + meta.getColumnName(i) + "=" + meta.getColumnName(i) + ";\n");

        script.append("}\n");
        script.append("\n");
        script.append("// -->\n");
        script.append("</script>\n");
        return script;
    }

    public static final String CHOOSER_TOP = "__chooser_top";
    public static final String CHOOSER_MIDDLE = "__chooser_middle";
    public static final String CHOOSER_BOTTOM = "__chooser_bottom";
}
