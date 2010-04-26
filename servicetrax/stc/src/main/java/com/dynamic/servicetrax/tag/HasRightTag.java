package com.dynamic.servicetrax.tag;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyTag;

import com.dynamic.charm.common.StringUtils;
import com.dynamic.charm.web.tag.support.EvalTool;
import com.dynamic.charm.web.tag.support.SpringAwareTag;
import com.dynamic.servicetrax.service.SecurityService;


/**
 * @jsp.tag name="hasRight"  body-content="JSP" 
 * 
 * @author gcase
 */
public class HasRightTag extends SpringAwareTag
{
	private String function;
	private String rightType;

	public final static String HAS_RIGHT_RESULT = HasRightTag.class + ".result";
	
	protected void evaluateExpresssions(EvalTool evalTool) throws JspException
	{
		function = evalTool.evaluateAsString("function", function);
		rightType = evalTool.evaluateAsString("rightType", rightType);
	}

	protected int doStartTagInternal() throws Exception
	{
		boolean hasRight = false;
		if (StringUtils.isNotBlank(function) && StringUtils.isNotBlank(rightType))
		{
			SecurityService securityService = (SecurityService) getBean(SecurityService.DEFAULT_SECURITY_SERVICE_NAME, SecurityService.class);
			hasRight = securityService.hasRight(getRequest(), function, rightType);
		}

		pageContext.setAttribute(HasRightTag.HAS_RIGHT_RESULT, Boolean.valueOf(hasRight));
		if (hasRight)
		{
			return EVAL_BODY_INCLUDE;
		}
		else
		{
			return SKIP_BODY;
		}
		
	}

	
	
	protected int doEndTagInternal()
	{
		return BodyTag.EVAL_PAGE;
	}
	
	
	/**
	 * Getter for property function.
	 * 
	 * @return Value of property function.
	 * @jsp.attribute required="true" rtexprvalue="true" description="The function code"
	 */
	public String getFunction()
	{
		return function;
	}

	public void setFunction(String function)
	{
		this.function = function;
	}
	
	/**
	 * 
	 * Getter for property rightType.
	 * 
	 * @return Value of property function.
	 * @jsp.attribute required="true" rtexprvalue="true" description="The right type code"
	 */
	public String getRightType()
	{
		return rightType;
	}

	public void setRightType(String rightType)
	{
		this.rightType = rightType;
	}
	
	@Override
	public void release()
	{
		super.release();
	}
}
