package com.dynamic.servicetrax.orm;

import java.util.Date;
import java.util.List;
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
    private Long requestTypeId;

    private Date jobDate;
    private Integer jobStartTime;
    private Integer jobLength;
    private Integer warehouseStartTime;
    private String specialInstructions;

    private Map<String, HotSheetDetail> details;

    private String projectName;
    private String customerName;
    private String endUserName;

    private Address jobLocationAddress;
    private List<Address> destinationAddresses;

    private Long originAddressId;
    private Address originAddress;
    private List originAddresses;

    private Address billingAddress;

    private Long originContactId;
    private String originContactName;
    private String originContactPhone;
    private String originContactEmail;

    private Long salesContactId;
    private String salesContactName;
    private String salesContactPhone;

    //This is the destination address
    private Long jobLocationAddressId;
    private String jobContactName;
    private String jobContactPhone;
    private String jobContactEmail;

    private String dealerPONumber;
    private String description;

    private String requestCreatedName;
    private Date requestCreatedDate;
    private String requestModifiedName;
    private Date requestModifiedDate;
    private Long customerId;
    private Long endUserId;
    private String createdByName;
    private String modifiedByName;

    private String startTimeHour;
    private String startTimeMinutes;
    private String startTimeAMPM;
    private String warehouseStartTimeHour;
    private String warehouseStartTimeMinutes;
    private String warehouseStartTimeAMPM;

    private boolean shouldPrint;

    //This is the id for fetching the billing address info from GreatPlains.
    private String extCustomerId;
    private List<KeyValueBean> originContacts;
    private List<KeyValueBean> destinationAddressContacts;


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

    public void setJobLocationAddressId(Long jobLocationAddressId) {
        this.jobLocationAddressId = jobLocationAddressId;
    }

    public Long getJobLocationAddressId() {
        return jobLocationAddressId;
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

    public String getSpecialInstructions() {
        return specialInstructions;
    }

    public void setSpecialInstructions(String specialInstructions) {
        this.specialInstructions = specialInstructions;
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

    public Address getOriginAddress() {
        return originAddress;
    }

    public void setOriginAddress(Address originAddress) {
        this.originAddress = originAddress;
    }

    public Address getBillingAddress() {
        return billingAddress;
    }

    public void setBillingAddress(Address billingAddress) {
        this.billingAddress = billingAddress;
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

    public String getRequestCreatedName() {
        return requestCreatedName;
    }

    public void setRequestCreatedName(String requestCreatedName) {
        this.requestCreatedName = requestCreatedName;
    }

    public Date getRequestCreatedDate() {
        return requestCreatedDate;
    }

    public void setRequestCreatedDate(Date requestCreatedDate) {
        this.requestCreatedDate = requestCreatedDate;
    }

    public String getRequestModifiedName() {
        return requestModifiedName;
    }

    public void setRequestModifiedName(String requestModifiedName) {
        this.requestModifiedName = requestModifiedName;
    }

    public Date getRequestModifiedDate() {
        return requestModifiedDate;
    }

    public void setRequestModifiedDate(Date requestModifiedDate) {
        this.requestModifiedDate = requestModifiedDate;
    }

    public void setJobLocationAddress(Address jobLocationAddress) {
        this.jobLocationAddress = jobLocationAddress;
    }

    public Address getJobLocationAddress() {
        return jobLocationAddress;
    }

    public void setCustomerId(Long customerId) {
        this.customerId = customerId;
    }

    public Long getCustomerId() {
        return customerId;
    }

    public void setEndUserId(Long endUserId) {
        this.endUserId = endUserId;
    }

    public Long getEndUserId() {
        return endUserId;
    }

    public void setOriginAddresses(List originAddresses) {
        this.originAddresses = originAddresses;
    }

    public List getOriginAddresses() {
        return originAddresses;
    }

    public void setCreatedByName(String createByName) {
        this.createdByName = createByName;
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

    public Long getRequestTypeId() {
        return requestTypeId;
    }

    public void setRequestTypeId(Long requestTypeId) {
        this.requestTypeId = requestTypeId;
    }

    public String getStartTimeHour() {
        return startTimeHour;
    }

    public void setStartTimeHour(String startTimeHour) {
        this.startTimeHour = startTimeHour;
    }

    public String getStartTimeMinutes() {
        return startTimeMinutes;
    }

    public void setStartTimeMinutes(String startTimeMinutes) {
        this.startTimeMinutes = startTimeMinutes;
    }

    public String getStartTimeAMPM() {
        return startTimeAMPM;
    }

    public void setStartTimeAMPM(String startTimeAMPM) {
        this.startTimeAMPM = startTimeAMPM;
    }

    public String getWarehouseStartTimeHour() {
        return warehouseStartTimeHour;
    }

    public void setWarehouseStartTimeHour(String warehouseStartTimeHour) {
        this.warehouseStartTimeHour = warehouseStartTimeHour;
    }

    public String getWarehouseStartTimeMinutes() {
        return warehouseStartTimeMinutes;
    }

    public void setWarehouseStartTimeMinutes(String warehouseStartTimeMinutes) {
        this.warehouseStartTimeMinutes = warehouseStartTimeMinutes;
    }

    public String getWarehouseStartTimeAMPM() {
        return warehouseStartTimeAMPM;
    }

    public void setWarehouseStartTimeAMPM(String warehouseStartTimeAMPM) {
        this.warehouseStartTimeAMPM = warehouseStartTimeAMPM;
    }

    public boolean isShouldPrint() {
        return shouldPrint;
    }

    public void setShouldPrint(boolean shouldPrint) {
        this.shouldPrint = shouldPrint;
    }

    public void setExtCustomerId(String extCustomerId) {
        this.extCustomerId = extCustomerId;
    }

    public String getExtCustomerId() {
        return extCustomerId;
    }

    public void setOriginContacts(List<KeyValueBean> originContacts) {
        this.originContacts = originContacts;
    }

    public List<KeyValueBean> getOriginContacts() {
        return originContacts;
    }

    public Long getOriginContactId() {
        return originContactId;
    }

    public void setOriginContactId(Long originContactId) {
        this.originContactId = originContactId;
    }

    public String getOriginContactName() {
        return originContactName;
    }

    public void setOriginContactName(String originContactName) {
        this.originContactName = originContactName;
    }

    public String getOriginContactPhone() {
        return originContactPhone;
    }

    public void setOriginContactPhone(String originContactPhone) {
        this.originContactPhone = originContactPhone;
    }

    public String getOriginContactEmail() {
        return originContactEmail;
    }

    public void setOriginContactEmail(String originContactEmail) {
        this.originContactEmail = originContactEmail;
    }

    public List<Address> getDestinationAddresses() {
        return destinationAddresses;
    }

    public void setDestinationAddresses(List<Address> destinationAddresses) {
        this.destinationAddresses = destinationAddresses;
    }

    public Long getSalesContactId() {
        return salesContactId;
    }

    public void setSalesContactId(Long saleContactId) {
        this.salesContactId = saleContactId;
    }

    public String getSalesContactName() {
        return salesContactName;
    }

    public void setSalesContactName(String salesContactName) {
        this.salesContactName = salesContactName;
    }

    public String getSalesContactPhone() {
        return salesContactPhone;
    }

    public void setSalesContactPhone(String salseContactPhone) {
        this.salesContactPhone = salseContactPhone;
    }

    public void setDestinationAddressContacts(List<KeyValueBean> destinationAddressContacts) {
        this.destinationAddressContacts = destinationAddressContacts;
    }

    public List<KeyValueBean> getDestinationAddressContacts() {
        return destinationAddressContacts;
    }
}
