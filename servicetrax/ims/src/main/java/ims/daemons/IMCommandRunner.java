package ims.daemons;

import ims.dataobjects.IMCommand;
import dynamic.intraframe.engine.ApplicationContext;
import dynamic.intraframe.engine.BaseApplicationContext;
import dynamic.intraframe.engine.Daemon;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.exec.ExecUtils;
import dynamic.util.string.StringUtil;
import dynamic.util.threads.BlockingQueue;
import dynamic.util.xml.XMLUtils;

/**
 * 
 * 
 * @version $Revision: 119 $Date: 3/27/2006 5:41:43 PM$
 */
public class IMCommandRunner implements Daemon
{
	public static final String IMCOMMAND_RUNNER = "IMCommandRunner";
	private String name = null;
	private Thread tid = null;
	private java.util.Date lastRun;
	private String path;

	private BlockingQueue queue = null;

	private final static int SLEEP_TIME = 0; // no sleep time

	/**
	 * Initializer called by iFrame when running as an iFrame Daemon. Diagnostics and ResourceManager are already initialized.
	 */
	public void initialize(ApplicationContext ac, String name) throws Exception
	{
		Diagnostics.trace("IMCommandRunner.initialize(ac,\"" + name + "\")");
		// this property must be set for integration manager to be fired from InvoiceBatch.java
		// to do, set CATALINA_OPTS=-Dam.integrationManager=true
		Diagnostics.debug("am.integrationManager " + System.getProperty("am.integrationManager"));

		path = XMLUtils.getValue(ac.getConfigDocument(), "integrationManager:path").trim();
		this.name = name;
		((BaseApplicationContext) ac).getResourceManager();
		ac.getConfigDocument();
		ac.setAppGlobalDatum(IMCOMMAND_RUNNER, this);

	}

	/**
	 * Shut down and destroy the Daemon (cleanup)
	 */
	public void destroy()
	{
		Diagnostics.trace("IMCommandRunner.destroy()");
		stop();
	}

	/**
	 * Show information about this Daemon
	 */
	public String toHTML(String href, boolean showDetail)
	{
		Diagnostics.trace("IMCommandRunner.toHTML()");
		if (true)
		// if (showDetail)
		{
			StringBuffer result = new StringBuffer();
			result.append("<table>");
			result.append("<tr>");
			result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">Last Run</font></td>");
			result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">").append(lastRun).append("</font></td>");
			result.append("</tr>");
			result.append("<tr>");
			result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">Sleep Time (seconds)</font></td>");
			result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">").append(SLEEP_TIME / 1000).append("</font></td>");
			result.append("</tr>");
			result.append("</table>");
			return result.toString();
		}
		else
		{
			StringBuffer result = new StringBuffer();
			result.append("<table>");
			result.append("<tr>");
			result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\"><a href=\"" + href);
			result.append("&daemon=" + getName());
			result.append("\">" + getName() + "</a></font></td>");
			result.append("</tr>");
			result.append("</table");
			return result.toString();
		}
	}

	/**
	 * The name of the Daemon
	 */
	public String getName()
	{
		return name;
	}

	/**
	 * Enqueue the command
	 */
	public synchronized void enqueueCmd(IMCommand imc) throws Exception
	{
		queue.enqueue(imc);
	}

	public void start()
	{
		Diagnostics.trace("IMCommandRunner.start()");
		queue = new BlockingQueue();
		tid = new Thread(this, name);
		Diagnostics.registerThread(tid);
		tid.start();
	}

	public void stop()
	{
		Diagnostics.trace("IMCommandRunner.stop()");
		if (tid == null)
			return;
		Thread tmp = tid;
		tid = null;
		tmp.interrupt();
		queue.close();
	}

	public void restart()
	{
		stop();
		start();
	}

	void close()
	{
		stop();
	}

	public void run()
	{
		String[] cmd = new String[4];
		Diagnostics.trace("IMCommandRunner.run() starting");
		lastRun = new java.util.Date();
		while (tid == Thread.currentThread())
		{
			IMCommand imc = null;

			try
			{
				imc = (IMCommand) queue.dequeue();
				Diagnostics.debug("IMCommandRunner - received a IMCommand");
				imc.changeStatus(2);
				cmd[0] = path;
				cmd[1] = "/I";
				cmd[2] = imc.integrationName;
				cmd[3] = "/S";
				Diagnostics.debug2("IMCommandRunner.run() cmd = " + StringUtil.arrayToString(cmd, ' '));
				// run command
				ExecUtils.exec(cmd);
			}
			catch (Exception e)
			{
				Diagnostics.error("IMCommandRunner.run() error = " + e);
				System.err.println("! " + imc + "\n" + e);
				restart();
			}
		}
	}
}
