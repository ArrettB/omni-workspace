package com.dynamic.servicetrax.service;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.AbstractTransactionalSpringContextTests;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * User: pgarvie
 * Date: Nov 14, 2010
 * Time: 12:55:52 PM
 */
public class HotSheetAjaxControllerTest extends AbstractTransactionalSpringContextTests {

    private HotSheetAjaxService hotSheetAjaxService;
    private JdbcTemplate jdbcTemplate;

    @SuppressWarnings("unchecked")
    public void testAddNewDestinationContact() {

        Long userId = (long) 1;
        Long organizationId = (long) 2;

        Map<String, String[]> params = new HashMap<String, String[]>();
        params.put("contactName", new String[]{"TestMe"});
        params.put("contactPhone", new String[]{"800.325.3535"});
        params.put("extDealerId", new String[]{"10828"});
        hotSheetAjaxService.addNewDestinationContact(params, userId, organizationId);
        String getIdentity = "SELECT @@IDENTITY current_id";
        Integer id = jdbcTemplate.queryForInt(getIdentity);
        List<Map> rows = jdbcTemplate.queryForList("SELECT * FROM CONTACTS WHERE CONTACT_ID = ?", new Object[]{id});
        assertTrue(rows != null && rows.size() == 1);
        Map aRow = rows.get(0);
        assertEquals("TestMe", aRow.get("CONTACT_NAME"));
        assertEquals(new BigDecimal(organizationId), aRow.get("ORGANIZATION_ID"));
        assertEquals("10828", aRow.get("EXT_DEALER_ID"));
        assertEquals("800.325.3535", aRow.get("PHONE_WORK"));
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
