/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: GlueTag.java 199 2006-11-14 23:38:41Z gcase $

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
import javax.servlet.jsp.tagext.BodyTag;
import javax.servlet.jsp.tagext.Tag;

import org.apache.taglibs.standard.resources.Resources;

import com.dynamic.charm.web.tag.support.EvalTool;
import com.dynamic.charm.web.tag.support.SpringAwareTag;


/**
 * @jsp.tag name="glue" body-content="empty" description="Creates an association between child and parent objects"
 *
 * @author gcase
 */
public class GlueTag extends SpringAwareTag
{
    private String bind;
    private String child;
    private String property;

    protected void evaluateExpresssions(EvalTool evalTool) throws JspException
    {
        bind = evalTool.evaluateAsString("bind", bind);
        child = evalTool.evaluateAsString("child", child);
        property = evalTool.evaluateAsString("property", property);
    }

    protected int doStartTagInternal() throws Exception
    {
        Tag t = findAncestorWithClass(this, FieldParent.class);
        if (t == null)
        {
            throw new JspTagException(Resources.getMessage("com.dynamic.charm.form.field_outside_parent"));
        }

        // send the parameter to the appropriate ancestor
        FieldParent fieldParent = (FieldParent) t;

        if (fieldParent.getFormModel().isReadableProperty(bind, property))
        {
            Object boundChild = fieldParent.getFormModel().getBoundObject(child);
            fieldParent.getFormModel().setBoundValue(bind, property, boundChild);
        }

        return EVAL_BODY_INCLUDE;
    }

    protected int doEndTagInternal()
    {
    	return BodyTag.EVAL_PAGE;
    }
    
    /**
    * Getter for property child.
    *
    * @return Value of property child.
    * @jsp.attribute required="true" rtexprvalue="true" description="The name of the child object that this field should be bound to"
    */
    public String getChild()
    {
        return child;
    }

    public void setChild(String child)
    {
        this.child = child;
    }

    /**
     * Getter for property bind.
     *
     * @return Value of property bind.
     * @jsp.attribute required="true" rtexprvalue="true" description="The name of the object that this field should be bound to"
     */
    public String getBind()
    {
        return bind;
    }

    public void setBind(String parent)
    {
        this.bind = parent;
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
