/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.

 * Copyright 2005, Dynamic Information Systems, LLC
 * $Id: QueryServiceAwareTag.java 199 2006-11-14 23:38:41Z gcase $

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
 * Created on Dec 10, 2004
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.dynamic.charm.web.tag.support;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyTag;

import org.apache.log4j.Logger;

import com.dynamic.charm.exception.CharmException;
import com.dynamic.charm.query.DataService;
import com.dynamic.charm.query.hibernate.HibernateService;
import com.dynamic.charm.service.QueryService;


/**
 * @jsp.tag name="QueryServiceAwareTag"
 *
 * @author gcase
 */
public abstract class QueryServiceAwareTag extends SpringAwareTag
{
    private static final Logger logger = Logger.getLogger(QueryServiceAwareTag.class);

    private QueryServiceHelper queryServiceHelper;

    private String dataService;
    private String queryService;

    protected void evaluateExpresssions(EvalTool evalTool) throws JspException
    {
        queryServiceHelper = new QueryServiceHelper();
        dataService = evalTool.evaluateAsString("dataService", dataService);
        queryService = evalTool.evaluateAsString("queryService", queryService);
        queryServiceHelper.setDataService(dataService);
        queryServiceHelper.setQueryService(queryService);
    }

    public void release()
    {
        super.release();
        if (queryServiceHelper != null)
        {
            queryServiceHelper = null;
        }
    }
    
    protected int doEndTagInternal()
    {
    	return BodyTag.EVAL_BODY_INCLUDE;
    };

    protected HibernateService getDefaultHibernateService() throws CharmException
    {
        return queryServiceHelper.getDefaultHibernateService(getApplicationContext());
    }

    protected QueryService getQueryServiceInstance()
    {
        return queryServiceHelper.getQueryServiceInstance(getApplicationContext());
    }

    protected DataService getDataServiceInstance()
    {
        return queryServiceHelper.getDataServiceInstance(getApplicationContext());
    }

    /**
     * Getter for property dataService.
     *
     * @return Value of property dataService.
     * @jsp.attribute required="false" rtexprvalue="true" description="The data
     *                service that should be used to execute any database
     *                queries"
     */
    public String getDataService()
    {
        return dataService;
    }

    public void setDataService(String dataService)
    {
        this.dataService = dataService;
    }

    /**
     * Getter for property queryService.
     *
     * @return Value of property queryService.
     * @jsp.attribute required="false" rtexprvalue="true" description="The query
     *                service that should be used to broker between the
     *                individual dataservices"
     */
    public String getQueryService()
    {
        return queryService;
    }

    public void setQueryService(String queryService)
    {
        this.queryService = queryService;
    }
}
