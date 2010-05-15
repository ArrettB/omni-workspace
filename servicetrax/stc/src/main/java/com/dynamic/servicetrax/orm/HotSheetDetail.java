package com.dynamic.servicetrax.orm;

/**
 * User: pgarvie
 * Date: May 14, 2010
 * Time: 10:07:40 AM
 */
public class HotSheetDetail extends AuditableObject {

    private Long hotSheetDetailId;

    private Long hotSheetId;

    private Long hotSheetLookupId;

    private Integer attributeValue;
    private String code;
    private String name;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public Long getHotSheetDetailId() {
        return hotSheetDetailId;
    }

    public void setHotSheetDetailId(Long hotSheetDetailId) {
        this.hotSheetDetailId = hotSheetDetailId;
    }

    public Long getHotSheetId() {
        return hotSheetId;
    }

    public void setHotSheetId(Long hotSheetId) {
        this.hotSheetId = hotSheetId;
    }

    public Long getHotSheetLookupId() {
        return hotSheetLookupId;
    }

    public void setHotSheetLookupId(Long hotSheetLookupId) {
        this.hotSheetLookupId = hotSheetLookupId;
    }

    public Integer getAttributeValue() {
        return attributeValue;
    }

    public void setAttributeValue(Integer attributeValue) {
        this.attributeValue = attributeValue;
    }
}
