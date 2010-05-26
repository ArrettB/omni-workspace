package com.dynamic.servicetrax.service;

import com.dynamic.charm.query.hibernate.HibernateService;
import com.dynamic.servicetrax.orm.Address;
import com.dynamic.servicetrax.orm.JobLocation;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.AbstractTransactionalSpringContextTests;

/**
 * User: pgarvie
 * Date: May 25, 2010
 * Time: 2:38:18 PM
 */
public class HotSheetServiceTest extends AbstractTransactionalSpringContextTests {

    private HibernateService hibernateService;
    private JdbcTemplate jdbcTemplate;
    private HotSheetService hotSheetService;


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
