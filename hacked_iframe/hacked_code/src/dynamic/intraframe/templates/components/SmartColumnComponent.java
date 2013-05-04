 package dynamic.intraframe.templates.components;
 
 import dynamic.dbtk.MetaData;
 import dynamic.dbtk.connection.QueryResults;
 import dynamic.dbtk.parser.Sql;
 import dynamic.intraframe.engine.InvocationContext;
 import dynamic.intraframe.templates.TemplateComponent;
 import dynamic.intraframe.templates.TemplateManager;
 import dynamic.util.string.StringUtil;
 import java.util.Vector;
 
 public class SmartColumnComponent extends TemplateComponent
 {
   public SmartColumnComponent()
     throws Exception
   {
     registerAttribute("aTitle", null);
     registerAttribute("colspan", "1");
     registerAttribute("class", null);
     registerAttribute("dTitle", null);
     registerAttribute("filter", null);
     registerAttribute("filterQuery", null);
     registerAttribute("filterQuick", "false");
     registerAttribute("format", null);
     registerAttribute("href", null);
     registerAttribute("height", "0");
     registerAttribute("linkClass", null);
     registerAttribute("name", "c1");
     registerAttribute("rolloverClass", null);
     registerAttribute("row", "1");
     registerAttribute("size", "0");
     registerAttribute("sort", null);
     registerDeprecatedAttribute("table", null);
     registerAttribute("target", null);
     registerAttribute("title", "");
     registerAttribute("value", null);
     registerAttribute("total", null);
     registerAttribute("onClick", null);
     registerAttribute("numDecimals", "0");
     allowsExtendedAttributes();
   }
 
   public String includeInternal(InvocationContext ic) throws Exception
   {
     StringBuffer result = new StringBuffer();
     int row = getInt(ic, "row");
     int onRow = Integer.parseInt((String)ic.getRequiredTransientDatum("row"));
     int rowid = Integer.parseInt((String)ic.getRequiredTransientDatum("rowid"));
 
     if (row != onRow)
     {
       result.append("</tr>\n<tr rowid=\"" + rowid + "\">\n");
       ic.setTransientDatum("row", "" + row);
     }
     result.append("\t");
     if (rowid == 0)
     {
       result.append(getTitle(ic));
     }
     else if (rowid == -1)
     {
       result.append(getFilter(ic));
     }
     else if (rowid == -2)
     {
       result.append(getTotal(ic));
     }
     else
     {
       result.append(getRow(ic));
     }
     return result.toString();
   }
 
   private String getTitle(InvocationContext ic)
     throws Exception
   {
     StringBuffer result = new StringBuffer();
     StringBuffer href = new StringBuffer();
     StringBuffer td = new StringBuffer();
     StringBuffer events = new StringBuffer();
 
     String aTitle = getString(ic, "aTitle");
     int colspan = getInt(ic, "colspan");
     String dTitle = getString(ic, "dTitle");
     String filter = getString(ic, "filter");
     String name = getString(ic, "name");
     int row = getInt(ic, "row");
     String sort = getString(ic, "sort");
     String title = getString(ic, "title");
     SmartTableComponent parent = getTable();
     String parentName = parent.getString(ic, "name");
     int height = parent.getInt(ic, "titleHeight");
     if (height == 0) height = parent.getInt(ic, "rowHeight");
     if (height == 0) height = getInt(ic, "height");
     String normal = parent.getTitleClass(ic, "normal");
     String rollover = parent.getTitleClass(ic, "rollover");
     String pressed = parent.getTitleClass(ic, "pressed");
     String text;
     String img;
     if (sort == null)
     {
       text = title;
       img = null;
     }
     else
     {
       String nextSort = null;
       String orderBy = ic.getParameter(parentName + "_order_by");
       if ((orderBy == null) || (orderBy.length() == 0) || (!orderBy.startsWith(sort)))
       {
         nextSort = "";
         img = null;
         text = title;
       }
       else if (orderBy.endsWith("desc"))
       {
         nextSort = null;
         img = parent.getString(ic, "dSort");
         text = dTitle != null ? dTitle : title;
         normal = parent.getTitleClass(ic, "sorted");
         rollover = parent.getTitleClass(ic, "sortedRollover");
         pressed = parent.getTitleClass(ic, "sortedPressed");
       }
       else
       {
         nextSort = " desc";
         img = parent.getString(ic, "aSort");
         text = aTitle != null ? aTitle : title;
         normal = parent.getTitleClass(ic, "sorted");
         rollover = parent.getTitleClass(ic, "sortedRollover");
         pressed = parent.getTitleClass(ic, "sortedPressed");
       }
 
       String url = (String)ic.getRequiredTransientDatum(parentName + "_filter_action");
       String queryString = SmartTableComponent.getQueryString(ic);
       queryString = SmartTableComponent.setParam(queryString, parentName + "_order_by", nextSort != null ? sort + nextSort : null);
       queryString = SmartTableComponent.setParam(queryString, "startWithRow", null);
       if ((queryString != null) && (queryString.length() > 0)) url = url + "?" + queryString;
       String target = (String)ic.getTransientDatum(parentName + "_filter_target");
       href.append("<a href=\"" + url + "\"");
       if (target != null) href.append(" target=\"" + target + "\"");
 
       href.append(">");
 
       events.append(" style=\"cursor:hand\"");
       if (normal != null)
       {
         if (pressed != null)
         {
           events.append(" onMouseDown=\"this.className='" + pressed + "'; return true\"");
           events.append(" onMouseUp=\"this.className='" + (rollover != null ? rollover : normal) + "'; return true\"");
         }
         if (rollover != null)
         {
           events.append(" onMouseOver=\"this.className='" + rollover + "'; return true\"");
           events.append(" onMouseOut=\"this.className='" + normal + "'; return true\"");
         }
       }
 
     }
 
     td.append("<td");
     if (height > 0) td.append(" height=\"" + height + "\"");
     if (normal != null) td.append(" class=\"" + normal + "\"");
     if (colspan > 1) td.append(" colspan=\"" + colspan + "\"");
     td.append(getExtendedAttributesString(ic));
     td.append(events);
     td.append(">\n");
 
     result.append(td);
     result.append("&nbsp;");
     if (href.length() > 0) result.append(href);
 
     if ((text == null) || (text.length() == 0) || (text.equals(" "))) text = "&nbsp;";
     result.append(text);
     if (img != null) result.append("&nbsp;" + img);
 
     if (href.length() > 0) result.append("</a>");
     result.append("</td>");
 
     result.append("\n");
 
     if ((filter != null) && (filter.length() > 0))
     {
       Vector filterList = (Vector)ic.getRequiredTransientDatum(parentName + "_filter_list");
       int idx = filter.indexOf(":");
       if (idx != -1) filter = filter.substring(0, idx);
       filterList.addElement(filter);
     }
 
     if (row == 1)
     {
       int numcols = Integer.parseInt((String)ic.getRequiredTransientDatum("numcols"));
       int skipcols = Integer.parseInt((String)ic.getRequiredTransientDatum("skipcols"));
       if ((text != null) && (text.length() > 0))
         numcols += colspan;
       else
         skipcols += colspan;
       ic.setTransientDatum("numcols", "" + numcols);
       ic.setTransientDatum("skipcols", "" + skipcols);
     }
 
     if (name != null) ic.setTransientDatum("lastColumn", name);
 
     return result.toString();
   }
 
   private String getFilter(InvocationContext ic)
     throws Exception
   {
     StringBuffer result = new StringBuffer();
 
     int colspan = getInt(ic, "colspan");
     String filter = getString(ic, "filter");
     String filterQuery = getString(ic, "filterQuery");
     boolean filterQuick = getBoolean(ic, "filterQuick");
     String name = getString(ic, "name");
     int size = getInt(ic, "size");
     boolean lastColumn = name.equals(ic.getRequiredTransientDatum("lastColumn"));
     SmartTableComponent parent = getTable();
     String parentName = parent.getString(ic, "name");
     int height = parent.getInt(ic, "titleHeight");
     if (height == 0) height = parent.getInt(ic, "rowHeight");
     if (height == 0) height = getInt(ic, "height");
     String css = parent.getFilterClass(ic);
 
     result.append("<td");
     if (height > 0) result.append(" height=\"" + height + "\"");
     if ((css != null) && (!lastColumn))
       result.append(" class=\"" + css + "\"");
     if (colspan > 1) result.append(" colspan=\"" + colspan + "\"");
     result.append(getExtendedAttributesString(ic));
     result.append(">");
 
     if (lastColumn)
     {
       result.append("<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\"");
       if (height > 0) result.append(" height=\"" + height + "\"");
       result.append("><tr");
       if (height > 0) result.append(" height=\"" + height + "\"");
       result.append("><td");
       if (height > 0) result.append(" height=\"" + height + "\"");
       if (css != null) result.append(" class=\"" + css + "\"");
       result.append(" style=\"width:100%\"");
       result.append(">");
     }
 
     if ((filter != null) && (filter.length() > 0))
     {
       String value = null;
       int idx = filter.indexOf(":");
       String params = null;
       if (idx != -1)
       {
         params = filter.substring(idx + 1);
         filter = filter.substring(0, idx);
         value = ic.getParameter(filter);
         if (value == null) value = "";
 
         int x = params.indexOf(" ");
         if (x == -1) x = params.indexOf("=");
         if (x == -1)
         {
           if (filterQuery == null)
             params = params + " LIKE " + StringUtil.toSQLString(new StringBuffer().append(value).append('%').toString());
           else
             params = params + " = " + StringUtil.toSQLString(value);
         }
       }
       else
       {
         value = ic.getParameter(filter);
         if (value == null) value = "";
       }
 
       if (filterQuery == null)
       {
         result.append("<input type=\"text\" name=\"");
         result.append(filter);
         result.append("\" value=\"");
         if ((value != null) && (value.length() > 0))
           result.append(StringUtil.toHTML(value));
         result.append("\"");
         if (size > 0) result.append(" size=\"" + size + "\"");
         result.append(" class=\"regular\" style=\"width:100%\"");
         if (filterQuick)
           result.append(" onChange=\"this.form.submit(); return true\"");
         result.append(">");
       }
       else
       {
         TemplateComponent select = this.manager.getTemplateComponent("SELECT");
         StringBuffer header = new StringBuffer();
         header.append(" name=\"" + filter + "\"");
         header.append(" query=\"" + filterQuery + "\"");
         header.append(" currentValue=\"<?p:" + filter + "?>\"");
         header.append(" firstOption=\"\"");
         header.append(" firstOptionValue=\"\"");
         header.append(" currentValue=\"<?p:" + filter + "?>\"");
         header.append(" class=\"regular\" style=\"width:100%\"");
         if (filterQuick)
           header.append(" onChange=\"this.form.submit(); return true\"");
         select.initialize(this.manager, null, header.toString(), null);
         result.append("\n");
         result.append(select.include(ic));
       }
 
       if ((params != null) && (value != null) && (value.length() > 0))
       {
         Sql sql = (Sql)ic.getTransientDatum(parentName + "_sql");
         if (sql == null) sql = Sql.fetchSql((String)ic.getTransientDatum(parentName + "_query"));
         sql = ic.processFilter(sql, "simple(" + params + ")");
         ic.setTransientDatum(parentName + "_sql", sql);
       }
     }
     else
     {
       result.append("&nbsp;");
     }
 
     if (lastColumn)
     {
       result.append("</td>");
       result.append("<td");
       if (height > 0) result.append(" height=\"" + height + "\"");
       if (css != null) result.append(" class=\"" + css + "\"");
       result.append("><input type=\"submit\" class=\"button2\" value=\"Search\"></td>");
       result.append("<td");
       if (height > 0) result.append(" height=\"" + height + "\"");
       if (css != null) result.append(" class=\"" + css + "\"");
       result.append("><input type=\"button\" class=\"button2\" value=\"Clear\" onClick=\"return clearFields()\"></td>");
       result.append("</td></tr></table>");
     }
 
     result.append("</td>\n");
 
     return result.toString();
   }
 
   public String getRow(InvocationContext ic)
     throws Exception
   {
     StringBuffer result = new StringBuffer();
     StringBuffer href = new StringBuffer();
     StringBuffer td = new StringBuffer();
     StringBuffer events = new StringBuffer();
 
     int colspan = getInt(ic, "colspan");
     String name = getString(ic, "name");
 
     String value = getString(ic, "value");
 
     SmartTableComponent parent = getTable();
     String parentName = parent.getString(ic, "name");
     MetaData meta = (MetaData)ic.getRequiredTransientDatum(parentName + "_metadata");
     int height = getInt(ic, "height");
     if (height == 0) height = parent.getInt(ic, "rowHeight");
 
     QueryResults cursor = (QueryResults)ic.getRequiredTransientDatum(SQLLoopComponent.CURSOR_VAR_PREFIX + parentName);
 
     if ((value == null) && (name != null))
     {
       String format = getString(ic, "format");
       if (format == null)
         value = cursor.getString(name);
       else if (format.equalsIgnoreCase("date"))
         value = SmartFieldComponent.formatDate(cursor.getDate(name));
       else if (format.equalsIgnoreCase("datetime"))
         value = SmartFieldComponent.formatDateTime(cursor.getTimestamp(name));
       else if (format.equalsIgnoreCase("time"))
         value = SmartFieldComponent.formatTime(cursor.getTimestamp(name));
       else if (format.equalsIgnoreCase("money"))
         value = SmartFieldComponent.formatMoney(cursor.getString(name));
       else if (format.equalsIgnoreCase("percent"))
         value = SmartFieldComponent.formatPercent(cursor.getString(name), getString(ic, "numDecimals"), false);
       else if (meta.getColumnTypeName(name).equals("date"))
         value = SmartFieldComponent.format(format, cursor.getTimestamp(name));
       else if (meta.getColumnTypeName(name).equals("number"))
         value = SmartFieldComponent.format(format, new Double(cursor.getDouble(name)));
       else {
         value = "Unknown format \"" + format + "\" on column " + name + " of type " + meta.getColumnTypeName(name);
       }
       if (getBoolean(ic, "total"))
       {
         String value_tot = (String)ic.getTransientDatum(name + "_tot");
         if (value_tot == null) value_tot = "0";
         value_tot = "" + Double.toString(Double.valueOf(value_tot).doubleValue() + cursor.getDouble(name));
         ic.setTransientDatum(name + "_tot", value_tot);
         ic.setTransientDatum(parentName + "_total", "true");
       }
 
       if (value != null) value = StringUtil.toHTML(value);
     }
 
     int rowid = Integer.parseInt((String)ic.getRequiredTransientDatum("rowid"));
     String rowClass = parent.getRowClass(ic, rowid, getString(ic, "class"));
 
     String url = getString(ic, "href");
     value = group(ic, name, value);
     if ((url != null) && (value != null))
     {
       String target = getString(ic, "target");
       href.append("<a href=\"" + url + "\"");
       if (target != null) href.append(" target=\"" + target + "\"");
 
       href.append(">");
 
       String temp_class = parent.getCellLinkClass(ic, rowid, getString(ic, "linkClass"));
       if (StringUtil.hasAValue(temp_class))
         rowClass = temp_class;
       String rowRolloverClass = parent.getRowRolloverClass(ic, rowid, getString(ic, "rolloverClass"));
       events.append(" style=\"cursor:hand\"");
       if ((rowClass != null) && (rowRolloverClass != null))
       {
         events.append(" onMouseOver=\"this.className='" + rowRolloverClass + "'; return true\"");
         events.append(" onMouseOut=\"this.className='" + rowClass + "'; return true\"");
       }
 
       String on_click = getString(ic, "onClick");
       if (StringUtil.hasAValue(on_click))
         events.append(" onClick=\"" + on_click + "\"");
       if (ic.getTransientDatum("autoClickURL") == null) {
         ic.setTransientDatum("autoClickURL", url);
       }
     }
 
     td.append("<td");
     if (height > 0) td.append(" height=\"" + height + "\"");
     if (rowClass != null) td.append(" class=\"" + rowClass + "\"");
     if (colspan > 1) td.append(" colspan=\"" + colspan + "\"");
     td.append(getExtendedAttributesString(ic));
     td.append(events);
     td.append(">");
 
     result.append(td);
     result.append("&nbsp;");
     if (href.length() > 0) result.append(href);
 
     if ((value == null) || (value.length() == 0) || (value.equals(" "))) value = "&nbsp;";
     result.append(value);
 
     if (href.length() > 0) result.append("</a>");
     result.append("</td>");
 
     result.append("\n");
 
     return result.toString();
   }
 
   public String getTotal(InvocationContext ic)
     throws Exception
   {
     StringBuffer result = new StringBuffer();
 
     int colspan = getInt(ic, "colspan");
     String name = getString(ic, "name");
     String value = (String)ic.getTransientDatum(name + "_tot");
     ic.removeTransientDatum(name + "_tot");
 
     String format = getString(ic, "format");
     if ((format != null) && (value != null))
     {
       if (format.equalsIgnoreCase("money"))
         value = SmartFieldComponent.formatMoney(value);
       else if (format.equalsIgnoreCase("percent"))
         value = SmartFieldComponent.formatPercent(value, getString(ic, "numDecimals"), false);
       else
         value = SmartFieldComponent.format(format, Double.valueOf(value));
     }
     if (value != null) value = StringUtil.toHTML(value);
 
     SmartTableComponent parent = getTable();
     String parentName = parent.getString(ic, "name");
     int height = parent.getInt(ic, "titleHeight");
     if (height == 0) height = parent.getInt(ic, "rowHeight");
     if (height == 0) height = getInt(ic, "height");
     String css = parent.getTotalClass(ic);
 
     result.append("<td");
     if (height > 0) result.append(" height=\"" + height + "\"");
     if (css != null) result.append(" class=\"" + css + "\"");
     if (colspan > 1) result.append(" colspan=\"" + colspan + "\"");
     result.append(getExtendedAttributesString(ic));
     result.append(">");
     if ((value == null) || (value.length() == 0) || (value.equals(" "))) value = "&nbsp;";
     result.append(value);
     result.append("</td>");
     result.append("\n");
 
     return result.toString();
   }
 
   private String group(InvocationContext ic, String name, String value)
     throws Exception
   {
     Vector rowGroups = (Vector)ic.getTransientDatum("group");
 
     if (rowGroups == null) return value;
 
     int index = rowGroups.indexOf(name);
     if (index == -1) return value;
 
     String groupName = (String)rowGroups.elementAt(index);
     String groupValue = (String)ic.getTransientDatum(groupName + "_group");
 
     if ((groupValue != null) && (groupValue.equals(value)))
     {
       value = null;
     }
     else
     {
       ic.setTransientDatum(groupName + "_group", value);
       index++; for (int i = index; i < rowGroups.size(); i++) {
         ic.setTransientDatum((String)rowGroups.elementAt(i) + "_group", null);
       }
     }
     return value;
   }
 
   public SmartTableComponent getTable() throws Exception
   {
     for (TemplateComponent t = getParent(); t != null; t = t.getParent()) {
       if ((t instanceof SmartTableComponent))
         return (SmartTableComponent)t;
     }
     throw new Exception("Could not find parent SmartTable for component " + this);
   }
 }

/* Location:           /Users/dave/kettle_river_consulting/customers/omni_workspace/iFrame framework/original code/
 * Qualified Name:     dynamic.intraframe.templates.components.SmartColumnComponent
 * JD-Core Version:    0.6.2
 */