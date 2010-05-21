package com.dynamic.servicetrax.domain;

import com.dynamic.charm.query.hibernate.HibernateService;
import com.dynamic.servicetrax.orm.Address;
import com.dynamic.servicetrax.orm.HotSheet;
import com.dynamic.servicetrax.orm.HotSheetDetail;
import com.dynamic.servicetrax.service.HotSheetService;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.AbstractTransactionalSpringContextTests;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * User: pgarvie
 * Date: May 14, 2010
 * Time: 11:27:48 AM
 */
public class HotSheetTest extends AbstractTransactionalSpringContextTests {

    private HibernateService hibernateService;
    private JdbcTemplate jdbcTemplate;
    private HotSheetService hotSheetService;

    private static final String PROJECT_NAME = "My Project";
    private static final Integer JOB_LENGTH = 8;

    public void testPersistingDetails() {

        hibernateService = (HibernateService) applicationContext.getBean("hibernateService");
        HotSheet hotsheet = createHotSheet();

        hibernateService.saveOrUpdate(hotsheet);

        Map<String, HotSheetDetail> details = hotSheetService.getHotSheetDetails(1L);
        Set<String> keys = details.keySet();
        for (String aKey : keys) {
            HotSheetDetail aDetail = details.get(aKey);
            aDetail.setHotSheet(hotsheet);
            hibernateService.saveOrUpdate(aDetail);
        }
        hotsheet.setDetails(details);

        HotSheet persisted = (HotSheet) hibernateService.get(HotSheet.class, hotsheet.getHotSheetId());
        assertEquals(JOB_LENGTH, persisted.getJobLength());
        assertEquals(PROJECT_NAME, persisted.getProjectName());

        int persistedDetailCount =
                jdbcTemplate.queryForInt("select count(*) from hotsheet_details where hotsheet_id = ?", new Object[]{persisted.getHotSheetId()});

        List control = jdbcTemplate.queryForList(HotSheetService.GET_HOTSHEET_LOOKUPS);
        assertTrue(control != null && control.size() == persistedDetailCount);

        List rows = jdbcTemplate.queryForList(HotSheetService.SELECT_ADDRESS, new Object[]{hotsheet.getJobLocationAddressId()});
        assertTrue(rows != null && rows.size() == 1);
        Map address = (Map) rows.get(0);
        assertEquals(address.get("JOB_LOCATION_NAME"), hotsheet.getJobLocationAddress().getJobLocationName());
        assertEquals(address.get("CITY"), hotsheet.getJobLocationAddress().getCity());
        assertEquals(address.get("STREET1"), hotsheet.getJobLocationAddress().getStreetOne());
    }


    public void testPersistance() {

        hibernateService = (HibernateService) applicationContext.getBean("hibernateService");
        HotSheet hotsheet = createHotSheet();
        hibernateService.saveOrUpdate(hotsheet);
        HotSheet persisted = (HotSheet) hibernateService.get(HotSheet.class, hotsheet.getHotSheetId());
        assertEquals(JOB_LENGTH, persisted.getJobLength());
        assertEquals(PROJECT_NAME, persisted.getProjectName());

        persisted.setJobLength(6);

        hibernateService.saveOrUpdate(persisted);

        persisted = (HotSheet) hibernateService.get(HotSheet.class, hotsheet.getHotSheetId());
        assertEquals((Integer) 6, persisted.getJobLength());
        assertEquals("foobar", persisted.getRequestModifiedName());
        assertNull(persisted.getRequestCreatedName());
        assertNull(persisted.getModifiedBy());
        assertEquals(0, persisted.getCreatedBy().intValue());

        List rows = jdbcTemplate.queryForList(HotSheetService.SELECT_ADDRESS, new Object[]{hotsheet.getJobLocationAddressId()});
        assertTrue(rows != null && rows.size() == 1);
        Map address = (Map) rows.get(0);
        assertEquals(address.get("STATE"), hotsheet.getJobLocationAddress().getState());
        assertEquals(address.get("STREET1"), hotsheet.getJobLocationAddress().getStreetOne());

    }

    private static final String GET_REQUEST = "select REQUEST_ID, PROJECT_ID, JOB_LOCATION_CONTACT_ID " +
            " from requests where request_id = (select max(request_id) from requests)";

    private static final String GET_JOB_LOCATION_ADDRESS = "select max(JOB_LOCATION_ID) from JOB_LOCATIONS";

    private HotSheet createHotSheet() {

        Date today = new Date();

        List rows = jdbcTemplate.queryForList(GET_REQUEST);
        assertTrue(rows != null && rows.size() > 0);
        Map row = (Map) rows.get(0);
        HotSheet hotSheet = new HotSheet();

        hotSheet.setRequestId(convertToLong(row.get("REQUEST_ID")));
        hotSheet.setProjectId(convertToLong(row.get("PROJECT_ID")));
        hotSheet.setJobLocationContactId(convertToLong(row.get("JOB_LOCATION_CONTACT_ID")));

        rows = jdbcTemplate.queryForList(HotSheetService.GET_PROJECT_INFO,
                                         new Object[]{hotSheet.getProjectId()});

        assertTrue(rows != null && rows.size() > 0);
        row = (Map) rows.get(0);
        hotSheet.setCustomerId(convertToLong(row.get("customerId")));
        hotSheet.setEndUserId(convertToLong(row.get("endUserId")));

        hotSheet.setOriginAddressId(0L);
        hotSheet.setBillingAddressId(0L);

        hotSheet.setProjectName(PROJECT_NAME);
        hotSheet.setCustomerName("My Customer");
        hotSheet.setEndUserName("My End User");

        hotSheet.setHotSheetNumber(2);
        hotSheet.setHotSheetIdentifier("My Hot Sheet");

        BigDecimal id = (BigDecimal) jdbcTemplate.queryForObject(GET_JOB_LOCATION_ADDRESS, BigDecimal.class);
        hotSheet.setJobLocationAddressId(id.longValue());
        Address address = hotSheetService.getAddress(id);
        hotSheet.setJobLocationAddress(address);

        hotSheet.setJobDate(today);
        hotSheet.setJobStartTime(900);
        hotSheet.setWarehouseStartTime(800);
        hotSheet.setJobLength(JOB_LENGTH);

        hotSheet.setCreatedBy(0L);
        hotSheet.setDateCreated(today);

        hotSheet.setRequestCreatedDate(today);
        hotSheet.setRequestModifiedName("foobar");
        return hotSheet;
    }

    private Long convertToLong(Object value) {
        return ((BigDecimal) value).longValue();
    }

    @Override
    protected String[] getConfigLocations() {
        return new String[]{"applicationContext-test.xml"};
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
    public void setHotSheetService(HotSheetService hotSheetService) {
        this.hotSheetService = hotSheetService;
    }
}