/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: BaseTag.java 265 2007-08-02 01:41:07Z bvonhaden $

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

import java.util.Iterator;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyTag;

import org.apache.log4j.Logger;
import org.springframework.context.NoSuchMessageException;
import org.springframework.validation.ObjectError;

import com.dynamic.charm.web.builder.HTMLElement;
import com.dynamic.charm.web.form.FormService;
import com.dynamic.charm.web.tag.TagDefaults;
import com.dynamic.charm.web.tag.support.EvalTool;
import com.dynamic.charm.web.tag.support.SpringAwareTag;


/**
 * BaseTag for other field tags"
 *
 * @author gcase
 */
public abstract class BaseTag extends SpringAwareTag
{
    private final static Logger logger = Logger.getLogger(BaseTag.class);
    
    protected String css;
    protected String style;
    protected String id;
    
    public void applyCommonAttributes(HTMLElement element)
    {
        element.css(css);
        element.style(style);
        element.id(id);
        
        for (Iterator iter = dynamicAttributeNamesIterator(); iter.hasNext();)
		{
			String attribute = (String) iter.next();
			Object value = getDynamicAttribute(attribute);
			if (value != null)
			{
				if (isSimpleAttribute(attribute))
				{
					element.setSimpleAttribute(attribute, value.toString());
				}
				else
				{
					element.setAttribute(attribute, value.toString());
				}				
			}
		}
    }

    public boolean isSimpleAttribute(String attribute)
    {
    	return "disabled".equalsIgnoreCase(attribute);
    }
    
    protected void evaluateExpresssions(EvalTool evalTool) throws JspException
    {
    	TagDefaults.getInstance().setAllDefaults(this);
        css = evalTool.evaluateAsString("css", css);
        style = evalTool.evaluateAsString("style", style);
        id = evalTool.evaluateAsString("id", id);
    }

    protected int doEndTagInternal()
    {
    	return BodyTag.EVAL_PAGE;
    }
    
    /**
      * Getter for property css.
      *
      * @return Value of property css.
      * @jsp.attribute required="false" rtexprvalue="true" description="Pass Through attribute for the css class attribute"
      */
    public String getCss()
    {
        return css;
    }

    public void setCss(String css)
    {
        this.css = css;
    }

    /**
      * Getter for property style.
      *
      * @return Value of property style.
      * @jsp.attribute required="false" rtexprvalue="true" description="Pass Through attribute for the style attribute"
      */
    public String getStyle()
    {
        return style;
    }

    public void setStyle(String style)
    {
        this.style = style;
    }
    

    /**
      * Getter for property id.
      *
      * @return Value of property id.
      * @jsp.attribute required="false" rtexprvalue="true" description="Pass Through attribute for the id attribute"
      */
    public String getId()
    {
        return id;
    }

    public void setId(String id)
    {
        this.id = id;
    } 
    
    

    public FormService getFormService()
    {
        FormService service = (FormService) getBean("formService", FormService.class);
        return service;
    }

    /**
     * Get the error message.
     * First try all the permutations, then try the default, and finally if all
     * are null then return the first code given surrounded by the magic ???.
     * 
     * @param error
     * @return
     */
    public String getErrorMessage(ObjectError error)
    {
        String[] codes = error.getCodes();
        Object[] args = error.getArguments();
        String result = null;
        for (int i = 0; i < codes.length && result == null; i++)
        {
        	try
        	{
        		result = getRawMessage(codes[i]);
        	}
        	catch (NoSuchMessageException ignore) {}
        }
        if (result == null)
        {
        	if (error.getDefaultMessage() != null)
        	{
        		result = error.getDefaultMessage();
        	}
        	else
        	{
        		if (codes.length > 0)
        		{
        			result = "???" + codes[0] + "???";
        		}
        	}
        }
        return result;
    }
}
