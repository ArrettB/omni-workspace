package com.dynamic.servicetrax.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.jdbc.core.JdbcTemplate;

/**
 * User: pgarvie
 * Date: 1/21/14
 * Time: 10:28 PM  Jan 21 2014
 */
public class JasperReportDao {

    private JdbcTemplate jdbcTemplate;

    public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @SuppressWarnings("unchecked")
    public Map<String, Map<BigDecimal, String>> getLookups() {
        List<Map<String, Object>> lookups = jdbcTemplate.queryForList(LOOKUPS_SQL);
        Map<String, Map<BigDecimal, String>> lookupMap = new HashMap<String, Map<BigDecimal, String>>();
        for (Map<String, Object> aLookup : lookups) {
            String typeCode = (String) aLookup.get("type_code");
            Map<BigDecimal, String> lookupList;
            if ((lookupList = lookupMap.get(typeCode)) == null) {
                lookupList = new HashMap<BigDecimal, String>();
                lookupMap.put(typeCode, lookupList);
            }
            lookupList.put((BigDecimal) aLookup.get("lookup_id"), (String) aLookup.get("lookup_name"));
        }
        return lookupMap;
    }

    public String getUser(BigDecimal userId) {
        if (userId == null) {
            return null;
        }
        return (String) jdbcTemplate.queryForObject(USERS_SQL, new Object[]{userId}, String.class);
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> getContactInfo(BigDecimal contactId) {
        if (contactId == null) {
            return Collections.emptyMap();
        }
        return jdbcTemplate.queryForMap(CONTACT_SQL, new Object[]{contactId});
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> getAddressInfo(BigDecimal jobLocationid) {
        if (jobLocationid == null) {
            return Collections.emptyMap();
        }

        return jdbcTemplate.queryForMap(JOB_LOCATION_SQL, new Object[]{jobLocationid});
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> getCustomerInfo(BigDecimal customerId) {
        return jdbcTemplate.queryForMap(CUSTOMER_SQL, new Object[]{customerId});
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> getProjectInfo(BigDecimal projectId) {
        return jdbcTemplate.queryForMap(PROJECT_SQL, new Object[]{projectId});
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> getRequestInfo(String requestId) {
        return jdbcTemplate.queryForMap(REQUEST_SQL, new Object[]{requestId, requestId});
    }

    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getAttachments(String requestId) {
        return jdbcTemplate.queryForList(ATTACHMENTS_SQL, new Object[]{requestId});
    }

    public Connection getConnection() throws SQLException {
        return jdbcTemplate.getDataSource().getConnection();
    }

    private static final String REQUEST_SQL = "SELECT r.request_no," +
            " r.project_id," +
            " r.version_no," +
            " r.request_type_id," +
            " r.description," +
            " r.other_conditions," +
            " getdate() cur_date," +
            " ISNULL(r.est_start_date,getDate()+100) - 2 wo_lock_date," +
            " ISNULL(r.est_start_date,getDate()+100) - 3 sr_lock_date," +
            " l1.code record_status_type_code," +
            " r.is_sent," +
            " l2.code record_type_code," +
            " r.quote_request_id," +
            " r.is_quoted," +
            " r.job_location_id," +
            " r.job_location_contact_id," +
            " r.a_m_contact_id," +
            " r.a_m_sales_contact_id," +
            " r.customer_contact_id," +
            " r.schedule_with_client_flag," +
            " r.schedule_type_id," +
            " r.is_stair_carry_required," +
            " r.est_start_date," +
            " r.est_start_time," +
            " r.est_end_date," +
            " r.days_to_complete," +
            " r.dealer_po_line_no," +
            " r.dealer_po_no," +
            " r.taxable_flag," +
            " r.date_created," +
            " r.created_by," +
            " r.date_modified," +
            " r.modified_by," +
            " r.prod_disp_id," +
            " r.wall_mount_type_id," +
            " r.elevator_avail_type_id," +
            " r.plan_location_type_id," +
            " r.system_furniture_line_type_id," +
            " r.other_delivery_type_id," +
            " r.delivery_type_id," +
            " r.other_furniture_type_id," +
            " r.quote_type_id," +
            " r.order_type_id," +
            " r.customer_costing_type_id," +
            " c1.contact_name contact_name1," +
            " dbo.sp_contact_phone(r.customer_contact_id) contact_phone1," +
            " c1.email contact_email1," +
            " c2.contact_name contact_name2," +
            " dbo.sp_contact_phone(r.customer_contact2_id) contact_phone2," +
            " c2.email contact_email2," +
            " c3.contact_name contact_name3," +
            " dbo.sp_contact_phone(r.customer_contact3_id) contact_phone3," +
            " c3.email contact_email3," +
            " c4.contact_name contact_name4," +
            " dbo.sp_contact_phone(r.customer_contact4_id) contact_phone4," +
            " c4.email contact_email4," +
            " (SELECT COUNT(po.po_id)" +
            " FROM purchase_orders po INNER JOIN" +
            " lookups l ON po.po_status_id = l.lookup_id" +
            " WHERE l.code IN ('released', 'received')" +
            " AND po.request_id = ?) po_count" +
            " FROM requests r INNER JOIN" +
            " lookups l1 ON r.request_status_type_id = l1.lookup_id INNER JOIN" +
            " lookups l2 ON r.request_type_id = l2.lookup_id LEFT OUTER JOIN" +
            " contacts c1 ON r.customer_contact_id = c1.contact_id LEFT OUTER JOIN" +
            " contacts c2 ON r.customer_contact2_id = c2.contact_id LEFT OUTER JOIN" +
            " contacts c3 ON r.customer_contact3_id = c3.contact_id LEFT OUTER JOIN" +
            " contacts c4 ON r.customer_contact4_id = c4.contact_id" +
            " WHERE l2.code <> 'quote'" +
            " AND r.request_id = ?";


    private static final String PROJECT_SQL = "SELECT TOP 1 p.project_no," +
            " p.project_id," +
            " p.project_type_id," +
            " p.project_type_code," +
            " p.project_type_name," +
            " p.project_status_type_code," +
            " p.project_status_type_name," +
            " p.parent_customer_id," +
            " p.customer_id," +
            " p.end_user_id," +
            " RTRIM(p.ext_dealer_id) ext_dealer_id," +
            " RTRIM(p.dealer_name) dealer_name," +
            " RTRIM(p.customer_name) customer_name," +
            " RTRIM(p.end_user_name) end_user_name," +
            " p.job_name," +
            " p.ext_end_user_id " +
            " FROM projects_v2 p" +
            " WHERE p.project_id = ?";

    private static final String CUSTOMER_SQL = "SELECT c.customer_name, " +
            " c.parent_customer_id," +
            " c.ext_dealer_id," +
            " c.ext_customer_id," +
            " l.code customer_type,c.end_user_parent_id," +
            " c_p.customer_name end_user_parent_name" +
            " FROM customers c JOIN lookups l ON c.customer_type_id = l.lookup_id" +
            " LEFT JOIN customers c_p ON c.end_user_Parent_id = c_p.customer_id  WHERE c.customer_id = ?";

    private static final String JOB_LOCATION_SQL = "SELECT street1, street2, street3, city, state, zip, job_location_name" +
            " FROM job_locations" +
            " WHERE job_location_id=?";

    public static final String ATTACHMENTS_SQL = "select distinct rd.request_document_id," +
            " rd.name," +
            " u.full_name created_by," +
            " convert(varchar(10), rd.date_created, 101) date_created" +
            " from request_documents rd," +
            " users u" +
            " where rd.created_by = u.user_id" +
            " and rd.request_id = ?";

    private static final String CONTACT_SQL = "select contact_name, phone_work, phone_cell" +
            " from contacts where contact_id=?";

    private static final String USERS_SQL = "select full_name from users where user_id = ?";

    private static final String LOOKUPS_SQL = "select lookup_id, type_code, lookup_name from lookups_v l";
}
