package com.dynamic.servicetrax.command;


@SuppressWarnings({"UnusedDeclaration"})
public class OriginContactCommand {
    private String contactName;
    private String contactPhone;
    private String extDealerId;
    private String originContactId;
    private String jobLocationAddressId;

    public String getCustomerId() {
        return customerId;
    }

    public void setCustomerId(String customerId) {
        this.customerId = customerId;
    }

    private String customerId;

    public String getContactName() {
        return contactName;
    }

    public void setContactName(String contactName) {
        this.contactName = contactName;
    }

    public String getContactPhone() {
        return contactPhone;
    }

    public void setContactPhone(String contactPhone) {
        this.contactPhone = contactPhone;
    }

    public String getExtDealerId() {
        return extDealerId;
    }

    public void setExtDealerId(String extDealerId) {
        this.extDealerId = extDealerId;
    }

    public String getOriginContactId() {
        return originContactId;
    }

    public void setOriginContactId(String originContactId) {
        this.originContactId = originContactId;
    }

    public String getJobLocationAddressId() {
        return jobLocationAddressId;
    }

    public void setJobLocationAddressId(String jobLocationAddressId) {
        this.jobLocationAddressId = jobLocationAddressId;
    }
}
