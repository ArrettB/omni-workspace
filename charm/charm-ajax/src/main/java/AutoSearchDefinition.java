
public class AutoSearchDefinition
{
	private String displayPropertyName;
	private String queryName;
	
	public String getDisplayPropertyName()
	{
		return displayPropertyName;
	}

	public void setDisplayPropertyName(String displayPropertyName)
	{
		this.displayPropertyName = displayPropertyName;
	}

	public String getQueryName()
	{
		return queryName;
	}

	public void setQueryName(String queryName)
	{
		this.queryName = queryName;
	}
	
	public String generateUniqueId()
	{
		return "" + hashCode();
	}


}
