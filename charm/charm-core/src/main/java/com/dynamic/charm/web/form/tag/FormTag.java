/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: FormTag.java 359 2008-11-20 15:28:11Z bvonhaden $

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

import javax.servlet.jsp.JspException;

import org.apache.log4j.Logger;

import com.dynamic.charm.exception.CharmException;
import com.dynamic.charm.web.builder.FormElement;
import com.dynamic.charm.web.builder.HTMLElement;
import com.dynamic.charm.web.form.CharmDataBinder;
import com.dynamic.charm.web.form.Field;
import com.dynamic.charm.web.form.FormModel;
import com.dynamic.charm.web.form.FormService;
import com.dynamic.charm.web.form.FormUtils;
import com.dynamic.charm.web.tag.TagDefaults;
import com.dynamic.charm.web.tag.support.EvalTool;


/**
 * The Charm Form tag supports editing of a record.
 * 
 * @jsp.tag name="form" display-name="Charm Form" body-content="JSP" dynamic-attributes="true"
 *
 * @author gcase
 */
public class FormTag extends BaseTag implements FieldParent
{
    private final static Logger logger = Logger.getLogger(FormTag.class);
    private final static boolean MODEL_IN_SESSION = false;

    public final static String DIGEST_PARAM = "cpua_id";
    public final static String ATTRIBUTE_MODE = FormTag.class.getName() + ".mode";
    public final static String MODE_UPDATE = "update";
    public final static String MODE_INSERT = "insert";
    public final static String FORM_NAME_PARAM = "_fname";

    static
    {
        TagDefaults.getInstance().registerDefault(FormTag.class, "method", "post");
        TagDefaults.getInstance().registerDefault(FormTag.class, "action", "form.go");
    }

    private String action;
    private String method;
    private String name;
    private String formView;
    private String successView;
    private String cancelView;
    private String fieldDecorator;
    private String enctype;
    private String postProcessor;
    private String preProcessor;
    private String forwardParameterList;
    private String forwardParametersExpr;
    private boolean forwardParameters;
    private String forwardBoundFieldAsParameterList;
    
    private FormModel _model;
    private FormElement _formElement;

    

    protected void evaluateExpresssions(EvalTool evalTool) throws JspException
    {
        super.evaluateExpresssions(evalTool);
        action = evalTool.evaluateAsString("action", action);
        method = evalTool.evaluateAsString("method", method);
        name = evalTool.evaluateAsString("name", name);
        formView = evalTool.evaluateAsString("formView", formView);
        successView = evalTool.evaluateAsString("successView", successView);
        cancelView = evalTool.evaluateAsString("cancelView", cancelView);
        fieldDecorator = evalTool.evaluateAsString("fieldDecorator", fieldDecorator);
        enctype = evalTool.evaluateAsString("enctype", enctype);
        postProcessor = evalTool.evaluateAsString("postProcessor", postProcessor);
		preProcessor = evalTool.evaluateAsString("preProcessor", preProcessor);
		forwardParameterList = evalTool.evaluateAsString("forwardParameterList", forwardParameterList);
		forwardParameters = evalTool.evaluateAsBoolean("forwardParameters", forwardParametersExpr, true);
		forwardBoundFieldAsParameterList = evalTool.evaluateAsString("forwardBoundFieldAsParameterList", forwardBoundFieldAsParameterList);
    }

    public int doStartTagInternal() throws JspException
    {
        logger.debug("doStartTagInternal()");
        TagDefaults.getInstance().setAllDefaults(this);
        refreshModel();

        _formElement = HTMLElement.createRootElement().createFormElement(name, method);
        _formElement.id(name);
        _formElement.action(action);
        _formElement.encType(enctype);
        _formElement.style(style);
        _formElement.css(css);

        //hidden tag is necessary so button can communicate what action to execute
        _formElement.createInputElementHidden(ButtonTag.FORM_SUBMIT_PARAM, "");

        //create a hidden tag for the form name (so we now how to get the formModel out of session later)
        _formElement.createInputElementHidden(FormTag.FORM_NAME_PARAM, name);

        //need to decide how to best do this, should we always mirror the incoming parameters??
        //              Iterator iter = getRequest().getParameterMap().keySet().iterator();
        //              while (iter.hasNext())
        //              {
        //                      String paramName = (String) iter.next();
        //                      String paramValue = getRequest().getParameter(paramName);
        //                      formElement.createInputElementHidden(paramName, paramValue);
        //              }

        // strip off the final </form>
        String formText = _formElement.evaluate();
        formText = formText.substring(0, formText.length() - "</form>".length());
        write(formText);

        return EVAL_BODY_INCLUDE;
    }

    public void refreshModel()
    {
        _model = FormUtils.getFormModelFromSession(getRequest(), name);
        if ((_model == null) || !MODEL_IN_SESSION)
        {
            logger.info("Creating a new form model");
            _model = new FormModel();

            _model.setFormName(name);
            _model.setFormView(formView);
            _model.setSuccessView(successView);
            _model.setCancelView(cancelView);
            _model.setPreProcessor(preProcessor);
            _model.setPostProcessor(postProcessor);
            _model.setForwardParameters(forwardParameters);
            _model.setForwardParameterList(forwardParameterList);
            _model.setForwardBoundFieldAsParameterList(forwardBoundFieldAsParameterList);
        }
        else
        {
            logger.info("Loading model from session");
        }

        // always do this put the form in the session
        FormUtils.placeFormInSession(_model, getRequest());
    }

    public int doEndTagInternal()
    {
        logger.debug("doEndTag()");

        HTMLElement element = HTMLElement.createRootElement();
        element.createInputElementHidden(DIGEST_PARAM, _model.createDigest());
        write(element.evaluateChildren());

        //              setMandatoryFields();
        write("</form>");
        return EVAL_PAGE;
    }

    /**
     * Getter for property action.
     *
     * @return Value of property action.
     * @jsp.attribute required="true" rtexprvalue="true" description="The
     *                action"
     */
    public String getAction()
    {
        return action;
    }

    public void setAction(String action)
    {
        this.action = action;
    }

    /**
     * Getter for property method.
     *
     * @return Value of property method.
     * @jsp.attribute required="false" rtexprvalue="false" description="The
     *                method, defaults to POST"
     */
    public String getMethod()
    {
        return method;
    }

    public void setMethod(String method)
    {
        this.method = method;
    }

    /**
     * Getter for property name.
     *
     * @return Value of property name.
     * @jsp.attribute required="true" rtexprvalue="true" description="The name"
     */
    public String getName()
    {
        return name;
    }

    public void setName(String name)
    {
        this.name = name;
    }

    public void addField(Field field)
    {
        FormService service = getFormService();
        CharmDataBinder binder = _model.getCharmDataBinder(field.getBindName());
        if (binder == null)
        {
            throw new CharmException("Unrecognized bind name:" + field.getBindName());
        }

        Object bound = binder.getTarget();
        String[] mandatories = service.getRequiredFields(binder.getTargetClass().getName());

        boolean isMandatory = false;
        String property = field.getProperty().toLowerCase();
        for (int i = 0; i < mandatories.length; i++)
        {
            if (property.equals(mandatories[i].toLowerCase()))
            {
                isMandatory = true;
                break;
            }
        }

        if (field.getMandatoryStatus() == Field.MANDATORY_UNKNOWN)
        {
            field.setMandatory(isMandatory);
            logger.info("Field tag did not specify mandatory for " + field.getProperty() + ", setting mandatory = " + field.isMandatory());
        }
        else if ((field.getMandatoryStatus() == Field.MANDATORY_NO) && isMandatory)
        {
            field.setMandatory(isMandatory);
            logger.info("Overriding field tag for " + field.getProperty() + " , setting mandatory = " + field.isMandatory());
        }
        else if ((field.getMandatoryStatus() == Field.MANDATORY_YES) && !isMandatory)
        {
            logger.info("Accepting field tag for " + field.getProperty() + ", leaving mandatory = " + field.isMandatory());
        }

        if (field.isMandatory())
        {
            binder.addRequiredField(field.getProperty());
        }

        _model.addField(field);
    }

    public FormModel getFormModel()
    {
        return _model;
    }

    public HTMLElement getFormElement()
    {
        return _formElement;
    }

    /**
     * Getter for property cancelView.
     *
     * @return Value of property cancelView.
     * @jsp.attribute required="false" rtexprvalue="true" description="The view
     *                used after cancelling the form"
     */
    public String getCancelView()
    {
        return cancelView;
    }

    public void setCancelView(String cancelView)
    {
        this.cancelView = cancelView;
    }

    /**
     * Getter for property formView.
     *
     * @return Value of property formView.
     * @jsp.attribute required="true" rtexprvalue="true" description="The view
     *                used to display the form"
     */
    public String getFormView()
    {
        return formView;
    }

    public void setFormView(String formView)
    {
        this.formView = formView;
    }

    /**
     * Getter for property successView.
     *
     * @return Value of property successView.
     * @jsp.attribute required="true" rtexprvalue="true" description="The view
     *                to be used after a successfull form submission"
     */
    public String getSuccessView()
    {
        return successView;
    }

    public void setSuccessView(String successView)
    {
        this.successView = successView;
    }

    /**
     * Getter for property fieldDecorator.
     *
     * @return Value of property fieldDecorator.
     * @jsp.attribute required="false" rtexprvalue="true" description="The
     *                decorator object that should be used for the fields"
     */
    public String getFieldDecorator()
    {
        return fieldDecorator;
    }

    public void setFieldDecorator(String fieldDecorator)
    {
        this.fieldDecorator = fieldDecorator;
    }

    /**
     * Getter for property enctype.
     *
     * @return Value of property enctype.
     * @jsp.attribute required="false" rtexprvalue="true" description="The
     *                encoding type for the form. multipart/form-data or none."
     */
    public String getEnctype()
    {
        return enctype;
    }

    public void setEnctype(String enctype)
    {
        this.enctype = enctype;
    }

    /**
     * Getter for property postProcessor.
     *
     * @return Value of property postProcessor.
     * @jsp.attribute required="false" rtexprvalue="true" description="The postProcessor that should
     *  be run after all other processors.  This can either be the fully qualified classname,
     *  or the name of the bean defined in Spring."
     */
	public String getPostProcessor()
	{
		return postProcessor;
	}

	public void setPostProcessor(String postProcessor)
	{
		this.postProcessor = postProcessor;
	}

	/**
     * Getter for property preProcessor.
     *
     * @return Value of property preProcessor.
     * @jsp.attribute required="false" rtexprvalue="true" description="The preProcessor that should
     *  be run before all other processors.  This can either be the fully qualified classname,
     *  or the name of the bean defined in Spring."
     */
	public String getPreProcessor()
	{
		return preProcessor;
	}

	public void setPreProcessor(String preProcessor)
	{
		this.preProcessor = preProcessor;
	}

	/**
	 * Getter for property forwardParameterList.
	 *
	 * @return Value of property forwardParameterList
	 * @jsp.attribute required="false" rtexprvalue="true" description="The list of parameters that 
	 * should be forwarded on a successful redirect to the next page.  If none is specified then
	 * all parameters are forwarded"
	 */
	public String getForwardParameterList()
	{
		return forwardParameterList;
	}

	public void setForwardParameterList(String forwardParameters)
	{
		this.forwardParameterList = forwardParameters;
	}

	/**
	 * Getter for property forwardParameters.
	 *
	 * @return Value of property forwardParameters
	 * @jsp.attribute required="false" rtexprvalue="true" type="boolean"
	 * description="true if the parameters should be forwarded according to
	 * the forwardParameterList on the success redirect.  Default value is TRUE"
	 */
	public String getForwardParameters()
	{
		return forwardParametersExpr;
	}

	public void setForwardParameters(String forwardParameters)
	{
		this.forwardParametersExpr = forwardParameters;
	}

	/**
	 * Get the property for the forwardBoundFieldAsParameterList. 
	 * 
	 * @return Returns the forwardBoundFieldAsParameterList.
	 * @jsp.attribute required="false" rtexprvalue="true"
	 * description="a list of fields that should be forwarded as
	 * parameters on the success redirect.  Default value is empty"
	 */
	public String getForwardBoundFieldAsParameterList()
	{
		return forwardBoundFieldAsParameterList;
	}

	/**
	 * @param forwardBoundFieldAsParameterList The forwardBoundFieldAsParameterList to set.
	 */
	public void setForwardBoundFieldAsParameterList(String forwardBoundFieldAsParameterList)
	{
		this.forwardBoundFieldAsParameterList = forwardBoundFieldAsParameterList;
	}


}
