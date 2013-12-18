package dynamic.intraframe.templates.components;

import dynamic.dbtk.FieldValidator;
import dynamic.dbtk.MetaData;
import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.parser.Sql;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.templates.TemplateAttribute;
import dynamic.intraframe.templates.TemplateComponent;
import dynamic.util.date.StdDate;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.ParsePosition;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Vector;

public class SmartFieldComponent extends TemplateComponent {
    public static final String MAND_FIELD_ERR_MSG = "mandFieldErrMsg";

    public SmartFieldComponent()
            throws Exception {
        registerAttribute("calculated", "false");
        registerAttribute("display", null);
        registerAttribute("div", "");
        registerAttribute("filter", null);
        registerDeprecatedAttribute("form", null);
        registerDeprecatedAttribute("id", null);
        registerAttribute("img", null);
        registerAttribute("key", null);
        registerAttribute("mode", "Always");
        registerAttribute("mandatory", null);
        registerAttribute("mandFieldErrMsg", null);
        registerRequiredAttribute("name");
        registerAttribute("nochoice", "false");
        registerAttribute("orderBy", null);
        registerAttribute("query", null);
        registerAttribute("resourceName", null);
        registerAttribute("table", null);
        registerAttribute("title", "");
        registerAttribute("type", "text");
        registerAttribute("validateField", "true");
        registerAttribute("value", null);
        registerAttribute("numDecimals", "0");
        allowsExtendedAttributes();
    }

    public String includeInternal(InvocationContext ic) throws Exception {
        StringBuffer result = new StringBuffer();
        String div = getString(ic, "div");
        String name = getString(ic, "name");
        String title = getString(ic, "title");
        String type = getString(ic, "type");
        boolean isCalculated = getBoolean(ic, "calculated");
        boolean validate_field = getBoolean(ic, "validateField");
        String resourceName = getString(ic, "resourceName");
        String mand_field_err_msg = (String) ic.getTransientDatum("mandFieldErrMsg");
        boolean canView = ((String) ic.getTransientDatum("View")).equals("true");
        boolean canInsert = ((String) ic.getTransientDatum("Insert")).equals("true");
        boolean canUpdate = ((String) ic.getTransientDatum("Update")).equals("true");
        boolean canDelete = ((String) ic.getTransientDatum("Delete")).equals("true");
        boolean canSave = ((String) ic.getTransientDatum("Save")).equals("true");
        MetaData meta = (MetaData) ic.getTransientDatum("METADATA");
        ConnectionWrapper conn = (ConnectionWrapper) ic.getTransientDatum("RESOURCE");
        SmartFormComponent parent = getParentSmartForm();
        String table = parent.getString(ic, "table");
        boolean errorText = parent.getBoolean(ic, "errorText");
        String errorImage = parent.getString(ic, "errorImage");
        if (mand_field_err_msg == null) {
            mand_field_err_msg = (String) ic.getTransientDatum("mandFieldErrMsg");
        }

        if ((!canView) || (!shouldInclude(ic))) return result.toString();

        String typename = meta.getColumnTypeName(name);
        if (typename == null) typename = "";
        String length = "";
        int displaySize = meta.getColumnDisplaySize(name);
        if (displaySize > 0) length = " maxlength=\"" + displaySize + "\"";

        boolean isMandatory = false;
        String mandatoryString = getString(ic, "mandatory");
        if (mandatoryString != null) isMandatory = getBoolean(ic, "mandatory");
        else if (meta != null) isMandatory = meta.isColumnMandatory(name);

        boolean isError = false;
        boolean isReadOnly = ((String) ic.getTransientDatum("Save")).equals("false");
        if (!isReadOnly) {
            isReadOnly = parent.getString(ic, "readonly").equals("true");
            if (!isReadOnly) {
                String readonly = getString(ic, "readonly");
                if ((readonly != null) && (readonly.equals("true"))) {
                    isReadOnly = true;
                }
            }
        }
        if (errorText) {
            String text = (String) ic.getTransientDatum("err@" + name);
            if ((text != null) && (text.length() > 0)) isError = true;

        }

        if (title.length() > 0) {
            boolean useCSS = parent.getBoolean(ic, "useCSS");

            if ((useCSS) && (isMandatory) && (!isError) && (!isReadOnly))
                result.append("<span class=\"mandatoryLabel\">" + title + "</span>");
            else if ((useCSS) && (isMandatory) && (isError) && (!isReadOnly))
                result.append("<span class=\"mandatoryLabelError\">" + title + "</span>");
            else
                result.append(title);
            if (div.length() > 0) result.append(div);
        }

        ConnectionWrapper connTemp = null;
        try {
            if (resourceName != null)
                connTemp = (ConnectionWrapper) ic.getResource(resourceName);
            else {
                connTemp = conn;
            }
            if (type.equalsIgnoreCase("droplist"))
                result.append(createDropList(ic, connTemp, name, typename, canSave, isReadOnly, isMandatory, isError, resourceName));
            else if (type.equalsIgnoreCase("chooser"))
                result.append(createChooser(ic, connTemp, name, typename, canSave, isReadOnly, isMandatory, isError, resourceName));
            else if (type.equalsIgnoreCase("date"))
                result.append(createDate(ic, connTemp, name, typename, canSave, isReadOnly, isMandatory, isError));
            else if (type.equalsIgnoreCase("time"))
                result.append(createTime(ic, connTemp, name, typename, canSave, isReadOnly, isMandatory, isError));
            else if (type.equalsIgnoreCase("datetime"))
                result.append(createDateTime(ic, connTemp, name, typename, canSave, isReadOnly, isMandatory, isError));
            else if (type.equalsIgnoreCase("textarea"))
                result.append(createTextArea(ic, connTemp, name, typename, length, canSave, isReadOnly, isMandatory, isError));
            else if (type.equalsIgnoreCase("boolean"))
                result.append(createBoolean(ic, connTemp, name, typename, canSave, isReadOnly, isMandatory, isError));
            else if (type.equalsIgnoreCase("dbhidden"))
                result.append(createDB(ic, connTemp, name, typename, canSave, isReadOnly, isMandatory, isError));
            else if (type.equalsIgnoreCase("phone"))
                result.append(createPhone(ic, connTemp, name, typename, length, canSave, isReadOnly, isMandatory, isError));
            else if (type.equalsIgnoreCase("money"))
                result.append(createMoney(ic, connTemp, name, typename, length, canSave, isReadOnly, isMandatory, isError));
            else if (type.equalsIgnoreCase("percent"))
                result.append(createPercent(ic, connTemp, name, typename, length, canSave, isReadOnly, isMandatory, isError));
            else {
                result.append(createText(ic, connTemp, name, typename, length, canSave, isReadOnly, isMandatory, isError));
            }
            if (resourceName != null)
                result.append("<input name=\"" + name + "_resource\" type=\"hidden\" value=\"" + resourceName + "\">");
        } finally {
            if (resourceName != null) {
                connTemp.release();
            }
        }

        if (isCalculated) {
            result.append("<input name=\"" + name + "_calculated\" type=\"hidden\" value=\"" + isCalculated + "\">");
        }

        if (!validate_field) {
            result.append("<input name=\"" + name + "_validate\" type=\"hidden\" value=\"" + validate_field + "\">");
        }

        if (errorText) {
            String text = (String) ic.getTransientDatum("err@" + name);
            if ((text != null) && (text.length() > 0) && (!type.equalsIgnoreCase("hidden"))) {
                if ((isMandatory) || (mand_field_err_msg.equalsIgnoreCase("false")))
                    text = mand_field_err_msg;
                if ((text != null) && (!text.equalsIgnoreCase("false"))) {
                    result.append("<div class=\"errorText\">" + errorImage + text + "</div>" + div);
                }
            }
        }
        return result.toString();
    }

    private boolean shouldInclude(InvocationContext ic) throws Exception {
        String mode = getString(ic, "mode");
        String formMode = (String) ic.getTransientDatum("mode");

        return (mode.equalsIgnoreCase("Always")) || ((mode.equalsIgnoreCase("Insert")) && (formMode.equals("Insert"))) || ((mode.equalsIgnoreCase("Update")) && (formMode.equals("Update")));
    }

    static String format(String pattern, Date date) {
        if (date == null) return "";
        return new SimpleDateFormat(pattern).format(date);
    }

    static String format(String pattern, Double number) {
        if (number == null) return "";
        return new DecimalFormat(pattern).format(number);
    }

    static Date convertToDate(String pattern, String date_string) {
        Date result = null;
        try {
            ParsePosition pos = new ParsePosition(0);
            SimpleDateFormat date_format = new SimpleDateFormat(pattern);
            result = date_format.parse(date_string, pos);
        } catch (Exception e) {
            Diagnostics.error("Failed to convert String='" + date_string + "' into format='" + pattern + "'");
        }
        return result;
    }

    static String convertToDateString(String from_pattern, String to_pattern, String date_string) {
        String result = null;
        try {
            if (!StringUtil.hasAValue(to_pattern))
                to_pattern = from_pattern;
            ParsePosition pos = new ParsePosition(0);
            SimpleDateFormat date_format = new SimpleDateFormat(from_pattern);
            Date converted_date = date_format.parse(date_string, pos);
            result = format(to_pattern, converted_date);
        } catch (Exception e) {
        }

        return result;
    }

    static String formatDate(Date date) {
        return format("MM/dd/yyyy", date);
    }

    public static String formatDate(String date) {
        String result = convertToDateString("yyyy-MM-dd", "MM/dd/yyyy", date);
        if (!StringUtil.hasAValue(result)) result = convertToDateString("dd-mmm-yyyy", "MM/dd/yyyy", date);
        if (!StringUtil.hasAValue(result)) result = convertToDateString("MM/dd/yyyy", null, date);
        return result;
    }

    static String formatDateTime(Date date) {
        return format("MM/dd/yyyy h:mm a", date);
    }

    static String formatDateTime(String date) {
        String result = convertToDateString("yyyy-MM-dd hh:mm:ss", "MM/dd/yyyy h:mm a", date);
        if (!StringUtil.hasAValue(result))
            result = convertToDateString("dd-mmm-yyyy HH:mm:ss", "MM/dd/yyyy h:mm a", date);
        if (!StringUtil.hasAValue(result)) result = convertToDateString("MM/dd/yyyy h:mm a", null, date);
        return result;
    }

    static String formatTime(Date date) {
        return format("h:mm a", date);
    }

    static String formatTime(String date) {
        String result = convertToDateString("h:mm a", null, date);
        if (result == null) result = convertToDateString("h:mm a", null, date);
        else if (result == null) result = convertToDateString("h:mm a", null, date);
        return result;
    }

    static String formatMoney(String value) {
        if (value == null) return "";
        return NumberFormat.getCurrencyInstance().format(Double.valueOf(value));
    }

    static String formatPercent(String value, String numDecimals, boolean divide) {
        if (value == null) return "";
        String result = FieldValidator.formatPercent(value, numDecimals, divide);
        return result;
    }

    public static String getFirst(String value) {
        if (value == null) return null;
        int x = value.indexOf(',');
        if (x != -1) return value.substring(0, x).trim();
        return value;
    }

    private String getValue(InvocationContext ic, String typename) throws Exception {
        return getValueInternal(ic, typename, false, false, false, false);
    }

    private String getDate(InvocationContext ic, String typename) throws Exception {
        return getValueInternal(ic, typename, true, false, false, false);
    }

    private String getDateTime(InvocationContext ic, String typename) throws Exception {
        return getValueInternal(ic, typename, true, true, false, false);
    }

    private String getTime(InvocationContext ic, String typename) throws Exception {
        return getValueInternal(ic, typename, false, true, false, false);
    }

    private String getMoney(InvocationContext ic, String typename) throws Exception {
        return getValueInternal(ic, typename, false, false, true, false);
    }

    private String getPercent(InvocationContext ic, String typename) throws Exception {
        return getValueInternal(ic, typename, false, false, false, true);
    }

    private String getValueInternal(InvocationContext ic, String typename, boolean isDate, boolean withTime, boolean isMoney, boolean isPercent) throws Exception {
        String name = getString(ic, "name");
        String result = null;
        boolean format_flag = true;

        Object tmp = ic.getTransientDatum(name);
        if (tmp != null) {
            String transient_value = tmp.toString();
            if (StringUtil.hasAValue(transient_value)) {
                result = transient_value;
                Diagnostics.trace("SmartFieldComponent.getValue(" + name + "): using transient data = \"" + result + "\"");

                format_flag = false;

                if (typename.equals("number")) {
                    result = getFirst(result);
                }
            }
        }

        if (result == null) {
            SmartFormComponent parent = getParentSmartForm();
            String parentName = parent.getString(ic, "name");
            QueryResults cursor = null;
            try {
                cursor = (QueryResults) ic.getTransientDatum(SQLLoopComponent.CURSOR_VAR_PREFIX + parentName);
            } catch (ClassCastException e) {
            }
            if (cursor != null) {
                String row_value = null;
                try {
                    if (isDate) {
                        if (withTime)
                            row_value = ic.format(cursor.getTimestamp(name), "datetime");
                        else
                            row_value = ic.format(cursor.getDate(name), "date");
                    } else if (withTime) {
                        row_value = ic.format(cursor.getTimestamp(name), "time");
                    } else if (isMoney) {
                        Double a_double = new Double(cursor.getDouble(name));
                        row_value = ic.format(a_double, "money");
                    } else if (isPercent) {
                        row_value = formatPercent(cursor.getString(name), getString(ic, "numDecimals"), false);
                    } else {
                        row_value = cursor.getString(name);
                    }
                    if (StringUtil.hasAValue(row_value)) {
                        result = row_value;
                        format_flag = false;
                        Diagnostics.trace("SmartFieldComponent.getValue(" + name + "): using row data = \"" + result + "\"");
                    }

                } catch (SQLException se) {
                    String parameter_value = ic.getParameter(name);
                    if (StringUtil.hasAValue(parameter_value)) {
                        result = parameter_value;
                        Diagnostics.trace("SmartFieldComponent.getValue(" + name + "): using parameter = \"" + result + "\"");
                    } else {
                        Diagnostics.trace("SmartFieldComponent.getValue(" + name + "): retrieve row data erred.\n" + se.toString());
                    }
                }
            }
        }

        if (result == null) {
            String default_value = getString(ic, "value");
            if (StringUtil.hasAValue(default_value)) {
                result = default_value;
                Diagnostics.trace("SmartFieldComponent.getValue(" + name + "): using default value = \"" + result + "\"");
                if (typename.equals("number")) {
                    result = getFirst(result);
                }
            }
        }

        if ((format_flag) && (StringUtil.hasAValue(result))) {
            String formatted_result = null;
            try {
                if (isDate) {
                    if (withTime)
                        formatted_result = ic.format(new StdDate(result), "datetime");
                    else
                        formatted_result = ic.format(new StdDate(result), "date");
                } else if (withTime)
                    formatted_result = ic.format(new StdDate(result), "time");
                else if (isMoney)
                    formatted_result = ic.format(result, "money");
                else if (isPercent) {
                    formatted_result = formatPercent(result, getString(ic, "numDecimals"), false);
                }
            } catch (Exception e) {
                Diagnostics.trace("SmartFieldComponent.getValue(" + name + "): failed to format '" + result + "'.\n" + e.toString());
            }
            if (StringUtil.hasAValue(formatted_result)) {
                Diagnostics.trace("SmartFieldComponent.getValue(" + name + "): formatted '" + result + "' to '" + formatted_result + "'");
                result = formatted_result;
            }

        }

        if (!StringUtil.hasAValue(result)) {
            result = "";
            Diagnostics.trace("SmartFieldComponent.getValue(" + name + "): no data found, defaulting \"\"");
        }
        ic.setTransientDatum(name, result.toString());

        return StringUtil.toHTML(result);
    }

    private String createDropList(InvocationContext ic, ConnectionWrapper conn, String name, String typename, boolean canSave, boolean isReadOnly, boolean isMandatory, boolean isError, String fieldResource) throws Exception {
        StringBuffer result = new StringBuffer();
        StringBuffer select = new StringBuffer();
        StringBuffer options = new StringBuffer();

        select.append("<select name=\"" + name + "\" id=\"" + name + "\"");
        select.append(getExtendedAttributesString(ic));
        String value = getValue(ic, typename);
        select.append(getCSS(ic, name, value, canSave, isReadOnly, isMandatory, isError));
        select.append(getEvents(ic));

        int i = 0;
        int selectedIndex = -1;

        if ((!isMandatory) || (value == null) || (value.length() <= 0)) {
            options.append("<option value=\"\">");
            i++;
        }

        String display = getString(ic, "display");
        String table = getString(ic, "table");
        String key = getString(ic, "key");
        if (key == null) key = getString(ic, "id");
        String query = getString(ic, "query");
        String filter = getString(ic, "filter");
        if (query == null) {
            String q = "SELECT " + key + " id, " + display + " display  FROM " + table;

            if ((filter != null) && (filter.length() > 0)) q = q + " WHERE " + filter;

            String orderBy = getString(ic, "orderBy");
            if (orderBy == null) orderBy = display;
            query = q + " ORDER BY " + orderBy;
        } else {
            Diagnostics.debug("SmartFieldComponent.createDropList() pre query=" + query);
            query = ic.processFilter(query, filter);
            Diagnostics.debug("SmartFieldComponent.createDropList() post query=" + query);
        }

        QueryResults rs = conn.resultsQueryEx(query);
        while (rs.next()) {
            String element_id = rs.getString(1);
            String element_display = rs.getString(2);
            options.append("<option value=\"" + element_id + "\"");
            if ((value != null) && (element_id != null) && (value.trim().equalsIgnoreCase(StringUtil.replaceString(element_id.trim(), "&", "&amp;")))) {
                options.append(" selected");
                selectedIndex = i;
            } else if ((value != null) && (element_display != null) && (value.trim().equalsIgnoreCase(StringUtil.replaceString(element_display.trim(), "&", "&amp;")))) {
                options.append(" selected");
                selectedIndex = i;
            }
            options.append(">" + element_display);
            i++;
        }
        rs.close();

        if ((isReadOnly) && (selectedIndex != -1)) {
            select.append(" onChange=\"this.selectedIndex=" + selectedIndex + "\"");
        }
        select.append(">");
        result.append(select);
        result.append(options);
        result.append("</select>");

        return result.toString();
    }

    private String createChooser(InvocationContext ic, ConnectionWrapper conn, String name, String typename, boolean canSave, boolean isReadOnly, boolean isMandatory, boolean isError, String fieldResource)
            throws Exception {
        StringBuffer result = new StringBuffer();
        String primaryKeyId = getValue(ic, typename);
        String display = getString(ic, "display");
        String table = getString(ic, "table");
        String query = getString(ic, "query");
        String filter = getString(ic, "filter");
        String key = getString(ic, "key");
        if (key == null) key = getString(ic, "id");

        if ((primaryKeyId != null) && (primaryKeyId.indexOf("&amp") >= 0)) {
            primaryKeyId = StringUtil.replaceString(primaryKeyId.trim(), "&amp;", "&");
        }
        if ((query == null) && (primaryKeyId != null)) {
            query = "SELECT " + key + " id, " + display + " display  FROM " + table + " where " + key + "=" + conn.toSQLString(primaryKeyId);
        }
        String valueFromKey = null;
        QueryResults rs = conn.resultsQueryEx(query);
        while ((rs.next()) && (StringUtil.hasAValue(primaryKeyId))) {
            if ((rs.getString(1) != null) && (rs.getString(1).equalsIgnoreCase(primaryKeyId))) {
                valueFromKey = rs.getString(2);
            }
        }

        ResultSetMetaData meta = rs.getMetaData();
        int maxlength = meta.getColumnDisplaySize(2);
        rs.close();

        String value = null;
        String param = ic.getParameter(name + "_text");

        if (valueFromKey != null) {
            value = valueFromKey;
        } else if ((param != null) && (param.length() > 0)) {
            value = param;
        } else if ((isMandatory) && (ic.getTransientDatum("mode").equals("Insert")) && (getBoolean(ic, "nochoice"))) {
            if (filter != null) {
                Diagnostics.debug("SmartFieldComponent.createChooser() pre query=" + query);
                Sql sql = Sql.fetchSql(query);
                sql = ic.processFilter(sql, filter);
                query = sql.getQuery();
                Diagnostics.debug("SmartFieldComponent.createChooser() post query=" + query);
            }
            rs = conn.resultsQueryEx(query);
            if (rs.next()) {
                primaryKeyId = rs.getString(name);
                value = rs.getString(name + "_text");
                if (rs.next()) {
                    primaryKeyId = null;
                    value = null;
                } else {
                    canSave = false;
                }

            } else {
                isError = true;
                ic.setTransientDatum("err@" + name, "There are no possible values for this.");
            }
            rs.close();
        }

        result.append("<input name=\"" + name + "_text\" id=\"" + name + "_text\"");
        result.append(" type=\"text\"");
        result.append(getExtendedAttributesString(ic));
        result.append(getCSS(ic, name + "_text", primaryKeyId, canSave, isReadOnly, isMandatory, isError));
        result.append(getEvents(ic));
        if (value != null) {
            result.append(" value=\"" + value + "\"");
        }
        if (maxlength > 0) {
            result.append(" maxlength=\"" + maxlength + "\"");
        }
        SmartFormComponent parentForm = getParentSmartForm();
        String parentName = parentForm.getString(ic, "name");
        int x = parentName.lastIndexOf('/');
        if (x != -1) parentName = parentName.substring(x + 1);

        result.append(" onChange=\"document." + parentName + "." + name + ".value=''\" ");
        result.append(">");

        if (filter != null) {
            result.append("<input name=\"" + name + "_filter\" id=\"" + name + "\" type=\"hidden\" value=\"" + StringUtil.toHTML(filter) + "\">");
        }
        result.append("<input name=\"" + name + "\" id=\"" + name + "\" type=\"hidden\" value=\"" + (primaryKeyId == null ? "" : primaryKeyId) + "\">");

        TemplateAttribute t_query = getAttribute(ic, "query");
        if (t_query != null) {
            result.append("<input name=\"" + name + "_query\" id=\"" + name + "_query\" type=\"hidden\" value=\"" + StringUtil.toHTML(t_query.toString()) + "\">");
        }
        String img = getString(ic, "img");
        if ((canSave) && (img != null)) {
            result.append(img);
        }
        return result.toString();
    }

    private String createDate(InvocationContext ic, ConnectionWrapper conn, String name, String typename, boolean canSave, boolean isReadOnly, boolean isMandatory, boolean isError) throws Exception {
        StringBuffer result = new StringBuffer();
        String value = getDate(ic, typename);

        result.append("<input name=\"" + name + "\" id=\"" + name + "\"");
        result.append(" type=\"text\"");
        result.append(getExtendedAttributesString(ic));
        result.append(getCSS(ic, name, value, canSave, isReadOnly, isMandatory, isError));
        result.append(getEvents(ic));
        result.append(" maxlength=\"10\"");
        result.append(" value=\"" + value + "\">");
        String img = getString(ic, "img");
        if ((canSave) && (img != null))
            result.append(img);
        return result.toString();
    }

    private String createTime(InvocationContext ic, ConnectionWrapper conn, String name, String typename, boolean canSave, boolean isReadOnly, boolean isMandatory, boolean isError) throws Exception {
        StringBuffer result = new StringBuffer();
        String value = getTime(ic, typename);

        result.append("<input name=\"" + name + "\" id=\"" + name + "\"");
        result.append(" type=\"text\"");
        result.append(getExtendedAttributesString(ic));
        result.append(getCSS(ic, name, value, canSave, isReadOnly, isMandatory, isError));
        result.append(getEvents(ic));
        result.append(" maxlength=\"8\"");
        result.append(" value=\"" + value + "\">");
        String img = getString(ic, "img");
        if ((canSave) && (img != null))
            result.append(img);
        return result.toString();
    }

    private String createDateTime(InvocationContext ic, ConnectionWrapper conn, String name, String typename, boolean canSave, boolean isReadOnly, boolean isMandatory, boolean isError) throws Exception {
        StringBuffer result = new StringBuffer();
        String value = getDateTime(ic, typename);

        result.append("<input name=\"" + name + "\" id=\"" + name + "\"");
        result.append(" type=\"text\"");
        result.append(getExtendedAttributesString(ic));
        result.append(getCSS(ic, name, value, canSave, isReadOnly, isMandatory, isError));
        result.append(getEvents(ic));
        result.append(" maxlength=\"19\"");
        result.append(" value=\"" + value + "\">");
        String img = getString(ic, "img");
        if ((canSave) && (img != null))
            result.append(img);
        return result.toString();
    }

    private String createTextArea(InvocationContext ic, ConnectionWrapper conn, String name, String typename, String length, boolean canSave, boolean isReadOnly, boolean isMandatory, boolean isError) throws Exception {
        StringBuffer result = new StringBuffer();
        String value = getValue(ic, typename);

        result.append("<textarea name=\"" + name + "\" id=\"" + name + "\"");
        result.append(getExtendedAttributesString(ic));
        result.append(getCSS(ic, name, value, canSave, isReadOnly, isMandatory, isError));
        result.append(length);
        result.append(getEvents(ic));
        result.append(">" + value + "</textarea>");

        return result.toString();
    }

    private String createBoolean(InvocationContext ic, ConnectionWrapper conn, String name, String typename, boolean canSave, boolean isReadOnly, boolean isMandatory, boolean isError) throws Exception {
        StringBuffer result = new StringBuffer();
        String value = getValue(ic, typename);

        result.append("<select name=\"" + name + "\" id=\"" + name + "\"");
        result.append(getExtendedAttributesString(ic));
        result.append(getCSS(ic, name, value, canSave, isReadOnly, isMandatory, isError));
        result.append(getEvents(ic));
        result.append(">");
        if (!isMandatory)
            result.append("<option value=\"\">");
        result.append("<option value=\"Y\"");
        if (value.equalsIgnoreCase("Y")) {
            result.append(" selected");
        }
        result.append(">Yes");

        result.append("<option value=\"N\"");
        if (value.equalsIgnoreCase("N")) {
            result.append(" selected");
        }
        result.append(">No");
        result.append("</select>");

        return result.toString();
    }

    private String createDB(InvocationContext ic, ConnectionWrapper conn, String name, String typename, boolean canSave, boolean isReadOnly, boolean isMandatory, boolean isError) throws Exception {
        StringBuffer result = new StringBuffer();
        String value = getValue(ic, typename);

        result.append("<input name=\"" + name + "\" type=\"hidden\"");
        result.append(getExtendedAttributesString(ic));
        result.append(" value=\"" + value + "\"");
        result.append(">");
        result.append("<input name=\"" + name + "_db\" id=\"" + name + "_db\" type=\"hidden\" value=\"true\">");
        return result.toString();
    }

    private String createPhone(InvocationContext ic, ConnectionWrapper conn, String name, String typename, String length, boolean canSave, boolean isReadOnly, boolean isMandatory, boolean isError)
            throws Exception {
        StringBuffer result = new StringBuffer();
        String value = getValue(ic, typename);

        result.append("<input name=\"" + name + "\" id=\"" + name + "\"");
        result.append(" type=\"text\"");
        result.append(getExtendedAttributesString(ic));
        result.append(getCSS(ic, name, value, canSave, isReadOnly, isMandatory, isError));
        result.append(length);
        result.append(" value=\"" + value + "\"");
        result.append(getEvents(ic));
        result.append(">");
        result.append("<input name=\"" + name + "_phone\" id=\"" + name + "_phone\" type=\"hidden\" value=\"true\">");

        return result.toString();
    }

    private String createMoney(InvocationContext ic, ConnectionWrapper conn, String name, String typename, String length, boolean canSave, boolean isReadOnly, boolean isMandatory, boolean isError) throws Exception {
        StringBuffer result = new StringBuffer();
        String value = getMoney(ic, typename);
        String format = getString(ic, "format");

        result.append("<input name=\"" + name + "\" id=\"" + name + "\"");
        result.append(" type=\"text\"");
        result.append(getExtendedAttributesString(ic));
        result.append(getCSS(ic, name, value, canSave, isReadOnly, isMandatory, isError));
        result.append(length);
        result.append(" value=\"" + value + "\"");
        result.append(getEvents(ic));
        result.append(">");
        result.append("<input name=\"" + name + "_money\" id=\"" + name + "_money\" type=\"hidden\" value=\"true\">");

        return result.toString();
    }

    private String createPercent(InvocationContext ic, ConnectionWrapper conn, String name, String typename, String length, boolean canSave, boolean isReadOnly, boolean isMandatory, boolean isError) throws Exception {
        StringBuffer result = new StringBuffer();
        String value = getPercent(ic, typename);
        String format = getString(ic, "format");

        result.append("<input name=\"" + name + "\" id=\"" + name + "\"");
        result.append(" type=\"text\"");
        result.append(getExtendedAttributesString(ic));
        result.append(getCSS(ic, name, value, canSave, isReadOnly, isMandatory, isError));
        result.append(length);
        result.append(" value=\"" + value + "\"");
        result.append(getEvents(ic));
        result.append(">");
        result.append("<input name=\"" + name + "_percent\" id=\"" + name + "_percent\" type=\"hidden\" value=\"" + getString(ic, "numDecimals") + "\">");

        return result.toString();
    }

    private String createText(InvocationContext ic, ConnectionWrapper conn, String name, String typename, String length, boolean canSave, boolean isReadOnly, boolean isMandatory, boolean isError) throws Exception {
        StringBuffer result = new StringBuffer();
        String value = getValue(ic, typename);

        result.append("<input name=\"" + name + "\" id=\"" + name + "\"");
        result.append(" type=\"" + getString(ic, "type") + "\"");
        result.append(getExtendedAttributesString(ic));
        result.append(getCSS(ic, name, value, canSave, isReadOnly, isMandatory, isError));
        result.append(length);
        result.append(" value=\"" + value + "\"");
        result.append(getEvents(ic));
        result.append(">");

        String format = getString(ic, "format");
        if (format != null)
            result.append("<input name=\"" + name + "_format\" id=\"" + name + "_format\" type=\"hidden\" value=\"" + StringUtil.toHTML(format) + "\">");

        TemplateAttribute query = getAttribute(ic, "query");
        if (query != null) {
            result.append("<input name=\"" + name + "_query\" id=\"" + name + "_query\" type=\"hidden\" value=\"" + StringUtil.toHTML(query.toString()) + "\">");
        }
        return result.toString();
    }

    private String getCSS(InvocationContext ic, String name, String value, boolean canSave, boolean isReadOnly, boolean isMandatory, boolean isError)
            throws Exception {
        String type = getString(ic, "type");
        if (type.equals("hidden")) return "";

        SmartFormComponent parent = getParentSmartForm();
        String parentName = parent.getString(ic, "name");
        int x = parentName.lastIndexOf('/');
        if (x != -1) parentName = parentName.substring(x + 1);
        boolean errorText = parent.getBoolean(ic, "errorText");
        boolean useCSS = parent.getBoolean(ic, "useCSS");
        String css = " class=\"regular\"";

        if (canSave) {
            if (isError)
                css = " class=\"error\"";
            else if ((useCSS) && (isMandatory) && ((value == null) || (value.length() == 0)))
                css = " class=\"mandatory\"";
            else if ((!useCSS) && (isMandatory)) {
                css = " class=\"mandatory\"";
            }
        }
        if (isReadOnly) {
            css = " class=\"readonly\" readonly=\"true\"";
        }

        if (useCSS) {
            if (isMandatory) {
                ((Vector) ic.getTransientDatum("mandatory")).addElement("document." + parentName + "." + name);
            }
            ((Vector) ic.getTransientDatum("fields")).addElement("document." + parentName + "." + name);
        }

        return css;
    }

    private String getEvents(InvocationContext ic) throws Exception {
        SmartFormComponent parent = getParentSmartForm();
        boolean useCSS = parent.getBoolean(ic, "useCSS");
        if (useCSS) return " onFocus=\"fixColors()\" onBlur=\"fixColors()\"";
        return "";
    }

    public SmartFormComponent getParentSmartForm() throws Exception {
        for (TemplateComponent t = getParent(); t != null; t = t.getParent()) {
            if ((t instanceof SmartFormComponent)) return (SmartFormComponent) t;
        }
        throw new Exception("Could not find parent SmartFormComponent for component " + this);
    }
}

/* Location:           /Users/dave/kettle_river_consulting/customers/omni_workspace/iFrame framework/original code/
 * Qualified Name:     dynamic.intraframe.templates.components.SmartFieldComponent
 * JD-Core Version:    0.6.2
 */