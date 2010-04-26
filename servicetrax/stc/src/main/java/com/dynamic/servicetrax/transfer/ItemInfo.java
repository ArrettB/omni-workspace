package com.dynamic.servicetrax.transfer;

public class ItemInfo
{
	private String itemId;
	private String itemName;
		
	
	public ItemInfo(String itemId, String itemName)
	{
		super();
		this.itemId = itemId;
		this.itemName = itemName;
	}
	
	public String getItemId()
	{
		return itemId;
	}
	public void setItemId(String itemId)
	{
		this.itemId = itemId;
	}
	public String getItemName()
	{
		return itemName;
	}
	public void setItemName(String itemName)
	{
		this.itemName = itemName;
	}
}
