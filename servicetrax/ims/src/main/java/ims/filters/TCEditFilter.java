package ims.filters;

import dynamic.dbtk.parser.Sql;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.filter.QueryFilter;
import dynamic.util.string.StringUtil;

/**
 * Modify the report queries with the values selected by the user.
 * 
 * Filter by r_job_id, or by either the r_user_id or r_employee_name (which are
 * both confusingly user_id, and are really mutually exclusive.)
 * 
 * The expected behavior if both r_user_id and r_employee_name are chosen with different values
 * is to return nothing.
 * 
 * @version $Id: TCEditFilter.java 1133 2008-03-17 14:42:52Z bvonhaden $
 */
public class TCEditFilter extends QueryFilter
{

	public TCEditFilter()
	{}

	public Sql process(InvocationContext ic, Sql query, String params)
	{
		if (params == null)
		{
			return query;
		}
		else
		{
			String[] columns = StringUtil.stringToArray(params, ',');

			String billServiceId = (String)ic.getSessionDatum("service_id");
			if (StringUtil.hasAValue(billServiceId))
			{
				String clause = columns[0] + " = " + StringUtil.toPStmtInt(billServiceId);
				query.addWhereAndClause(clause);
			}
			
			String billJobId = (String)ic.getSessionDatum("job_id");
			if (StringUtil.hasAValue(billJobId))
			{
				String clause = columns[1] + " = " + StringUtil.toPStmtInt(billJobId);
				query.addWhereAndClause(clause);
			}
			
			String itemTypeCode = (String)ic.getSessionDatum("item_type_code");
			if (StringUtil.hasAValue(itemTypeCode))
			{
				String clause = columns[2] + " = " + StringUtil.toPStmtString(itemTypeCode);
				query.addWhereAndClause(clause);
			}
			
			
			return query;
		}
	}
}
