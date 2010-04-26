/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: ErrorTag.java 199 2006-11-14 23:38:41Z gcase $

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
import java.util.List;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspTagException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.Tag;

import org.apache.log4j.Logger;
import org.apache.taglibs.standard.resources.Resources;
import org.springframework.validation.Errors;
import org.springframework.validation.ObjectError;

import com.dynamic.charm.web.builder.HTMLElement;
import com.dynamic.charm.web.tag.support.EvalTool;


/**
 * @jsp.tag name="error" body-content="empty"
 *
 * @author gcase
 */
public class ErrorTag extends BaseTag
{
    private final static Logger logger = Logger.getLogger(ErrorTag.class);
    private String bind;
    private String property;
    private String var;

    protected FieldParent _parent;

    protected void evaluateExpresssions(EvalTool evalTool) throws JspException
    {
        super.evaluateExpresssions(evalTool);
        bind = evalTool.evaluateAsString("bind", bind);
        property = evalTool.evaluateAsString("property", property);
        var = evalTool.evaluateAsString("var", var);
    }

    protected int doStartTagInternal() throws Exception
    {
        logger.debug("doStartTagInternal()");

        Tag t = findAncestorWithClass(this, FieldParent.class);
        if (t == null)
        {
            throw new JspTagException(Resources.getMessage("com.dynamic.charm.form.field_outside_parent"));
        }

        // send the parameter to the appropriate ancestor
        _parent = (FieldParent) t;

        //CharmDataBinder binder = parent.getFormModel().getCharmDataBinder(bind);
        //BindException errors = binder.getErrors();
        Errors errors = getRequestContext().getErrors(bind);
        if (errors != null)
        {
            List errorList = null;
            if (property == null)
            {
                errorList = errors.getGlobalErrors();

                String errorCount = (errorList.size() == 0) ? "No" : Integer.toString(errorList.size());
                write("<!-- " + errorCount + " global errors for " + bind + " -->");
            }
            else
            {
                errorList = errors.getFieldErrors(property);

                String errorCount = (errorList.size() == 0) ? "No" : Integer.toString(errorList.size());
                write("<!-- " + errorCount + " errors for " + bind + "_" + property + " -->");
            }

            if (var == null)
            {
                // we just write out each error tag, wrapped by a div;
                HTMLElement root = HTMLElement.createRootElement();

                for (Iterator iter = errorList.iterator(); iter.hasNext();)
                {
                    ObjectError error = (ObjectError) iter.next();
                    String defaultMessage = error.getDefaultMessage();
                    if (defaultMessage != null)
                    {
                        root.addComment(defaultMessage);
                    }

                    HTMLElement div = root.createElement("div");
                    div.css(css);
                    div.style(style);
                    div.setText(getErrorMessage(error));
                }

                write(root.evaluateChildren());
            }
            else
            {
                pageContext.setAttribute(var, errorList, PageContext.PAGE_SCOPE);
            }
        }
        else
        {
            write("<!-- No global errors for " + bind + " -->");
        }

        return EVAL_BODY_INCLUDE;
    }

    /**
     * Getter for property bind.
     *
     * @return Value of property bind.
     * @jsp.attribute required="true" rtexprvalue="true" description="The bind
     *                name to get errors for"
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
     * @return Value of property property.
     * @jsp.attribute required="false" rtexprvalue="true" description="The
     *                property to get errros for. If this is left blank, will
     *                return the global erorrs for the form"
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
     * Getter for property var.
     *
     * @return Value of property var.
     * @jsp.attribute required="false" rtexprvalue="true" description="The name
     *                of the var to be used to make the error list availabe. IF
     *                this is left blank, it will render the errors itself."
     */
    public String getVar()
    {
        return var;
    }

    public void setVar(String var)
    {
        this.var = var;
    }
}
