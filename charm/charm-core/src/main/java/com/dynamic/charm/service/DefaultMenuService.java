/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: DefaultMenuService.java 199 2006-11-14 23:38:41Z gcase $

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


package com.dynamic.charm.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.BeanWrapperImpl;
import org.springframework.beans.factory.InitializingBean;

import com.dynamic.charm.web.CharmWebObjectSupport;
import com.dynamic.charm.web.tag.menu.Menu;
import com.dynamic.charm.web.tag.menu.MenuItem;


public class DefaultMenuService extends CharmWebObjectSupport implements MenuService, InitializingBean
{
    private QueryService queryService;
    private String itemQueryId = "menuService.menuItems";
    private String displayQueryId = "menuService.display";
    private String hrefQueryId = "menuService.href";
    private boolean enableCaching = true;
    private Map _cache;
    
    public void registerRequiredProperties()
    {
        registerRequiredProperty("queryService");
        registerRequiredProperty("displayQueryId");
        registerRequiredProperty("hrefQueryId");
     }
    
	  public void afterPropertiesSetInternal()
		{
			if (enableCaching)
			{
				_cache = new HashMap();
			}
		}
    
    public Menu getMenu(String menuCode, HttpServletRequest request)
	{
    	Menu menu = null;
		if (enableCaching)
		{
			synchronized (_cache)
			{
				menu = (Menu) _cache.get(menuCode);
				if (menu == null)
				{
					menu = loadMenuFromDatabase(menuCode, request);
					_cache.put(menuCode, menu);
				}
				// return a copy of the cached menu, so that any changes to this do not modify our original
				menu = new Menu(menu);
			}
		}
		else
		{
			menu = loadMenuFromDatabase(menuCode, request);
		}
			
		applySecurity(menu, request);
		return menu;
	}
    
    public void clearCache()
    {
    	if (enableCaching)
    	{
    		synchronized (_cache)
    		{
    			_cache.clear();
    		}
    	}
    }
    
    protected Menu loadMenuFromDatabase(String menuCode, HttpServletRequest request)
    {
    	Menu result = new Menu(menuCode);
    	result.setTitle(loadMenuTitle(menuCode, request));
    	result.setHref(loadMenuTitleHref(menuCode, request));
    	result.setMenuItems(loadMenuItems(menuCode, request));
    	return result;
    }
    
    
    /**
     * This method is provded so that custom implementations may override
     * @param items
     * @param request
     * @return
     */
    public void applySecurity(Menu menu, HttpServletRequest request)
    {
    }

    public QueryService getQueryService()
    {
        return queryService;
    }

    public void setQueryService(QueryService queryService)
    {
        this.queryService = queryService;
    }

    protected MenuItem[] loadMenuItems(String menuCode, HttpServletRequest request)
    {
        List queryResults = queryService.namedQueryForList(itemQueryId, menuCode);
        MenuItem[] result = new MenuItem[queryResults.size()];
        for (int i = 0, n = queryResults.size(); i < n; i++)
        {
            Object row = queryResults.get(i);
            if (row instanceof MenuItem)
            {
                result[i] = (MenuItem) row;
            }
            else if (row instanceof Map)
            {
                MenuItem item = new MenuItem();
                BeanWrapperImpl bw = new BeanWrapperImpl(item);
                bw.setPropertyValues((Map) row);
                result[i] = item;
            }
            else if (row instanceof Object[])
            {
                Object[] values = (Object[]) row;
                MenuItem item = new MenuItem();
                if ((values.length > 0) && (values[0] != null))
                {
                    item.setCode(values[0].toString());
                }
                if ((values.length > 1) && (values[1] != null))
                {
                    item.setDisplay(values[1].toString());
                }
                if ((values.length > 2) && (values[2] != null))
                {
                    item.setHref(values[2].toString());
                }
                if ((values.length > 3) && (values[3] != null))
                {
                    item.setDisplayOrder(Integer.parseInt(values[3].toString()));
                }
                if ((values.length > 4) && (values[4] != null))
                {
                    item.setTarget(values[4].toString());
                }
                result[i] = item;
            }
        }
        return result;
    } 
    
    protected String loadMenuTitle(String menuCode, HttpServletRequest request)
    {
        Object result = queryService.namedQueryForObject(displayQueryId, menuCode);
        if(result != null)
        {
        	return result.toString();
        }
        else
        {
        	return null;
        }
    }
    
    protected String loadMenuTitleHref(String menuCode, HttpServletRequest request)
    {
        Object result = queryService.namedQueryForObject(hrefQueryId, menuCode);
        if(result != null)
        {
        	return result.toString();
        }
        else
        {
        	return null;
        }
    }

	public String getDisplayQueryId()
	{
		return displayQueryId;
	}

	public void setDisplayQueryId(String displayQueryId)
	{
		this.displayQueryId = displayQueryId;
	}

	public boolean isEnableCaching()
	{
		return enableCaching;
	}

	public void setEnableCaching(boolean enableCaching)
	{
		this.enableCaching = enableCaching;
	}

	public String getHrefQueryId()
	{
		return hrefQueryId;
	}

	public void setHrefQueryId(String hrefQueryId)
	{
		this.hrefQueryId = hrefQueryId;
	}

	public String getItemQueryId()
	{
		return itemQueryId;
	}

	public void setItemQueryId(String itemQueryId)
	{
		this.itemQueryId = itemQueryId;
	}


	

}
