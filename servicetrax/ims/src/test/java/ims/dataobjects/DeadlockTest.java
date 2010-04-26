package ims.dataobjects;

import static org.junit.Assert.assertTrue;

import java.sql.SQLException;
import java.sql.Statement;

import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;
import org.w3c.dom.Element;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.Configuration;
import dynamic.util.resources.BaseResourceManager;
import dynamic.util.xml.XMLUtils;

public class DeadlockTest
{
	static BaseResourceManager rm;

//	@BeforeClass
//	public static void setUpBeforeClass() throws Exception
//	{
//		Configuration config = new Configuration("src/main/webapp/WEB-INF/ims.xml");
//		rm = new BaseResourceManager();
//		Element resourceManagerElement = XMLUtils.getSingleElement(config.getConfigDocument(), Configuration.RESOURCE_MANAGER);
//		rm.initialize(resourceManagerElement);
//		ConnectionWrapper conn = null;
//		Statement stmt = null;
//		try {
//			conn = (ConnectionWrapper) rm.getResource();
//			stmt = conn.createStatement();
//			stmt.execute("IF OBJECT_ID( 'TestDeadLoack') IS NOT NULL DROP table TestDeadLoack");
//			stmt.execute("IF OBJECT_ID( 'DeadLoack') IS NOT NULL DROP table DeadLoack");
//			stmt.execute("CREATE table TestDeadLoack  (id int, name VARCHAR(100))");
//			stmt.execute("CREATE table DeadLoack (id int, name VARCHAR(100))");
//			stmt.execute("Insert TestDeadLoack Select 1,'Madhu'");
//			stmt.execute("Insert TestDeadLoack Select 2,'ABC'");
//			stmt.execute("Insert TestDeadLoack Select 3,'XYZ'");
//			stmt.execute("Insert DeadLoack Select 1,'Madhu'");
//			stmt.execute("Insert DeadLoack Select 2,'ABC'");
//			stmt.execute("Insert DeadLoack Select 3,'XYZ'");
//		} catch (SQLException e) {
//			System.out.println("Exception in DeadlockTest.setUpBeforeClass(): " + e.getMessage());
//		} finally {
//			if (stmt != null) {
//				stmt.close();
//			}
//			
//			if (conn != null) {
//				conn.close();
//			}
//		}
//	}
//
//	@AfterClass
//	public static void tearDownAfterClass() throws Exception
//	{
//		ConnectionWrapper conn = null;
//		Statement stmt = null;
//		try {
//			conn = (ConnectionWrapper) rm.getResource();
//			stmt = conn.createStatement();
//			stmt.execute("IF OBJECT_ID( 'TestDeadLoack') IS NOT NULL DROP table TestDeadLoack");
//			stmt.execute("IF OBJECT_ID( 'DeadLoack') IS NOT NULL DROP table DeadLoack");
//		} catch (SQLException e) {
//			System.out.println("Exception in DeadlockTest.tearDownAfterClass(): " + e.getMessage());
//		} finally {
//			if (stmt != null) {
//				stmt.close();
//			}
//			
//			if (conn != null) {
//				conn.close();
//			}
//		}
//		if (rm != null)
//			rm.destroy();
//	}
//
//	@Test
//	public void testDeadlock() throws Exception {
//		ConnectionWrapper conn = null;
//		ConnectionWrapper conn2 = null;
//		try {
//			conn = (ConnectionWrapper) rm.getResource("Test");
//			conn.setTransactionIsolation(conn.TRANSACTION_SERIALIZABLE);
//			int conn_level = conn.getTransactionIsolation();
//			conn2 = (ConnectionWrapper) rm.getResource("Test2");
//			conn2.setTransactionIsolation(conn.TRANSACTION_SERIALIZABLE);
//			int conn_level2 = conn2.getTransactionIsolation();
//			conn.setAutoCommit(false);
//			conn2.setAutoCommit(false);
//			conn.update("Begin tran");
//			conn.update("UPDATE TestDeadLoack SET Name = 'Madhu123'");
//			conn2.update("Begin tran");
//			conn2.update("UPDATE ims.DeadLoack SET Name = 'xyz345'");
//			
//			(new Thread(new DeadlockRunnale(conn2, "SELECT * From ims.TestDeadLoack", "sekect1"))).start();
//			
//			(new Thread(new DeadlockRunnale(conn, "SELECT * From DeadLoack", "sekect2"))).start();
//			
//			for (int i = 0; i < 1000000; i++) {
//				String str = "A" + "B" + "C" + "a" + "b" + "c";
//			}
//			
////			QueryResults qr = conn2.select("SELECT * From ims.TestDeadLoack");
////			while (qr.next()) {
////				System.out.println(qr.getString(2));
////			}
////			
////			QueryResults qr2 = conn.select("SELECT * From DeadLoack");
////			while (qr2.next()) {
////				System.out.println(qr2.getString(2));
////			}
//		} catch (SQLException e) {		
//			assertTrue(e.getErrorCode() == 1205);
//		} finally {
//			if (conn != null) {
//				conn.close();
//			}
//			if (conn2 != null) {
//				conn2.close();
//			}
//		}
//	}

	@Test
	public void doNothing()
	{
		
	}
}
