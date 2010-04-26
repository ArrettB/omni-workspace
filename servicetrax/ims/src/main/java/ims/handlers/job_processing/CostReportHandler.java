/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.
 *
 * Copyright 2005, Dynamic Information Systems, LLC
 * $Header: C:\work\ims\src\ims\handlers\job_processing\CostReportHandler.java, 4, 3/15/2006 6:03:16 PM, Blake Von Haden$
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
package ims.handlers.job_processing;

import ims.handlers.docs.DocumentDownloadHandler;

import javax.servlet.ServletOutputStream;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;


/**
 * Run the cost report.
 *
 * @version $Id: C:\work\ims\src\ims\handlers\job_processing\CostReportHandler.java, 4, 3/15/2006 6:03:16 PM, Blake Von Haden$
 */
public class CostReportHandler extends DocumentDownloadHandler
{
	public boolean handleEnvironment(InvocationContext ic)
	{
		ConnectionWrapper conn = null;

		try
		{
			conn = (ConnectionWrapper) ic.getResource();

			CostReport report = new CostReport();
			String jobId = (String) ic.getSessionDatum("job_id");
			String organizationId = (String) ic.getSessionDatum("org_id");
			String customerName = (String) ic.getSessionDatum("customer_name");
			report.generate(jobId, organizationId, customerName, conn);
			
			boolean inline = !StringUtil.toBoolean(ic.getParameter("download"));

			ServletOutputStream out = getOutputStream(ic, "Cost Report.xls", null, inline);
			report.write(out);
			ic.setAction(null);
			ic.setHTMLTemplateName(null);
		}
		catch (Exception e)
		{
			ic.setTransientDatum("errorMessage", "Unable to create the costing report " + e.getMessage());
			Diagnostics.error("Unable to create the costing report", e);
		}
		finally
		{
			if (conn != null)
				conn.release();
		}

		return true;
	}
}
