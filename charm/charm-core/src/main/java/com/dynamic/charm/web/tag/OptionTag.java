package com.dynamic.charm.web.tag;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspTagException;
import javax.servlet.jsp.tagext.BodyTagSupport;
import javax.servlet.jsp.tagext.Tag;
import javax.servlet.jsp.tagext.TagSupport;

import org.apache.taglibs.standard.resources.Resources;

import com.dynamic.charm.common.StringUtils;
import com.dynamic.charm.web.tag.support.EvalTool;
import com.dynamic.charm.web.tag.support.Option;
import com.dynamic.charm.web.tag.support.SelectParent;


/**
 * @jsp.tag name="option" body-content="empty"
 *
 * @author gcase
 */
public class OptionTag extends BodyTagSupport
{
    private String name;
    private String value;
    
    public OptionTag()
    {
        super();
        init();
    }

    public void release()
    {
        super.release();
        init();
    }

    public int doStartTag() throws JspException
    {
        EvalTool evalTool = new EvalTool(this, pageContext);   
        name = evalTool.evaluateAsString("name", name);
        value = evalTool.evaluateAsString("value", value);
       	
        // chain to the parent implementation
        return super.doStartTag();       
    }

    public int doEndTag() throws JspException
    {
        Tag t = TagSupport.findAncestorWithClass(this, SelectParent.class);
        if (t == null)
        {
            throw new JspTagException(Resources.getMessage("PARAM_OUTSIDE_PARENT"));
        }

        // take no action for null or empty names
        if ((name == null) || name.equals(""))
        {
            return EVAL_PAGE;
        }

        // evaluate value to equal body content if value attribute not set
        String stringValue = (value != null) ? value.toString() : null;
        if (StringUtils.isBlank(stringValue) && bodyContent != null && StringUtils.isNotBlank(bodyContent.toString()))
        {
            value = bodyContent.getString().trim();
        }
        

        // send the option to our parent
        SelectParent parent = (SelectParent) t;
        parent.addOption(new Option(name, value));

        return EVAL_PAGE;
    }

    private void init()
    {
        name = null;
        value = null;
    }

    /**
     * Getter for property name.
     *
     * @return Value of property getName.
     * @jsp.attribute required="true" rtexprvalue="true" description="The name of the option"
     */
    public String getName()
    {
        return name;
    }

    /**
     * @param name The name to set.
     */
    public void setName(String name)
    {
        this.name = name;
    }

    /**
     * Getter for property value.
     *
     * @return Value of property getValue.
     * @jsp.attribute required="true" rtexprvalue="true" description="The value of the option"
     */
    public String getValue()
    {
        return value;
    }

    /**
     * @param value The value to set.
     */
    public void setValue(String value)
    {
        this.value = value;
    }
}
