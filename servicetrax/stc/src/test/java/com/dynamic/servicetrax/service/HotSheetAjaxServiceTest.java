package com.dynamic.servicetrax.service;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.AbstractDependencyInjectionSpringContextTests;

import java.util.HashMap;
import java.util.Map;

/**
 * User: pgarvie
 * Date: Nov 14, 2010
 * Time: 12:55:52 PM
 */
public class HotSheetAjaxServiceTest extends AbstractDependencyInjectionSpringContextTests {

    private HotSheetAjaxService hotSheetAjaxService;
    private JdbcTemplate jdbcTemplate;

    private static final String DELETE = "delete from contacts where contact_name = 'TestMe'";

    @Override
    protected void onSetUp() throws Exception {
        super.onSetUp();
        jdbcTemplate.execute(DELETE);
    }

    @Override
    protected void onTearDown() throws Exception {
        super.onTearDown();
        jdbcTemplate.execute(DELETE);
    }

    @SuppressWarnings("unchecked")
    public void testAddNewDestinationContactRollback() {

        Long userId = (long) 1;
        Long organizationId = (long) 2;

        Map<String, String[]> params = new HashMap<String, String[]>();
        params.put("contactName", new String[]{"TestMe"});
        params.put("contactPhone", new String[]{"800.325.3535"});
        params.put("extDealerId", new String[]{"10828"});

        //There is no jobLocationAddressId 
        hotSheetAjaxService.addNewDestinationContact(params, userId, organizationId);
        String getIdentity = "SELECT @@IDENTITY contact_id";
        Integer id = jdbcTemplate.queryForInt(getIdentity);
        assertEquals(0, id.intValue());
    }


    @SuppressWarnings("unused")
    public void setHotSheetAjaxService(HotSheetAjaxService hotSheetAjaxService) {
        this.hotSheetAjaxService = hotSheetAjaxService;
    }

    @SuppressWarnings("unused")
    public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    protected String[] getConfigLocations() {
        return new String[]{"applicationContext-test.xml"};
    }
}
