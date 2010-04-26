package com.dynamic.servicetrax.invoice;

import java.sql.Date;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;
import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.directwebremoting.WebContextFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.jdbc.core.SqlParameter;
import org.springframework.jdbc.object.SqlUpdate;

import com.dynamic.charm.common.LogUtil;
import com.dynamic.charm.query.hibernate.HibernateService;
import com.dynamic.charm.service.QueryService;
import com.dynamic.servicetrax.dao.LookupsDao;
import com.dynamic.servicetrax.support.ServiceTraxDWRObjectSupport;
import com.dynamic.servicetrax.transfer.ItemInfo;
import com.dynamic.servicetrax.transfer.ServiceInfo;
import com.dynamic.servicetrax.util.DistinctList;


public class InvoiceManager extends ServiceTraxDWRObjectSupport implements InitializingBean
{
	private static final String SESSION_ATTR_RECORDS = InvoiceManager.class.getName() + ".records";
 //   private static final String SESSION_ATTR_HIB_RECORDS = InvoiceManager.class.getName() + ".hibernateRecords";
    private static final String SESSION_ATTR_INVOICE_ID = InvoiceManager.class.getName() + ".invoiceId";
    private static final String SESSION_ATTR_DELETED = InvoiceManager.class.getName() + ".deleted";

	private int maxItems = 30;
	private QueryService queryService;
	private LookupsDao lookupsDao;
    private DataSource dataSource;

    private DeleteOperation deleteOperation ;
    private UpdateOperation updateOperation;
    private InsertOperation insertOperation;
    private UpdateInvoice updateInvoiceOperation;

    private final static Logger logger = Logger.getLogger(InvoiceManager.class);


	@Override
	public void afterPropertiesSetInternal()
	{
	       LogUtil.flowerBoxDebug( logger, "dataSource = " + getDataSource() );
	        deleteOperation = new DeleteOperation( getDataSource() );
	        updateOperation = new UpdateOperation( getDataSource() );
	        insertOperation = new InsertOperation( getDataSource() );
	        updateInvoiceOperation = new UpdateInvoice( getDataSource() );
	}

	@Override
	public void registerRequiredProperties()
	{
		 registerRequiredProperty("queryService");
		 registerRequiredProperty("lookupsDao");
		 registerRequiredProperty("dataSource");
	}


    public Map<Long, InvoiceLineRecord> sessionTransferRecords()
    {
        HttpSession session = WebContextFactory.get().getSession();
        Map<Long, InvoiceLineRecord> result = (Map<Long, InvoiceLineRecord>) session.getAttribute( SESSION_ATTR_RECORDS );
        if (result == null)
        {
            result = new LinkedHashMap<Long, InvoiceLineRecord>();
            session.setAttribute( SESSION_ATTR_RECORDS, result );
        }
        return result;
    }

    public Long sessionInvoiceId()
    {
        HttpSession session = WebContextFactory.get().getSession();
        return (Long) session.getAttribute( SESSION_ATTR_INVOICE_ID );
    }

    public List sessionDeletedRecords()
    {
        HttpSession session = WebContextFactory.get().getSession();
        List result = (List) session.getAttribute( SESSION_ATTR_DELETED );
        if (result == null)
        {
            result = new ArrayList<InvoiceLineRecord>();
            session.setAttribute( SESSION_ATTR_DELETED, result );
        }
        return result;
    }


	public QueryService getQueryService()
	{
		return queryService;
	}

	public void setQueryService(QueryService queryService)
	{
		this.queryService = queryService;
	}

    private List fetchAllRecords()
    {
        return queryService.namedQueryForList("invoiceManager.invoiceLineItems.hibernate", sessionInvoiceId());
    }

    /**
     * Used to initilize the manager
     * @param invoiceId
     * @return
     */
    public Collection<InvoiceLineRecord> loadRecords(Long invoiceId)
    {
        HttpSession session = WebContextFactory.get().getSession();
        session.setAttribute(SESSION_ATTR_INVOICE_ID, invoiceId);

        List<InvoiceLineRecord> deleted = sessionDeletedRecords();
        deleted.clear();

        List<InvoiceLineRecord> records = fetchAllRecords();
		Map<Long, InvoiceLineRecord> transferMap = sessionTransferRecords();
		transferMap.clear();
        for (InvoiceLineRecord record : records)
        {
        	transferMap.put(record.getInvoiceLineNo(), record);
        }

        return transferMap.values();
    }

    public Collection<InvoiceLineRecord> refreshRecords()
    {
    	return sessionTransferRecords().values();
    }


	public InvoiceLineRecord getRecord(long invoiceLineNo)
	{
		Map<Long, InvoiceLineRecord> records = sessionTransferRecords();
	    return records.get(invoiceLineNo);
	}

	public Map<String,Double> getSubTotals()
	{
		Map<String,Double> result = new LinkedHashMap<String,Double>();
		Map<Long, InvoiceLineRecord> records = sessionTransferRecords();
		for (InvoiceLineRecord record : records.values())
		{
			String key = record.getItemString().trim();
			Double subtotal = result.get(key);
			if (subtotal == null)
			{
				subtotal = Double.valueOf(0);
			}
			result.put(key, Double.valueOf(subtotal.doubleValue() + record.getTotal()));
		}

		return result;
	}

	public String updateRecord(InvoiceLineRecord toAdd)
	{
		logger.debug("toAdd.getItemId = "  + toAdd.getItemId());
		logger.debug("toAdd.getItemString = "  + toAdd.getItemString());
		logger.debug("toAdd.getServiceId = "  + toAdd.getServiceId());
		logger.debug("toAdd.getItemString = "  + toAdd.getItemString());
		logger.debug("toAdd.getQty = "  + toAdd.getQty());
		logger.debug("toAdd.getRate = "  + toAdd.getRate());
		logger.debug("toAdd.getDescription = "  + toAdd.getDescription());

		Map<Long, InvoiceLineRecord> records = sessionTransferRecords();
	    records.put(toAdd.getInvoiceLineNo(), toAdd);



	    return getMessage("servicetrax.tc.time.msgs.add");
	}


	public String deleteRecord(InvoiceLineRecord toDelete)
	{
        Map<Long, InvoiceLineRecord> records = sessionTransferRecords();

        InvoiceLineRecord deleted = records.remove(toDelete.getInvoiceLineNo());
        if (deleted.getInvoiceLineId() > 0)
        {
            sessionDeletedRecords().add(deleted);
        }

        //need to renumber the line numbers, and rebuild our map
        int lineNo = 1;
        ArrayList<InvoiceLineRecord> renumberList = new ArrayList<InvoiceLineRecord>();
        renumberList.addAll(records.values());
        records.clear();
        for (InvoiceLineRecord record : renumberList)
		{
        	record.setInvoiceLineNo(lineNo++);
        	records.put(record.getInvoiceLineNo(), record);
		}

	    return getMessage("servicetrax.tc.time.msgs.delete");
	}

	public String resetRecords()
	{
		//this resets the deleted list and reloads the records
		loadRecords(sessionInvoiceId());

		return getMessage("servicetrax.billing.invoices.msgs.reset");
	}

	public String commitRecords()
	{
		List poNumbers = new DistinctList();

		Map<Long,  InvoiceLineRecord> records = sessionTransferRecords();
        for (InvoiceLineRecord record : records.values())
        {
            if (record.getInvoiceLineId() > 0)
            {
                logger.debug("Updating line #" + record.getInvoiceLineNo() + " with id = " + record.getInvoiceLineId());
                updateOperation.run(record);
            }
            else
            {
                logger.debug("Inserting line #" + record.getInvoiceLineNo() + " with id = " + record.getInvoiceLineId());
                insertOperation.run(record);
            }

            poNumbers.add(record.getPoNo());
        }



        List<InvoiceLineRecord> deleteList = sessionDeletedRecords();
        for (InvoiceLineRecord record : deleteList)
        {
				logger.debug("Deleting line #" + record.getInvoiceLineNo() + " with id = " + record.getInvoiceLineId());
				deleteOperation.run(record.getInvoiceLineId());

         }

        //since we manipulated the database with jdbc, we need to clear the cache
        HibernateService hs = (HibernateService) getQueryService().getDataService(QueryService.DEFAULT_HIBERNATE_SERVICE_NAME);
        hs.getSessionFactory().evictQueries();

        StringBuffer poString = new StringBuffer();
		for (Iterator iter = poNumbers.iterator(); iter.hasNext();)
		{
			String po = (String) iter.next();
			poString.append(po);
			if (iter.hasNext())
			{
				poString.append(", ");
			}
		}

        updateInvoiceOperation.run(poString.toString(), sessionInvoiceId());


		//this resets the deleted list and reloads the records
		loadRecords(sessionInvoiceId());


        return getMessage("servicetrax.billing.invoices.msgs.commit", new Object[] {records.size()});
	}




	public List<ItemInfo> getItemInfos(String itemString)
	{

		itemString += "%";
		String[] paramNames = new String[] { "organization_id", "invoice_id", "item_name" };
		Object[] paramValues = new Object[] { new Long(getOrganizationId()), sessionInvoiceId(), itemString };

		List<Map> queryResults = queryService.namedQueryForList("invoiceManager.items.jdbc", paramNames, paramValues);

		if (queryResults != null)
		{
			if (queryResults.size() >= maxItems)
			{
				queryResults = queryResults.subList(0, maxItems - 1);
			}
		}

		List<ItemInfo> result = new ArrayList<ItemInfo>(queryResults.size());
		for (Map row : queryResults)
		{
			String id = getMapValue(row, "item_id");
			String name = getMapValue(row, "item_name");
			result.add(new ItemInfo(id, name));
		}
		return result;
	}
	
	public List<ServiceInfo> getServiceInfos(String serviceString)
	{

		serviceString += "%";
		String[] paramNames = new String[] { "invoice_id", "service_no" };
		Object[] paramValues = new Object[] { sessionInvoiceId(), serviceString };

		List<Map> queryResults = queryService.namedQueryForList("invoiceManager.services.jdbc", paramNames, paramValues);

		if (queryResults != null)
		{
			if (queryResults.size() >= maxItems)
			{
				queryResults = queryResults.subList(0, maxItems - 1);
			}
		}

		List<ServiceInfo> result = new ArrayList<ServiceInfo>(queryResults.size());
		for (Map row : queryResults)
		{
			String id = getMapValue(row, "service_id");
			String num = getMapValue(row, "service_no");
			result.add(new ServiceInfo(id, num));
		}
		return result;
	}

	private String getMapValue(Map row, String key)
	{
		Object value = row.get(key);
		if (value != null)
		{
			return value.toString();
		}
		else
		{
			return "N/A";
		}
	}





	public class DeleteOperation extends SqlUpdate
	{

		public DeleteOperation(DataSource ds)
		{

            setDataSource(ds);
			setSql("DELETE FROM invoice_lines WHERE invoice_line_id = ?");
			declareParameter(new SqlParameter(Types.NUMERIC));
			compile();
		}

		/**
		 * @param invoiceLineId
		 *            for the invoice_line to be delete
		 * @return number of rows deleted
		 */
		public int run(long id)
		{
			Object[] params = new Object[] { new Long(id) };
			return update(params);
		}
	}

	public class UpdateOperation extends SqlUpdate
	{

		private static final String UPDATE 
			= "UPDATE invoice_lines "
			+ "   SET invoice_line_no = ?,"
			+ "       item_id = ?,"
			+ "       bill_service_id = ?,"
			+ "       po_no = ?,"
			+ "       description = ?,"
			+ "       qty = ?,"
			+ "       unit_price = ?,"
			+ "       taxable_flag = ?,"
			+ "       date_modified = ?,"
			+ "       modified_by = ? "
			+ " WHERE invoice_line_id = ?";

        public UpdateOperation(DataSource ds)
		{
			setDataSource(ds);
			setSql(UPDATE);
			declareParameter(new SqlParameter(Types.NUMERIC));
			declareParameter(new SqlParameter(Types.NUMERIC));
			declareParameter(new SqlParameter(Types.NUMERIC));
			declareParameter(new SqlParameter(Types.VARCHAR));
			declareParameter(new SqlParameter(Types.VARCHAR));
			declareParameter(new SqlParameter(Types.NUMERIC));
			declareParameter(new SqlParameter(Types.NUMERIC));
			declareParameter(new SqlParameter(Types.VARCHAR));
			declareParameter(new SqlParameter(Types.TIMESTAMP));
			declareParameter(new SqlParameter(Types.NUMERIC));
			declareParameter(new SqlParameter(Types.NUMERIC));
			compile();
		}


		public int run(InvoiceLineRecord record)
		{
            Date now = new Date(System.currentTimeMillis());

            Object[] params = new Object[] {record.getInvoiceLineNo(),  record.getItemId(), record.getServiceId(), record.getPoNo(), record.getDescription(), record.getQty(), record.getRate(), record.getTaxableFlag(), now, getUserId(), record.getInvoiceLineId() };
			return update(params);
		}
	}


	public class UpdateInvoice extends SqlUpdate
	{

		private static final String UPDATE = "UPDATE invoices SET po_no = ?, date_modified = ?, modified_by = ? WHERE invoice_id = ?";


        public UpdateInvoice(DataSource ds)
		{
			setDataSource(ds);
			setSql(UPDATE);
			declareParameter(new SqlParameter(Types.VARCHAR));
			declareParameter(new SqlParameter(Types.TIMESTAMP));
			declareParameter(new SqlParameter(Types.NUMERIC));
			declareParameter(new SqlParameter(Types.NUMERIC));
			compile();
		}


		public int run(String poNo, Long invoiceId)
		{
	        Date now = new Date(System.currentTimeMillis());

            Object[] params = new Object[] {poNo, now, getUserId(), invoiceId};
			return update(params);
		}
	}


    public class InsertOperation extends SqlUpdate
    {
        private static final String INSERT 
    	= "INSERT INTO invoice_lines (invoice_id," 
    	+ "                           invoice_line_type_id," 
    	+ "                           invoice_line_no,"
    	+ "                           item_id," 
    	+ "                           bill_service_id,"
    	+ "                           po_no,"
    	+ "                           description,"
    	+ "                           qty," 
    	+ "                           unit_price,"
    	+ "                           taxable_flag,"
    	+ "                           date_created,"
    	+ "                           created_by) "
    	+ " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        public InsertOperation(DataSource ds)
        {
            setDataSource(ds);
            setSql(INSERT);
            declareParameter(new SqlParameter(Types.NUMERIC));
            declareParameter(new SqlParameter(Types.NUMERIC));
            declareParameter(new SqlParameter(Types.NUMERIC));
            declareParameter(new SqlParameter(Types.NUMERIC));
            declareParameter(new SqlParameter(Types.NUMERIC));
            declareParameter(new SqlParameter(Types.VARCHAR));
            declareParameter(new SqlParameter(Types.VARCHAR));
            declareParameter(new SqlParameter(Types.NUMERIC));
            declareParameter(new SqlParameter(Types.NUMERIC));
            declareParameter(new SqlParameter(Types.VARCHAR));
            declareParameter(new SqlParameter(Types.TIMESTAMP));
            declareParameter(new SqlParameter(Types.NUMERIC));

            compile();
        }

        public int run(InvoiceLineRecord record)
        {
            Date now = new Date(System.currentTimeMillis());
            Integer customLineTypeId = Integer.parseInt(lookupsDao.getLookupId("invoice_line_type", "custom").toString());

            Object[] params = new Object[] {
                    sessionInvoiceId(),
                    customLineTypeId,
                    record.getInvoiceLineNo(),
                    record.getItemId(),
                    record.getServiceId(),
                    record.getPoNo(),
                    record.getDescription(),
                    record.getQty(),
                    record.getRate(),
                    record.getTaxableFlag(),
                    now,
                    getUserId() };



            return update(params);
        }
    }

    public DataSource getDataSource()
    {
        return dataSource;
    }

    public void setDataSource( DataSource dataSource )
    {
        this.dataSource = dataSource;
    }

    public LookupsDao getLookupsDao()
	{
		return lookupsDao;
	}

	public void setLookupsDao(LookupsDao lookupsDao)
	{
		this.lookupsDao = lookupsDao;
	}
}
