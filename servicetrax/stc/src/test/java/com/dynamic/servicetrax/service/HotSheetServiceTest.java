package com.dynamic.servicetrax.service;

import com.dynamic.charm.query.hibernate.HibernateService;
import com.dynamic.servicetrax.orm.Address;
import com.dynamic.servicetrax.orm.JobLocation;
import com.dynamic.servicetrax.util.TimeUtils;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.AbstractTransactionalSpringContextTests;

import java.util.List;

/**
 * User: pgarvie
 * Date: May 25, 2010
 * Time: 2:38:18 PM
 */
public class HotSheetServiceTest extends AbstractTransactionalSpringContextTests {

    private HibernateService hibernateService;
    private JdbcTemplate jdbcTemplate;
    private HotSheetService hotSheetService;

    public void testBillingAddressStoredProcedure() {

        String customerId = "FakeCustomerId";
        List addresses = hotSheetService.getBillingAddress(customerId);
        assertTrue(addresses != null && addresses.size() == 0);

        addresses = hotSheetService.getBillingAddress("       ");
        assertTrue(addresses != null && addresses.size() == 0);

        addresses = hotSheetService.getBillingAddress(null);
        assertTrue(addresses != null && addresses.size() == 0);

        addresses = hotSheetService.getBillingAddress("");
        assertTrue(addresses != null && addresses.size() == 0);
    }


    /**
     * Prerequisites: hours are from 12 to 11; minutes are 00, 15, 30 and 45
     */
    public void testConvertMilitaryToStandardTime() {

        int military = 1145;
        assertEquals(TimeUtils.getHour(military), "11");
        assertEquals(TimeUtils.getMinutes(military), "45");
        assertEquals("AM", TimeUtils.getAMPM(military));

        military = 2345;
        assertEquals(TimeUtils.getHour(military), "11");
        assertEquals(TimeUtils.getMinutes(military), "45");
        assertEquals("PM", TimeUtils.getAMPM(military));

        military = 800;
        assertEquals(TimeUtils.getHour(military), "8");
        assertEquals(TimeUtils.getMinutes(military), "00");
        assertEquals("AM", TimeUtils.getAMPM(military));

        military = 2000;
        assertEquals(TimeUtils.getHour(military), "8");
        assertEquals(TimeUtils.getMinutes(military), "00");
        assertEquals("PM", TimeUtils.getAMPM(military));

        military = 1215;
        assertEquals(TimeUtils.getHour(military), "12");
        assertEquals(TimeUtils.getMinutes(military), "15");
        assertEquals("PM", TimeUtils.getAMPM(military));

        military = 0;
        assertEquals(TimeUtils.getHour(military), "12");
        assertEquals(TimeUtils.getMinutes(military), "00");
        assertEquals("AM", TimeUtils.getAMPM(military));

        military = 1330;
        assertEquals(TimeUtils.getHour(military), "1");
        assertEquals(TimeUtils.getMinutes(military), "30");
        assertEquals("PM", TimeUtils.getAMPM(military));

        military = 130;
        assertEquals(TimeUtils.getHour(military), "1");
        assertEquals(TimeUtils.getMinutes(military), "30");
        assertEquals("AM", TimeUtils.getAMPM(military));

        military = 30;
        assertEquals(TimeUtils.getHour(military), "12");
        assertEquals(TimeUtils.getMinutes(military), "30");
        assertEquals("AM", TimeUtils.getAMPM(military));

        military = 1200;
        assertEquals(TimeUtils.getHour(military), "12");
        assertEquals(TimeUtils.getMinutes(military), "00");
        assertEquals("PM", TimeUtils.getAMPM(military));

        military = 100;
        assertEquals(TimeUtils.getHour(military), "1");
        assertEquals(TimeUtils.getMinutes(military), "00");
        assertEquals("AM", TimeUtils.getAMPM(military));
    }


    public void testJobLocationAddressInsert() {
        Address address = new Address();
        address.setJobLocationCustomerId("123");
        address.setJobLocationName("JobLocationName");
        address.setStreetOne("Street One");
        address.setCity("City");
        address.setState("MN");
        address.setZip("12345");
        address.setCountry("US");
        hotSheetService.addJobLocationAddress(address, 123L);
        long id = jdbcTemplate.queryForLong("select max(JOB_LOCATION_ID) from JOB_LOCATIONS");
        JobLocation location = (JobLocation) hibernateService.get(JobLocation.class, id);
        assertEquals(Long.valueOf(address.getJobLocationCustomerId()), location.getCustomer().getCustomerId());
        assertEquals(address.getCity(), location.getCity());
        assertEquals(address.getJobLocationName(), location.getJobLocationName());
    }

//    public void testHotSheetQuery() {
//        Address address = new Address();
//        address.setJobLocationCustomerId("123");
//        address.setJobLocationName("JobLocationName");
//        address.setStreetOne("Street One");
//        address.setCity("City");
//        address.setState("MN");
//        address.setZip("12345");
//        address.setCountry("US");
//        hotSheetService.addJobLocationAddress(address, 123L);
//        long id = jdbcTemplate.queryForLong("select max(JOB_LOCATION_ID) from JOB_LOCATIONS");
//        JobLocation location = (JobLocation) hibernateService.get(JobLocation.class, id);
//        assertEquals(Long.valueOf(address.getJobLocationCustomerId()), location.getCustomer().getCustomerId());
//        assertEquals(address.getCity(), location.getCity());
//        assertEquals(address.getJobLocationName(), location.getJobLocationName());
//    }

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
