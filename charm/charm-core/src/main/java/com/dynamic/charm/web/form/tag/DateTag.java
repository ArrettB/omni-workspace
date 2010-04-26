/*
 * Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written consent of Dynamic
 * Information Systems. All rights reserved.
 *
 * Copyright 2005, Dynamic Information Systems, LLC $Id: DateTag.java 143
 * 2005-07-14 17:59:32Z $
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 * FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL DYNAMIC
 * INFORMATIONS SYTEMS, LLC BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * ====================================================================
 */


package com.dynamic.charm.web.form.tag;

import java.util.Date;

import javax.servlet.jsp.JspException;

import org.apache.log4j.Logger;
import org.springframework.util.StringUtils;

import com.dynamic.charm.date.DateUtils;
import com.dynamic.charm.web.builder.HTMLElement;
import com.dynamic.charm.web.form.tag.editor.DatePropertyEditor;
import com.dynamic.charm.web.tag.support.EvalTool;


/**
 * @jsp.tag name="date" body-content="empty" dynamic-attributes="true"
 *
 * Creates a date input chooser.  The date chooser utilizes the yahoo ui calendar library.  
 * See <a href="http://developer.yahoo.com/yui/calendar/">http://developer.yahoo.com/yui/calendar/</a> for details.
 * <br><br>
 * To use this calendar, you will need to include the necessary javascript files.
 * 
 * <pre>
 * &lt;script type="text/javascript" src="&lt;c:url value="/js/yui/yahoo.js"/&gt;"&gt;&lt;/script&gt;
 * &lt;script type="text/javascript" src="&lt;c:url value="/js/yui/dom.js"/&gt;"&gt;&lt;/script&gt;
 * &lt;script type="text/javascript" src="&lt;c:url value="/js/yui/event.js"/&gt;"&gt;&lt;/script&gt;
 * &lt;script type="text/javascript" src="&lt;c:url value="/js/yui/calendar.js"/&gt;"&gt;&lt;/script&gt;
 * &lt;script type="text/javascript" src="&lt;c:url value="/js/calendar.js"/&gt;"&gt;&lt;/script&gt;
 *</pre>
 *
 * @author gcase
 */
public class DateTag extends AbstractFieldTag
{
    private String adjustByDays;
    private final static Logger logger = Logger.getLogger(DateTag.class);

    public static final String DATE_PATTERN = "MM/dd/yyyy";
    
    protected void evaluateExpresssions(EvalTool evalTool) throws JspException
    {
        super.evaluateExpresssions(evalTool);
        adjustByDays = evalTool.evaluateAsString("adjustByDays", adjustByDays);
    }
   
    public void render(HTMLElement formElement)
    {
    	// the date we need to display
    	Date currentDateValue = getControlValueAsDate();
    	if(StringUtils.hasText(adjustByDays) && currentDateValue == null)
    	{
    		currentDateValue = DateUtils.addDays(new Date(), Integer.parseInt(adjustByDays));
    	}
        
    	Boolean disabled = getDynamicAttributeBoolean("disabled");
    	String inputId = getUsableId();
   
    	CalendarSupport calendarSupport = new CalendarSupport();
		HTMLElement calendarInput = calendarSupport.renderCalendar(formElement, getRequestContext(), inputId, getControlName(), currentDateValue, disabled.booleanValue(), "{}");
		applyCommonAttributes(calendarInput);
   	
		// register our editor
    	if (!disabled.booleanValue())
		{
			bindPropertyEditor(new DatePropertyEditor(calendarSupport.createDateFormat()));
		}
 
    }

    
    /**
     * Operates in the same manner as getControlValue, but returns a date object
     * instead
     *
     * @return the control value as a date
     * @see AbstractFieldTag#getControlValue()
     */
    protected Date getControlValueAsDate()
    {
        Date result = null;
        String dateString = null;

        // value attribute
        dateString = value;
        if (!StringUtils.hasText(dateString))
        {
            // parameter value
            dateString = getParameter(getControlName());

            if (!StringUtils.hasText(dateString))
            {
                // bound value
                Object boundValue = getBoundValue();
                if ((boundValue != null) && (boundValue instanceof Date))
                {
                    result = (Date) boundValue;
                }
                else
                {
                    dateString = getBoundValueAsString();
                    if (!StringUtils.hasText(dateString))
                    {
                        // defaultValue attribute
                        dateString = defaultValue;
                    }
                }
            }
        }

        if ((dateString != null) && (result == null))
        {
        	result =  new CalendarSupport().parseDate(dateString, getRequestContext());
        }
        return result;
    }

    
    /**
     * Getter for property adjustByDays.
     *
     * @return Value of property adjustByDays
     * @jsp.attribute required="false" rtexprvalue="true" description="The
     *                number of days, positive or negative that you wish to adjust the default date."
     */
   public String getAdjustByDays()
   {
      return adjustByDays;
   }

   public void setAdjustByDays(String adjustByDays)
   {
      this.adjustByDays = adjustByDays;
   }
}
