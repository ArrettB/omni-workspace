/*
 * Dynamic Information Systems, LLC
 * 
 * This software can only be used with the expressed written consent of Dynamic
 * Information Systems. All rights reserved.
 * 
 * Copyright 2005, Dynamic Information Systems, LLC $Id: SortTag.java 199 2006-11-14 23:38:41Z gcase $
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

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyTag;

import org.springframework.beans.support.PropertyComparator;
import org.springframework.web.util.TagUtils;

import com.dynamic.charm.exception.CharmException;
import com.dynamic.charm.web.tag.support.EvalTool;
import com.dynamic.charm.web.tag.support.SpringAwareTag;

/**
 * @jsp.tag name="sort" body-content="empty" display-name="Sort"
 *          description="Sorts the given collection, using the property
 *          specified as the sort criteria. This does not sort the collecion
 *          itself, but a shallow copy, which will be made availabe in the scope
 *          and var names provided"
 * @author gcase
 * 
 */
public class SortTag extends SpringAwareTag
{
	static
	{
		TagDefaults.getInstance().registerDefault(QueryServiceTag.class, "scope", TagUtils.SCOPE_PAGE);
	}

	private String property;
	private String order;
	private String var;
	private String scope;
	private Object collection;
	private String collectionExpr;
	private boolean caseSensitive;
	private String caseSensitiveExpr;

	protected void evaluateExpresssions(EvalTool evalTool) throws JspException
	{
		property = evalTool.evaluateAsString("property", property);
		caseSensitive = evalTool.evaluateAsBoolean("caseSensitive", caseSensitiveExpr, true);
		var = evalTool.evaluateAsString("var", var);
		scope = evalTool.evaluateAsString("scope", scope);
	}
	
	protected int doStartTagInternal() throws Exception
	{
        TagDefaults.getInstance().setAllDefaults(this);
		
		if (collection == null)
		{
			return SKIP_BODY;
		}
		else if (collection instanceof Collection)
		{
			// perform a shallow copy into a list
			List sortMe = new ArrayList();
			sortMe.addAll((Collection) collection);

			PropertyComparator comparator = new PropertyComparator(property, caseSensitive, !isDescending());
			Collections.sort(sortMe, comparator);
			setObjectInScope(var, sortMe, scope);
		}
		else
		{
			throw new CharmException("Expected a collection, but collection evaluates to " + collection);
		}

		return SKIP_BODY;
	}
	
    protected int doEndTagInternal()
    {
    	return BodyTag.EVAL_PAGE;
    }
    
	public boolean isDescending()
	{
		return "reverse".equalsIgnoreCase(order) || "desc".equalsIgnoreCase(order) || "descending".equalsIgnoreCase(order);
	}

	/**
	 * Getter for property scope.
	 * 
	 * @return Value of property getScope.
	 * @jsp.attribute required="false" rtexprvalue="true" description="The scope
	 *                to be used when setting the variable value. Allowed values
	 *                are page, request, session, and application. Defaults to
	 *                page"
	 */
	public String getScope()
	{
		return scope;
	}

	public void setScope(String scope)
	{
		this.scope = scope;
	}

	/**
	 * Getter for property var.
	 * 
	 * @return Value of property getVar.
	 * @jsp.attribute required="true" rtexprvalue="true" description="The name
	 *                of the variable that will be set with the result of the
	 *                fetch."
	 */
	public String getVar()
	{
		return var;
	}

	public void setVar(String var)
	{
		this.var = var;
	}

	/**
	 * Getter for property caseSensitive.
	 * 
	 * @return Value of property caseSensitive.
	 * @jsp.attribute required="false" rtexprvalue="true" type="boolean"
	 *                description="Determines if the sort should be
	 *                caseSensitive. Defaults to true"
	 * @jsp
	 */
	public String setCaseSensitive()
	{
		return caseSensitiveExpr;
	}

	public void setCaseSensitive(String caseSensitive)
	{
		this.caseSensitiveExpr = caseSensitive;
	}

	/**
	 * Getter for property collection.
	 * 
	 * @return Value of property collection.
	 * @jsp.attribute required="false" rtexprvalue="true" description="The
	 *                collection to be sorted. The collection will not be sorted
	 *                itself, but a shallow copy instead"
	 */
	public Object getCollection()
	{
		return collection;
	}

	public void setCollection(Object collection) throws JspException
	{
		if (collection == null)
		{
			this.collection = null;
		}
		else if (collection instanceof String)
		{
			// must be an expression
			EvalTool evalTool = new EvalTool(this, pageContext);
			this.collection = evalTool.evaluateAsObject("collection", (String) collection);
		}
		else if (collection instanceof Collection)
		{
			this.collection = collection;
		}
		else
		{
			throw new JspException("Unexpected type for collection attribute: " + collection);
		}

	}

	/**
	 * Getter for property order.
	 * 
	 * @return Value of property order.
	 * @jsp.attribute required="false" rtexprvalue="true" description="The order
	 *                to sort by. Pass in <code>desc</code> to sort decending.
	 *                Synonyms are provided for a descending sort
	 *                <code>descending</code> and <code>reverse</code>.
	 *                Otherwise will sort ascending. "
	 * @jsp
	 */
	public String getOrder()
	{
		return order;
	}

	public void setOrder(String order)
	{
		this.order = order;
	}

	/**
	 * Getter for property property.
	 * 
	 * @return Value of property property.
	 * @jsp.attribute required="false" rtexprvalue="true" description="The
	 *                property that should be used to sort by. This property
	 *                should evaluate to a type that is <code>Comparable</code>"
	 * @jsp
	 */
	public String getProperty()
	{
		return property;
	}

	public void setProperty(String property)
	{
		this.property = property;
	}
}
