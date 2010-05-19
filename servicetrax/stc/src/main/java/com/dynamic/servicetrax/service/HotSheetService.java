package com.dynamic.servicetrax.service;

import com.dynamic.servicetrax.orm.HotSheet;
import com.dynamic.servicetrax.orm.HotSheetDetail;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * User: pgarvie
 * Date: May 13, 2010
 * Time: 3:29:46 PM
 */
public class HotSheetService {

    private JdbcTemplate jdbcTemplate;

    private static final String GET_PROJECT_INFO =
            "SELECT TOP 1 RTRIM(p.dealer_name) dealerName," +
                    " RTRIM(p.customer_name) customerName," +
                    " RTRIM(p.end_user_name) endUserName," +
                    " p.job_name as jobName " +
                    " FROM projects_v2 p  " +
                    " WHERE p.project_id = ?";

    public HotSheet buildHotSheet(String requestId) {

        BigDecimal projectId = getProjectId(requestId);
        HotSheet hotSheet = addProjectInfo(projectId);
        Integer hotSheetNumber = getHotSheetNumber(requestId);
        hotSheet.setHotSheetNumber(hotSheetNumber);
        addRequestInfo(hotSheet, requestId, hotSheetNumber);
        return hotSheet;
    }


    private HotSheet addProjectInfo(BigDecimal projectId) {
        List projectInfo = jdbcTemplate.query(GET_PROJECT_INFO, new Object[]{projectId}, new ProjectInfoMapper());
        return (HotSheet) projectInfo.get(0);
    }


    private BigDecimal getProjectId(String requestId) {
        List list = jdbcTemplate.queryForList("select project_id from requests where request_id = ?", new Object[]{requestId});
        Map row = (Map) list.get(0);
        return (BigDecimal) row.get("project_id");
    }

    private static final String GET_HOT_SHEET_NUMBER = "select count(*) as hotSheetNo from hotsheets where request_id = ?";

    private Integer getHotSheetNumber(String requestId) {
        Integer hotSheetNumber = jdbcTemplate.queryForInt(GET_HOT_SHEET_NUMBER, new Object[]{requestId});
        if (hotSheetNumber == null) {
            hotSheetNumber = 1;
        }
        else {
            hotSheetNumber++;
        }
        return hotSheetNumber;
    }


    private static final String GET_HOT_SHEET_ID_INFO =
            "select requests.PROJECT_ID as projectId," +
                    " requests.REQUEST_NO as requestNo," +
                    " requests.VERSION_NO as versionNo," +
                    " requests.JOB_LOCATION_ID as jobLocationId," +
                    " requests.JOB_LOCATION_CONTACT_ID as jobLocationContactId," +
                    " requests.DEALER_PO_NO, " +
                    " requests.DESCRIPTION," +
                    " requests.DATE_CREATED," +
                    " requests.CREATED_BY," +
                    " requests.DATE_MODIFIED," +
                    " requests.MODIFIED_BY" +
                    " from requests where requests.request_id = ?";


    private void addRequestInfo(HotSheet hotSheet, String requestId, Integer hotSheetNumber) {

        List list = jdbcTemplate.queryForList(GET_HOT_SHEET_ID_INFO, new Object[]{requestId});
        Map row = (Map) list.get(0);

        // Build hotsheet id
        StringBuilder buf = new StringBuilder(requestId);
        buf.append("-");
        buf.append(row.get("requestNo"));
        buf.append(".");
        buf.append(row.get("versionNo"));
        buf.append("HS");
        buf.append(hotSheetNumber);
        hotSheet.setHotSheetIdentifier(buf.toString());

        // Get the created and modified dates
        hotSheet.setDateCreated((Date) row.get("DATE_CREATED"));
        hotSheet.setDateModified((Date) row.get("DATE_MODIFIED"));

        hotSheet.setDealerPONumber((String) row.get("DEALER_PO_NO"));
        hotSheet.setDescription((String) row.get("DESCRIPTION"));

        List createdBy = jdbcTemplate.queryForList("SELECT FIRST_NAME, LAST_NAME FROM USERS WHERE USER_ID = ? ", new Object[]{row.get("CREATED_BY")});
        String createdName = getName(createdBy);
        hotSheet.setCreatedByName(createdName);

        List modifiedBy = jdbcTemplate.queryForList("SELECT FIRST_NAME, LAST_NAME FROM USERS WHERE USER_ID = ? ", new Object[]{row.get("MODIFIED_BY")});
        String modifiedName = getName(modifiedBy);
        hotSheet.setModifiedByName(modifiedName);

        initializeJobLocation(hotSheet, (BigDecimal) row.get("jobLocationId"));
        initializeJobLocationContact(hotSheet, (BigDecimal) row.get("jobLocationContactId"));

        //Default to today
        hotSheet.setJobDate(new Date());
    }

    private void initializeJobLocationContact(HotSheet hotSheet, BigDecimal jobLocationContactId) {

        List jobLocationContact =
                jdbcTemplate.queryForList("SELECT CONTACT_NAME, EMAIL, PHONE_WORK, PHONE_CELL, PHONE_HOME FROM CONTACTS WHERE CONTACT_ID = ? ",
                                          new Object[]{jobLocationContactId});

        if (jobLocationContact == null || jobLocationContact.size() == 0) {
            return;
        }


        Map row = (Map) jobLocationContact.get(0);
        hotSheet.setJobContactName((String) row.get("CONTACT_NAME"));
        hotSheet.setJobContactEmail((String) row.get("EMAIL"));
        hotSheet.setJobContactPhone((String) row.get("PHONE_WORK"));
        hotSheet.setJobLocationContactId(jobLocationContactId.longValue());
    }

    private void initializeJobLocation(HotSheet hotSheet, BigDecimal jobLocationId) {

        List jobLocation = jdbcTemplate.queryForList("SELECT JOB_LOCATION_NAME, STREET1, STREET2, STREET3, CITY, " +
                "STATE, ZIP, COUNTRY FROM JOB_LOCATIONS WHERE JOB_LOCATION_ID = ? ", new Object[]{jobLocationId});

        if (jobLocation == null || jobLocation.size() == 0) {
            return;
        }

        Map row = (Map) jobLocation.get(0);
        hotSheet.setJobLocationName((String) row.get("JOB_LOCATION_NAME"));
        hotSheet.setStreetOne((String) row.get("STREET1"));
        hotSheet.setStreetTwo((String) row.get("STREET2"));
        hotSheet.setStreetThree((String) row.get("STREET3"));
        hotSheet.setCity((String) row.get("CITY"));
        hotSheet.setState((String) row.get("STATE"));
        hotSheet.setZip((String) row.get("ZIP"));
        hotSheet.setCountry((String) row.get("COUNTRY"));

    }

    private String getName(List rows) {
        if (rows == null || rows.size() == 0) {
            return null;
        }

        Map row = (Map) rows.get(0);
        StringBuilder buffer = new StringBuilder((String) row.get("FIRST_NAME"));
        buffer.append(" ");
        buffer.append((String) row.get("LAST_NAME"));
        return buffer.toString();
    }


    private static final String HOTSHEET_LOOKUP_TYPE_ID = "'83'";
    public static final String GET_HOTSHEET_LOOKUPS =
            "select lookup_id, code, name from lookups where lookup_type_id  = " + HOTSHEET_LOOKUP_TYPE_ID;

    @SuppressWarnings("unchecked")
    public Map<String, HotSheetDetail> getHotSheetDetails(Long user) {
        List<Map> lookups = jdbcTemplate.queryForList(GET_HOTSHEET_LOOKUPS);
        Map<String, HotSheetDetail> details = new HashMap<String, HotSheetDetail>();
        for (Map aRow : lookups) {
            HotSheetDetail aDetail = new HotSheetDetail();
            BigDecimal id = (BigDecimal) aRow.get("lookup_id");
            aDetail.setHotSheetLookupId(id.longValue());
            aDetail.setCode((String) aRow.get("code"));
            aDetail.setName((String) aRow.get("name"));
            aDetail.setAttributeValue(0);

            Date today = new Date();
            aDetail.setDateCreated(today);
            aDetail.setCreatedBy(user);
            aDetail.setDateModified(today);
            aDetail.setModifiedBy(user);
            details.put(aDetail.getCode(), aDetail);
        }
        return details;
    }

    @SuppressWarnings("unused")
    public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }


    private class ProjectInfoMapper implements RowMapper {

        public Object mapRow(ResultSet resultSet, int i) throws SQLException {
            HotSheet hotSheet = new HotSheet();
            hotSheet.setProjectName(resultSet.getString("customerName"));
            hotSheet.setCustomerName(resultSet.getString("customerName"));
            hotSheet.setEndUserName(resultSet.getString("endUserName"));
            return hotSheet;
        }
    }
}
