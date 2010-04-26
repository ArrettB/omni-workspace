/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.
 *
 * Copyright 2001-2003,2006, Dynamic Information Systems, LLC
 * $Header: DisplayChecklistHandler.java, 5, 1/26/2006 5:41:57 PM, Blake Von Haden$
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO
 * EVENT SHALL DYNAMIC INFORMATIONS SYTEMS, LLC BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * ====================================================================
 */package ims.handlers.lists;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * 
 * @version $Header: DisplayChecklistHandler.java, 5, 1/26/2006 5:41:57 PM, Blake Von Haden$
 */
public class DisplayChecklistHandler extends BaseHandler
{
	public void setUpHandler()
	{
	}

	public void destroy()
	{
	}

	public boolean handleEnvironment(InvocationContext ic)
	{
		ConnectionWrapper conn = null;
		boolean result = true;
		try
		{
			Diagnostics.trace("DisplayChecklistHandler.handleEnvironment()");
			conn = (ConnectionWrapper) ic.getResource();
			String checklistID = ic.getParameter("checklist_id");
			String redisplay_checklist = ic.getParameter("redisplay_checklist");
			boolean redisplay = false;
			if (StringUtil.hasAValue(redisplay_checklist) && redisplay_checklist.equalsIgnoreCase("true"))
				redisplay = true;
			StringBuffer query = new StringBuffer();
			query.append("SELECT num_stations");
			query.append(" FROM checklists ");
			query.append(" WHERE checklist_id = ").append(conn.toSQLString(checklistID));

			if (redisplay)
			{
				String totalNumStations = ic.getParameter("num_stations");
				ic.setTransientDatum("num_stations", totalNumStations);

				String questionNum = null;
				String yesNoAnswer = null;
				String numAnswer = null;
				for (int i = 1; i <= SaveChecklistHandler.numberQuestions; i++)
				{
					questionNum = Integer.toString(i);
					yesNoAnswer = ic.getParameter(questionNum);
					numAnswer = ic.getParameter(questionNum + "_" + "Num");

					if (StringUtil.hasAValue(questionNum) && StringUtil.hasAValue(yesNoAnswer))
					{
						ic.setTransientDatum(questionNum + "_" + yesNoAnswer.toLowerCase() + "_checked", "checked");
						// Diagnostics.debug("Setting " + questionNum + "_" + yesNoAnswer.toLowerCase() + "_checked=checked");
					}

					for (int j = 0; j < SaveChecklistHandler.letters.length; j++)
					{
						questionNum = Integer.toString(i) + "_" + SaveChecklistHandler.letters[j];
						yesNoAnswer = ic.getParameter(questionNum);
						numAnswer = ic.getParameter(questionNum + "_" + "Num");
						if (StringUtil.hasAValue(questionNum) && StringUtil.hasAValue(yesNoAnswer))
						{
							ic.setTransientDatum(questionNum + "_" + yesNoAnswer.toLowerCase() + "_checked", "checked");
							// Diagnostics.debug("Setting " + questionNum + "_" + yesNoAnswer.toLowerCase() + "_checked=checked");
						}

						if (StringUtil.hasAValue(numAnswer))
						{
							ic.setTransientDatum(questionNum + "_num", numAnswer);
							// Diagnostics.debug("Setting " + questionNum + "_num=" + numAnswer);
						}

					}
				}
			}
			else
			{
				QueryResults rs = conn.resultsQueryEx(query);
				if (rs.next())
				{
					String totalNumStations = rs.getString("num_stations");
					ic.setTransientDatum("num_stations", totalNumStations);
					rs.close();

					query = new StringBuffer();
					query.append("SELECT data_name, data_value, num_stations");
					query.append(" FROM checklist_data ");
					query.append(" WHERE checklist_id = ").append(checklistID);
					rs = conn.resultsQueryEx(query);
					while (rs.next())
					{
						String dataName = rs.getString("data_name");
						String dataValue = rs.getString("data_value");
						String numStations = rs.getString("num_stations");

						if (StringUtil.hasAValue(dataValue))
						{
							ic.setTransientDatum(dataName + "_" + dataValue.toLowerCase() + "_checked", "checked");
							// Diagnostics.debug("Setting " + dataName + "_" + dataValue.toLowerCase() + "_checked=checked");
						}

						if (StringUtil.hasAValue(numStations))
						{
							ic.setTransientDatum(dataName + "_num", numStations);
							// Diagnostics.debug("Setting " + dataName + "_num=" + numStations);
						}
					}

				}
				rs.close();
			}

		}
		catch (Exception e)
		{
			result = false;
			ErrorHandler.handleException(ic, e, "Exception in DisplayChecklistHandler");
		}
		finally
		{
			if (conn != null)
				conn.release();
		}

		return result;
	}

}
