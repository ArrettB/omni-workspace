package com.dynamic.charm.web.tag;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.MissingResourceException;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspTagException;

import org.apache.log4j.Logger;
import org.apache.taglibs.standard.resources.Resources;
import org.springframework.beans.BeanWrapperImpl;

import com.dynamic.charm.common.ArrayUtils;
import com.dynamic.charm.common.StringUtils;
import com.dynamic.charm.exception.CharmException;
import com.dynamic.charm.exception.CheckedCharmException;
import com.dynamic.charm.query.DataService;
import com.dynamic.charm.service.QueryService;
import com.dynamic.charm.web.tag.support.EvalTool;
import com.dynamic.charm.web.tag.support.Option;
import com.dynamic.charm.web.tag.support.ParamHelper;
import com.dynamic.charm.web.tag.support.ParamParent;
import com.dynamic.charm.web.tag.support.QueryServiceAwareTag;
import com.dynamic.charm.web.tag.support.SelectParent;

/**
 * @jsp.tag name="options" body-content="JSP"
 * 
 * @author gcase
 */
public class OptionCollectionTag extends QueryServiceAwareTag implements ParamParent
{
	/**
	 * 
	 */
	private static final long serialVersionUID = -5257744435549749156L;

	private final static Logger logger = Logger.getLogger(OptionCollectionTag.class);

	private final static String[] DEFAULT_LABEL_PROPS = new String[] { "name", "label", "display", "description" };
	private final static String[] DEFAULT_VALUE_PROPS = new String[] { "id", "value", "identifier" };

	private String optionValue;
	private String optionLabel;
	private String namedQueryId;
	private String query;
	private Object collection;
	private ParamHelper paramHelper = new ParamHelper();

	protected void evaluateExpresssions(EvalTool evalTool) throws JspException
	{
		super.evaluateExpresssions(evalTool);
		optionValue = evalTool.evaluateAsString("optionValue", optionValue);
		optionLabel = evalTool.evaluateAsString("optionLabel", optionLabel);
		namedQueryId = evalTool.evaluateAsString("namedQueryId", namedQueryId);
		query = evalTool.evaluateAsString("query", query);

	}	
	
	
	protected int doStartTagInternal() throws Exception
	{
	       // must clear out any parameters from previous invocations
        if (paramHelper != null)
        {
        	paramHelper.release();
        }
        paramHelper = new ParamHelper();
        
        return EVAL_BODY_INCLUDE;
      }
	
	public int doEndTag() throws JspException
	{
		try
		{
			SelectParent parent = (SelectParent) findAncestorWithClass(this, SelectParent.class);
			if (parent == null)
			{
				throw new JspTagException(Resources.getMessage("PARAM_OUTSIDE_PARENT"));
			}

			List results = fetchResults();
			if (((results.size() > 0) && (optionLabel == null)) || (optionValue == null))
			{
				generateDefaultValues(results.get(0));
			}

			for (Iterator iter = results.iterator(); iter.hasNext();)
			{
				Object resultRow = iter.next();
				Option option = createNameValuePair(resultRow);
				parent.addOption(option);
			}
		}
		catch (MissingResourceException e)
		{
			throw new JspException("Exception in OptionCollectionTag", e);
		}
		catch (CheckedCharmException e)
		{
			throw new JspException("Exception in OptionCollectionTag", e);
		}

		return super.doEndTag();
	}
	
	
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
					optionLabel = DEFAULT_LABEL_PROPS[i];
				}
			}
			for (int i = 0; i < DEFAULT_VALUE_PROPS.length; i++)
			{
				if (keys.contains(DEFAULT_VALUE_PROPS[i]))
				{
					optionValue = DEFAULT_VALUE_PROPS[i];
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
					optionLabel = DEFAULT_LABEL_PROPS[i];
				}
			}
			for (int i = 0; i < DEFAULT_VALUE_PROPS.length; i++)
			{
				if (bw.isReadableProperty(DEFAULT_VALUE_PROPS[i]))
				{
					optionValue = DEFAULT_VALUE_PROPS[i];
				}
			}
		}
		if ((optionLabel == null) || (optionValue == null))
		{
			throw new CharmException("optionLabel and optionValue were not specified, and could not be determined from the query results");
		}
	}

	public void init() throws Exception
	{
		logger.debug("init()");

		// must clear out any parameters from previous invocations
		if (paramHelper != null)
		{
			paramHelper.release();
		}
		paramHelper = new ParamHelper();
	}

	public void release()
	{
		logger.debug("release()");
		if (paramHelper != null)
		{
			paramHelper.release();
		}
		paramHelper = null;
	}

	private List fetchResults() throws CheckedCharmException
	{
		if (logger.isInfoEnabled())
		{
			logger.info(ArrayUtils.toString(paramsToNameArray(), "parameterNames"));
			logger.info(ArrayUtils.toString(paramsToValueArray(), "parameterValues"));
		}

		if ((collection != null) && (collection instanceof Collection))
		{
			List result = new ArrayList();
			result.addAll((Collection) collection);
			return result;
		}
		else if (StringUtils.isNotBlank(namedQueryId))
		{
			QueryService queryService = getQueryServiceInstance();
			return queryService.namedQueryForList(namedQueryId, paramsToNameArray(), paramsToValueArray());
		}
		else if (query != null)
		{
			DataService service = getDataServiceInstance();
			return service.queryForList(query, paramsToNameArray(), paramsToValueArray(), paramsToTypeArray());
		}
		else
		{
			return new ArrayList();
		}
	}

	public Option createNameValuePair(Object resultRow)
	{
		Option result = new Option();
		if (resultRow instanceof Map)
		{
			result.setName(convertToString(((Map) resultRow).get(optionLabel)));
			result.setValue(convertToString(((Map) resultRow).get(optionValue)));
		}
		else
		{
			BeanWrapperImpl bw = new BeanWrapperImpl(resultRow);
			result.setName(convertToString(bw.getPropertyValue(optionLabel)));
			result.setValue(convertToString(bw.getPropertyValue(optionValue)));
		}
		return result;
	}

	private String convertToString(Object o)
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

	public void addParameter(String name, Object value)
	{
		logger.debug("Adding parameter:" + name + " = " + value);
		paramHelper.addParameter(name, value);
	}

	public Iterator getParameterNames()
	{
		return paramHelper.getParameterNames();
	}

	public Object getParameterValue(String name)
	{
		return paramHelper.getParameterValue(name);
	}

	public Object[] paramsToValueArray()
	{
		return paramHelper.toValueArray();
	}

	public String[] paramsToNameArray()
	{
		return paramHelper.toNameArray();
	}

	public int[] paramsToTypeArray()
	{
		return paramHelper.toTypeArray();
	}

	public int getNumberParameters()
	{
		return paramHelper.getNumberParameters();
	}

	public ParamHelper getParamHelper()
	{
		return paramHelper;
	}

	public void setParamHelper(ParamHelper paramHelper)
	{
		this.paramHelper = paramHelper;
	}

	/**
	 * Getter for property optionLabel.
	 * 
	 * @return Value of property optionLabel.
	 * @jsp.attribute required="false" rtexprvalue="true" description="The
	 *                property to be used for the display of the tag"
	 */
	public String getOptionLabel()
	{
		return optionLabel;
	}

	public void setOptionLabel(String optionLabel)
	{
		this.optionLabel = optionLabel;
	}

	/**
	 * Getter for property optionValue.
	 * 
	 * @return Value of property optionValue.
	 * @jsp.attribute required="false" rtexprvalue="true" description="The
	 *                property to be used to get the value of the tag"
	 */
	public String getOptionValue()
	{
		return optionValue;
	}

	public void setOptionValue(String optionValue)
	{
		this.optionValue = optionValue;
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
