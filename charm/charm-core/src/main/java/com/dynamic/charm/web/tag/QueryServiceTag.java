/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.

 * Copyright 2005, Dynamic Information Systems, LLC
 * $Id: QueryServiceTag.java 199 2006-11-14 23:38:41Z gcase $

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


package com.dynamic.charm.web.tag;

import java.util.List;

import javax.servlet.jsp.JspException;

import org.apache.log4j.Logger;
import org.springframework.dao.DataAccessException;
import org.springframework.util.StringUtils;
import org.springframework.web.util.TagUtils;

import com.dynamic.charm.exception.CharmException;
import com.dynamic.charm.exception.CheckedCharmException;
import com.dynamic.charm.query.DataService;
import com.dynamic.charm.service.DefaultQueryService;
import com.dynamic.charm.web.tag.support.EvalTool;
import com.dynamic.charm.web.tag.support.ParamParent;
import com.dynamic.charm.web.tag.support.ParameterAwareTag;


/**
 * @jsp.tag name="queryService" body-content="JSP" display-name="Query Service" description="Using the queryService, it executes the specified query and returns the result in a variable with the same name as the <code>var</code> attribute."
 *
 * @author gcase
 */
public class QueryServiceTag extends ParameterAwareTag implements ParamParent
{
    private static final Logger logger = Logger.getLogger(QueryServiceTag.class);

    static
    {
        TagDefaults.getInstance().registerDefault(QueryServiceTag.class, "dataService", DefaultQueryService.DEFAULT_HIBERNATE_SERVICE_NAME);
        TagDefaults.getInstance().registerDefault(QueryServiceTag.class, "scope", TagUtils.SCOPE_PAGE);
    }

    private String var;
    private String scope;
    private String namedQueryId;
    private String query;
    private String singleExpr;
    private boolean single;
    
    protected void evaluateExpresssions(EvalTool evalTool) throws JspException
    {
        super.evaluateExpresssions(evalTool);
        var = evalTool.evaluateAsString("var", var);
        scope = evalTool.evaluateAsString("scope", scope);
        namedQueryId = evalTool.evaluateAsString("namedQueryId", namedQueryId);
        query = evalTool.evaluateAsString("query", query);
        single = evalTool.evaluateAsBoolean("single", singleExpr, false);
    }

    /*
     * (non-Javadoc)
     *
     * @see org.springframework.web.servlet.tags.RequestContextAwareTag#doStartTagInternal()
     */
    protected int doStartTagInternal() throws Exception
    {
        TagDefaults.getInstance().setAllDefaults(this);
        return super.doStartTagInternal();
    }

    public void release()
    {
        super.release();
    }

    public int doEndTag() throws JspException
    {
        try
        {
            List queryResults = fetchResults();
            if (single)
            {
                if ((queryResults == null) || (queryResults.size() == 0))
                {
                    //nothing to do
                }
                else if (queryResults.size() == 1)
                {
                    setObjectInScope(var, queryResults.get(0), scope);
                }
                else
                {
                    throw new CharmException("Expected to receive only a single result from query, actually returned " + queryResults.size() + " items: [" + queryResults + "]");
                }
            }
            else
            {
                setObjectInScope(var, queryResults, scope);
            }
        }
        catch (CheckedCharmException e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

        return EVAL_PAGE;
    }

    /**
     * @return
     * @throws JspException
     * @throws ClassNotFoundException
     * @throws DataAccessException
     */
    private List fetchResults() throws CheckedCharmException
    {
        if (StringUtils.hasText(namedQueryId))
        {
            return getQueryServiceInstance().namedQueryForList(namedQueryId, paramsToNameArray(), paramsToValueArray());
        }
        else
        {
            DataService service = (getDataServiceInstance());
            return service.queryForList(query, paramsToNameArray(), paramsToValueArray(), paramsToTypeArray());
        }
    }

    /**
     * Getter for property scope.
     *
     * @return Value of property getScope.
     * @jsp.attribute required="false" rtexprvalue="true" description="The scope
     *                to be used when setting the variable value. Allowed values
     *                are page, request, session, and application. Defaults to page"
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
     * Getter for property namedQueryId.
     *
     * @return Value of property getNamedQueryId.
     * @jsp.attribute required="false" rtexprvalue="true" description="The named query ID"
     */
    public String getNamedQueryId()
    {
        return namedQueryId;
    }

    public void setNamedQueryId(String namedQueryId)
    {
        this.namedQueryId = namedQueryId;
    }

    /**
    * Getter for property single.
    *
    * @return Value of property single.
    * @jsp.attribute required="false" rtexprvalue="true" type="boolean"
    * description="If this is set to true, the tag expects the query
    *              will only return a single result.  The tag will use this value, rather than returning a
    *              list of a single element.  If more than one result is returned, an exception will be raised.
    *              Defaults to false"
    */
    public String isSingle()
    {
        return singleExpr;
    }

    public void setSingle(String single)
    {
        this.singleExpr = single;
    }

    /**
    * Getter for property query.
    *
    * @return Value of property getQuery.
    * @jsp.attribute required="false" rtexprvalue="true" description="The query to run, if the namedQueryId is not set"
    */
    public String getQuery()
    {
        return query;
    }

    public void setQuery(String query)
    {
        this.query = query;
    }
}
