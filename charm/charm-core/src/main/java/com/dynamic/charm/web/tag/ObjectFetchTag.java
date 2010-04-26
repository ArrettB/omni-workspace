/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.

 * Copyright 2005, Dynamic Information Systems, LLC
 * $Id: ObjectFetchTag.java 199 2006-11-14 23:38:41Z gcase $

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

import java.io.Serializable;

import javax.servlet.jsp.JspException;

import org.apache.log4j.Logger;
import org.springframework.dao.DataAccessException;
import org.springframework.util.StringUtils;
import org.springframework.web.util.TagUtils;

import com.dynamic.charm.query.DataService;
import com.dynamic.charm.query.hibernate.HibernateService;
import com.dynamic.charm.query.jdbc.DefaultJDBCService;
import com.dynamic.charm.query.jdbc.JDBCService;
import com.dynamic.charm.service.DefaultQueryService;
import com.dynamic.charm.web.tag.support.EvalTool;
import com.dynamic.charm.web.tag.support.QueryServiceAwareTag;


/**
 * @jsp.tag name="objectFetch" body-content="empty" description="It fetches objects, fool!"
 *
 * @author gcase
 */
public class ObjectFetchTag extends QueryServiceAwareTag
{
    private static final Logger logger = Logger.getLogger(ObjectFetchTag.class);

    static
    {
        TagDefaults.getInstance().registerDefault(ObjectFetchTag.class, "dataService", DefaultQueryService.DEFAULT_HIBERNATE_SERVICE_NAME);
        TagDefaults.getInstance().registerDefault(ObjectFetchTag.class, "scope", TagUtils.SCOPE_PAGE);
    }

    private String className;
    private String identifier;
    private String var;
    private String scope;
    private String table;
    private String identifierName;

    protected void evaluateExpresssions(EvalTool evalTool) throws JspException
    {
        super.evaluateExpresssions(evalTool);
        className = evalTool.evaluateAsString("className", className);
        identifier = evalTool.evaluateAsString("identifier", identifier);
        var = evalTool.evaluateAsString("var", var);
        scope = evalTool.evaluateAsString("scope", scope);
        table = evalTool.evaluateAsString("table", table);
        identifierName = evalTool.evaluateAsString("identifierName", identifierName);
    }

    /*
     * (non-Javadoc)
     *
     * @see org.springframework.web.servlet.tags.RequestContextAwareTag#doStartTagInternal()
     */
    protected int doStartTagInternal() throws Exception
    {
        logger.debug("ObjectFetchTag.doStartTagInternal()");
        TagDefaults.getInstance().setAllDefaults(this);

        Object obj = fetchObject();

        if (StringUtils.hasText(var))
        {
            setObjectInScope(var, obj, scope);
        }
        else
        {
            write(obj.toString());
        }

        return EVAL_BODY_INCLUDE;
    }

    /**
     * @return
     * @throws JspException
     * @throws ClassNotFoundException
     * @throws DataAccessException
     */
    private Object fetchObject() throws JspException, DataAccessException, ClassNotFoundException
    {
        DataService service = (getDataServiceInstance());

        if (service instanceof JDBCService)
        {
            return fetchObjectWithJDBC((DefaultJDBCService) service);
        }
        else if (service instanceof HibernateService)
        {
            return fetchObjectWithHibernate((HibernateService) service);
        }
        else
        {
            return null;
        }
    }

    private Object fetchObjectWithJDBC(JDBCService service) throws JspException
    {
        String query = "SELECT * FROM " + table + " WHERE " + identifierName + " = ?";
        return service.queryForObjectByPosition(query, identifier);
    }

    private Object fetchObjectWithHibernate(HibernateService service) throws JspException,
        DataAccessException, ClassNotFoundException
    {
        return service.get(service.resolveClass(className), (Serializable) identifier);
    }

    /**
     * Getter for property classname.
     *
     * @return Value of property getClassName.
     * @jsp.attribute required="false" rtexprvalue="true" description="The fully qualified class object that will be returned. Applicable only when using HibernateService."
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
     * Getter for property identifier.
     *
     * @return Value of property getService.
     * @jsp.attribute required="true" rtexprvalue="true" description="The identifier value of the object to be fetched"
     */
    public String getIdentifier()
    {
        return identifier;
    }

    public void setIdentifier(String identifier)
    {
        this.identifier = identifier;
    }

    /**
     * Getter for property identifierName.
     *
     * @return Value of property getIdentifierName.
     * @jsp.attribute required="false" rtexprvalue="true" description="The name of the primary key column that should be used when doing the fetch.  Only applicable when using JDBCService"
     */
    public String getIdentifierName()
    {
        return identifierName;
    }

    public void setIdentifierName(String identifierName)
    {
        this.identifierName = identifierName;
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
     * Getter for property table.
     *
     * @return Value of property getTable.
     * @jsp.attribute required="false" rtexprvalue="true" description="The name of the table that should be used when doing the fetch.  Only applicable when using JDBCService"
     */
    public String getTable()
    {
        return table;
    }

    public void setTable(String table)
    {
        this.table = table;
    }

    /**
     * Getter for property var.
     *
     * @return Value of property getVar.
     * @jsp.attribute required="false" rtexprvalue="true" description="The name of the variable that will be set with the result of the fetch."
     */
    public String getVar()
    {
        return var;
    }

    public void setVar(String var)
    {
        this.var = var;
    }
}
