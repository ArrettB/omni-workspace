/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: DivDecorator.java 199 2006-11-14 23:38:41Z gcase $

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
 *
 * This decorator encloses the label with a span tag with a given css class,
 * does the same thing with the control, and then wraps the entire thing in a
 * div. Use this if you want to create table-less forms.
 *
 * Resulting HTML:
 *
 *
 *
 * @author gcase
 *
 */
public class DivDecorator extends BaseDecorator implements FieldDecorator
{
    private String labelCss;
    private String inputCss;
    private String divCss;
    private String errorCss;
    private String mandatoryDivCss;

    public void decorateAndRender(AbstractFieldTag tag, HTMLElement rootElement, RequestContext context, HttpServletRequest request)
    {
        HTMLElement div = rootElement.createElement("div");
        if (tag.treatAsMandatory())
        {
            div.css(mandatoryDivCss);
        }
        else
        {
            div.css(divCss);
        }

        HTMLElement labelElement = createLabelElement(tag, div);
        labelElement.css(labelCss);

        HTMLElement inputSpan = div.createElement("span");
        inputSpan.css(inputCss);

        // tells the tag to display itself, using inputSpan as its enclosing element
        tag.render(inputSpan);

        FieldError[] fieldErrors = tag.getErrors();
        if (fieldErrors != null)
        {
            for (int i = 0; i < fieldErrors.length; i++)
            {
                HTMLElement error = rootElement.createElement("div");
                error.css(errorCss);
                error.setText(tag.getErrorMessage(fieldErrors[i]));
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

    public String getDivCss()
    {
        return divCss;
    }

    public void setDivCss(String divCss)
    {
        this.divCss = divCss;
    }

    public String getMandatoryDivCss()
    {
        return mandatoryDivCss;
    }

    public void setMandatoryDivCss(String mandatoryDivCss)
    {
        this.mandatoryDivCss = mandatoryDivCss;
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
