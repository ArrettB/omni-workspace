/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: RadioTag.java 243 2007-04-09 16:41:49Z nwest $

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


package com.dynamic.charm.web.form.tag;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.jsp.JspException;

import org.apache.log4j.Logger;
import org.springframework.beans.BeanWrapperImpl;
import org.springframework.util.StringUtils;

import com.dynamic.charm.common.ArrayUtils;
import com.dynamic.charm.exception.CharmException;
import com.dynamic.charm.exception.CheckedCharmException;
import com.dynamic.charm.query.DataService;
import com.dynamic.charm.query.NamedQuery;
import com.dynamic.charm.service.QueryService;
import com.dynamic.charm.web.builder.HTMLElement;
import com.dynamic.charm.web.builder.RadioElement;
import com.dynamic.charm.web.builder.RadioGroupElement;
import com.dynamic.charm.web.form.CharmDataBinder;
import com.dynamic.charm.web.form.tag.editor.HibernateObjectPropertyEditor;
import com.dynamic.charm.web.tag.TagDefaults;
import com.dynamic.charm.web.tag.support.EvalTool;
import com.dynamic.charm.web.tag.support.ParamParent;
import com.dynamic.charm.web.tag.support.QueryServiceHelper;


/**
 * @jsp.tag name="radio" body-content="JSP" dynamic-attributes="true"
 *
 * @author gcase
 */
public class RadioTag extends AbstractParameterAwareFieldTag implements ParamParent
{
    private final static String[] DEFAULT_LABEL_PROPS = new String[]
        {
            "name", "label", "display"
        };
    private final static String[] DEFAULT_VALUE_PROPS = new String[]
        {
            "id", "value", "identifier"
        };

    private final static Logger logger = Logger.getLogger(RadioTag.class);
    private String radioValue;
    private String radioLabel;
    private String namedQueryId;
    private String query;
    private String dataService;
    private String queryService;

    private QueryServiceHelper _queryServiceHelper;

    protected int doStartTagInternal() throws Exception
    {
        logger.debug("SelectTag.doStartTagInternal()");
        TagDefaults.getInstance().setAllDefaults(this);
        return super.doStartTagInternal();
    }

    protected void evaluateExpresssions(EvalTool evalTool) throws JspException
    {
        super.evaluateExpresssions(evalTool);
        _queryServiceHelper = new QueryServiceHelper();
        dataService = evalTool.evaluateAsString("dataService", dataService);
        queryService = evalTool.evaluateAsString("queryService", queryService);
        _queryServiceHelper.setDataService(dataService);
        _queryServiceHelper.setQueryService(queryService);

        radioValue = evalTool.evaluateAsString("radioValue", radioValue);
        radioLabel = evalTool.evaluateAsString("radioLabel", radioLabel);
        namedQueryId = evalTool.evaluateAsString("namedQueryId", namedQueryId);
        query = evalTool.evaluateAsString("query", query);
    }

    public void release()
    {
        super.release();
        if (_queryServiceHelper != null)
        {
            _queryServiceHelper = null;
        }
    }

    public void render(HTMLElement formElement)
    {
        // determine the type
        CharmDataBinder binder = _parent.getFormModel().getCharmDataBinder(bind);
        Class boundType = binder.getPropertyType(property);

        // register a new editor for that type
        // call the object hope, as in I "hope" this works. Get it?!?
        HibernateObjectPropertyEditor hope = new HibernateObjectPropertyEditor(boundType, getQueryServiceInstance().getHibernateService());
        binder.registerCustomEditor(boundType, property, hope);

        RadioGroupElement element = formElement.createRadioGroupElement(getControlName());

        applyCommonAttributes(element);

        try
        {
            List results = fetchResults();
            if ((radioLabel == null) || (radioValue == null))
            {
                if (results.size() > 0)
                {
                    generateDefaultValues(results.get(0));
                }
            }

            Object currentValue = getBoundValue();
            for (Iterator iter = results.iterator(); iter.hasNext();)
            {
                createItem(element, iter.next(), currentValue);
            }
        }
        catch (CheckedCharmException e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

    /**
     * Developers can be lazy, so lets try to guess what they wanted for
     *
     * @param representative
     */
    public void generateDefaultValues(Object representative)
    {
        if (representative instanceof Map)
        {
            // create a lowercase list
            List keys = new ArrayList();
            for (Iterator iter = ((Map) representative).keySet().iterator(); iter.hasNext();)
            {
                String element = (String) iter.next();
                keys.add(element.toLowerCase());
            }

            for (int i = 0; i < DEFAULT_LABEL_PROPS.length; i++)
            {
                if (keys.contains(DEFAULT_LABEL_PROPS[i]))
                {
                    radioLabel = DEFAULT_LABEL_PROPS[i];
                }
            }
            for (int i = 0; i < DEFAULT_VALUE_PROPS.length; i++)
            {
                if (keys.contains(DEFAULT_VALUE_PROPS[i]))
                {
                    radioValue = DEFAULT_VALUE_PROPS[i];
                }
            }
        }
        else
        {
            BeanWrapperImpl bw = new BeanWrapperImpl(representative);
            for (int i = 0; i < DEFAULT_LABEL_PROPS.length; i++)
            {
                if (bw.isReadableProperty(DEFAULT_LABEL_PROPS[i]))
                {
                    radioLabel = DEFAULT_LABEL_PROPS[i];
                }
            }
            for (int i = 0; i < DEFAULT_VALUE_PROPS.length; i++)
            {
                if (bw.isReadableProperty(DEFAULT_VALUE_PROPS[i]))
                {
                    radioValue = DEFAULT_VALUE_PROPS[i];
                }
            }
        }
        if ((radioLabel == null) || (radioValue == null))
        {
            throw new CharmException(
                "radioLabel and radioValue were not specified, and could not be determined from the query results");
        }
    }

    public String convertToString(Object o)
    {
        if (o == null)
        {
            return "";
        }
        else
        {
            return o.toString();
        }
    }

    public RadioElement createItem(RadioGroupElement rg, Map map, Object currentValue)
    {
        String display = convertToString(map.get(radioLabel));
        String value = convertToString(map.get(radioValue));
        RadioElement radio = rg.createRadioElement(display, value);
        return radio;
    }

    public RadioElement createItem(RadioGroupElement rg, Object object, Object currentValue)
    {
        BeanWrapperImpl bw = new BeanWrapperImpl(object);
        String display = convertToString(bw.getPropertyValue(radioLabel));
        String value = convertToString(bw.getPropertyValue(radioValue));
        RadioElement radio = rg.createRadioElement(display, value);

        CharmDataBinder binder = _parent.getFormModel().getCharmDataBinder(bind);
        Class boundType = binder.getPropertyType(property);

        if (currentValue != null)
        {
            Serializable id = getQueryServiceInstance().getHibernateService().getIdentifier(
                    boundType, currentValue);
            if (id.toString().equals(value))
            {
                radio.setSelected(true);
                logger.info("Setting selection to " + display);
            }
        }

        return radio;
    }

    private List fetchResults() throws CheckedCharmException
    {
        logger.info(ArrayUtils.toString(paramsToNameArray(), "parameterNames"));

        if (StringUtils.hasText(namedQueryId))
        {
            NamedQuery namedQuery = getQueryServiceInstance().getNamedQuery(namedQueryId);
            return getQueryServiceInstance().queryForList(namedQuery, paramsToNameArray(), paramsToValueArray());
        }
        else
        {
            DataService service = getDataServiceInstance();
            return service.queryForList(query, paramsToNameArray(), paramsToValueArray(), paramsToTypeArray());
        }
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

    /**
     * Getter for property namedQueryId.
     *
     * @return Value of property getNamedQueryId.
     * @jsp.attribute required="false" rtexprvalue="true" description="The named
     *                query ID"
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
     * Getter for property query.
     *
     * @return Value of property getQuery.
     * @jsp.attribute required="false" rtexprvalue="true" description="The query
     *                to run, if the namedQueryId is not set"
     */
    public String getQuery()
    {
        return query;
    }

    public void setQuery(String query)
    {
        this.query = query;
    }

    /**
     * Getter for property radioLabel.
     *
     * @return Value of property radioLabel.
     * @jsp.attribute required="false" rtexprvalue="true" description="The
     *                property to be used for the display of the tag"
     */
    public String getRadioLabel()
    {
        return radioLabel;
    }

    public void setRadioLabel(String optionLabel)
    {
        this.radioLabel = optionLabel;
    }

    /**
     * Getter for property radioValue.
     *
     * @return Value of property radioValue.
     * @jsp.attribute required="false" rtexprvalue="true" description="The
     *                property to be used to get the value of the tag"
     */
    public String getRadioValue()
    {
        return radioValue;
    }

    public void setRadioValue(String optionValue)
    {
        this.radioValue = optionValue;
    }

    public QueryService getQueryServiceInstance()
    {
        return _queryServiceHelper.getQueryServiceInstance(getApplicationContext());
    }

    public DataService getDataServiceInstance()
    {
        return _queryServiceHelper.getDataServiceInstance(getApplicationContext());
    }
}
