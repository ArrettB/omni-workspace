package dynamic.dbtk.connection;

import dynamic.util.date.StdDate;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.diagnostics.DiagnosticsMessage;
import dynamic.util.performance.PerformanceTracker;
import dynamic.util.performance.StopwatchList;
import dynamic.util.resources.DynamicResource;
import dynamic.util.resources.DynamicResourceProducer;
import dynamic.util.string.StringUtil;

import java.sql.*;
import java.util.Date;
import java.util.*;

/**
 * Reverse engineered from the IMS iFrame2.jar file.
 *
 * @author bvonhaden
 * @version $Header: ConnectionWrapper.java, 4, 3/6/2006 3:46:53 PM, Blake Von Haden$
 */
public class ConnectionWrapper implements Connection, DynamicResource, Runnable
{
	private Connection theConnection;
	private JDBCResourceProducer producer;
	private String name;
	private String type;
	private long min;
	private long max;
	private long ttl;
	private Vector<Statement> _statements;
	private Hashtable<Statement, String> _queries;
	private boolean available;
	private Thread tester;
	private long useCount;
	private long totalTime;
	private Date created;
	private Date accessed;
	private Date expires;
	private boolean shared;
	private String lastQuery;
	private DiagnosticsMessage lastProblem;
	private PerformanceTracker tracker;
	public int TRANSACTION_NONE;
	public int TRANSACTION_READ_UNCOMMITTED;
	public int TRANSACTION_READ_COMMITTED;
	public int TRANSACTION_REPEATABLE_READ;
	public int TRANSACTION_SERIALIZABLE;

	public ConnectionWrapper()
	{
		theConnection = null;
		producer = null;
		name = null;
		type = null;
		min = 0L;
		max = 500L;
		ttl = 100L;
		_statements = new Vector<Statement>();
		_queries = new Hashtable<Statement, String>();
		available = false;
		tester = null;
		useCount = 0L;
		totalTime = 0L;
		created = null;
		accessed = null;
		expires = null;
		shared = false;
		lastQuery = "";
		lastProblem = null;
		tracker = new PerformanceTracker(10, 10, 100);
		TRANSACTION_NONE = Connection.TRANSACTION_NONE;
		TRANSACTION_READ_UNCOMMITTED = Connection.TRANSACTION_READ_UNCOMMITTED;
		TRANSACTION_READ_COMMITTED = Connection.TRANSACTION_READ_COMMITTED;
		TRANSACTION_REPEATABLE_READ = Connection.TRANSACTION_REPEATABLE_READ;
		TRANSACTION_SERIALIZABLE = Connection.TRANSACTION_SERIALIZABLE;
	}

	public synchronized DynamicResource initialize(Object resource, DynamicResourceProducer producer, String name, String type,
			String min, String max, String ttl)
	{
		theConnection = (Connection) resource;
		try
		{
			theConnection.setTransactionIsolation(TRANSACTION_READ_UNCOMMITTED);
			Diagnostics.debug2("Successfully set transaction isolation on connection");
		}
		catch (SQLException e)
		{
			Diagnostics.error("Could not set transaction isolation on connection");
		}
		this.producer = (JDBCResourceProducer) producer;
		this.name = name;
		this.type = type;
		if (min != null && min.length() > 0)
			this.min = Integer.parseInt(min);
		if (max != null && max.length() > 0)
			this.max = Integer.parseInt(max);
		if (ttl != null && ttl.length() > 0)
			this.ttl = Integer.parseInt(ttl);
		available = true;
		created = new Date();
		touch();
		start();
		return this;
	}

	public synchronized void destroy()
	{
		neaten();
		shared = false;
		available = true;
		stop();
		try
		{
			if (theConnection != null)
				close();
		}
		catch (Exception e)
		{
		}
		theConnection = null;
		expires = null;
	}

	public synchronized boolean acquire()
	{
		boolean result = false;
		if (isAvailable() && !isExpired())
		{
			available = false;
			touch();
			useCount++;
			result = true;
		}
		return result;
	}

	public synchronized void release()
	{
		release(false);
	}

	public synchronized void release(boolean forceRelease)
	{
		if (shared && !forceRelease)
		{
			return;
		}
		else
		{
			touch();
			neaten();
			shared = false;
			available = true;
			return;
		}
	}

	/**
	 * @deprecated Method releaseResource is deprecated
	 */
	public synchronized void releaseResource()
	{
		release(false);
	}

	/**
	 * Update the last accessed and expires time.
	 *
	 */
	private void touch()
	{
		accessed = new StdDate();
		expires = new StdDate(accessed.getTime() + ttl * 60 * 1000);
	}

	public void share()
	{
		shared = true;
	}

	public synchronized void test()
	{
		if (theConnection == null)
		{
			Diagnostics.error("Database connection is null");
			destroy();
			return;
		}
		if (isExpired())
		{
			Diagnostics.trace("ConnectionWrapper.test() removing expired resource");
			destroy();
			return;
		}
		if (!isAvailable())
			return;
		try
		{
			setAutoCommit(false);
			setAutoCommit(true);
		}
		catch (Throwable t)
		{
			Diagnostics.error("Problem in ConnectionWrapper.test()", t);
			destroy();
		}
	}

	private void start()
	{
		tester = new Thread(this, "ConnectionCleaner-" + name);
		Diagnostics.registerThread(tester, Diagnostics.getContext());
		tester.start();
	}

	private void stop()
	{
		if (tester == null)
			return;
		Thread temp = tester;
		tester = null;
		if (temp != Thread.currentThread())
			temp.interrupt();
	}

	public void run()
	{
		try
		{
			for (Thread thisThread = Thread.currentThread(); tester == thisThread;)
			{
				test();
				if (tester != thisThread)
					break;
				try
				{
					Thread.sleep(60000L);
				}
				catch (InterruptedException e)
				{
				}
			}
		}
		catch (Throwable t)
		{
			Diagnostics.error("ConnectionWrapper.run() was halted", t);
		}
	}

	public String getName()
	{
		return name;
	}

	public long getMaxUseCount()
	{
		return max;
	}

	public boolean isAvailable()
	{
		return available;
	}

	public boolean isExpired()
	{
		if (available && useCount >= getMaxUseCount())
		{
			Diagnostics
					.debug("ConnectionWrapper.isExpired() returning true because max use count " + getMaxUseCount() + " reached");
			return true;
		}
		if (type.equals("SingleUse") && useCount > 0L && isAvailable())
		{
			Diagnostics.debug("ConnectionWrapper.isExpired() returning true because a single use resource has been used");
			return true;
		}
		if (expires == null)
		{
			Diagnostics.debug("ConnectionWrapper.isExpired() returning true because expiration date was null");
			return true;
		}
		if (System.currentTimeMillis() > expires.getTime())
		{
			Diagnostics.debug("ConnectionWrapper.isExpired() returning true because expiration date " + expires + " was passed");
			return true;
		}
		else
		{
			return false;
		}
	}

	public boolean isShareable()
	{
		return type.equals("SharedPool");
	}

	private String basename(Object o)
	{
		if (o == null)
			return "";
		String s = o.getClass().getName();
		int x = s.lastIndexOf('.');
		if (x == -1)
			return s;
		else
			return s.substring(x + 1);
	}

	public String toHTML(String href, int index, boolean showDetail)
	{
		StringBuffer result = new StringBuffer();
		result.append("<tr>\n");
		String name = getName() + ":" + index;
		result.append("<td rowspan=\"2\" bgcolor=\"#DCDCDC\"><font size=\"1\"><a href=\"" + href);
		if (!showDetail)
			result.append("&resource=" + name);
		result.append("\">" + name + "</font></td>\n");
		result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">" + basename(this) + "</font></td>\n");
		result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">" + basename(producer) + "</font></td>\n");
		result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">" + type + "</font></td>\n");
		result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">" + (shared ? "Shared" : "No") + "</font></td>\n");
		result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">"
				+ (isExpired() ? "Expired" : isAvailable() ? "Available" : "In Use") + "</font></td>\n");
		result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">" + useCount + "/" + getMaxUseCount() + "</font></td>\n");
		result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">" + new StdDate(created) + "</font></td>\n");
		result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">" + (isExpired() ? "Expired" : (new StdDate(expires)).toString())
				+ "</font></td>\n");
		result.append("</tr>\n");
		result.append("<tr>\n");
		result.append("<td colspan=\"8\" bgcolor=\"#DCDCDC\"><font size=\"1\">"
				+ (lastProblem == null ? lastQuery : lastProblem.toHTML()) + "</td>\n");
		result.append("</tr>\n");
		if (showDetail)
		{
			result.append("<tr><td colspan=\"99\">\n");
			result.append("<table width=\"100%\">\n");
			result.append("<tr>\n");
			result.append("<td bgcolor=\"#888888\"><font size=\"2\"><b>Attribute</b></font></td>\n");
			result.append("<td colspan=\"4\" bgcolor=\"#888888\"><font size=\"2\"><b>Value</b></font></td>\n");
			result.append("</tr>\n");
			result.append("<tr>\n");
			result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">Class</font></td>\n");
			result.append("<td colspan=\"4\" bgcolor=\"#DCDCDC\"><font size=\"1\">" + getClass().getName() + "</font></td>\n");
			result.append("</tr>\n");
			result.append("<tr>\n");
			result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">Date Accessed</font></td>\n");
			result.append("<td colspan=\"4\" bgcolor=\"#DCDCDC\"><font size=\"1\">" + new StdDate(accessed) + "</font></td>\n");
			result.append("</tr>\n");
			result.append("<tr>\n");
			result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">Date Created</font></td>\n");
			result.append("<td colspan=\"4\" bgcolor=\"#DCDCDC\"><font size=\"1\">" + new StdDate(created) + "</font></td>\n");
			result.append("</tr>\n");
			result.append("<tr>\n");
			result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">Date Expires</font></td>\n");
			result.append("<td colspan=\"4\" bgcolor=\"#DCDCDC\"><font size=\"1\">"
					+ (isExpired() ? "Expired" : (new StdDate(expires)).toString()) + "</font></td>\n");
			result.append("</tr>\n");
			result.append("<tr>\n");
			result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">Is Expired?</font></td>\n");
			result.append("<td colspan=\"4\" bgcolor=\"#DCDCDC\"><font size=\"1\">" + isExpired() + "</font></td>\n");
			result.append("</tr>\n");
			result.append("<tr>\n");
			result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">Max Use Count</font></td>\n");
			result.append("<td colspan=\"4\" bgcolor=\"#DCDCDC\"><font size=\"1\">" + getMaxUseCount() + "</font></td>\n");
			result.append("</tr>\n");
			result.append("<tr>\n");
			result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">Name</font></td>\n");
			result.append("<td colspan=\"4\" bgcolor=\"#DCDCDC\"><font size=\"1\">" + name + "</font></td>\n");
			result.append("</tr>\n");
			result.append("<tr>\n");
			result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">Producer</font></td>\n");
			result.append("<td colspan=\"4\" bgcolor=\"#DCDCDC\"><font size=\"1\">" + producer.getClass().getName()
					+ "</font></td>\n");
			result.append("</tr>\n");
			result.append("<tr>\n");
			result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">Status</font></td>\n");
			result.append("<td colspan=\"4\" bgcolor=\"#DCDCDC\"><font size=\"1\">"
					+ (isExpired() ? "Expired" : isAvailable() ? "Available" : "In Use") + "</font></td>\n");
			result.append("</tr>\n");
			result.append("<tr>\n");
			result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">TTL</font></td>\n");
			result.append("<td colspan=\"4\" bgcolor=\"#DCDCDC\"><font size=\"1\">" + ttl + "</font></td>\n");
			result.append("</tr>\n");
			result.append("<tr>\n");
			result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">Type</font></td>\n");
			result.append("<td colspan=\"4\" bgcolor=\"#DCDCDC\"><font size=\"1\">" + type + "</font></td>\n");
			result.append("</tr>\n");
			result.append("<tr>\n");
			result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">Shared</font></td>\n");
			result.append("<td colspan=\"4\" bgcolor=\"#DCDCDC\"><font size=\"1\">" + shared + "</font></td>\n");
			result.append("</tr>\n");
			result.append("<tr>\n");
			result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">Use Count</font></td>\n");
			result.append("<td colspan=\"4\" bgcolor=\"#DCDCDC\"><font size=\"1\">" + useCount + "</font></td>\n");
			result.append("</tr>\n");
			result.append("<tr>\n");
			result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">Options</font></td>\n");
			result.append("<td colspan=\"4\" bgcolor=\"#DCDCDC\"><font size=\"1\"><a href=\"" + href + "&option=kill&resource="
					+ name + "\">kill</a></font></td>\n");
			result.append("</tr>\n");
			long requests = tracker.getRequestCount();
			Date now = new Date();
			long uptime = System.currentTimeMillis() - tracker.getCreatedTime().getTime();
			long rph = (long) (((double) requests * 1000D * 60D * 60D) / (double) uptime);
			result.append("<tr>\n");
			result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">Now</font></td>\n");
			result.append("<td colspan=\"4\" bgcolor=\"#DCDCDC\"><font size=\"1\">" + new StdDate(now) + "</font></td>\n");
			result.append("</tr>\n");
			result.append("<tr>\n");
			result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">Uptime</font></td>\n");
			result.append("<td colspan=\"4\" bgcolor=\"#DCDCDC\"><font size=\"1\">" + StdDate.formatDateInterval(uptime)
					+ "</font></td>\n");
			result.append("</tr>\n");
			result.append("<tr>\n");
			result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">Requests</font></td>\n");
			result.append("<td colspan=\"4\" bgcolor=\"#DCDCDC\"><font size=\"1\">" + requests + "</font></td>\n");
			result.append("</tr>\n");
			result.append("<tr>\n");
			result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">Requests per Hour</font></td>\n");
			result.append("<td colspan=\"4\" bgcolor=\"#DCDCDC\"><font size=\"1\">" + rph + "</font></td>\n");
			result.append("</tr>\n");
			result.append("<tr>\n");
			result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">Currently Running</font></td>\n");
			result.append("<td colspan=\"4\" bgcolor=\"#DCDCDC\"><font size=\"1\">" + tracker.getConcurrentRequestCount()
					+ "</font></td>\n");
			result.append("</tr>\n");
			result.append("<tr>\n");
			result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">Total Time</font></td>\n");
			result.append("<td colspan=\"4\" bgcolor=\"#DCDCDC\"><font size=\"1\">" + tracker.getTotalTime() + "</font></td>\n");
			result.append("</tr>\n");
			result.append("<tr>\n");
			result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">Average Request</font></td>\n");
			result.append("<td colspan=\"4\" bgcolor=\"#DCDCDC\"><font size=\"1\">" + tracker.getAverageInterval()
					+ "</font></td>\n");
			result.append("</tr>\n");
			StopwatchList list = tracker.getLast();
			result.append("<tr>\n");
			result.append("<td bgcolor=\"#DCDCDC\" rowspan=\"" + list.size() + "\"><font size=\"1\">Last " + list.size()
					+ " Requests</font></td>\n");
			for (int i = 0; i < list.size(); i++)
			{
				if (i > 0)
					result.append("<tr>\n");
				result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">");
				result.append(list.getStopwatch(i).getCount() + "<br>");
				result.append("</font></td>\n");
				result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">");
				result.append(list.getStopwatch(i).getInterval() + "<br>");
				result.append("</font></td>\n");
				result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">");
				result.append(list.getStopwatch(i).getDate() + "<br>");
				result.append("</font></td>\n");
				result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">");
				result.append(list.getStopwatch(i).getName() + "<br>");
				result.append("</font></td>\n");
				result.append("</tr>\n");
			}
			list = tracker.getMin();
			result.append("<tr>\n");
			result.append("<td bgcolor=\"#DCDCDC\" rowspan=\"" + list.size() + "\"><font size=\"1\">Top " + list.size()
					+ " Quickest Requests</font></td>\n");
			for (int i = 0; i < list.size(); i++)
			{
				if (i > 0)
					result.append("<tr>\n");
				result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">");
				result.append(list.getStopwatch(i).getCount() + "<br>");
				result.append("</font></td>\n");
				result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">");
				result.append(list.getStopwatch(i).getInterval() + "<br>");
				result.append("</font></td>\n");
				result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">");
				result.append(list.getStopwatch(i).getDate() + "<br>");
				result.append("</font></td>\n");
				result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">");
				result.append(list.getStopwatch(i).getName() + "<br>");
				result.append("</font></td>\n");
				result.append("</tr>\n");
			}
			list = tracker.getMax();
			result.append("<tr>\n");
			result.append("<td bgcolor=\"#DCDCDC\" rowspan=\"" + list.size() + "\"><font size=\"1\">Top " + list.size()
					+ " Longest Requests</font></td>\n");
			for (int i = 0; i < list.size(); i++)
			{
				if (i > 0)
					result.append("<tr>\n");
				result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">");
				result.append(list.getStopwatch(i).getCount() + "<br>");
				result.append("</font></td>\n");
				result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">");
				result.append(list.getStopwatch(i).getInterval() + "<br>");
				result.append("</font></td>\n");
				result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">");
				result.append(list.getStopwatch(i).getDate() + "<br>");
				result.append("</font></td>\n");
				result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">");
				result.append(list.getStopwatch(i).getName() + "<br>");
				result.append("</font></td>\n");
				result.append("</tr>\n");
			}
			result.append("</table>\n");
			result.append("</tr></td>\n");
		}
		return result.toString();
	}

	public synchronized void neaten()
	{
		for (int i = 0; i < _statements.size(); i++)
		{
			String query = null;
			try
			{
				query = null;
				Statement stmt = (Statement) _statements.elementAt(i);
				query = _queries.get(stmt);
				Diagnostics.warning("ConnectionWrapper.neaten() removing statement " + query);
				stmt.close();
			}
			catch (Exception e)
			{
				Diagnostics.error("Problem closing statement " + query, e);
			}
		}
		_statements.removeAllElements();
		_queries.clear();
	}

	public void finalize() throws Throwable
	{
		neaten();
		super.finalize();
	}

	
	/**
	 * Process a SQL SELECT query as a {@link java.sql.PreparedStatement} using the params array if it is specified and not empty, 
	 * or as a {@link java.sql.Statement} if not and return a result set. Don't forget close the result set.
	 *
	 * @param sql the SQL SELECT statement to execute.
	 * @param params array of objects to bind to the query.
	 * @exception SQLException DB error message.
	 * @return the results of the query.
	 */
	public QueryResults select(StringBuffer sql, Object params[]) throws SQLException
	{
		String s = "" + sql;
		QueryResults result = null;
		Statement stmt = null;

		try
		{
			touch();
			s = sql.toString();
			lastQuery = s;
			lastProblem = null;
			ResultSet rs = null;
			
			Diagnostics.debug(expandSQL(sql, params));
			
			if (params == null || params.length == 0)
			{
				stmt = createStatement();
				_queries.put(stmt,s);
				rs = stmt.executeQuery(s);
			}
			else
			{
				stmt = prepareStatement(s, params);
				_queries.put(stmt,s);
				rs = ((PreparedStatement)stmt).executeQuery();
			}
			result = new QueryResults(this, stmt, rs);
		}
		catch (SQLException e)
		{
			removeStatement(stmt);
			e.setNextException(new SQLException(s));
			lastProblem = new DiagnosticsMessage(Diagnostics.ERROR, "Problem with query", e, null);
			throw e;
		}
		
		return result;
	}

	/**
	 * Process a SQL SELECT query as a {@link java.sql.PreparedStatement} using param as the bound parameter and return a result set.
	 * Don't forget close the result set.
	 *
	 * @param sql the SQL SELECT statement to execute.
	 * @param param the object to bind to the query.
	 * @exception SQLException DB error message.
	 * @return the results of the query.
	 */
	public QueryResults select(StringBuffer sql, Object param) throws SQLException
	{
		return select(sql, new Object[] { param });
	}

	/**
	 * Process a SQL SELECT query and return a result set.
	 * Don't forget close the result set.
	 *
	 * @param sql the SQL SELECT statement to execute.
	 * @exception SQLException DB error message.
	 * @return the results of the query.
	 */
	public QueryResults select(StringBuffer sql) throws SQLException
	{
		return select(sql, null);
	}

	/**
	 * Process a SQL SELECT query as a {@link java.sql.PreparedStatement} using the params array if it is specified and not empty, 
	 * or as a {@link java.sql.Statement} if not and return a result set. Don't forget close the result set.
	 *
	 * @param sql the sql SELECT statement to execute.
	 * @param params array of objects to bind to the query.
	 * @exception SQLException DB error message.
	 * @return the results of the query.
	 */
	public QueryResults select(String sql, Object params[]) throws SQLException
	{
		return select(new StringBuffer(sql), params);
	}

	/**
	 * Process a SQL SELECT query as a {@link java.sql.PreparedStatement} using param as the bound parameter and return a result set.
	 * Don't forget close the result set.
	 *
	 * @param sql the SQL SELECT statement to execute.
	 * @param param the object to bind to the query.
	 * @exception SQLException DB error message.
	 * @return the results of the query.
	 */
	public QueryResults select(String sql, Object param) throws SQLException
	{
		return select(new StringBuffer(sql), new Object[] { param });
	}

	/**
	 * Process a SQL SELECT query and return a result set.
	 * Don't forget close the result set.
	 *
	 * @param sql the SQL SELECT statement to execute.
	 * @exception SQLException DB error message.
	 * @return the results of the query.
	 */
	public QueryResults select(String sql) throws SQLException
	{
		return select(new StringBuffer(sql), null);
	}

	/**
	 * Convert a SQL statement and parameters for debugging and printing.
	 */
	public String expandSQL(StringBuffer sql, Object params[])
	{
		StringBuffer sb = new StringBuffer(sql.toString());
		
/* Yeah, this can't be trusted to work.
 * 
		String s;
		int pos = 0;
		for (int i = 0; params != null && i < params.length; i++)
		{
			Object o = params[i];
			if (o instanceof String) 
				s = toSQLString((String)o);
			else if (o instanceof Date)
				s = toSQLString((Date)o);
			else if ( o == null)
					s = "NULL";
			else
				s = o.toString();

			pos = sb.indexOf("?", pos);
			sb.replace(pos, pos+1, s);
			pos += s.length();
		}
 */		
		if (params != null && params.length > 0) 
			sb.append(" -- params=").append(StringUtil.arrayToString(params, ','));
		
		return sb.toString();
	}

	// selectFirst

	/**
	 * Process a SQL SELECT query as a {@link java.sql.PreparedStatement} using the params array if it is specified and not empty, 
	 * or as a {@link java.sql.Statement} if not and return the value in the first column of the first row as a String.
	 *
	 * @param sql the SQL SELECT statement to execute.
	 * @param params array of objects to bind to the query.
	 * @exception SQLException DB error message.
	 * @return the value in the first column of the first row as a String, or NULL if nothing selected.
	 */
	public String selectFirst(StringBuffer sql, Object params[]) throws SQLException
	{
		String result = null;
		QueryResults rs = null;

		try
		{
			rs = select(sql, params);
			if (rs.next()) result = rs.getString(1);
		}
		finally
		{
			try { if (rs != null) rs.close(); } catch (Exception ex) {} // throw away
		}

		return result;
	}

	/**
	 * Process a SQL SELECT query as a {@link java.sql.PreparedStatement} using param as the bound parameter 
	 * and return the value in the first column of the first row as a String.
	 *
	 * @param sql the SQL SELECT statement to execute.
	 * @param param the object to bind to the query.
	 * @exception SQLException DB error message.
	 * @return the value in the first column of the first row as a String
	 */
	public String selectFirst(StringBuffer sql, Object param) throws SQLException
	{
		return selectFirst(sql, new Object[] { param });
	}

	/**
	 * Process a SQL SELECT query and return the value in the first column of the first row as a String.
	 *
	 * @param sql the SQL SELECT statement to execute.
	 * @exception SQLException DB error message.
	 * @return the value in the first column of the first row as a String.
	 */
	public String selectFirst(StringBuffer sql) throws SQLException
	{
		return selectFirst(sql, null);
	}

	/**
	 * Process a SQL SELECT query as a {@link java.sql.PreparedStatement} using the params array if it is specified and not empty, 
	 * or as a {@link java.sql.Statement} if not and return the value in the first column of the first row as a String.
	 *
	 * @param sql the SQL SELECT statement to execute.
	 * @param params array of objects to bind to the query.
	 * @exception SQLException DB error message.
	 * @return the value in the first column of the first row as a String
	 */
	public String selectFirst(String sql, Object params[]) throws SQLException
	{
		return selectFirst(new StringBuffer(sql), params);
	}

	/**
	 * Process a SQL SELECT query as a {@link java.sql.PreparedStatement} using param as the bound parameter 
	 * and return the value in the first column of the first row as a String.
	 *
	 * @param sql the SQL SELECT statement to execute.
	 * @param param the object to bind to the query.
	 * @exception SQLException DB error message.
	 * @return the value in the first column of the first row as a String
	 */
	public String selectFirst(String sql, Object param) throws SQLException
	{
		return selectFirst(new StringBuffer(sql), new Object[] { param });
	}

	/**
	 * Process a SQL SELECT query and return the value in the first column of the first row as a String.
	 *
	 * @param sql the SQL SELECT statement to execute.
	 * @exception SQLException DB error message.
	 * @return the value in the first column of the first row as a String.
	 */
	public String selectFirst(String sql) throws SQLException
	{
		return selectFirst(new StringBuffer(sql), null);
	}

	// interface for the new calls

	/**
	 * Process a SQL INSERT, UPDATE, DELETE, or EXECUTE statement as a {@link java.sql.PreparedStatement} using the params array if it is specified and not empty, 
	 * or as a {@link java.sql.Statement} if not and return the number of rows affected by the operation.
	 *
	 * @param sql the SQL INSERT, UPDATE, DELETE, or EXECUTE statement to execute.
	 * @param params array of objects to bind to the statement.
	 * @exception SQLException DB error message.
	 * @return the number of rows affected by the operation.
	 */
	private long executeUpdate(StringBuffer sql, Object params[]) throws SQLException
	{
		String s = "" + sql;
		long result = 0;
		Statement stmt = null;
		
		try
		{
			Diagnostics.debug(expandSQL(sql, params));
			touch();

			s = sql.toString();
			lastQuery = s;
			lastProblem = null;
			if (params == null || params.length == 0)
			{
				stmt = createStatement();
				_queries.put(stmt,s);
				result = stmt.executeUpdate(s);
			}
			else
			{
				stmt = prepareStatement(s, params);
				_queries.put(stmt,s);
				result = ((PreparedStatement)stmt).executeUpdate();
			}
		}
		catch (SQLException e)
		{
			e.setNextException(new SQLException(s));
			lastProblem = new DiagnosticsMessage(Diagnostics.ERROR, "Problem with statement", e, null);
			throw e;
		}
		finally
		{
			removeStatement(stmt);
		}
		
		return result;
	}

	// update

	/**
	 * Process a SQL UPDATE statement as a {@link java.sql.PreparedStatement} using the params array if it is specified and not empty, 
	 * or as a {@link java.sql.Statement} if not and return the number of rows updated.
	 *
	 * @param sql the SQL UPDATE statement to execute.
	 * @param params array of objects to bind to the statement.
	 * @exception SQLException DB error message.
	 * @return the number of rows updated.
	 */
	public long update(StringBuffer sql, Object params[]) throws SQLException
	{
//		fireBeforeUpdate(sql, params);
		long result = executeUpdate(sql, params);
//		fireAfterUpdate(sql, params);
		return result;
	}
	
	/**
	 * Process a SQL UPDATE statement as a {@link java.sql.PreparedStatement} using param as the bound parameter 
	 * and return the number of rows updated.
	 *
	 * @param sql the SQL UPDATE statement to execute.
	 * @param param the object to bind to the statement.
	 * @exception SQLException DB error message.
	 * @return the number of rows updated.
	 */
	public long update(StringBuffer sql, Object param) throws SQLException
	{
		return update(sql, new Object[] { param });
	}
	
	/**
	 * Process a SQL UPDATE statement and return the number of rows updated.
	 *
	 * @param sql the SQL UPDATE statement to execute.
	 * @exception SQLException DB error message.
	 * @return the number of rows updated.
	 */
	public long update(StringBuffer sql) throws SQLException
	{
		return update(sql, null);
	}
	
	/**
	 * Process a SQL UPDATE statement as a {@link java.sql.PreparedStatement} using the params array if it is specified and not empty, 
	 * or as a {@link java.sql.Statement} if not and return the number of rows updated.
	 *
	 * @param sql the SQL UPDATE statement to execute.
	 * @param params array of objects to bind to the statement.
	 * @exception SQLException DB error message.
	 * @return the number of rows updated.
	 */
	public long update(String sql, Object params[]) throws SQLException
	{
		return update(new StringBuffer(sql), params);
	}
	
	/**
	 * Process a SQL UPDATE statement as a {@link java.sql.PreparedStatement} using param as the bound parameter 
	 * and return the number of rows updated.
	 *
	 * @param sql the SQL UPDATE statement to execute.
	 * @param param the object to bind to the statement.
	 * @exception SQLException DB error message.
	 * @return the number of rows updated.
	 */
	public long update(String sql, Object param) throws SQLException
	{
		return update(new StringBuffer(sql), new Object[] { param });
	}
	
	/**
	 * Process a SQL UPDATE statement and return the number of rows updated.
	 *
	 * @param sql the SQL UPDATE statement to execute.
	 * @exception SQLException DB error message.
	 * @return the number of rows updated.
	 */
	public long update(String sql) throws SQLException
	{
		return update(new StringBuffer(sql), null);
	}

	
	QueryResults executeQuery(String query) throws SQLException
	{
		Diagnostics.trace2(query);
		QueryResults result = null;
		Statement stmt = null;
		try
		{
			stmt = createStatement();
			_queries.put(stmt, query);
			lastQuery = query;
			lastProblem = null;
			tracker.start(query);
			ResultSet rs = stmt.executeQuery(query);
			tracker.stop(query);
			result = new QueryResults(this, stmt, rs);
		}
		catch (SQLException e)
		{
			removeStatement(stmt);
			e.setNextException(new SQLException(query));
			lastProblem = new DiagnosticsMessage(1, "Problem executing query", e, null);
			throw e;
		}
		return result;
	}

	int executeUpdate(String query) throws SQLException
	{
		Diagnostics.trace2(query);
		int result = 0;
		Statement stmt = null;
		try
		{
			stmt = createStatement();
			_queries.put(stmt, query);
			lastQuery = query;
			lastProblem = null;
			tracker.start(query);
			result = stmt.executeUpdate(query);
			tracker.stop(query);
		}
		catch (SQLException e)
		{
			e.setNextException(new SQLException(query));
			lastProblem = new DiagnosticsMessage(1, "Problem executing update", e, null);
			throw e;
		}
		finally
		{
			removeStatement(stmt);
		}
		return result;
	}

	/**
	 * @deprecated Method getNextValueOfSequenceString is deprecated
	 */
	public String getNextValueOfSequenceString(String seq)
	{
		return quickQuery("SELECT " + seq + ".NEXTVAL FROM DUAL");
	}

	public long getLongValueOfSequence(String seq)
	{
		return Long.parseLong(getNextValueOfSequenceString(seq));
	}

	public String getNextValueOfSequenceStringEx(String seq) throws SQLException
	{
		return queryEx("SELECT " + seq + ".NEXTVAL FROM DUAL");
	}

	public long getLongValueOfSequenceEx(String seq) throws SQLException
	{
		return Long.parseLong(getNextValueOfSequenceStringEx(seq));
	}

	public QueryResults resultsQueryEx(String query) throws SQLException
	{
		return executeQuery(query);
	}

	public QueryResults resultsQueryEx(StringBuffer query) throws SQLException
	{
		return resultsQueryEx(query.toString());
	}

	/**
	 * @deprecated Method sendQueryEx is deprecated
	 */
	public ResultSet sendQueryEx(String query) throws SQLException
	{
		return resultsQueryEx(query).getResultSet();
	}

	/**
	 * @deprecated Method sendQueryEx is deprecated
	 */
	public ResultSet sendQueryEx(StringBuffer query) throws SQLException
	{
		return sendQueryEx(query.toString());
	}

	/**
	 * @deprecated Method sendQuery is deprecated
	 */
	public ResultSet sendQuery(String query)
	{
		QueryResults rs = null;
		try
		{
			rs = executeQuery(query);
		}
		catch (Exception e)
		{
			Diagnostics.error("Problem while executing query " + query, e);
		}
		if (rs == null)
			return null;
		else
			return rs.getResultSet();
	}

	/**
	 * @deprecated Method sendQuery is deprecated
	 */
	public ResultSet sendQuery(StringBuffer query)
	{
		return sendQuery(query.toString());
	}

	public int updateEx(String query, boolean doCommit) throws SQLException
	{
		int result = executeUpdate(query);
		if (doCommit)
			commit();
		return result;
	}

	public int updateEx(StringBuffer query, boolean doCommit) throws SQLException
	{
		return updateEx(query.toString(), doCommit);
	}

	public int updateEx(String query) throws SQLException
	{
		return updateEx(query, false);
	}

	public int updateEx(StringBuffer query) throws SQLException
	{
		return updateEx(query.toString(), false);
	}

	public int updateAtLeastEx(String query, int minRequired, boolean commit) throws SQLException
	{
		int rowsUpdated = updateEx(query, commit);
		if (rowsUpdated < minRequired)
		{
			SQLException baseEx = new SQLException("Updated: " + rowsUpdated + " Minimum: " + minRequired);
			baseEx.setNextException(new SQLException(query));
			throw baseEx;
		}
		else
		{
			return rowsUpdated;
		}
	}

	public int updateAtLeastEx(String query, int minRequired) throws SQLException
	{
		return updateAtLeastEx(query, minRequired, false);
	}

	public int updateAtLeastEx(StringBuffer query, int minRequired) throws SQLException
	{
		return updateAtLeastEx(query.toString(), minRequired, false);
	}

	public int updateAtLeastEx(StringBuffer query, int minRequired, boolean commit) throws SQLException
	{
		return updateAtLeastEx(query.toString(), minRequired, commit);
	}

	public int updateExactlyEx(String query, int numRequired, boolean commit) throws SQLException
	{
		int rowsUpdated = updateEx(query, commit);
		if (rowsUpdated != numRequired)
		{
			SQLException baseEx = new SQLException("Updated: " + rowsUpdated + " Required: " + numRequired);
			baseEx.setNextException(new SQLException(query));
			throw baseEx;
		}
		else
		{
			return rowsUpdated;
		}
	}

	public int updateExactlyEx(String query, int numRequired) throws SQLException
	{
		return updateExactlyEx(query, numRequired, false);
	}

	public int updateExactlyEx(StringBuffer query, int numRequired) throws SQLException
	{
		return updateExactlyEx(query.toString(), numRequired, false);
	}

	public int updateExactlyEx(StringBuffer query, int numRequired, boolean commit) throws SQLException
	{
		return updateExactlyEx(query.toString(), numRequired, commit);
	}

	/**
	 * @deprecated Method quickUpdate is deprecated
	 */
	public int quickUpdate(String query, boolean doCommit)
	{
		int result = 0;
		try
		{
			result = executeUpdate(query);
			if (doCommit)
				commit();
		}
		catch (Exception e)
		{
			Diagnostics.error("Exception while performing mutation:\n" + query + "\n", e);
		}
		return result;
	}

	/**
	 * @deprecated Method quickUpdate is deprecated
	 */
	public int quickUpdate(String query)
	{
		return quickUpdate(query, true);
	}

	/**
	 * @deprecated Method quickUpdate is deprecated
	 */
	public int quickUpdate(StringBuffer query)
	{
		return quickUpdate(query.toString(), true);
	}

	/**
	 * @deprecated Method quickUpdate is deprecated
	 */
	public int quickUpdate(StringBuffer query, boolean doCommit)
	{
		return quickUpdate(query.toString(), doCommit);
	}

	/**
	 * @deprecated Method doInsert is deprecated
	 */
	public boolean doInsert(String qry, Hashtable data)
	{
		String query = null;
		boolean indicator = true;
		try
		{
			query = applyValuesToTemplate(qry, data);
			executeUpdate(query);
			commit();
		}
		catch (Exception e)
		{
			Diagnostics.error("Exception while performing insert:\n" + query + "\n", e);
			indicator = false;
		}
		return indicator;
	}

	/**
	 * @deprecated Method doInsert is deprecated
	 */
	public boolean doInsert(StringBuffer qry, Hashtable data)
	{
		return doInsert(qry.toString(), data);
	}

	/**
	 * @deprecated Method applyValuesToTemplate is deprecated
	 */
	private String applyValuesToTemplate(String template, Hashtable replacements)
	{
		String key = null;
		String value = null;
		String converted = template;
		for (Enumeration elements = replacements.keys(); elements.hasMoreElements();)
		{
			key = (String) elements.nextElement();
			value = (String) replacements.get(key);
			for (int oi = converted.indexOf("%%" + key + "%%"); oi != -1; oi = converted.indexOf("%%" + key + "%%"))
				converted = converted.substring(0, oi) + value + converted.substring(oi + key.length() + 4);
		}
		return converted;
	}

	/**
	 * @deprecated Method doInsert is deprecated
	 */
	public boolean doInsert(String qry, Vector data)
	{
		return false;
	}

	/**
	 * @deprecated Method doMultiInsert is deprecated
	 */
	public boolean doMultiInsert(String qry, Vector data)
	{
		return false;
	}

	/**
	 * @deprecated Method doUpdate is deprecated
	 */
	public boolean doUpdate(String qry, Hashtable data)
	{
		return false;
	}

	/**
	 * @deprecated Method doMultiUpdate is deprecated
	 */
	public boolean doMultiUpdate(String qry, Hashtable data)
	{
		return false;
	}

	/**
	 * @deprecated Method doMultiUpdateAndInsert is deprecated
	 */
	public boolean doMultiUpdateAndInsert(String qry, Hashtable data)
	{
		return false;
	}


	/**
	 * @deprecated Method quickQuery is deprecated
	 */
	public String quickQuery(String query)
	{
		String result = null;
		QueryResults rs = null;
		try
		{
			rs = executeQuery(query);
			if (rs.next())
				result = rs.getString(1);
		}
		catch (Exception e)
		{
			Diagnostics.error("Exception while executing query:\n" + query + "\n", e);
		}
		finally
		{
			try
			{
				if (rs != null)
					rs.close();
			}
			catch (Exception ex)
			{
			}
		}
		return result;
	}

	/**
	 * @deprecated Method quickQuery is deprecated
	 */
	public String quickQuery(StringBuffer query)
	{
		return quickQuery(query.toString());
	}

	public String queryEx(String query) throws SQLException
	{
		String result = null;
		QueryResults rs = null;
		try
		{
			rs = executeQuery(query);
			if (rs.next())
			{
				result = rs.getString(1);
			}
		}
		finally
		{
			try
			{
				if( rs != null ) rs.close();
			}
			catch (Exception ignore)
			{
			}
		}
		return result;
	}

	public String queryEx(StringBuffer query) throws SQLException
	{
		return queryEx(query.toString());
	}

	public Statement createStatement() throws SQLException
	{
		Statement stmt = theConnection.createStatement();
		_statements.addElement(stmt);
		return stmt;
	}

	public void removeStatement(Statement stmt)
	{
		if (stmt == null)
			return;
		try
		{
			_statements.removeElement(stmt);
			_queries.remove(stmt);
			stmt.close();
		}
		catch (Exception e)
		{
			Diagnostics.error("ConnectionWrapper.removeStatement(): Exception removing statement", e);
		}
	}

	public PreparedStatement prepareStatement(String sql) throws SQLException
	{
		return theConnection.prepareStatement(sql);
	}

	public PreparedStatement prepareStatement(String sql, Object params[]) throws SQLException
	{
		PreparedStatement stmt = prepareStatement(sql);
		for (int i = 0; params != null && i < params.length; i++)
		{
			Object o = params[i];
			if (o instanceof java.util.Date) 
				o = new Timestamp(((java.util.Date)o).getTime());
			
			if (o == null) 
				stmt.setString(i+1, null); 
			else 
				stmt.setObject(i+1, o);
		}
		
		return stmt;
	}

	public CallableStatement prepareCall(String sql) throws SQLException
	{
		return theConnection.prepareCall(sql);
	}

	public String nativeSQL(String sql) throws SQLException
	{
		return theConnection.nativeSQL(sql);
	}

	public void setAutoCommit(boolean autoCommit) throws SQLException
	{
		theConnection.setAutoCommit(autoCommit);
	}

	public boolean getAutoCommit() throws SQLException
	{
		return theConnection.getAutoCommit();
	}

	public void commit() throws SQLException
	{
		theConnection.commit();
	}

	public void rollback() throws SQLException
	{
		theConnection.rollback();
	}

	public void close() throws SQLException
	{
		theConnection.close();
	}

	public boolean isClosed() throws SQLException
	{
		return theConnection.isClosed();
	}

	public DatabaseMetaData getMetaData() throws SQLException
	{
		return theConnection.getMetaData();
	}

	public void setReadOnly(boolean readOnly) throws SQLException
	{
		theConnection.setReadOnly(readOnly);
	}

	public boolean isReadOnly() throws SQLException
	{
		return theConnection.isReadOnly();
	}

	public void setCatalog(String catalog) throws SQLException
	{
		theConnection.setCatalog(catalog);
	}

	public String getCatalog() throws SQLException
	{
		return theConnection.getCatalog();
	}

	public void setTransactionIsolation(int level) throws SQLException
	{
		theConnection.setTransactionIsolation(level);
	}

	public int getTransactionIsolation() throws SQLException
	{
		return theConnection.getTransactionIsolation();
	}

	public SQLWarning getWarnings() throws SQLException
	{
		return theConnection.getWarnings();
	}

	public void clearWarnings() throws SQLException
	{
		theConnection.clearWarnings();
	}

	/**
	 * @deprecated Method toSqlString is deprecated
	 */
	public String toSqlString(String s)
	{
		return toSQLString(s);
	}

	/**
	 * @deprecated Method toSqlString is deprecated
	 */
	public String toSqlString(Date d)
	{
		return toSQLString(d);
	}

	public String toSQLString(String s)
	{
		return producer.toSQLString(s);
	}

	public String toSQLString(Date d)
	{
		return producer.toSQLString(d);
	}

	public String now()
	{
		return producer.now();
	}

	public CallableStatement prepareCall(String sql, int resultSetType, int resultSetConcurrency) throws SQLException
	{
		try
		{
			Class c[] = { sql.getClass(), Integer.TYPE, Integer.TYPE };
			Object o[] = { sql, new Integer(resultSetType), new Integer(resultSetConcurrency) };
			return (CallableStatement) theConnection.getClass().getDeclaredMethod("prepareCall", c).invoke(theConnection, o);
		}
		catch (Exception e)
		{
			return null;
		}
	}

	public PreparedStatement prepareStatement(String sql, int resultSetType, int resultSetConcurrency) throws SQLException
	{
		try
		{
			Class c[] = { sql.getClass(), Integer.TYPE, Integer.TYPE };
			Object o[] = { sql, new Integer(resultSetType), new Integer(resultSetConcurrency) };
			return (CallableStatement) theConnection.getClass().getDeclaredMethod("prepareStatement", c).invoke(theConnection, o);
		}
		catch (Exception e)
		{
			return null;
		}
	}

	public Statement createStatement(int resultSetType, int resultSetConcurrency) throws SQLException
	{
		try
		{
			Class c[] = { Integer.TYPE, Integer.TYPE };
			Object o[] = { new Integer(resultSetType), new Integer(resultSetConcurrency) };
			Statement stmt = (Statement) theConnection.getClass().getDeclaredMethod("createStatement", c).invoke(theConnection, o);
			_statements.addElement(stmt);
			return stmt;
		}
		catch (Exception e)
		{
			return null;
		}
	}

	public Map getTypeMap() throws SQLException
	{
		try
		{
			Class c[] = new Class[0];
			Object o[] = new Object[0];
			return (Map) theConnection.getClass().getDeclaredMethod("getTypeMap", c).invoke(theConnection, o);
		}
		catch (Exception e)
		{
			return null;
		}
	}

	public void setTypeMap(Map map) throws SQLException
	{
		try
		{
			Class c[] = { map.getClass() };
			Object o[] = { map };
			theConnection.getClass().getDeclaredMethod("setTypeMap", c).invoke(theConnection, o);
			return;
		}
		catch (Exception e)
		{
			return;
		}
	}

	// The following methods are needed for the JDBC 3.0 Connection interface
	// the following is a HACK for cross-version Java 1.3 <--> 1.4 support
	public Statement createStatement(int resultSetType, int resultSetConcurrency, int resultSetHoldability) throws SQLException
	{
		Statement result = null;
		try
		{
			result = (Statement) theConnection.getClass().getDeclaredMethod("createStatement",
					new Class[] { Integer.TYPE, Integer.TYPE, Integer.TYPE })
					.invoke(
							theConnection,
							new Object[] { new Integer(resultSetType), new Integer(resultSetConcurrency),
									new Integer(resultSetHoldability) });
			_statements.add(result);
		}
		catch (Exception e)
		{
		}
		return result;
	}

	public int getHoldability() throws SQLException
	{
		Integer result = new Integer(0);
		try
		{
			result = (Integer) theConnection.getClass().getDeclaredMethod("getHoldability", new Class[] {}).invoke(theConnection,
					new Object[] {});
		}
		catch (Exception e)
		{
		}
		return result.intValue();
	}

	public CallableStatement prepareCall(String sql, int resultSetType, int resultSetConcurrency, int resultSetHoldability)
			throws SQLException
	{
		CallableStatement result = null;
		try
		{
			result = (CallableStatement) theConnection.getClass().getDeclaredMethod("prepareCall",
					new Class[] { Integer.TYPE, Integer.TYPE, Integer.TYPE })
					.invoke(
							theConnection,
							new Object[] { new Integer(resultSetType), new Integer(resultSetConcurrency),
									new Integer(resultSetHoldability) });
		}
		catch (Exception e)
		{
		}
		return result;
	}

	public PreparedStatement prepareStatement(String sql, int resultSetType, int resultSetConcurrency, int resultSetHoldability)
			throws SQLException
	{
		PreparedStatement result = null;
		try
		{
			result = (PreparedStatement) theConnection.getClass().getDeclaredMethod("prepareStatement",
					new Class[] { String.class, Integer.TYPE, Integer.TYPE, Integer.TYPE }).invoke(
					theConnection,
					new Object[] { sql, new Integer(resultSetType), new Integer(resultSetConcurrency),
							new Integer(resultSetHoldability) });
		}
		catch (Exception e)
		{
		}
		return result;
	}

	public PreparedStatement prepareStatement(String sql, int autoGeneratedKeys) throws SQLException
	{
		PreparedStatement result = null;
		try
		{
			result = (PreparedStatement) theConnection.getClass().getDeclaredMethod("prepareStatement",
					new Class[] { String.class, Integer.TYPE }).invoke(theConnection,
					new Object[] { sql, new Integer(autoGeneratedKeys) });
		}
		catch (Exception e)
		{
		}
		return result;
	}

	public PreparedStatement prepareStatement(String sql, int[] columnIndexes) throws SQLException
	{
		PreparedStatement result = null;
		try
		{
			result = (PreparedStatement) theConnection.getClass().getDeclaredMethod("prepareStatement",
					new Class[] { String.class, columnIndexes.getClass() }).invoke(theConnection,
					new Object[] { sql, columnIndexes });
		}
		catch (Exception e)
		{
		}
		return result;
	}

	public PreparedStatement prepareStatement(String sql, String[] columnNames) throws SQLException
	{
		PreparedStatement result = null;
		try
		{
			result = (PreparedStatement) theConnection.getClass().getDeclaredMethod("prepareStatement",
					new Class[] { String.class, columnNames.getClass() }).invoke(theConnection, new Object[] { sql, columnNames });
		}
		catch (Exception e)
		{
		}
		return result;
	}

	public void releaseSavepoint(java.sql.Savepoint savepoint) throws SQLException
	{
		try
		{
			theConnection.getClass().getDeclaredMethod("releaseSavepoint", new Class[] { java.sql.Savepoint.class }).invoke(
					theConnection, new Object[] { savepoint });
		}
		catch (Exception e)
		{
		}
	}

	public void rollback(java.sql.Savepoint savepoint) throws SQLException
	{
		try
		{
			theConnection.getClass().getDeclaredMethod("rollback", new Class[] { java.sql.Savepoint.class }).invoke(theConnection,
					new Object[] { savepoint });
		}
		catch (Exception e)
		{
		}
	}

	public void setHoldability(int holdability) throws SQLException
	{
		try
		{
			theConnection.getClass().getDeclaredMethod("setHoldability", new Class[] { Integer.TYPE }).invoke(theConnection,
					new Object[] { new Integer(holdability) });
		}
		catch (Exception e)
		{
		}
	}

	public java.sql.Savepoint setSavepoint() throws SQLException
	{
		java.sql.Savepoint result = null;
		try
		{
			result = (java.sql.Savepoint) theConnection.getClass().getDeclaredMethod("setSavepoint", new Class[] {}).invoke(
					theConnection, new Object[] {});
		}
		catch (Exception e)
		{
		}
		return result;
	}

	public java.sql.Savepoint setSavepoint(String name) throws SQLException
	{
		java.sql.Savepoint result = null;
		try
		{
			result = (java.sql.Savepoint) theConnection.getClass().getDeclaredMethod("setSavepoint", new Class[] { String.class })
					.invoke(theConnection, new Object[] { name });
		}
		catch (Exception e)
		{
		}
		return result;
	}

}

/***********************************************************************************************************************************
 * DECOMPILATION REPORT ***
 *
 * DECOMPILED FROM: c:\work\ims\www\WEB-INF\lib\iFrame2.jar
 *
 *
 * TOTAL TIME: 78 ms
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
