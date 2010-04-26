/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.

 * Copyright 2005, Dynamic Information Systems, LLC
 * $Id: SpringAwareTag.java 265 2007-08-02 01:41:07Z bvonhaden $

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


/*
 * Created on Oct 21, 2004
 */
package com.dynamic.charm.web.tag.support;

import java.io.IOException;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspTagException;
import javax.servlet.jsp.tagext.BodyTagSupport;

import org.apache.commons.collections.iterators.EmptyIterator;
import org.apache.commons.lang.BooleanUtils;
import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;
import org.springframework.web.servlet.support.JspAwareRequestContext;
import org.springframework.web.servlet.support.RequestContext;
import org.springframework.web.util.TagUtils;

import com.dynamic.charm.common.ApplicationContextHelper;


/**
 *
 * @jsp.tag name="SpringAwareTag"
 *
 *
 * Abstract base class for creating tags that have easy access to Spring.
 * Includes convenient methods for common resource calls. Tags that extend this
 * class should implement the following methods:
 *
 * protected final int doStartTagInternal() throws JspException, IOException
 * public void doFinally()
 *
 * Support for message handling must be configured in your
 * applicationContext.xml
 *
 * <bean id="messageSource"
 * class="org.springframework.context.support.ResourceBundleMessageSource">
 * <property name="basenames"> <list><value>security </value>
 * <value>securityAPI </value> </list> </property> </bean>
 *
 * @author gcase
 */
public abstract class SpringAwareTag extends BodyTagSupport
{
 
    /** PageContext attribute for page-level RequestContext instance */
    public static final String REQUEST_CONTEXT_PAGE_ATTRIBUTE = "org.springframework.web.servlet.tags.REQUEST_CONTEXT";
    
    private RequestContext requestContext;
    private Map dynamicAttributes;
    private ApplicationContextHelper applicationContextHelper;
    
    private static final Logger logger = Logger.getLogger(SpringAwareTag.class);
   
    public final int doStartTag() throws JspException
    {
    	logger.debug("doStartTag()");
        this.requestContext = (RequestContext) this.pageContext.getAttribute(REQUEST_CONTEXT_PAGE_ATTRIBUTE);
        try
        {
            if (this.requestContext == null)
            {
                this.requestContext = new JspAwareRequestContext(this.pageContext);
                this.pageContext.setAttribute(REQUEST_CONTEXT_PAGE_ATTRIBUTE, this.requestContext);
            }
            this.applicationContextHelper = new ApplicationContextHelper(requestContext.getWebApplicationContext());

            evaluateExpresssions(new EvalTool(this, pageContext));
            return doStartTagInternal();
        }
        catch (JspException ex)
        {
            logger.error(ex.getMessage(), ex);
            throw ex;
        }
        catch (RuntimeException ex)
        {
            logger.error(ex.getMessage(), ex);
            throw ex;
        }
        catch (Exception ex)
        {
            logger.error(ex.getMessage(), ex);
            throw new JspTagException(ex.getMessage());
        }
    }

    public int doEndTag() throws JspException
    {
    	int result = doEndTagInternal(); 
    	logger.debug("doEndTag()");
        if (dynamicAttributes != null)
        {
            dynamicAttributes.clear();
        }
        dynamicAttributes = null;
        return result;
    }
    
    /**
     * Called by doStartTag to perform the actual work.
     *
     * @return same as TagSupport.doStartTag
     * @throws Exception
     *             any exception, any checked one other than a JspException gets
     *             wrapped in a JspException by doStartTag
     * @see javax.servlet.jsp.tagext.TagSupport#doStartTag
     */
    protected abstract int doStartTagInternal() throws Exception;
  
    protected abstract int doEndTagInternal();

    protected abstract void evaluateExpresssions(EvalTool evalTool) throws JspException;

    /**
     * Return the current RequestContext.
     */
    protected final RequestContext getRequestContext()
    {
        return requestContext;
    }

    protected void write(String msg)
    {
        try
        {
            pageContext.getOut().write(msg);
        }
        catch (IOException e)
        {
            logger.error(e.getMessage(), e);
        }
    }

    protected String getParameter(String key)
    {
        return getRequest().getParameter(key);
    }

    protected Object getSessionAttribute(String key)
    {
        return getSession().getAttribute(key);
    }

    protected void setSessionAttribute(String key, Object val)
    {
        getSession().setAttribute(key, val);
    }

    protected HttpServletRequest getRequest()
    {
        return (HttpServletRequest) pageContext.getRequest();
    }

    protected HttpServletResponse getResponse()
    {
        return (HttpServletResponse) pageContext.getResponse();
    }

    protected HttpSession getSession()
    {
        return getRequest().getSession();
    }

    protected ApplicationContext getApplicationContext()
    {
        return getRequestContext().getWebApplicationContext();
    }

    protected void setObjectInScope(String variableName, Object value, String scopeName)
    {
        logger.info("Setting " + variableName + " to " + value + " in " + scopeName + " scope.");
        pageContext.setAttribute(variableName, value, TagUtils.getScope(scopeName));
    }

    public void setDynamicAttribute(String uri, String localName, Object value) throws JspException
    {
        logger.debug("Setting attribute " + localName + " to " + value + ", uri = " + uri);
        if (dynamicAttributes == null)
        {
        	dynamicAttributes = new LinkedHashMap();
        }
        dynamicAttributes.put(localName, value);
    }

    public Object getDynamicAttribute(String localName)
    {
    	if (dynamicAttributes == null)
			return null;
		else
			return dynamicAttributes.get(localName);
    }   
    
    public Boolean getDynamicAttributeBoolean(String localName)
	{
		Object val = getDynamicAttribute(localName);
		if (val == null)
			return Boolean.FALSE;
		else
			return BooleanUtils.toBooleanObject(val.toString());
	}
    
    public Iterator dynamicAttributeNamesIterator()
    {
    	if (dynamicAttributes == null)
    		return EmptyIterator.INSTANCE;
    	else
    		return dynamicAttributes.keySet().iterator();
    }

	public Object getBean(String name, Class requiredType)
	{
		return applicationContextHelper.getBean(name, requiredType);
	}

	public Object getBean(String name)
	{
		return applicationContextHelper.getBean(name);
	}

	public Object[] getBeansOfType(Class requiredType)
	{
		return applicationContextHelper.getBeansOfType(requiredType);
	}

	public String getMessage(String key, Object[] args)
	{
		return applicationContextHelper.getMessage(key, args);
	}

	public String getMessage(String key, String defaultMessage, Object[] args)
	{
		return applicationContextHelper.getMessage(key, defaultMessage, args);
	}

	public String getMessage(String key, String defaultMessage)
	{
		return applicationContextHelper.getMessage(key, defaultMessage);
	}

	public String getRawMessage(String key)
	{
		return applicationContextHelper.getRawMessage(key);
	}

	public String getRawMessage(String key, Object[] args)
	{
		return applicationContextHelper.getRawMessage(key, args);
	}

	public String getMessage(String key)
	{
		return applicationContextHelper.getMessage(key);
	}

	public String getPrefixedMessage(Class prefixClass, String key, Object[] args)
	{
		return applicationContextHelper.getPrefixedMessage(prefixClass, key, args);
	}

	public String getPrefixedMessage(Class prefixClass, String key, String defaultMessage, Object[] args)
	{
		return applicationContextHelper.getPrefixedMessage(prefixClass, key, defaultMessage, args);
	}

	public String getPrefixedMessage(Class prefixClass, String key, String defaultMessage)
	{
		return applicationContextHelper.getPrefixedMessage(prefixClass, key, defaultMessage);
	}

	public String getPrefixedMessage(Class prefixClass, String key)
	{
		return applicationContextHelper.getPrefixedMessage(prefixClass, key);
	}
    
}
