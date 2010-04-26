
package ims.handlers.job_processing;

import ims.dataobjects.Item;
import ims.dataobjects.JobItemRate;
import ims.helpers.MapUtil;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.intraframe.templates.components.SmartFormComponent;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * @version $Id: ItemHandler.java, 10, 4/1/2004 1:46:31 PM, Greg Case$
 */
public class ItemHandler extends BaseHandler
{
	public final static String GP_COLUMN_POSITION_MATERIAL = "M";
	public final static String COLUMN_POSITION_MATERIAL = "material";
	
	public final static String GP_COLUMN_POSITION_SUBCONTRACTOR = "SU";
	public final static String COLUMN_POSITION_SUBCONTRACTOR = "subcontractor";

	public void setUpHandler(){}
	public void destroy(){}

	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		Diagnostics.trace("ItemHandler.handleEnvironment()");
		boolean bRet = true;
		boolean show_msg = true;
		ConnectionWrapper ims_conn = null;
		ConnectionWrapper gp_conn = null;
		try
		{

			String mode = (String) ic.getParameter("mode");
			String button = ic.getParameter(SmartFormComponent.BUTTON);
			String redisplay = ic.getParameter("redisplay");
			String dont_show_msg_str = (String) ic.getTransientDatum("dont_show_msg"); //used
																					   // by
																					   // extranet

			if (StringUtil.hasAValue(dont_show_msg_str) && dont_show_msg_str.equalsIgnoreCase("true"))
				show_msg = false;
			if (button == null)
				button = SmartFormComponent.Cancel;

			boolean reload = false;
			String button_name = ic.getParameter("load_rates");
			if (button_name != null && button_name.equalsIgnoreCase("true"))
				reload = true;

			Diagnostics.debug2("mode='" + mode + "' button='" + button + "' reload='" + reload + "' redisplay='" + redisplay + "'");

			if ((button.equalsIgnoreCase(SmartFormComponent.Save) && !redisplay.equalsIgnoreCase("true")) || reload)
			{
				String org_resource = (String) ic.getSessionDatum("org_resource");
				if (org_resource == null || org_resource.trim().equalsIgnoreCase(""))
				{
					//failed to determine which great plains database to grab
					// item data from.
					if (show_msg)
						SmartFormHandler.addSmartFormError(ic, "Missing org_resource, cannot connect to Great Plains.\n"
								+ "Exception in ItemHandler, could not get org_resource from session data.\n"
								+ "Variable org_resource is used to connect to the approprite Great Plains database.");
					Diagnostics.error("ItemHandler.handleEnvironment() Unalbe to find org_resource, cannot connect to Great Plains to load items.");
				}
				else
				{
					//found org_resource so create great plains connection
					ims_conn = (ConnectionWrapper) ic.getTransientDatum(SmartFormHandler.CONNECTION);
					gp_conn = (ConnectionWrapper) ic.getResource(org_resource);

					if (mode.equalsIgnoreCase(SmartFormComponent.Insert) || reload)
					{
						bRet = this.loadItems(ims_conn, gp_conn, ic, show_msg);
						if (bRet)
							bRet = this.loadCustomerRates(ims_conn, gp_conn, ic, false, show_msg);
					}
				}
			}
		}
		catch (Exception e)
		{
			bRet = false;
			Diagnostics.error("Exception in ItemHandler: " + e);
			ErrorHandler.handleException(ic, e, "Exception in ItemHandler");
		}
		finally
		{
			//because this is a Pre/PostHandler, we do NOT release the ims
			// connection

			//we do release the Great Plains Connection
			if (gp_conn != null)
			{
				gp_conn.release();
			}
		}
		return bRet; //because we want to show smartform erros to user
	}

	/**
	 * Load default item pricing from Great Plains (gp) First retrieve all ims
	 * items, compare against gp items if gp item is not in ims, add to ims.
	 */
	public boolean loadItems(ConnectionWrapper ims_conn, ConnectionWrapper gp_conn, InvocationContext ic, boolean show_msg) throws Exception
	{
		Diagnostics.trace("ItemHandler.loadItems()");

		boolean bRet = true;
		String org_id = (String) ic.getSessionDatum("org_id");

		String user_id = (String) ic.getRequiredSessionDatum("user_id");

		//load ims items into hashtable
		StringBuffer query = new StringBuffer();
		query.append("SELECT ext_item_id, item_id FROM items WHERE organization_id=" + ims_conn.toSQLString(org_id) + " ORDER BY ext_item_id");

		Diagnostics.debug3("Load IMS Items Query = " + query.toString());

		QueryResults rs = ims_conn.resultsQueryEx(query);
		Map<String, String> ims_items = new HashMap<String, String>();

		while (rs.next())
		{
			//Diagnostics.debug2("ims item.ext_item_id ='"+
			// rs.getString("ext_item_id").toLowerCase()+"' and
			// ims.item_id='"+rs.getString("item_id")+"'");
			ims_items.put(rs.getString("ext_item_id").toLowerCase().trim(), rs.getString("item_id")); //trim
																									  // not
																									  // really
																									  // needed,
																									  // just
																									  // in
																									  // case
		}
		rs.close();

		//get lookup IDs
		Map<String, String> item_types = MapUtil.getTypeMap(ims_conn, "item_type");
		Map<String, String> item_status_types = MapUtil.getTypeMap(ims_conn, "item_status_type");
		// lookup by attribute 1 code
		Map<String, String> job_types_by_attr1 = getAltMap(ims_conn, "lookups_v", "attribute1", "job_type");

		//update all items rates
		query = new StringBuffer();
		query.append("SELECT im.itemnmbr ext_itemnmbr, im.itmshnam name, im.itemdesc description, ");
		query.append("im.modifdt date_created, im.pricegroup price_group, im.itemtype, ");
		query.append("im.uscatvls_1 billable_flag, im.uscatvls_2 expense_export_code, ");
		query.append("im.uscatvls_3 job_type_attr1, im.uscatvls_4 column_position");
		query.append(" FROM IV00101 im ");
		query.append(" WHERE (im.pricegroup='HOURLY' OR im.pricegroup='EXPENSE') ");
		query.append(" ORDER BY im.itemnmbr");

		Diagnostics.debug3("Load GP Items Query = " + query.toString());

		Item an_item = null; //item to add to ims
		String ext_itemnmbr = null;
		String item_id = null;
		List<Item> items = new ArrayList<Item>();
		rs = gp_conn.resultsQueryEx(query);
		while (rs.next())
		{
			//attempt to fetch item from ims database
			ext_itemnmbr = rs.getString("ext_itemnmbr").toLowerCase().trim(); // need to trim
																			  // because char
																			  // fields are
																			  // padded
			item_id = ims_items.get(ext_itemnmbr);
			Diagnostics.debug2("gp ext_itemnmbr='" + ext_itemnmbr + "', found ims item_id='" + item_id + "'");
			if (item_id == null)
			{
				an_item = new Item();
				an_item.setCreatedBy(user_id);
			}
			else
			{
				an_item = Item.fetch(item_id, ims_conn);
				an_item.setModifiedBy(user_id);
				an_item.setDateModified(new Date());
			}

			an_item.setName(rs.getString("name"));
			if (an_item.getName() == null || an_item.getName().trim().equalsIgnoreCase(""))
			{
				if (show_msg)
					SmartFormHandler.addSmartFormError(ic, "Saved job. However, The Great Plain's item '" + ext_itemnmbr
							+ "' failed to load because it is missing its Short Name.\n" + "You must update the Great Plains item '"
							+ ext_itemnmbr + "' and\n" + "type in a short name before you can use this item in ServiceTRAX.\n\n"
							+ "Then reload rates for this job to load the item.");
			}
			else
			{
				an_item.setOrganizationID((new Integer(org_id)).intValue());
				an_item.setDescription(rs.getString("description"));
				an_item.setExtItemID(ext_itemnmbr);
				an_item.setDateCreated(rs.getDate("date_created"));
				//Diagnostics.debug2("item
				// type='"+rs.getString(5).trim()+"':"+(String)item_types.get("hours")
				// );
				if (rs.getString("price_group").trim().equalsIgnoreCase("hourly")) //pricegroup
					an_item.setItemTypeID((new Integer((String) item_types.get("hours"))).intValue());
				else if (rs.getString("price_group").trim().equalsIgnoreCase("expense")) //pricegroup
					an_item.setItemTypeID((new Integer((String) item_types.get("expense"))).intValue());

				if (rs.getString("itemtype").trim().equalsIgnoreCase("2"))
				{//itemtype is discontinued
					an_item.setItemStatusTypeID((new Integer((String) item_status_types.get("inactive"))).intValue());
					//Diagnostics.debug2("item status='inactive'");
				}
				else
				{//item is not discontinued so make available
					an_item.setItemStatusTypeID((new Integer((String) item_status_types.get("active"))).intValue());
					//Diagnostics.debug2("item status='active'");
				}

				if (StringUtil.hasAValue(rs.getString("billable_flag")) && rs.getString("billable_flag").trim().substring(0, 1).equalsIgnoreCase("N"))
					an_item.setBillableFlag("N");
				else
					an_item.setBillableFlag("Y"); //set billable_flag = Yes

				an_item.setExpenseExportCode(rs.getString("expense_export_code"));

				String jobTypeCode = rs.getString("job_type_attr1");
				if (StringUtil.hasAValue(jobTypeCode))
				{
					String jobTypeId = (String)job_types_by_attr1.get(jobTypeCode.trim());
					if (StringUtil.hasAValue(jobTypeId))
					{
						an_item.setJobTypeID(Integer.parseInt(jobTypeId));
						Diagnostics.debug("Matched Job Type code="+jobTypeCode);
					}
					else
					{
						Diagnostics.debug("Could not match Job Type code="+jobTypeCode);
					}
				}

				String columnPosition = rs.getString("column_position");
				if (columnPosition != null) columnPosition = columnPosition.trim();
				an_item.setColumnPosition(translateColumnPosition(columnPosition));
				//Diagnostics.debug2(an_item.toString());

				items.add(an_item);
			}
		}
		rs.close();

		Iterator commit_items = items.iterator();
		Item commit_item = null;
		while (commit_items.hasNext())
		{
			commit_item = (Item) commit_items.next();
			//Diagnostics.debug2("commiting item='"+
			// commit_item.getName()+"'");
			commit_item.commit(ims_conn);
			//Diagnostics.debug2("successfully commited item='"+
			// commit_item.getName()+"'");
		}

		return bRet;
	}

	public String translateColumnPosition(String gpValue)
	{
		String result = null;
		if (GP_COLUMN_POSITION_MATERIAL.equals(gpValue))
			result = COLUMN_POSITION_MATERIAL;
		else if (GP_COLUMN_POSITION_SUBCONTRACTOR.equals(gpValue))
			result = COLUMN_POSITION_SUBCONTRACTOR;
		else
			result = null;
		return result;
	}
	

	/**
	 * @param ims_conn
	 * @param string
	 * @param string2
	 * @param string3
	 * @return
	 * @throws SQLException
	 */
	private Map<String, String> getAltMap(ConnectionWrapper conn, String table, String column, String type) throws SQLException
	{
		StringBuffer query = new StringBuffer();
		query.append("SELECT ").append(column).append(", lookup_id FROM ").append(table);
		query.append(" WHERE type_code = " + conn.toSQLString(type));

		Map<String, String> result = new HashMap<String, String>();
		QueryResults rs = null;
		try
		{
			rs = conn.resultsQueryEx(query);
			while (rs.next())
			{
				result.put(rs.getString(1), rs.getString(2));
			}
		}
		finally
		{
			if (rs != null)
				rs.close();
		}
		return result;
	}

	/**
	 * Load default item pricing from Great Plains (gp) First retrieve all ims
	 * items, compare against gp items if gp item is not in ims, add to ims.
	 */

	public boolean loadCustomerRates(ConnectionWrapper ims_conn, ConnectionWrapper gp_conn, InvocationContext ic, boolean overwriteExistingRate,
			boolean show_msg) throws Exception
	{
		Diagnostics.trace("ItemHandler.loadCustomerRates()");
		boolean bRet = false;

		String user_id = (String) ic.getSessionDatum("user_id");
		String ext_price_level_id = (String) ic.getParameter("ext_price_level_id");
		String job_id = (String) ic.getParameter("job_id");
		String org_id = (String) ic.getSessionDatum("org_id");

		if (job_id == null) //if new job, id will be a parameter, else manually
							// running
			job_id = (String) ic.getSessionDatum("job_id");
		else
			//creating job so set session id for future use like by item rates
			// form
			ic.setSessionDatum("job_id", job_id);

		String error_title = "Failed to load Job Item Rates from Great Plains";

		if (user_id == null)
		{
			if (show_msg)
				SmartFormHandler.addSmartFormError(ic, error_title + "\nException in ItemHandler, could not get user_id from session data.\n"
						+ "Variable user_id is used for created_by column of job_item_rates table for new job item rates.");
			Diagnostics.error("ItemHandler.loadCustomerRates() missing user_id, failed to loadCustomerRates.");
		}
		else if (job_id == null)
		{
			if (show_msg)
				SmartFormHandler.addSmartFormError(ic, error_title + "\nException in ItemHandler, could not get job_id from parameter data.\n"
						+ "Variable job_id is used for job_id column of items table for new rates.");
			Diagnostics.error("ItemHandler.loadCustomerRates() missing job_id, failed to loadCustomerRates.");
		}
		else if (ext_price_level_id == null)
		{
			if (show_msg)
				SmartFormHandler.addSmartFormError(ic, error_title
						+ "\nException in ItemHandler, could not get Great Plains price level id from parameter data.\n"
						+ "Variable ext_price_level_id is used to lookup price level for item rates in Great Plains.");
			Diagnostics.error("ItemHandler.loadCustomerRates() missing ext_price_level_id, failed to loadCustomerRates.");
		}
		else
		{
			//determine list of existing job item rates so we don't reload them
			Map uom_types = MapUtil.getTypeMap(ims_conn, "uom_type");
			StringBuffer query = new StringBuffer();

			query.append("SELECT i.ext_item_id, j.job_item_rate_id FROM items i, job_item_rates j ");
			query.append("WHERE i.item_id = j.item_id and j.job_id=" + job_id);
			Diagnostics.debug3("Load IMS Job Item Rates Query = " + query.toString());

			QueryResults rs = null;
			Map<String, String> ims_rates = new HashMap<String, String>();
			try
			{
				rs = ims_conn.resultsQueryEx(query);
				while (rs.next())
				{
					//Diagnostics.debug2("existing rate name='"+
					// rs.getString("ext_item_id").toLowerCase()+"'
					// id='"+rs.getString("job_item_rate_id")+"'");
					ims_rates.put(rs.getString("ext_item_id").toLowerCase().trim(), rs.getString("job_item_rate_id"));
				}
			}
			finally
			{
				if (rs != null)
					rs.close();
			}


			//load existing items from ims to add foreign key item_id to new
			// job item rates
			query = new StringBuffer();
			query.append("SELECT i.ext_item_id, i.item_id FROM items i WHERE organization_id=" + ims_conn.toSQLString(org_id));
			Diagnostics.debug3("Load IMS Item Query = " + query.toString());

			Map<String, String> ims_items = new HashMap<String, String>();
			try
			{
				rs = ims_conn.resultsQueryEx(query);
				while (rs.next())
				{
					//Diagnostics.debug2("existing item name='"+
					// rs.getString("ext_item_id").toLowerCase()+"' and
					// id='"+rs.getString("item_id")+"'");
					ims_items.put(rs.getString("ext_item_id").toLowerCase().trim(), rs.getString("item_id"));
				}
			}
			finally
			{
				if (rs != null)
					rs.close();
			}

			//load gp items for this customer
			query = new StringBuffer();
			query.append("SELECT im.itemnmbr, im.pricegroup, im.pricmthd, ");
			query.append("im.currcost, pl.uofm, pl.uomprice, getDate() date_created ");
			query.append("FROM IV00101 im, IV00108 pl ");
			query.append("WHERE im.itemnmbr = pl.itemnmbr and im.itemtype != 2 and im.itmshnam IS NOT NULL and im.itmshnam <> '' and pl.prclevel = "
					+ gp_conn.toSQLString(ext_price_level_id));
			query.append(" ORDER BY im.itemnmbr");

			Diagnostics.debug3("Load GP Rates Query = " + query.toString());

			String gp_item_name = null;
			int item_id = -1;
			JobItemRate job_item_rate = null; //job item rate to add to ims
			List<JobItemRate> job_rates = new ArrayList<JobItemRate>();
			String price_group = null;
			String price_method = null;
			Map<String, String> loaded_items = new HashMap<String, String>();
			try
			{
				rs = gp_conn.resultsQueryEx(query);
				while (rs.next())
				{
					job_item_rate = null; //set job item rate to null
					gp_item_name = rs.getString("itemnmbr").toLowerCase().trim();
					//if job rate already exists don't recreate.
					//Diagnostics.debug2("if statement: gp name='"+ gp_item_name
					// +"' ims rate exist="+(ims_rates.containsKey( gp_item_name ))
					// +" ims item exists="+ims_items.containsKey( gp_item_name ) );
	
					if (loaded_items.containsKey(gp_item_name))
					{//already loaded this item, don't load, notify user
						if (show_msg)
						{
							SmartFormHandler.addSmartFormError(ic, "Warning: Price level '" + ext_price_level_id + "' has duplicate item: '" + gp_item_name
									+ "', loaded first one only.");
						}
					}
					else if (!(ims_rates.containsKey(gp_item_name)) && ims_items.containsKey(gp_item_name))
					{
						//not currently an job_item_rate for this job, so create
						//Diagnostics.debug2("gp name='"+
						// rs.getString(1).toLowerCase().trim()+"'");
						job_item_rate = new JobItemRate();
						job_item_rate.setJobID((new Integer(job_id)).intValue());
						//Diagnostics.debug2("existing item id='"+
						// ((String)ims_items.get( gp_item_name ))+"'");
						item_id = (new Integer((String) ims_items.get(gp_item_name))).intValue();
						job_item_rate.setItemID(item_id); //ims item id
						job_item_rate.setExtRateID(rs.getString("itemnmbr"));
	
						price_group = rs.getString("pricegroup");
						//Diagnostics.debug2("price group='"+ price_group +"'");
						if (price_group != null)
						{
							if (price_group.trim().equalsIgnoreCase("hourly")) //pricegroup
								job_item_rate.setUomTypeID((new Integer((String) uom_types.get("hour"))).intValue());
							else if (price_group.trim().equalsIgnoreCase("expense")) //pricegroup
								job_item_rate.setUomTypeID((new Integer((String) uom_types.get("expense"))).intValue());
						}
						job_item_rate.setExtUomName(rs.getString("uofm"));
						job_item_rate.setDateCreated(rs.getDate("date_created"));
						job_item_rate.setCreatedBy((new Integer(user_id)).intValue());
					}
					else if (ims_rates.containsKey(gp_item_name))
					{//retrieve existing job_item_rate
						//Diagnostics.error("existing ims
						// job_item_rate_id='"+(String)ims_rates.get( gp_item_name
						// )+"'");
						job_item_rate = JobItemRate.fetch((String) ims_rates.get(gp_item_name), ic);
						job_item_rate.setDateModified(rs.getDate("date_created"));
						job_item_rate.setModifiedBy((new Integer(user_id)).intValue());
	
					}
	
					//for new or existing, update the rate...
					if (job_item_rate != null)
					{//update the rate
	
						price_method = rs.getString("pricmthd");
						//Diagnostics.debug2("price method code ='"+ price_method
						// +"'");
						if (price_method != null)
						{
							if (price_method.trim().equalsIgnoreCase("3")) //great
																		   // plains
																		   // pricing
																		   // method
																		   // of
																		   // "%Markup
																		   // -
																		   // Current
																		   // Cost"
								job_item_rate.setRate(rs.getDouble("uomprice") + (rs.getDouble("currcost") * (rs.getDouble("uomprice") / 100)));
							else
								//assuming great plains pricing method of "Currency
								// Amount", pricmthd=1
								job_item_rate.setRate((new Double(rs.getString("uomprice"))).doubleValue());
						}
						job_rates.add(job_item_rate);
					}
	
					//this is to handle when there are multiple pricelevel entries
					// for the same item (happens more then you would believe).
					loaded_items.put(gp_item_name, "");
	
					bRet = true;
				}
			}
			finally
			{
				if (rs != null)
					rs.close();
			}
			//need to commit job first before loading job item rates because of
			// foreign key constraint to jobs
			//AbstractDataObject needs to commit with parameter of
			// connectionwrapper so I could pass this connection wrapper in
			//and not have it bomb. I should not have commit job here, I should
			// let smartform do it.
			ims_conn.commit();
			Diagnostics.debug2("committed new job_id='" + job_id + "'");

			Iterator commit_job_rates = job_rates.iterator();
			JobItemRate commit_job_rate = null;
			while (commit_job_rates.hasNext())
			{
				commit_job_rate = (JobItemRate) commit_job_rates.next();
				//Diagnostics.debug2("commiting job rate='"+
				// commit_job_rate.getExtRateID()+"'");
				commit_job_rate.commit(ic);
				//Diagnostics.debug2("successfully committed job rate='"+
				// commit_job_rate.getExtRateID()+"'");
			}

		}
		if (bRet && show_msg)
			SmartFormHandler.addSmartFormError(ic, "Successfully loaded Price Level '" + ext_price_level_id + "'.");

		return bRet;
	}


}