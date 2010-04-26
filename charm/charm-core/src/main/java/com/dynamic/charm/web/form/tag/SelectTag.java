/*
 * Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written consent of Dynamic
 * Information Systems. All rights reserved.
 *
 * Copyright 2005, Dynamic Information Systems, LLC $Id: SelectTag.java 160
 * 2005-07-26 13:53:17Z $
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


package com.dynamic.charm.web.form.tag;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyTag;

import org.apache.log4j.Logger;
import org.hibernate.SessionFactory;
import org.hibernate.metadata.ClassMetadata;
import org.hibernate.type.Type;

import com.dynamic.charm.query.hibernate.HibernateService;
import com.dynamic.charm.service.QueryService;
import com.dynamic.charm.web.builder.HTMLElement;
import com.dynamic.charm.web.builder.OptionElement;
import com.dynamic.charm.web.builder.SelectElement;
import com.dynamic.charm.web.form.CharmDataBinder;
import com.dynamic.charm.web.form.tag.editor.HibernateObjectPropertyEditor;
import com.dynamic.charm.web.tag.TagDefaults;
import com.dynamic.charm.web.tag.support.EvalTool;
import com.dynamic.charm.web.tag.support.Option;
import com.dynamic.charm.web.tag.support.SelectParent;


/**
 * @jsp.tag name="select" body-content="JSP" dynamic-attributes="true"
 *
 * @author gcase
 * @version $Id: SelectTag.java 399 2009-05-19 22:56:48Z bvonhaden $
 */
public class SelectTag extends AbstractFieldTag implements SelectParent
{
    /**
	 * 
	 */
	private static final long serialVersionUID = -5674869273596390668L;

	private final static Logger logger = Logger.getLogger(SelectTag.class);
    private int size;
    private String sizeExpr;
    private String multipleExpr;
    private boolean multiple;
    private String defaultValue;
    private String defaultLabel;
    private String currentValue;
    
    private List options;
    
    protected int doStartTagInternal() throws Exception
    {
        logger.debug("SelectTag.doStartTagInternal()");
        super.doStartTagInternal();
        TagDefaults.getInstance().setAllDefaults(this);
  
        options = new ArrayList();
        
        return BodyTag.EVAL_BODY_INCLUDE;
    }

    protected void evaluateExpresssions(EvalTool evalTool) throws JspException
    {
    	super.evaluateExpresssions(evalTool);
    	multiple = evalTool.evaluateAsBoolean("multiple", multipleExpr, false);
    	size = evalTool.evaluateAsInteger("size", sizeExpr);
    	defaultValue = evalTool.evaluateAsString("defaultValue", defaultValue);
		defaultLabel = evalTool.evaluateAsString("defaultLabel", defaultLabel);
		currentValue = evalTool.evaluateAsString("currentValue", currentValue);
    }
        
    public void render(HTMLElement formElement)
    {
    	SelectElement selectElement = formElement.createSelectElement(getControlName());
		applyCommonAttributes(selectElement);
		
		if (size >= 1)
		{
			selectElement.setAttribute("size", size);
		}
		
		if (multiple)
		{
			selectElement.setSimpleAttribute("multiple", true);
		}

		addDefaultOption(selectElement, currentValue);

		if (isEntityType()) {
			CharmDataBinder binder = _parent.getFormModel().getCharmDataBinder(bind);
			Class boundPropertyType = binder.getPropertyType(property);

			// register a new editor for that type
			// call the object hope, as in I "hope" this works. Get it?!?
			HibernateObjectPropertyEditor hope = new HibernateObjectPropertyEditor(boundPropertyType, getHibernateService());
			bindPropertyEditor(hope);

			String id = null;

			if (currentValue == null)
			{
				Object currentValue = getBoundValue();
				if (currentValue != null)
				{
					id = getHibernateService().getIdentifier(boundPropertyType, currentValue).toString();
				}
				else
				{
					// redisplay the option selected even if it was not saved.
					id = getControlValue();
				}
			}
			else
			{
				id = currentValue;
			}

			createOptions(selectElement, id);
		}
		else
		{
			createOptions(selectElement, getControlValue());
		}
	}
    
    private void addDefaultOption(SelectElement select, String currentValue) {
		if (defaultLabel != null && defaultValue != null) {
			OptionElement optionElement = select.createOption(defaultLabel, defaultValue);

			if (currentValue == null) {
				currentValue = getControlValue();
			}

			if ((currentValue == null) || currentValue.equalsIgnoreCase("")) {
				optionElement.setSelected(true);
				logger.info("Setting selection to default value of " + defaultValue);
			}
		}
	} 
  
    private void createOptions(SelectElement select, String currentValueIdentifier)
    {
		for (Iterator iter = options.iterator(); iter.hasNext();)
		{
			Option option = (Option) iter.next();
			OptionElement optionElement = select.createOption(option.getName(), option.getValue());
			if (option.getValue().equals(currentValueIdentifier))
			{
				logger.info("Setting selection to " + option.getName());
				optionElement.setSelected(true);
			}
		}
   	
    }
    
	public void addOption(Option option)
	{
		options.add(option);
	}  

	/**
     * Returns true if a property of an another entity
     */
    public boolean isEntityType()
    {
        CharmDataBinder binder = _parent.getFormModel().getCharmDataBinder(bind);
        Class boundPropertyType = binder.getTargetClass();
        SessionFactory sf = getHibernateService().getSessionFactory();
       	ClassMetadata meta = sf.getClassMetadata(boundPropertyType);
        Type propertyType = meta.getPropertyType(property);
        return propertyType.isEntityType();
    }

    private HibernateService getHibernateService()
    {
    	return (HibernateService) getBean(QueryService.DEFAULT_HIBERNATE_SERVICE_NAME, HibernateService.class);
    }

    /**
     * Getter for property defaultLabel.
     *
     * @return Value of property defaultLabel.
     * @jsp.attribute required="false" rtexprvalue="true" description="The
     *    property to be used to get the default selected label of the tag"
     */
    public String getDefaultLabel()
    {
        return defaultLabel;
    }

    public void setDefaultLabel(String defaultLabel)
    {
       this.defaultLabel = defaultLabel;
    }

    /**
     * Getter for property defaultValue.
     *
     * @return Value of property defaultValue.
     * @jsp.attribute required="false" rtexprvalue="true" description="The
     *    property to be used to get the default selected value of the tag"
     */
    public String getDefaultValue()
    {
        return defaultValue;
    }

    public void setDefaultValue(String defaultValue)
    {
        this.defaultValue = defaultValue;
    }

    /**
     * Getter for property multiple.
     *
     * @return Value of property multiple.
     * @jsp.attribute required="false" rtexprvalue="true" type="boolean"
     * description="Passthru"
     */
    public String getMultiple()
    {
        return multipleExpr;
    }

    public void setMultiple(String multiple)
    {
        this.multipleExpr = multiple;
    }

    /**
     * Getter for property size.
     *
     * @return Value of property size.
     * @jsp.attribute required="false" rtexprvalue="true" type="int"
     * description="Passthru"
     */
    public String getSize()
    {
        return sizeExpr;
    }

    public void setSize(String size)
    {
       this.sizeExpr = size;
    }
    
    /**
     * Getter for currentValue. 
     *
     * @return Value of current value.
     * @jsp.attribute required="false" rtexprvalue="true"
     * description="This will override the default behavior 
     * of the selected value as the identifier of the object (according 
     * to hibernate) and instead use your value"
     */
	public String getCurrentValue() {
		return currentValue;
	}

	public void setCurrentValue(String currentValue) {
		this.currentValue = currentValue;
	}



}
