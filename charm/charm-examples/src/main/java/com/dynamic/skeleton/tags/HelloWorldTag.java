/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.

 * Copyright 2005, Dynamic Information Systems, LLC
 * $Id: AbstractCharmTag.java 14 2005-05-16 15:14:30Z  $

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
package com.dynamic.skeleton.tags;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyTag;

import com.dynamic.charm.web.tag.TagDefaults;
import com.dynamic.charm.web.tag.support.EvalTool;
import com.dynamic.charm.web.tag.support.SpringAwareTag;

/**
 * JSP Tag Handler class
 *
 * @jsp.tag   name = "helloworld"
 *            display-name = "Hello World Tag"
 *            description = "There isn't much to describe"
 *            body-content = "empty"
 */
public class HelloWorldTag extends SpringAwareTag
{
    /**
     * A default <code>serialVersionUID</code>
     */
    private static final long serialVersionUID = 1L;
    
    
    private String salutation;
    
    static
    {
        TagDefaults.getInstance().registerDefault(HelloWorldTag.class, "salutation", "Hello");
    }
 
    protected int doStartTagInternal() throws Exception
    {   
        TagDefaults.getInstance().setAllDefaults(this);
        pageContext.getOut().write(salutation + ", world!");
        return BodyTag.EVAL_BODY_INCLUDE;
    }
      
    /**
     * Getter for property salutation.
     * 
     * @return Value of property salutation.
     * @jsp.attribute required="false" rtexprvalue="true" description="The salutation to use when greting others.  Defaults to Hello."
     */
    public String getSalutation()
    {
        return salutation;
    }
    
    /**
     * @param salutation The salutation to set.
     */
    public void setSalutation(String salutation)
    {
        this.salutation = salutation;
    }

	protected void evaluateExpresssions(EvalTool evalTool) throws JspException
	{
		salutation = evalTool.evaluateAsString("salutation", salutation);
	}

	protected int doEndTagInternal()
	{
		return BodyTag.EVAL_PAGE;
	}
    
}
