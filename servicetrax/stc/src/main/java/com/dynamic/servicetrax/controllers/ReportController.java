package com.dynamic.servicetrax.controllers;

import com.dynamic.servicetrax.service.JasperReportService;
import com.dynamic.servicetrax.service.ServiceRequestDto;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.util.Date;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

/**
 * User: pgarvie
 * Date: Apr 22, 2011
 * Time: 8:18:51 PM
 */
public class ReportController extends MultiActionController {

    private static final Logger LOGGER = Logger.getLogger(ReportController.class);
    private JasperReportService jasperReportService;

    @SuppressWarnings("unused")
    public void printServiceRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String requestId = request.getParameter("requestId");
        String path = request.getSession().getServletContext().getRealPath("reports");
        String filePath = getFilePath();
        ServiceRequestDto helper = jasperReportService.printServiceRequest(path, filePath, requestId);

        ByteArrayOutputStream data = helper.getJasperOutput();

        if (data == null) {
            StringBuilder message = new StringBuilder("Could not generate a report for service request id ");
            message.append(requestId);
            message.append(". Please check the error log. ");
            message.append(new Date());
            LOGGER.error(message.toString());
            response.setContentType("text/plain");
            data = new ByteArrayOutputStream();
            data.write(message.toString().getBytes());
        }
        else {
            response.setHeader("Content-disposition", "attachment; filename=" + helper.getQuoteNumber() + "_ServiceRequest.pdf");
            response.setContentType("application/pdf");
        }

        ServletOutputStream output = response.getOutputStream();
        output.write(data.toByteArray());
        response.flushBuffer();
    }

    private String getFilePath() {
        StringBuilder builder = new StringBuilder(File.separator);
        builder.append("serviceRequest");
        builder.append(File.separator);
        builder.append("printServiceRequest.jasper");
        return builder.toString();
    }

    public void setJasperReportService(JasperReportService jasperReportService) {
        this.jasperReportService = jasperReportService;
    }
}
