package ims.dataobjects;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertFalse;

import java.util.Date;

import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;
import org.w3c.dom.Element;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.Configuration;
import dynamic.util.resources.BaseResourceManager;
import dynamic.util.xml.XMLUtils;

public class ItemTest
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
//	@Test
//	public void testFetch() throws Exception
//	{
//		ConnectionWrapper conn = (ConnectionWrapper) rm.getResource();
//
//		Item item = Item.fetch("65", conn);
//
//		assertNotNull(item);
//		conn.close();
//	}
//
//	@Test (expected=java.sql.SQLException.class)
//	public void testUpdate_InvalidIDModified() throws Exception
//	{
//		ConnectionWrapper conn = (ConnectionWrapper) rm.getResource();
//
//		Item item = Item.fetch("65", conn);
//		item.setItemID(99999965);
//
//		item.commit(conn);
//
//		conn.close();
//	}
//
//
//	@Test
//	public void testInsert() throws Exception
//	{
//		ConnectionWrapper conn = (ConnectionWrapper) rm.getResource();
//
//		Item item = new Item();
//		item.setName("Deleteme");
//		item.setDateCreated(new Date());
//		item.setExtItemID("testdelete");
//		item.setBillableFlag("Y");
//		item.setOrganizationID(2);
//		item.commit(conn);
//
//		item.delete();
//		item.commit(conn);
//
//		conn.close();
//	}
//
//	@Test
//	public void testAllowExpenseEntry() throws Exception
//	{
//		ConnectionWrapper conn = (ConnectionWrapper) rm.getResource();
//
//		Item item = new Item();
//		item.setName("Deleteme");
//		item.setDateCreated(new Date());
//		item.setExtItemID("testdelete");
//		item.setBillableFlag("Y");
//		item.setOrganizationID(2);
//		item.setAllowExpenseEntry("x");
//		item.commit(conn);
//
//		assertFalse(item.isAllowExpenseEntry());
//
//		item.delete();
//		item.commit(conn);
//
//		conn.close();
//	}


	@Test
	public void doNothing()
	{
		
	}
	
}
