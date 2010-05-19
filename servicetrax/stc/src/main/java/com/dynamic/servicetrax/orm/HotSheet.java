package com.dynamic.servicetrax.orm;

import java.util.Date;
import java.util.Map;

/**
 * User: pgarvie
 * Date: May 13, 2010
 * Time: 3:34:08 PM
 */
public class HotSheet extends AuditableObject {

    private Long hotSheetId;

    private Integer hotSheetNumber;
    private String hotSheetIdentifier;

    private Long jobLocationContactId;
    private Long requestId;
    private Long projectId;

    private String streetOne;
    private String streetTwo;
    private String streetThree;
    private String city;
    private String state;
    private String zip;
    private String country;

    private Date jobDate;
    private Integer jobStartTime;
    private Integer jobLength;
    private Integer warehouseStartTime;
    private String specialConditions;

    private Map<String, HotSheetDetail> details;


    private String projectName;
    private String customerName;
    private String endUserName;
    private Long originAddressId;
    private Long billingAddressId;
    private String createdByName;
    private String modifiedByName;
    private String jobLocationName;
    private String jobContactName;
    private String jobContactEmail;
    private String jobContactPhone;
    private String dealerPONumber;
    private String description;

    public Long getHotSheetId() {
        return hotSheetId;
    }

    public void setHotSheetId(Long hotSheetId) {
        this.hotSheetId = hotSheetId;
    }

    public Integer getHotSheetNumber() {
        return hotSheetNumber;
    }

    public void setHotSheetNumber(Integer hotSheetNumber) {
        this.hotSheetNumber = hotSheetNumber;
    }

    public Long getJobLocationContactId() {
        return jobLocationContactId;
    }

    public void setJobLocationContactId(Long jobLocationContactId) {
        this.jobLocationContactId = jobLocationContactId;
    }

    public Long getRequestId() {
        return requestId;
    }

    public void setRequestId(Long requestId) {
        this.requestId = requestId;
    }

    public Long getProjectId() {
        return projectId;
    }

    public void setProjectId(Long projectId) {
        this.projectId = projectId;
    }

    public String getStreetOne() {
        return streetOne;
    }

    public void setStreetOne(String streetOne) {
        this.streetOne = streetOne;
    }

    public String getStreetTwo() {
        return streetTwo;
    }

    public void setStreetTwo(String streetTwo) {
        this.streetTwo = streetTwo;
    }

    public String getStreetThree() {
        return streetThree;
    }

    public void setStreetThree(String streetThree) {
        this.streetThree = streetThree;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getZip() {
        return zip;
    }

    public void setZip(String zip) {
        this.zip = zip;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public Date getJobDate() {
        return jobDate;
    }

    public void setJobDate(Date jobDate) {
        this.jobDate = jobDate;
    }

    public Integer getJobStartTime() {
        return jobStartTime;
    }

    public void setJobStartTime(Integer jobStartTime) {
        this.jobStartTime = jobStartTime;
    }

    public Integer getJobLength() {
        return jobLength;
    }

    public void setJobLength(Integer jobLength) {
        this.jobLength = jobLength;
    }

    public Integer getWarehouseStartTime() {
        return warehouseStartTime;
    }

    public void setWarehouseStartTime(Integer warehouseStartTime) {
        this.warehouseStartTime = warehouseStartTime;
    }

    public String getSpecialConditions() {
        return specialConditions;
    }

    public void setSpecialConditions(String specialConditions) {
        this.specialConditions = specialConditions;
    }

    public Map<String, HotSheetDetail> getDetails() {
        return details;
    }

    public void setDetails(Map<String, HotSheetDetail> details) {
        this.details = details;
    }

    public void setHotSheetIdentifier(String hotSheetIdentifier) {
        this.hotSheetIdentifier = hotSheetIdentifier;
    }

    public String getHotSheetIdentifier() {
        return hotSheetIdentifier;
    }

    public void setProjectName(String projectName) {
        this.projectName = projectName;
    }

    public String getProjectName() {
        return projectName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setEndUserName(String endUserName) {
        this.endUserName = endUserName;
    }

    public String getEndUserName() {
        return endUserName;
    }

    public void setOriginAddressId(Long originAddressId) {
        this.originAddressId = originAddressId;
    }

    public Long getOriginAddressId() {
        return originAddressId;
    }

    public Long getBillingAddressId() {
        return billingAddressId;
    }

    public void setBillingAddressId(Long billingAddressId) {
        this.billingAddressId = billingAddressId;
    }

    public void setCreatedByName(String createdByName) {
        this.createdByName = createdByName;
    }

    public String getCreatedByName() {
        return createdByName;
    }

    public void setModifiedByName(String modifiedByName) {
        this.modifiedByName = modifiedByName;
    }

    public String getModifiedByName() {
        return modifiedByName;
    }

    public void setJobLocationName(String jobLocationName) {
        this.jobLocationName = jobLocationName;
    }

    public String getJobLocationName() {
        return jobLocationName;
    }

    public void setJobContactName(String jobContactName) {
        this.jobContactName = jobContactName;
    }

    public String getJobContactName() {
        return jobContactName;
    }

    public void setJobContactEmail(String jobContactEmail) {
        this.jobContactEmail = jobContactEmail;
    }

    public String getJobContactEmail() {
        return jobContactEmail;
    }

    public void setJobContactPhone(String jobContactPhone) {
        this.jobContactPhone = jobContactPhone;
    }

    public String getJobContactPhone() {
        return jobContactPhone;
    }

    public void setDealerPONumber(String dealerPONumber) {
        this.dealerPONumber = dealerPONumber;
    }

    public String getDealerPONumber() {
        return dealerPONumber;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }
}