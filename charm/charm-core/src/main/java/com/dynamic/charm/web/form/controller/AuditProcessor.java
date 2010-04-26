/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: AuditProcessor.java 199 2006-11-14 23:38:41Z gcase $

* THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
* OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED.  IN NO EVENT SHALL DYNAMIC INFORMATIONS SYTEMS, LLC
* BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
* SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
* LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
* USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
* OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
* SUCH DAMAGE.
* ====================================================================
*/


package com.dynamic.charm.web.form.controller;

import java.util.Date;
import java.util.Iterator;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.web.servlet.ModelAndView;

import com.dynamic.charm.service.SecurityService;
import com.dynamic.charm.web.form.FormModel;


public class AuditProcessor extends AbstractProcessor implements FormProcessor, InitializingBean
{
    private final static Logger logger = Logger.getLogger(AuditProcessor.class);

    private String dateCreatedProperty = "dateCreated";
    private String dateModifiedProperty = "dateModified";
    private String createdByProperty = "createdBy";
    private String modifiedByProperty = "modifiedBy";

    private SecurityService securityService;

    public void registerRequiredProperties()
    {
        registerRequiredProperty("securityService");
    }

	public void afterPropertiesSetInternal()
	{
	}
	
    public ModelAndView handleSave(FormModel model, HttpServletRequest request,
        HttpServletResponse response)
    {
        return null;
    }

    public ModelAndView handleDelete(FormModel model, HttpServletRequest request,
        HttpServletResponse response)
    {
        return null;
    }

    public boolean validate(FormModel model, HttpServletRequest request,
        HttpServletResponse response)
    {
        return true;
    }

    public void onShowForm(FormModel model, HttpServletRequest request,
        HttpServletResponse response)
    {
    }

    public void performRequestBindings(FormModel model, HttpServletRequest request,
        HttpServletResponse response)
    {
        logger.debug("performRequestBindings()");

        Date now = new Date();
        String userId = securityService.getUserID(request);
        if ((userId == null) || userId.equalsIgnoreCase(""))
        {
            userId = "0";
        }

        Iterator iter = model.getBindNames();
        while (iter.hasNext())
        {
            String bindName = (String) iter.next();
            if (model.isWritableProperty(bindName, dateCreatedProperty) && (model.getBoundValue(bindName, dateCreatedProperty) == null))
            {
                model.setBoundValue(bindName, dateCreatedProperty, now);
            }
            if (model.isWritableProperty(bindName, createdByProperty) && (model.getBoundValue(bindName, createdByProperty) == null))
            {
                model.setBoundValue(bindName, createdByProperty, userId);
            }

            if (model.isWritableProperty(bindName, dateModifiedProperty))
            {
                model.setBoundValue(bindName, dateModifiedProperty, now);
            }
            if (model.isWritableProperty(bindName, modifiedByProperty))
            {
                model.setBoundValue(bindName, modifiedByProperty, userId);
            }
        }
    }

    public String getCreatedByProperty()
    {
        return createdByProperty;
    }

    public void setCreatedByProperty(String createdByProperty)
    {
        this.createdByProperty = createdByProperty;
    }

    public String getDateCreatedProperty()
    {
        return dateCreatedProperty;
    }

    public void setDateCreatedProperty(String dateCreatedProperty)
    {
        this.dateCreatedProperty = dateCreatedProperty;
    }

    public String getDateModifiedProperty()
    {
        return dateModifiedProperty;
    }

    public void setDateModifiedProperty(String dateModifiedProperty)
    {
        this.dateModifiedProperty = dateModifiedProperty;
    }

    public String getModifiedByProperty()
    {
        return modifiedByProperty;
    }

    public void setModifiedByProperty(String modifiedByProperty)
    {
        this.modifiedByProperty = modifiedByProperty;
    }

    public SecurityService getSecurityService()
    {
        return securityService;
    }

    public void setSecurityService(SecurityService securityService)
    {
        this.securityService = securityService;
    }

}
