package ims.handlers.estimator;

import java.io.File;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import jp.ne.so_net.ga2.no_ji.jcom.JComException;
import jp.ne.so_net.ga2.no_ji.jcom.ReleaseManager;
import jp.ne.so_net.ga2.no_ji.jcom.excel8.ExcelApplication;
import jp.ne.so_net.ga2.no_ji.jcom.excel8.ExcelRange;
import jp.ne.so_net.ga2.no_ji.jcom.excel8.ExcelWorkbook;
import jp.ne.so_net.ga2.no_ji.jcom.excel8.ExcelWorkbooks;
import jp.ne.so_net.ga2.no_ji.jcom.excel8.ExcelWorksheet;
import jp.ne.so_net.ga2.no_ji.jcom.excel8.ExcelWorksheets;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;
import dynamic.util.xml.XMLUtils;


/**
 * Methods to manipulate the XLS Estimator spreadsheet.
 * 
 * @version $Id$
 */
public class QuoteExcelHandler {

	private File excel_file = null;
	private File template = null;
	private String requestId = null;
	private String version = null;
	private String subversion = null;
	private String userId = null;
	private String projectDir = null;


	public QuoteExcelHandler(){	}

	public QuoteExcelHandler(File excel_file){
		this.excel_file = excel_file;
	}

	/**
	 * get values from excel spreadsheet and
	 * insert them into the database
	 * @param xml_file
	 */
	public void getValuesSetDatabase(File xml_file, String quoteId, ConnectionWrapper conn) throws Exception {

		PreparedStatement stmt = null;
		ReleaseManager rm = null;
		ExcelApplication excel = null;
		StringBuffer query = new StringBuffer();
		query .append("UPDATE quotes SET date_modified = getdate(), modified_by = ?"); 
		List<String>paramList = new ArrayList<String>();
		paramList.add(userId);
		

		try{
			rm = new ReleaseManager();
			Diagnostics.debug("PATH:" + excel_file.getPath());

			// open excel object
			excel = new ExcelApplication(rm);
			excel.Visible(false);
			ExcelWorkbooks xlBooks = excel.Workbooks();
			ExcelWorkbook xlBook = xlBooks.Open(excel_file.getPath());
			ExcelWorksheets xlSheets = xlBook.Worksheets();

			// open xml file for mapping parameters
			Document xml = XMLUtils.parse(xml_file);
			NodeList sheets = xml.getElementsByTagName("sheet");
			int sheet_total = sheets.getLength();

			// first loop through each one of the sheet nodes
			for(int sheet_count = 0; sheet_count < sheet_total; sheet_count++)
			{

				Node sheet = sheets.item(sheet_count);
				String sheet_number = XMLUtils.getValue(sheet, ":number");

				// set the excel work sheet to the sheet number from the node
				ExcelWorksheet xlSheet = xlSheets.Item(Integer.parseInt(sheet_number));
				ExcelRange xlRange = xlSheet.Cells();
				
				NodeList tables = XMLUtils.getElementsByTagName(sheet, "table");
				
				for (int i = 0; i < tables.getLength(); i++)
				{
					Node table = tables.item(i);
					if ("quotes".equals(XMLUtils.getValue(table, ":name")))
					{
						// grab all the items within the sheet node
						NodeList items = XMLUtils.getElementsByTagName(table, "item");
						int item_total = items.getLength();

						// loop through the items
						for(int item_count = 0; item_count < item_total; item_count++)
						{
							Node task = items.item(item_count);
							String field = XMLUtils.getValue(task, "field");
							String value = getExcelCellValue(field, xlRange, task);

							query.append(",").append(field).append(" = ?");
							paramList.add(value);
						}
						
					}
					else
					{
						updateQuoteDetail(quoteId, table, xlRange, conn);
					}
					
				}

			}

			query.append(" WHERE request_id = ? ")
			     .append(" AND version = ? ")
			     .append(" AND sub_version = ?");
			paramList.add(requestId);
			paramList.add(version);
			paramList.add(subversion);
			
			conn.update(query, paramList.toArray());

			xlBook.Close(false,null,false);
	       

		} catch (JComException e) {

			Diagnostics.error("There was an error in getting data from the excel file into the database", e);
			e.printStackTrace();

        } catch (Exception e) {

			Diagnostics.error("There was an error in getting data from the excel file into the database", e);
			e.printStackTrace();

		} finally {
			if (excel != null) {
				excel.Quit();
				excel = null;
			}
			if (stmt != null) stmt.close();
			if (rm != null) {
				rm.release();
				rm = null;
			}
		}
	}

	/**
	 * Get the matching value from the Excel cell as defined in the given task.
	 * 
	 * @param field
	 * @param xlRange
	 * @param task
	 * @return
	 * @throws Exception
	 */
	String getExcelCellValue(String field, ExcelRange xlRange, Node task) throws Exception
	{
		String column = XMLUtils.getValue(task, "column");
		String row = XMLUtils.getValue(task, "row");

		// adjust the width so values show up correctly and not '#####'
		try {
			xlRange.Item(Integer.parseInt(row), Integer.parseInt(column)).Columns().AutoFit();
		} catch (Exception e) {
			Diagnostics.error("Problem setting width for field " + field + ", column " + column + ", row " + row, e);
		}

		String value = xlRange.Item(Integer.parseInt(row), Integer.parseInt(column)).Text();
		value = value.trim();
		
		if ("[QUOTE_TOTAL]".equalsIgnoreCase(field)) {
			value = StringUtil.replaceString(value, "-", "");
			value = StringUtil.replaceString(value, " ", "");
			value = StringUtil.replaceString(value, "$", "");
			value = StringUtil.replaceString(value, ",", "");
		}

		return value;
	}
	
	/**
	 * Put the quote detail data into the quote detail table.
	 *  
	 * @param quoteId
	 * @param table
	 * @param conn
	 * @throws Exception 
	 */
	private void updateQuoteDetail(String quoteId, Node table, ExcelRange xlRange, ConnectionWrapper conn) throws Exception
	{
		String tableName = XMLUtils.getValue(table, ":name");

		NodeList sets = XMLUtils.getElementsByTagName(table, "set");

		for (int i = 0; i < sets.getLength(); i++)
		{
			Node set = sets.item(i);
			StringBuffer insertSQL = new StringBuffer("INSERT INTO ").append(tableName).append(" (");
			StringBuffer insertParams = new StringBuffer();
			StringBuffer updateSQL = new StringBuffer("UPDATE ").append(tableName).append(" SET ");
			
			NodeList items = XMLUtils.getElementsByTagName(set, "item");
			List<String> parameters = new ArrayList<String>();
			
			boolean first = true;
			boolean hasRequiredValue = true;
			for (int itemIndex = 0; itemIndex < items.getLength(); itemIndex++)
			{
				Node item = items.item(itemIndex);
				String field = XMLUtils.getValue(item, "field");
				String value = getExcelCellValue(field, xlRange, item);
				
				boolean required = StringUtil.toBoolean(XMLUtils.getValue(item, ":required"));
				String maxLengthStr = XMLUtils.getValue(item, ":maxlength");
				if (StringUtil.hasAValue(maxLengthStr))
				{
					int maxLength = Integer.parseInt(maxLengthStr);
					value = StringUtil.truncate(value, maxLength);
				}
				
				if (required && !StringUtil.hasAValue(value))
					hasRequiredValue = false;
				
				parameters.add(value);

				if (!first)
				{
					insertSQL.append(",");
					insertParams.append(",");
					updateSQL.append(",");
				}
				// insert column
				insertSQL.append(field);
				
				// insert ?
				insertParams.append("?");
				
				// update columnName = value
				updateSQL.append(field).append(" = ?");

				first = false;
			}

			updateSQL.append(" WHERE quote_id = ? AND set_number = ?");

			String setNumber = XMLUtils.getValue(set, ":number");
			parameters.add(quoteId);
			parameters.add(setNumber);
			long count = conn.update(updateSQL, parameters.toArray());
			if (count == 0 && hasRequiredValue)
			{
				if (!first)
				{
					insertSQL.append(",");
					insertParams.append(",");
				}
				insertSQL.append("quote_id, set_number, created_by, date_created) VALUES (");
				insertParams.append("?,?,?,getdate() )");
				parameters.add(userId);
				conn.update(insertSQL.append(insertParams), parameters.toArray());
			}
			else if (count == 1 && !hasRequiredValue)
			{
				String sql = "DELETE FROM " + tableName + " WHERE quote_id = ? AND set_number = ?";
				conn.update(sql, new String[] {quoteId, setNumber});
			}
		}
	}

	/**
	 * get values from the database and
	 * place them into the excel sheet.
	 * @param xml_file
	 */
	public void setDatabaseGetValues(File xml_file, ConnectionWrapper conn) throws Exception {

		Diagnostics.debug2("EXCEL:START BUILDING FILE - 1");

		ReleaseManager rm = null;
		ExcelApplication excel = null;

		Diagnostics.debug2("EXCEL:DECLARE RM - 2");

		try{
			//open excel object
			rm = new ReleaseManager();
			excel = new ExcelApplication(rm);
			Diagnostics.debug2("EXCEL:CREATE EXCEL OBJECT - 3");
			excel.Visible(false);
			Diagnostics.debug2("EXCEL:SET VISIBLE TO FALSE - 4");
			ExcelWorkbooks xlBooks = excel.Workbooks();
			Diagnostics.debug2("EXCEL:OPEN WORKBOOK - 5");
			ExcelWorkbook xlBook = xlBooks.Open(template.getPath());
			Diagnostics.debug2("EXCEL:OPEN EXCEL FILE IN EXCEL - 5");
			ExcelWorksheets xlSheets = xlBook.Worksheets();
			Diagnostics.debug2("EXCEL:OPEN WORKSHEET - 6");



			// open xml file for mapping parameters
			Document xml = XMLUtils.parse(xml_file);
			NodeList querys = xml.getElementsByTagName("query");
			Diagnostics.debug2("EXCEL:OPENED XML FILE - 7");

			if( querys.getLength() == 1 )
			{

				Node query_node = querys.item(0);
				String query = XMLUtils.getValue(query_node, "").trim();

				QueryResults rs = null;
				
				try
				{
					rs = conn.select(query, requestId);
					Diagnostics.debug2("EXCEL:EXCUTE DATABASE READ " + query + " - 8");
	
					while (rs.next())
					{
	
						NodeList sheets = xml.getElementsByTagName("sheet");
						int sheet_total = sheets.getLength();
						Diagnostics.debug2("EXCEL:SHEET TOTAL: " + sheet_total);
	
						// first loop through each one of the sheet nodes
						for(int sheet_count = 0; sheet_count < sheet_total; sheet_count++)
						{
	
							Node sheet = sheets.item(sheet_count);
							String sheet_number = XMLUtils.getValue(sheet, ":number");
	
							// set the excel work sheet to the sheet number from the node
							ExcelWorksheet xlSheet = xlSheets.Item(Integer.parseInt(sheet_number));
							ExcelRange xlRange = xlSheet.Cells();
	
							// grab all the items within the sheet node
							NodeList items = XMLUtils.getElementsByTagName(sheet, "item");
							int item_total = items.getLength();
	
							Diagnostics.debug2("EXCEL:ITEM TOTAL: " + item_total);
	
							// loop through the items
							for(int item_count = 0; item_count < item_total; item_count++)
							{
	
								Node task = items.item(item_count);
	
								String column = XMLUtils.getValue(task, "column");
								String row = XMLUtils.getValue(task, "row");
								String field = XMLUtils.getValue(task, "field").trim();
	
								String value = rs.getString(field);
	
								xlRange.Item(Integer.parseInt(row), Integer.parseInt(column)).Value(value);
	
							}
	
							ExcelWorksheet xlS = xlSheets.Item(2);
							ExcelRange xlR = xlS.Cells();
							xlR.Item(137, 14).Value(this.projectDir);
	
						}
	
					}
				}
				finally
				{
					if (rs != null)
						rs.close();
				}

				Diagnostics.debug2("EXCEL:SAVE EXCEL FILE " + excel_file.getPath() + " - 9");
				xlBook.SaveAs(excel_file.getPath());

				xlBook.Close(false,null,false);
				Diagnostics.debug2("EXCEL:CLOSE EXCEL - 10");
		        

			}else{

				Diagnostics.error("The set xml file for the excel spreed sheet must have one query!");

			}



		}catch(SQLException e)
		{

			Diagnostics.debug2("There was an error in trying to put data into the excel file." + e);
			e.printStackTrace();

		}catch (Exception e)
		{

			Diagnostics.debug2("There was an error in trying to put data into the excel file." + e);
			e.printStackTrace();

		}
		finally
		{
			if (excel != null) {
				excel.Quit();
				excel = null;
			}
			if (rm != null) {
				rm.release();
				rm = null;
			}
		}

	}

	public void setDataToQuote(ConnectionWrapper conn){
		String query = "sp_estimator 7, " + requestId + ", NULL, " + version + ", " + subversion + ", NULL, NULL";
		try
		{
			conn.updateEx(query);
		}
		catch(SQLException e)
		{
			Diagnostics.debug2("There was an error trying to set an transfer excel to quote.");
		}
	}


	public void setFileTemplate(File template){	this.template = template; }

	public void setRequestId(String requestId){ this.requestId = requestId; }

	public void setVersion(String version){ this.version = version; }

	public void setSubVersion(String subversion){ this.subversion = subversion; }

	public void setUserId(String userid){ this.userId =  userid; }

	public void setProjectDir(String projectDir) { this.projectDir = projectDir; }




}
