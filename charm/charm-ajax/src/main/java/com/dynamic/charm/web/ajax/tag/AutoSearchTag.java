/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.

 * Copyright 2005, Dynamic Information Systems, LLC
 * $Id: ObjectFetchTag.java 11 2005-10-19 21:27:59Z gcase $

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

package com.dynamic.charm.web.ajax.tag;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.DynamicAttributes;

import org.apache.log4j.Logger;

import com.dynamic.charm.web.builder.DivElement;
import com.dynamic.charm.web.builder.HTMLElement;
import com.dynamic.charm.web.builder.InputElement;
import com.dynamic.charm.web.form.tag.BaseTag;
import com.dynamic.charm.web.tag.TagDefaults;
import com.dynamic.charm.web.tag.support.EvalTool;

/**
 * Create an autocomplete dropdown list input field.
 * This uses the Script.aculo.us Javascript library to make the AJAX calls. 
 *
 * You should limit the amount of return values to a reasonable number in the query.
 *
 * <pre>
  &lt;charm-ajax:autoSearch name="newUser" value="" targetParam="name" searchList="newDashboardUsers.ajax" className="autocomplete"
		                    minChars="0"
		                    options="parameters: \"prefix=userId\", afterUpdateElement : getSelectionId" />
	</pre>	                    
    <br/>this is supposed to generate the following html--<br/>
   <pre>
   &lt;input type="text" name="newUser" value="" id="newUser_autocomplete" autocomplete="off" />
   &lt;div id="div_newUser_autocomplete" class="autocomplete">&lt;/div>
   &lt;script type="text/javascript">new Ajax.Autocompleter('newUser_autocomplete','div_newUser_autocomplete','newDashboardUsers.ajax' ,{paramName: 'name', minChars: 0, parameters: "prefix=userId", afterUpdateElement : getSelectionId});&lt;/script>
   </pre>

 *
 * @author nwest
 * @version $Id$
 * @jsp.tag name="autoSearch" body-content="empty" description="Create an AJAX autocomplete droplist chooser" dynamic-attributes="true"
 * 
 */
public class AutoSearchTag extends BaseTag implements DynamicAttributes
{
	private static final Logger logger = Logger.getLogger(AutoSearchTag.class);

	private String name;
	private String value;
	private String targetParam;
	private String searchList;
	private String className;
	private String minChars;
	private String options;

	private HTMLElement _autoSearch;

	protected void evaluateExpresssions(EvalTool evalTool) throws JspException
	{
		super.evaluateExpresssions(evalTool);
		name = evalTool.evaluateAsString("name", name);
		value = evalTool.evaluateAsString("value", value);
		targetParam = evalTool.evaluateAsString("targetParam", targetParam);
		searchList = evalTool.evaluateAsString("searchList", searchList);
		className =  evalTool.evaluateAsString("className", className);
		if (className == null)
			className = "auto_complete";
		
		options = evalTool.evaluateAsString("options", options);
		if (options != null)
		{
			if (!options.startsWith(","))
				options = ", " + options;
		}
		else
		{
			options = "";
		}
		
		minChars = evalTool.evaluateAsString("minChars", minChars);
		if (minChars == null)
			minChars = "2";
	}

	/*
	 * (non-Javadoc)
	 *
	 * @see org.springframework.web.servlet.tags.RequestContextAwareTag#doStartTagInternal()
	 */
	protected int doStartTagInternal() throws Exception
	{
		logger.debug("doStartTagInternal()");
		TagDefaults.getInstance().setAllDefaults(this);

		_autoSearch = HTMLElement.createRootElement();

		InputElement input = _autoSearch.createInputElementText(name, value);
		String inputId = name + "_autocomplete";
		input.setAttribute("id", inputId);
		input.setAttribute("autocomplete", "off");
		applyCommonAttributes(input);

		String divId = "div_" + name + "_autocomplete";
		DivElement div = _autoSearch.createDivElement(divId);
		div.setAttribute("class", className);

		String ajaxScript = "new Ajax.Autocompleter('" + inputId + "','" + divId + "','" + searchList + "' ,{paramName: '"
				+ targetParam + "', minChars: " + minChars + options + "});";
		_autoSearch.addJavascript(ajaxScript);

		return EVAL_BODY_INCLUDE;
	}

	protected int doEndTagInternal()
	{
		write(_autoSearch.evaluateChildren());
		return EVAL_PAGE;
	}

	/**
	 * This names the input field.
	 *
	 * @return Value of property name.
	 * @jsp.attribute required="true" rtexprvalue="true" description="This names the input field."
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
	 * This is the name of the column that is returned by the controller.
	 *
	 * @return Value of property targetParam.
	 * @jsp.attribute required="true" rtexprvalue="true" description="This is the name of the column that is returned by the controller."
	 */
	public String getTargetParam()
	{
		return targetParam;
	}

	public void setTargetParam(String targetParam)
	{
		this.targetParam = targetParam;
	}

	/**
	 * This is url that points to the target search list.
	 *
	 * @return Value of property searchList.
	 * @jsp.attribute required="true" rtexprvalue="true" description="This is url that points to the target search list."
	 */
	public String getSearchList()
	{
		return searchList;
	}

	public void setSearchList(String searchList)
	{
		this.searchList = searchList;
	}

	/**
	 * The initial value for the field.
	 *
	 * @return Value of property value.
	 * @jsp.attribute required="true" rtexprvalue="true" description="The initial value for the field"
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
	 * The autocomplete div class name
	 * 
	 * @return
	 * @jsp.attribute required="false" rtexprvalue="true" description="The div class name"
	 */
	public String getClassName()
	{
		return className;
	}

	public void setClassName(String className)
	{
		this.className = className;
	}

	/**
	 * The options for the Ajax.Autocompleter, other than paramName or minChars.
	 * Those have their own specific options settings
	 * 
	 * @return the options for the Ajax.Autocompleter.
	 * @jsp.attribute required="false" rtexprvalue="true" description="The options for the Ajax.Autocompleter, other than paramName or minChars.  Those have their own specific options settings."
	 */
	public String getOptions()
	{
		return options;
	}

	public void setOptions(String options)
	{
		this.options = options;
	}

	/**
	 * The minChars option for the Ajax.Autocompleter
	 * 
	 * @return the minimum characters to activate the lookup
	 * @jsp.attribute required="false" rtexprvalue="true" description="The minChars option for the Ajax.Autocompleter"
	 */
	public String getMinChars()
	{
		return minChars;
	}

	public void setMinChars(String minChars)
	{
		this.minChars = minChars;
	}

}
