/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.
 *
 * Copyright 2005, Dynamic Information Systems, LLC
 * $Header: ItemCostingPostHandler.java, 1, 6/10/2005 9:14:28 AM, Blake Von Haden$
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
 */
package ims.handlers.maintenance;

import ims.dataobjects.User;
import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.SmartFormHandler;


/**
 * Create the history entry for an update to the Item Costing.
 *
 * @version $Header: ItemCostingPostHandler.java, 1, 6/10/2005 9:14:28 AM, Blake Von Haden$
 */
public class ItemCostingPostHandler extends BaseHandler
{
	public void setUpHandler() throws Exception {}

	public void destroy() {}

	/* (non-Javadoc)
	 * @see dynamic.intraframe.handlers.BaseHandler#handleEnvironment(dynamic.intraframe.engine.InvocationContext)
	 */
	public boolean handleEnvironment(InvocationContext ic)
		throws Exception
	{
		String button = ic.getParameter("button");
		boolean result = true;

		if ("Save".equals(button))
		{
			ConnectionWrapper conn = (ConnectionWrapper) ic.getTransientDatum(SmartFormHandler.CONNECTION);
			String itemId = ic.getParameter("item_id");
			String uom = ic.getParameter("cost_per_uom");
			String margin = ic.getParameter("percent_margin");
			User user = (User) ic.getSessionDatum("user");

			String query = "INSERT INTO item_costing_history"
			             + "(item_id, cost_per_uom, percent_margin, created_by, date_created)"
			             + "VALUES"
			             + "(" + conn.toSQLString(itemId)
			             + ", " + conn.toSQLString(uom)
			             + ", " + conn.toSQLString(margin)
			             + ", " + conn.toSQLString(user.getFirstName() + " " + user.getLastName()) 
			             + ", CURRENT_TIMESTAMP)";
			conn.updateEx(query);
		}

		return result;
	}
}
