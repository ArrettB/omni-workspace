package com.dynamic.servicetrax.service;

import com.dynamic.charm.query.hibernate.HibernateService;
import com.dynamic.servicetrax.orm.Address;
import com.dynamic.servicetrax.orm.HotSheet;
import com.dynamic.servicetrax.orm.HotSheetDetail;
import com.dynamic.servicetrax.util.TimeUtils;
import org.springframework.context.MessageSource;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.validation.FieldError;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
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

    private MessageSource messageSource;

    public static final String GET_PROJECT_INFO =
            "SELECT TOP 1 p.customer_id customerId," +
                    " p.end_user_id endUserId," +
                    " RTRIM(p.dealer_name) dealerName," +
                    " RTRIM(p.customer_name) customerName," +
                    " RTRIM(p.end_user_name) endUserName," +
                    " p.job_name as jobName " +
                    " FROM projects_v2 p  " +
                    " WHERE p.project_id = ?";

    public HotSheet buildHotSheet(String requestId, Long userId) {

        BigDecimal projectId = getProjectId(requestId);
        HotSheet hotSheet = addProjectInfo(projectId);

        Integer hotSheetNumber = getNextHotSheetNumberForRequest(requestId);
        hotSheet.setHotSheetNumber(hotSheetNumber);

        addRequestInfo(hotSheet, requestId, hotSheetNumber);
        hotSheet.setRequestId(Long.valueOf(requestId));
        hotSheet.setProjectId(projectId.longValue());

        initializeJobTime(hotSheet);

        addRequestTypeId(hotSheet);
        addUserInfo(hotSheet, userId);
        addOriginAddressInfo(hotSheet);
        addBillingAddressInfo(hotSheet);
        return hotSheet;
    }

    private void initializeJobTime(HotSheet hotSheet) {

        Calendar now = Calendar.getInstance();

        //Default to today
        hotSheet.setJobDate(now.getTime());
        hotSheet.setJobLength(0);

        String AM_PM = "AM";
        if (now.get(Calendar.HOUR_OF_DAY) > 12) {
            AM_PM = "PM";
        }

        int minute = now.get(Calendar.MINUTE);
        if (minute >= 45) {
            minute = 45;
        }
        else if (minute >= 30) {
            minute = 30;
        }
        else if (minute >= 15) {
            minute = 15;
        }
        else {
            minute = 0;
        }

        hotSheet.setStartTimeHour(String.valueOf(now.get(Calendar.HOUR)));
        hotSheet.setStartTimeMinutes(String.valueOf(minute));
        hotSheet.setStartTimeAMPM(AM_PM);
        hotSheet.setWarehouseStartTimeHour(String.valueOf(now.get(Calendar.HOUR)));
        hotSheet.setWarehouseStartTimeMinutes(String.valueOf(minute));
        hotSheet.setWarehouseStartTimeAMPM(AM_PM);
    }


    public static final String GET_REQUEST_TYPE_ID =
            "select lookup_id from lookups where code = 'hot_sheet'";

    private void addRequestTypeId(HotSheet hotSheet) {
        long requestTypeId = jdbcTemplate.queryForLong(GET_REQUEST_TYPE_ID);
        hotSheet.setRequestTypeId(requestTypeId);
    }

    public static final String GET_USER = "select full_name from users where user_id = ?";

    private void addUserInfo(HotSheet hotSheet, Long userId) {

        hotSheet.setDateCreated(new Date());
        hotSheet.setCreatedBy(userId);
        String name = getUserName(userId);
        hotSheet.setCreatedByName(name);
    }

    public String getUserName(Long userId) {
        String name = null;
        List row = jdbcTemplate.queryForList(GET_USER, new Object[]{userId});
        if (row != null && row.size() > 0) {
            Map userInfo = (Map) row.get(0);
            name = (String) userInfo.get("full_name");
        }
        return name;
    }

    public static final String GET_JOB_LOCATION_INFO = "select JOB_LOCATION_ID, JOB_LOCATION_NAME, JOB_LOCATION_NAME, " +
            " STREET1, STREET2, STREET3," +
            " CITY, STATE, ZIP, COUNTRY " +
            "from JOB_LOCATIONS where CUSTOMER_ID = ? order by JOB_LOCATION_NAME";

    @SuppressWarnings("unchecked")
    public void addOriginAddressInfo(HotSheet hotSheet) {

        List<Map> originAddresses = jdbcTemplate.queryForList(GET_JOB_LOCATION_INFO, new Object[]{hotSheet.getCustomerId()});
        hotSheet.setOriginAddresses(originAddresses);

        if (originAddresses != null && originAddresses.size() > 0) {
            Map firstAddress = originAddresses.get(0);
            BigDecimal id = (BigDecimal) firstAddress.get("JOB_LOCATION_ID");
            Address originAddress = getAddress(id);
            hotSheet.setOriginAddress(originAddress);
            List<Address> addresses = getOriginAddresses(originAddresses);
            hotSheet.setOriginAddresses(addresses);
        }
        else {
            hotSheet.setOriginAddress(new Address());
        }
    }

    private List<Address> getOriginAddresses(List<Map> originAddresses) {
        List<Address> addresses = new ArrayList<Address>();
        for (Map aRow : originAddresses) {
            Address anAddress = new Address();
            BigDecimal id = (BigDecimal) aRow.get("JOB_LOCATION_ID");
            anAddress.setJobLocationId(id.longValue());
            anAddress.setJobLocationName((String) aRow.get("JOB_LOCATION_NAME"));
            anAddress.setStreetOne((String) aRow.get("STREET1"));
            anAddress.setStreetTwo((String) aRow.get("STREET2"));
            anAddress.setStreetThree((String) aRow.get("STREET3"));
            anAddress.setCity((String) aRow.get("CITY"));
            anAddress.setState((String) aRow.get("STATE"));
            anAddress.setZip((String) aRow.get("ZIP"));
            anAddress.setCountry((String) aRow.get("COUNTRY"));
            addresses.add(anAddress);
        }
        return addresses;
    }

    private void addBillingAddressInfo(HotSheet hotSheet) {

        //TODO: wire this up to billing when it comes on line
        Long id = hotSheet.getJobLocationAddressId();
        hotSheet.setBillingAddressId(id);

        Address billingAddress = new Address();
        billingAddress.setJobLocationCustomerId(String.valueOf(id));
        billingAddress.setJobLocationName("Billing Address");
        billingAddress.setStreetOne("Billing Address Street One");
        billingAddress.setStreetTwo("Street Two");
        billingAddress.setCity("City");
        billingAddress.setState("State");
        billingAddress.setZip("12121");

        //Address billingAddress = getAddress(new BigDecimal(id));
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

    public Integer getNextHotSheetNumberForRequest(String requestId) {
        Integer hotSheetNumber = jdbcTemplate.queryForInt(GET_HOT_SHEET_NUMBER, new Object[]{requestId});
        if (hotSheetNumber == null) {
            hotSheetNumber = 1;
        }
        else {
            hotSheetNumber++;
        }
        return hotSheetNumber;
    }

    public Integer getCurrentHotSheetNumberForRequest(String requestId) {
        return jdbcTemplate.queryForInt(GET_HOT_SHEET_NUMBER, new Object[]{requestId});
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


    private static final String HOTSHEET_LOOKUP_TYPE_CODE = "'hotsheet_detail_type'";

    public static final String GET_HOTSHEET_LOOKUPS =
            "SELECT LOOKUPS.LOOKUP_ID, LOOKUPS.CODE, LOOKUPS.NAME FROM LOOKUPS, LOOKUP_TYPES" +
                    " WHERE LOOKUP_TYPES.CODE  = " + HOTSHEET_LOOKUP_TYPE_CODE +
                    " AND LOOKUPS.LOOKUP_TYPE_ID = LOOKUP_TYPES.LOOKUP_TYPE_ID";

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

    @SuppressWarnings("unused")
    public void setMessageSource(MessageSource messageSource) {
        this.messageSource = messageSource;
    }

    public void convertStartTimesToMilitary(HttpServletRequest request, HotSheet hotSheet) {

        Map map = request.getParameterMap();
        int startTime =
                TimeUtils.getTimeAsMilitaryTime(Integer.valueOf(getValue(map.get("startTimeHour"))),
                                                Integer.valueOf(getValue(map.get("startTimeMinutes"))),
                                                getValue(map.get("startTimeAMPM")));
        hotSheet.setJobStartTime(startTime);

        int warehouseStartTime =
                TimeUtils.getTimeAsMilitaryTime(Integer.valueOf(getValue(map.get("warehouseStartTimeHour"))),
                                                Integer.valueOf(getValue(map.get("warehouseStartTimeMinutes"))),
                                                getValue(map.get("warehouseStartTimeAMPM")));
        hotSheet.setWarehouseStartTime(warehouseStartTime);
    }

    private String getValue(Object param) {
        String[] s = (String[]) param;
        if (s != null && s.length > 0) {
            return s[0];
        }
        return null;
    }

    @SuppressWarnings("unchecked")
    public List<Address> getUpdatedOriginAddresses(String customerId) {

        if (customerId == null) {
            return Collections.EMPTY_LIST;
        }

        List<Map> originAddresses = jdbcTemplate.queryForList(GET_JOB_LOCATION_INFO, new Object[]{Long.valueOf(customerId)});
        if (originAddresses != null && originAddresses.size() > 0) {
            return getOriginAddresses(originAddresses);
        }
        return Collections.EMPTY_LIST;
    }

    public Map<String, HotSheetDetail> getNewHotSheetDetails() {
        return getHotSheetDetails(null);
    }

    public Map<String, HotSheetDetail> getExistingHotSheetDetails(String hotSheetId) {
        HibernateTemplate hibernateTemplate = hibernateService.getHibernateTemplate();
        String getDetails = "from HotSheetDetail as hsd where hsd.hotSheet.hotSheetId = ?";
        List<HotSheetDetail> details = hibernateTemplate.find(getDetails, Long.valueOf(hotSheetId));
        Map<String, HotSheetDetail> detailsMap = new HashMap<String, HotSheetDetail>();
        for (HotSheetDetail aDetail : details) {
            detailsMap.put(aDetail.getCode(), aDetail);
        }
        return detailsMap;
    }


    public static final String ADD_JOB_LOCATION_ADDRESS = "insert into JOB_LOCATIONS" +
            " (CUSTOMER_ID, JOB_LOCATION_NAME, STREET1, STREET2, CITY, STATE, ZIP, COUNTRY, LOCATION_TYPE_ID, DATE_CREATED, CREATED_BY)" +
            " VALUES(?,?,?,?,?,?,?,?," +
            " select lookup_id FROM lookups l JOIN lookup_types lt ON l.lookup_type_id = lt.lookup_type_id " +
            " WHERE lt.code='location_type' AND l.code = 'worksite'," +
            " ?,?)";

    public static final String FOO =
            "INSERT INTO job_locations (customer_id, job_location_name, location_type_id, street1, street2," +
                    " city, state, zip, country, date_created, created_by)" +
                    " SELECT ?, ?, l.lookup_id, ?, ?, ?, ?, ?, ?, ?, ?" +
                    " FROM lookups l JOIN lookup_types lt ON l.lookup_type_id = lt.lookup_type_id\n" +
                    " WHERE lt.code='location_type' AND l.code = 'worksite'";

    public void addJobLocationAddress(Address address, long userId) {
        jdbcTemplate.update(FOO, new Object[]
                {
                        address.getJobLocationCustomerId(),
                        address.getJobLocationName(),
                        address.getStreetOne(),
                        address.getStreetTwo(),
                        address.getCity(),
                        address.getState(),
                        address.getZip(),
                        address.getCountry(),
                        new Date(),
                        userId
                });
    }

    public List<String> buildErrors(List<FieldError> allErrors) {

        List<String> errorMessages = new ArrayList<String>();
        for (FieldError anError : allErrors) {
            String anErrorMessage = messageSource.getMessage(anError, Locale.getDefault());
            errorMessages.add(anErrorMessage);
        }
        return errorMessages;
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
