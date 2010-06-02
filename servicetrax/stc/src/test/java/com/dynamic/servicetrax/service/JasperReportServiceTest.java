package com.dynamic.servicetrax.service;

import org.springframework.mock.web.MockServletConfig;
import org.springframework.test.AbstractTransactionalSpringContextTests;

import java.io.OutputStream;

/**
 * User: pgarvie
 * Date: May 28, 2010
 * Time: 8:58:27 PM
 */
public class JasperReportServiceTest extends AbstractTransactionalSpringContextTests {

    private JasperReportService jasperReportService;

    public void testGeneratingReport(){
//        MockServletConfig servletConfig = new MockServletConfig();
//        String path = "/Users/pgarvie/projects/omni/servicetrax/stc/src/main/webapp/reports";
//        OutputStream output = jasperReportService.generateReport(path, 47L);
//        System.out.println("");

    }


    @Override
    protected String[] getConfigLocations() {
        return new String[]{"applicationContext-test.xml"};
    }

    public void setJasperReportService(JasperReportService jasperReportService) {
        this.jasperReportService = jasperReportService;
    }
}





