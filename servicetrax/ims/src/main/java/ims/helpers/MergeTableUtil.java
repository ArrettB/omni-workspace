/*
 * Created on Feb 19, 2004 To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package ims.helpers;

import java.util.Date;
import java.util.Iterator;
import java.util.List;

import dynamic.dbtk.InClause;
import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * @author gcase To change the template for this generated type comment go to
 *         Window - Preferences - Java - Code Generation - Code and Comments
 */
public class MergeTableUtil
{

	/**
	 * DOCUMENT ME!
	 * 
	 * @param masterKeyName
	 * @param selectedKeyName
	 * @param masterKeyValue
	 * @param selectedKeyValues
	 * @param joinTable
	 * @param selectedTable
	 * @param conn
	 * @throws Exception
	 */
	public static void updateJoinTable(String masterKeyName, String selectedKeyName, String masterKeyValue, List selectedKeyValues, String joinTable,
			String selectedTable, ConnectionWrapper conn) throws Exception
	{
		updateJoinTable(masterKeyName, selectedKeyName, masterKeyValue, selectedKeyValues, joinTable, selectedTable, null, null, true, conn);
	}

	/**
	 * DOCUMENT ME!
	 * 
	 * @param masterKeyName
	 * @param selectedKeyName
	 * @param masterKeyValue
	 * @param selectedKeyValues
	 * @param joinTable
	 * @param selectedTable
	 * @param additionalColumnNames
	 * @param additionalColumnValues
	 * @param conn
	 * @throws Exception
	 */
	public static void updateJoinTable(String masterKeyName, String selectedKeyName, String masterKeyValue, List selectedKeyValues, String joinTable,
			String selectedTable, List additionalColumnNames, List additionalColumnValues, ConnectionWrapper conn) throws Exception
	{
		updateJoinTable(masterKeyName, selectedKeyName, masterKeyValue, selectedKeyValues, joinTable, selectedTable, additionalColumnNames,
				additionalColumnValues, true, conn);
	}
	
	
	public static void updateJoinTable(String masterKeyName, String selectedKeyName, String masterKeyValue, List selectedKeyValues, String joinTable,
			String selectedTable, List additionalColumnNames, List additionalColumnValues, boolean doDelete, ConnectionWrapper conn) throws Exception
	{
		updateJoinTable(masterKeyName, selectedKeyName, masterKeyValue, selectedKeyValues, joinTable, selectedTable, 
				additionalColumnNames, additionalColumnValues, doDelete, null, conn);
	}


	
	
	
	public static void updateJoinTable(String masterKeyName, String selectedKeyName, String masterKeyValue, List selectedKeyValues, 
			String joinTable, String selectedTable, List additionalColumnNames, List additionalColumnValues, boolean doDelete, 
			String additionalDeleteWhereClause, ConnectionWrapper conn) throws Exception 
	{
		InClause selectedClause = new InClause();
		for (Iterator iter = selectedKeyValues.iterator(); iter.hasNext(); )
		{
			String key = (String) iter.next();
			selectedClause.add(key);

		}

		//selectedClause.add(selectedKeyValues);

		//First delete anything that has not been selected and currently
		// exists
		if (doDelete)
		{
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM ").append(joinTable);
			delete.append(" WHERE ").append(masterKeyName).append(" = ").append(masterKeyValue);

			if (selectedClause.isValid())
			{
				delete.append(" AND ").append(selectedClause.getNotInClause(selectedKeyName));
			}

			if (StringUtil.hasAValue(additionalDeleteWhereClause)) {
				delete.append(" AND ").append(additionalDeleteWhereClause);
			}
			
			Diagnostics.debug("Deleting from " + joinTable + ", statement = " + delete);

			int deleted = conn.updateEx(delete);
			Diagnostics.debug(deleted + " rows deleted.");
		}

		//and now create everything that has been selected, but does not yet
		// exist
		if (selectedClause.isValid())
		{
			StringBuffer insert = new StringBuffer();
			insert.append("INSERT INTO ").append(joinTable).append(" (").append(masterKeyName).append(", ").append(selectedKeyName);

			if (additionalColumnNames != null)
			{
				for (int i = 0; i < additionalColumnNames.size(); i++)
				{
					insert.append(", ").append(additionalColumnNames.get(i));
				}
			}

			insert.append(")");
			insert.append(" SELECT ").append(masterKeyValue);
			insert.append(", selected.").append(selectedKeyName);

			if (additionalColumnValues != null)
			{
				for (int i = 0; i < additionalColumnValues.size(); i++)
				{
					Object val = additionalColumnValues.get(i);

					if (val instanceof Date)
					{
						insert.append(", ").append(conn.toSQLString((Date) val));
					}

					/*
					 * else if (val instanceof String) { insert.append(",
					 * ").append(conn.toSQLString((String) val)); }
					 */
					else
					{
						insert.append(", ").append(val);
					}
				}
			}

			insert.append(" FROM ").append(selectedTable).append(" selected");
			insert.append(" WHERE ").append(selectedClause.getInClause("selected." + selectedKeyName));
			insert.append(" AND selected.").append(selectedKeyName).append(" NOT IN (");
			insert.append(" SELECT ").append(selectedKeyName);
			insert.append(" FROM ").append(joinTable);
			insert.append(" WHERE ").append(masterKeyName).append(" = ").append(masterKeyValue);
			insert.append(")");

			Diagnostics.debug("Inserting into " + joinTable + ", statement = " + insert);

			int inserted = conn.updateEx(insert);
			Diagnostics.debug(inserted + " rows inserted.");

		}
		else
		{
			Diagnostics.debug("Insert was skipped, nothing selected to insert.");
		}
	}
}
