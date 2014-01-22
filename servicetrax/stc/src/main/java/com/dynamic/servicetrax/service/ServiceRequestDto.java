package com.dynamic.servicetrax.service;

import java.io.ByteArrayOutputStream;

/**
 * User: pgarvie
 * Date: 1/21/14
 * Time: 10:47 PM  Jan 21 2014
 */
public class ServiceRequestDto {

    private String quoteNumber;
    private ByteArrayOutputStream jasperOutput;

    public void setQuoteNumber(String quoteNumber) {
        this.quoteNumber = quoteNumber;
    }

    public String getQuoteNumber() {
        return quoteNumber;
    }

    public void setJasperOutput(ByteArrayOutputStream jasperOutput) {
        this.jasperOutput = jasperOutput;
    }

    public ByteArrayOutputStream getJasperOutput() {
        return jasperOutput;
    }
}
