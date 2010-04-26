package ims.handlers.maintenance;

import ims.dataobjects.ResourceItem;
import ims.dataobjects.ResourceTypeItem;

import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.intraframe.templates.components.SmartFormComponent;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * @version $Id: ResourcePostHandler.java 1100 2008-03-06 17:36:02Z dzhao $
 */
public class ResourcePostHandler extends BaseHandler
{
	public void setUpHandler()
	{
		Diagnostics.debug2("ResourcePostHandler.setUpHandler()");
	}

	public void destroy()
	{
		Diagnostics.debug2("ResourcePostHandler.destroy()");
	}

  	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		Diagnostics.debug2("ResourcePostHandler.handleEnvironment()");
		boolean result = true;

		/*
		Note:
		Because this is PostHandler with SmartFormHandler, we do NOT
		catch the exception or release the resource ourselves
		*/

		String res_action = ic.getParameter("res_action");
		String button = ic.getParameter(SmartFormComponent.BUTTON);
		String mode = ic.getParameter("mode");
		String loadResTypeItems = ic.getParameter("loadResTypeItems"); //button on mnt/resource_items
	
		Diagnostics.error("res_action = '"+res_action+"', button='"+button+"', mode='"+mode+"', loadResTypeItems button='"+loadResTypeItems+"'");		

		if (res_action != null && res_action.equalsIgnoreCase("loadResTypeItems") &&
			 loadResTypeItems != null && loadResTypeItems.equals("Load Resource Type Items") )
		{//case clicked on "load resource type items" button on mnt/resource_items page
			loadResourceItems(ic);
		}
		else if( res_action != null && res_action.equalsIgnoreCase("loadResItems") &&
					button != null && button.equals(SmartFormComponent.Save) &&
					mode != null && mode.equalsIgnoreCase("Insert") )
		{//case clicked save on new resource on mnt/resource page
			loadResourceItems(ic);
		}


		return result;
	}
		

  /**
	* Load default item pricing from Great Plains (gp)
	* First retrieve all ims items, compare against gp items
	* if gp item is not in ims, add to ims.
	*/
	public boolean loadResourceItems(InvocationContext ic)
	throws Exception
	{
		Diagnostics.trace("ResourcePostHandler.loadResourceItems()");
		boolean bRet = true;
		try
		{
			ConnectionWrapper conn = (ConnectionWrapper)ic.getTransientDatum(SmartFormHandler.CONNECTION);
			String resource_id = (String)ic.getTransientDatum("resource_id");
			if( !StringUtil.hasAValue(resource_id) )
				resource_id = ic.getRequiredParameter("resource_id");
			String user_id = (String)ic.getRequiredSessionDatum("user_id");
			String resource_type_id = ic.getParameter("resource_type_id");
			String org_id = (String)ic.getSessionDatum("org_id");
			boolean has_a_default_item = false;

			//determine resource_type if not known
			if( !StringUtil.hasAValue(resource_type_id) )
			{
				StringBuffer query = new StringBuffer();
				query.append("SELECT resource_type_id FROM resources WHERE resource_id = "+conn.toSQLString(resource_id));
				QueryResults rs = conn.resultsQueryEx(query);

				if( rs.next() )
				{
					Diagnostics.debug2("Loading Resource Type, resource_type_id ='"+ rs.getString(1).toLowerCase()+"'");
					resource_type_id = rs.getString(1);		
				}
				else
				{
					Diagnostics.error("Failed to retrieve resource_type_id from resources.  Cannot complete load of resource items from resource type itesm.");
				}
			}
						
			//load ims items into hashtable
			StringBuffer query = new StringBuffer();
			query.append("SELECT item_id, default_item_flag, getDate() FROM resource_type_items_v WHERE resource_type_id=" + conn.toSQLString(resource_type_id) + " AND organization_id = " + conn.toSQLString(org_id)+" ORDER BY item_id" );

			Diagnostics.debug3("Load IMS Resource Type Items Query = "+query.toString() );

			QueryResults rs = conn.resultsQueryEx(query);
			Vector<ResourceTypeItem> ims_res_type_items = new Vector<ResourceTypeItem>();

			ResourceTypeItem an_res_type_item = null;
			while( rs.next() )
			{
				Diagnostics.debug2("Loading Resource Type Item, item_id ='"+ rs.getString(1).toLowerCase()+"'");
				an_res_type_item = new ResourceTypeItem();
				an_res_type_item.setItemID( rs.getInt(1) );
				an_res_type_item.setDefaultItemFlag( rs.getString(2) );
				an_res_type_item.setCreatedBy( new Integer(user_id).intValue() );
				an_res_type_item.setDateCreated( rs.getDate(3) );
				ims_res_type_items.add( an_res_type_item );
			}
			rs.close();

			//determine existing resource_items...			
			query = new StringBuffer();
			query.append("SELECT item_id, default_item_flag FROM resource_items_v WHERE resource_id=" + conn.toSQLString(resource_id) + " AND organization_id=" + conn.toSQLString(org_id) + " ORDER BY item_id" );

			Diagnostics.debug3("Load Resource Items Query = "+query.toString() );

			rs = conn.resultsQueryEx(query);
			Hashtable<String,String> ims_res_items = new Hashtable<String,String>();

			while( rs.next() )
			{
				Diagnostics.debug2("ims resource_item, item_id ='"+ rs.getString(1).toLowerCase()+"'");
				ims_res_items.put( rs.getString(1).toLowerCase().trim(), ""); //trim not really needed, just in case
				if( rs.getString(2) != null && rs.getString(2).equalsIgnoreCase("Y") )
					has_a_default_item = true;
			}
			rs.close();

			Vector<ResourceItem> res_items = new Vector<ResourceItem>(); //to hold the group to commit;
			ResourceItem res_item = null; //res_type_item to add to ims
			an_res_type_item = null; //reuse
			Enumeration res_type_items = ims_res_type_items.elements();

			while( res_type_items.hasMoreElements() )
			{
				res_item = null;
				an_res_type_item = (ResourceTypeItem)res_type_items.nextElement();
				if( an_res_type_item != null && !ims_res_items.containsKey( new Integer(an_res_type_item.getItemID()).toString() ) )
				{//then add new resource item
					res_item = new ResourceItem();
					res_item.setResourceID( new Integer(resource_id).intValue() );
					res_item.setItemID( an_res_type_item.getItemID() );
					if( has_a_default_item )
						res_item.setDefaultItemFlag("N");
					else
						res_item.setDefaultItemFlag(an_res_type_item.getDefaultItemFlag());
					res_item.setCreatedBy( an_res_type_item.getCreatedBy() );
					res_item.setDateCreated( an_res_type_item.getDateCreated() );
					res_items.add( res_item );
				}
			}
			rs.close();

			Enumeration commit_res_items = res_items.elements();
			ResourceItem commit_res_item = null;
			while( commit_res_items.hasMoreElements() )
			{
				commit_res_item = (ResourceItem)commit_res_items.nextElement();
				Diagnostics.debug2("commiting resource_item with item_id='"+ commit_res_item.getItemID()+"'");
				commit_res_item.commit(ic);
				Diagnostics.debug2("successfully commited resource_item with item_id='"+ commit_res_item.getItemID()+"'");
			}
		}
		catch (Exception e)
		{
			bRet = false;
			Diagnostics.error("Error in ResourcePostHandler while loading Resource Items."+e.toString());
		}
		return bRet;
	}
			
}