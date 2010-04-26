/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: AbstractFieldTag.java 243 2007-04-09 16:41:49Z nwest $

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


package com.dynamic.charm.web.form.tag;

import java.beans.PropertyEditor;
import java.util.List;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspTagException;
import javax.servlet.jsp.tagext.BodyTag;
import javax.servlet.jsp.tagext.Tag;

import org.apache.log4j.Logger;
import org.apache.taglibs.standard.resources.Resources;
import org.springframework.validation.Errors;
import org.springframework.validation.FieldError;

import com.dynamic.charm.common.ArrayUtils;
import com.dynamic.charm.common.StringUtils;
import com.dynamic.charm.web.builder.HTMLElement;
import com.dynamic.charm.web.form.BoundProperty;
import com.dynamic.charm.web.form.CharmDataBinder;
import com.dynamic.charm.web.form.Field;
import com.dynamic.charm.web.form.tag.decorator.FieldDecorator;
import com.dynamic.charm.web.tag.support.EvalTool;


public abstract class AbstractFieldTag extends BaseTag
{
    private final static Logger logger = Logger.getLogger(AbstractFieldTag.class);

    public final static String NO_DECORATOR = "none";
    protected String property;
    protected String bind;
    protected String decorator;
    protected String label;
    protected String labeltooltip;
    protected String tooltip;
    protected String defaultValue;
    protected String value;
    protected String mandatoryExpr;
    protected boolean mandatory;
    protected String readonlyExpr;
    protected boolean readonly;
    protected String displayonlyExpr;
    protected boolean displayonly;

    protected FieldParent _parent;

    /**
     * Need to keep treatAsMandatory and mandatory attributes separate.  This is because the tag container will only use the
     * setMandatory() method if it believes the state to have been changed.  If the state is changed internally ,which will happen
     * when the FormService has determine that a field is mandatory from databasemeta data, we need to track this change separately,
     *  so that the container can correctly maintain our state the next time the tag is invoked.
     */
    protected boolean treatAsMandatory = false;

    protected void evaluateExpresssions(EvalTool evalTool) throws JspException
    {
	
        super.evaluateExpresssions(evalTool);
        property = evalTool.evaluateAsString("property", property);
        bind = evalTool.evaluateAsString("bind", bind);
        decorator = evalTool.evaluateAsString("decorator", decorator);
        label = evalTool.evaluateAsString("label", label);
        labeltooltip = evalTool.evaluateAsString("labeltooltip", labeltooltip);
        tooltip = evalTool.evaluateAsString("tooltip", tooltip);
        label = evalTool.evaluateAsString("label", label);
        defaultValue = evalTool.evaluateAsString("defaultValue", defaultValue);

        mandatory = evalTool.evaluateAsBoolean("mandatory", mandatoryExpr, false);
        readonly = evalTool.evaluateAsBoolean("readonly", readonlyExpr, false);
        displayonly = evalTool.evaluateAsBoolean("displayonly", displayonlyExpr, false);
    }

    public void applyCommonAttributes(HTMLElement element)
    {
        super.applyCommonAttributes(element);
        if (readonly)
        {
            element.setAttribute("readonly", "readonly");
        }
        if (StringUtils.isNotBlank(tooltip))
        {
            element.setAttribute("title", getMessage(tooltip));
        }
        
        //override the id value set in BaseTag
        element.id(getUsableId());
    }


    protected int doStartTagInternal() throws Exception
    {
        Tag t = findAncestorWithClass(this, FieldParent.class);
        if (t == null)
        {
            throw new JspTagException(Resources.getMessage("com.dynamic.charm.form.field_outside_parent"));
        }

        // send the parameter to the appropriate ancestor
        _parent = (FieldParent) t;

        Field f = new Field(bind, property);
        f.setMandatory(mandatory);
        f.setDisplayOnly(displayonly);

        _parent.addField(f);

        treatAsMandatory = f.isMandatory();
        if (treatAsMandatory && !mandatory)
        {
            logger.info("Treating " + bind + "." + property + " as mandatory even though was not explicitly set");
        }

        return BodyTag.EVAL_BODY_INCLUDE;
    }

    public int doEndTagInternal()
    {
        HTMLElement root = HTMLElement.createRootElement();
        FieldDecorator decoratorBean = getDecoratorInstance();
        if (decoratorBean != null)
        {
            decoratorBean.decorateAndRender(this, root, getRequestContext(), getRequest());
            write(root.evaluateChildren());
        }
        else
        {
            render(root);
            write(root.evaluateChildren());
        }

        return BodyTag.EVAL_PAGE;
    }

    public FieldDecorator getDecoratorInstance()
    {
        if (NO_DECORATOR.equalsIgnoreCase(decorator))
        {
            return null;
        }
        else if (StringUtils.isNotBlank(decorator))
        {
            return (FieldDecorator) getBean(decorator, FieldDecorator.class);
        }
        else
        {
            String parentDecorator = _parent.getFieldDecorator();
            if (StringUtils.isNotBlank(parentDecorator) && !NO_DECORATOR.equalsIgnoreCase(parentDecorator))
            {
                return (FieldDecorator) getBean(parentDecorator, FieldDecorator.class);
            }
            else
            {
                return null;
            }
        }
    }

    public Object getBoundValue()
    {
        return _parent.getFormModel().getBoundValue(bind, property);
    }

    public String getBoundValueAsString()
    {

        Object result = getBoundValue();
        if (result == null)
        {
            return "";
        }
        else
        {
            return result.toString();
        }
    }

    /**
     * Returns the value that should be displayed in the form.  First checks the value tag, then see if there is a parameter with the same internal name of the control.
     * <ol>
     *  <li>Value of the <code>value</code> attribute
     *  <li>Value of a parameter with the same internal name of the control (keeps state between form displays)
     *  <li>Value of the property of the object this control is bound to
     *  <li>Value of the <code>defaultValue</code> attribute
     * </ol>
     *
     * @return
     */
    public String getControlValue()
    {
        // value attribute
        String result = value;

        if (!StringUtils.isNotEmpty(result))
        {
            // parameter value
            result = getParameter(getControlName());

            if (!StringUtils.isNotEmpty(result))
            {
                // bound value
                result = getBoundValueAsString();

                if (!StringUtils.isNotEmpty(result))
                {
                    // defaultValue attribute
                    result = defaultValue;
                }
            }
        }
        return result;
    }

    public String getControlName()
    {
        BoundProperty bp = new BoundProperty(bind, property);
        return bp.getBoundPropertyKey();
    }

    public FieldError[] getErrors()
    {
        Errors bindErrors = getRequestContext().getErrors(bind);
        if (bindErrors == null)
        {
            return null;
        }

        List errorList = bindErrors.getFieldErrors(property);

        // convert to array
        return (FieldError[]) ArrayUtils.toArray(errorList, FieldError.class);
    }

    public void bindPropertyEditor(PropertyEditor propertyEditor)
    {
        CharmDataBinder binder = _parent.getFormModel().getCharmDataBinder(bind);
        Class boundPropertyType = binder.getPropertyType(property);
        binder.registerCustomEditor(boundPropertyType, property, propertyEditor);
    }

    /**
     * This method is called during the end of the tag lifecycle, and should be
     * used to add addtional HTMLElements to the root element provided.
     *
     * @param formElement
     */
    public abstract void render(HTMLElement formElement);

    /**
     * Getter for property bind.
     *
     * @return Value of property bind.
     * @jsp.attribute required="false" rtexprvalue="true" description="The name of the object that this field should be bound to"
     */
    public String getBind()
    {
        return bind;
    }

    public void setBind(String bind)
    {
        this.bind = bind;
    }

    /**
     * Getter for property property.
     *
     * @return Value of property property
     * @jsp.attribute required="false" rtexprvalue="true" description="The
     *                property that this control should be bound to"
     */
    public String getProperty()
    {
        return property;
    }

    public void setProperty(String property)
    {
        this.property = property;
    }

    /**
     * Getter for property label.
     *
     * @return Value of property label
     * @jsp.attribute required="false" rtexprvalue="true" description="The label
     *                to be used"
     */
    public String getLabel()
    {
        return label;
    }

    public void setLabel(String label)
    {
        this.label = label;
    }

    /**
     * Getter for property mandatory.
     *
     * @return Value of property mandatory
     * @jsp.attribute required="false" rtexprvalue="true" type="boolean"
     * description="Whether or not this field should be considered mandatory"
     */
    public String getMandatory()
    {
        return mandatoryExpr;
    }

    public void setMandatory(String mandatory)
    {
        this.mandatoryExpr = mandatory;
    }

    /**
     * Getter for property decorator.
     *
     * @return Value of property decorator
     * @jsp.attribute required="false" rtexprvalue="true" description="The bean
     *                name that should be used to decorate the input"
     */
    public String getDecorator()
    {
        return decorator;
    }

    public void setDecorator(String decorator)
    {
        this.decorator = decorator;
    }

    /**
     * Getter for property readonly.
     *
     * @return Value of property readonly
     * @jsp.attribute required="false" rtexprvalue="true" type="boolean"
     * description="Controls if it is readonly or not"
     */
    public String getReadonly()
    {
        return readonlyExpr;
    }

    public void setReadonly(String readonly)
    {
        this.readonlyExpr = readonly;
    }

    /**
     * Getter for property displayonly.
     *
     * @return Value of property displayonly
     * @jsp.attribute required="false" rtexprvalue="true" type="boolean"
     * description="Controls whether or not the value should be rebound to the object during form submission"
     */
    public String getDisplayonly()
    {
        return displayonlyExpr;
    }

    public void setDisplayonly(String displayonly)
    {
        this.displayonlyExpr = displayonly;
    }

    /**
     * Getter for property labeltooltip.
     *
     * @return Value of property labeltooltip
     * @jsp.attribute required="false" rtexprvalue="true" description="The
     *                tooltip for the label of the control"
     */
    public String getLabeltooltip()
    {
        return labeltooltip;
    }

    public void setLabeltooltip(String labeltooltip)
    {
        this.labeltooltip = labeltooltip;
    }

    /**
     * Getter for property tooltip.
     *
     * @return Value of property tooltip
     * @jsp.attribute required="false" rtexprvalue="true" description="The
     *                tooltip for the input control"
     */
    public String getTooltip()
    {
        return tooltip;
    }

    public void setTooltip(String tooltip)
    {
        this.tooltip = tooltip;
    }

    /**
     * Getter for property value.
     *
     * @return Value of property value.
     * @jsp.attribute required="false" rtexprvalue="true" description="The value
     *                (used to override the bounded property)"
     */
    public String getValue()
    {
        return value;
    }

    public void setValue(String value)
    {
        this.value = value;
    }

    /**
     * Getter for property defaultValue.
     *
     * @return Value of property defaultValue.
     * @jsp.attribute required="false" rtexprvalue="true" description="The default value of the tag, will be used bound value is currently null"
     */
    public String getDefaultValue()
    {
        return defaultValue;
    }

    public void setDefaultValue(String defaultValue)
    {
        this.defaultValue = defaultValue;
    }

    public boolean treatAsMandatory()
    {
        return treatAsMandatory;
    }
    
    public String getUsableId()
    {
    	String idVal = getId();
    	
    	if (idVal == null)
    		return getControlName();
    	else
    		return idVal;
    		
    }

}
