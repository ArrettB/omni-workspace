package ims.handlers.lists;

import java.sql.SQLException;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * 
 * @version $Header: SaveChecklistHandler.java, 6, 1/23/2006 3:43:51 PM, Blake Von Haden$
 */
public class SaveChecklistHandler extends BaseHandler
{
	public static int numberQuestions = 10;
	public static String[] letters = {"A", "B", "C", "D", "E", "F"};

	public void setUpHandler(){}
	public void destroy(){}

	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		ConnectionWrapper conn = null;
		boolean result = true;
		try
		{
			Diagnostics.trace("SaveChecklistHandler.handleEnvironment()");
			ic.setHTMLTemplateName("enet/lists/checklist.html");
			conn = (ConnectionWrapper) ic.getResource();
			conn.setAutoCommit(false);

			String button = ic.getParameter("button");
			if (button.equalsIgnoreCase("Save"))
			{
				result = saveChecklist(ic, conn);
				if( result )
				{
					conn.commit();
					String prevTemplate = ic.getParameter("prev_template");
					Diagnostics.debug("User saved, send them back to " + prevTemplate);
					ic.setHTMLTemplateName(prevTemplate);
				}
				else
				{
					conn.rollback();
					ic.setParameter("redisplay_checklist","true");
					ic.dispatchHandler("ims.handlers.lists.DisplayChecklistHandler");
				}
			}
			else if (button.equalsIgnoreCase("Save and Create Punchlist"))
			{
				result = saveChecklist(ic, conn);
				if( result )
				{
					conn.commit();
					Diagnostics.debug("User saved and is creating punchlist, sending them to punchlist edit");
					ic.setHTMLTemplateName("enet/lists/punchlist.html");
				}
				else
				{
					conn.rollback();
					ic.dispatchHandler("ims.handlers.lists.DisplayChecklistHandler");
					ic.setParameter("redisplay_checklist","true");
				}

			}
			else if (button.equalsIgnoreCase("Cancel"))
			{
				String prevTemplate = ic.getParameter("prev_template");
				Diagnostics.debug("User cancelled, send them back to " + prevTemplate);
				ic.setHTMLTemplateName(prevTemplate);
			}
			else
			{
				Diagnostics.error("Unrecognized button in SaveChecklistHandler, button=" + button);
			}
		}
		catch (Exception e)
		{
			result = false;
			ErrorHandler.handleException(ic, e,  "Exception in SaveChecklistHandler");
			conn.rollback();
		}
		finally
		{
			if (conn != null) 
			{
				try
				{
					conn.setAutoCommit(true);
				}
				catch (SQLException ignore){}
				conn.release();
			}
		}

		return result;
	}


	private boolean saveChecklist(InvocationContext ic, ConnectionWrapper conn) throws Exception
	{
		Diagnostics.trace("SaveChecklistHandler.saveChecklist()");
		boolean result = true;
		String checklistID = ic.getParameter("checklist_id");
		String requestID = ic.getRequiredParameter("request_id");
		String userID = ic.getSessionDatum("user_id").toString();
		String numStations = ic.getRequiredParameter("num_stations");
		try
		{
			if( StringUtil.hasAValue(numStations) )
				new Integer(numStations); //if exception, send error message to user, in catch clause

			if( !StringUtil.hasAValue(checklistID) )
			{
				//create a new checklist
				StringBuffer query = new StringBuffer();
				query.append("INSERT INTO checklists (request_id, num_stations, created_by, date_created)");
				query.append(" VALUES (");
				query.append(conn.toSQLString(requestID));
				query.append(", ").append(conn.toSQLString(numStations));
				query.append(", ").append(userID);
				query.append(", ").append(conn.toSQLString(new java.util.Date()));
				query.append(")");
				conn.updateExactlyEx(query, 1);

				checklistID = conn.queryEx("SELECT SCOPE_IDENTITY()");

			}
			else
			{
				//update existing checklist
				StringBuffer query = new StringBuffer();
				query.append("UPDATE checklists");
				query.append(" SET num_stations = ").append(conn.toSQLString(numStations));
				query.append(", modified_by = ").append(userID);
				query.append(", date_modified = ").append("getDate()");
				query.append(" WHERE checklist_id = " + checklistID);
				conn.updateExactlyEx(query, 1);

				//delete all checklist data
				deleteChecklistData(conn, checklistID);
			}

			String questionNum = null;
			String yesNoAnswer = null;
			String numAnswer = null;
			for (int i = 1; i <= numberQuestions; i++)
			{
				questionNum = Integer.toString(i);
				yesNoAnswer = ic.getParameter(questionNum);
				numAnswer = ic.getParameter(questionNum + "_" + "Num");
				//Diagnostics.debug(questionNum + ":" + yesNoAnswer + "," + numAnswer);
				if (yesNoAnswer != null && yesNoAnswer.length() > 0)
				{
					saveChecklistData(conn, checklistID, questionNum, yesNoAnswer, numAnswer);
				}
				for (int j = 0; j < letters.length; j++)
				{
					questionNum = Integer.toString(i) + "_" + letters[j];
					yesNoAnswer = ic.getParameter(questionNum);
					numAnswer = ic.getParameter(questionNum + "_" + "Num");
					if( StringUtil.hasAValue(numAnswer) )
						new Integer(numAnswer); //if exception, send error message to user, in catch clause

					//Diagnostics.debug(questionNum + ":" + yesNoAnswer + "," + numAnswer);
					if (yesNoAnswer != null && yesNoAnswer.length() > 0)
					{
						saveChecklistData(conn, checklistID, questionNum, yesNoAnswer, numAnswer);
					}
				}
			}
		}
		catch(NumberFormatException e)
		{
			ic.setTransientDatum("error_msg","Number of Stations must contain a number.  Please re-enter...");
			Diagnostics.error("User did not put a # into Num of Stations...");
			result = false;
		}
		return result;
	}

	private void saveChecklistData(ConnectionWrapper conn, String checklistID, String questionNum, String yesNoAnswer, String numAnswer) throws Exception
	{
		StringBuffer query = new StringBuffer();
		query.append("INSERT INTO checklist_data (checklist_id, data_name, data_value, num_stations)");
		query.append(" VALUES (");
		query.append(conn.toSQLString(checklistID));
		query.append(", ").append(conn.toSQLString(questionNum));
		query.append(", ").append(conn.toSQLString(yesNoAnswer));
		query.append(", ").append(conn.toSQLString(numAnswer));
		query.append(")");
		conn.updateExactlyEx(query, 1);
	}

	private void deleteChecklistData(ConnectionWrapper conn, String checklistID) throws Exception
	{
		Diagnostics.debug("Deleting checklist data for checklist_id = " + checklistID);
		conn.updateEx("DELETE FROM checklist_data WHERE checklist_id = " + checklistID);
	}

}
