package ims.dataobjects;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class Dtpropertie extends AbstractDatabaseObject
{

	private int id;
	private int objectid;
	private String property;
	private String value;
	private String lvalue;
	private int version;
	private String uvalue;

	public Dtpropertie()
	{
		super();
	}


	public static Dtpropertie fetch(String id, String property, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(id), property, ic, null);
	}

	public static Dtpropertie fetch(String id, String property, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(id), property, ic, resourceName);
	}

	public static Dtpropertie fetch(int id, String property, InvocationContext ic)
	{
		 return fetch(id, property, ic, null);
	}

	public static Dtpropertie fetch(int id, String property, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("Dtpropertie.fetch()");

		Dtpropertie result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT id ");
			query.append(", objectid ");
			query.append(", property ");
			query.append(", value ");
			query.append(", lvalue ");
			query.append(", version ");
			query.append(", uvalue ");
			query.append("FROM dtproperties ");
			query.append("WHERE (id = ").append(id).append(" AND property = ").append(property).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new Dtpropertie();
				result.setID(rs.getInt(1));
				result.setObjectid(rs.getInt(2));
				result.setProperty(rs.getString(3));
				result.setValue(rs.getString(4));
				result.setLvalue(rs.getString(5));
				result.setVersion(rs.getInt(6));
				result.setUvalue(rs.getString(7));
			}
			else
			{
				Diagnostics.error("Error in Dtpropertie.fetch(), Could not find Dtpropertie; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Dtpropertie.fetch()");
		}
		finally
		{
			if (conn != null)
			{
				conn.release();
			}
		}

		 if (result != null) result.handleAction(FETCH_ACTION);
		return result;
	}

	protected void internalUpdate(InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("Dtpropertie.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE dtproperties ");
			update.append("SET objectid = ").append(this.getObjectid());
			update.append(", value = ").append(conn.toSQLString(StringUtil.truncate(this.getValue(), 255)));
			update.append(", lvalue = ").append(conn.toSQLString(StringUtil.truncate(this.getLvalue(), 2147483647)));
			update.append(", version = ").append(this.getVersion());
			update.append(", uvalue = ").append(conn.toSQLString(StringUtil.truncate(this.getUvalue(), 255)));
			update.append("WHERE (id = ").append(this.getID()).append(" AND property = ").append(this.getProperty()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Dtpropertie.internalUpdate()");
		}
		finally
		{
			if (conn != null)
			{
				conn.release();
			}
		}
	}

	protected void internalInsert(InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("Dtpropertie.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO dtproperties (");
				insert.append("objectid");
				insert.append(", value");
				insert.append(", lvalue");
				insert.append(", version");
				insert.append(", uvalue");
				insert.append(") VALUES (");
				insert.append(this.getObjectid());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getValue(), 255)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getLvalue(), 2147483647)));
				insert.append(", ").append(this.getVersion());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getUvalue(), 255)));
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO dtproperties (");
				insert.append("id");
				insert.append(", objectid");
				insert.append(", property");
				insert.append(", value");
				insert.append(", lvalue");
				insert.append(", version");
				insert.append(", uvalue");
				insert.append(") VALUES (");
				insert.append(this.getID());
				insert.append(", ").append(this.getObjectid());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getProperty(), 64)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getValue(), 255)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getLvalue(), 2147483647)));
				insert.append(", ").append(this.getVersion());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getUvalue(), 255)));
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Dtpropertie.internalInsert()");
		}
		finally
		{
			if (conn != null)
			{
				conn.release();
			}
		}
	}

	protected void internalDelete(InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("Dtpropertie.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM dtproperties ");
			delete.append("WHERE (id = ").append(this.getID()).append(" AND property = ").append(this.getProperty()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Dtpropertie.internalDelete()");
		}
		finally
		{
			if (conn != null)
			{
				conn.release();
			}
		}
	}

	private boolean skipPrimaryKey()
	{
		boolean skipPrimaryKey = false;
		if (this.getID() <= 0)
		{
			skipPrimaryKey = true;
		}
		else if (this.getProperty() == null || this.getProperty().equals(AbstractDatabaseObject.USE_IDENTITY))
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("Dtpropertie:\n");
		result.append("  id = ").append(this.getID()).append("\n");
		result.append("  objectid = ").append(this.getObjectid()).append("\n");
		result.append("  property = ").append(this.getProperty()).append("\n");
		result.append("  value = ").append(this.getValue()).append("\n");
		result.append("  lvalue = ").append(this.getLvalue()).append("\n");
		result.append("  version = ").append(this.getVersion()).append("\n");
		result.append("  uvalue = ").append(this.getUvalue()).append("\n");
		return result.toString();
	}


	public int getID()
	{
		return id;
	}

	public int getObjectid()
	{
		return objectid;
	}

	public String getProperty()
	{
		return property;
	}

	public String getValue()
	{
		return value;
	}

	public String getLvalue()
	{
		return lvalue;
	}

	public int getVersion()
	{
		return version;
	}

	public String getUvalue()
	{
		return uvalue;
	}

	public void setID(int idIn)
	{
		id = idIn;
		handleAction(MODIFY_ACTION);
	}

	public void setObjectid(int objectidIn)
	{
		objectid = objectidIn;
		handleAction(MODIFY_ACTION);
	}

	public void setProperty(String propertyIn)
	{
		property = propertyIn;
		handleAction(MODIFY_ACTION);
	}

	public void setValue(String valueIn)
	{
		value = valueIn;
		handleAction(MODIFY_ACTION);
	}

	public void setLvalue(String lvalueIn)
	{
		lvalue = lvalueIn;
		handleAction(MODIFY_ACTION);
	}

	public void setVersion(int versionIn)
	{
		version = versionIn;
		handleAction(MODIFY_ACTION);
	}

	public void setUvalue(String uvalueIn)
	{
		uvalue = uvalueIn;
		handleAction(MODIFY_ACTION);
	}
}
