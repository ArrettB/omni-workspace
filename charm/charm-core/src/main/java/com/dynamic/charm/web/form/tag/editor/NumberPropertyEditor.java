/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: NumberPropertyEditor.java 199 2006-11-14 23:38:41Z gcase $

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


package com.dynamic.charm.web.form.tag.editor;

import java.beans.PropertyEditorSupport;
import java.text.NumberFormat;
import java.text.ParseException;

import org.apache.log4j.Logger;

import com.dynamic.charm.common.StringUtils;
import com.dynamic.charm.reflect.ConvertUtils;


public class NumberPropertyEditor extends PropertyEditorSupport
{
    private final static Logger logger = Logger.getLogger(NumberPropertyEditor.class);
    private NumberFormat parser;
    private Class propertyType;

    public NumberPropertyEditor(NumberFormat parser, Class propertyType)
    {
        this.parser = parser;
        this.propertyType = propertyType;
    }

    public void setAsText(String value) throws IllegalArgumentException
    {
        if (StringUtils.isNotBlank(value))
        {
            try
            {
                Number result = parser.parse(value);
                Object converted = ConvertUtils.convert(result, propertyType);
                logger.debug("Setting property to " + converted);
                setValue(converted);
            }
            catch (ParseException e)
            {
                logger.error("Could not parse " + value);
            }
        }
        else
        {
            setValue(null);
        }
    }

    public String getAsText()
    {
        Object value = getValue();
        return value.toString();
    }
}
