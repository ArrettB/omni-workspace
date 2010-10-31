package com.dynamic.servicetrax.orm;

/**
 * User: pgarvie
 * Date: May 21, 2010
 * Time: 9:02:39 AM
 */
public class Address {

    private Long jobLocationId;
    private String jobLocationName;
    private String streetOne;
    private String streetTwo;
    private String streetThree;
    private String city;
    private String state;
    private String zip;
    private String country;
    private String jobLocationCustomerId;
    private String endUserId;


    public Long getJobLocationId() {
        return jobLocationId;
    }

    public void setJobLocationId(Long jobLocationId) {
        this.jobLocationId = jobLocationId;
    }

    public String getJobLocationName() {
        return jobLocationName;
    }

    public void setJobLocationName(String jobLocationName) {
        this.jobLocationName = jobLocationName;
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

    public String getJobLocationCustomerId() {
        return jobLocationCustomerId;
    }

    public void setJobLocationCustomerId(String jobLocationCustomerId) {
        this.jobLocationCustomerId = jobLocationCustomerId;
    }

    public String getEndUserId() {
        return endUserId;
    }

    public void setEndUserId(String endUserId) {
        this.endUserId = endUserId;
    }
}
