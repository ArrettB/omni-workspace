/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: FormController.java 360 2008-11-21 14:45:27Z john.cicchese $

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


package com.dynamic.charm.web.form.controller;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.MethodUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.ModelAndViewDefiningException;
import org.springframework.web.servlet.mvc.Controller;
import org.springframework.web.servlet.view.RedirectView;

import com.dynamic.charm.common.ArrayUtils;
import com.dynamic.charm.common.ClassUtils;
import com.dynamic.charm.common.Constants;
import com.dynamic.charm.common.StringUtils;
import com.dynamic.charm.io.UploadedFile;
import com.dynamic.charm.web.builder.HrefBuilder;
import com.dynamic.charm.web.controller.BaseController;
import com.dynamic.charm.web.form.CharmDataBinder;
import com.dynamic.charm.web.form.FormModel;
import com.dynamic.charm.web.form.FormUtils;
import com.dynamic.charm.web.form.tag.FormTag;

/**
 * The Charm Form Controller is used with the charm:form tag.
 * It handles the display, updating, or deleting of values with a charm:form.
 * 
 * @version $Header$
 */
public class FormController extends BaseController implements Controller, InitializingBean
{
    private final static Class[] executeArgTypes = new Class[]
        {
            FormModel.class, HttpServletRequest.class, HttpServletResponse.class
        };

    private final static Logger logger = Logger.getLogger(FormController.class);
    private String invalidFormView;
    private List processorList;

    public void registerRequiredProperties()
    {
        registerRequiredProperty("processorList");
        registerRequiredProperty("invalidFormView");
    }

	public void afterPropertiesSetInternal()
	{
	}

    public Map createErrorsModel(FormModel model)
    {
        Map result = new HashMap();
        Iterator iter = model.getBindNames();
        while (iter.hasNext())
        {
            String bindName = (String) iter.next();
            CharmDataBinder binder = model.getCharmDataBinder(bindName);
            Map errors = binder.getBindingResult().getModel();
            result.putAll(errors);
        }
        return result;
    }

    protected boolean shouldPerformBindings(HttpServletRequest request,
        HttpServletResponse response)
    {
        return !FormUtils.isDelete(request) && !FormUtils.isDelete(request);
    }

    protected boolean shouldPerformValidation(HttpServletRequest request,
        HttpServletResponse response)
    {
        return !FormUtils.isDelete(request) && !FormUtils.isDelete(request);
    }

    protected boolean isFormAuthentic(HttpServletRequest request, HttpServletResponse response)
    {
        FormModel model = FormUtils.getFormModelFromSession(request);
        String digest = request.getParameter(FormTag.DIGEST_PARAM);
        String modelDigest = model.createDigest();
        return modelDigest.equals(digest);
    }

    protected ModelAndView handleRequestInternal(HttpServletRequest request,
        HttpServletResponse response) throws Exception
    {
        FormModel model = FormUtils.getFormModelFromSession(request);
        String submitType = FormUtils.getSubmitType(request);
        if (model == null)
        {
            return handleInvalidFormSubmission("The model could not be found.", request, response);
        }
        else if (!StringUtils.isNotBlank(submitType))
        {
            return handleInvalidFormSubmission("Could not determine the submit operation.", request,
                    response);
        }
        else if (!isFormAuthentic(request, response))
        {
            return handleInvalidFormSubmission("You are being a bad haxxor.", request, response);
        }
        else if (FormUtils.isCancel(request))
        {
            return handleCancel(model, request, response);
        }
        else
        {
        	try 
        	{
	            extractFiles(request);
	
	            FormProcessor preProcessor = instantiateProcessor(model.getPreProcessor());
	            FormProcessor postProcessor = instantiateProcessor(model.getPostProcessor());
	
	            List invokedProcessors = new ArrayList();
	
	            //not sure if addAll makes any guarantee on order, so lets add them manually
	            if (preProcessor != null)
	            {
	                logger.info("preProcessor found: " + preProcessor);
	                invokedProcessors.add(preProcessor);
	            }
	            for (Iterator iter = processorList.iterator(); iter.hasNext();)
	            {
	                invokedProcessors.add(iter.next());
	            }
	            if (postProcessor != null)
	            {
	                logger.info("postProcessor found: " + postProcessor);
	                invokedProcessors.add(postProcessor);
	            }
	
	            // transform our list into an array of processors for easier iteration
	            FormProcessor[] formProcessors = (FormProcessor[]) ArrayUtils.toArray(invokedProcessors, FormProcessor.class);
	
	            if (shouldPerformBindings(request, response))
	            {
	                performRequestBindings(model, request, response, formProcessors);
	            }
	
	            if (shouldPerformValidation(request, response))
	            {
	                validate(model, request, response, formProcessors);
	            }
	
	            if (model.hasErrors())
	            {
	                onShowForm(model, request, response, formProcessors);
	
	                Map errorsModel = createErrorsModel(model);
	                ModelAndView resultModel = new ModelAndView(model.getFormView(), errorsModel);
	                return resultModel;
	            }
	            else
	            {
	                ModelAndView executionResult = executeHandleMethods(model, request, response,
	                        formProcessors);
	                if (executionResult != null)
	                {
	                    return executionResult;
	                }
	                else if (model.hasErrors()) //need to check again for errors after execute methods have run
	                {
	                    onShowForm(model, request, response, formProcessors);
	
	                    Map errorsModel = createErrorsModel(model);
	                    ModelAndView resultModel = new ModelAndView(model.getFormView(), errorsModel);
	                    return resultModel;
	                }
	                else
	                {
	                    return handleSuccess(request, response, model);
	                }
	            }

	        }
        	catch (ModelAndViewDefiningException e) 
        	{
	        	return e.getModelAndView();
	        }
        }
    }

    private void extractFiles(HttpServletRequest request) throws IOException
    {
        if (request instanceof MultipartHttpServletRequest)
        {
            MultipartHttpServletRequest multi = (MultipartHttpServletRequest) request;
            MultipartFile file = null;
            UploadedFile uppedFile = null;

            List files = new ArrayList();

            Iterator uppedFiles = multi.getFileMap().values().iterator();
            while (uppedFiles.hasNext())
            {
                file = (MultipartFile) uppedFiles.next();
                uppedFile = new UploadedFile();
                uppedFile.setAttributeName(file.getName());
                uppedFile.setFileName(file.getOriginalFilename());
                uppedFile.setBytes(file.getBytes());

                if (file.getOriginalFilename() != null && file.getOriginalFilename().length() > 0)
                	files.add(uppedFile);
            }

            //try and make files available
            request.setAttribute(Constants.UPLOADED_FILES, files);
        }
    }

    protected ModelAndView executeHandleMethods(FormModel model, HttpServletRequest request,
        HttpServletResponse response, FormProcessor[] formProcessors)
        throws IllegalArgumentException, IllegalAccessException, InvocationTargetException
    {
        logger.debug("executeHandleMethods()");

        ModelAndView result = null;

        if (result == null)
        {
            for (int i = 0; i < formProcessors.length; i++)
            {
                result = executeHandleMethod(formProcessors[i], model, request, response);
                if (result != null)
                {
                    break;
                }
            }
        }

        return result;
    }

    protected ModelAndView executeHandleMethod(FormProcessor processor, FormModel model,
        HttpServletRequest request, HttpServletResponse response) throws IllegalArgumentException,
        IllegalAccessException, InvocationTargetException
    {
        logger.debug("executeHandleMethod()");

        String submitType = FormUtils.getSubmitType(request);
        submitType = StringUtils.capitalize(submitType);

        String methodName = "handle" + submitType;

        logger.debug("Looking for method " + methodName + " on " + processor.getClass().getName());

        Method executeMe = MethodUtils.getAccessibleMethod(processor.getClass(), methodName, executeArgTypes);
        if (executeMe != null)
        {
            logger.debug("Executing " + methodName + " on " + processor.getClass().getName());

            Object result = executeMe.invoke(processor, new Object[]
                    {
                        model, request, response
                    });
            if ((result != null) && (result instanceof ModelAndView))
            {
                return (ModelAndView) result;
            }
            else
            {
                return null;
            }
        }
        return null;
    }

    public void performRequestBindings(FormModel model, HttpServletRequest request,
        HttpServletResponse response, FormProcessor[] formProcessors)
    {
        logger.debug("performRequestBindings()");

        Iterator iter = model.getBindNames();
        while (iter.hasNext())
        {
            String bindName = (String) iter.next();
            CharmDataBinder binder = model.getCharmDataBinder(bindName);
            binder.bind(request);
        }

        // allow processors to do their thing
        // processors should interact with the model directly, rather than
        // setting request parameters
        for (int i = 0; i < formProcessors.length; i++)
        {
            formProcessors[i].performRequestBindings(model, request, response);
        }
    }

    public void onShowForm(FormModel model, HttpServletRequest request,
        HttpServletResponse response, FormProcessor[] formProcessors) throws ModelAndViewDefiningException
    {
        logger.debug("onShowForm()");

        //copy parameters
        for (int i = 0; i < formProcessors.length; i++)
        {
            formProcessors[i].onShowForm(model, request, response);
        }

    }

    public void validate(FormModel model, HttpServletRequest request, HttpServletResponse response,
        FormProcessor[] formProcessors)
    {
        logger.debug("validate()");
        for (int i = 0; i < formProcessors.length; i++)
        {
            if (!formProcessors[i].validate(model, request, response))
            {
                break;
            }
        }
    }

    /**
     * For a valid form submission we remove the formModel from session
     * and then perform a redirect to the success view specified
     * in the form model. The redirect is to avoid duplicate submissions.
     * 
     * @param request
     * @param response
     * @param model
     * @return the success model and view.
     */
	protected ModelAndView handleSuccess(HttpServletRequest request, HttpServletResponse response, FormModel model)
	{
		// remove previous form model
		FormUtils.removeFormsFromSession(request);

		ModelAndView result = null;

		if (model.getSuccessView() == null)
		{
			result = new ModelAndView();
		}
		else
		{
			String path = request.getContextPath() + "/";
			HrefBuilder successHref = new HrefBuilder(path + model.getSuccessView() + ".html");
			
			// optionally forward fields values as parameters.
			Iterator fieldNames = FormUtils.getForwardFieldsAsParameterNames(model).iterator();
			while (fieldNames.hasNext())
			{
				String fieldName = (String) fieldNames.next();
				successHref.addParameter(model.getBoundPropertyName(fieldName), 
						model.getBoundValue(fieldName));
			}
			
			// optionally forward parameters.
			Iterator parameterNames = FormUtils.getForwardParameterNames(request, model);
			while (parameterNames.hasNext())
			{
				String paramName = (String) parameterNames.next();
				successHref.addParameter(paramName, request.getParameter(paramName));
			}

			RedirectView redirect = new RedirectView(successHref.evaluate());
			result = new ModelAndView(redirect);
		}

		return result;
	}

    protected ModelAndView handleInvalidFormSubmission(String reason, HttpServletRequest request,
        HttpServletResponse response)
    {
        // remove previous form model
        FormUtils.removeFormsFromSession(request);
        logger.error(reason);
        return new ModelAndView(invalidFormView, "reason", "Sorry, the server encountered an error. Please try again.");
    }

    protected ModelAndView handleCancel(FormModel model, HttpServletRequest request,
        HttpServletResponse response)
    {
        FormUtils.removeFormsFromSession(request);

        String cancelView = model.getCancelView();
        if (!StringUtils.isNotBlank(cancelView))
        {
            logger.info("cancelView not specified, defaulting to successView");
            cancelView = model.getSuccessView();
        }
        return new ModelAndView(cancelView);
    }

    public String getInvalidFormView()
    {
        return invalidFormView;
    }

    public void setInvalidFormView(String invalidFormView)
    {
        this.invalidFormView = invalidFormView;
    }

    public List getProcessorList()
    {
        return processorList;
    }

    public void setProcessorList(List processorList)
    {
        this.processorList = processorList;
    }

    private FormProcessor instantiateProcessor(String processorName)
    {
        //first check to see if there is a bean defined
        if (StringUtils.isBlank(processorName))
        {
            return null;
        }

        FormProcessor result = (FormProcessor) getBean(processorName, FormProcessor.class);
        if (result == null)
        {
            return (FormProcessor) ClassUtils.instantiate(processorName);
        }

        return result;
    }
}
