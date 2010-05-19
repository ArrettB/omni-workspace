package com.dynamic.servicetrax.domain;

import com.dynamic.charm.query.hibernate.HibernateService;
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

    private static final String STREET_ONE = "123 Main Street";
    private static final String PROJECT_NAME = "My Project";
    private static final Integer JOB_LENGTH = 8;

    public void testPersistingDetails() {

        hibernateService = (HibernateService) applicationContext.getBean("hibernateService");
        HotSheet hotsheet = createHotSheet();

        HotSheetService hotSheetService = new HotSheetService();
        hotSheetService.setJdbcTemplate(jdbcTemplate);
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
        assertEquals(STREET_ONE, persisted.getStreetOne());
        assertEquals(PROJECT_NAME, persisted.getProjectName());

        List persistedDetails = hibernateService.findAll(HotSheetDetail.class);
        assertTrue(persistedDetails != null);
        List control = jdbcTemplate.queryForList(HotSheetService.GET_HOTSHEET_LOOKUPS);
        assertTrue(control != null && control.size() == persistedDetails.size());
    }


    public void testPersistance() {

        hibernateService = (HibernateService) applicationContext.getBean("hibernateService");
        HotSheet hotsheet = createHotSheet();
        hibernateService.saveOrUpdate(hotsheet);
        HotSheet persisted = (HotSheet) hibernateService.get(HotSheet.class, hotsheet.getHotSheetId());
        assertEquals(JOB_LENGTH, persisted.getJobLength());
        assertEquals(STREET_ONE, persisted.getStreetOne());
        assertEquals(PROJECT_NAME, persisted.getProjectName());

        persisted.setStreetOne("321 Cherry Blossom Lane");
        persisted.setCity("Duluth");
        persisted.setJobLength(6);

        hibernateService.saveOrUpdate(persisted);

        persisted = (HotSheet) hibernateService.get(HotSheet.class, hotsheet.getHotSheetId());
        assertEquals((Integer) 6, persisted.getJobLength());
        assertEquals("Duluth", persisted.getCity());
        assertEquals("321 Cherry Blossom Lane", persisted.getStreetOne());
    }


    private static final String GET_REQUEST = "select REQUEST_ID, PROJECT_ID, JOB_LOCATION_CONTACT_ID " +
            " from requests where request_id = (select max(request_id) from requests)";

    private HotSheet createHotSheet() {

        Date today = new Date();

        List rows = jdbcTemplate.queryForList(GET_REQUEST);
        assertTrue(rows != null && rows.size() > 0);
        Map row = (Map) rows.get(0);
        HotSheet hotSheet = new HotSheet();

        hotSheet.setRequestId(convertToLong(row.get("REQUEST_ID")));
        hotSheet.setProjectId(convertToLong(row.get("PROJECT_ID")));
        hotSheet.setJobLocationContactId(convertToLong(row.get("JOB_LOCATION_CONTACT_ID")));

        hotSheet.setOriginAddressId(0L);
        hotSheet.setBillingAddressId(0L);

        hotSheet.setProjectName(PROJECT_NAME);
        hotSheet.setCustomerName("My Customer");
        hotSheet.setEndUserName("My End User");

        hotSheet.setHotSheetNumber(2);
        hotSheet.setHotSheetIdentifier("My Hot Sheet");

        hotSheet.setStreetOne(STREET_ONE);
        hotSheet.setCity("Riverdale");
        hotSheet.setState("OH");
        hotSheet.setZip("OH");
        hotSheet.setCountry("US");

        hotSheet.setJobDate(today);
        hotSheet.setJobStartTime(900);
        hotSheet.setWarehouseStartTime(800);
        hotSheet.setJobLength(JOB_LENGTH);
        hotSheet.setJobLocationName("My Location");

        hotSheet.setCreatedBy(0L);
        hotSheet.setDateCreated(today);
        hotSheet.setModifiedBy(0L);
        hotSheet.setDateModified(today);
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
}