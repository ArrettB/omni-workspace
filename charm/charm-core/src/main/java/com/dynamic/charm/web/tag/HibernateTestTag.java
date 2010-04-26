/*
 * Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written consent of Dynamic
 * Information Systems. All rights reserved.
 *
 * Copyright 2005, Dynamic Information Systems, LLC $Id: HibernateTestTag.java
 * 149 2005-07-19 14:45:43Z $
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

import java.beans.PropertyDescriptor;
import java.io.IOException;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.jsp.JspException;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import com.dynamic.charm.exception.ExceptionUtils;
import com.dynamic.charm.query.hibernate.HibernateService;
import com.dynamic.charm.service.DefaultQueryService;
import com.dynamic.charm.web.builder.CellElement;
import com.dynamic.charm.web.builder.HTMLElement;
import com.dynamic.charm.web.builder.InputElement;
import com.dynamic.charm.web.builder.RowElement;
import com.dynamic.charm.web.builder.TableElement;
import com.dynamic.charm.web.builder.TextAreaElement;
import com.dynamic.charm.web.tag.support.QueryServiceAwareTag;


/**
 * @jsp.tag name="hibernateTest" body-content="empty"
 * @jsp.variable name-given="testVariable" class="java.lang.Integer"
 *               scope="NESTED"
 *
 * @author gcase
 */
public class HibernateTestTag extends QueryServiceAwareTag
{
    private static final String QUERY_PARAM = "query";

    private static final Logger logger = Logger.getLogger(HibernateTestTag.class);

    static
    {
        TagDefaults.getInstance().registerDefault(HibernateTestTag.class, "dataService", DefaultQueryService.DEFAULT_HIBERNATE_SERVICE_NAME);
    }

    private String defaultQuery;

    /*
     * (non-Javadoc)
     *
     * @see org.springframework.web.servlet.tags.RequestContextAwareTag#doStartTagInternal()
     */
    protected int doStartTagInternal() throws Exception
    {
        logger.debug("HibernateQuery.doStartTag()");
        TagDefaults.getInstance().setAllDefaults(this);

        return EVAL_BODY_INCLUDE;
    }

    public int doEndTag() throws JspException
    {
        logger.debug("HibernateQuery.doEndTag()");

        HTMLElement div = HTMLElement.createRootElement("div");

        try
        {
            String query = pageContext.getRequest().getParameter(QUERY_PARAM);
            renderForm(div, query);

            if (StringUtils.isNotBlank(query))
            {
                HibernateService service = getDefaultHibernateService();
                List list = (List) service.queryForList(query);

                render(div, list);
            }
        }
        catch (Exception e)
        {
            renderError(div, e);
        }
        finally
        {
            try
            {
                pageContext.getOut().write(div.toString());
            }
            catch (IOException e1)
            {
            }
        }

        return EVAL_PAGE;
    }

    private void renderCell(RowElement row, Object val)
    {
        CellElement cell = row.createCell();
        cell.style("font-family:verdana;font-size:10px;background-color:#EEE");
        cell.setText(convertToString(val));
    }

    private void renderHeaderCell(RowElement row, String name)
    {
        CellElement cell = row.createCell();
        cell.style("font-weight:bold;font-family:verdana;font-size:10px;background-color:#CCC");
        cell.setText(name);
    }

    private void renderForm(HTMLElement root, String query)
    {
        HTMLElement form = root.createElement("form");
        form.setAttribute("method", "post");
        form.setAttribute("name", "hibQueryTestForm");

        TableElement table = form.createTableElement();
        table.cellpadding(0).cellspacing(1).border(0);

        RowElement row = table.createRow();

        CellElement cell = row.createCell();
        TextAreaElement area = cell.createTextAreaElement(QUERY_PARAM);
        area.style("font-family:verdana;font-size:10px;width:600px;height:150px;");
        area.rows(10);
        area.cols(60);
        if (StringUtils.isNotBlank(query))
        {
            area.setText(query);
        }
        else if (StringUtils.isNotBlank(defaultQuery))
        {
            area.setText(defaultQuery);
        }

        cell = row.createCell();

        InputElement button = cell.createInputElementSubmit("Run Query", "Run Query!");
        button.style("font-family:verdana;font-size:10px;");
    }

    private void renderRowMap(TableElement table, int rowNum, Map propertyMap)
    {
        RowElement row = table.createRow();
        renderCell(row, Integer.toString(rowNum));

        for (Iterator iter = propertyMap.keySet().iterator(); iter.hasNext();)
        {
            String property = (String) iter.next();
            Object val = propertyMap.get(property);
            CellElement cell = row.createCell();
            cell.style("font-family:verdana;font-size:10px;background-color:#EEE");
            cell.setText(convertToString(val));
        }
    }

    private void renderRowBean(TableElement table, int rowNum, Object bean)
    {
        RowElement row = table.createRow();
        renderCell(row, Integer.toString(rowNum));

        PropertyDescriptor[] props = PropertyUtils.getPropertyDescriptors(bean);
        for (int i = 0; i < props.length; i++)
        {
            String attribute = props[i].getName();

            Object val = null;
            try
            {
                val = BeanUtils.getProperty(bean, attribute);
            }
            catch (Exception e)
            {
                val = e;
            }

            CellElement cell = row.createCell();
            cell.style("font-family:verdana;font-size:10px;background-color:#EEE");
            cell.setText(convertToString(val));
        }
    }

    private void renderRowArray(TableElement table, int rowNum, Object[] array)
    {
        RowElement row = table.createRow();
        renderCell(row, Integer.toString(rowNum));
        for (int i = 0; i < array.length; i++)
        {
            renderCell(row, array[i]);
        }
    }

    public String convertToString(Object o)
    {
        return (o != null) ? o.toString() : "<NULL>";
    }

    private void renderHeader(TableElement table, Object firstRowObject)
    {
        RowElement row = table.createRow();
        renderHeaderCell(row, "Row");

        if (firstRowObject instanceof Object[])
        {
            Object[] fields = (Object[]) firstRowObject;

            for (int i = 0; i < fields.length; i++)
            {
                renderHeaderCell(row, "Column " + i);
            }
        }
        else if (firstRowObject instanceof Map)
        {
            for (Iterator iter = ((Map) firstRowObject).keySet().iterator(); iter.hasNext();)
            {
                String columnName = (String) iter.next();
                renderHeaderCell(row, columnName);
            }
        }
        else
        {
            PropertyDescriptor[] props = PropertyUtils.getPropertyDescriptors(firstRowObject);
            for (int i = 0; i < props.length; i++)
            {
                renderHeaderCell(row, props[i].getName());
            }
        }
    }

    private void render(HTMLElement root, List list)
    {
        if (list == null)
        {
            root.createElement("div").setText("No Rows Returned");
            return;
        }

        TableElement table = root.createTableElement();
        table.cellpadding(2).cellspacing(1).border(0);
        table.style("border:solid 1px black");

        int rownum = 1;

        for (Iterator iterator = list.iterator(); iterator.hasNext();)
        {
            Object bean = iterator.next();

            if (rownum == 1)
            {
                renderHeader(table, bean);
            }

            if (bean instanceof Object[])
            {
                renderRowArray(table, rownum++, (Object[]) bean);
            }
            if (bean instanceof Map)
            {
                renderRowMap(table, rownum++, (Map) bean);
            }
            else
            {
                renderRowBean(table, rownum++, bean);
            }
        }
    }

    private void renderError(HTMLElement root, Throwable e)
    {
        // Builder builder = new Builder();
        // HTMLElement div = builder.addElement("div");
        TableElement table = root.createTableElement();
        table.cellpadding(2).cellspacing(1).border(0);
        table.style("border:solid 1px black");

        RowElement row = table.createRow();

        CellElement cell = row.createCell();
        cell.style("font-family:courier;font-size:10px;background-color:#EEE;color:Red");

        HTMLElement preElement = cell.createElement("pre");

        String error = ExceptionUtils.formatStackTrace(e);
        logger.error("Exception in HibernateTestTag", e);
        preElement.setText(error);
    }

    /**
     * Getter for property defaultQuery.
     *
     * @return Value of property defaultQuery.
     * @jsp.attribute required="false" rtexprvalue="true" description="The value
     *                of the query that should be shown when first seen."
     */
    public String getDefaultQuery()
    {
        return defaultQuery;
    }

    public void setDefaultQuery(String defaultQuery)
    {
        this.defaultQuery = defaultQuery;
    }
}
