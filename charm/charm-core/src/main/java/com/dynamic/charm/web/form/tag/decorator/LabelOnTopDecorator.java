/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: LabelOnTopDecorator.java 199 2006-11-14 23:38:41Z gcase $

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

import org.springframework.web.servlet.support.RequestContext;

import com.dynamic.charm.web.builder.HTMLElement;
import com.dynamic.charm.web.form.tag.AbstractFieldTag;


public class LabelOnTopDecorator extends BaseDecorator implements FieldDecorator
{
    private String labelCss;
    private String inputCss;
    private String rowCss;
    private String mandatoryRowCss;

    public void decorateAndRender(AbstractFieldTag tag, HTMLElement rootElement, RequestContext context, HttpServletRequest request)
    {
        String labelText = getLabel(tag);

        HTMLElement firstRow = rootElement.createElement("tr");
        if (tag.treatAsMandatory())
        {
            firstRow.css(rowCss);
        }
        else
        {
            firstRow.css(mandatoryRowCss);
        }

        HTMLElement labelCell = firstRow.createElement("td");
        labelCell.css(labelCss);
        labelCell.setText(labelText);

        HTMLElement secondRow = rootElement.createElement("tr");
        if (tag.treatAsMandatory())
        {
            firstRow.css(rowCss);
        }
        else
        {
            firstRow.css(mandatoryRowCss);
        }

        HTMLElement inputCell = secondRow.createElement("td");
        inputCell.css(inputCss);

        tag.render(inputCell);
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

    public String getMandatoryRowCss()
    {
        return mandatoryRowCss;
    }

    public void setMandatoryRowCss(String mandatoryRowCss)
    {
        this.mandatoryRowCss = mandatoryRowCss;
    }

    public String getRowCss()
    {
        return rowCss;
    }

    public void setRowCss(String rowCss)
    {
        this.rowCss = rowCss;
    }
}
