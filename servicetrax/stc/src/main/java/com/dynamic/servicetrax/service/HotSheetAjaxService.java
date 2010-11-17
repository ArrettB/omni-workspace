package com.dynamic.servicetrax.service;

import com.dynamic.servicetrax.orm.Address;
import org.apache.log4j.Logger;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.orm.hibernate3.HibernateTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallbackWithoutResult;
import org.springframework.transaction.support.TransactionTemplate;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * User: pgarvie
 * Date: Nov 6, 2010
 * Time: 2:57:05 PM
 */
public class HotSheetAjaxService {

    private static final Logger LOGGER = Logger.getLogger(HotSheetAjaxService.class);
    private JdbcTemplate jdbcTemplate;
    private TransactionTemplate transactionTemplate;

    public static final String ADD_JOB_LOCATION_ADDRESS =
            "INSERT INTO job_locations (customer_id, job_location_name, location_type_id, street1, street2," +
                    " city, state, zip, country, date_created, created_by)" +
                    " SELECT ?, ?, l.lookup_id, ?, ?, ?, ?, ?, ?, ?, ?" +
                    " FROM lookups l JOIN lookup_types lt ON l.lookup_type_id = lt.lookup_type_id" +
                    " WHERE lt.code='location_type' AND l.code = 'worksite'";

    public void addAddress(Address address, long userId) {
        jdbcTemplate.update(ADD_JOB_LOCATION_ADDRESS, new Object[]
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

    public static final String ADD_ORIGIN_CONTACT =
            "INSERT INTO contacts (contact_name, organization_id, cont_status_type_id," +
                    " customer_id, phone_work, ext_dealer_id, date_created, created_by)" +
                    " SELECT ?, ?, l.lookup_id, ?, ?, ?, ?, ?" +
                    " FROM lookups l INNER JOIN lookup_types lt ON l.lookup_type_id = lt.lookup_type_id" +
                    " WHERE l.code='active' AND lt.code='contact_status_type'";

    public void addNewOriginContact(Map parameterMap, Long userId, long organizationId) {

        try {
            String name = HotSheetServiceUtils.getInstance().getValue(parameterMap.get("contactName"));
            String customerId = HotSheetServiceUtils.getInstance().getValue(parameterMap.get("customerId"));
            String phone = HotSheetServiceUtils.getInstance().getValue(parameterMap.get("contactPhone"));
            String extDealerId = HotSheetServiceUtils.getInstance().getValue(parameterMap.get("extDealerId"));

            jdbcTemplate.update(ADD_ORIGIN_CONTACT, new Object[]
                    {
                            name,
                            organizationId,
                            customerId,
                            phone,
                            extDealerId,
                            new Date(),
                            userId
                    });
        }
        catch (DataAccessException e) {
            LOGGER.error(e);
        }
    }

    private static final String ADD_DESTINATION_CONTACT =
            "INSERT INTO contacts (contact_name," +
                    " phone_work," +
                    " organization_id," +
                    " ext_dealer_id," +
                    " cont_status_type_id," +
                    " contact_type_id," +
                    " date_created," +
                    " created_by)" +
                    " SELECT ?, ?, ?, ?, l.lookup_id, ?, ?, ?" +
                    " FROM lookups l INNER JOIN lookup_types lt ON l.lookup_type_id = lt.lookup_type_id" +
                    " WHERE l.code='active' AND lt.code='contact_status_type'";

    private static final String ADD_JOB_LOCATION_CONTACT =
            "INSERT INTO job_location_contacts (job_location_id, " +
                    " contact_id," +
                    " date_created," +
                    " created_by)" +
                    " VALUES (?, ?, ?, ?)";


    public void addNewDestinationContact(Map parameterMap, final Long userId, final long organizationId) {

        final String name = HotSheetServiceUtils.getInstance().getValue(parameterMap.get("contactName"));
        final String phone = HotSheetServiceUtils.getInstance().getValue(parameterMap.get("contactPhone"));
        final String extDealerId = HotSheetServiceUtils.getInstance().getValue(parameterMap.get("extDealerId"));
        final String contactTypeId = "138";//HotSheetServiceUtils.getInstance().getValue(parameterMap.get("contactTypeId"));
        final String jobLocationAddressId = HotSheetServiceUtils.getInstance().getValue(parameterMap.get("newJobLocationAddressId"));

        transactionTemplate.execute(new TransactionCallbackWithoutResult() {
            public void doInTransactionWithoutResult(TransactionStatus status) {

                Date today = new Date();
                try {
                    jdbcTemplate.update(ADD_DESTINATION_CONTACT, new Object[]{
                            name,
                            phone,
                            organizationId,
                            extDealerId,
                            contactTypeId,
                            today,
                            userId
                    });

                    Integer destinationContactId = jdbcTemplate.queryForInt("SELECT @@IDENTITY current_id");

                    jdbcTemplate.update(ADD_JOB_LOCATION_CONTACT, new Object[]{
                            jobLocationAddressId,
                            destinationContactId,
                            today,
                            userId
                    });
                }
                catch (DataAccessException e) {
                    LOGGER.error(e);
                    status.setRollbackOnly();
                }
            }
        });
    }


    public static final String SELECT_CONTACT =
            "SELECT CONTACT_ID, CONTACT_NAME, PHONE_WORK, EMAIL from CONTACTS where CONTACT_ID = ?";

    public Map getContact(BigDecimal originContactId) {

        List contact = jdbcTemplate.queryForList(SELECT_CONTACT,
                                                 new Object[]{originContactId});
        if (contact == null) {
            return null;
        }

        return (Map) contact.get(0);
    }

    @SuppressWarnings("unchecked")
    public List<Address> getUpdatedAddresses(String customerId) {

        if (customerId == null) {
            return Collections.EMPTY_LIST;
        }

        List<Map> addresses = jdbcTemplate.queryForList(HotSheetService.GET_JOB_LOCATION_ADDRESSES, new Object[]{Long.valueOf(customerId)});
        if (addresses != null && addresses.size() > 0) {
            return HotSheetServiceUtils.getInstance().convertToAddressList(addresses);
        }
        return Collections.EMPTY_LIST;
    }

    @SuppressWarnings("unchecked")
    public List<Map> getOriginContacts(Map map) {
        String customerId = HotSheetServiceUtils.getInstance().getValue(map.get("customerId"));
        if (customerId == null || customerId.trim().length() == 0) {
            return Collections.EMPTY_LIST;
        }
        return jdbcTemplate.queryForList(HotSheetService.GET_ORIGIN_CONTACT_INFO, new Object[]{customerId});
    }

    public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @SuppressWarnings("unused")
    public void setTransactionManager(HibernateTransactionManager transactionManager) {
        transactionTemplate = new TransactionTemplate(transactionManager);
    }

    @SuppressWarnings("unchecked")
    public List<Map> getDestinationContacts(String jobLocationAddressId) {
        if (jobLocationAddressId == null || jobLocationAddressId.trim().length() == 0) {
            return Collections.EMPTY_LIST;
        }
        return jdbcTemplate.queryForList(HotSheetService.GET_DESTINATION_CONTACT_INFO, new Object[]{jobLocationAddressId});
    }
}
