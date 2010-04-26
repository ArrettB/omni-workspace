/*
 * Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written consent of Dynamic
 * Information Systems. All rights reserved.
 *
 * Copyright 2005, Dynamic Information Systems, LLC $Id: FormModel.java 166
 * 2005-08-09 15:57:18Z $
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 * FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL DYNAMIC
 * INFORMATIONS SYTEMS, LLC BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * ====================================================================
 */


package com.dynamic.charm.web.form;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.BeanWrapper;
import org.springframework.validation.Errors;

import com.dynamic.charm.common.ArrayUtils;
import com.dynamic.charm.service.EncryptionService;

/**
 * 
 * @version $Header$
 */
public class FormModel
{
    private final static Logger logger = Logger.getLogger(FormModel.class);
    private String formView;
    private String successView;
    private String cancelView;
    private String formName;
    private String postProcessor;
    private String preProcessor;

    private Map bindings = new LinkedHashMap();
    private List fields = new ArrayList();
	private String forwardParameterList;
	private boolean forwardParameters;
	private String forwardBoundFieldAsParameterList;

    public String getCancelView()
    {
        return cancelView;
    }

    public void setCancelView(String cancelView)
    {
        this.cancelView = cancelView;
    }

    public String getFormName()
    {
        return formName;
    }

    public void setFormName(String formName)
    {
        this.formName = formName;
    }

    public String getFormView()
    {
        return formView;
    }

    public void setFormView(String formView)
    {
        this.formView = formView;
    }

    public String getSuccessView()
    {
        return successView;
    }

    public void setSuccessView(String successView)
    {
        this.successView = successView;
    }

    public void performBinding(String bindName, Object bindMe, Class bindClass, String identifier)
    {
        logger.debug("performBinding()");

        CharmDataBinder binder = new CharmDataBinder(bindMe, bindClass, bindName, identifier);
        logger.info("Binding bean of type " + bindClass.getName() + " to " + bindName);
        bindings.put(bindName, binder);
    }

    public void removeBinding(String bindName)
    {
    	bindings.remove(bindName);
    }
    
    /**
     * Gets the name of a bound property from the bound property key 
     * @param boundPropertyKey
     * @return String
     */
    public String getBoundPropertyName(String boundPropertyKey)
    {
    	String propertyName = null;
    	
    	BoundProperty boundProperty = new BoundProperty(boundPropertyKey);
    	if(boundProperty.isValid())
    	{
    		propertyName = boundProperty.getPropertyName();
    	}
    	
    	return propertyName;
    }
    
    public Object getBoundValue(String bindName, String propertyName)
    {
        if (isReadableProperty(bindName, propertyName))
        {
            if (logger.isDebugEnabled())
            {
                logger.debug("Evaluating " + bindName + "." + propertyName + " to " + getBeanWrapper(bindName).getPropertyValue(propertyName));
            }
            return getCharmDataBinder(bindName).getProperty(propertyName);
        }
        else
        {
            logger.debug("Ignoring attempt to read " + bindName + "." + propertyName + ", is not readable");
            return null;
        }
    }

    public void setBoundValue(String bindName, String propertyName, Object value)
    {
        logger.debug("setBoundValue() of " + bindName + "'s " + propertyName + " to " + value);
        if (isWritableProperty(bindName, propertyName))
        {
            getCharmDataBinder(bindName).setProperty(propertyName, value);
        }
        else
        {
            logger.debug("Ignoring attempt to set " + bindName + "." + propertyName + " to " + value + ", is not writable");
        }
    }

    public Object getBoundValue(String boundPropertyKey)
    {
        BoundProperty bp = new BoundProperty(boundPropertyKey);
        if (bp.isValid())
        {
            return getBoundValue(bp.getBindName(), bp.getPropertyName());
        }
        else
        {
            return null;
        }
    }

    public void setBoundValue(String boundPropertyKey, Object value)
    {
        BoundProperty bp = new BoundProperty(boundPropertyKey);
        if (bp.isValid())
        {
            setBoundValue(bp.getBindName(), bp.getPropertyName(), value);
        }
    }
    
    private BeanWrapper getBeanWrapper(String bindName)
    {
        CharmDataBinder binder = (CharmDataBinder) bindings.get(bindName);
        return binder.getBeanWrapper();
    }

    public CharmDataBinder getCharmDataBinder(String bindName)
    {
        CharmDataBinder binder = (CharmDataBinder) bindings.get(bindName);
        return binder;
    }

    public Iterator getBindNames()
    {
        return bindings.keySet().iterator();
    }

    public Object[] getBoundObjects()
    {
        Object[] result = new Object[bindings.size()];
        int i = 0;
        for (Iterator iter = bindings.values().iterator(); iter.hasNext();)
        {
            CharmDataBinder binder = (CharmDataBinder) iter.next();
            result[i++] = binder.getTarget();
        }
        return result;
    }

    public Object getBoundObject(String bindName)
    {
        CharmDataBinder binder = getCharmDataBinder(bindName);
        if (binder != null)
        {
            return binder.getTarget();
        }
        else
        {
            return null;
        }
    }

    public boolean isReadableProperty(String bindName, String propertyName)
    {
        BeanWrapper bw = getBeanWrapper(bindName);
        if (bw != null)
        {
            return bw.isReadableProperty(propertyName);
        }
        else
        {
            return false;
        }
    }

    public boolean isWritableProperty(String bindName, String propertyName)
    {
        BeanWrapper bw = getBeanWrapper(bindName);
        if (bw != null)
        {
            return bw.isWritableProperty(propertyName);
        }
        else
        {
            return false;
        }
    }

    public Errors getErrors(String bindName)
    {
        return getCharmDataBinder(bindName).getBindingResult();
    }

    public boolean hasErrors()
    {
        for (Iterator iter = bindings.values().iterator(); iter.hasNext();)
        {
            CharmDataBinder binder = (CharmDataBinder) iter.next();
            if (binder.getBindingResult().hasErrors())
            {
                return true;
            }
        }
        return false;
    }

    public Field[] getFields()
    {
        return (Field[]) ArrayUtils.toArray(fields, Field.class);
    }

    public Field[] getFieldsForBinding(String bindName)
    {
        List tempList = new ArrayList();
        for (Iterator iter = fields.iterator(); iter.hasNext();)
        {
            Field f = (Field) iter.next();
            if (f.getBindName().equalsIgnoreCase(bindName))
            {
                tempList.add(f);
            }
        }
        return (Field[]) ArrayUtils.toArray(tempList, Field.class);
    }

    public void addField(Field field)
    {
        if (!fields.contains(field))
        {
            fields.add(field);

            CharmDataBinder binder = getCharmDataBinder(field.getBindName());
            binder.addAllowedField(field.getProperty());
            if (field.isDisplayOnly())
            {
                binder.addIgnoredField(field.getProperty());
            }
        }

        // we do not need to add it to the mandory fields, that is done by the
        // form tag itself
    }

    public String createDigest()
    {
        Iterator iter = this.getBindNames();
        StringBuffer buffer = new StringBuffer();
        buffer.append("FortyTwo");
        while (iter.hasNext())
        {
            String bindName = (String) iter.next();
            CharmDataBinder binder = this.getCharmDataBinder(bindName);
            Object bound = this.getBoundObject(bindName);
            buffer.append(bound.getClass().getName()).append("-");
            buffer.append(bindName).append("-");
            buffer.append(binder.getIdentifier()).append("-");
        }

        byte[] digest = EncryptionService.stringToDigest(buffer.toString());
        byte[] encoded = EncryptionService.bytesToEncoding(digest);
        return new String(encoded);
    }

    public String getPostProcessor()
    {
        return postProcessor;
    }

    public void setPostProcessor(String postProcessor)
    {
        this.postProcessor = postProcessor;
    }

    public String getPreProcessor()
    {
        return preProcessor;
    }

    public void setPreProcessor(String preProcessor)
    {
        this.preProcessor = preProcessor;
    }

    public String getSessionAttributeName()
    {
        return FormModel.class.getName() + "." + formName + ".FORM";
    }

	public void setForwardParameterList(String forwardParameterList)
	{
		this.forwardParameterList = forwardParameterList;
	}

	public String getForwardParameterList()
	{
		return forwardParameterList;
	}

	public void setForwardParameters(boolean forwardParameters)
	{
		this.forwardParameters = forwardParameters;
	}

	public boolean isForwardParameters()
	{
		return forwardParameters;
	}

	/**
	 * @return Returns the forwardBoundFieldAsParameterList.
	 */
	public String getForwardBoundFieldAsParameterList()
	{
		return forwardBoundFieldAsParameterList;
	}

	/**
	 * @param forwardBoundFieldAsParameterList The forwardBoundFieldAsParameterList to set.
	 */
	public void setForwardBoundFieldAsParameterList(String forwardBoundFieldAsParameterList)
	{
		this.forwardBoundFieldAsParameterList = forwardBoundFieldAsParameterList;
	}
}
