/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: HiddenTag.java 327 2008-05-14 19:07:59Z jheald $

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

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspTagException;
import javax.servlet.jsp.tagext.Tag;

import org.apache.log4j.Logger;
import org.apache.taglibs.standard.resources.Resources;
import org.springframework.util.StringUtils;

import com.dynamic.charm.web.builder.HTMLElement;
import com.dynamic.charm.web.builder.InputElement;
import com.dynamic.charm.web.form.BoundProperty;
import com.dynamic.charm.web.form.Field;
import com.dynamic.charm.web.tag.support.EvalTool;


/**
 * @jsp.tag name="hidden" body-content="empty" description="Creates a hidden tag on the form.  If the bind and property properties are set, this tag will
 * generate a hidden tag that will be used internally to set that particular property on the object.   However, if the parameter property is set,
 * this tag will simply create hidden input with the name of the parameter as its name, and the value of the parameter as the value.  The result is that the value of that
 * particular parameter will be passed along to subsequent invocations of the form." display-name="Hidden Tag"
 *
 * @author gcase
 */
public class HiddenTag extends BaseTag
{
    private final static Logger logger = Logger.getLogger(HiddenTag.class);

    protected String parameter;
    protected String bind;
    protected String property;
    protected String value;
    protected String defaultValue;

    protected FieldParent _parent;

    protected void evaluateExpresssions(EvalTool evalTool) throws JspException
    {
        super.evaluateExpresssions(evalTool);
        parameter = evalTool.evaluateAsString("parameter", parameter);
        bind = evalTool.evaluateAsString("bind", bind);
        property = evalTool.evaluateAsString("property", property);
        value = evalTool.evaluateAsString("value", value);
        defaultValue = evalTool.evaluateAsString("defaultValue", defaultValue);
    }

    protected int doStartTagInternal() throws Exception
    {
        logger.debug("doStartTagInternal()");

        if (StringUtils.hasText(bind) && StringUtils.hasText(property))
        {
            Tag t = findAncestorWithClass(this, FieldParent.class);
            if (t == null)
            {
                throw new JspTagException(Resources.getMessage("com.dynamic.charm.form.field_outside_parent"));
            }

            // send the parameter to the appropriate ancestor
            _parent = (FieldParent) t;

            Field f = new Field(bind, property);

            _parent.addField(f);
        }
        else if (StringUtils.hasText(parameter))
        {
        }

        return SKIP_BODY;
    }

    public int doEndTag() throws JspException
    {
        HTMLElement root = HTMLElement.createRootElement();
        InputElement input = root.createInputElementHidden(getControlName(), getControlValue());
        input.setAttribute("id", getId());
        write(input.evaluate());
        return super.doEndTag();
    }

    public Object getBoundValue()
    {
        logger.debug("getBoundValue()");
        if (!StringUtils.hasText(bind))
        {
            return null;
        }
        else
        {
            return _parent.getFormModel().getBoundValue(bind, property);
        }
    }

    public String getBoundValueAsString()
    {
        logger.debug("getBoundValueAsString()");

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

        if (!StringUtils.hasText(result))
        {
            // parameter value
            result = getParameter(getControlName());

            if (!StringUtils.hasText(result))
            {
                // bound value
                result = getBoundValueAsString();

                if (!StringUtils.hasText(result))
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
        if (parameter == null)
        {
            BoundProperty bp = new BoundProperty(bind, property);
            return bp.getBoundPropertyKey();
        }
        else
        {
            return parameter;
        }
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

    /**
     * Getter for property parameter.
     *
     * @return Value of property parameter.
     * @jsp.attribute required="false" rtexprvalue="true" description="The name of the parameter that should be persisted"
     */
    public String getParameter()
    {
        return parameter;
    }

    public void setParameter(String parameter)
    {
        this.parameter = parameter;
    }

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
}
