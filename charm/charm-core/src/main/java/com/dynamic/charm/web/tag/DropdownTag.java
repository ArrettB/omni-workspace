/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: DropdownTag.java 422 2009-06-18 20:17:55Z bvonhaden $

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


package com.dynamic.charm.web.tag;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyTag;
import javax.servlet.jsp.tagext.DynamicAttributes;

import org.apache.log4j.Logger;

import com.dynamic.charm.web.builder.HTMLElement;
import com.dynamic.charm.web.builder.OptionElement;
import com.dynamic.charm.web.builder.SelectElement;
import com.dynamic.charm.web.form.tag.BaseTag;
import com.dynamic.charm.web.tag.support.EvalTool;
import com.dynamic.charm.web.tag.support.Option;
import com.dynamic.charm.web.tag.support.SelectParent;


/**
 * @jsp.tag name="dropdown" body-content="JSP" dynamic-attributes="true"
 *
 * @author gcase
 */
public class DropdownTag extends BaseTag implements SelectParent, DynamicAttributes
{
    /**
	 * 
	 */
	private static final long serialVersionUID = 5601447702275389554L;
	private final static Logger logger = Logger.getLogger(DropdownTag.class);
    private String name;
    private String currentValue;
    private int size;
    private String sizeExpr;
    private String multipleExpr;
    private boolean multiple;
    private String defaultValue;
    private String defaultLabel;
    
    private SelectElement _selectElement;
    
    protected void evaluateExpresssions(EvalTool evalTool) throws JspException
    {
        super.evaluateExpresssions(evalTool);
        name = evalTool.evaluateAsString("name", name);
        currentValue = evalTool.evaluateAsString("currentValue", currentValue);
    	multiple = evalTool.evaluateAsBoolean("multiple", multipleExpr, false);
    	size = evalTool.evaluateAsInteger("size", sizeExpr);
    	defaultValue = evalTool.evaluateAsString("defaultValue", defaultValue);
		defaultLabel = evalTool.evaluateAsString("defaultLabel", defaultLabel);
   }
    
    protected int doStartTagInternal() throws Exception
    {
        logger.debug("doStartTagInternal()");
     
        HTMLElement root = HTMLElement.createRootElement();
        _selectElement = root.createSelectElement(getName());
        applyCommonAttributes(_selectElement);
        if (size >= 1)
        {
        	_selectElement.setAttribute("size", size);
        }
        if (multiple)
        {
        	_selectElement.setSimpleAttribute("multiple", true);
        }
        
        if (defaultValue != null && defaultLabel != null)
        {
            OptionElement defaultOption = _selectElement.createOption(defaultLabel, defaultValue);
            if ((currentValue == null) || currentValue.toString().equalsIgnoreCase(""))
            {
                defaultOption.setSelected(true);
                logger.info("Setting selection to default value of " + defaultValue);
            }        	
        }
        
         return BodyTag.EVAL_BODY_INCLUDE;
    }

    public int doEndTagInternal()
    {
        write(_selectElement.evaluate());
        return EVAL_PAGE;
    }
   
	public void addOption(Option option)
	{
		OptionElement optionElement = _selectElement.createOption(option.getName(), option.getValue());
        if (option.getValue().equals(currentValue))
        {
            logger.info("Setting selection to " + option.getName());
            optionElement.setSelected(true);
        }
	}
    
    /**
    * Getter for property name.
    *
    * @return Value of property name.
    * @jsp.attribute required="false" rtexprvalue="true" description="Pass Through value for the name attribute"
    */
    public String getName()
    {
        return name;
    }

    public void setName(String name)
    {
        this.name = name;
    }

    /**
     * Getter for property currentValue.
     *
     * @return Value of property currentValue.
     * @jsp.attribute required="false" rtexprvalue="true" description="The
     *    property to be used to get the current selected value of the tag"
     */
    public String getCurrentValue()
    {
        return currentValue;
    }

    public void setCurrentValue(String currentValue)
    {
        this.currentValue = currentValue;
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
     * description="Pass Through value for the multiple attribute"
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
     * description="Pass Through value for the size attribute"
     */
    public String getSize()
    {
        return sizeExpr;
    }

    public void setSize(String size)
    {
       this.sizeExpr = size;
    }


}
