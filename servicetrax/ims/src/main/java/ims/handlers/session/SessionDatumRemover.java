package ims.handlers.session;

import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * @version $Id: SessionDatumRemover.java, 1, 5/21/2008, David Zhao$
 */
public class SessionDatumRemover extends BaseHandler {

	public void setUpHandler() {}

	public void destroy() {}

	public boolean handleEnvironment(InvocationContext ic) {
		Diagnostics.trace("SessionDatumRemover.handleEnvironment()");
		boolean result = true;
		String sessionDatumName = null;
		try {
			sessionDatumName = ic.getParameter("session_datum_name");
			if (StringUtil.hasAValue(sessionDatumName)) {
				ic.removeSessionDatum(sessionDatumName);
			}
		} catch (Exception e) {
			result = false;
			Diagnostics.error("Error in SessionDatumRemover.handleEnvironment():" + e);
		} finally {

		}
		return result;
	}

}
