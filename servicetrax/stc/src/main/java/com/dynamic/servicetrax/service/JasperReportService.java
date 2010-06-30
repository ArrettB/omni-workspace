package com.dynamic.servicetrax.service;

import net.sf.jasperreports.engine.JRExporter;
import net.sf.jasperreports.engine.JRExporterParameter;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.export.JRPdfExporter;
import org.apache.log4j.Logger;
import org.springframework.jdbc.core.JdbcTemplate;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

/**
 * User: pgarvie
 * Date: May 28, 2010
 * Time: 2:03:51 PM
 */
public class JasperReportService {

    private static final Logger LOGGER = Logger.getLogger(JasperReportService.class);

    private JdbcTemplate jdbcTemplate;

    public ByteArrayOutputStream generateReport(String realPath, String hotSheetId, String extCustomerId, String dbPrefix) {

        Connection conn = null;

        try {

            Map<String, Object> parameters = new HashMap<String, Object>();
            parameters.put("ID", String.valueOf(hotSheetId));
            parameters.put("EXT_CUSTOMER_ID", String.valueOf(extCustomerId));
            parameters.put("SUBREPORT_DIR", realPath + File.separator);
            parameters.put("DB_PREFIX", dbPrefix + "ott_spGetPrimaryAddress");

            JRExporter exporter = new JRPdfExporter();
            conn = jdbcTemplate.getDataSource().getConnection();
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

    @SuppressWarnings("unused")
    public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }
}