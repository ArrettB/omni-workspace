//Decompiled by DJ v3.5.5.77 Copyright 2003 Atanas Neshkov  Date: 11/11/2004 4:09:36 PM
//Home Page : http://members.fortunecity.com/neshkov/dj.html  - Check often for new version!
//Decompiler options: packimports(3)
//Source File Name:   SmartTableComponent.java

package ims.components;

import ims.helpers.IMSUtil;

import java.lang.reflect.Field;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;
import java.util.Vector;

import dynamic.dbtk.MetaData;
import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.MemoryResults;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.parser.Sql;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.templates.components.SQLLoopComponent;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

//Referenced classes of package dynamic.intraframe.templates.components:
//         SQLLoopComponent, SmartFormComponent

public class SmartTableComponent extends dynamic.intraframe.templates.components.SmartTableComponent
{

	/**
	 * @throws Exception
	 */
	public SmartTableComponent() throws Exception
	{
		super();
	}

	protected void main(InvocationContext ic, String name, String target, StringBuffer header, StringBuffer body, StringBuffer footer, StringBuffer script) throws Exception
	{
		ConnectionWrapper conn = null;
		PreparedStatement pstmt = null;
		try
		{
			ic.setTransientDatum(SQLLoopComponent.CURSOR_VAR_PREFIX + name, new String());
			Vector rowGroups = StringUtil.stringToVector(getString(ic, "group"));
			ic.setTransientDatum("group", rowGroups);
			Object o = getObject(ic, "cursor");
			QueryResults rs = null;
			if (o != null && !(o instanceof QueryResults))
				o = new MemoryResults(new Vector());
			rs = (QueryResults) o;
			int maxRows = getInt(ic, "maxRows");
			int maxRowCount = maxRows;
			String maxRowString = ic.getParameter(name + "_max_rows");
			if (maxRowString != null && maxRowString.length() > 0)
				maxRowCount = Integer.parseInt(maxRowString);
			int numRows = 0;
			String query = getString(ic, "query");
			Sql sql = null;
			String resourceName = getString(ic, "resourceName");
			if (query == null && rs == null)
				throw new Exception("Neither query or cursor was specified in component " + this);
			if (query != null && rs != null)
				throw new Exception("Both query and cursor were specified in component " + this);
			if (query != null)
			{
				Diagnostics.debug("SmartTableComponent.include() pre-filter SQL: " + query);
				conn = (ConnectionWrapper) ic.getResource(resourceName);
				Connection actualConn = getConnection(conn);
				Diagnostics.debug("actualConn = " + actualConn);
				String filter = getString(ic, "filter");
				if (filter != null && filter.length() > 0)
				{
					if (sql == null)
						sql = Sql.fetchSql(query);
					sql = ic.processFilter(sql, filter);
				}
				String orderBy = ic.getParameter(name + "_order_by");
				if (orderBy != null)
				{
					if (sql == null)
						sql = Sql.fetchSql(query);
					sql = ic.processFilter(sql, "orderby(" + orderBy + ")");
					query = sql.getQuery();
				}
			}
			else if (rs instanceof MemoryResults)
				numRows = ((MemoryResults) rs).size();
			ic.setTransientDatum("numcols", "0");
			ic.setTransientDatum("skipcols", "0");
			Vector filterList = new Vector();
			ic.setTransientDatum(name + "_filter_list", filterList);
			header.append(title(ic, name, target, filterList));
			if (sql != null)
				ic.setTransientDatum(name + "_sql", sql);
			else if (query != null)
				ic.setTransientDatum(name + "_query", query);
			header.append(filter(ic, name, target, filterList, maxRows));
			sql = (Sql) ic.getTransientDatum(name + "_sql");
			if (query != null)
			{
				if (sql != null)
				{
					query = sql.getQuery();
					Diagnostics.debug("SmartTableComponent.include() post-filter SQL: " + query);
				}
				//             ResultSet actualRS = stmt.executeQuery(query.toString());
				//             rs = new QueryResults(conn, stmt, actualRS);
				//  rs = stmt.executeQuery(query.toString());

				// new prepared statement code
				pstmt = IMSUtil.queryToPreparedStatement(conn, new StringBuffer(query));
				ResultSet psRS = pstmt.executeQuery();
				rs = new QueryResults(conn, pstmt, psRS);

			}
			ic.setTransientDatum(SQLLoopComponent.CURSOR_VAR_PREFIX + name, rs);
			MetaData meta = new MetaData(rs.getMetaData());
			ic.setTransientDatum(name + "_metadata", meta);
			int startWithRow = 1;
			String tmp = ic.getParameter(name + "_start_with");
			if (tmp != null)
				startWithRow = Integer.parseInt(tmp);
			body.append(body(ic, name, rs, meta, startWithRow, maxRowCount));
			int rowid = Integer.parseInt((String) ic.getRequiredTransientDatum("rowid"));
			String doTotal = (String) ic.getTransientDatum(name + "_total");
			if (doTotal != null)
				footer.append(total(ic, name));
			ic.removeTransientDatum(name + "_total");
			if (startWithRow > 1 || maxRowCount != 0 && rowid - startWithRow >= maxRowCount)
			{
				numRows = Integer.parseInt((String) ic.getTransientDatum("rowCount"));
				Diagnostics.debug("Using rowCount of " + numRows);
				//             if(query != null)
				//             {
				//                 if(sql == null)
				//                     sql = Sql.fetchSql(query);
				//                 Sql count_sql = ic.processFilter(sql, "count");
				//                 String count_query = count_sql.getQuery();
				//                 Diagnostics.debug("SmartTableComponent.include() count SQL: " + count_query);
				//                 String count = conn.queryEx(count_query);
				//                 if(count != null && count.length() > 0)
				//                     numRows = Integer.parseInt(count);
				//             }
				footer.append(footer(ic, startWithRow, maxRowCount, maxRows, numRows, target));
			}
			script.append("<script type=\"text/javascript\">\n");
			script.append("<!--//\n");
			for (int i = 1; i <= meta.getColumnCount(); i++)
				script.append("\tvar " + meta.getColumnName(i) + "='';\n");

			script.append("// -->\n");
			script.append("</script>\n");
			if (rowid == 2 && getBoolean(ic, "autoClick") && (String) ic.getTransientDatum("autoClickURL") != null)
				ic.sendRedirect((String) ic.getTransientDatum("autoClickURL"));
		}
		finally
		{
			if (pstmt != null)
				pstmt.close();
			if (conn != null)
				conn.release();
		}
	}

	protected String body(InvocationContext ic, String name, QueryResults rs, MetaData meta, int startWithRow, int maxRowCount) throws Exception
	{
		StringBuffer body = new StringBuffer();

		int height = getInt(ic, "rowHeight");
		int rowid = 0;
		int rowCount = 0;

		//handle case when coloring row when some condition exists
		String colorRowClasses = getString(ic, "colorRowClasses");
		boolean hasColorRowClasses = StringUtil.hasAValue(colorRowClasses);
		String colorRowCol = getString(ic, "colorRowCol");
		String colorRowVal = getString(ic, "colorRowVal");
		int num_cols = meta.getColumnCount();

		Vector alt1 = StringUtil.stringToVector(getString(ic, "alternator1"), ':');
		Vector alt2 = StringUtil.stringToVector(getString(ic, "alternator2"), ':');

		// skip
		for (rowid = 1; (rowid < startWithRow) && rs.next(); rowid++, rowCount++)
		{
		}
		ic.setTransientDatum(name + ":rowid", "" + rowid);
		ic.setTransientDatum("rowid", "" + rowid); // necessary since some templates still depend on plain rowid

		if (alt1 != null)
			ic.setTransientDatum(name + ":alt1", alt1.elementAt((rowid - 1) % alt1.size()));
		if (alt2 != null)
			ic.setTransientDatum(name + ":alt2", alt2.elementAt((rowid - 1) % alt2.size()));

		ic.setTransientDatum(name + ":firstRow", "" + true);

		while (rs.next())
		{
			ic.setTransientDatum("row", "1");
			rowCount++;

			if (maxRowCount != 0 && rowid >= (maxRowCount + startWithRow))
				break;
			//body.append("<a href=\"JavaScript:");
			//String temp = "select(" + (rowid-startWithRow) + ",";
			//for (int i = 1; i <= meta.getColumnCount(); i++)
			//{
			//	if (i > 1) temp += ",";
			//	temp += StringUtil.toJavaScriptString(rs.getString(i));
			//}
			//temp += ")";
			//if (rowid == 1)
			//	selectFirstRow = temp;
			//body.append(temp);
			//body.append("\">\n");

			//test if we should color this row
			if (hasColorRowClasses)
			{
				ic.removeTransientDatum("hasColorRowClasses");
				for (int i = 1; i <= num_cols; i++)
				{
					if (meta.getColumnName(i).equalsIgnoreCase(colorRowCol) && rs.getString(i) != null && rs.getString(i).equals(colorRowVal))
					{
						ic.setTransientDatum("hasColorRowClasses", colorRowClasses);
						break;
					}
				}
			}

			body.append("<tr rowid=\"" + rowid + "\"");
			if (height > 0)
				body.append(" height=\"" + height + "\"");
			//body.append(" style=\"cursor:hand\"");
			//String rowRolloverClass = getString(ic,"rowRolloverClass");
			//if (rowRolloverClass != null)
			//{
			//	body.append(" onMouseOver=\"return setRowClass(" + (rowid-startWithRow) + ",'" + rowRolloverClass + "')\"");
			//	body.append(" onMouseOut=\"return resetRowClass(" + (rowid-startWithRow) + ")\"");
			//}
			body.append(">");

			if (getString(ic, "folders") != null)
			{
				ic.setTransientDatum("hashResults", rs);
			}

			body.append(includeChildren(ic));

			body.append("</tr>\n");
			//body.append("</a>\n");
			rowid++;
			ic.setTransientDatum(name + ":rowid", "" + rowid);
			ic.setTransientDatum("rowid", "" + rowid); // necessary since some templates still depend on plain rowid

			if (alt1 != null)
				ic.setTransientDatum(name + ":alt1", alt1.elementAt((rowid - 1) % alt1.size()));
			if (alt2 != null)
				ic.setTransientDatum(name + ":alt2", alt2.elementAt((rowid - 1) % alt2.size()));

			ic.removeTransientDatum(name + ":firstRow");
		}

		//get an accurate row count
		while (rs.next())
		{
			rowCount++;
		}
		rs.close();
		rs = null;
		ic.setTransientDatum("rowCount", Integer.toString(rowCount));

		ic.removeTransientDatum(name + ":firstRow");
		ic.setTransientDatum(name + ":numRows", "" + (rowid - 1));
		ic.setTransientDatum(name + ":rowsReturned", "" + (rowid - 1)); //this value may be overwritten when drawing the footer
		ic.setTransientDatum(name + ":rowsDisplayed", "" + (rowid - startWithRow));

		if (rowid == startWithRow) // No data
		{
			ic.setTransientDatum(name + ":nodata", "true");

			// handle colorRowClasses
			ic.removeTransientDatum("hasColorRowClasses");

			String numcols = (String) ic.getRequiredTransientDatum("numcols");
			body.append("<tr><td");
			body.append(" colspan=\"" + numcols + "\"");
			if (height > 0)
				body.append(" height=\"" + height + "\"");
			String css = getRowClass(ic, rowid, null);
			if (css != null)
				body.append(" class=\"" + css + "\"");
			body.append(">");
			body.append("No items in the list");
			body.append("</td>\n");
			body.append("</tr>\n");
		}

		// body.append(getScript(ic, name, meta, selectFirstRow, rowid));

		return body.toString();
	}

	protected String getFilterClass(InvocationContext ic) throws Exception
	{
		String result = getString(ic, "filterClass");
		if (result == null)
			return getTitleClass(ic, "normal");
		else
			return result;
	}

	protected String getTitleClass(InvocationContext ic, String type) throws Exception
	{
		String result = null;
		String normal = null;
		String rollover = null;
		String pressed = null;
		String sorted = null;
		String sortedRollover = null;
		String sortedPressed = null;
		try
		{
			String classes = getString(ic, "titleClass");
			Vector tmp = StringUtil.stringToVector(classes, ',');
			normal = (String) tmp.elementAt(0);
			rollover = (String) tmp.elementAt(1);
			pressed = (String) tmp.elementAt(2);
			sorted = (String) tmp.elementAt(3);
			sortedRollover = (String) tmp.elementAt(4);
			sortedPressed = (String) tmp.elementAt(5);
		}
		catch (Exception e)
		{
		}
		if (type.equalsIgnoreCase("normal"))
			result = normal;
		else if (type.equalsIgnoreCase("rollover"))
			result = rollover;
		else if (type.equalsIgnoreCase("pressed"))
			result = pressed;
		else if (type.equalsIgnoreCase("sorted"))
			result = sorted == null ? getTitleClass(ic, "normal") : sorted;
		else if (type.equalsIgnoreCase("sortedRollover"))
			result = sortedRollover == null ? getTitleClass(ic, "rollover") : sortedRollover;
		else if (type.equalsIgnoreCase("sortedPressed"))
			result = sortedPressed == null ? getTitleClass(ic, "pressed") : sortedPressed;
		else
			throw new Exception("Unknown class type \"" + type + "\"");
		return result;
	}

	protected String getRowClass(InvocationContext ic, int rowid, String rowClassString) throws Exception
	{
		String result = null;

		//handle case when colorRowClasses condition has been met
		String colorRowClasses = (String) ic.getTransientDatum("hasColorRowClasses");
		List colorRowClassesList = StringUtil.stringToVector(colorRowClasses);
		if (colorRowClasses != null && !colorRowClasses.equalsIgnoreCase("false"))
		{
			//use first class of colorRowClasses (1st=rowClass, 2nd=LinkClass, 3rd=RollOverclass)
			if (colorRowClassesList.size() > 0)
			{
				result = (String) colorRowClassesList.get(0);
			}
			else
			{
				Diagnostics.warning("Did not find first class (Row Class) of colorRowClasses '" + colorRowClasses + "'");
			}
		}
		else
		{
			if (rowClassString == null)
				rowClassString = getString(ic, "rowClass");

			List rowClass = StringUtil.stringToVector(rowClassString, ',');
			if (rowClass != null && rowClass.size() > 0)
				result = (String) rowClass.get((rowid - 1) % rowClass.size());
		}
		return result;
	}

	/**
		*  May return null if not found
		*/
	protected String getCellLinkClass(InvocationContext ic, int rowid, String cellClassString) throws Exception
	{
		String result = null;

		//handle case when colorRowClasses condition has been met
		String colorRowClasses = (String) ic.getTransientDatum("hasColorRowClasses");
		List colorRowClassesList = StringUtil.stringToVector(colorRowClasses);
		if (colorRowClasses != null && !colorRowClasses.equalsIgnoreCase("false"))
		{
			//use second class of colorRowClasses (1st=rowClass, 2nd=LinkClass, 3rd=RollOverclass)
			if (colorRowClassesList.size() > 1)
			{
				result = (String) colorRowClassesList.get(1);
			}
			else
			{
				Diagnostics.warning("Did not find 2nd class (Link Class) in colorRowClasses in string '" + colorRowClasses + "', using default cellLinkClass.");
			}
		}
		else
		{
			if (cellClassString == null)
				cellClassString = getString(ic, "cellLinkClasses");
			result = getRowClass(ic, rowid, cellClassString);
		}

		return result; //may not have a cellLinkClass, will return null in that case.
	}

	protected String getRowRolloverClass(InvocationContext ic, int rowid, String rowClassString) throws Exception
	{
		String result = null;

		//handle case when colorRowClasses condition has been met
		String colorRowClasses = (String) ic.getTransientDatum("hasColorRowClasses");
		List colorRowClassesList = StringUtil.stringToVector(colorRowClasses);
		if (colorRowClasses != null && !colorRowClasses.equalsIgnoreCase("false"))
		{
			//use third class of colorRowClasses (1st=rowClass, 2nd=LinkClass, 3rd=RollOverclass)
			if (colorRowClassesList.size() > 2)
			{
				result = (String) colorRowClassesList.get(2);
			}
			else
			{
				Diagnostics.warning("Did not find 3rd class (RowRollover Class) in colorRowClasses in string '" + colorRowClasses + "', using default rowRolloverClass.");
			}
		}
		else
		{
			if (rowClassString == null)
				rowClassString = getString(ic, "rowRolloverClass");
			result = getRowClass(ic, rowid, rowClassString);
		}

		return result;
	}



	public static Connection getConnection(ConnectionWrapper conn)
	{
		Connection result = null;
		try
		{
			// get the reflected object
			Field field = conn.getClass().getDeclaredField("theConnection");
			// set accessible true
			field.setAccessible(true);
			result = (Connection) field.get(conn);
		}
		catch (SecurityException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		catch (IllegalArgumentException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		catch (NoSuchFieldException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		catch (IllegalAccessException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}

}
