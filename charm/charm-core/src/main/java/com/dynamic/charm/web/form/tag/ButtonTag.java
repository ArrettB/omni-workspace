/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: ButtonTag.java 199 2006-11-14 23:38:41Z gcase $

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
import org.springframework.web.util.JavaScriptUtils;

import com.dynamic.charm.web.builder.HTMLElement;
import com.dynamic.charm.web.builder.InputElement;
import com.dynamic.charm.web.tag.support.EvalTool;


/**
 * @jsp.tag name="button" body-content="empty"
 *
 * @author gcase
 */
public class ButtonTag extends BaseTag
{
    public final static String FORM_SUBMIT_PARAM = "__submit";
    public final static String FORM_CANCEL_BUTTON = "cancel";
    public final static String FORM_DELETE_BUTTON = "delete";
    public final static String FORM_SAVE_BUTTON = "save";
    private final static String DEFAULT_CONFIRM_MESSAGE = "Are you sure you want to delete this?";

    private final static Logger logger = Logger.getLogger(ButtonTag.class);

    private String display;
    private String code;
    private String onClick;
    private boolean confirmDelete;
    private String confirmDeleteExpr;

    private FieldParent _parent;

    protected void evaluateExpresssions(EvalTool evalTool) throws JspException
    {
        super.evaluateExpresssions(evalTool);
        display = evalTool.evaluateAsString("display", display);
        code = evalTool.evaluateAsString("code", code);
        onClick = evalTool.evaluateAsString("onClick", onClick);
        confirmDelete = evalTool.evaluateAsBoolean("confirmDelete", confirmDeleteExpr, true);
    }

    public String generateOnClick()
    {
        String formName = _parent.getFormModel().getFormName();
        StringBuffer result = new StringBuffer();
        result.append("document." + formName + "." + FORM_SUBMIT_PARAM + ".value = '" + code + "';");

        if (onClick == null)
        {
            if (code.equalsIgnoreCase(FORM_DELETE_BUTTON) && confirmDelete)
            {
                String confirmMessage = getPrefixedMessage(ButtonTag.class, "confirm.message",
                        DEFAULT_CONFIRM_MESSAGE);
                confirmMessage = JavaScriptUtils.javaScriptEscape(confirmMessage);
                result.append("if (confirm('" + confirmMessage + "')) { ");
            }
            result.append("if (!document." + formName + ".onsubmit) document." + formName + ".submit();");
            result.append("else if (document." + formName + ".onsubmit()) document." + formName + ".submit();");
            if (code.equalsIgnoreCase(FORM_DELETE_BUTTON) && confirmDelete)
            {
                result.append(" }");
            }
        }
        else
        {
            result.append(onClick);
        }

        return result.toString();
    }

    protected int doStartTagInternal() throws Exception
    {
        Tag t = findAncestorWithClass(this, FieldParent.class);
        if (t == null)
        {
            throw new JspTagException(Resources.getMessage("com.dynamic.charm.form.field_outside_parent"));
        }

        _parent = (FieldParent) t;

        String formMode = (String) pageContext.getAttribute(FormTag.ATTRIBUTE_MODE);
        if (FormTag.MODE_INSERT.equals(formMode) && FORM_DELETE_BUTTON.equalsIgnoreCase(code))
        {
            write("<!-- Delete button is not needed-->");
        }
        else
        {
            HTMLElement root = HTMLElement.createRootElement();
            InputElement input = root.createInputElementButton(code, display);
            input.setAttribute("onClick", generateOnClick());
            applyCommonAttributes(input);
            write(input.evaluate());
        }

        return EVAL_PAGE;
    }

    /**
     * Getter for property code.
     *
     * @return Value of property code.
     * @jsp.attribute required="false" rtexprvalue="true" description="The
     *                button code"
     */
    public String getCode()
    {
        return code;
    }

    public void setCode(String code)
    {
        this.code = code;
    }

    /**
     * Getter for property display.
     *
     * @return Value of property display.
     * @jsp.attribute required="false" rtexprvalue="true" description="The
     *                button text"
     */
    public String getDisplay()
    {
        return display;
    }

    public void setDisplay(String display)
    {
        this.display = display;
    }

    /**
     * Getter for property confirmDelete.
     *
     * @return Value of property confirmDelete.
     * @jsp.attribute required="false" rtexprvalue="true" description="Whether or not the user should be prompted to delete the row.  Defaults to true"
     */
    public String setConfirmDelete()
    {
        return confirmDeleteExpr;
    }

    public void setConfirmDelete(String confirmDelete)
    {
        this.confirmDeleteExpr = confirmDelete;
    }

    /**
     * Getter for property onClick.
     *
     * @return Value of property onClick.
     * @jsp.attribute required="false" rtexprvalue="true" description="The script to run when the button is clicked"
     */
    public String getOnClick()
    {
        return onClick;
    }

    public void setOnClick(String onClick)
    {
        this.onClick = onClick;
    }
}
