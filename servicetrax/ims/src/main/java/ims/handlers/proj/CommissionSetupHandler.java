package ims.handlers.proj;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.util.diagnostics.Diagnostics;
import ims.Constants;

import java.util.Date;

public class CommissionSetupHandler extends BaseHandler {

    private static final String INSERT_COMMISSION =
            "INSERT INTO COMMISSIONS (PROJECT_ID, REQUEST_ID, FUEL_SURCHARGE, LABOR_MARKUP, TRUCKING_MARKUP, EXPENSE_MARKUP, CREATED_BY," +
                    " DATE_CREATED)" +
                    " VALUES(?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String UPDATE_COMMISSION =
            "UPDATE COMMISSIONS SET PROJECT_ID = ?, REQUEST_ID = ?, FUEL_SURCHARGE = ?, LABOR_MARKUP = ?, " +
                    " TRUCKING_MARKUP = ?, EXPENSE_MARKUP = ?, MODIFIED_BY = ?, DATE_MODIFIED = ?" +
                    " WHERE PROJECT_ID = ? AND REQUEST_ID = ?";

    private static final String CHECK_FOR_COMMISSION =
            "SELECT COUNT(*) AS EXISTING_ROWS FROM COMMISSIONS WHERE PROJECT_ID = ? AND REQUEST_ID = ?";

    public boolean handleEnvironment(InvocationContext ic) throws Exception {

        boolean result = true;

        String button = ic.getParameter("button");

        if (!button.equals("Save")) {
            return result;
        }

        //Sanity check: if display is false, we do not want to persist the values
        String displayMarkupWidgets = ic.getParameter(Constants.DISPLAY_MARKUP_WIDGETS);
        if (displayMarkupWidgets != null && displayMarkupWidgets.trim().length() > 0 && displayMarkupWidgets.equals("false")) {
            return result;
        }

        boolean isUpdate = isUpdate(ic,
                                    CHECK_FOR_COMMISSION,
                                    new Object[]{
                                            ic.getParameter("project_id"),
                                            ic.getParameter("request_id")});
        if (isUpdate) {
            executeSql(ic,
                       new Object[]{
                               ic.getParameter("project_id"),
                               ic.getParameter("request_id"),
                               ic.getParameter("fuel_surcharge"),
                               ic.getParameter("labor_markup"),
                               ic.getParameter("trucking_markup"),
                               ic.getParameter("expense_markup"),
                               ic.getSessionDatum("user_id"),
                               new Date(),
                               ic.getParameter("project_id"),
                               ic.getParameter("request_id"),
                       },
                       UPDATE_COMMISSION);
        }
        else {
            executeSql(ic,
                       new Object[]{
                               ic.getParameter("project_id"),
                               ic.getParameter("request_id"),
                               ic.getParameter("fuel_surcharge"),
                               ic.getParameter("labor_markup"),
                               ic.getParameter("trucking_markup"),
                               ic.getParameter("expense_markup"),
                               ic.getSessionDatum("user_id"),
                               new Date()
                       },
                       INSERT_COMMISSION);
        }
        return result;
    }

    private boolean isUpdate(InvocationContext ic, String sql, Object[] params) {

        ConnectionWrapper conn = null;
        QueryResults rs = null;

        try {
            conn = (ConnectionWrapper) ic.getResource();
            rs = conn.select(sql, params);
            return rs.next() && rs.getInt("EXISTING_ROWS") > 0;
        }
        catch (Exception e) {
            Diagnostics.error("Exception selecting project_id :" + e);
        }
        finally {
            try {
                if (rs != null) {
                    rs.close();
                }

                if (conn != null) {
                    conn.release();
                }
            }
            catch (Exception ignore) {
                Diagnostics.error("Exception selecting project_id :" + ignore);
            }
        }
        return false;
    }

    private void executeSql(InvocationContext ic, Object[] params, String sql) {

        ConnectionWrapper conn = null;
        try {
            conn = (ConnectionWrapper) ic.getResource();
            conn.update(sql, params);
        }
        catch (Exception e) {
            Diagnostics.error("Exception selecting project_id :" + e);
        }
        finally {
            try {
                if (conn != null) {
                    conn.release();
                }
            }
            catch (Exception ignore) {
                Diagnostics.error("Exception selecting project_id :" + ignore);
            }
        }
    }

    @Override
    public void destroy() {
    }

    @Override
    public void setUpHandler() throws Exception {
    }


}
