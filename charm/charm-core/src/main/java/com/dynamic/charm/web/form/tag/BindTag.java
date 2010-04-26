/*
 * Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written consent of Dynamic
 * Information Systems. All rights reserved.
 *
 * Copyright 2005, Dynamic Information Systems, LLC $Id: BindTag.java 184
 * 2005-08-22 16:38:43Z $
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


package com.dynamic.charm.web.form.tag;

import java.io.Serializable;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspTagException;
import javax.servlet.jsp.tagext.Tag;

import org.apache.log4j.Logger;
import org.apache.taglibs.standard.resources.Resources;
import org.springframework.beans.BeanUtils;
import org.springframework.dao.DataAccessException;
import org.springframework.util.StringUtils;
import org.springframework.web.util.TagUtils;

import com.dynamic.charm.exception.CheckedCharmException;
import com.dynamic.charm.query.DataService;
import com.dynamic.charm.query.hibernate.HibernateService;
import com.dynamic.charm.query.jdbc.JDBCService;
import com.dynamic.charm.web.builder.HTMLElement;
import com.dynamic.charm.web.tag.TagDefaults;
import com.dynamic.charm.web.tag.support.EvalTool;
import com.dynamic.charm.web.tag.support.QueryServiceAwareTag;


/**
 * @jsp.tag name="bind" body-content="empty" description="Bind an object to the
 *          form"
 *
 * @author gcase
 */
public class BindTag extends QueryServiceAwareTag
{
    private static final Logger logger = Logger.getLogger(BindTag.class);

    private String className;
    private String identifier;
    private String name;
    private String table;
    private String identifierName;
    private boolean primary;
    private String primaryExpr;

    private String _identifier;
    private String _mode;

    protected void evaluateExpresssions(EvalTool evalTool) throws JspException
    {
        super.evaluateExpresssions(evalTool);
    	className = evalTool.evaluateAsString("className", className);
        identifier = evalTool.evaluateAsString("identifier", identifier);
        name = evalTool.evaluateAsString("name", name);
        table = evalTool.evaluateAsString("table", table);
        identifierName = evalTool.evaluateAsString("identifierName", identifierName);

        primary = evalTool.evaluateAsBoolean("primary", primaryExpr, false);
    }

    private String getIdentifierInputName()
    {
        return name + "_cpua_";
    }

    protected int doStartTagInternal() throws Exception
    {
        logger.debug("doStartTagInternal()");

        Tag t = findAncestorWithClass(this, FieldParent.class);
        if (t == null)
        {
            throw new JspTagException(Resources.getMessage("com.dynamic.charm.form.field_outside_parent"));
        }

        // send the parameter to the appropriate ancestor
        FieldParent parent = (FieldParent) t;

        // determine our actual identifer value
        // either value given from bind tag, or from the hidden input if this is
        // a repeated form showing
        _identifier = this.identifier;
        if (!StringUtils.hasText(_identifier))
        {
            _identifier = getParameter(getIdentifierInputName());
        }
        logger.debug("this.identifier = " + this.identifier);
        logger.debug("this._identifier = " + this._identifier);

        // this.identifier =
        // ExpressionEvaluationUtils.evaluateString("identifier", identifier,
        // pageContext);
        // this.identifier = (String)
        // ExpressionEvaluatorManager.evaluate("identifier", identifier,
        // String.class, pageContext);
        TagDefaults.getInstance().setAllDefaults(this);

        Object bound = fetchObject();

        if (bound == null)
        {
            throw new CheckedCharmException("No object exists that has that identifier.");
        }

        parent.getFormModel().performBinding(name, bound, resolveObjectClass(bound), _identifier);

        HTMLElement root = HTMLElement.createRootElement();
        root.addComment("Succesfully bound " + bound.getClass().getName() + " to " + name);
        root.addComment("Identifier = " + _identifier);
        root.createInputElementHidden(getIdentifierInputName(), _identifier);

        // also create one to mirror the parameter, if it came in as the same
        // name of the property
        String idParamName = guessIncomingParameterName();
        String idParamValue = getParameter(idParamName);
        if (StringUtils.hasText(idParamValue))
        {
            logger.info("Found a parameter for " + idParamName + ", it will be mirrored in the form");
            root.createInputElementHidden(idParamName, idParamValue);
        }
        else
        {
            logger.info("No parameter found for " + idParamName);
        }

        write(root.evaluateChildren());

        setObjectInScope(name, bound, TagUtils.SCOPE_PAGE);

        if (primary)
        {
            // determine the mode
            logger.info("Setting form mode to " + _mode);
            pageContext.setAttribute(FormTag.ATTRIBUTE_MODE, _mode);
        }

        return EVAL_BODY_INCLUDE;
    }

    private String guessIncomingParameterName() throws ClassNotFoundException
    {
        String result = identifierName;
        if (result == null)
        {
            DataService service = getDataServiceInstance();
            if (service instanceof HibernateService)
            {
                HibernateService hibernateService = ((HibernateService) service);
                Class entityClass = hibernateService.resolveClass(className);
                result = hibernateService.getIdentifierName(entityClass);
            }
        }
        return result;
    }

    /**
     * @return
     * @throws JspException
     * @throws ClassNotFoundException
     * @throws DataAccessException
     */
    private Object fetchObject() throws JspException, DataAccessException, ClassNotFoundException
    {
        logger.debug("fetchObject()");

        DataService service = getDataServiceInstance();

        if (service instanceof JDBCService)
        {
            return fetchObjectWithJDBC((JDBCService) service);
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

    private Class resolveObjectClass(Object boundObject)
    {
        Class bindClass = boundObject.getClass();
        DataService service = getDataServiceInstance();

        if ((className != null) && (service instanceof HibernateService))
        {
            try
            {
                bindClass = ((HibernateService) service).resolveClass(className);
            }
            catch (ClassNotFoundException e)
            {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
        return bindClass;
    }

    public int doEndTag() throws JspException
    {
        logger.debug("doEndTag()");
        logger.debug("identifier = " + identifier);
        return super.doEndTag();
    }

    private Object fetchObjectWithJDBC(JDBCService service) throws JspException
    {
        logger.debug("fetchObjectWithJDBC()");

        String query = "SELECT * FROM " + table + " WHERE " + identifierName + " = ?";
        return service.queryForObjectByPosition(query, _identifier);
    }

    private Object fetchObjectWithHibernate(HibernateService service) throws JspException,
        DataAccessException, ClassNotFoundException
    {
        logger.debug("fetchObjectWithHibernate()");

        if (StringUtils.hasText(_identifier))
        {
            logger.debug("_identifier = " + _identifier);

            Object result = service.get(service.resolveClass(className), (Serializable) _identifier);

            if (result == null)
            {
                _mode = FormTag.MODE_INSERT;
                return BeanUtils.instantiateClass(service.resolveClass(className));
            }
            else
            {
                _mode = FormTag.MODE_UPDATE;
                return result;
            }
        }
        else
        {
            _mode = FormTag.MODE_INSERT;
            return BeanUtils.instantiateClass(service.resolveClass(className));
        }
    }

    /**
     * Getter for property classname.
     *
     * @return Value of property getClassName.
     * @jsp.attribute required="false" rtexprvalue="true" description="The fully
     *                qualified class object that will be returned. Applicable
     *                only when using HibernateService."
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
     * @return Value of property identifier.
     * @jsp.attribute required="true" rtexprvalue="true" description="The
     *                identifier value of the object to be fetched"
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
     * @jsp.attribute required="false" rtexprvalue="true" description="The name
     *                of the primary key column that should be used when doing
     *                the fetch. Only applicable when using JDBCService"
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
     * Getter for property table.
     *
     * @return Value of property getTable.
     * @jsp.attribute required="false" rtexprvalue="true" description="The name
     *                of the table that should be used when doing the fetch.
     *                Only applicable when using JDBCService"
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
     * Getter for property name.
     *
     * @return Value of property getName.
     * @jsp.attribute required="true" rtexprvalue="true" description="The name
     *                of the "
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
     * Getter for property primary.
     *
     * @return Value of property primary.
     * @jsp.attribute required="false" rtexprvalue="true" description="Is this
     *                the bind that controls the form"
     */
    public String getPrimary()
    {
        return primaryExpr;
    }

    public void setPrimary(String primary)
    {
        this.primaryExpr = primary;
    }
}
