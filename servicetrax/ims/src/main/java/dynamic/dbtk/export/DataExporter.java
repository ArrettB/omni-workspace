package dynamic.dbtk.export;



import java.io.FileOutputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.sql.Date;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Vector;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

import dynamic.dbtk.MetaData;
import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.resources.ResourceManager;
import dynamic.util.string.StringUtil;
import dynamic.util.xml.XMLUtils;


/**
 * This class will dump the results of a query to a file.
 * Example of use: (with no error handling)
 * 
 * <pre>
 * 		
 * 
 * 		public exportToFile(InvocationContext ic)
 * 		{
 * 			// create the file
 * 			File dest = new File("C:\export.txt");
 *			FileOutputStream out = new FileOutputStream(dest);
 *
 *			//create and setup the exporter
 *			DataExporter exporter = new DataExporter();
 *			exporter.setFileType(DataExporter.FILE_TYPE_TAB_SEP);
 *			exporter.setQuery("SELECT * FROM invoices");
 *			exporter.setOutputStream(out);
 *			exporter.setResourceManager(((BaseInvocationContext) ic).getResourceManager());
 *
 *			//start the exporter and wait for it to finish before we return
 *			exporter.start();
 *			Thread t = exporter.getThread();
 *			t.join();
 *
 *			out.close();	
 *		}
 * 
 * 
 * 		public exportToBrowser(InvocationContext ic)
 * 		{
 * 			// get the outputstream
 * 			HttpServletResponse resp = ic.getHttpServletResponse();
 *			OutputStream out = new resp.getOutputStream()(dest);
 *		
 *			//create and setup the exporter
 *			DataExporter exporter = new DataExporter();
 *			exporter.setFileType(DataExporter.FILE_TYPE_TAB_SEP);
 *			exporter.setQuery("SELECT * FROM invoices");
 *			exporter.setOutputStream(out);
 *			exporter.setResourceManager(((BaseInvocationContext) ic).getResourceManager());
 *
 *			//start the exporter and wait for it to finish before we return
 *			exporter.start();
 *			Thread t = exporter.getThread();
 *			t.join();
 *
 *			out.close();	
 *		}
 *
 * 
 *  	public exportCustomHeadings(InvocationContext ic)
 * 		{
 * 			// get the outputstream
 * 			HttpServletResponse resp = ic.getHttpServletResponse();
 *			OutputStream out = new resp.getOutputStream()(dest);
 *		
 * 			Vector myHeadings = new Vector();
 * 			myHeadings.addElement("Invoice Number");
 * 			myHeadings.addElement("Invoice Net Total");
 * 
 *			//create and setup the exporter
 *			DataExporter exporter = new DataExporter();
 *			exporter.setFileType(DataExporter.FILE_TYPE_TAB_SEP);
 *			exporter.setQuery("SELECT invoice_no, invoice_total FROM invoices");
 *			exporter.setOutputStream(out);
 *			exporter.setResourceManager(((BaseInvocationContext) ic).getResourceManager());
 *			exporter.setHeaderList(myHeadings);
 * 
 *			//start the exporter and wait for it to finish before we return
 *			exporter.start();
 *			Thread t = exporter.getThread();
 *			t.join();
 *
 *			out.close();	
 *		}
 * 	
 * 
 *    	public handleEnvironment(InvocationContext ic)
 * 		{
 * 			Diagnostics.debug("Exporting is cool");
 * 
 * 			// get the outputstream
 * 			HttpServletResponse resp = ic.getHttpServletResponse();
 *			OutputStream out = new resp.getOutputStream()(dest);
 *			
 *			ConnectionWrapper conn = null;
 *  		try
 * 			{
 * 
 * 				//do any necessary database updates or whatever
 * 
 * 				//tell our browser what to expect
 * 				String resultsName = "YourExportedData.csv"
 * 				resp.setContentType("application/vnd.ms-excel");
 *				resp.setHeader("Content-disposition", "attachment;filename=" + resultsName);
 *				resp.setHeader("Expires", "0");
 *
 * 				//create and setup the exporter
 *				DataExporter exporter = new DataExporter();
 *				exporter.setFileType(DataExporter.FILE_TYPE_COMMA_SEP);
 *				exporter.setQuery("SELECT invoice_no, invoice_total FROM invoices");
 *				exporter.setOutputStream(out);
 *				exporter.setConnectionWrapper(conn);
 * 				
 *				//start the exporter and wait for it to finish before we return
 *				exporter.start();
 *				Thread t = exporter.getThread();
 *				t.join();
 *							
 * 
 * 			}
 * 			catch (Exception e)
 * 			{
 *				result = false;
 *				ErrorHandler.handleException(ic, "Exception in MyUberHandler", e);
 *
 * 			}
 *		 	finally
 * 			{
 * 				if (conn != null)
 *					conn.release();
 *					
 *				if (out != null)
 *					out.close();	
 *		
 * 			}
 * 			return result;
 *			
 *		}
 * 
 * 
 * </pre>
 * @author gcase
 */
public class DataExporter implements Runnable
{
	
	
	private String query;
	private String dateFormat = "MM/dd/yyyy h:mm:ss a";
	private ResourceManager resourceManager;
	private InvocationContext ic;
	private ConnectionWrapper connectionWrapper;
	private Thread tid;
	private int fileType;
	private OutputStream outputStream;
	private boolean showColumnHeadings = true;
	private Vector headerList = null;
	private String exportName;

	private MetaData resultMeta = null;
	private QueryResults results = null;
	private OutputStreamWriter writer = null;
	private String templateName;

	public final static int FILE_TYPE_COMMA_SEP = 1;
	public final static int FILE_TYPE_TAB_SEP = 2;

	/**
	 * DataExporter constructor comment.
	 */
	public DataExporter()
	{
		super();
	}

	/**
	 * Run the Daemon (the main loop)
	 */
	public void run()
	{

		try
		{
			Diagnostics.debug("run() starting");
			if (tid == Thread.currentThread())
			{

				ConnectionWrapper conn = getConnectionWrapper();
				boolean mustCreateConn = (conn == null);
				try
				{
					//make sure we have everything we need;
					if (preflightCheck())
					{
						
						if (mustCreateConn)
						{
							conn = (ConnectionWrapper) resourceManager.getResource();
						}

						writer = new OutputStreamWriter(getOutputStream());

						results = conn.resultsQueryEx(getQuery());
						resultMeta = new MetaData(results.getMetaData());

						writeHeadings();
						if (results.next() && (tid == Thread.currentThread()))
						{
							writeSingleLine();
						}
						while (results.next() && (tid == Thread.currentThread()))
						{
							writer.write(getLineSep());
							writeSingleLine();
						}
						results.close();
						
					}

				}
				catch (SQLException e)
				{
					Diagnostics.error("Problem with query", e);
				}
				finally
				{
					try
					{
						if (mustCreateConn && conn != null)
							conn.release();

						if (writer != null)
							writer.close();
					}
					catch (Exception e)
					{
					} // throw away
				}
			}
		}
		catch (Throwable t)
		{
			Diagnostics.error("Problem in run()", t);
		}

		Diagnostics.debug("run() complete");
	}

	private void writeSingleColumn(int columnNum, boolean prependColumnSep) throws Exception
	{
		String val = null;
		Date dateVal = null;
		String columnType = null;

		if (prependColumnSep)
			writer.write(getColumnSep());

		columnType = resultMeta.getColumnTypeName(columnNum);
		if (columnType.equalsIgnoreCase("date") || columnType.equalsIgnoreCase("datetime"))
		{
			dateVal = results.getDate(columnNum);
			if (dateVal != null)
			{
				SimpleDateFormat formatter = new SimpleDateFormat(getDateFormat());
				writer.write(formatter.format(dateVal));
			}
		}
		else
		{
			val = results.getString(columnNum);
			if (StringUtil.hasAValue(val))
			{
				if (val.indexOf(getColumnSep()) != -1)
				{
					val = "\"" + val + "\"";
				}
				writer.write(val);
			}
		}
	}

	private void writeSingleLine() throws Exception
	{
		int numColumns = resultMeta.getColumnCount();
		writeSingleColumn(1, false);
		for (int i = 2; i <= numColumns; i++)
		{
			writeSingleColumn(i, true);
		}

	}

	private void writeHeadings() throws Exception
	{
		if (getShowColumnHeadings())
		{
			if (getHeaderList() == null || headerList.size() == 0)
			{
				int numColumns = resultMeta.getColumnCount();
				writer.write(resultMeta.getColumnName(1));
				for (int i = 2; i <= numColumns; i++)
				{
					writer.write(getColumnSep());
					writer.write(resultMeta.getColumnName(i));
				}
				writer.write(getLineSep());
			}
			else
			{
				String header = (String) headerList.elementAt(0);
				writer.write(header.trim());
				for (int i = 1; i < headerList.size(); i++)
				{
					header = (String) headerList.elementAt(i);
					writer.write(getColumnSep());
					writer.write(header.trim());
				}
				writer.write(getLineSep());
			}
		}

	}

	private boolean preflightCheck()
	{

		if (getQuery() == null && getTemplateName() == null)
		{
			Diagnostics.error("Error in DataExporter: getQuery() and getTemplate() returned null");
			return false;
		}
		else
		{
			if (getQuery() != null)
			{
				if (getConnectionWrapper() == null && getResourceManager() == null)
				{
					Diagnostics.error("Error in DataExporter: getConnectionWrapper() and getOutputStream() returned null");
					return false;
				}
			}
			else if (getTemplateName() != null)
			{
				if (getInvocationContext() == null)
				{
					Diagnostics.error("Error in DataExporter: getInvocationContext() returned null");
					return false;
				}	
				if (getExportName() == null)
				{
					Diagnostics.error("Error in DataExporter: exportName() returned null");
					return false;				
				}			
			}
		}
		
		if (getOutputStream() == null)
		{
			Diagnostics.error("Error in DataExporter: getOutputStream() returned null");
			return false;
		}
		return true;
	}

	/**
	 * Start the Exporter
	 */
	public void start()
	{
		Diagnostics.debug("DataExporter.start()");
		tid = new Thread(this, "DataExporter");
		tid.start();
	}

	/**
	 * Stop the Exporter gracefully
	 */
	public void stop()
	{
		Diagnostics.debug("DataExporter.stop()");
		if (tid == null)
			return;
		Thread tmp = tid;
		tid = null;
		tmp.interrupt();
	}

	/**
	 * Main method used for testing
	 * @param args java.lang.String[]
	 */
	public static void main(String[] args)
	{
		String xmlFile = "C:\\work\\torit\\torit-dev.xml";
		String dest = "C:\\work\\export.csv";
		String query = "SELECT * FROM countries";

		try
		{
			Document doc = XMLUtils.parse(xmlFile);

			Element resourceManagerElement = XMLUtils.getSingleElement(doc, "resourceManager");
			String resourceManagerClass = resourceManagerElement.getAttribute("class");
			ResourceManager RM = (ResourceManager) Class.forName(resourceManagerClass).newInstance();
			RM.initialize(resourceManagerElement, null);

			DataExporter exporter = new DataExporter();
			exporter.setResourceManager(RM);
			exporter.setFileType(FILE_TYPE_COMMA_SEP);
			exporter.setQuery(query);
			exporter.setOutputStream(new FileOutputStream(dest));
			exporter.setShowColumnHeadings(true);

			exporter.start();
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}

	}

	private String getColumnSep()
	{
		switch (getFileType())
		{
			case FILE_TYPE_COMMA_SEP :
				return ",";
			case FILE_TYPE_TAB_SEP :
				return "\t";
			default :
				return " ";
		}
	}

	private String getLineSep()
	{
		return "\n";
	}

	/**
	 * Gets the query.
	 * @return Returns a String
	 */
	public String getQuery()
	{
		return query;
	}

	/**
	 * Sets the query.
	 * @param query The query to set
	 */
	public void setQuery(String query)
	{
		this.query = query;
	}

	/**
	 * Gets the dateFormat.
	 * @return Returns a String
	 */
	public String getDateFormat()
	{
		return dateFormat;
	}

	/**
	 * Sets the dateFormat.
	 * @param dateFormat The dateFormat to set
	 */
	public void setDateFormat(String dateFormat)
	{
		this.dateFormat = dateFormat;
	}

	/**
	 * Gets the resourceManager.
	 * @return Returns a ResourceManager
	 */
	public ResourceManager getResourceManager()
	{
		return resourceManager;
	}

	/**
	 * Sets the resourceManager.
	 * @param resourceManager The resourceManager to set
	 */
	public void setResourceManager(ResourceManager resourceManager)
	{
		this.resourceManager = resourceManager;
	}
	
	/**
	 * Sets the Invocation Context.
	 * @param ic The invocationContext to set
	 */	
	public void setInvocationContext(InvocationContext ic)
	{
		this.ic = ic;
	}
	
	/**
	 * Gets the Invocation Context.
	 */	
	public InvocationContext getInvocationContext()
	{
		return ic;
	}

	/**
	 * Gets the connectionWrapper.
	 * @return Returns a ConnectionWrapper
	 */
	public ConnectionWrapper getConnectionWrapper()
	{
		return connectionWrapper;
	}

	/**
	 * Sets the connectionWrapper.
	 * @param connectionWrapper The connectionWrapper to set
	 */
	public void setConnectionWrapper(ConnectionWrapper connectionWrapper)
	{
		this.connectionWrapper = connectionWrapper;
	}

	/**
	 * Gets the fileType.
	 * @return Returns a int
	 */
	public int getFileType()
	{
		return fileType;
	}

	/**
	 * Sets the fileType.
	 * @param fileType The fileType to set
	 */
	public void setFileType(int fileType)
	{
		this.fileType = fileType;
	}

	/**
	 * Gets the outputStream.
	 * @return Returns a OutputStream
	 */
	public OutputStream getOutputStream()
	{
		return outputStream;
	}

	/**
	 * Sets the outputStream.
	 * @param outputStream The outputStream to set
	 */
	public void setOutputStream(OutputStream outputStream)
	{
		this.outputStream = outputStream;
	}

	/**
	 * Gets the showColumnHeadings.
	 * @return Returns a boolean
	 */
	public boolean getShowColumnHeadings()
	{
		return showColumnHeadings;
	}
	
	public String getTemplateName()
	{
		return templateName;
	}
	
	public void setTemplateName(String templateName)
	{
		this.templateName = templateName;
	}

	/**
	 * Sets the showColumnHeadings.
	 * @param showColumnHeadings The showColumnHeadings to set
	 */
	public void setShowColumnHeadings(boolean showColumnHeadings)
	{
		this.showColumnHeadings = showColumnHeadings;
	}

	/**
	 * Gets the headerList.
	 * @return Returns a Vector
	 */
	public Vector getHeaderList()
	{
		return headerList;
	}

	/**
	 * Sets the headerList.
	 * @param headerList The headerList to set
	 */
	public void setHeaderList(Vector headerList)
	{
		this.headerList = headerList;
	}

	/**
	 * Gets the thread.
	 * @return Returns a Thread
	 */
	public Thread getThread()
	{
		return tid;
	}
	
	/**
	 * Gets the export section name.
	 * @return Returns a section name
	 */
	public String getExportName()
	{
		return exportName;
	}
	
	/**
	 * sets the export section name.
	 * @param export section name
	 */
	public void setExportName(String exportName)
	{
		this.exportName = exportName;
	}	

	/**
	 * Method processNode.  This is the main CSV formatting logic.  Any changes to how
	 * the HTML to CSV works should be defined here.
	 * @param node
	 * @param sb
	 */
	private void processNode(Node node, StringBuffer sb)
	{
		String prevNode = "";
		String parentNode = "";

		if (node.getPreviousSibling() != null) prevNode = StringUtil.isNull(node.getPreviousSibling().getNodeName(), "").toUpperCase();
		if (node.getParentNode() != null) parentNode = StringUtil.isNull(node.getParentNode().getNodeName(), "").toUpperCase();

		String name = StringUtil.isNull(node.getNodeName(), "").toUpperCase();
		String value = StringUtil.isNull(node.getNodeValue(), "");


		if (name.equals("#TEXT"))
		{
			if (parentNode.equals("SPAN") || parentNode.equals("TD") || parentNode.equals("B") || (prevNode.equals("") && parentNode.equals("A")))
			{
				//Page Title Header <SPAN>, <TD>, <B> within a <TD>, or SmartTable Headers <A HREF>
				getCell(value, sb, 0, true);
			}
			else if (prevNode.equals("BR") && parentNode.equals("TD"))
			{
				//BR within a TD
				getCell(value, sb, 2, false); //strip off the preceeding comma and quote
			}
		}
		else if (name.equals("TR"))
		{
			getRow(sb, 1); //Strip off the preceding comma and add a newline char
		}
	}

	/**
	 * Method getCell.  Creates a comma delimited cell surrounded with qoutes.  Will strip off
	 * end number of chars specified to create concatenated cells with startQuote set to false.
	 * @param value
	 * @param sb
	 * @param cutEndChars
	 * @param startQuote
	 */
	private void getCell(String value, StringBuffer sb, int cutEndChars, boolean startQuote)
	{
		if (cutEndChars > 0) sb.setLength(sb.length() - cutEndChars); //strip off the preceeding chars
		if (startQuote) sb.append("\""+prepareCell(value)+"\""+getColumnSep()+"");
		else sb.append(" "+prepareCell(value)+"\""+getColumnSep()+"");
	}



	/**
	 * Method getRow.  Appends a newline character after stripping off the last comma.
	 * @param sb
	 * @param cutEndChars
	 */
	private void getRow(StringBuffer sb, int cutEndChars)
	{
		//Newline
		int newLength = sb.length() - cutEndChars;
		if (newLength > 0)
			sb.setLength(newLength);
		sb.append("\n");
	}

	/**
	 * Method prepareCell.  This method will strip out unwanted chars and strings
	 * @param s
	 * @return String
	 */
	private String prepareCell(String s)
	{
		StringBuffer result = new StringBuffer("");
		s = s.trim();
		if(s.equalsIgnoreCase("&nbsp;"))
		{
			s = " ";
		}
		for(int i = 0; i < s.length(); i++)
		{
			char c = s.charAt(i);

			if(c == '\t') result.append(" ");
			else if(c == '\r' || c == '\n') result.append(" ");
			else result.append(c);
		}
		return result.toString();
	}	

}