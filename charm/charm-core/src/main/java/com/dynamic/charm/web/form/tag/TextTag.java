/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: TextTag.java 199 2006-11-14 23:38:41Z gcase $

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

import org.apache.log4j.Logger;

import com.dynamic.charm.web.builder.HTMLElement;
import com.dynamic.charm.web.builder.InputElement;


/**
 * @jsp.tag name="text" body-content="empty" dynamic-attributes="true" body-content="empty"
 *
 * @author gcase
 */
public class TextTag extends AbstractFieldTag
{
    private final static Logger logger = Logger.getLogger(TextTag.class);

    public TextTag()
    {
        super();
        logger.debug("TextTag()");
    }

    public void release()
    {
        super.release();
    }

    public void render(HTMLElement formElement)
    {
        logger.debug("render()");

        InputElement input = formElement.createInputElementText(getControlName(), getControlValue());
        applyCommonAttributes(input);
    }
}
