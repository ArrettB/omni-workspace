/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.
 *
 * Copyright 2005, Dynamic Information Systems, LLC
 * $Header: C:\work\ims\src\ims\handlers\job_processing\XLSBaseReport.java, 4, 3/15/2006 6:03:16 PM, Blake Von Haden$
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO
 * EVENT SHALL DYNAMIC INFORMATIONS SYTEMS, LLC BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * ====================================================================
 */
package ims.handlers.job_processing;

import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.hssf.util.CellReference;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Hashtable;

/**
 * Create an Excel based report with specific formatting for ServiceTrax.
 * 
 * @version $Id: XLSBaseReport.java 1416 2008-10-31 19:52:40Z bvonhaden $
 */
public class XLSBaseReport
{
	private final static String DATETIMEFORMAT = "m/d/yy h:mm";
	private final static String MONEYFORMAT = "$#,##0.00";
	private final static String PERCENT_FORMAT = "0.00%";
	
	private HSSFWorkbook wb = null;
	private HSSFSheet currentSheet = null;
	HSSFCellStyle currencyStyle = null;
	HSSFCellStyle datetimeStyle = null;
	HSSFCellStyle titleStyle = null;
	HSSFCellStyle boldStyle = null;
	short currentRowIndex = -1;
	HSSFRow currentRow = null;
	Hashtable<String,Integer> breaks = new Hashtable<String,Integer>();
	private int currentColumnIndex = -1;
	private HSSFCell currentColumn;
	private int maxColumnIndex;
	private HSSFCellStyle currencySubtotalStyle;
	private HSSFCellStyle stringSubtotalStyle;
	private HSSFCellStyle stringRightJustifyStyle;
	private HSSFCellStyle percentStyle;

	public XLSBaseReport()
	{
		wb = new HSSFWorkbook();
		HSSFDataFormat format = wb.createDataFormat();
	
		currencyStyle = wb.createCellStyle();
		currencyStyle.setDataFormat(format.getFormat(MONEYFORMAT));


		percentStyle = wb.createCellStyle();
		percentStyle.setDataFormat(format.getFormat(PERCENT_FORMAT));

		currencySubtotalStyle = wb.createCellStyle();
		currencySubtotalStyle.setDataFormat(format.getFormat(MONEYFORMAT));
		currencySubtotalStyle.setBorderTop(HSSFCellStyle.BORDER_DOUBLE);

		stringSubtotalStyle = wb.createCellStyle();
		stringSubtotalStyle.setBorderTop(HSSFCellStyle.BORDER_DOUBLE);

		datetimeStyle = wb.createCellStyle();
		datetimeStyle.setDataFormat(HSSFDataFormat.getBuiltinFormat(DATETIMEFORMAT));

		titleStyle = wb.createCellStyle();

		HSSFFont font = wb.createFont();
		font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		titleStyle.setFont(font);
		titleStyle.setWrapText(true);
		titleStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);

		boldStyle = wb.createCellStyle();
		font = wb.createFont();
		font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		boldStyle.setFont(font);

		stringRightJustifyStyle = wb.createCellStyle();
		stringRightJustifyStyle.setAlignment(HSSFCellStyle.ALIGN_RIGHT);

		currentSheet = wb.createSheet("report");
	}

	public HSSFWorkbook getWb()
	{
		return wb;
	}

	/**
	 * Set the format for the date and time columns.
	 * 
	 * @param datetimeStyle
	 */
	public void setDatetimeStyle(String datetimeStyle)
	{
		this.datetimeStyle.setDataFormat(HSSFDataFormat.getBuiltinFormat(datetimeStyle));
	}

	/**
	 * Set the format for currency columns.
	 * 
	 * @param currencyStyle
	 */
	public void setCurrencyStyle(String currencyStyle)
	{
		HSSFDataFormat format = wb.createDataFormat();
		this.currencyStyle.setDataFormat(format.getFormat(currencyStyle));
	}

	/**
	 * Set up the report header information.
	 * 
	 */
	public void header(String left, String reportTitle)
	{
		SimpleDateFormat format = new SimpleDateFormat("M/d/yyyy");
		setLeftHeader(left);
		setCenterHeader(reportTitle);
		setRightHeader(format.format(new Date()) + "   Page " + HSSFHeader.page() + " of " + HSSFHeader.numPages());
	}

	/**
	 * Set the left header information.
	 * 
	 * @param value
	 */
	public void setLeftHeader(String value)
	{
		HSSFHeader header = currentSheet.getHeader();
		header.setLeft(value);
	}

	/**
	 * Set the center header value.
	 * 
	 * @param value
	 */
	public void setCenterHeader(String value)
	{
		HSSFHeader header = currentSheet.getHeader();
		header.setCenter(value);
	}

	/**
	 * Set the right header value.
	 * 
	 * @param value
	 */
	public void setRightHeader(String value)
	{
		HSSFHeader header = currentSheet.getHeader();
		header.setRight(value);
	}

	public void footer(String left, String right)
	{
		HSSFFooter footer = currentSheet.getFooter();
		footer.setLeft(left);
		footer.setRight(right);
	}


	/**
	 * @return a new row for the current worksheet.
	 */
	public HSSFRow nextRow()
	{
		currentColumnIndex = -1;

		return currentRow = currentSheet.createRow((short) ++currentRowIndex);
	}

	/**
	 * Add a column title.
	 * 
	 * @param value  value of the title
	 * @param width  width of the column
	 */
	public HSSFCell addTitleCell(String value, int width)
	{
		currentColumn = addStringCell(value);
		currentColumn.setCellStyle(titleStyle);
		setColumnWidth(currentColumnIndex, width);

		return currentColumn;
	}

	public void setColumnWidth(int columnIndex, int width)
	{
		currentSheet.setColumnWidth((short) columnIndex, (short) (width * 256));
	}

	/**
	 * Add a generic text cell.
	 * 
	 * @param value the text value to put in the cell.
	 * @return the created cell
	 */
	public HSSFCell addStringCell(String value)
	{
		currentColumn = currentRow.createCell(incrementColumn());
		currentColumn.setCellValue(value);

		return currentColumn;
	}

	/**
	 * Add a cell with bold text.
	 * 
	 * @param value the text value to put in the cell.
	 * @return the created cell
	 */
	public HSSFCell addBoldStringCell(String value)
	{
		currentColumn = addStringCell(value);
		currentColumn.setCellStyle(boldStyle);

		return currentColumn;
	}

	/**
	 * Add regular string cell, but right justified.
	 * 
	 * @param value the text value to put in the cell.
	 * @return the created cell
	 */
	public HSSFCell addStringCellRightJustify(String value)
	{
		currentColumn = addStringCell(value);
		currentColumn.setCellStyle(stringRightJustifyStyle);

		return currentColumn;
	}

	/**
	 * Add a subtotal cell for text.
	 * 
	 * @param value
	 * @return the created cell
	 */
	public HSSFCell addStringSubtotalCell(String value)
	{
		currentColumn = currentRow.createCell(incrementColumn());
		currentColumn.setCellStyle(stringSubtotalStyle);
		currentColumn.setCellValue(value);

		return currentColumn;
	}

	/**
	 * 
	 * @param value
	 * @return the created cell
	 */
	public HSSFCell addSubtotalCell(double value)
	{
		currentColumn = currentRow.createCell(incrementColumn());
		currentColumn.setCellStyle(currencySubtotalStyle);
		currentColumn.setCellValue(value);

		return currentColumn;
	}

	
	
	/**
	 * Add a generic number cell.
	 * 
	 * @param value
	 * @return the created cell
	 */
	public HSSFCell addNumberCell(double value)
	{
		currentColumn = currentRow.createCell(incrementColumn());
		currentColumn.setCellValue(value);

		return currentColumn;
	}

	/**
	 * Add a currency cell.
	 * 
	 * @param value
	 * @return the created cell
	 */
	public HSSFCell addCurrencyCell(double value)
	{
		currentColumn = currentRow.createCell(incrementColumn());
		currentColumn.setCellValue(value);
		currentColumn.setCellStyle(currencyStyle);

		return currentColumn;
	}

	public HSSFCell addPercentCell(double value)
	{
		currentColumn = currentRow.createCell(incrementColumn());
		currentColumn.setCellValue(value);
		currentColumn.setCellStyle(percentStyle);

		return currentColumn;
	}
	
	/**
	 * Add a date and time cell.
	 * 
	 * @param value
	 * @return the created cell
	 */
	public HSSFCell addDatetimeCell(Date value)
	{
		currentColumn = currentRow.createCell(incrementColumn());
		currentColumn.setCellValue(value);
		currentColumn.setCellStyle(datetimeStyle);

		return currentColumn;
	}

	/**
	 * Write the report to the given file.
	 * 
	 * @param outputFile
	 * @throws IOException
	 */
	public void write(String outputFile) throws IOException
	{
		write(new File(outputFile));
	}

	/**
	 * Write the report to the given output stream.
	 * 
	 * @param out
	 * @throws IOException
	 */
	public void write(OutputStream out) throws IOException
	{
		wb.write(out);
	}

	/**
	 * Write the report to the given file.
	 * 
	 * @param outputFile
	 * @throws IOException
	 */
	public void write(File outputFile) throws IOException
	{
		FileOutputStream out = null;

		try
		{
			out = new FileOutputStream(outputFile);
			wb.write(out);
		}
		finally
		{
			if (out != null)
				out.close();
		}
	}

	/**
	 * Create a subtotal cell with a subtotal formula for the given break name.
	 * 
	 * @param breakName
	 *            name of the break.
	 * @return the created cell
	 */
	public HSSFCell addSubTotalCell(String breakName)
	{
		return addSubTotalCell(breakName, currencySubtotalStyle);
	}

	/**
	 * Create a subtotal cell with a subtotal formula for the given break name.
	 * 
	 * @param breakName
	 *            name of the break.
	 * @return the created cell
	 */
	public HSSFCell addNumberSubTotalCell(String breakName)
	{
		return addSubTotalCell(breakName, stringSubtotalStyle);
	}

	/**
	 * Create a subtotal cell with a subtotal formula for the given break name.
	 * 
	 * @param breakName
	 *            name of the break.
	 * @param style
	 * @return the created cell
	 */
	public HSSFCell addSubTotalCell(String breakName, HSSFCellStyle style)
	{
		currentColumn = currentRow.createCell(incrementColumn());

		if (style != null)
			currentColumn.setCellStyle(style);

		Integer breakRow = (Integer) breaks.get(breakName);
		int breakVal = 0;

		if (breakRow != null)
		{
			breakVal = breakRow.intValue();
		}

		CellReference cellRefStart = new CellReference(breakVal + 1, currentColumnIndex);
		CellReference cellRefEnd = new CellReference(currentRowIndex - 1, currentColumnIndex);

		currentColumn.setCellFormula("SUBTOTAL(9," + cellRefStart.toString() + ":" + cellRefEnd.toString() + ")");

		return currentColumn;
	}

	public void breakTotals(String breakName)
	{
		breaks.put(breakName, new Integer(currentRowIndex));
	}

	/**
	 * Increment the counter for the current column.
	 * 
	 * @return
	 */
	private int incrementColumn()
	{
		++currentColumnIndex;

		if (currentColumnIndex > maxColumnIndex)
			maxColumnIndex = currentColumnIndex;

		return currentColumnIndex;
	}

	/**
	 * Set the print area to include all the report columns and rows.
	 * 
	 */
	public void setPrintArea()
	{
		// CellReference cellRefEnd = new CellReference(60, maxColumnIndex);
		// wb.setPrintArea(0, "A1:"+ cellRefEnd.toString());
		wb.setPrintArea(0, 0, maxColumnIndex, 0, currentSheet.getLastRowNum());
	}

	public HSSFSheet getCurrentSheet()
	{
		return currentSheet;
	}

	public void setCurrentSheet(HSSFSheet currentSheet)
	{
		this.currentSheet = currentSheet;
	}
	
	public CellReference currentCellReference()
	{
		return new CellReference(currentRowIndex, currentColumnIndex);
	}
}
