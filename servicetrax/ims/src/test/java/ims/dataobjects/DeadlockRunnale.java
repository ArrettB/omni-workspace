package ims.dataobjects;

import static org.junit.Assert.fail;

import ims.helpers.IMSUtil;

import java.sql.CallableStatement;
import java.sql.SQLException;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.util.diagnostics.Diagnostics;

/**
 * @version $Id: DeadlockRunnale.java, 1, 8/25/2008 5:42:18 PM, Blake Von Haden$
 */
public class DeadlockRunnale implements Runnable {
	
	private String name = null;
	private Thread tid = null;
	private ConnectionWrapper conn;
	private String query;


	private final static int SLEEP_TIME = 1 * 60 * 60 * 1000; // every 1 hour
	
	public DeadlockRunnale() {
		
	}
	
	public DeadlockRunnale(ConnectionWrapper conn, String query, String name) {
		this.conn = conn;
		this.query = query;
		this.name = name;
	}




	public void start()
	{
		Diagnostics.trace("DeadlockRunnale.start()");
		tid = new Thread(this, name);
		Diagnostics.registerThread(tid);
		tid.start();
	}

	public void stop()
	{
		Diagnostics.trace("DeadlockRunnale.stop()");
		if (tid == null)
			return;
		Thread tmp = tid;
		tid = null;
		tmp.interrupt();
	}

	public void run() {
		CallableStatement stmt = null;
		try	{
			Diagnostics.trace("DeadlockRunnale.run() starting");
			conn.select(query);
//			QueryResults qr = conn.select(query);
//			while (qr.next()) {
//				System.out.println(qr.getString(2));
//			}
			fail("************** Failed deadlock test!!!!");
		} catch (Throwable t) {
			if (((SQLException) t).getErrorCode() == 1205) {
				System.out.println("It is a deadlock!!!!!!!");		
				IMSUtil.sendEmail("mail.apexit.com", 25, "david.zhao@apexit.com", "david.zhao@apexit.com", "deadlock alert", t.getMessage() + " Failed SQL Statement = (" + query + ")");
//				try {				
//					stmt = conn.prepareCall("{call sp_deadlock_alert()}");
//					stmt.execute();
//				} catch (Exception e ) {
//					Diagnostics.error("Exception calling sp_deadlock_alert()", e);
//				} finally {
//					try {
//					if (stmt != null) {
//						stmt.close();
//					}
//					} catch (Exception e) {
//						//
//					}
//				}
			}
			Diagnostics.error("Exception in DeadlockRunnale", t);
		}

		Diagnostics.debug("DeadlockRunnale() complete");
	}

	public static int getSLEEP_TIME() {
		return SLEEP_TIME;
	}

	public ConnectionWrapper getConn() {
		return conn;
	}

	public String getQuery() {
		return query;
	}
	
	public String getName() {
		return name;
	}
	

}