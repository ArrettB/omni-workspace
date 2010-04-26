/*jadclipse*/// Decompiled by Jad v1.5.8f. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) radix(10) lradix(10) 
// Source File Name:   SmartFormHandler.java
package dynamic.intraframe.handlers;

import java.sql.SQLException;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;

import dynamic.dbtk.FieldValidator;
import dynamic.dbtk.MetaData;
import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.templates.TemplateAttribute;
import dynamic.util.date.StdDate;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

// Referenced classes of package dynamic.intraframe.handlers:
//            BaseHandler, ErrorHandler
/**
 * @version $Header: SmartFormHandler.java, 4, 4/10/2006 1:43:20 PM, Blake Von Haden$
 */
public class SmartFormHandler extends BaseHandler
{

	public SmartFormHandler()
	{}

	public void setUpHandler()
	{}

	public void destroy()
	{}

	public boolean handleEnvironment(InvocationContext ic)
	{
		ConnectionWrapper conn = null;
		boolean result = true;
		String button = null;
		String template = null;
		String redisplayTemplate = null;
		try
		{
			button = ic.getParameter("button");
			if (button == null)
			{
				Diagnostics.debug3("No button specified, defaulting as 'Cancel' button'");
				button = "Cancel";
			}
			button = button.trim();
			if (button.equals("OK"))
				button = "Cancel";
			ic.setParameter("button", button);
			Diagnostics.trace("SmartFormHandler.handleEnvironment(" + button + ")");
			redisplayTemplate = ic.getParameter("redisplayTemplate");
			String nextTemplate = ic.getParameter("nextTemplate");
			String prevTemplate = ic.getParameter("prevTemplate");
			String preHandler = ic.getParameter("preHandler");
			String postHandler = ic.getParameter("postHandler");
			String validate_flag = ic.getParameter("validate");
			String redisplay = ic.getParameter("redisplay");
			boolean isRedisplay = false;
			if (redisplay != null && redisplay.equalsIgnoreCase("true"))
			{
				isRedisplay = true;
				ic.removeParameter("redisplay");
			}
			String resourceName = ic.getParameter("resourceName");
			conn = (ConnectionWrapper) ic.getResource(resourceName);
			conn.setAutoCommit(false);
			ic.setTransientDatum("__connection", conn);
			if (preHandler != null && preHandler.length() > 0 && !isRedisplay)
			{
				Vector preHandlerVect = StringUtil.stringToVector(preHandler);
				for (int i = 0; i < preHandlerVect.size(); i++)
				{
					result = ic.dispatchHandler((String) preHandlerVect.elementAt(i));
					if (!result)
						break;
				}

				if (result && validate_flag != null && validate_flag.equalsIgnoreCase("true") && button.equals("Save"))
					result = validate(ic);
			}
			else if (button.equals("Save") && !isRedisplay)
				result = validate(ic);
			if (!result || isRedisplay)
			{
				if (isRedisplay)
					Diagnostics.trace("SmartFormHandler.HandleEnvironment() redisplaying form");
				if (!result)
				{
					Diagnostics.trace("SmartFormHandler.HandleEnvironment() Validation failed");
					ic.setParameter("validation_error", "true");
				}
				copyParametersToTransient(ic);
				template = redisplayTemplate;
			}
			else
			{
				if (button.equals("Save"))
				{
					String mode = ic.getParameter("mode");
					if (mode.equals("Update"))
						handleUpdate(ic);
					else
						handleInsert(ic);
					template = nextTemplate;
				}
				else if (button.equals("Copy"))
				{
					handleCopyButton(ic);
					template = redisplayTemplate;
				}
				else if (button.equals("New"))
				{
					handleNewButton(ic);
					template = redisplayTemplate;
				}
				else if (button.equals("Delete"))
				{
					handleDeleteButton(ic);
					template = nextTemplate;
				}
				else if (button.equals("Cancel"))
				{
					handleCancelButton(ic);
					template = prevTemplate;
				}
				else if (button.equals("Done"))
				{
					handleDoneButton(ic);
					template = nextTemplate;
				}
				else
				{
					Diagnostics.warning("SmartFormHandler.handleEnvirnoment(): Unknown button " + button);
				}
				if (postHandler != null && postHandler.length() > 0)
				{
					Vector postHandlerVect = StringUtil.stringToVector(postHandler);
					for (int i = 0; i < postHandlerVect.size(); i++)
					{
						result = ic.dispatchHandler((String) postHandlerVect.elementAt(i));
						if (!result)
							break;
					}

					if (!result)
					{
						copyParametersToTransient(ic);
						template = redisplayTemplate;
					}
				}
			}
			if (ic.getHTMLTemplateName() == null || ic.getHTMLTemplateName().length() == 0)
				ic.setHTMLTemplateName(template);
		}
		catch (Exception e)
		{
			result = false;
			handleException(ic, e, conn, button);
		}
		finally
		{
			if (conn != null)
			{
				try
				{
					if (result)
						conn.commit();
					else
						conn.rollback();
				}
				catch (Exception e)
				{}
				conn.release();
			}
		}
		return result;
	}

	public static String getFirst(String value)
	{
		if (value == null)
			return null;
		int x = value.indexOf(',');
		if (x != -1)
			return value.substring(0, x).trim();
		else
			return value;
	}

	private String getValue(InvocationContext ic, MetaData meta, int i, ConnectionWrapper conn) throws Exception
	{
		String name = meta.getColumnName(i);
		String value = ic.getParameter(name);
		if (meta.getColumnTypeName(i).equals("date"))
		{
			if (value == null || value.length() == 0)
				value = "NULL";
			else if (value.equalsIgnoreCase(conn.now()))
				value = conn.now();
			else
				value = conn.toSQLString(new StdDate(value));
		}
		else if (!ic.containsParameter(name + "_db"))
			if (meta.getColumnTypeName(i).equals("number"))
			{
				if (ic.containsParameter(name + "_phone"))
					value = StringUtil.getDigits(value, false);
				else if (ic.containsParameter(name + "_money"))
					value = StringUtil.getDigits(value, true);
				else if (ic.containsParameter(name + "_percent"))
					value = StringUtil.getDBPercent(value, null, true);
				else
					value = getFirst(value);
				if (value == null || value.length() == 0)
					value = "NULL";
			}
			else
			{
				value = conn.toSQLString(value);
			}
		return value;
	}

	private void handleInsert(InvocationContext ic) throws SQLException, Exception
	{
		Diagnostics.trace("SmartFormHandler.handleInsert()");
		String key = ic.getParameter("key");
		String key_value = null;
		String table = ic.getParameter("table");
		StringBuffer statement = new StringBuffer();
		ConnectionWrapper conn = (ConnectionWrapper) ic.getTransientDatum("__connection");
		MetaData meta = new MetaData(conn, table);
		boolean needComma = false;
		boolean isSQLServer = false; 
		String cat = conn.getCatalog();
		boolean isView = MetaData.isView(ic, conn, table, cat);
		String sequence = ic.getParameter("sequence");
		isSQLServer = sequence.equalsIgnoreCase("@@identity");
		boolean isCalculated = false;
		if (!isSQLServer)
			key_value = conn.getNextValueOfSequenceStringEx(sequence);
		statement.append("insert into " + table + " (");
		if (!isSQLServer || isView)
		{
			statement.append(key);
			needComma = true;
		}
		for (int i = 1; i <= meta.getColumnCount(); i++)
			if (ic.containsParameter(meta.getColumnName(i)) && !meta.getColumnName(i).equals(key))
			{
				isCalculated = StringUtil.toBoolean(ic.getParameter(meta.getColumnName(i).toLowerCase() + "_calculated"));
				if (!isCalculated)
				{
					if (needComma)
						statement.append(", ");
					else
						needComma = true;
					statement.append(meta.getColumnName(i));
				}
			}

		needComma = false;
		statement.append(") values (");
		if (!isSQLServer)
		{
			statement.append(conn.toSQLString(key_value));
			needComma = true;
		}
		else if (isView)
		{
			statement.append("0");
			needComma = true;
		}
		for (int i = 1; i <= meta.getColumnCount(); i++)
			if (ic.containsParameter(meta.getColumnName(i)) && !meta.getColumnName(i).equals(key))
			{
				isCalculated = StringUtil.toBoolean(ic.getParameter(meta.getColumnName(i).toLowerCase() + "_calculated"));
				if (!isCalculated)
				{
					if (needComma)
						statement.append(", ");
					else
						needComma = true;
					statement.append(getValue(ic, meta, i, conn));
				}
			}

		statement.append(")");
		Diagnostics.debug("SmartFormHandler.handleInsert() SQL: " + statement);
		conn.updateExactlyEx(statement, 1, false);
		if (isSQLServer)
			key_value = conn.queryEx("SELECT SCOPE_IDENTITY()");
		ic.setParameter(key, key_value);
		ic.setTransientDatum(key, key_value);
	}

	private void handleUpdate(InvocationContext ic) throws SQLException, Exception
	{
		Diagnostics.trace("SmartFormHandler.handleUpdate()");
		String key = ic.getParameter("key");
		String key_value = ic.getParameter(key);
		String table = ic.getParameter("table");
		StringBuffer statement = new StringBuffer();
		ConnectionWrapper conn = (ConnectionWrapper) ic.getTransientDatum("__connection");
		MetaData meta = new MetaData(conn, table);
		statement.append("update " + table + " set ");
		boolean first_time = true;
		boolean found_one = false;
		boolean isCalculated = false;
		for (int i = 1; i <= meta.getColumnCount(); i++)
			if (ic.containsParameter(meta.getColumnName(i)) && !meta.getColumnName(i).equals(key))
			{
				found_one = true;
				isCalculated = StringUtil.toBoolean(ic.getParameter(meta.getColumnName(i).toLowerCase() + "_calculated"));
				if (!isCalculated)
				{
					if (first_time)
						first_time = false;
					else
						statement.append(", ");
					statement.append(meta.getColumnName(i) + "=" + getValue(ic, meta, i, conn));
				}
			}

		if (!found_one)
		{
			return;
		}
		else
		{
			statement.append(" where " + key + "=" + conn.toSQLString(key_value));
			Diagnostics.debug("SmartFormHandler.handleUpdate() SQL: " + statement);
			conn.updateEx(statement, false);
			return;
		}
	}

	private void handleCopyButton(InvocationContext ic) throws SQLException
	{
		Diagnostics.trace("SmartFormHandler.handleCopyButton()");
		copyParametersToTransient(ic);
		String key = ic.getParameter("key");
		ic.setTransientDatum(key, "");
	}

	private void handleNewButton(InvocationContext ic) throws SQLException
	{
		Diagnostics.trace("SmartFormHandler.handleNewButton()");
		String key = ic.getParameter("key");
		ic.setTransientDatum(key, "");
		for (Enumeration e = ic.getParameterKeys(); e.hasMoreElements();)
		{
			key = (String) e.nextElement();
			if (key.endsWith("_text"))
				ic.setParameter(key, "");
		}

	}

	private void handleDeleteButton(InvocationContext ic) throws SQLException
	{
		Diagnostics.trace("SmartFormHandler.handleDeleteButton()");
		String key = ic.getParameter("key");
		String key_value = ic.getParameter(key);
		String table = ic.getParameter("table");
		ConnectionWrapper conn = (ConnectionWrapper) ic.getTransientDatum("__connection");
		if (key_value.length() > 0)
		{
			String statement = "delete from " + table + " where " + key + "=" + conn.toSQLString(key_value);
			Diagnostics.debug("SmartFormHandler.handleDeleteButton() SQL: " + statement);
			conn.updateEx(statement, false);
			ic.setTransientDatum(key, "");
		}
		else
		{
			Diagnostics.error("Failed to delete record, table='" + table + "' and key='" + key + "' and value='" + key_value + "'");
		}
	}

	private void handleCancelButton(InvocationContext ic)
	{
		Diagnostics.trace("SmartFormHandler.handleCancelButton()");
		String key = ic.getParameter("key");
		ic.setTransientDatum(key, ic.getParameter(key));
	}

	private void handleDoneButton(InvocationContext ic)
	{
		Diagnostics.trace("SmartFormHandler.handleDoneButton()");
		String key = ic.getParameter("key");
		ic.setTransientDatum(key, ic.getParameter(key));
	}

	public static void handleException(InvocationContext ic, Exception e, ConnectionWrapper conn, String button)
	{
		Diagnostics.trace("SmartFormHandler.handleException()");
		final int Oracle_unique = 1;
		final int Oracle_foreign_key = 2292;
		final int SQLServer_unique_index = 2601;
		final int SQLServer_unique = 2627;
		final int SQLServer_foreign_key = 547;
		try
		{
			String field = null;
			String errorMessage = null;
			int error_code = (e instanceof SQLException) ? ((SQLException) e).getErrorCode() : 0;
			String constraint_name = null;
			if (error_code == Oracle_unique || error_code == Oracle_foreign_key)
			{
				Diagnostics.debug("SmartFormHandler Oracle constraint violated: " + e);
				String message = e.getMessage();
				int begParen = message.indexOf("(");
				int endParen = message.indexOf(")");
				if (begParen < endParen && begParen >= 0)
				{
					int begDot = message.substring(begParen, endParen).indexOf(".");
					if (begDot >= 0)
						constraint_name = message.substring(begParen + begDot + 1, endParen);
				}
			}
			else if (error_code == SQLServer_unique || error_code == SQLServer_foreign_key || error_code == SQLServer_unique_index)
			{
				Diagnostics.debug("SmartFormHandler SQLServer constraint violated: " + e);
				String message = e.getMessage();
				int firstSentence = message.indexOf(".");
				if (firstSentence != -1)
				{
					message = message.substring(0, firstSentence - 1);
					int lastQuote = message.lastIndexOf("'");
					if (lastQuote != -1)
						constraint_name = message.substring(lastQuote + 1);
				}
			}
			if (constraint_name != null)
			{
				Diagnostics.debug("constraint_name=\"" + constraint_name + "\"");
				field = conn.queryEx("select field from constraint_names where name = " + conn.toSQLString(constraint_name));
				errorMessage = conn.queryEx("select description from constraint_names where name = "
						+ conn.toSQLString(constraint_name));
			}
			if (errorMessage != null)
			{
				ic.setHTMLTemplateName(ic.getParameter("redisplayTemplate"));
				copyParametersToTransient(ic);
				if (field != null && field.length() > 0)
					ic.setTransientDatum("err@" + field, errorMessage);
				else
					addSmartFormError(ic, errorMessage);
			}
			else
			{
				ErrorHandler.handleException(ic, e, "SmartFormHandler.handleException(" + button + ")");
			}
		}
		catch (Exception ex)
		{
			ErrorHandler.handleException(ic, e, "SmartFormHandler.handleException(" + button + ")");
		}
	}

	public static void copyParametersToTransient(InvocationContext ic)
	{
		Diagnostics.trace("SmartFormHandler.copyParametersToTransient()");
		String key;
		String value;
		for (Enumeration keys = ic.getParameterKeys(); keys.hasMoreElements(); ic.setTransientDatum(key, value))
		{
			key = (String) keys.nextElement();
			value = ic.getParameter(key);
		}

	}

	public static void addSmartFormError(InvocationContext ic, String newMessage)
	{
		Diagnostics.trace("SmartFormHandler.addSmartFormError()");
		if (newMessage == null)
			return;
		String currentMessage = (String) ic.getTransientDatum("SMARTFORM_ERROR");
		if (currentMessage == null)
			currentMessage = newMessage + "<br>\n";
		else
			currentMessage = currentMessage + newMessage + "<br>\n";
		ic.setTransientDatum("SMARTFORM_ERROR", currentMessage);
	}

	private static boolean validateChooserQuery(InvocationContext ic, ConnectionWrapper conn, String columnName, String query,
			Hashtable storedResults) throws Exception
	{
		Diagnostics.trace("SmartFormHandler.validateChooserQuery() columnName=" + columnName + " query=" + query);
		int rowCount = 0;
		String value = null;
		ConnectionWrapper conn_temp = null;
		String resourceName = ic.getParameter(columnName + "_resource");
		if (resourceName != null)
		{
			conn_temp = (ConnectionWrapper) ic.getResource(resourceName);
			Diagnostics.debug2("new resourceName='" + resourceName + "'");
		}
		else
		{
			conn_temp = conn;
		}
		for (Enumeration hashEnum = storedResults.keys(); hashEnum.hasMoreElements();)
		{
			String queryStr = (String) hashEnum.nextElement();
			if (queryStr.equals(query))
			{
				Hashtable values = (Hashtable) storedResults.get(query);
				rowCount = ((Integer) values.get("rowCount")).intValue();
				value = (String) values.get(columnName);
				break;
			}
		}

		if (value == null)
		{
			TemplateAttribute temp = new TemplateAttribute("query", query);
			String tempQuery = temp.evaluate(ic);
			Diagnostics.trace("SmartFormHandler.validateChooserQuery() SQL: " + tempQuery);
			QueryResults rs = conn_temp.resultsQueryEx(tempQuery);
			Hashtable values = new Hashtable();
			rowCount = 0;
			if (rs.next())
			{
				value = rs.getString(columnName);
				rowCount++;
				MetaData meta = new MetaData(rs.getMetaData());
				for (int i = 1; i <= meta.getColumnCount(); i++)
				{
					String storeColumn = meta.getColumnName(i);
					String storeValue = rs.getString(i);
					values.put(storeColumn, storeValue != null ? ((Object) (storeValue)) : "");
				}

				if (rs.next())
					rowCount++;
			}
			rs.close();
			values.put("rowCount", new Integer(rowCount));
			storedResults.put(query, values);
		}
		if (rowCount == 0)
		{
			ic.setTransientDatum("err@" + columnName, "No match was found.");
			Diagnostics.trace("SmartFormHandler.validateChooserQuery() No match was found for column=" + columnName);
		}
		else if (rowCount == 1)
		{
			ic.setParameter(columnName, value != null ? value : "");
		}
		else
		{
			ic.setTransientDatum("err@" + columnName, "More than one match was found.");
			Diagnostics.trace("SmartFormHandler.validateChooserQuery() More than one match was found for column=" + columnName);
		}
		return rowCount == 1;
	}

	public static boolean validate(InvocationContext ic) throws Exception
	{
		ConnectionWrapper conn = (ConnectionWrapper) ic.getTransientDatum("__connection");
		return validate(ic, conn);
	}

	public static boolean validate(InvocationContext ic, ConnectionWrapper conn) throws Exception
	{
		Diagnostics.trace("SmartFormHandler.validate()");
		String key = ic.getParameter("key");
		String mode = ic.getParameter("mode");
		String table = ic.getParameter("table");
		MetaData meta = new MetaData(conn, table);
		boolean is_valid = true;
		Hashtable storedResults = new Hashtable();
		boolean mandatory_message_sent = false;
		for (int i = 1; i <= meta.getColumnCount(); i++)
		{
			String name = meta.getColumnName(i);
			String query = ic.getParameter(name + "_query");
			String foreignKey = null;
			String columnValue = ic.getParameter(name + "_text");
			boolean isCalculated = StringUtil.toBoolean(ic.getParameter(name + "_calculated"));
			String validate_field = ic.getParameter(name + "_validate");
			if (isCalculated || validate_field != null && !validate_field.equalsIgnoreCase("true"))
				continue;
			if (columnValue == null)
				columnValue = ic.getParameter(name);
			else
				foreignKey = ic.getParameter(name);
			if (query != null && query.length() > 0 && (foreignKey == null || foreignKey.length() == 0) && columnValue != null
					&& columnValue.length() > 0 && !validateChooserQuery(ic, conn, name, query, storedResults))
			{
				is_valid = false;
				continue;
			}
			String value = ic.getParameter(name);
			if (ic.containsParameter(name + "_phone"))
			{
				value = ic.format(value, "phone");
				if (value == null)
				{
					is_valid = false;
					ic.setTransientDatum("err@" + name, "This is not a valid phone number");
					Diagnostics.debug("SmartFormHandler.handleEnvironment() phone number for " + name + " ("
							+ ic.getParameter(name) + ") is not valid");
					continue;
				}
				ic.setParameter(name, value);
			}
			if (ic.containsParameter(name + "_money"))
			{
				if (!FieldValidator.validateMoney(value)) // dollar amount is invalid
				{
					is_valid = false;
					ic.setTransientDatum("err@" + name, "This is not a valid dollar amount");
					Diagnostics.debug("SmartFormHandler.handleEnvironment() dollar amount for " + name + " (" + value
							+ ") is not valid");
					continue;
				}
				else if (value != null && value.length() > 0)
				{
					value = ic.format(Double.valueOf(StringUtil.getDigits(value, true)), ic.getParameter(name + "_format"));
					ic.setParameter(name, value);
				}
			}
			if (ic.containsParameter(name + "_percent"))
			{
				value = FieldValidator.formatPercent(value, ic.getParameter(name + "_percent"), true);
				if (value == null)
				{
					is_valid = false;
					ic.setTransientDatum("err@" + name, "This is not a valid percent");
					Diagnostics.debug("SmartFormHandler.handleEnvironment() x percent for field '" + name + "' ("
							+ ic.getParameter(name) + ") is not valid");
					continue;
				}
				ic.setParameter(name, value);
			}
			if (meta.getColumnTypeName(i).equals("date") && value != null && !value.equalsIgnoreCase(conn.now())
					&& !ic.containsParameter(name + "_db"))
			{
				if (!FieldValidator.validateDate(value))
				{
					is_valid = false;
					ic.setTransientDatum("err@" + name, "This is not a valid date");
					Diagnostics.debug("SmartFormHandler.handleEnvironment() date for " + name + " (" + value + ") is not valid");
					continue;
				}
				if (value != null && value.length() > 0)
				{
					value = ic.format(new StdDate(value), ic.getParameter(name + "_format"));
					ic.setParameter(name, value);
				}
			}
			if (!name.equals(key))
			{
				
				boolean isMandatory = false;
				String mandatoryString = ic.getParameter(name + "_mandatory");
				if (mandatoryString != null)
					isMandatory = mandatoryString.equalsIgnoreCase("" + true);
				else
					isMandatory = meta.isColumnMandatory(i);
			
				if (isMandatory && mode.equals("Insert") && (value == null || value.length() == 0) ||
					isMandatory && mode.equals("Update") && value != null && value.length() == 0)
				{
					ic.setTransientDatum("err@" + name, " ");
					Diagnostics.debug("SmartFormHandler.handleEnvironment() mandatory field " + name + " was not specified");
					if (!mandatory_message_sent)
					{
						ic.setTransientDatum("err@table_" + table, "");
						mandatory_message_sent = true;
					}
					is_valid = false;
				}
				else if (!ic.containsParameter(name + "_db"))
					if (meta.getColumnTypeName(i).equals("date") && value != null && !value.equalsIgnoreCase(conn.now()) && !FieldValidator.validateDate(value))
					{
						if (value.length() == 5)
						{
							if (value.length() == 5 && FieldValidator.validateDate(value + ":00"))
							{
								ic.setParameter(name, value + ":00");
							}
							else
							{
								ic.setTransientDatum("err@" + name, "This is not a valid date or time (mm/dd/yyyy hh:mm:ss)");
								Diagnostics.debug("SmartFormHandler.handleEnvironment() time for " + name + " (" + value + ") is not valid");
								is_valid = false;
							}
						}
						else
						{
							ic.setTransientDatum("err@" + name, "This is not a valid date (mm/dd/yyyy)");
							Diagnostics.debug("SmartFormHandler.handleEnvironment() date for " + name + " (" + value + ") is not valid");
							is_valid = false;
						}
					}
					else if (meta.getColumnTypeName(i).equals("number") && !ic.containsParameter(name + "_money") && !ic.containsParameter(name + "_percent")
							&& !FieldValidator.validateNumber(getFirst(value)))
					{
						ic.setTransientDatum("err@" + name, "This is not a valid number");
						Diagnostics.debug("SmartFormHandler.handleEnvironment() number for " + name + " (" + value + ") is not valid");
						is_valid = false;
					}
					else if (!meta.getColumnTypeName(i).equals("date") && !FieldValidator.validateLength(value, meta.getColumnDisplaySize(i)))
					{
						ic.setTransientDatum("err@" + name, "This value is too long (max " + meta.getColumnDisplaySize(i) + ")");
						Diagnostics.debug("SmartFormHandler.handleEnvironment() value for " + name + " (" + value + ") is is too long (max " + meta.getColumnDisplaySize(i) + ")");
						is_valid = false;
					}
			}
		}

		return is_valid;
	}

	public static final String CONNECTION = "__connection";
}

/***********************************************************************************************************************************
 * DECOMPILATION REPORT ***
 * 
 * DECOMPILED FROM: C:\work\ims\www\WEB-INF\lib\iFrame2.jar
 * 
 * 
 * TOTAL TIME: 47 ms
 * 
 * 
 * JAD REPORTED MESSAGES/ERRORS:
 * 
 * 
 * EXIT STATUS: 0
 * 
 * 
 * CAUGHT EXCEPTIONS:
 * 
 **********************************************************************************************************************************/
