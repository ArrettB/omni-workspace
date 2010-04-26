/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: CheckboxTag.java 199 2006-11-14 23:38:41Z gcase $

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

import com.dynamic.charm.web.builder.HTMLElement;
import com.dynamic.charm.web.builder.InputElement;
import com.dynamic.charm.web.tag.support.EvalTool;


/**
 * @jsp.tag name="checkbox" body-content="empty" display=-name="CheckBox" dynamic-attributes="true" description="Renders a checkbox on the form.  A <code>&ltlinput type=&quot;hidden&quot; &gt; </code> is used pass the actual value of the checkbox, so that a checked and an unchecked value can be specified (easier than checking for the non-existance of the parameter)</code>
 *
 * @author gcase
 */
public class CheckboxTag extends AbstractFieldTag
{
    private String checkedValue;
    private String uncheckedValue;

    protected void evaluateExpresssions(EvalTool evalTool) throws JspException
    {
        super.evaluateExpresssions(evalTool);
        checkedValue = evalTool.evaluateAsString("checkedValue", checkedValue, "Y");
        uncheckedValue = evalTool.evaluateAsString("uncheckedValue", uncheckedValue, "N");
    }

    public void render(HTMLElement formElement)
    {
        boolean isChecked = isChecked();

        String hiddenName = getControlName();
        String checkBoxName = getControlName() + "_control";

        InputElement hidden = formElement.createInputElementHidden(hiddenName, isChecked ? checkedValue : uncheckedValue);
        hidden.id(hiddenName);

        InputElement checked = formElement.createInputElementCheckbox(checkBoxName);
        super.applyCommonAttributes(checked);
        
        checked.id(checkBoxName);
        checked.setAttribute("onClick", onClick());
        checked.setSimpleAttribute("checked", isChecked);
    }

    private String onClick()
    {
        String hiddenName = getControlName();
        String checkBoxName = getControlName() + "_control";

        StringBuffer buffer = new StringBuffer();
        buffer.append("document.getElementById('" + hiddenName + "').value");
        buffer.append(" = ");
        buffer.append("document.getElementById('" + checkBoxName + "').checked");
        buffer.append(" ? '" + checkedValue + "' :'" + uncheckedValue + "';");

        return buffer.toString();
    }

    private boolean isChecked()
    {
        String controlValue = getControlValue();
        if (controlValue == null)
        {
            return false;
        }

        return ((controlValue.equalsIgnoreCase(checkedValue) ||
                    controlValue.equalsIgnoreCase("y") || controlValue.equalsIgnoreCase("true") ||
                    controlValue.equalsIgnoreCase("on") || controlValue.equalsIgnoreCase("yes") ||
                    controlValue.equals("1")));
    }

    /**
     * Getter for property checkedValue.
     *
     * @return Value of property checkedValue.
     * @jsp.attribute required="false" rtexprvalue="false" description="The value to be stored in the database when the checkbox is checked"
     */
    public String getCheckedValue()
    {
        return checkedValue;
    }

    public void setCheckedValue(String checkedValue)
    {
        this.checkedValue = checkedValue;
    }

    /**
    * Getter for property uncheckedValue.
    *
    * @return Value of property uncheckedValue.
    * @jsp.attribute required="false" rtexprvalue="false" description="The value to be stored in the database when the checkbox is not checked"
    */
    public String getUncheckedValue()
    {
        return uncheckedValue;
    }

    public void setUncheckedValue(String unCheckedValue)
    {
        this.uncheckedValue = unCheckedValue;
    }
}
