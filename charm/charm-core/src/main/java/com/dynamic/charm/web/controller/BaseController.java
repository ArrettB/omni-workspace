/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: BaseController.java 199 2006-11-14 23:38:41Z gcase $

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


package com.dynamic.charm.web.controller;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang.SystemUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.BeanWrapper;
import org.springframework.beans.BeanWrapperImpl;
import org.springframework.beans.factory.BeanInitializationException;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.context.ApplicationContextAware;
import org.springframework.web.servlet.mvc.AbstractController;
import org.springframework.web.servlet.mvc.Controller;

import com.dynamic.charm.common.ApplicationContextHelper;
import com.dynamic.charm.exception.ParameterMissingException;
import com.dynamic.charm.exception.ParameterParseException;
import com.dynamic.charm.web.RequestUtils;


public abstract class BaseController extends AbstractController implements InitializingBean, Controller, ApplicationContextAware
{
    private final static Logger logger = Logger.getLogger(BaseController.class);

    protected List requiredProperties = new LinkedList();
	private ApplicationContextHelper applicationContextHelper;

	public BaseController()
	{
		registerRequiredProperties();
	}

	public abstract void registerRequiredProperties();
	public abstract void afterPropertiesSetInternal();

    public void registerRequiredProperty(String propertyName)
    {
        requiredProperties.add(propertyName);
    }

	public void afterPropertiesSet() throws Exception
	{
		for (Iterator iter = requiredProperties.iterator(); iter.hasNext();)
		{
			String propertyName = (String) iter.next();
			BeanWrapper bw = new BeanWrapperImpl(this);
			if (bw.isReadableProperty(propertyName))
			{
				Object propValue = BeanUtils.getProperty(this, propertyName);
				if (propValue == null) 
				{
					throw new BeanInitializationException(propertyName + " is a required property of " + this.getClass().getName() + ".  Please edit your configuration fiile accordingly."); 
				}
			}
			else
			{
				throw new BeanInitializationException(propertyName + " can not be read on "+ this.getClass().getName() + ".   Make sure the class has a getter for the property."); 
			}

		}

		if (SystemUtils.isJavaVersionAtLeast(1.5f))
		{
			// getClass().getf
		}
		applicationContextHelper = new ApplicationContextHelper(getApplicationContext());

		afterPropertiesSetInternal();
	}

    public void setSessionAttribute(HttpServletRequest req, String attributeName, Object value)
    {
        req.getSession().setAttribute(attributeName, value);
    }

    public Object getSessionAttribute(HttpServletRequest req, String attributeName)
    {
        return req.getSession().getAttribute(attributeName);
    }

    public void removeSessionAttribute(HttpServletRequest req, String attributeName)
    {
        req.getSession().removeAttribute(attributeName);
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

	public Object getBean(String name, Class requiredType)
	{
		return applicationContextHelper.getBean(name, requiredType);
	}

	public Object getBean(String name)
	{
		return applicationContextHelper.getBean(name);
	}

	public Object[] getBeansOfType(Class requiredType)
	{
		return applicationContextHelper.getBeansOfType(requiredType);
	}

	public String getMessage(String key, Object[] args)
	{
		return applicationContextHelper.getMessage(key, args);
	}

	public String getMessage(String key, String defaultMessage, Object[] args)
	{
		return applicationContextHelper.getMessage(key, defaultMessage, args);
	}

	public String getMessage(String key, String defaultMessage)
	{
		return applicationContextHelper.getMessage(key, defaultMessage);
	}

	public String getMessage(String key)
	{
		return applicationContextHelper.getMessage(key);
	}

	public String getPrefixedMessage(Class prefixClass, String key, Object[] args)
	{
		return applicationContextHelper.getPrefixedMessage(prefixClass, key, args);
	}

	public String getPrefixedMessage(Class prefixClass, String key, String defaultMessage, Object[] args)
	{
		return applicationContextHelper.getPrefixedMessage(prefixClass, key, defaultMessage, args);
	}

	public String getPrefixedMessage(Class prefixClass, String key, String defaultMessage)
	{
		return applicationContextHelper.getPrefixedMessage(prefixClass, key, defaultMessage);
	}

	public String getPrefixedMessage(Class prefixClass, String key)
	{
		return applicationContextHelper.getPrefixedMessage(prefixClass, key);
	}
	
	public Locale getLocale()
	{
		return applicationContextHelper.getLocale();
	}

    
}
