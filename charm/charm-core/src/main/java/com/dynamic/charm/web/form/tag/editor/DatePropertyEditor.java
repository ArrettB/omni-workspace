/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: DatePropertyEditor.java 199 2006-11-14 23:38:41Z gcase $

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
import java.text.DateFormat;
import java.text.ParseException;
import java.util.Date;

import org.apache.log4j.Logger;

import com.dynamic.charm.common.StringUtils;


public class DatePropertyEditor extends PropertyEditorSupport
{	
	private DateFormat dateFormat;
	
	public DatePropertyEditor(DateFormat dateFormat) {
		this.dateFormat = dateFormat;
	}
	
    private final static Logger logger = Logger.getLogger(DatePropertyEditor.class);

    public void setAsText(String dateText) throws IllegalArgumentException
    {
        Date parsed;
        try
        {
        	if (StringUtils.isNotBlank(dateText))
        	{
                parsed = dateFormat.parse(dateText);
                setValue(parsed);
                logger.info("Setting value to " + parsed);
        	}
        	else
        	{
        		setValue(null);
                logger.info("Setting value to NULL");
        	}
        }
        catch (ParseException e)
        {
            logger.error("Bad Date Format", e);
            setValue(null);
        }
    }

    public String getAsText()
    {
        return dateFormat.format(getValue());
    }
}
