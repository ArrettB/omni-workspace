package com.dynamic.servicetrax.domain;

import com.dynamic.charm.query.hibernate.HibernateService;
import com.dynamic.charm.service.QueryService;
import com.dynamic.servicetrax.orm.Contact;
import com.dynamic.servicetrax.orm.HotSheet;
import com.dynamic.servicetrax.orm.HotSheetDetail;
import com.dynamic.servicetrax.orm.Lookup;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.AbstractTransactionalDataSourceSpringContextTests;
import org.springframework.test.AbstractTransactionalSpringContextTests;

import java.util.Date;

/**
 * User: pgarvie
 * Date: May 14, 2010
 * Time: 11:27:48 AM
 */
public class HotSheetDetailTest extends AbstractTransactionalSpringContextTests {

    private HibernateService hibernateService;
    private JdbcTemplate jdbcTemplate;
    //private QueryService queryService;

    public void testPersistance() {

        hibernateService = (HibernateService) applicationContext.getBean("hibernateService");

        HotSheet hotsheet = createHotSheet();

        HotSheetDetail detail = new HotSheetDetail();
        detail.setDateCreated(new Date());
        detail.setCreatedBy(1L);
        detail.setDateModified(new Date());
        detail.setModifiedBy(1L);
        detail.setAttributeValue(2);

        detail.setHotSheetId(3L);

        detail.setHotSheetLookupId(4L);
        detail.setCode("Code");
        detail.setName("Name");
        detail.setHotSheetDetailId(5L);
        try {
            hibernateService.getHibernateTemplate().save(detail);
        }
        catch (Exception e) {
        }
        System.out.println("o = ");

    }

    private HotSheet createHotSheet() {
        return new HotSheet();
    }

    @Override
    protected String[] getConfigLocations() {
        return new String[]{"applicationContext-test.xml"};
    }

    public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }
}
