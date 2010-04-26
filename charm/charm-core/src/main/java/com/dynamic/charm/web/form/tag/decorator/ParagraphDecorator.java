/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: ParagraphDecorator.java 199 2006-11-14 23:38:41Z gcase $

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
 *This is a simple decorator that places the label and the input in a paragraph element
 *
 * Resulting HTML:
 *
 *
 *
 * @author gcase
 *
 */
public class ParagraphDecorator extends BaseDecorator implements FieldDecorator
{
	private String mandatoryClass;
	private String errorClass;
 
    public void decorateAndRender(AbstractFieldTag tag, HTMLElement rootElement, RequestContext context, HttpServletRequest request)
    {
        HTMLElement para = rootElement.createElement("p");
        if (tag.treatAsMandatory())
        {
        	para.css(mandatoryClass);
        }
        else
        {
        }

        HTMLElement labelElement = createLabelElement(tag, para);

        // tells the tag to display itself, using inputSpan as its enclosing element
        tag.render(para);

        FieldError[] fieldErrors = tag.getErrors();
        if (fieldErrors != null)
        {
            for (int i = 0; i < fieldErrors.length; i++)
            {
                HTMLElement error = rootElement.createElement("div");
                error.css(errorClass);
                error.setText(tag.getErrorMessage(fieldErrors[i]));
            }
        }
    }

	public void setErrorClass(String errorClass)
	{
		this.errorClass = errorClass;
	}

	public void setMandatoryClass(String mandatoryClass)
	{
		this.mandatoryClass = mandatoryClass;
	}

   
}
