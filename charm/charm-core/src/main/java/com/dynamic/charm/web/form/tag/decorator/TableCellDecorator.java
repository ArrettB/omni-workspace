/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: TableCellDecorator.java 199 2006-11-14 23:38:41Z gcase $

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


package com.dynamic.charm.web.form.tag.decorator;

import javax.servlet.http.HttpServletRequest;

import org.springframework.validation.FieldError;
import org.springframework.web.servlet.support.RequestContext;

import com.dynamic.charm.web.builder.HTMLElement;
import com.dynamic.charm.web.form.tag.AbstractFieldTag;


/**
 * This decorator renders its labels and inputs into two <code>&lt;td&gt;</code> elements within a single <code>&lt;tr&gt;</code>.
 * Errors are rendered as a single <code>&lt;td&gt;</code> with the <code>colspan</code> attribute set to 2.  If using this renderer, be sure
 * to include a <code>&lt;table&gt;</code><code>&lt;/table&gt;</code> inside of the form tag
 *
 * End result looks like this:
 *
 *
 *
 * @author gcase
 *
 */
public class TableCellDecorator extends BaseDecorator implements FieldDecorator
{
    private String labelCss;
    private String inputCss;
    private String errorCss;

    public void decorateAndRender(AbstractFieldTag tag, HTMLElement rootElement, RequestContext context, HttpServletRequest request)
    {

        HTMLElement labelCell = rootElement.createElement("td");
        HTMLElement labelElement = createLabelElement(tag, labelCell);
        labelElement.css(labelCss);

        HTMLElement inputCell = rootElement.createElement("td");
        inputCell.css(inputCss);

        // tells the tag to display itself, using inputCell as its enclosing element
        tag.render(inputCell);

        FieldError[] fieldErrors = tag.getErrors();
        if (fieldErrors != null)
        {
            for (int i = 0; i < fieldErrors.length; i++)
            {
                HTMLElement errorRow = rootElement.createElement("tr");
                HTMLElement errorCell = errorRow.createElement("td");
                errorCell.setAttribute("colspan", 2);
                errorCell.css(errorCss);
                errorCell.setText(tag.getErrorMessage(fieldErrors[i]));
            }
        }
    }

    public String getInputCss()
    {
        return inputCss;
    }

    public void setInputCss(String inputCss)
    {
        this.inputCss = inputCss;
    }

    public String getLabelCss()
    {
        return labelCss;
    }

    public void setLabelCss(String labelCss)
    {
        this.labelCss = labelCss;
    }

 

    public String getErrorCss()
    {
        return errorCss;
    }

    public void setErrorCss(String errorCss)
    {
        this.errorCss = errorCss;
    }
}
