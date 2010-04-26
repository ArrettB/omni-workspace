/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: MoneyTag.java 243 2007-04-09 16:41:49Z nwest $

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

import java.text.NumberFormat;
import java.text.ParseException;

import org.apache.log4j.Logger;

import com.dynamic.charm.common.StringUtils;
import com.dynamic.charm.web.builder.HTMLElement;
import com.dynamic.charm.web.builder.InputElement;
import com.dynamic.charm.web.form.CharmDataBinder;
import com.dynamic.charm.web.form.tag.editor.NumberPropertyEditor;


/**
 * @jsp.tag name="money" body-content="empty" dynamic-attributes="true"
 *
 * @author gcase
 */
public class MoneyTag extends AbstractFieldTag
{
    private final static Logger logger = Logger.getLogger(MoneyTag.class);

    public MoneyTag()
    {
        super();
    }

    public void release()
    {
        super.release();
    }

    public void render(HTMLElement formElement)
    {
 
        String controlValue = getControlValue();
        NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(getRequestContext().getLocale());

        if (StringUtils.isNotBlank(controlValue))
        {
            Number parsed = null;
            try
            {
                parsed = currencyFormat.parse(controlValue);
            }
            catch (ParseException e)
            {
                try
                {
                    parsed = NumberFormat.getNumberInstance(getRequestContext().getLocale()).parse(
                            controlValue);
                }
                catch (ParseException ignored)
                {
                }
            }
            if (parsed != null)
            {
                controlValue = currencyFormat.format(parsed.doubleValue());
            }
        }

        InputElement input = formElement.createInputElementText(getControlName(), controlValue);
        input.setAttribute("id", getControlName());
        input.setAttribute("onblur", "formatAsMoney(this)");
        applyCommonAttributes(input);

        CharmDataBinder binder = _parent.getFormModel().getCharmDataBinder(bind);
        Class boundPropertyType = binder.getPropertyType(property);
        bindPropertyEditor(new NumberPropertyEditor(currencyFormat, boundPropertyType));
    }
}
