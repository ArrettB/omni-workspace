package com.dynamic.servicetrax.service;

import com.dynamic.servicetrax.dao.JasperReportDao;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import net.sf.jasperreports.engine.JRExporter;
import net.sf.jasperreports.engine.JRExporterParameter;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.data.JRMapCollectionDataSource;
import net.sf.jasperreports.engine.export.JRPdfExporter;
import net.sf.jasperreports.engine.export.JRPdfExporterParameter;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

/**
 * User: pgarvie
 * Date: May 28, 2010
 * Time: 2:03:51 PM
 */
public class JasperReportService {

    private static final Logger LOGGER = Logger.getLogger(JasperReportService.class);
    private static final String NEW_LINE = "\n";
    private static final String COMMA = ",";
    private static final String SPACE = " ";

    private JasperReportDao jasperReportDao;

    public ServiceRequestDto printServiceRequest(String realPath, String fileName, String requestId) {

        ServiceRequestDto helper = new ServiceRequestDto();

        try {
            Map<String, Object> allInfo = new HashMap<String, Object>();

            Map<String, Map<BigDecimal, String>> lookups = jasperReportDao.getLookups();

            Map<String, Object> requestInfo = jasperReportDao.getRequestInfo(requestId);
            allInfo.putAll(requestInfo);

            BigDecimal jobLocationContactId = (BigDecimal) requestInfo.get("job_location_contact_id");
            String jobLocationContact = buildContact(jasperReportDao.getContactInfo(jobLocationContactId));
            allInfo.put("jobLocationContact", jobLocationContact);

            BigDecimal amSalesContactId = (BigDecimal) requestInfo.get("a_m_sales_contact_id");
            String amSalesContact = buildContact(jasperReportDao.getContactInfo(amSalesContactId));
            allInfo.put("amSalesContact", amSalesContact);

            BigDecimal amContactId = (BigDecimal) requestInfo.get("a_m_contact_id");
            String amContact = buildContact(jasperReportDao.getContactInfo(amContactId));
            allInfo.put("amContact", amContact);

            BigDecimal customerContactId = (BigDecimal) requestInfo.get("customer_contact_id");
            String customerContact = buildContact(jasperReportDao.getContactInfo(customerContactId));
            allInfo.put("customerContact", customerContact);

            BigDecimal projectId = (BigDecimal) requestInfo.get("project_id");
            Map<String, Object> projectInfo = jasperReportDao.getProjectInfo(projectId);
            allInfo.putAll(projectInfo);

            BigDecimal customerId = (BigDecimal) projectInfo.get("customer_id");
            Map<String, Object> customerInfo = jasperReportDao.getCustomerInfo(customerId);
            allInfo.putAll(customerInfo);

            String quoteNumber = buildQuoteNumber(allInfo);
            allInfo.put("quoteNumber", quoteNumber);

            BigDecimal jobLocationId = (BigDecimal) allInfo.get("job_location_id");
            Map<String, Object> addressInfo = jasperReportDao.getAddressInfo(jobLocationId);
            allInfo.putAll(addressInfo);
            String address = buildAddress(addressInfo);
            allInfo.put("address", address);

            String scheduleWithClient = (String) allInfo.get("schedule_with_client_flag");
            allInfo.put("scheduleWithClient", scheduleWithClient != null && scheduleWithClient.equals("Y") ? "Yes" : "No");


            String scheduleType = lookupId(lookups, "schedule_type", (BigDecimal) allInfo.get("schedule_type_id"));
            allInfo.put("scheduleType", scheduleType);

            String startDate = formatDate((Date) allInfo.get("est_start_date"));
            allInfo.put("startDate", startDate);
            String startTime = formatTime((Date) allInfo.get("est_start_time"));
            allInfo.put("startTime", startTime);
            String endDate = formatDate((Date) allInfo.get("est_end_date"));
            allInfo.put("endDate", endDate);

            String systemFurniture = lookupId(lookups, "furniture_line_type", (BigDecimal) allInfo.get("system_furniture_line_type_id"));
            allInfo.put("systemFurniture", systemFurniture);

            String shippingMethod = lookupId(lookups, "delivery_type", (BigDecimal) allInfo.get("delivery_type_id"));
            allInfo.put("shippingMethod", shippingMethod);

            String otherFurniture = lookupId(lookups, "yes_no_type", (BigDecimal) allInfo.get("other_furniture_type_id"));
            allInfo.put("otherFurniture", otherFurniture);

            String otherShippingMethod = lookupId(lookups, "delivery_type", (BigDecimal) allInfo.get("other_delivery_type_id"));
            allInfo.put("otherShippingMethod", otherShippingMethod);

            String productDisposition = lookupId(lookups, "product_disposition_type", (BigDecimal) allInfo.get("prod_disp_id"));
            allInfo.put("productDisposition", productDisposition);

            String wallMount = lookupId(lookups, "wall_mount_type", (BigDecimal) allInfo.get("wall_mount_type_id"));
            allInfo.put("wallMount", wallMount);

            String deliveryConditions = lookupId(lookups, "elevator_available_type", (BigDecimal) allInfo.get("elevator_avail_type_id"));
            allInfo.put("deliveryConditions", deliveryConditions);

            String stairCarry = (String) allInfo.get("is_stair_carry_required");
            allInfo.put("stairCarry", stairCarry != null && stairCarry.equals("Y") ? "Yes" : "No");

            String planLocationType = lookupId(lookups, "plan_locations_type", (BigDecimal) allInfo.get("plan_location_type_id"));
            allInfo.put("planLocationType", planLocationType);

            String billingType = lookupId(lookups, "billing_type", (BigDecimal) allInfo.get("quote_type_id"));
            allInfo.put("billingType", billingType);

            String taxableFlag = (String) allInfo.get("taxable_flag");
            allInfo.put("taxableFlag", taxableFlag != null && taxableFlag.equals("Y") ? "Yes" : "No");

            String orderType = lookupId(lookups, "order_type", (BigDecimal) allInfo.get("order_type_id"));
            allInfo.put("orderType", orderType);

            String customerCosting = lookupId(lookups, "customer_costing_type", (BigDecimal) allInfo.get("customer_costing_type_id"));
            allInfo.put("customerCosting", customerCosting);

            String description = (String) allInfo.get("description");
            String singleSpaceDescription = description.replace("\r\r", "");
            allInfo.put("description", singleSpaceDescription);

            String otherConditions = (String) allInfo.get("other_conditions");
            allInfo.put("otherConditions", StringUtils.isEmpty(otherConditions) ? "None" : otherConditions);

            List<Map<String, Object>> documents = jasperReportDao.getAttachments(requestId);
            HashMap<String, Object> attachments = getAttachments(documents);
            if (attachments == null || attachments.size() == 0) {
                allInfo.put("attachmentFileName", "None");
            }
            else {
                allInfo.put("attachmentFileName", attachments.get("attachmentFileName"));
                allInfo.put("attachmentCreatedBy", attachments.get("attachmentCreatedBy"));
                allInfo.put("attachmentDate", attachments.get("attachmentDate"));
            }


            String dateCreated = formatDate((Date) allInfo.get("date_created"));
            allInfo.put("dateCreated", dateCreated);
            BigDecimal createdById = (BigDecimal) allInfo.get("created_by");
            allInfo.put("createdBy", jasperReportDao.getUser(createdById));

            String dateModified = formatDate((Date) allInfo.get("date_modified"));
            allInfo.put("dateModified", dateModified);
            BigDecimal modifiedById = (BigDecimal) allInfo.get("modified_by");
            allInfo.put("modifiedBy", jasperReportDao.getUser(modifiedById));

            ArrayList<Map<String, Object>> results = new ArrayList<Map<String, Object>>();
            results.add(allInfo);
            JRMapCollectionDataSource dataSource = new JRMapCollectionDataSource(results);

            JRExporter exporter = new JRPdfExporter();
            File file = new File(realPath + File.separator + fileName);
            if (file.canRead()) {
                JasperPrint jasperPrint = JasperFillManager.fillReport(file.getAbsolutePath(), null, dataSource);
                ByteArrayOutputStream byteArray = new ByteArrayOutputStream();
                exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, byteArray);
                exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
                exporter.setParameter(JRPdfExporterParameter.FORCE_LINEBREAK_POLICY, Boolean.TRUE);
                exporter.exportReport();
                helper.setQuoteNumber(quoteNumber);
                helper.setJasperOutput(byteArray);
                return helper;
            }
        }
        catch (Exception e) {
            LOGGER.error(e);
        }
        return helper;
    }

    private String lookupId(Map<String, Map<BigDecimal, String>> lookups, String key, BigDecimal id) {
        return lookups.get(key).get(id);
    }

    private String formatTime(Date timestamp) {
        if (timestamp == null) {
            return null;
        }
        return new SimpleDateFormat("h:mm a").format(timestamp);
    }

    private String formatDate(Date date) {
        if (date == null) {
            return null;
        }
        return new SimpleDateFormat("M/d/yyyy").format(date);
    }

    public ByteArrayOutputStream generateReport(String realPath, String hotSheetId, String extCustomerId, String dbPrefix) {

        Connection conn = null;

        try {

            Map<String, Object> parameters = new HashMap<String, Object>();
            parameters.put("ID", String.valueOf(hotSheetId));
            parameters.put("EXT_CUSTOMER_ID", String.valueOf(extCustomerId));
            parameters.put("SUBREPORT_DIR", realPath + File.separator);
            parameters.put("DB_PREFIX", dbPrefix + "ott_spGetPrimaryAddress");

            JRExporter exporter = new JRPdfExporter();
            conn = jasperReportDao.getConnection();
            File file = new File(realPath + File.separator + "billOfLadin.jasper");
            if (file.canRead()) {
                JasperPrint jasperPrint = JasperFillManager.fillReport(file.getAbsolutePath(),
                                                                       parameters,
                                                                       conn);

                ByteArrayOutputStream byteArray = new ByteArrayOutputStream();
                exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, byteArray);
                exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
                exporter.exportReport();
                return byteArray;
            }
        }
        catch (Exception e) {
            LOGGER.error(e);
        }
        finally {
            if (conn != null) {
                try {
                    conn.close();
                }
                catch (SQLException ignore) {
                    LOGGER.error(ignore);
                }
            }
        }
        return null;
    }

    @SuppressWarnings("unchecked")
    public HashMap<String, Object> getAttachments(List<Map<String, Object>> documents) {
        if (documents == null || documents.isEmpty()) {
            return null;
        }

        HashMap<String, Object> attachmentMap = new HashMap<String, Object>();
        StringBuilder builder = new StringBuilder();
        for (Map<String, Object> aDocument : documents) {
            builder.append(aDocument.get("name"));
            builder.append(NEW_LINE);
        }
        attachmentMap.put("attachmentFileName", builder.toString());

        builder = new StringBuilder();
        for (Map<String, Object> aDocument : documents) {
            builder.append(aDocument.get("created_by"));
            builder.append(NEW_LINE);
        }
        attachmentMap.put("attachmentCreatedBy", builder.toString());

        builder = new StringBuilder();
        for (Map<String, Object> aDocument : documents) {
            builder.append(aDocument.get("date_created"));
            builder.append(NEW_LINE);
        }
        attachmentMap.put("attachmentDate", builder.toString());

        return attachmentMap;
    }


    private String buildContact(Map<String, Object> contactInfo) {
        if (contactInfo.size() == 0) {
            return null;
        }

        String name = (String) contactInfo.get("contact_name");
        String workPhone = (String) contactInfo.get("phone_work");
        String cellPhone = (String) contactInfo.get("phone_cell");
        StringBuilder builder = new StringBuilder(name);
        builder.append(" : ");
        builder.append(workPhone != null ? workPhone : "No Phone Listed");
        builder.append(" : ");
        builder.append(cellPhone != null ? cellPhone : "No Cell Listed");
        return builder.toString();
    }


    private String buildAddress(Map<String, Object> addressInfo) {
        StringBuilder builder = new StringBuilder((String) addressInfo.get("street1"));
        String streetTwo = (String) addressInfo.get("street2");
        if (StringUtils.isNotEmpty(streetTwo)) {
            builder.append(NEW_LINE);
            builder.append(streetTwo);
        }
        builder.append(NEW_LINE);
        builder.append(addressInfo.get("city") == null ? StringUtils.EMPTY : addressInfo.get("city"));
        builder.append(COMMA);
        builder.append(SPACE);
        builder.append(addressInfo.get("state") == null ? StringUtils.EMPTY : addressInfo.get("state"));
        builder.append(SPACE);
        builder.append(addressInfo.get("zip") == null ? StringUtils.EMPTY : addressInfo.get("zip"));
        return builder.toString();
    }

    private String buildQuoteNumber(Map<String, Object> allInfo) {
        BigDecimal projectNumber = (BigDecimal) allInfo.get("project_no");
        BigDecimal requestNumber = (BigDecimal) allInfo.get("request_no");
        BigDecimal versionNumber = (BigDecimal) allInfo.get("version_no");
        StringBuilder builder = new StringBuilder(String.valueOf(projectNumber));
        builder.append("-");
        builder.append(String.valueOf(requestNumber));
        builder.append(".");
        builder.append(String.valueOf(versionNumber));
        return builder.toString();
    }

    public void setJasperReportDao(JasperReportDao jasperReportDao) {
        this.jasperReportDao = jasperReportDao;
    }
}
