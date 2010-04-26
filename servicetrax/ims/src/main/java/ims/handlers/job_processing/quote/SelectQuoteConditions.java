/*
 *               ApexIT, Inc.
 *
 * This software can only be used with the expressed written
 * consent of ApexIT, Inc. All rights reserved.
 *
 * Copyright 2009 ApexIT, Inc.
 * $Id: SelectQuoteConditions.java 1520 2009-03-10 23:11:04Z bvonhaden $
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL APEXIT, INC.
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
 * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 * ====================================================================
 */

package ims.handlers.job_processing.quote;

import ims.Constants;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import dynamic.dbtk.InClause;
import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.util.diagnostics.Diagnostics;

/**
 * Update the selected conditions for the quote.
 * 
 * This assumes there is one quote per quote request.
 * 
 * @version $Id: SelectQuoteConditions.java 1520 2009-03-10 23:11:04Z bvonhaden $
 */
public class SelectQuoteConditions extends BaseHandler
{

	public void setUpHandler() throws Exception
	{}

	public void destroy()
	{}

	public boolean handleEnvironment(InvocationContext ic)
	{
		String conditions[] = (String[]) ic.getParameterValues("statusCheckBox");
		String originalStatus[] = (String[]) ic.getParameterValues("originalStatus");

		List<String> conditionsToRemove = new ArrayList<String>();
		List<String> originallyUnchecked = new ArrayList<String>();

		for (String original : originalStatus)
		{
			String[] orig = original.split(":");
			if (orig.length > 0)
			{
				if ("N".equals(orig[0]))
					originallyUnchecked.add(orig[1]);
				else
					conditionsToRemove.add(orig[1]);
			}
		}

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper) ic.getResource();
			conn.setAutoCommit(false);
			String requestId = ic.getParameter("request_id");

			String quoteId = conn.selectFirst("SELECT quote_id FROM quotes WHERE request_id = ?", requestId);

			String userId = ic.getSessionDatum(Constants.SESSION_USER_ID).toString();
			for (String checked : conditions)
			{
				if (originallyUnchecked.contains(checked))
				{
					// add
					String insert = "INSERT INTO quote_standard_conditions (quote_id, standard_condition_id, date_created, created_by)"
							+ " VALUES (?, ?, getDate(), ?)";
					String[] params = new String[] { quoteId, checked, userId };
					conn.update(insert, params);
				}
				else
				{
					conditionsToRemove.remove(checked);
				}
			}

			InClause inClause = new InClause();
			for (String standardConditionId : conditionsToRemove)
			{
				inClause.add(standardConditionId);
			}
			if (inClause.isValid())
			{
				String delete = "DELETE FROM quote_standard_conditions WHERE quote_id = ? AND "
						+ inClause.getInClause("standard_condition_id");
				conn.update(delete, quoteId);
			}

			conn.update("UPDATE quotes SET date_modified = getDate(), modified_by = ? WHERE quote_id = ?", new String[] { userId,
					quoteId });

			conn.commit();
		}
		catch (Exception e)
		{
			Diagnostics.error("Problem updating quote conditions", e);
			try
			{
				if (conn != null)
					conn.rollback();
			}
			catch (SQLException ignore)
			{}
		}
		finally
		{
			if (conn != null)
    			try
    			{
    				conn.setAutoCommit(true);
    			}
    			catch (SQLException ignore)
    			{}
    			conn.release();
		}

		return false;
	}

}
