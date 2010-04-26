package com.dynamic.charm.web.form.tag;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.support.RequestContext;
import org.springframework.web.util.JavaScriptUtils;

import com.dynamic.charm.common.Constants;
import com.dynamic.charm.common.StringUtils;
import com.dynamic.charm.web.builder.DivElement;
import com.dynamic.charm.web.builder.HTMLElement;
import com.dynamic.charm.web.builder.ImageElement;
import com.dynamic.charm.web.builder.InputElement;

public class CalendarSupport
{
	public static final String DATE_PATTERN = "MM/dd/yyyy";
	private final static Logger logger = Logger.getLogger(CalendarSupport.class);
	
	public HTMLElement renderCalendar(HTMLElement rootElement,  RequestContext context, String inputId, String inputName, Date defaultDate, boolean isDisabled, String options)
	{
		String calendarId = inputId + "Calendar";
       	String containerDivId = inputId + "CalDiv";
        String imgId = inputId + "Img";
    	String functionName = "init" + calendarId;
    	
    	InputElement input = rootElement.createInputElement("text", inputName);
    	input.setAttribute("id", inputId);
    	
    	if (defaultDate != null)
    	{
    		DateFormat dateFormat = createDateFormat();
    		input.setAttribute("value", dateFormat.format(defaultDate));
    	}

		// determine context-aware paths
		String contextPath = context.getContextPath();
		String imageURL = contextPath + "/images/calendar.jpg";

		//create image regardless if we are disabled
		ImageElement img = rootElement.createImageElement(imageURL);
		img.id(imgId);
		img.setAttribute("border", 0);
		img.style("vertical-align: middle;");
		img.alt("Click here to show the calendar");
		img.title("Click here to show the calendar");
    	
    	if (!isDisabled)
		{
			DivElement containerDiv = rootElement.createDivElement(containerDivId);
			containerDiv.style("position:absolute;");

			StringBuilder calendarScript = new StringBuilder();
			calendarScript.append(Constants.LINE_SEP);
			calendarScript.append("// IE does not like it sometimes when you run javascript modifying the dom before the dom has been fully created").append(Constants.LINE_SEP);
			calendarScript.append("// so we define the function, and call it after the body is loaded").append(Constants.LINE_SEP);
			calendarScript.append("function ").append(functionName).append("()").append(Constants.LINE_SEP);
			calendarScript.append("{").append(Constants.LINE_SEP);
			calendarScript.append("\tvar ").append(calendarId).append(" = new PopupCalendar(").append(escapeAndQuote(calendarId)).append(", ").append(escapeAndQuote(inputId)).append(", ").append(escapeAndQuote(containerDivId)).append(", ").append(escapeAndQuote(imgId) + ", ").append(options).append(");").append(Constants.LINE_SEP);
			calendarScript.append("}").append(Constants.LINE_SEP);
			calendarScript.append(Constants.LINE_SEP);
			calendarScript.append("YAHOO.util.Event.addListener(window, 'load', ").append(functionName).append(");").append(Constants.LINE_SEP);
			calendarScript.append(Constants.LINE_SEP);
			
			// render the javascript for the input
			rootElement.addJavascript(calendarScript.toString());
		}	
    	
    	return input;
		
	}
	
    public DateFormat createDateFormat()
    {
    	return new SimpleDateFormat(DATE_PATTERN);
    }
    
    private String escapeAndQuote(String s)
	{
		return "'" + JavaScriptUtils.javaScriptEscape(s) + "'";
	}
    
    public Date parseDate(String dateString, RequestContext context)
    {
    	DateFormat dateFormat = DateFormat.getDateInstance(DateFormat.SHORT, context.getLocale());
        Date result = null;
 
        if (StringUtils.isNotBlank(dateString))
        {
            try
            {
                result = dateFormat.parse(dateString);
            }
            catch (ParseException e)
            {
                logger.error("Could not parse the date parameter", e);
            }
        }
        return result;
    }
}
