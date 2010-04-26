/**
 * 
 */
package dynamic.dbtk.parser;

import java.util.Vector;

import junit.framework.Assert;
import junit.framework.TestCase;

/**
 * @author bvonhaden
 *
 */
public class SqlTest extends TestCase {


	/**
	 * Test method for {@link dynamic.dbtk.parser.Sql#getQuery()}.
	 * @throws ParseException 
	 */
	public void testGetQuery() throws ParseException {
		String query = "SELECT one, two FROM cat";
		Sql jp = Sql.fetchSql(query );
		
		assertEquals(query, jp.getQuery());
	}

	/**
	 * Test method for {@link dynamic.dbtk.parser.Sql#getTables()}.
	 * @throws ParseException 
	 */
	public void testGetTables() throws ParseException {
		String query = "SELECT one, two FROM cat";
		Sql jp = Sql.fetchSql(query );
		Vector tables = jp.getTables();
		for (int i = 0; i < tables.size(); i++)
		{
			QueryTable tab = (QueryTable)tables.get(i);
			assertEquals("cat", tab.getName());
		}
	}

	/**
	 * Test method for {@link dynamic.dbtk.parser.Sql#getTableAlias(java.lang.String)}.
	 * @throws ParseException 
	 */
	public void testGetTableAlias_none() throws ParseException {
		String query = "SELECT one, two FROM cat";
		Sql jp = Sql.fetchSql(query );
		
		assertEquals(null, jp.getTableAlias("cat"));
	}

	/**
	 * Test method for {@link dynamic.dbtk.parser.Sql#getTableAlias(java.lang.String)}.
	 * @throws ParseException 
	 */
	public void testGetTableAlias_exists() throws ParseException {
		String query = "SELECT one, two FROM cat c";
		Sql jp = Sql.fetchSql(query );
		
		assertEquals("c", jp.getTableAlias("cat"));
	}

	/**
	 * Test method for {@link dynamic.dbtk.parser.Sql#getSelect()}.
	 * @throws ParseException 
	 */
	public void testGetSelect() throws ParseException {
		String query = "SELECT one, two FROM cat c";
		Sql jp = Sql.fetchSql(query );
		
		assertEquals("SELECT one, two ", jp.getSelect());
	}

	/**
	 * Test method for {@link dynamic.dbtk.parser.Sql#getFrom()}.
	 * @throws ParseException 
	 */
	public void testGetFrom() throws ParseException {
		String query = "SELECT one, two FROM cat c";
		Sql jp = Sql.fetchSql(query );
		
		assertEquals("FROM cat c", jp.getFrom());
	}

	/**
	 * Test method for {@link dynamic.dbtk.parser.Sql#getFrom()}.
	 * @throws ParseException 
	 */
	public void testGetFrom_where() throws ParseException {
		String query = "SELECT one, two FROM cat c WHERE c.id = 1";
		Sql jp = Sql.fetchSql(query );
		
		assertEquals("FROM cat c ", jp.getFrom());
	}

	/**
	 * Test method for {@link dynamic.dbtk.parser.Sql#getFrom()}.
	 * @throws ParseException 
	 */
	public void testGetFrom_complex() throws ParseException {
		String query = "SELECT one, two FROM cat c, dog d WHERE c.enemy_id = d.dog_id";
		Sql jp = Sql.fetchSql(query );
		
		assertEquals("FROM cat c, dog d ", jp.getFrom());
	}

	/**
	 * Test method for {@link dynamic.dbtk.parser.Sql#getFrom()}.
	 * @throws ParseException 
	 */
	public void testGetFrom_inner() throws ParseException {
		String select = "SELECT one, two ";
		String from = "FROM cats c INNER JOIN dogs d ON c.enemy_id = d.dog_id";
		Sql jp = Sql.fetchSql(select + from );
		String f = jp.getFrom();
		assertEquals(from, jp.getFrom());
	}

	/**
	 * Test method for {@link dynamic.dbtk.parser.Sql#getFrom()}.
	 * @throws ParseException 
	 */
	public void testGetFrom_inner_where() throws ParseException {
		String select = "SELECT one, two ";
		String from = "FROM cats c INNER JOIN dogs d ON c.enemy_id = d.dog_id ";
		String where = "WHERE c.id = 1";
		Sql jp = Sql.fetchSql(select + from + where );
		
		assertEquals(from, jp.getFrom());
	}

	/**
	 * Test method for {@link dynamic.dbtk.parser.Sql#getSelect()}.
	 * @throws ParseException 
	 */
	public void testGetFrom_inner2_select() throws ParseException {
		String select = "SELECT DISTINCT c.contact_id customer_contact_id, c.contact_name ";
		String from = "FROM contacts c INNER JOIN"
			+ " job_location_contacts jlc ON c.contact_id = jlc.contact_id INNER JOIN"
			+ " lookups l ON c.cont_status_type_id = l.lookup_id ";
 		String where = "WHERE l.code='active'"
 			+ " AND c.contact_name IS NOT NULL"
 			+ " AND c.contact_name NOT LIKE '%N/A%'"
 			+ " AND c.contact_name <> 'NA'"
 			+ " AND (jlc.job_location_id = 19076 OR c.contact_id = 30001) ";
 		String orderBy = "ORDER BY c.contact_name";
		Sql jp = Sql.fetchSql(select + from + where + orderBy );
		
		assertEquals(select, jp.getSelect());
	}

	/**
	 * Test method for {@link dynamic.dbtk.parser.Sql#getFrom()}.
	 * @throws ParseException 
	 */
	public void testGetFrom_inner2_from() throws ParseException {
		String select = "SELECT DISTINCT c.contact_id customer_contact_id, c.contact_name ";
		String from = "FROM contacts c INNER JOIN"
			+ " job_location_contacts jlc ON c.contact_id = jlc.contact_id INNER JOIN"
			+ " lookups l ON c.cont_status_type_id = l.lookup_id ";
 		String where = "WHERE l.code='active'"
 			+ " AND c.contact_name IS NOT NULL"
 			+ " AND c.contact_name NOT LIKE '%N/A%'"
 			+ " AND c.contact_name <> 'NA'"
 			+ " AND (jlc.job_location_id = 19076 OR c.contact_id = 30001) ";
 		String orderBy = "ORDER BY c.contact_name";
		Sql jp = Sql.fetchSql(select + from + where + orderBy );
		
		assertEquals(from, jp.getFrom());
	}


	/**
	 * Test method for {@link dynamic.dbtk.parser.Sql#getTables()}.
	 * @throws ParseException 
	 */
	public void testGetFrom_inner2_tables() throws ParseException {
		String select = "SELECT DISTINCT c.contact_id customer_contact_id, c.contact_name ";
		String from = "FROM contacts c INNER JOIN"
			+ " job_location_contacts jlc ON c.contact_id = jlc.contact_id INNER JOIN"
			+ " lookups l ON c.cont_status_type_id = l.lookup_id ";
 		String where = "WHERE l.code='active'"
 			+ " AND c.contact_name IS NOT NULL"
 			+ " AND c.contact_name NOT LIKE '%N/A%'"
 			+ " AND c.contact_name <> 'NA'"
 			+ " AND (jlc.job_location_id = 19076 OR c.contact_id = 30001) ";
 		String orderBy = "ORDER BY c.contact_name";
		Sql jp = Sql.fetchSql(select + from + where + orderBy );
		
		Vector tables = jp.getTables();
		assertEquals(3, tables.size());
		assertEquals("contacts", ((QueryTable)tables.get(0)).getName());
		assertEquals("job_location_contacts", ((QueryTable)tables.get(1)).getName());
		assertEquals("lookups", ((QueryTable)tables.get(2)).getName());
	}

	/**
	 * Test method for {@link dynamic.dbtk.parser.Sql#getWhere()}.
	 * @throws ParseException 
	 */
	public void testGetFrom_inner2_where() throws ParseException {
		String select = "SELECT DISTINCT c.contact_id customer_contact_id, c.contact_name ";
		String from = "FROM contacts c INNER JOIN"
			+ " job_location_contacts jlc ON c.contact_id = jlc.contact_id INNER JOIN"
			+ " lookups l ON c.cont_status_type_id = l.lookup_id ";
 		String where = "WHERE l.code='active'"
 			+ " AND c.contact_name IS NOT NULL"
 			+ " AND c.contact_name NOT LIKE '%N/A%'"
 			+ " AND c.contact_name <> 'NA'"
 			+ " AND (jlc.job_location_id = 19076 OR c.contact_id = 30001) ";
 		String orderBy = "ORDER BY c.contact_name";
		Sql jp = Sql.fetchSql(select + from + where + orderBy );
		
		assertEquals(where, jp.getWhere());
	}

	/**
	 * Test method for {@link dynamic.dbtk.parser.Sql#getOrderBy()}.
	 * @throws ParseException 
	 */
	public void testGetFrom_inner2_orderBy() throws ParseException {
		String select = "SELECT DISTINCT c.contact_id customer_contact_id, c.contact_name ";
		String from = "FROM contacts c INNER JOIN"
			+ " job_location_contacts jlc ON c.contact_id = jlc.contact_id INNER JOIN"
			+ " lookups l ON c.cont_status_type_id = l.lookup_id ";
 		String where = "WHERE l.code='active'"
 			+ " AND c.contact_name IS NOT NULL"
 			+ " AND c.contact_name NOT LIKE '%N/A%'"
 			+ " AND c.contact_name <> 'NA'"
 			+ " AND (jlc.job_location_id = 19076 OR c.contact_id = 30001) ";
 		String orderBy = "ORDER BY c.contact_name";
		Sql jp = Sql.fetchSql(select + from + where + orderBy );
		
		assertEquals(orderBy, jp.getOrderBy());
	}

	/**
	 * Test method for {@link dynamic.dbtk.parser.Sql#getFrom()}.
	 * @throws ParseException 
	 */
	public void testGetFrom_inner_tables() throws ParseException {
		String select = "SELECT one, two ";
		String from = "FROM cats c INNER JOIN dogs d ON c.enemy_id = d.dog_id ";
		String where = "WHERE c.id = 1";
		Sql jp = Sql.fetchSql(select + from + where );
		
		Vector tables = jp.getTables();
		assertEquals(2, tables.size());
		assertEquals("cats", ((QueryTable)tables.get(0)).getName());
		assertEquals("dogs", ((QueryTable)tables.get(1)).getName());
	}

	/**
	 * Test method for {@link dynamic.dbtk.parser.Sql#getFrom()}.
	 * @throws ParseException 
	 */
	public void testGetFrom_inner_tables_and() throws ParseException {
		String select = "SELECT one, two ";
		String from = "FROM cats c INNER JOIN dogs d ON c.enemy_id = d.dog_id AND c.spade_id = d.spade_id ";
		String where = "WHERE c.id = 1";
		Sql jp = Sql.fetchSql(select + from + where );
		
		Vector tables = jp.getTables();
		assertEquals(2, tables.size());
		assertEquals("cats", ((QueryTable)tables.get(0)).getName());
		assertEquals("dogs", ((QueryTable)tables.get(1)).getName());
	}


	/**
	 * Test method for {@link dynamic.dbtk.parser.Sql#getFrom()}.
	 * @throws ParseException 
	 */
	public void testGetFrom_left_outer_tables() throws ParseException {
		String select = "SELECT one, two ";
		String from = "FROM cats c LEFT OUTER JOIN dogs d ON c.enemy_id = d.dog_id ";
		String where = "WHERE c.id = 1";
		Sql jp = Sql.fetchSql(select + from + where );
		
		Vector tables = jp.getTables();
		assertEquals(2, tables.size());
		assertEquals("cats", ((QueryTable)tables.get(0)).getName());
		assertEquals("dogs", ((QueryTable)tables.get(1)).getName());
	}

	/**
	 * Test method for {@link dynamic.dbtk.parser.Sql#getFrom()}.
	 * @throws ParseException 
	 */
	public void testGetFrom_left_tables() throws ParseException {
		String select = "SELECT one, two ";
		String from = "FROM cats c LEFT JOIN dogs d ON c.enemy_id = d.dog_id ";
		String where = "WHERE c.id = 1";
		Sql jp = Sql.fetchSql(select + from + where );
		
		Vector tables = jp.getTables();
		assertEquals(2, tables.size());
		assertEquals("cats", ((QueryTable)tables.get(0)).getName());
		assertEquals("dogs", ((QueryTable)tables.get(1)).getName());
	}

	/**
	 * Test method for {@link dynamic.dbtk.parser.Sql#getFrom()}.
	 * @throws ParseException 
	 */
	public void testGetFrom_right_outer_tables() throws ParseException {
		String select = "SELECT one, two ";
		String from = "FROM cats c RIGHT OUTER JOIN dogs d ON c.enemy_id = d.dog_id ";
		String where = "WHERE c.id = 1";
		Sql jp = Sql.fetchSql(select + from + where );
		
		Vector tables = jp.getTables();
		assertEquals(2, tables.size());
		assertEquals("cats", ((QueryTable)tables.get(0)).getName());
		assertEquals("dogs", ((QueryTable)tables.get(1)).getName());
	}

	/**
	 * Test method for {@link dynamic.dbtk.parser.Sql#getFrom()}.
	 * @throws ParseException 
	 */
	public void testGetFrom_right_tables() throws ParseException {
		String select = "SELECT one, two ";
		String from = "FROM cats c RIGHT JOIN dogs d ON c.enemy_id = d.dog_id ";
		String where = "WHERE c.id = 1";
		Sql jp = Sql.fetchSql(select + from + where );
		
		Vector tables = jp.getTables();
		assertEquals(2, tables.size());
		assertEquals("cats", ((QueryTable)tables.get(0)).getName());
		assertEquals("dogs", ((QueryTable)tables.get(1)).getName());
	}

	/**
	 * Test method for {@link dynamic.dbtk.parser.Sql#getFrom()}.
	 * @throws ParseException 
	 */
	public void testGetFrom_full_outer_tables() throws ParseException {
		String select = "SELECT one, two ";
		String from = "FROM cats c FULL OUTER JOIN dogs d ON c.enemy_id = d.dog_id ";
		String where = "WHERE c.id = 1";
		Sql jp = Sql.fetchSql(select + from + where );
		
		Vector tables = jp.getTables();
		assertEquals(2, tables.size());
		assertEquals("cats", ((QueryTable)tables.get(0)).getName());
		assertEquals("dogs", ((QueryTable)tables.get(1)).getName());
	}

	/**
	 * Test method for {@link dynamic.dbtk.parser.Sql#getFrom()}.
	 * @throws ParseException 
	 */
	public void testGetFrom_full_tables() throws ParseException {
		String select = "SELECT one, two ";
		String from = "FROM cats c FULL JOIN dogs d ON c.enemy_id = d.dog_id ";
		String where = "WHERE c.id = 1";
		Sql jp = Sql.fetchSql(select + from + where );
		
		Vector tables = jp.getTables();
		assertEquals(2, tables.size());
		assertEquals("cats", ((QueryTable)tables.get(0)).getName());
		assertEquals("dogs", ((QueryTable)tables.get(1)).getName());
	}

	/**
	 * Test method for {@link dynamic.dbtk.parser.Sql#getWhere()}.
	 * @throws ParseException 
	 */
	public void testGetWhere() throws ParseException {
		String query = "SELECT one, two FROM cat c WHERE c.foo = 'bar'";
		Sql jp = Sql.fetchSql(query );
		
		assertEquals("WHERE c.foo = 'bar'", jp.getWhere());
	}

	/**
	 * Test method for {@link dynamic.dbtk.parser.Sql#getWhere()}.
	 * @throws ParseException 
	 */
	public void testVarchar() throws ParseException {
		String query = "SELECT service_id, CONVERT(VARCHAR, service_no) + ' - ' + ISNULL(description, '')"
			+ " FROM services"
			+ " WHERE job_id = 5"
			+ " ORDER BY service_no";
		Sql jp = Sql.fetchSql(query );
		
		assertEquals("SELECT service_id, CONVERT(VARCHAR, service_no) + ' - ' + ISNULL(description, '') ", jp.getSelect());
		jp.getQuery();
	}

    public void testClearOrderBy() throws ParseException
    {
        String query = "SELECT name, col2 from tab1 ";
        String orderBy = "ORDER BY name";
        Sql jp = Sql.fetchSql(query + orderBy);
        jp.setOrderBy("");
        assertEquals(query, jp.getQuery());
    }

	/**
	 * Test method for {@link dynamic.dbtk.parser.Sql#getWhere()}.
	 * @throws ParseException 
	 */
	public void testSortBY() throws ParseException {
		String query = "SELECT pv.* FROM ("
			+ " SELECT pv.project_request_no"
			+ " , pv.project_id"
			+ " , pv.project_no"
			+ " , pv.request_id"
			+ " , pv.request_no"
			+ " , pv.job_name"
			+ " , pv.ext_dealer_id"
			+ " , pv.dealer_name"
			+ " , pv.customer_name"
			+ " , pv.end_user_name"
			+ " , pv.record_type_code"
			+ " , pv.record_status_name"
			+ " , pv.dealer_po_no"
			+ " , pv.customer_po_no"
			+ " , pv.vendor_count"
			+ " , pv.vendor_complete_count"
			+ " , pv.description"
			+ " , ISNULL(pv.est_start_date, ISNULL(pv.min_act_start_date, pv.min_sch_start_date)) install_date"
			+ " , pv.record_status_seq_no"
			+ " , '' foo"
			+ " , '' selected"
			+ " FROM quick_request_vendors_v pv  INNER JOIN "
			+ " user_customers uc ON pv.customer_id = uc.customer_id" 
			+ " WHERE pv.organization_id = '<#?I2?#>'"
			+ "  AND (uc.user_customer_id IN('165'))"
			+ " AND pv.ext_dealer_id = '<#?S10563?#>'"
			+ " UNION "
			+ " SELECT pv.project_request_no"
			+ " , pv.project_id"
			+ " , pv.project_no"
			+ " , pv.request_id"
			+ " , pv.request_no"
			+ " , pv.job_name"
			+ " , pv.ext_dealer_id"
			+ " , pv.dealer_name"
			+ " , pv.customer_name"
			+ " , pv.end_user_name"
			+ " , pv.record_type_code"
			+ " , pv.record_status_name"
			+ " , pv.dealer_po_no"
			+ " , pv.customer_po_no"
			+ " , pv.vendor_count"
			+ " , pv.vendor_complete_count"
			+ " , pv.description"
			+ " , ISNULL(pv.est_start_date, ISNULL(pv.min_act_start_date, pv.min_sch_start_date)) install_date"
			+ " , pv.record_status_seq_no"
			+ " , '' foo"
			+ " , '' selected"
			+ " FROM quick_request_vendors_v pv  INNER JOIN "
			+ " user_customers uc ON pv.customer_id = uc.customer_id INNER JOIN "
			+ " user_customer_end_users uceu ON uc.user_customer_id = uceu.user_customer_id" 
			+ " WHERE pv.organization_id = '<#?I2?#>'"
			+ " AND (uc.user_customer_id IN('167'))"
			+ " AND pv.ext_dealer_id = '<#?S10563?#>'"
			+ " AND pv.end_user_id = uceu.customer_id" 
			+ " ) pv "
			+ " ORDER BY project_no DESC, request_no DESC, record_status_seq_no";
		Sql jp = Sql.fetchSql(query );
		
		assertEquals("ORDER BY project_no DESC, request_no DESC, record_status_seq_no", jp.getOrderBy());
	}

	/**
	 * Test method for {@link dynamic.dbtk.parser.Sql#getWhere()}.
	 * @throws ParseException 
	 */
	public void testOrderBy() throws ParseException {
		String query = "SELECT pv.* FROM ("
			+ " SELECT pv.project_request_no"
			+ " FROM quick_request_vendors_v pv  INNER JOIN "
			+ " user_customers uc ON pv.customer_id = uc.customer_id" 
			+ " WHERE pv.organization_id = '2'"
			+ " UNION "
			+ " SELECT pv.project_request_no"
			+ " FROM quick_request_vendors_v pv  INNER JOIN "
			+ " user_customers uc ON pv.customer_id = uc.customer_id INNER JOIN "
			+ " user_customer_end_users uceu ON uc.user_customer_id = uceu.user_customer_id" 
			+ " WHERE pv.organization_id = '<#?I2?#>'"
			+ " ) pv "
			+ " ORDER BY project_no DESC, request_no DESC, record_status_seq_no";
		Sql jp = Sql.fetchSql(query );
		
		assertEquals("ORDER BY project_no DESC, request_no DESC, record_status_seq_no", jp.getOrderBy());
	}

	/**
	 * Test method for {@link dynamic.dbtk.parser.Sql#getWhere()}.
	 * @throws ParseException 
	 */
	public void testUnion() throws ParseException {
		String query = "SELECT pv.* FROM ("
			+ " SELECT pv.project_request_no"
			+ " FROM quick_request_vendors_v pv "
			+ " WHERE pv.organization_id = '2'"
			+ " UNION "
			+ " SELECT pv.project_request_no"
			+ " FROM quick_request_vendors_v pv " 
			+ " WHERE pv.organization_id = '2'"
			+ " ) pv WHERE pv.fred = 1"
			+ " ORDER BY project_no DESC, request_no DESC, record_status_seq_no";
		Sql jp = Sql.fetchSql(query );
		
		assertEquals("ORDER BY project_no DESC, request_no DESC, record_status_seq_no", jp.getOrderBy());
	}

	/**
	 * Test method for {@link dynamic.dbtk.parser.Sql#getWhere()}.
	 * @throws ParseException 
	 */
	public void testEmbeddedFrom() throws ParseException {
		String query = "SELECT pv.* FROM ("
			+ " SELECT pv.project_request_no"
			+ " FROM quick_request_vendors_v pv "
			+ " WHERE pv.organization_id = '2'"
			+ " ) pv WHERE pv.fred = 1"
			+ " ORDER BY project_no DESC, request_no DESC, record_status_seq_no";
		Sql jp = Sql.fetchSql(query );
		
		assertEquals("ORDER BY project_no DESC, request_no DESC, record_status_seq_no", jp.getOrderBy());
	}

	public void testCaseStatement() throws ParseException
	{
		String query = "select case when 1=1 then 1 else 0 end from customers";
		Sql jp = Sql.fetchSql(query);
		assertEquals(query, jp.getQuery());
	}
	
	public void testMultiWhenCaseStatement() throws ParseException
	{
		String query = "select case when 1=1 then 1 when 2=2 then 2 else 0 end from customers";
		Sql jp = Sql.fetchSql(query);
	}
	
	public void testCaseOptionalElse() throws ParseException
	{
		String query = "select case when 1=1 then 1 when 2=2 then 2 end from customers";
		Sql jp = Sql.fetchSql(query);
	}
	
	public void testCaseInFromClause() throws ParseException
	{
		String query = "select it.i_value from (select case when 1=1 then 1 when 2=2 then 2 end i_value from customers) it";
		Sql jp = Sql.fetchSql(query);
		assertEquals(query, jp.getQuery());
	}
	
	public void testCaseSimpleExpression() throws ParseException
	{
		String query = "select case customer_id	when 1 then 1 else 0 end from customers";
		Sql jp = Sql.fetchSql(query);
	}
	
	public void testComplexCaseStatement() throws ParseException
	{
		String query =
		"select"
		+ " IsNull(sum(il.unit_price * il.qty), 0) custom_tot,"
		+ " IsNull(sum(sl.bill_hourly_total), 0) hours_total,"
		+ " IsNull(sum(sl.bill_exp_total), 0) exp_tot,"
		+ " IsNull(sum(sl.bill_total), 0) + IsNull(sum(il.unit_price * il.qty), 0) total_tot,"
		+ " u.first_name + ' ' + u.last_name assigned_to_name,"
		+ " j.job_no,"
		+ " i.job_id,"
		+ " ib.name batch_status_name,"
		+ " i_trk.invoice_id_trk,"
		+ " i.invoice_id,"
		+ " i.description invoice_description,"
		+ " invoice_type.name invoice_type_name,"
		+ " i.status_id invoice_status_id,"
		+ " i.date_sent,"
		+ " j.customer_name,"
		+ " j.end_user_name,"
		+ " jt.name job_type_name,"
		+ " i.po_no,"
		+ " i.date_created invoice_date_created"
	+ " from"
		+ " invoices i"
		+ " left join ("
			+ " select"
				+ " i2.invoice_id,"
			+ " case"
				+ " when iv.invoice_tracking_id is null then convert(varchar, i2.invoice_id) + ''"
				+ " else convert(varchar, i2.invoice_id) + '*'"
			+ " end invoice_id_trk"
			+ " from"
				+ " invoices i2"
				+ " left join invoice_tracking iv on"
					+ " i2.invoice_id = iv.invoice_id) i_trk on"
				+ " i.invoice_id = i_trk.invoice_id"
		+ " left join lookups invoice_type on"
			+ " i.invoice_type_id = invoice_type.lookup_id "			
		+ "  join ("
			+ " select"
				+ " j.job_id,"
				+ " j.job_no,"
				+ " j.billing_user_id,"
				+ " j.job_type_id,"
				+ " CASE" 
					+ " WHEN customer_type.code = 'end_user' THEN (SELECT customer_name FROM customers WHERE customer_id = c.end_user_parent_id)" 
					+ " ELSE c.customer_name" 
				+ " END customer_name,"
				+ " CASE" 
					+ " WHEN customer_type.code = 'end_user' THEN c.customer_name" 
					+ " ELSE eu.customer_name" 
				+ " END end_user_name"
			+ " from"
				+ " jobs j"
				+ " join customers c on"
					+ " j.customer_id = c.customer_id"
				+ " join lookups customer_type on"
					+ " c.customer_type_id = customer_type.lookup_id"
				+ " left join projects p on"
					+ " p.project_id = j.project_id"
				+ " left join customers eu on"
					+ " eu.customer_id = p.end_user_id"	
			+ " ) j on"
			+ " i.job_id = j.job_id"
		+ " left join ("
			+ " select"
				+ " invoices.invoice_id,"
				+ " unit_price,"
				+ " qty"
			+ " from"
				+ " invoices"
				+ " join invoice_lines on"
					+ " invoices.invoice_id = invoice_lines.invoice_id"
				+ " join lookups l on"
					+ " invoice_lines.invoice_line_type_id = lookup_id"
				+ " join lookup_types lt on"
					+ " l.lookup_type_id = lt.lookup_type_id"
			+ " where" 
				+ " lt.code = 'invoice_line_type'"
				+ " and lt.active_flag <> 'N'"
				+ " and l.active_flag <> 'N'"
				+ " and l.code = 'custom') il on"
			+ " i.invoice_id = il.invoice_id"
		+ " left join ("
			+ " select"
				+ " invoice_id,"
				+ " bill_hourly_total,"
				+ " bill_exp_total,"
				+ " bill_total"
			+ " from"
				+ " service_lines"
			+ " where"
				+ " status_id > 3"
				+ " AND internal_req_flag = 'N') sl on"
			+ " i.invoice_id = sl.invoice_id"
		+ " left join users u on"
			+ " u.user_id = i.assigned_to_user_id"
		+ " left join invoice_batch_statuses ib on"
			+ " i.batch_status_id = ib.status_id"
		+ " join lookups jt on"
			+ " jt.lookup_id = j.job_type_id"
	+ " where"
		+ " i.organization_id = 2 "
		+ " and i.status_id = 2 "
		+ " and (j.billing_user_id = 2250 OR 'true' = 'true')"
	+ " GROUP BY" 
		+ " i.invoice_id,"
		+ " i_trk.invoice_id_trk,"
		+ " i.description,"
		+ " invoice_type.name,"
		+ " i.status_id,"
		+ " j.customer_name,"
		+ " j.end_user_name,"
		+ " i.job_id,"
		+ " u.first_name,"
		+ " u.last_name,"
		+ " job_no,"
		+ " ib.name,"
		+ " i.date_sent,"
		+ " i.po_no,"
		+ " i.date_created,"
		+ " jt.name"
	+ " order by"
		+ " i.invoice_id";		
		Sql jp = Sql.fetchSql(query);
		String q2 = jp.getQuery();
		String where = jp.getWhere();
		String groupBy = jp.getGroupBy();
		String orderBy = jp.getOrderBy();
	}
	
	public void testInlineSelect() throws ParseException
	{
		String query 
		= "SELECT i2.invoice_id, "
	    + "       CASE (SELECT COUNT(*) FROM invoice_tracking WHERE invoice_id = i2.invoice_id) WHEN 0 THEN CONVERT(VARCHAR, i2.invoice_id) ELSE CONVERT(VARCHAR, i2.invoice_id) + '*' END invoice_id_trk "
        + "  FROM invoices i2 "
        + " where i2.invoice_id=180865 ";
	
		Sql jp = Sql.fetchSql(query);
		String q2 = jp.getQuery();
		String where = jp.getWhere();
	}
	
	public void testAnsiJoin() throws ParseException
	{
		String query = "select customer_id from customers c join invoices i on c.id = i.id";
		Sql jp = Sql.fetchSql(query);
		String test = jp.getQuery();
		assertEquals(query, jp.getQuery());
	}
	
	public void testAnsiLeftJoin() throws ParseException
	{
		String query = "select customer_id from customers c left join invoices i on c.id = i.id";
		Sql jp = Sql.fetchSql(query);
		String test = jp.getQuery();
		assertEquals(query, jp.getQuery());
	}
	
	public void testAnsiLeftOuterJoin() throws ParseException
	{
		String query = "select customer_id from customers c left outer join invoices i on c.id = i.id";
		Sql jp = Sql.fetchSql(query);
		String test = jp.getQuery();
		assertEquals(query, jp.getQuery());
	}
	
	public void testAnsiRightJoin() throws ParseException
	{
		String query = "select customer_id from customers c right join invoices i on c.id = i.id";
		Sql jp = Sql.fetchSql(query);
		String test = jp.getQuery();
		assertEquals(query, jp.getQuery());
	}
	
	public void testAnsiRightOuterJoin() throws ParseException
	{
		String query = "select customer_id from customers c right outer join invoices i on c.id = i.id";
		Sql jp = Sql.fetchSql(query);
		String test = jp.getQuery();
		assertEquals(query, jp.getQuery());
	}
	
	public void testAnsiInnerJoin() throws ParseException
	{
		String query = "select customer_id from customers c inner join invoices i on c.id = i.id";
		Sql jp = Sql.fetchSql(query);
		String test = jp.getQuery();
		assertEquals(query, jp.getQuery());
	}
	
	public void testFalseAnsiJoin() throws ParseException
	{
		String query = "select customer_id from customers c inner outer join invoices i on c.id = i.id";
		try
		{
			Sql jp = Sql.fetchSql(query);
			Assert.fail("query incorrectly passed through the parser");
		}
		catch(ParseException px)
		{
			
		}
		
	}
	
	public void testOrderGroupBy() throws ParseException
	{
		String query = "select customer_id from customers group by customer_id order by customer_id";
		Sql jp = Sql.fetchSql(query);
		String qroupBy = jp.getGroupBy();
		String orderBy = jp.getOrderBy();
		assertEquals("group by customer_id ", jp.getGroupBy());
		assertEquals("order by customer_id", jp.getOrderBy());
	}
	
	public void testWithTabs() throws ParseException
	{
		String query = "SELECT billing_user_id,"
		          + "	bill_job_no,"
		          + " bill_job_id,"
		          + " non_billable_total,"
		          + " billable_total,"
		          + " invoiced_total,"
		          + " customer_name,"
		          + " end_user_name,"
		          + " max_est_end_date_varchar,"
		          + " billing_user_name,"
		          + " job_name,"
		          + " organization_id,"
		          + " po_count,"
		          + " received_po_count"
	         + "	 FROM bill_jobs_v "
	        + " 		WHERE organization_id = '<#?S2?#>'"
	          + " AND (billing_user_id = '<#?S2250?#>' OR 'true' = '<#?Strue?#>')"
	          + " 	ORDER BY billing_user_name, bill_job_no";
		Sql jp = Sql.fetchSql(query);
		assertEquals(query, jp.getQuery());
	}

}
