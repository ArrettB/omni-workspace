/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: CharmDataBinder.java 355 2008-11-12 22:00:42Z bvonhaden $

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


package com.dynamic.charm.web.form;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletRequest;

import org.springframework.beans.BeanWrapper;
import org.springframework.beans.MutablePropertyValues;
import org.springframework.beans.PropertyValues;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.ServletRequestParameterPropertyValues;

import com.dynamic.charm.common.ArrayUtils;
import com.dynamic.charm.web.form.tag.editor.NumberPropertyEditor;


public class CharmDataBinder extends ServletRequestDataBinder
{
    protected List ignoredFieldList = new ArrayList();
    protected List allowedFieldList = new ArrayList();
    protected List requiredFieldList = new ArrayList();

    private String identifier;
    private Class targetClass;

    
    /**
     * We need the target class here, since the object we get back from hibernate may not be the class we expect (since it could be a cglib generated class)
     * @param target
     * @param targetClass
     * @param bindName
     * @param identifier
     */
    public CharmDataBinder(Object target, Class targetClass, String bindName, String identifier)
    {
        super(target, bindName);
        this.targetClass = targetClass;
        this.identifier = identifier;
    
        registerCustomEditor(Integer.class, new NumberPropertyEditor(DecimalFormat.getIntegerInstance(), Integer.class));
        registerCustomEditor(Long.class, new NumberPropertyEditor(DecimalFormat.getIntegerInstance(), Long.class));
        registerCustomEditor(Double.class, new NumberPropertyEditor(DecimalFormat.getNumberInstance(), Double.class));
        registerCustomEditor(Float.class, new NumberPropertyEditor(DecimalFormat.getNumberInstance(), Float.class));
    }

    

    public void bind(ServletRequest request)
    {
        MutablePropertyValues mpvs = new ServletRequestParameterPropertyValues(request, getObjectName());
        for (Iterator iter = ignoredFieldList.iterator(); iter.hasNext();)
        {
            mpvs.removePropertyValue((String) iter.next());
        }
        doBind(mpvs);
    }
    
    public void setProperty(String propertyName, Object value)
    {
        if (value instanceof String)
        {
            String str = (String) value;
            if (!StringUtils.hasText(str))
            {
                value = null;
            }
        }
        getPropertyAccessor().setPropertyValue(propertyName, value);
    }

    public Object getProperty(String propertyName)
    {
    	return getPropertyAccessor().getPropertyValue(propertyName);
    }

    public void setPropertyValues(PropertyValues pvs)
    {
    	getPropertyAccessor().setPropertyValues(pvs);
    }
    
    public Class getPropertyType(String property)
    {
    	return getPropertyAccessor().getPropertyType(property);
    }
    
    public BeanWrapper getBeanWrapper() 
    {
    	return (BeanWrapper) super.getInternalBindingResult().getPropertyAccessor();
    }

    public void addIgnoredField(String propertyName)
    {
        ignoredFieldList.add(propertyName);

        //remove it from mandatory fields if present
        requiredFieldList.remove(propertyName);
    }

    /**
     * Overriding method in super class
     */
    public String[] getAllowedFields()
    {
        return (String[]) ArrayUtils.toArray(allowedFieldList, String.class);
    }

    /**
     * Overriding method in super class
     */
    public void setAllowedFields(String[] allowedFields)
    {
        allowedFieldList.clear();
        for (int i = 0; i < allowedFields.length; i++)
        {
            allowedFieldList.add(allowedFields[i]);
        }
    }

    public void addAllowedField(String allowedField)
    {
        allowedFieldList.add(allowedField);
    }

    /**
     * Overriding method in super class
     */
    public String[] getRequiredFields()
    {
        return (String[]) ArrayUtils.toArray(requiredFieldList, String.class);
    }

    /**
     * Overriding method in super class
     */
    public void setRequiredFields(String[] requiredFields)
    {
        requiredFieldList.clear();
        for (int i = 0; i < requiredFields.length; i++)
        {
            addRequiredField(requiredFields[i]);
        }
    }

    public void addRequiredField(String requiredField)
    {
        if (!ignoredFieldList.contains(requiredField))
        {
            requiredFieldList.add(requiredField);
        }
    }

    public String getIdentifier()
    {
        return identifier;
    }

    public Class getTargetClass()
    {
        return targetClass;
    }
}
