package ims.handlers.estimator;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;
import dynamic.util.xml.XMLUtils;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellReference;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import java.io.File;
import java.io.FileOutputStream;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;


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
		StringBuffer query = new StringBuffer();
		query .append("UPDATE quotes SET date_modified = getdate(), modified_by = ?"); 
		List<String>paramList = new ArrayList<String>();
		paramList.add(userId);
		Workbook workbook = null;
		

		try{
			Diagnostics.debug("PATH:" + excel_file.getPath());

			workbook = WorkbookFactory.create(excel_file);

			// open xml file for mapping parameters
			Document xml = XMLUtils.parse(xml_file);
			NodeList sheets = xml.getElementsByTagName("sheet");
			int sheet_total = sheets.getLength();

			// first loop through each one of the sheet nodes
			for(int sheet_count = 0; sheet_count < sheet_total; sheet_count++)
			{

				Node sheet = sheets.item(sheet_count);
				String sheet_number = XMLUtils.getValue(sheet, ":number");
				int sheetIndex = Integer.parseInt(sheet_number) - 1;

				// set the excel work sheet to the sheet number from the node
				Sheet poisheet = workbook.getSheetAt(sheetIndex);

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
							String value = getExcelCellValue(field, poisheet, task);

							query.append(",").append(field).append(" = ?");
							paramList.add(value);
						}
						
					}
					else
					{
						updateQuoteDetail(quoteId, table, poisheet, conn);
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

			workbook.close();
        } catch (Exception e) {
			Diagnostics.error("There was an error in getting data from the excel file into the database", e);
		} finally {
			if (workbook != null) {
				workbook.close();
				workbook = null;
			}
			if (stmt != null) stmt.close();
		}
	}

	String getExcelCellValue(String field, Sheet xlSheet, Node task) throws Exception {
		String columnString = XMLUtils.getValue(task, "column");
		String rowString = XMLUtils.getValue(task, "row");

		int column = Integer.parseInt(columnString) - 1;
		int row = Integer.parseInt(rowString) - 1;
		CellReference cellRef = new CellReference(row, column);

		Diagnostics.debug("Field " + field  + " is cell at " + row + ", column " + column + " is " + cellRef.formatAsString());

		// get the text that appears in the cell by getting the cell value and applying any data formats (Date, 0.00, 1.23e9, $1.23, etc)
		Row xlRow = xlSheet.getRow(row);
		Cell xlCell = xlRow.getCell(column);
		String text = new DataFormatter().formatCellValue(xlCell);
		Diagnostics.debug("Cell value " + text);

		switch (xlCell.getCellType()) {
			case Cell.CELL_TYPE_BLANK:
				return "";
			case Cell.CELL_TYPE_BOOLEAN:
				return new Boolean(xlCell.getBooleanCellValue()).toString();
			case Cell.CELL_TYPE_NUMERIC:
			case Cell.CELL_TYPE_FORMULA:
				if (DateUtil.isCellDateFormatted(xlCell)) {
					SimpleDateFormat formatter = new SimpleDateFormat("MM/dd/yyyy");
					Date cellValue = xlCell.getDateCellValue();
					return formatter.format(cellValue);
				} else {
					return new Double(xlCell.getNumericCellValue()).toString();
				}
			default:
				return text;
		}
	}

	/**
	 * Put the quote detail data into the quote detail table.
	 *
	 * @param quoteId
	 * @param table
	 * @param conn
	 * @throws Exception
	 */
	private void updateQuoteDetail(String quoteId, Node table, Sheet sheet, ConnectionWrapper conn) throws Exception
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
				String value = getExcelCellValue(field, sheet, item);

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

		Workbook workbook = null;

		try{
			//open excel object
			workbook = WorkbookFactory.create(new File(template.getPath()));

			Diagnostics.debug2("EXCEL:OPEN EXCEL FILE - 2");

			for(int i = 0; i < workbook.getNumberOfSheets(); i++) {
				Diagnostics.debug2("EXCEL:Sheet at index " + i + " is " + workbook.getSheetAt(i).getSheetName());
			}

			// open xml file for mapping parameters
			Document xml = XMLUtils.parse(xml_file);
			NodeList querys = xml.getElementsByTagName("query");
			Diagnostics.debug2("EXCEL:OPENED XML FILE - 3");

			if( querys.getLength() == 1 )
			{

				Node query_node = querys.item(0);
				String query = XMLUtils.getValue(query_node, "").trim();

				QueryResults rs = null;

				try
				{
					rs = conn.select(query, requestId);
					Diagnostics.debug2("EXCEL:EXECUTE DATABASE READ " + query + " - 8");

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

							int sheetIndex = Integer.parseInt(sheet_number) - 1;
							Sheet poisheet = workbook.getSheetAt(sheetIndex);
							CreationHelper createHelper = workbook.getCreationHelper();
							Diagnostics.debug2("Sheet for sheet index " + sheetIndex + " is " + poisheet.getSheetName());

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

								Diagnostics.error("Field: " + field + ", row : " + row + ", cell : " + column + " set value to " + value);

								if(value != null) {
									int rowIndex = Integer.parseInt(row) - 1;
									int cellIndex = Integer.parseInt(column) - 1;
									Row xlRow = poisheet.getRow(rowIndex);
									Cell xlCell = xlRow.getCell(cellIndex);

									switch (xlCell.getCellType()) {
										case Cell.CELL_TYPE_BLANK:
											xlCell.setCellValue(createHelper.createRichTextString(value));
											break;
										case Cell.CELL_TYPE_BOOLEAN: {
											boolean b = Boolean.valueOf(value);
											xlCell.setCellValue(b);
											break;
										}
										case Cell.CELL_TYPE_STRING: {
											xlCell.setCellValue(createHelper.createRichTextString(value));
											break;
										}
										case Cell.CELL_TYPE_NUMERIC: {
											xlCell.setCellValue(value);
											if (DateUtil.isCellDateFormatted(xlCell)) {
												Diagnostics.error("Field: " + field + ", row : " + row + ", cell : " + column + " The cell is a date formatted cell!");
											} else {
												Double d = Double.parseDouble(value);
												xlCell.setCellValue(d);
											}
											break;
										}
										case Cell.CELL_TYPE_FORMULA:
											break;
										default:
											break;
									}
								}
							}

							// 0 offset so need to use 1 to get sheet number 2
							Sheet xlSheet = workbook.getSheetAt(1);
							Diagnostics.debug2("Sheet for sheet number 2 is " + xlSheet.getSheetName());

							// was 137
							Row xlRow = xlSheet.getRow(136);
							// was 14
							Cell xlCell = xlRow.getCell(13);
							if(xlCell == null) {
								xlCell = xlRow.createCell(13);
							}
							xlCell.setCellValue(this.projectDir);
						}
					}
				}
				finally
				{
					if (rs != null)
						rs.close();
				}

				Diagnostics.debug2("EXCEL:SAVE EXCEL FILE " + excel_file.getPath() + " - 9");
				FileOutputStream fos = new FileOutputStream(excel_file.getPath());

				workbook.write(fos);

				fos.flush();
				fos.close();

				Diagnostics.debug2("EXCEL:CLOSE EXCEL - 10");
			} else {
				Diagnostics.error("The set xml file for the excel spreed sheet must have one query!");
			}
		} catch( SQLException e )
		{

			Diagnostics.error("There was an error in trying to put data into the excel file.", e);

		} catch( Exception e )
		{

			Diagnostics.error("There was an error in trying to put data into the excel file.", e);
		}
		finally
		{
			if (workbook != null) {
				workbook.close();
				workbook = null;
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
			Diagnostics.error("There was an error trying to set an transfer excel to quote.", e);
		}
	}


	public void setFileTemplate(File template){	this.template = template; }

	public void setRequestId(String requestId){ this.requestId = requestId; }

	public void setVersion(String version){ this.version = version; }

	public void setSubVersion(String subversion){ this.subversion = subversion; }

	public void setUserId(String userid){ this.userId =  userid; }

	public void setProjectDir(String projectDir) { this.projectDir = projectDir; }




}
