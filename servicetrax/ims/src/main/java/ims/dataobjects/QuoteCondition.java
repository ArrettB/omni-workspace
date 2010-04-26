package ims.dataobjects;

import java.util.Date;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class QuoteCondition extends AbstractDatabaseObject
{

	private int quoteConditionID;
	private int quoteID;
	private int conditionID;
	private String useFlag;
	private Date dateCreated;
	private int createdBy;
	private Date dateModified;
	private int modifiedBy;

	public QuoteCondition()
	{
		super();
	}


	public static QuoteCondition fetch(String quoteConditionID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(quoteConditionID), ic, null);
	}

	public static QuoteCondition fetch(String quoteConditionID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(quoteConditionID), ic, resourceName);
	}

	public static QuoteCondition fetch(int quoteConditionID, InvocationContext ic)
	{
		 return fetch(quoteConditionID, ic, null);
	}

	public static QuoteCondition fetch(int quoteConditionID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("QuoteCondition.fetch()");

		QuoteCondition result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT quote_condition_id ");
			query.append(", quote_id ");
			query.append(", condition_id ");
			query.append(", use_flag ");
			query.append(", date_created ");
			query.append(", created_by ");
			query.append(", date_modified ");
			query.append(", modified_by ");
			query.append("FROM quote_conditions ");
			query.append("WHERE (quote_condition_id = ").append(quoteConditionID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new QuoteCondition();
				result.setQuoteConditionID(rs.getInt(1));
				result.setQuoteID(rs.getInt(2));
				result.setConditionID(rs.getInt(3));
				result.setUseFlag(rs.getString(4));
				result.setDateCreated(rs.getDate(5));
				result.setCreatedBy(rs.getInt(6));
				result.setDateModified(rs.getDate(7));
				result.setModifiedBy(rs.getInt(8));
			}
			else
			{
				Diagnostics.error("Error in QuoteCondition.fetch(), Could not find QuoteCondition; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in QuoteCondition.fetch()");
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
		Diagnostics.trace("QuoteCondition.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE quote_conditions ");
			update.append("SET quote_id = ").append(this.getQuoteID());
			update.append(", condition_id = ").append(this.getConditionID());
			update.append(", use_flag = ").append(conn.toSQLString(StringUtil.truncate(this.getUseFlag(), 1)));
			update.append(", date_created = ").append(conn.toSQLString(this.getDateCreated()));
			update.append(", created_by = ").append(this.getCreatedBy());
			update.append(", date_modified = ").append(conn.toSQLString(this.getDateModified()));
			update.append(", modified_by = ").append(this.getModifiedBy());
			update.append("WHERE (quote_condition_id = ").append(this.getQuoteConditionID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in QuoteCondition.internalUpdate()");
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
		Diagnostics.trace("QuoteCondition.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO quote_conditions (");
				insert.append("quote_id");
				insert.append(", condition_id");
				insert.append(", use_flag");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getQuoteID());
				insert.append(", ").append(this.getConditionID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getUseFlag(), 1)));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO quote_conditions (");
				insert.append("quote_condition_id");
				insert.append(", quote_id");
				insert.append(", condition_id");
				insert.append(", use_flag");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getQuoteConditionID());
				insert.append(", ").append(this.getQuoteID());
				insert.append(", ").append(this.getConditionID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getUseFlag(), 1)));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				quoteConditionID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in QuoteCondition.internalInsert()");
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
		Diagnostics.trace("QuoteCondition.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM quote_conditions ");
			delete.append("WHERE (quote_condition_id = ").append(this.getQuoteConditionID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in QuoteCondition.internalDelete()");
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
		if (this.getQuoteConditionID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("QuoteCondition:\n");
		result.append("  quote_condition_id = ").append(this.getQuoteConditionID()).append("\n");
		result.append("  quote_id = ").append(this.getQuoteID()).append("\n");
		result.append("  condition_id = ").append(this.getConditionID()).append("\n");
		result.append("  use_flag = ").append(this.getUseFlag()).append("\n");
		result.append("  date_created = ").append(this.getDateCreated()).append("\n");
		result.append("  created_by = ").append(this.getCreatedBy()).append("\n");
		result.append("  date_modified = ").append(this.getDateModified()).append("\n");
		result.append("  modified_by = ").append(this.getModifiedBy()).append("\n");
		return result.toString();
	}


	public int getQuoteConditionID()
	{
		return quoteConditionID;
	}

	public int getQuoteID()
	{
		return quoteID;
	}

	public int getConditionID()
	{
		return conditionID;
	}

	public String getUseFlag()
	{
		return useFlag;
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

	public void setQuoteConditionID(int quoteConditionIDIn)
	{
		quoteConditionID = quoteConditionIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setQuoteID(int quoteIDIn)
	{
		quoteID = quoteIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setConditionID(int conditionIDIn)
	{
		conditionID = conditionIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setUseFlag(String useFlagIn)
	{
		useFlag = useFlagIn;
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
