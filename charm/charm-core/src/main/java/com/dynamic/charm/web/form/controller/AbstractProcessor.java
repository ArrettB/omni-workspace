/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: AbstractProcessor.java 375 2009-02-27 17:09:32Z bvonhaden $

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

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.hibernate.HibernateException;
import org.hibernate.exception.ConstraintViolationException;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.validation.Errors;

import com.dynamic.charm.exception.ParameterMissingException;
import com.dynamic.charm.exception.ParameterParseException;
import com.dynamic.charm.query.hibernate.HibernateService;
import com.dynamic.charm.web.CharmWebObjectSupport;
import com.dynamic.charm.web.RequestUtils;
import com.dynamic.charm.web.form.BoundProperty;
import com.dynamic.charm.web.form.FormModel;
import com.dynamic.charm.web.form.tag.ButtonTag;


public abstract class AbstractProcessor extends CharmWebObjectSupport
{
    private final static Logger logger = Logger.getLogger(AbstractProcessor.class);

    /**
     * Adds an error to the form model.  The error code is used to look up the appropriate message to display, otherwise the defaultMessage will be used.
     * @param model  The model to add the error to
     * @param bindName The name of the bound object this error applies to
     * @param errorCode The errorCode used to lookup the message
     * @param defaultMessage The message to be displayed if message under the errorCode is not found
     */
    public void addError(FormModel model, String bindName, String errorCode, String defaultMessage)
    {
        Errors errors = getErrors(model, bindName);
        errors.reject(errorCode, defaultMessage);
    }

    public void addError(FormModel model, String bindName, String fieldName, String errorCode,
        String defaultMessage)
    {
        Errors errors = getErrors(model, bindName);
        errors.rejectValue(fieldName, errorCode, defaultMessage);
    }

    public Errors getErrors(FormModel model, String bindName)
    {
        return model.getCharmDataBinder(bindName).getBindingResult();
    }

    /**
     * Retrieves a value from the servlet request for the given bound object and property
     * This is used to work with values that do not exist on the object itself.
     *
     * @param bindName The name of the bound object
     * @param propertyName The name of the property
     * @param request the current request
     */
    public String getExtendedProperty(String bindName, String propertyName,
        HttpServletRequest request)
    {
        BoundProperty bp = new BoundProperty(bindName, propertyName);
        return request.getParameter(bp.getBoundPropertyKey());
    }

    public Object performHibernateOperation(String bindName, FormModel model,
        HibernateService service, HibernateOperation operation)
    {
        Object result = null;
        try
        {
            result = operation.doInHibernate(service);
        }
        catch (DataIntegrityViolationException e)
        {
            logger.error("DataIntegrityViolationException in performHibernateOperation()", e);
            addError(model, bindName,
                "com.dynamic.charm.web.form.controller.abstractProcessor.dataIntegrityViolationException.message",
                "The row can not be deleted, it is referenced elsewhere.");
        }
        catch (ConstraintViolationException e)
        {
            logger.error("ConstraintViolationException in performHibernateOperation()", e);
            addError(model, bindName,
                "com.dynamic.charm.web.form.controller.abstractProcessor.constraintViolationException.message",
                "The row can not be deleted, it is referenced elsewhere.");
        }
        catch (HibernateException e)
        {
            logger.error("HibernateException in performHibernateOperation()", e);
            addError(model, bindName,
                "com.dynamic.charm.web.form.controller.abstractProcessor.hibernateException.message",
                "The row can not be deleted, it is referenced elsewhere.");
        }
        return result;
    }

    public String getSubmitType(HttpServletRequest request)
    {
        return request.getParameter(ButtonTag.FORM_SUBMIT_PARAM);
    }

    public boolean isCancel(HttpServletRequest request, HttpServletResponse response)
    {
        return "cancel".equalsIgnoreCase(getSubmitType(request));
    }

    public boolean isDelete(HttpServletRequest request, HttpServletResponse response)
    {
        return "delete".equalsIgnoreCase(getSubmitType(request));
    }

    public Boolean getBooleanParameter(HttpServletRequest request, String parameterName,
        boolean defaultValue) throws ParameterParseException
    {
        return RequestUtils.getBooleanParameter(request, parameterName, defaultValue);
    }

    public Boolean getBooleanParameter(HttpServletRequest request, String parameterName,
        Boolean defaultValue) throws ParameterParseException
    {
        return RequestUtils.getBooleanParameter(request, parameterName, defaultValue);
    }

    public Boolean getBooleanParameter(HttpServletRequest request, String parameterName)
        throws ParameterParseException
    {
        return RequestUtils.getBooleanParameter(request, parameterName);
    }

    public Double getDoubleParameter(HttpServletRequest request, String parameterName,
        double defaultValue) throws ParameterParseException
    {
        return RequestUtils.getDoubleParameter(request, parameterName, defaultValue);
    }

    public Double getDoubleParameter(HttpServletRequest request, String parameterName,
        Double defaultValue) throws ParameterParseException
    {
        return RequestUtils.getDoubleParameter(request, parameterName, defaultValue);
    }

    public Double getDoubleParameter(HttpServletRequest request, String parameterName)
        throws ParameterParseException
    {
        return RequestUtils.getDoubleParameter(request, parameterName);
    }

    public Float getFloatParameter(HttpServletRequest request, String parameterName,
        Float defaultValue) throws ParameterParseException
    {
        return RequestUtils.getFloatParameter(request, parameterName, defaultValue);
    }

    public Float getFloatParameter(HttpServletRequest request, String parameterName)
        throws ParameterParseException
    {
        return RequestUtils.getFloatParameter(request, parameterName);
    }

    public Float getFloatParameter(HttpServletRequest request, String parameterName,
        float defaultValue) throws ParameterParseException
    {
        return RequestUtils.getFloatParameter(request, parameterName, defaultValue);
    }

    public Integer getIntegerParameter(HttpServletRequest request, String parameterName,
        int defaultValue) throws ParameterParseException
    {
        return RequestUtils.getIntegerParameter(request, parameterName, defaultValue);
    }

    public Integer getIntegerParameter(HttpServletRequest request, String parameterName,
        Integer defaultValue) throws ParameterParseException
    {
        return RequestUtils.getIntegerParameter(request, parameterName, defaultValue);
    }

    public Integer getIntegerParameter(HttpServletRequest request, String parameterName)
        throws ParameterParseException
    {
        return RequestUtils.getIntegerParameter(request, parameterName);
    }

    public Long getLongParameter(HttpServletRequest request, String parameterName,
        long defaultValue) throws ParameterParseException
    {
        return RequestUtils.getLongParameter(request, parameterName, defaultValue);
    }

    public Long getLongParameter(HttpServletRequest request, String parameterName,
        Long defaultValue) throws ParameterParseException
    {
        return RequestUtils.getLongParameter(request, parameterName, defaultValue);
    }

    public Long getLongParameter(HttpServletRequest request, String parameterName)
        throws ParameterParseException
    {
        return RequestUtils.getLongParameter(request, parameterName);
    }

    public Boolean getRequiredBooleanParameter(HttpServletRequest request, String parameterName)
        throws ParameterMissingException, ParameterParseException
    {
        return RequestUtils.getRequiredBooleanParameter(request, parameterName);
    }

    public Double getRequiredDoubleParameter(HttpServletRequest request, String parameterName)
        throws ParameterMissingException, ParameterParseException
    {
        return RequestUtils.getRequiredDoubleParameter(request, parameterName);
    }

    public Float getRequiredFloatParameter(HttpServletRequest request, String parameterName)
        throws ParameterMissingException, ParameterParseException
    {
        return RequestUtils.getRequiredFloatParameter(request, parameterName);
    }

    public Integer getRequiredIntegerParameter(HttpServletRequest request, String parameterName)
        throws ParameterMissingException, ParameterParseException
    {
        return RequestUtils.getRequiredIntegerParameter(request, parameterName);
    }

    public Long getRequiredLongParameter(HttpServletRequest request, String parameterName)
        throws ParameterMissingException, ParameterParseException
    {
        return RequestUtils.getRequiredLongParameter(request, parameterName);
    }

    public String getRequiredStringParameter(HttpServletRequest request, String parameterName)
        throws ParameterMissingException
    {
        return RequestUtils.getRequiredStringParameter(request, parameterName);
    }

    public String getStringParameter(HttpServletRequest request, String parameterName,
        String defaultValue)
    {
        return RequestUtils.getStringParameter(request, parameterName, defaultValue);
    }

    public String getStringParameter(HttpServletRequest request, String parameterName)
    {
        return RequestUtils.getStringParameter(request, parameterName);
    }
}
