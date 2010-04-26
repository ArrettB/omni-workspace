/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.

 * Copyright 2005, Dynamic Information Systems, LLC
 * $Id: ParameterTag.java 199 2006-11-14 23:38:41Z gcase $

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
import javax.servlet.jsp.JspTagException;
import javax.servlet.jsp.tagext.BodyTagSupport;
import javax.servlet.jsp.tagext.Tag;
import javax.servlet.jsp.tagext.TagSupport;

import org.apache.taglibs.standard.resources.Resources;

import com.dynamic.charm.common.StringUtils;
import com.dynamic.charm.web.tag.support.EvalTool;
import com.dynamic.charm.web.tag.support.ParamParent;


/**
 * @jsp.tag name="parameter" body-content="empty"
 *
 * @author gcase
 */
public class ParameterTag extends BodyTagSupport
{
    private String name;
    private Object value;
 
    public ParameterTag()
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
        if (value instanceof String)
        {
        	value = evalTool.evaluateAsObject("value", (String)value);
        }
		
		
        // chain to the parent implementation
        return super.doStartTag();       
    }

    public int doEndTag() throws JspException
    {
        Tag t = TagSupport.findAncestorWithClass(this, ParamParent.class);
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

        if (StringUtils.isBlank(stringValue))
        {
            if ((bodyContent == null) || (bodyContent.getString() == null))
            {
                value = "";
            }
            else
            {
                value = bodyContent.getString().trim();
            }
        }

        // send the parameter to the appropriate ancestor
        ParamParent parent = (ParamParent) t;
        parent.addParameter(name, value);

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
     * @jsp.attribute required="true" rtexprvalue="true" description="The name of the parameter"
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
     * @jsp.attribute required="true" rtexprvalue="true" description="The value of the parameter"
     */
    public Object getValue()
    {
        return value;
    }

    /**
     * @param value The value to set.
     */
    public void setValue(Object value)
    {
        this.value = value;
    }
}
