package com.dynamic.servicetrax.service;

import com.dynamic.charm.query.hibernate.HibernateService;
import com.dynamic.charm.service.QueryService;
import com.dynamic.servicetrax.orm.Address;
import com.dynamic.servicetrax.orm.HotSheet;
import com.dynamic.servicetrax.orm.HotSheetDetail;
import com.dynamic.servicetrax.orm.KeyValueBean;
import com.dynamic.servicetrax.util.TimeUtils;
import org.apache.log4j.Logger;
import org.springframework.context.MessageSource;
import org.springframework.dao.DataAccessException;
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

    private QueryService queryService;

    private MessageSource messageSource;

    private static final Logger LOGGER = Logger.getLogger(HotSheetService.class);

    public static final String GET_PROJECT_INFO =
            "SELECT TOP 1 p.customer_id customerId," +
                    " p.end_user_id endUserId," +
                    " RTRIM(p.dealer_name) dealerName," +
                    " RTRIM(p.customer_name) customerName," +
                    " RTRIM(p.end_user_name) endUserName," +
                    " p.job_name as jobName," +
                    " customers.ext_customer_id as extCustomerId" +
                    " FROM projects_v2 p, customers" +
                    " WHERE p.project_id = ?" +
                    " AND p.customer_id = customers.customer_id";
    private static final String EMPTY_STRING = "";

    public HotSheet buildHotSheet(String requestId, Long userId, Long organizationId) {

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
        addOriginContactInfo(hotSheet);
        addBillingAddressInfo(hotSheet, organizationId);
        return hotSheet;
    }

    public HotSheet getHotSheet(String hotSheetNumber, Long userId, Long organizationId) {
        HotSheet hotSheet = (HotSheet) queryService.namedQueryForObject("hibernate.hotSheetByNumber",
                                                                        new String[]{"hotSheetNumber"},
                                                                        new String[]{hotSheetNumber});

        addOriginAddressInfo(hotSheet);
        addOriginContactInfo(hotSheet);
        addDestinationAddressInfo(hotSheet);
        addBillingAddressInfo(hotSheet, organizationId);
        Address jobLocationAddress = HotSheetServiceUtils.getInstance().getAddress(new BigDecimal(hotSheet.getJobLocationAddressId()));
        hotSheet.setJobLocationAddress(jobLocationAddress);

        initializeJobLocationContact(hotSheet, BigDecimal.valueOf(hotSheet.getJobLocationContactId()));

        Long createdById = hotSheet.getCreatedBy();
        String createdByName = getUserName(createdById);
        hotSheet.setCreatedByName(createdByName);

        Long modifiedById = hotSheet.getModifiedBy();
        String modifiedByName = getUserName(modifiedById);
        hotSheet.setModifiedByName(modifiedByName);

        Integer jobStartTime = hotSheet.getJobStartTime();
        hotSheet.setStartTimeHour(TimeUtils.getHour(jobStartTime));
        hotSheet.setStartTimeMinutes(TimeUtils.getMinutes(jobStartTime));
        hotSheet.setStartTimeAMPM(TimeUtils.getAMPM(jobStartTime));

        Integer warehouseStartTime = hotSheet.getWarehouseStartTime();
        hotSheet.setWarehouseStartTimeHour(TimeUtils.getHour(warehouseStartTime));
        hotSheet.setWarehouseStartTimeMinutes(TimeUtils.getMinutes(warehouseStartTime));
        hotSheet.setWarehouseStartTimeAMPM(TimeUtils.getAMPM(warehouseStartTime));

        Map<String, HotSheetDetail> details = hotSheet.getDetails();
        if (details == null || details.size() == 0) {
            details = getHotSheetDetails(userId);
            hotSheet.setDetails(details);
        }

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

    public static final String GET_JOB_LOCATION_ADDRESSES =
            "select JOB_LOCATION_ID, JOB_LOCATION_NAME, JOB_LOCATION_NAME, " +
                    " STREET1, STREET2, STREET3," +
                    " CITY, STATE, ZIP, COUNTRY" +
                    " from JOB_LOCATIONS where CUSTOMER_ID = ? order by JOB_LOCATION_ID DESC";

    @SuppressWarnings("unchecked")
    public void addOriginAddressInfo(HotSheet hotSheet) {

        List<Map> originAddresses = jdbcTemplate.queryForList(GET_JOB_LOCATION_ADDRESSES, new Object[]{hotSheet.getCustomerId()});

        if (originAddresses != null && originAddresses.size() > 0) {
            Address originAddress;
            BigDecimal id;
            if (hotSheet.getOriginAddressId() == null) {
                Map firstAddress = originAddresses.get(0);
                id = (BigDecimal) firstAddress.get("JOB_LOCATION_ID");
                hotSheet.setOriginAddressId(id.longValue());
            }
            else {
                id = BigDecimal.valueOf(hotSheet.getOriginAddressId());
            }

            originAddress = HotSheetServiceUtils.getInstance().getAddress(id);
            hotSheet.setOriginAddress(originAddress);
            List<Address> addresses = HotSheetServiceUtils.getInstance().convertToAddressList(originAddresses);
            hotSheet.setOriginAddresses(addresses);
        }
        else {
            hotSheet.setOriginAddress(new Address());
        }
    }

    @SuppressWarnings("unchecked")
    public void addDestinationAddressInfo(HotSheet hotSheet) {

        List<Map> destinationAddresses = jdbcTemplate.queryForList(GET_JOB_LOCATION_ADDRESSES, new Object[]{hotSheet.getEndUserId()});

        if (destinationAddresses != null && destinationAddresses.size() > 0) {
            Address destinationAddress;
            BigDecimal id;
            if (hotSheet.getOriginAddressId() == null) {
                Map firstAddress = destinationAddresses.get(0);
                id = (BigDecimal) firstAddress.get("JOB_LOCATION_ID");
                hotSheet.setJobLocationAddressId(id.longValue());
            }
            else {
                id = BigDecimal.valueOf(hotSheet.getJobLocationAddressId());
            }

            destinationAddress = HotSheetServiceUtils.getInstance().getAddress(id);
            hotSheet.setJobLocationAddress(destinationAddress);
            List<Address> addresses = HotSheetServiceUtils.getInstance().convertToAddressList(destinationAddresses);
            hotSheet.setDestinationAddresses(addresses);
        }
        else {
            hotSheet.setOriginAddress(new Address());
        }
    }


    public static final String GET_ORIGIN_CONTACT_INFO =
            "SELECT CONTACT_ID, CONTACT_NAME, PHONE_WORK, EMAIL FROM CONTACTS WHERE CUSTOMER_ID = ? ORDER BY CONTACT_ID DESC";


    @SuppressWarnings("unchecked")
    public void addOriginContactInfo(HotSheet hotSheet) {
        List<Map> originContacts =
                jdbcTemplate.queryForList(GET_ORIGIN_CONTACT_INFO, new Object[]{hotSheet.getCustomerId()});

        if (originContacts != null && originContacts.size() > 0) {
            BigDecimal id;
            if (hotSheet.getOriginContactId() == null) {
                Map firstContact = originContacts.get(0);
                id = (BigDecimal) firstContact.get("CONTACT_ID");
                hotSheet.setOriginAddressId(id.longValue());
                String name = (String) firstContact.get("CONTACT_NAME");
                hotSheet.setOriginContactName(name);
                String phone = (String) firstContact.get("PHONE_WORK");
                hotSheet.setOriginContactPhone(phone);
                String email = (String) firstContact.get("EMAIL");
                hotSheet.setOriginContactEmail(email);
            }
        }
        else {
            hotSheet.setOriginContactName(EMPTY_STRING);
            hotSheet.setOriginContactPhone(EMPTY_STRING);
        }

        if (originContacts != null) {
            List<KeyValueBean> contacts = new ArrayList<KeyValueBean>(originContacts.size());
            for (Map aRow : originContacts) {
                KeyValueBean aBean = new KeyValueBean(aRow.get("CONTACT_ID"), aRow.get("CONTACT_NAME"));
                contacts.add(aBean);
            }
            hotSheet.setOriginContacts(contacts);
        }
        else {
            hotSheet.setOriginContacts(Collections.EMPTY_LIST);
        }
    }

    public void addDestinationContactInfo(HotSheet hotSheet) {
        initializeJobLocationContact(hotSheet, new BigDecimal(hotSheet.getJobLocationContactId()));
    }


    private void addBillingAddressInfo(HotSheet hotSheet, Long organizationId) {

        List billingAddress = getBillingAddress(String.valueOf(hotSheet.getExtCustomerId()), organizationId);
        if (billingAddress == null || billingAddress.size() == 0) {
            hotSheet.setBillingAddress(getEmptyAddress());
            return;
        }
        hotSheet.setBillingAddress((Address) billingAddress.get(0));
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

    private static final String GET_HOT_SHEET_NUMBER = "select max(hotsheet_no) as hotSheetNo from hotsheets where request_id = ?";

    public synchronized Integer getNextHotSheetNumberForRequest(String requestId) {
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
                    " requests.DEALER_PO_NO," +
                    " requests.DESCRIPTION," +
                    " requests.CUSTOMER_CONTACT_ID," +
                    " requests.DATE_CREATED," +
                    " requests.CREATED_BY," +
                    " requests.DATE_MODIFIED," +
                    " requests.MODIFIED_BY," +
                    " requests.A_M_SALES_CONTACT_ID," +
                    " projects.PROJECT_NO as projectNo," +
                    " originContact.phone_work as originPhone," +
                    " originContact.contact_name as originName," +
                    " salesContact.contact_name as salesName," +
                    " salesContact.phone_work as salesPhone" +
                    " from requests, projects, contacts originContact, contacts salesContact" +
                    " where projects.project_id = requests.project_id" +
                    " and originContact.contact_id = requests.customer_contact_id" +
                    " and salesContact.contact_id = requests.a_m_sales_contact_id" +
                    " and requests.request_id = ?";

    @SuppressWarnings("unchecked")
    private void addRequestInfo(HotSheet hotSheet, String requestId, Integer hotSheetNumber) {

        List list = jdbcTemplate.queryForList(GET_HOT_SHEET_ID_INFO, new Object[]{requestId});
        Map row = (Map) list.get(0);

        // Build hotsheet id
        StringBuilder buf = new StringBuilder();
        buf.append(row.get("projectNo"));
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
        Address jobLocationAddress = HotSheetServiceUtils.getInstance().getAddress((BigDecimal) row.get("jobLocationAddressId"));
        hotSheet.setJobLocationAddress(jobLocationAddress);
        List<Map> destinationAddressRows = jdbcTemplate.queryForList(GET_JOB_LOCATION_ADDRESSES, new Object[]{hotSheet.getEndUserId()});
        List<Address> destinationAddresses = HotSheetServiceUtils.getInstance().convertToAddressList(destinationAddressRows);
        hotSheet.setDestinationAddresses(destinationAddresses);

        initializeJobLocationContact(hotSheet, (BigDecimal) row.get("jobLocationContactId"));

        BigDecimal contactId = (BigDecimal) row.get("CUSTOMER_CONTACT_ID");
        hotSheet.setOriginContactId(contactId.longValue());
        hotSheet.setOriginContactName((String) row.get("originName"));
        hotSheet.setOriginContactPhone((String) row.get("originPhone"));

        BigDecimal amSalesContactId = (BigDecimal) row.get("A_M_SALES_CONTACT_ID");
        hotSheet.setSalesContactId(amSalesContactId.longValue());
        hotSheet.setSalesContactName((String) row.get("salesName"));
        hotSheet.setSalesContactPhone((String) row.get("salesPhone"));
    }

    public static final String GET_DESTINATION_CONTACT_INFO =
            "SELECT C.CONTACT_ID, CONTACT_NAME, PHONE_WORK, EMAIL" +
                    " FROM CONTACTS C" +
                    " INNER JOIN JOB_LOCATION_CONTACTS JLC ON C.CONTACT_ID=JLC.CONTACT_ID" +
                    " INNER JOIN LOOKUPS L ON C.CONT_STATUS_TYPE_ID = L.LOOKUP_ID" +
                    " WHERE L.CODE='ACTIVE'" +
                    " AND C.CONTACT_NAME IS NOT NULL" +
                    " AND C.CONTACT_NAME NOT LIKE '%N/A%'" +
                    " AND C.CONTACT_NAME <> 'NA'" +
                    " AND JLC.JOB_LOCATION_ID = ?" +
                    " ORDER BY C.CONTACT_ID DESC";

    @SuppressWarnings("unchecked")
    private void initializeJobLocationContact(HotSheet hotSheet, BigDecimal jobLocationContactId) {

        List<Map> destinationContacts =
                jdbcTemplate.queryForList(GET_DESTINATION_CONTACT_INFO, new Object[]{hotSheet.getJobLocationAddressId()});

        List<KeyValueBean> contacts;

        if (destinationContacts != null && destinationContacts.size() > 0) {
            for (Map aRow : destinationContacts) {
                BigDecimal id = (BigDecimal) aRow.get("CONTACT_ID");
                if (jobLocationContactId.equals(id)) {
                    id = (BigDecimal) aRow.get("CONTACT_ID");
                    hotSheet.setJobLocationContactId(id.longValue());
                    String name = (String) aRow.get("CONTACT_NAME");
                    hotSheet.setJobContactName(name);
                    String phone = (String) aRow.get("PHONE_WORK");
                    hotSheet.setJobContactPhone(phone);
                    String email = (String) aRow.get("EMAIL");
                    hotSheet.setJobContactEmail(email);
                }
            }

            contacts = new ArrayList<KeyValueBean>(destinationContacts.size());
            for (Map aRow : destinationContacts) {
                KeyValueBean aBean = new KeyValueBean(aRow.get("CONTACT_ID"), aRow.get("CONTACT_NAME"));
                contacts.add(aBean);
            }
        }
        else {

            // Use the one from the request
            List jobLocationContact =
                    jdbcTemplate.queryForList("SELECT CONTACT_ID, CONTACT_NAME, EMAIL, PHONE_WORK, PHONE_CELL, PHONE_HOME FROM CONTACTS WHERE CONTACT_ID = ? ",
                                              new Object[]{jobLocationContactId});
            Map aRow = (Map) jobLocationContact.get(0);
            hotSheet.setJobContactName((String) aRow.get("CONTACT_NAME"));
            hotSheet.setJobContactEmail((String) aRow.get("EMAIL"));
            hotSheet.setJobContactPhone((String) aRow.get("PHONE_WORK"));
            hotSheet.setJobLocationContactId(jobLocationContactId.longValue());

            contacts = new ArrayList<KeyValueBean>(1);
            KeyValueBean aBean = new KeyValueBean(aRow.get("CONTACT_ID"), aRow.get("CONTACT_NAME"));
            contacts.add(aBean);
        }
        hotSheet.setDestinationAddressContacts(contacts);
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

    private static final String CHECK_HOTSHEET_NUMBER =
            "SELECT COUNT(*) FROM HOTSHEETS WHERE HOTSHEET_NO = ? AND REQUEST_ID = ?";

    public synchronized HotSheet saveHotSheet(HotSheet hotsheet) {


        if (hotsheet.getHotSheetId() == null) {
            int count = jdbcTemplate.queryForInt(CHECK_HOTSHEET_NUMBER,
                                                 new Object[]{hotsheet.getHotSheetNumber(),
                                                         hotsheet.getRequestId()});
            if (count > 0) {
                Integer newHotSheetNumber =
                        getNextHotSheetNumberForRequest(String.valueOf(hotsheet.getRequestId()));
                hotsheet.setHotSheetNumber(newHotSheetNumber);
                String existingIdentifier = hotsheet.getHotSheetIdentifier();
                String truncated = existingIdentifier.substring(0, existingIdentifier.indexOf("HS") + 2);
                hotsheet.setHotSheetIdentifier(truncated + newHotSheetNumber);
            }
        }


        HotSheet persisted = (HotSheet) hibernateService.saveOrUpdate(hotsheet);

        Map<String, HotSheetDetail> details = persisted.getDetails();
        if (details != null) {
            Set<String> keys = details.keySet();
            for (String aKey : keys) {
                HotSheetDetail aDetail = details.get(aKey);
                aDetail.setHotSheet(hotsheet);
                aDetail.setCreatedBy(hotsheet.getCreatedBy());
            }
            hibernateService.saveOrUpdateAll(details.values());
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
    public void setQueryService(QueryService queryService) {
        this.queryService = queryService;
    }

    @SuppressWarnings("unused")
    public void setMessageSource(MessageSource messageSource) {
        this.messageSource = messageSource;
    }

    public void convertStartTimesToMilitary(HttpServletRequest request, HotSheet hotSheet) {

        Map map = request.getParameterMap();
        int startTime =
                TimeUtils.getTimeAsMilitaryTime(Integer.valueOf(HotSheetServiceUtils.getInstance().getValue(map.get("startTimeHour"))),
                                                Integer.valueOf(HotSheetServiceUtils.getInstance().getValue(map.get("startTimeMinutes"))),
                                                HotSheetServiceUtils.getInstance().getValue(map.get("startTimeAMPM")));
        hotSheet.setJobStartTime(startTime);

        int warehouseStartTime =
                TimeUtils.getTimeAsMilitaryTime(Integer.valueOf(HotSheetServiceUtils.getInstance().getValue(map.get("warehouseStartTimeHour"))),
                                                Integer.valueOf(HotSheetServiceUtils.getInstance().getValue(map.get("warehouseStartTimeMinutes"))),
                                                HotSheetServiceUtils.getInstance().getValue(map.get("warehouseStartTimeAMPM")));
        hotSheet.setWarehouseStartTime(warehouseStartTime);
    }

    public Map<String, HotSheetDetail> getNewHotSheetDetails() {
        return getHotSheetDetails(null);
    }

    @SuppressWarnings("unchecked")
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


    private static final String GET_DB_PREFIX = "SELECT DB_PREFIX FROM ORGANIZATIONS WHERE ORGANIZATION_ID = ?";

    public List getBillingAddress(String extCustomerId, Long organizationId) {

        if (extCustomerId == null || extCustomerId.trim().length() == 0) {
            return Collections.EMPTY_LIST;
        }

        String prefix = getDbPrefixForOrganization(organizationId);

        if (prefix == null || prefix.trim().length() == 0) {
            LOGGER.warn("No database prefix found for id " + organizationId);
            return Collections.EMPTY_LIST;
        }

        try {
            return jdbcTemplate.query("exec " + prefix + "ott_spGetPrimaryAddress " + extCustomerId,
                                      new RowMapper() {
                                          public Object mapRow(ResultSet resultSet, int i) throws SQLException {
                                              Address address = new Address();
                                              address.setJobLocationName(getStringValue(resultSet, "CNTCPRSN"));
                                              address.setStreetOne(getStringValue(resultSet, "ADDRESS1"));
                                              address.setStreetTwo(getStringValue(resultSet, "ADDRESS2"));
                                              address.setCity(getStringValue(resultSet, "CITY"));
                                              address.setState(getStringValue(resultSet, "STATE"));
                                              address.setZip(getStringValue(resultSet, "ZIP"));
                                              address.setCountry(getStringValue(resultSet, "COUNTRY"));
                                              return address;
                                          }
                                      });
        }
        catch (DataAccessException e) {
            LOGGER.error(e);
            LOGGER.error("Check to see if stored procedure is present in the " + prefix + " database.");
            return Collections.EMPTY_LIST;
        }
    }

    public String getDbPrefixForOrganization(Long organizationId) {
        String prefix = (String) jdbcTemplate.queryForObject(GET_DB_PREFIX, new Object[]{organizationId}, String.class);
        if (prefix == null || prefix.length() == 0) {
            return EMPTY_STRING;
        }
        return prefix.toUpperCase();
    }

    private String getStringValue(ResultSet resultSet, String columnName) throws SQLException {
        String theString = resultSet.getString(columnName);
        if (theString == null || theString.length() == 0) {
            return EMPTY_STRING;
        }
        return theString.trim();
    }

    public List<String> buildErrors(List<FieldError> allErrors) {

        List<String> errorMessages = new ArrayList<String>();
        for (FieldError anError : allErrors) {
            String anErrorMessage = messageSource.getMessage(anError, Locale.getDefault());
            errorMessages.add(anErrorMessage);
        }
        return errorMessages;
    }

    public void updateHotSheetIdentifier(HotSheet hotSheet, Integer hotSheetNumber) {
        hotSheet.setHotSheetNumber(hotSheetNumber);
        String hotSheetIdentifier = hotSheet.getHotSheetIdentifier();
        int index = hotSheetIdentifier.lastIndexOf("HS");
        String substring = hotSheetIdentifier.substring(0, index + 2);
        hotSheet.setHotSheetIdentifier(substring + hotSheetNumber);
    }


    private Address getEmptyAddress() {
        Address emptyAddress = new Address();
        emptyAddress.setJobLocationCustomerId(String.valueOf("0"));
        emptyAddress.setJobLocationName(EMPTY_STRING);
        emptyAddress.setStreetOne(EMPTY_STRING);
        emptyAddress.setStreetTwo(EMPTY_STRING);
        emptyAddress.setCity(EMPTY_STRING);
        emptyAddress.setState(EMPTY_STRING);
        emptyAddress.setZip(EMPTY_STRING);
        return emptyAddress;
    }

    private class ProjectInfoMapper implements RowMapper {

        public Object mapRow(ResultSet resultSet, int i) throws SQLException {
            HotSheet hotSheet = new HotSheet();
            BigDecimal customerId = resultSet.getBigDecimal("customerId");
            if (customerId != null) {
                hotSheet.setCustomerId(customerId.longValue());
                hotSheet.setExtCustomerId(resultSet.getString("extCustomerId"));
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

    public List getEquipmentList() {
        return HotSheetServiceUtils.EQUIPMENT;
    }
}
