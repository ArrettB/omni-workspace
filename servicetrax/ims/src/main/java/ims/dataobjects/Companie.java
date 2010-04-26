package ims.dataobjects;

import java.util.Date;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class Companie extends AbstractDatabaseObject
{

	private String companyID;
	private String companyName;
	private String extCompanyID;
	private Date dateCreated;
	private int createdBy;
	private Date dateModified;
	private int modifiedBy;

	public Companie()
	{
		super();
	}


	public static Companie fetch(String companyID, InvocationContext ic)
	{
		 return fetch(companyID, ic, null);
	}

	public static Companie fetch(String companyID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("Companie.fetch()");

		Companie result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT company_id ");
			query.append(", company_name ");
			query.append(", ext_company_id ");
			query.append(", date_created ");
			query.append(", created_by ");
			query.append(", date_modified ");
			query.append(", modified_by ");
			query.append("FROM companies ");
			query.append("WHERE (company_id = ").append(companyID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new Companie();
				result.setCompanyID(rs.getString(1));
				result.setCompanyName(rs.getString(2));
				result.setExtCompanyID(rs.getString(3));
				result.setDateCreated(rs.getDate(4));
				result.setCreatedBy(rs.getInt(5));
				result.setDateModified(rs.getDate(6));
				result.setModifiedBy(rs.getInt(7));
			}
			else
			{
				Diagnostics.error("Error in Companie.fetch(), Could not find Companie; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Companie.fetch()");
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
		Diagnostics.trace("Companie.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE companies ");
			update.append("SET company_name = ").append(conn.toSQLString(StringUtil.truncate(this.getCompanyName(), 200)));
			update.append(", ext_company_id = ").append(conn.toSQLString(StringUtil.truncate(this.getExtCompanyID(), 30)));
			update.append(", date_created = ").append(conn.toSQLString(this.getDateCreated()));
			update.append(", created_by = ").append(this.getCreatedBy());
			update.append(", date_modified = ").append(conn.toSQLString(this.getDateModified()));
			update.append(", modified_by = ").append(this.getModifiedBy());
			update.append("WHERE (company_id = ").append(this.getCompanyID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Companie.internalUpdate()");
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
		Diagnostics.trace("Companie.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO companies (");
				insert.append("company_name");
				insert.append(", ext_company_id");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(conn.toSQLString(StringUtil.truncate(this.getCompanyName(), 200)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getExtCompanyID(), 30)));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO companies (");
				insert.append("company_id");
				insert.append(", company_name");
				insert.append(", ext_company_id");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(conn.toSQLString(StringUtil.truncate(this.getCompanyID(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCompanyName(), 200)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getExtCompanyID(), 30)));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				companyID = conn.queryEx("select @@identity");
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Companie.internalInsert()");
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
		Diagnostics.trace("Companie.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM companies ");
			delete.append("WHERE (company_id = ").append(this.getCompanyID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Companie.internalDelete()");
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
		if (this.getCompanyID() == null || this.getCompanyID().equals(AbstractDatabaseObject.USE_IDENTITY))
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("Companie:\n");
		result.append("  company_id = ").append(this.getCompanyID()).append("\n");
		result.append("  company_name = ").append(this.getCompanyName()).append("\n");
		result.append("  ext_company_id = ").append(this.getExtCompanyID()).append("\n");
		result.append("  date_created = ").append(this.getDateCreated()).append("\n");
		result.append("  created_by = ").append(this.getCreatedBy()).append("\n");
		result.append("  date_modified = ").append(this.getDateModified()).append("\n");
		result.append("  modified_by = ").append(this.getModifiedBy()).append("\n");
		return result.toString();
	}


	public String getCompanyID()
	{
		return companyID;
	}

	public String getCompanyName()
	{
		return companyName;
	}

	public String getExtCompanyID()
	{
		return extCompanyID;
	}

	public Date getDateCreated()
	{
		return dateCreated;
	}

	public int getCreatedBy()
	{
		return createdBy;
	}

	public Date getDateModified()
	{
		return dateModified;
	}

	public int getModifiedBy()
	{
		return modifiedBy;
	}

	public void setCompanyID(String companyIDIn)
	{
		companyID = companyIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setCompanyName(String companyNameIn)
	{
		companyName = companyNameIn;
		handleAction(MODIFY_ACTION);
	}

	public void setExtCompanyID(String extCompanyIDIn)
	{
		extCompanyID = extCompanyIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setDateCreated(Date dateCreatedIn)
	{
		dateCreated = dateCreatedIn;
		handleAction(MODIFY_ACTION);
	}

	public void setCreatedBy(int createdByIn)
	{
		createdBy = createdByIn;
		handleAction(MODIFY_ACTION);
	}

	public void setDateModified(Date dateModifiedIn)
	{
		dateModified = dateModifiedIn;
		handleAction(MODIFY_ACTION);
	}

	public void setModifiedBy(int modifiedByIn)
	{
		modifiedBy = modifiedByIn;
		handleAction(MODIFY_ACTION);
	}
}
