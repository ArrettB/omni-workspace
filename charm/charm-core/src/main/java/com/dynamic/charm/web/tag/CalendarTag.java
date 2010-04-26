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


package com.dynamic.charm.web.tag;

import java.util.Date;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyTag;
import javax.servlet.jsp.tagext.DynamicAttributes;

import org.apache.log4j.Logger;

import com.dynamic.charm.web.builder.HTMLElement;
import com.dynamic.charm.web.form.tag.BaseTag;
import com.dynamic.charm.web.form.tag.CalendarSupport;
import com.dynamic.charm.web.tag.support.EvalTool;


/**
 * Creates a date input chooser.  The date chooser utilizes the yahoo ui calendar library.  
 * See <a href="http://developer.yahoo.com/yui/calendar/">http://developer.yahoo.com/yui/calendar/</a> for details.
 * <br><br>
 * To use this calendar, you will need to include the necessary javascript files.
 * 
 * <pre>
 * &lt;script type="text/javascript" src="&lt;c:url value="/js/yui/yahoo-dom-event/yahoo-dom-event.js"/&gt;"&gt;&lt;/script&gt;
 * &lt;script type="text/javascript" src="&lt;c:url value="/js/yui/calendar/calendar.js"/&gt;"&gt;&lt;/script&gt;
 * &lt;script type="text/javascript" src="&lt;c:url value="/js/calendar.js"/&gt;"&gt;&lt;/script&gt;
 *</pre>
 *
 * @author gcase
 * @jsp.tag name="calendar" display-name="YUI Calender" body-content="empty" dynamic-attributes="true"
 *  description="Creates a date input chooser.  The date chooser utilizes the yahoo ui calendar library."
 */
public class CalendarTag extends BaseTag implements DynamicAttributes
{
    private final static Logger logger = Logger.getLogger(CalendarTag.class);

    public static final String DATE_PATTERN = "MM/dd/yyyy";
    
    private String name;
    private String value;
    private String options;

	private HTMLElement _rootElement;
    
    protected void evaluateExpresssions(EvalTool evalTool) throws JspException
    {
        super.evaluateExpresssions(evalTool);
        name = evalTool.evaluateAsString("name", name);
        value = evalTool.evaluateAsString("value", value);
        options = evalTool.evaluateAsString("options", options);
   }
	
    protected int doStartTagInternal() throws Exception
	{
		logger.debug("doStartTagInternal()");

		_rootElement = HTMLElement.createRootElement();
		CalendarSupport calendarSupport = new CalendarSupport();
		Date defaultDate = null;
		if (value == null)
		{
			defaultDate = new Date();
		}
		else
		{
			defaultDate = calendarSupport.parseDate(value, getRequestContext());
		}

		String inputId = id != null ? id : name;

		HTMLElement calendarInput = calendarSupport.renderCalendar(_rootElement, getRequestContext(), inputId, name, defaultDate, false, options);
		applyCommonAttributes(calendarInput);

		return BodyTag.EVAL_BODY_INCLUDE;
	}

    protected int doEndTagInternal()
    {
        write(_rootElement.evaluateChildren());
    	return EVAL_PAGE;
    }
    
    /**
     * Getter for property name.
     *
     * @return Value of property name.
     * @jsp.attribute required="false"
     *  rtexprvalue="true"
     *  description="Pass Through value for the name attribute"
     */
     public String getName()
     {
         return name;
     }

     public void setName(String name)
     {
         this.name = name;
     }
     
     /**
      * Getter for property value.
      *
      * @return Value of property value.
      * @jsp.attribute
      *  required="false"
      *  rtexprvalue="true" 
      *  description="The value that should be initially displayed"
      */
      public String getValue()
      {
          return value;
      }

      public void setValue(String value)
      {
          this.value = value;
      }

	/**
	 * @return Returns the options for the calendar.
     * @jsp:attribute required="false"
     *  rtexprvalue="true"
     *  description="The options for the calendar."
	 */
	public String getOptions()
	{
		return options;
	}

	/**
	 * @param options The options to set.
	 */
	public void setOptions(String options)
	{
		this.options = options;
	}
    

}
