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
 * @version $Id: EmployeeHoursReporFilter.java 1110 2008-03-10 16:24:09Z bvonhaden $
 */
public class EmployeeHoursReporFilter extends QueryFilter
{

	public EmployeeHoursReporFilter()
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
			String jobId = ic.getParameter("r_job_id");
			if (StringUtil.hasAValue(jobId))
			{
				query.addWhereAndClause("(" + columns[0] + " = " + StringUtil.toPStmtInt(jobId) + ")");
			}

			String employeeId = ic.getParameter("r_user_id");
			String resourceId = ic.getParameter("r_employee_name");
			if (StringUtil.hasAValue(employeeId) || StringUtil.hasAValue(resourceId))
			{
				StringBuffer clause = new StringBuffer("(");
				
				if (StringUtil.hasAValue(employeeId))
				{
					clause.append(columns[1]).append(" = ").append(StringUtil.toPStmtInt(employeeId));
					if (StringUtil.hasAValue(resourceId))
						clause.append(" AND ").append(columns[1]).append(" = ").append(StringUtil.toPStmtInt(resourceId));
				}
				else
				{
					clause.append(columns[1]).append(" = ").append(StringUtil.toPStmtInt(resourceId));
				}
				clause.append(")");
				
				query.addWhereAndClause(clause.toString());
			}
			return query;
		}
	}
}
