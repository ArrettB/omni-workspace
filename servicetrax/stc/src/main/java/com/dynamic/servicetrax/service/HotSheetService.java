package com.dynamic.servicetrax.service;

import com.dynamic.charm.query.hibernate.HibernateService;
import com.dynamic.servicetrax.orm.HotSheet;
import com.dynamic.servicetrax.orm.HotSheetDetail;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.orm.hibernate3.HibernateTemplate;

import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
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

    public HotSheet configureHotSheetProjectInfo(String requestId) {

        BigDecimal projectId = getProjectId(requestId);
        List list = jdbcTemplate.query(GET_PROJECT_INFO, new Object[]{projectId}, new ProjectInfoMapper());
        HotSheet hotSheet = (HotSheet) list.get(0);
        Integer hotSheetNumber = getHotSheetNumber(requestId);
        hotSheet.setHotSheetNumber(hotSheetNumber);

        String hotSheetIdentifier = getHotSheetIdentifier(requestId, hotSheetNumber);
        hotSheet.setHotSheetIdentifier(hotSheetIdentifier);
        return hotSheet;
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
            "select requests.project_id as projectId, " +
                    " requests.request_no as requestNo, " +
                    " requests.version_no as versionNo " +
                    " from requests where requests.request_id = ?";

    private String getHotSheetIdentifier(String requestId, Integer hotSheetNumber) {

        List list = jdbcTemplate.queryForList(GET_HOT_SHEET_ID_INFO, new Object[]{requestId});

        Map row = (Map) list.get(0);
        StringBuilder buf = new StringBuilder(requestId);
        buf.append("-");
        buf.append(row.get("requestNo"));
        buf.append(".");
        buf.append(row.get("versionNo"));
        buf.append("HS");
        buf.append(hotSheetNumber);
        return buf.toString();
    }


    public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private static final String GET_HOTSHEET_LOOKUPS =
            "select lookup_id, code, name from lookups where lookup_type_id  = '83'";

    public Map<String, HotSheetDetail> getHotSheetDetails() {
        List<Map> lookups = jdbcTemplate.queryForList(GET_HOTSHEET_LOOKUPS);
        Map<String, HotSheetDetail> details = new HashMap<String, HotSheetDetail>();
        for(Map aRow : lookups){
            HotSheetDetail aDetail = new HotSheetDetail();
            BigDecimal id = (BigDecimal) aRow.get("lookup_id");
            aDetail.setHotSheetLookupId(id.longValue());
            aDetail.setCode((String)aRow.get("code"));
            aDetail.setName((String)aRow.get("name"));
            aDetail.setAttributeValue(0);
            details.put(aDetail.getCode(), aDetail);
        }
        return details;
    }

    public void setHibernateLookupsDao(com.dynamic.servicetrax.dao.HibernateLookupsDao hibernateLookupsDao) {
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
