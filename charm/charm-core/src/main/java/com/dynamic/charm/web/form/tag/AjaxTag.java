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
import java.util.Map;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyTag;

import org.apache.log4j.Logger;
import org.hibernate.SessionFactory;
import org.hibernate.metadata.ClassMetadata;
import org.hibernate.type.Type;
import org.springframework.beans.BeanWrapperImpl;

import com.dynamic.charm.common.StringUtils;
import com.dynamic.charm.exception.CharmException;
import com.dynamic.charm.query.hibernate.HibernateService;
import com.dynamic.charm.service.QueryService;
import com.dynamic.charm.web.builder.DivElement;
import com.dynamic.charm.web.builder.HTMLElement;
import com.dynamic.charm.web.builder.ImageElement;
import com.dynamic.charm.web.builder.InputElement;
import com.dynamic.charm.web.form.CharmDataBinder;
import com.dynamic.charm.web.form.tag.decorator.FieldDecorator;
import com.dynamic.charm.web.form.tag.editor.HibernateObjectPropertyEditor;
import com.dynamic.charm.web.tag.TagDefaults;
import com.dynamic.charm.web.tag.support.EvalTool;


/**
 * @jsp.tag name="ajax" body-content="JSP" dynamic-attributes="true"
 * 
 * @version $Id$
 */
public class AjaxTag extends AbstractFieldTag
{
    /**
	 * 
	 */
	private static final long serialVersionUID = 8597332483340349150L;

	private final static Logger logger = Logger.getLogger(AjaxTag.class);

	private final static String[] DEFAULT_LABEL_PROPS = new String[] { "name", "label", "display", "description" };
	private final static String[] DEFAULT_VALUE_PROPS = new String[] { "id", "value", "identifier" };    

	private String multipleExpr;
    private String defaultValue;
    private String defaultLabel;
    private String currentValue;
    private String useIndicatorExpr;    
    private boolean useIndicator;
    private String indicatorImage;
    private String searchURL;
    private String ajaxOptions;
    private String prefix;
    private String autoCompleteClass;
	private String optionValue;
	private String optionLabel;    
    
    
    
    protected int doStartTagInternal() throws Exception
    {
        logger.debug("SelectTag.doStartTagInternal()");
        super.doStartTagInternal();
        TagDefaults.getInstance().setAllDefaults(this);
        
        return BodyTag.EVAL_BODY_INCLUDE;
    }
    
    public int doEndTagInternal()
    {
        HTMLElement root = HTMLElement.createRootElement();
        FieldDecorator decoratorBean = getDecoratorInstance();
        if (decoratorBean != null)
        {
            decoratorBean.decorateAndRender(this, root, getRequestContext(), getRequest());
        }
        else
        {
            render(root);
        }

        DivElement div = root.createDivElement(getControlName()+"_autocomplete");
        div.setAttribute("class", autoCompleteClass);

        String ajaxScript = "\n\n<script type=\"text/javascript\">\n\n"
        				+ 	" new Ajax.Autocompleter(\""+getControlName()+"_parameter\", \""+getControlName()+"_autocomplete\",\""+ searchURL+"\", {"+ajaxOptions+"});"
        				+	"\n\n function "+getControlName()+"_update(txt, li)\n"
        				+   "{\n"
        				+   "\t updateHidden(txt, li, '"+prefix+"', '"+getControlName()+"');\n"
        				+  "}\n\n"
        				+  "</script>";
        	
        write(root.evaluateChildren() + ajaxScript);
              
        return BodyTag.EVAL_PAGE;
    }    

    protected void evaluateExpresssions(EvalTool evalTool) throws JspException
    {
    	super.evaluateExpresssions(evalTool);
    	defaultValue = evalTool.evaluateAsString("defaultValue", defaultValue);
		defaultLabel = evalTool.evaluateAsString("defaultLabel", defaultLabel);
		currentValue = evalTool.evaluateAsString("currentValue", currentValue);
	    useIndicator = evalTool.evaluateAsBoolean("useIndicator", useIndicatorExpr, false);
	    indicatorImage = evalTool.evaluateAsString("indicatorImage", indicatorImage, "/images/spinner.gif");
	    searchURL = evalTool.evaluateAsString("searchURL", searchURL);
	    ajaxOptions = evalTool.evaluateAsString("ajaxOptions", ajaxOptions);
	    prefix = evalTool.evaluateAsString("prefix", prefix);
	    autoCompleteClass = evalTool.evaluateAsString("autoCompleteClass", autoCompleteClass);
	    optionValue = evalTool.evaluateAsString("optionValue", optionValue);
		optionLabel = evalTool.evaluateAsString("optionLabel", optionLabel);      
    }
        
    public void render(HTMLElement formElement) 
    {
		String displayValue = null;
		String displayLabel = null;
		if (isEntityType()) 
		{
			CharmDataBinder binder = _parent.getFormModel().getCharmDataBinder(bind);
			Class boundPropertyType = binder.getPropertyType(property);

			HibernateObjectPropertyEditor propEditor = new HibernateObjectPropertyEditor(boundPropertyType, getHibernateService());
			bindPropertyEditor(propEditor);

			if (currentValue == null) 
			{
				Object currentValue = getBoundValue();
				if (currentValue != null) 
				{
					if(optionLabel == null || optionValue == null)
						generateDefaultValues(currentValue);
					displayValue = getHibernateService().getIdentifier(boundPropertyType, currentValue).toString();
				
					if (currentValue instanceof Map)
					{
						displayLabel = convertToString(((Map) currentValue).get(optionLabel));
						displayValue = convertToString(((Map) currentValue).get(optionValue));
						//result.setName(convertToString(((Map) currentValue).get(optionLabel)));
						//result.setValue(convertToString(((Map) currentValue).get(optionValue)));
					}
					else
					{
						BeanWrapperImpl bw = new BeanWrapperImpl(currentValue);
						
						displayLabel = convertToString(bw.getPropertyValue(optionLabel));
						//result.setValue(convertToString(bw.getPropertyValue(optionValue)));
					}
				}
				else
				{
					displayValue = getControlValue();
					if (displayValue != null)
					{
    					currentValue = getHibernateService().get(boundPropertyType, displayValue);
    					BeanWrapperImpl bw = new BeanWrapperImpl(currentValue);
    					
    					displayLabel = convertToString(bw.getPropertyValue(optionLabel));
					}
				}
			}
			else 
			{
				displayValue = currentValue;
			}			
		}
		else 
		{
			//createOptions(selectElement, getControlValue());
		}

    	InputElement hiddenElement = formElement.createInputElementHidden(getControlName(), StringUtils.toStringNullsAsEmpty(displayValue));
    	hiddenElement.setAttribute("id", getControlName());
		
		InputElement inputElement = formElement.createInputElement("input", getControlName()+"_parameter");
		applyCommonAttributes(inputElement);
		inputElement.setAttribute("value", StringUtils.toStringNullsAsEmpty(displayLabel));
		inputElement.setAttribute("id", getControlName()+"_parameter");
		inputElement.setAttribute("autocomplete", "off");
		
		if(useIndicator)
		{
			HTMLElement span = formElement.createElement("span");
			span.setAttribute("id", getControlName() + "_indicator");
			span.setAttribute("style", "display: none");
			
			// determine context-aware paths
			String contextPath = getRequestContext().getContextPath();
			String imageURL = contextPath + indicatorImage;

			//create image regardless if we are disabled
			ImageElement img = span.createImageElement(imageURL);
			img.alt("Working....");
		}
	}

	private String convertToString(Object o)
	{
		if (o == null)
		{
			return "";
		}
		else
		{
			return o.toString();
		}
	}    
    
	public void generateDefaultValues(Object representative)
	{
		if (representative instanceof Map)
		{
			// create a lowercase list
			List keys = new ArrayList();
			for (Iterator iter = ((Map) representative).keySet().iterator(); iter.hasNext();)
			{
				String element = (String) iter.next();
				keys.add(element.toLowerCase());
			}

			for (int i = 0; i < DEFAULT_LABEL_PROPS.length; i++)
			{
				if (keys.contains(DEFAULT_LABEL_PROPS[i]))
				{
					optionLabel = DEFAULT_LABEL_PROPS[i];
				}
			}
			for (int i = 0; i < DEFAULT_VALUE_PROPS.length; i++)
			{
				if (keys.contains(DEFAULT_VALUE_PROPS[i]))
				{
					optionValue = DEFAULT_VALUE_PROPS[i];
				}
			}
		}
		else
		{
			BeanWrapperImpl bw = new BeanWrapperImpl(representative);
			for (int i = 0; i < DEFAULT_LABEL_PROPS.length; i++)
			{
				if (bw.isReadableProperty(DEFAULT_LABEL_PROPS[i]))
				{
					optionLabel = DEFAULT_LABEL_PROPS[i];
					break;
				}
			}
			for (int i = 0; i < DEFAULT_VALUE_PROPS.length; i++)
			{
				if (bw.isReadableProperty(DEFAULT_VALUE_PROPS[i]))
				{
					optionValue = DEFAULT_VALUE_PROPS[i];
				}
			}
		}
		if ((optionLabel == null) || (optionValue == null))
		{
			throw new CharmException("optionLabel and optionValue were not specified, and could not be determined from the query results");
		}
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

    /**
     * Getter for property useIndicator.
     *
     * @return Value of property useIndicator.
     * @jsp.attribute required="false" rtexprvalue="true" type="boolean"
     * description="Passthru"
     */
    public String getUseIndicator()
    {
        return useIndicatorExpr;
    }

    public void setUseIndicator(String useIndicatorExpr)
    {
        this.useIndicatorExpr = useIndicatorExpr;
    }

    /**
     * Getter for property indicatorImage.
     *
     * @return Value of property indicatorImage.
     * @jsp.attribute required="false" rtexprvalue="true" description="Need Description"
     */
    public String getIndicatorImage()
    {
        return indicatorImage;
    }

    public void setIndicatorImage(String indicatorImage)
    {
        this.indicatorImage = indicatorImage;
    }

    /**
     * Getter for property searchURL.
     *
     * @return Value of property searchURL.
     * @jsp.attribute required="false" rtexprvalue="true" description="Need Description"
     */
    public String getSearchURL()
    {
        return searchURL;
    }

    public void setSearchURL(String searchURL)
    {
        this.searchURL = searchURL;
    }

    /**
     * Getter for property ajaxOptions.
     *
     * @return Value of property ajaxOptions.
     * @jsp.attribute required="false" rtexprvalue="true" description="Need Description"
     */
    public String getAjaxOptions()
    {
        return ajaxOptions;
    }

    public void setAjaxOptions(String ajaxOptions)
    {
        this.ajaxOptions = ajaxOptions;
    }

    /**
     * Getter for property prefix.
     *
     * @return Value of property prefix.
     * @jsp.attribute required="false" rtexprvalue="true" description="Need Description"
     */
    public String getPrefix()
    {
        return prefix;
    }

    public void setPrefix(String prefix)
    {
        this.prefix = prefix;
    }
    
    /**
     * Getter for property autoCompleteClass.
     *
     * @return Value of property autoCompleteClass.
     * @jsp.attribute required="false" rtexprvalue="true" description="Need Description"
     */
    public String getAutoCompleteClass()
    {
        return autoCompleteClass;
    }

    public void setAutoCompleteClass(String autoCompleteClass)
    {
        this.autoCompleteClass = autoCompleteClass;
    }    

	/**
	 * Getter for property optionLabel.
	 * 
	 * @return Value of property optionLabel.
	 * @jsp.attribute required="false" rtexprvalue="true" description="The
	 *                property to be used for the display of the tag"
	 */
	public String getOptionLabel()
	{
		return optionLabel;
	}

	public void setOptionLabel(String optionLabel)
	{
		this.optionLabel = optionLabel;
	}

	/**
	 * Getter for property optionValue.
	 * 
	 * @return Value of property optionValue.
	 * @jsp.attribute required="false" rtexprvalue="true" description="The
	 *                property to be used to get the value of the tag"
	 */
	public String getOptionValue()
	{
		return optionValue;
	}

	public void setOptionValue(String optionValue)
	{
		this.optionValue = optionValue;
	}
}
