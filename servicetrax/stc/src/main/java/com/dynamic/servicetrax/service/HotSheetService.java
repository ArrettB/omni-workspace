package com.dynamic.servicetrax.service;

import com.dynamic.charm.query.hibernate.HibernateService;
import com.dynamic.servicetrax.orm.Address;
import com.dynamic.servicetrax.orm.HotSheet;
import com.dynamic.servicetrax.orm.HotSheetDetail;
import com.dynamic.servicetrax.orm.KeyValueBean;
import com.dynamic.servicetrax.util.TimeUtils;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * User: pgarvie
 * Date: May 13, 2010
 * Time: 3:29:46 PM
 */
public class HotSheetService {

    private JdbcTemplate jdbcTemplate;

    private HibernateService hibernateService;

    public static final String GET_PROJECT_INFO =
            "SELECT TOP 1 p.customer_id customerId," +
                    " p.end_user_id endUserId," +
                    " RTRIM(p.dealer_name) dealerName," +
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
        hotSheet.setRequestId(Long.valueOf(requestId));
        hotSheet.setProjectId(projectId.longValue());

        addOriginAddressInfo(hotSheet);
        addBillingAddressInfo(hotSheet);
        return hotSheet;
    }

    public static final String GET_CUSTOMER_INFO =
            "select JOB_LOCATION_ID, JOB_LOCATION_NAME from JOB_LOCATIONS where CUSTOMER_ID = ? order by JOB_LOCATION_NAME";

    @SuppressWarnings("unchecked")
    public void addOriginAddressInfo(HotSheet hotSheet) {

        List<Map> originAddresses = jdbcTemplate.queryForList(GET_CUSTOMER_INFO, new Object[]{hotSheet.getCustomerId()});
        hotSheet.setOriginAddresses(originAddresses);

        if (originAddresses != null && originAddresses.size() > 0) {
            Map firstAddress = originAddresses.get(0);
            BigDecimal id = (BigDecimal) firstAddress.get("JOB_LOCATION_ID");
            Address originAddress = getAddress(id);
            hotSheet.setOriginAddress(originAddress);
            List<KeyValueBean> addresses = new ArrayList<KeyValueBean>();
            for (Map aRow : originAddresses) {
                BigDecimal key = (BigDecimal) aRow.get("JOB_LOCATION_ID");
                String value = (String) aRow.get("JOB_LOCATION_NAME");
                KeyValueBean aBean = new KeyValueBean(key, value);
                addresses.add(aBean);
            }
            hotSheet.setOriginAddresses(addresses);
        }
        else{
            hotSheet.setOriginAddress(new Address());
        }
    }

    private void addBillingAddressInfo(HotSheet hotSheet) {

        //TODO: wire this up to billing when it comes on line
        Long id = hotSheet.getJobLocationAddressId();
        hotSheet.setBillingAddressId(id);
        Address billingAddress = getAddress(new BigDecimal(id));
        hotSheet.setBillingAddress(billingAddress);
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
                    " requests.JOB_LOCATION_ID as jobLocationAddressId," +
                    " requests.JOB_LOCATION_CONTACT_ID as jobLocationContactId," +
                    " requests.DEALER_PO_NO, " +
                    " requests.DESCRIPTION," +
                    " requests.CUSTOMER_CONTACT_ID," +
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

        hotSheet.setDealerPONumber((String) row.get("DEALER_PO_NO"));
        hotSheet.setDescription((String) row.get("DESCRIPTION"));

        List createdBy = jdbcTemplate.queryForList("SELECT FIRST_NAME, LAST_NAME FROM USERS WHERE USER_ID = ? ", new Object[]{row.get("CREATED_BY")});
        String createdName = getName(createdBy);
        hotSheet.setRequestCreatedName(createdName);
        hotSheet.setRequestCreatedDate((Date) row.get("DATE_CREATED"));

        List modifiedBy = jdbcTemplate.queryForList("SELECT FIRST_NAME, LAST_NAME FROM USERS WHERE USER_ID = ? ", new Object[]{row.get("MODIFIED_BY")});
        String modifiedName = getName(modifiedBy);
        hotSheet.setRequestModifiedName(modifiedName);
        hotSheet.setRequestModifiedDate((Date) row.get("DATE_MODIFIED"));

        //We persist the id; we use the address in the view
        BigDecimal jobLocationAddressId = (BigDecimal) row.get("jobLocationAddressId");
        hotSheet.setJobLocationAddressId(jobLocationAddressId.longValue());
        Address jobLocationAddress = getAddress((BigDecimal) row.get("jobLocationAddressId"));
        hotSheet.setJobLocationAddress(jobLocationAddress);
        initializeJobLocationContact(hotSheet, (BigDecimal) row.get("CUSTOMER_CONTACT_ID"));

        //Default to today
        hotSheet.setJobDate(new Date());
        hotSheet.setJobLength(0);
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

    public static final String SELECT_ADDRESS =
            "SELECT JOB_LOCATION_NAME, STREET1, STREET2, STREET3, CITY, " +
                    "STATE, ZIP, COUNTRY FROM JOB_LOCATIONS WHERE JOB_LOCATION_ID = ? ";


    public Address getAddress(BigDecimal jobLocationId) {

        Address address = (Address) jdbcTemplate.queryForObject(SELECT_ADDRESS,
                                                                new Object[]{jobLocationId},
                                                                new AddressMapper());
        if (address == null) {
            return null;
        }

        return address;
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

    public HotSheet saveHotSheet(HotSheet hotsheet) {
        HotSheet persisted = (HotSheet) hibernateService.saveOrUpdate(hotsheet);

        Map<String, HotSheetDetail> details = persisted.getDetails();
        if (details != null) {
            Set<String> keys = details.keySet();
            for (String aKey : keys) {
                HotSheetDetail aDetail = details.get(aKey);
                aDetail.setHotSheet(hotsheet);
                aDetail.setCreatedBy(hotsheet.getCreatedBy());
                hibernateService.saveOrUpdate(aDetail);
            }
        }
        return persisted;
    }

    @SuppressWarnings("unused")
    public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @SuppressWarnings("unused")
    public void setHibernateService(HibernateService hibernateService) {
        this.hibernateService = hibernateService;
    }

    public void initializeStartTimes(HttpServletRequest request, HotSheet hotSheet) {

        Map map = request.getParameterMap();
        int startTime =
                TimeUtils.getTimeAsMilitaryTime(Integer.valueOf(getValue(map.get("start_time_hour"))),
                                                Integer.valueOf(getValue(map.get("start_time_minutes"))),
                                                getValue(map.get("start_time_AMPM")));
        hotSheet.setJobStartTime(startTime);

        int warehouseStartTime =
                TimeUtils.getTimeAsMilitaryTime(Integer.valueOf(getValue(map.get("warehouse_start_time_hour"))),
                                                Integer.valueOf(getValue(map.get("warehouse_start_time_minutes"))),
                                                getValue(map.get("warehouse_start_time_AMPM")));
        hotSheet.setWarehouseStartTime(warehouseStartTime);
    }

    private String getValue(Object param) {
        String[] s = (String[]) param;
        if (s != null && s.length > 0) {
            return s[0];
        }
        return null;
    }

    private class ProjectInfoMapper implements RowMapper {

        public Object mapRow(ResultSet resultSet, int i) throws SQLException {
            HotSheet hotSheet = new HotSheet();
            BigDecimal customerId = resultSet.getBigDecimal("customerId");
            if (customerId != null) {
                hotSheet.setCustomerId(customerId.longValue());
            }

            BigDecimal endUserId = resultSet.getBigDecimal("endUserId");
            if (endUserId != null) {
                hotSheet.setEndUserId(endUserId.longValue());
            }
            hotSheet.setProjectName(resultSet.getString("jobName"));
            hotSheet.setCustomerName(resultSet.getString("customerName"));
            hotSheet.setEndUserName(resultSet.getString("endUserName"));
            return hotSheet;
        }
    }

    private class AddressMapper implements RowMapper {

        public Object mapRow(ResultSet resultSet, int i) throws SQLException {
            Address address = new Address();
            address.setJobLocationName(resultSet.getString("JOB_LOCATION_NAME"));
            address.setStreetOne(resultSet.getString("STREET1"));
            address.setStreetTwo(resultSet.getString("STREET2"));
            address.setStreetThree(resultSet.getString("STREET3"));
            address.setCity(resultSet.getString("CITY"));
            address.setState(resultSet.getString("STATE"));
            address.setZip(resultSet.getString("ZIP"));
            address.setCountry(resultSet.getString("COUNTRY"));
            return address;
        }
    }
}
