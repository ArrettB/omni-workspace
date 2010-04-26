package com.dynamic.servicetrax.tag;

import javax.servlet.jsp.JspException;

import com.dynamic.charm.web.tag.support.EvalTool;
import com.dynamic.charm.web.tag.support.SpringAwareTag;

/**
 * @jsp.tag name="hasRightElse"  body-content="JSP" 
 * 
 * @author gcase
 */
public class HasRightElseTag extends SpringAwareTag
{

	// BodyTag implementation ---------------------------------------
	public int doStartTagInternal() throws JspException
	{
		Boolean ifResult = getId() == null ? (Boolean) pageContext.getAttribute(HasRightTag.HAS_RIGHT_RESULT) : (Boolean) pageContext.getAttribute(getId());

		pageContext.removeAttribute(HasRightTag.HAS_RIGHT_RESULT);

		if (ifResult == null || ifResult.booleanValue() == true)
		{
			return SKIP_BODY;
		}
		else
		{
			return EVAL_BODY_INCLUDE;
		}
	}

	public int doEndTag() throws JspException
	{
		return super.doEndTag();
	}

	public void release()
	{
		setId(null);
		super.release();
	}

	@Override
	protected int doEndTagInternal()
	{
		return EVAL_PAGE;
	}

	@Override
	protected void evaluateExpresssions(EvalTool evalTool) throws JspException
	{
	}
}
