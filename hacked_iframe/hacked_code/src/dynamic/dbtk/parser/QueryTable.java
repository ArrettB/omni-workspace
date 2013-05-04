package dynamic.dbtk.parser;


/**
 * The information about a table in the FROM clause of a query statement.
 *
 * $Header: QueryTable.java, 2, 12/13/2001 3:45:49 PM, Blake Von Haden$
 */
public class QueryTable
{

	private String name;
	private String alias;
	/**
	 * True if this is part of the original query.
	 */
	private boolean original=false;

	public QueryTable(String name)
	{
		this(name, null);
	}

	/**
	 * @param name the name of the table
	 * @param alias the alias for the table
	 */
	public QueryTable(String name, String alias)
	{
		this.name = name;
		this.alias = alias;
	}

	public void setAlias(String alias)
	{
		this.alias = alias;
	}

	/**
	 * @return the name of the table
	 */
	public String getName()
	{
		return name;
	}

	/**
	 * @return the alias for the table
	 */
	public String getAlias()
	{
		return alias;
	}

	/**
	 * Used internally to the SQL parser to determine that this table
	 * was part of the original query.
	 */
	void setOriginal()
	{
		this.original=true;
	}

	/**
	 * Used to differentiate between original tables and tables added later.
	 *
	 * @return true if this table is part of the original query.
	 */
	public boolean isOriginal()
	{
		return original;
	}

	/**
	 * @return properly formatted table name and alias for the FROM clause.
	 */
	public String toString()
	{
		return alias == null ? name : name + " " + alias;
	}

}
