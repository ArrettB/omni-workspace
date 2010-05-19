package com.dynamic.servicetrax.orm;

import java.util.Date;

/**
 * User: pgarvie
 * Date: May 14, 2010
 * Time: 10:09:17 AM
 */
public abstract class AuditableObject {

    private Date dateCreated;

    private Long createdBy;

    private Date dateModified;

    private Long modifiedBy;

    public Date getDateCreated() {
        return dateCreated;
    }

    public void setDateCreated(Date dateCreated) {
        this.dateCreated = dateCreated;
    }

    public Long getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Long createdBy) {
        this.createdBy = createdBy;
    }

    public Date getDateModified() {
        return dateModified;
    }

    public void setDateModified(Date dateModified) {
        this.dateModified = dateModified;
    }

    public Long getModifiedBy() {
        return modifiedBy;
    }

    public void setModifiedBy(Long modifiedBy) {
        this.modifiedBy = modifiedBy;
    }
}
