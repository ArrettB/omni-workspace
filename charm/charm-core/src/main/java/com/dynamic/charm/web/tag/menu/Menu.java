package com.dynamic.charm.web.tag.menu;

public class Menu implements Cloneable
{
	private String menuCode;
	private String title;
	private String href;
	private MenuItem[] menuItems;
	
	public Menu(String menuCode)
	{
		this(menuCode, null, null);
	}
	
	public Menu(String menuCode, String title)
	{
		this(menuCode, title, null);
	}
	
	public Menu(String menuCode, String title, String href)
	{
		this(menuCode, title, href, null);
	}
	
	public Menu(String menuCode, String title, String href, MenuItem[] menuItems)
	{
		this.menuCode = menuCode;
		this.title = title;
		this.href = href;
		this.menuItems = menuItems;
	}
	
	/**
	 * A Copy Constructor, used by DefaultMenuService, which returns 
	 * copies so that that cached version remains unmodified.
	 * 
	 */
	public Menu(Menu copyMe)
	{
		this(copyMe.getMenuCode(), copyMe.getTitle(), copyMe.getHref(), copyMe.getMenuItems());
	}
	
	public String getHref()
	{
		return href;
	}
	public void setHref(String href)
	{
		this.href = href;
	}
	public String getMenuCode()
	{
		return menuCode;
	}
	public void setMenuCode(String menuCode)
	{
		this.menuCode = menuCode;
	}
	public MenuItem[] getMenuItems()
	{
		return menuItems;
	}
	public void setMenuItems(MenuItem[] menuItems)
	{
		this.menuItems = menuItems;
	}
	public String getTitle()
	{
		return title;
	}
	public void setTitle(String title)
	{
		this.title = title;
	}
	
	public String toString()
	{
		return "[Menu] - " + menuCode + " - " + title;
	}
}
