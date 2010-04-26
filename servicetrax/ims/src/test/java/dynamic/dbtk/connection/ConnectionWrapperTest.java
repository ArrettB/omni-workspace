/*
 *               ApexIT, Inc.
 *
 * This software can only be used with the expressed written
 * consent of ApexIT, Inc. All rights reserved.
 *
 * Copyright 2008 ApexIT, Inc.
 * $Id: ConnectionWrapperTest.java 1393 2008-10-30 16:37:37Z bvonhaden $
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL DYNAMIC INFORMATIONS SYTEMS, LLC
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
 * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 * ====================================================================
 */

package dynamic.dbtk.connection;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import ims.helpers.IMSUtil;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Date;

import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;
import org.w3c.dom.Element;

import dynamic.intraframe.engine.Configuration;
import dynamic.util.resources.BaseResourceManager;
import dynamic.util.xml.XMLUtils;

/**
 * @version $Id: ConnectionWrapperTest.java 1393 2008-10-30 16:37:37Z bvonhaden $
 */
public class ConnectionWrapperTest
{

	static BaseResourceManager rm;

//	@BeforeClass
//	public static void setUpBeforeClass() throws Exception
//	{
//		Configuration config = new Configuration("src/main/webapp/WEB-INF/ims.xml");
//		rm = new BaseResourceManager();
//		Element resourceManagerElement = XMLUtils.getSingleElement(config.getConfigDocument(), Configuration.RESOURCE_MANAGER);
//		rm.initialize(resourceManagerElement);
//	}
//
//	@AfterClass
//	public static void tearDownAfterClass() throws Exception
//	{
//		if (rm != null)
//			rm.destroy();
//	}
//
//	/**
//	 * Test method for {@link dynamic.dbtk.connection.ConnectionWrapper#selectFirst(java.lang.StringBuffer, java.lang.Object[])}.
//	 * @throws Exception 
//	 */
//	@Ignore
//	@Test
//	public void testSelectFirst_Stringinline() throws Exception
//	{
//		ConnectionWrapper conn = (ConnectionWrapper) rm.getResource();
//
//		Date start = new Date();
//		String val = conn.selectFirst("SELECT rate FROM job_item_rates WHERE job_id = '15539' and item_id = '270'");
//		System.out.println("time elapsed=" + (new Date().getTime() - start.getTime()));
//
//		assertNotNull(val);
//		conn.close();
//	}
//
//	/**
//	 * Test method for {@link dynamic.dbtk.connection.ConnectionWrapper#selectFirst(java.lang.StringBuffer, java.lang.Object[])}.
//	 * @throws Exception 
//	 */
//	@Ignore
//	@Test
//	public void testSelectFirst_Integer() throws Exception
//	{
//		ConnectionWrapper conn = (ConnectionWrapper) rm.getResource();
//
//		Integer jobID = new Integer("15539");
//		Integer itemID = new Integer("270");
//		Date start = new Date();
//		String val = conn.selectFirst("SELECT rate FROM job_item_rates WHERE job_id = ? and item_id = ?", new Integer[] { jobID,
//				itemID });
//		System.out.println("time elapsed=" + (new Date().getTime() - start.getTime()));
//
//		assertNotNull(val);
//		conn.close();
//	}
//
//	/**
//	 * Test method for {@link dynamic.dbtk.connection.ConnectionWrapper#selectFirst(java.lang.StringBuffer, java.lang.Object[])}.
//	 * Using BigDecimal on ID's has very bad performance.
//	 * 
//	 * @throws Exception 
//	 */
//	@Ignore
//	@Test
//	public void testSelectFirst_BigDecimal() throws Exception
//	{
//		ConnectionWrapper conn = (ConnectionWrapper) rm.getResource();
//
//		BigDecimal jobID = new BigDecimal("15539");
//		BigDecimal itemID = new BigDecimal("270");
//		Date start = new Date();
//		String val = conn.selectFirst("SELECT rate FROM job_item_rates WHERE job_id = ? and item_id = ?", new BigDecimal[] { jobID,
//				itemID });
//		System.out.println("time elapsed=" + (new Date().getTime() - start.getTime()));
//
//		assertNotNull(val);
//		conn.close();
//	}
//
//	/**
//	 * Test method for {@link dynamic.dbtk.connection.ConnectionWrapper#selectFirst(java.lang.StringBuffer)}.
//	 * @throws Exception 
//	 */
//	@Ignore
//	@Test
//	public void testSelectFirst_String() throws Exception
//	{
//		ConnectionWrapper conn = (ConnectionWrapper) rm.getResource();
//
//		String jobID = "15539";
//		String itemID = "270";
//		Date start = new Date();
//		String val = conn.selectFirst("SELECT rate FROM job_item_rates WHERE job_id = ? and item_id = ?", new String[] { jobID,
//				itemID });
//		System.out.println("time elapsed=" + (new Date().getTime() - start.getTime()));
//
//		assertNotNull(val);
//		conn.close();
//	}
//
//	/**
//	 * Test method for {@link dynamic.dbtk.connection.ConnectionWrapper#selectFirst(java.lang.StringBuffer)}.
//	 * @throws Exception 
//	 */
//	@Ignore
//	@Test
//	public void testQueryEx_String() throws Exception
//	{
//		ConnectionWrapper conn = (ConnectionWrapper) rm.getResource();
//
//		String jobID = "15539";
//		String itemID = "270";
//		Date start = new Date();
//		String val = conn.queryEx("SELECT rate FROM job_item_rates WHERE job_id = " + conn.toSQLString(jobID) + " and item_id = "
//				+ conn.toSQLString(itemID));
//		System.out.println("time elapsed=" + (new Date().getTime() - start.getTime()));
//
//		assertNotNull(val);
//		conn.close();
//	}
//
//	/**
//	 * Test method for {@link dynamic.dbtk.connection.ConnectionWrapper#selectFirst(java.lang.StringBuffer, java.lang.Object[])}.
//	 * @throws Exception 
//	 */
//	@Ignore
//	@Test
//	public void testPstmt_Int() throws Exception
//	{
//		ConnectionWrapper conn = (ConnectionWrapper) rm.getResource();
//
//		Date start = new Date();
//		PreparedStatement stmt = IMSUtil.queryToPreparedStatement(conn,
//				"SELECT rate FROM job_item_rates WHERE job_id = '<#?I15539?#>' and item_id = '<#?I270?#>'");
//		ResultSet rs = stmt.executeQuery();
//		String val = null;
//		if (rs.next())
//		{
//			val = rs.getString(1);
//		}
//		rs.close();
//		stmt.close();
//		System.out.println("time elapsed=" + (new Date().getTime() - start.getTime()));
//
//		assertNotNull(val);
//		conn.close();
//	}
//
//	/**
//	 * Test method for {@link dynamic.dbtk.connection.ConnectionWrapper#selectFirst(java.lang.StringBuffer, java.lang.Object[])}.
//	 * @throws Exception 
//	 */
//	@Ignore
//	@Test
//	public void testPstmt_String() throws Exception
//	{
//		ConnectionWrapper conn = (ConnectionWrapper) rm.getResource();
//
//		Date start = new Date();
//		PreparedStatement stmt = IMSUtil.queryToPreparedStatement(conn,
//				"SELECT rate FROM job_item_rates WHERE job_id = '<#?S15539?#>' and item_id = '<#?S270?#>'");
//		ResultSet rs = stmt.executeQuery();
//		String val = null;
//		if (rs.next())
//		{
//			val = rs.getString(1);
//		}
//		rs.close();
//		stmt.close();
//		System.out.println("time elapsed=" + (new Date().getTime() - start.getTime()));
//
//		assertNotNull(val);
//		conn.close();
//	}
//
//	/**
//	 * Test method for {@link dynamic.dbtk.connection.ConnectionWrapper#selectFirst(java.lang.StringBuffer, java.lang.Object[])}.
//	 * @throws Exception 
//	 */
//	@Ignore	@Test
//	public void testIsolationLevel() throws Exception
//	{
//		ConnectionWrapper conn = (ConnectionWrapper) rm.getResource();
//
//		String val = null;
//		QueryResults rs = conn.select("DBCC USEROPTIONS");
//		while (rs.next())
//		{
//			String setOption = rs.getString("Set Option");
//			if ("isolation level".equals(setOption))
//				val = rs.getString("Value");
//		}
//		rs.close();
//
//		assertEquals("read uncommitted", val);
//		conn.close();
//	}
//
//	/**
//	 * Test method for {@link dynamic.dbtk.connection.ConnectionWrapper#selectFirst(java.lang.StringBuffer, java.lang.Object[])}.
//	 * @throws Exception 
//	 */
//
//	public void testIsolationLevel_autocommitFalse() throws Exception
//	{
//		ConnectionWrapper conn = (ConnectionWrapper) rm.getResource();
//
//		conn.setAutoCommit(false);
//		String val = null;
//		QueryResults rs = conn.select("DBCC USEROPTIONS");
//		while (rs.next())
//		{
//			String setOption = rs.getString("Set Option");
//			if ("isolation level".equals(setOption))
//				val = rs.getString("Value");
//		}
//		rs.close();
//
//		assertEquals("read uncommitted", val);
//		
//		conn.setAutoCommit(true);
//		conn.close();
//	}

	@Test
	public void doNothing()
	{
		
	}
}
