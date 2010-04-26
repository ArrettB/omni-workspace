/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: HibernateProcessor.java 270 2007-08-23 01:21:07Z bvonhaden $

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

import java.util.Iterator;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.web.servlet.ModelAndView;

import com.dynamic.charm.query.hibernate.HibernateService;
import com.dynamic.charm.web.form.FormModel;


public class HibernateProcessor extends AbstractProcessor implements FormProcessor, InitializingBean
{
    private final static Logger logger = Logger.getLogger(HibernateProcessor.class);
    private HibernateService hibernateService;

    public void registerRequiredProperties()
    {
        registerRequiredProperty("hibernateService");
    }

	public void afterPropertiesSetInternal()
	{
	}
    
    public ModelAndView handleSave(FormModel model, HttpServletRequest request,
        HttpServletResponse response)
    {
        logger.debug("handleSave()");

        Iterator iter = model.getBindNames();
        while (iter.hasNext())
        {
            String bindName = (String) iter.next();
            Object bound = model.getBoundObject(bindName);
            Class targetClass = model.getCharmDataBinder(bindName).getTargetClass();
            if (hibernateService.supports(targetClass))
            {
                try
                {
                    logger.info("Merging: " + bound);
                    Object merged = hibernateService.merge(bound);
                    logger.info("Persisting: " + merged);
                    hibernateService.saveOrUpdate(merged);
  
                    BeanUtils.copyProperties(merged, bound);
                    //changed back to this version- running into some trouble with item by item approach.
//                    model.getCharmDataBinder(bindName).getBeanWrapper().setWrappedInstance(bound);
                    //need to copy values from the saved object back to the one in the form model
                    //could probably just call setWrappedInstance() on the beanWrapper, but lets copy
                    //each property instead
                    
//                    BeanWrapper bwMerged = new BeanWrapperImpl(merged);
//                    BeanWrapper bwModel = model.getCharmDataBinder(bindName).getBeanWrapper();
//                    
//                    PropertyDescriptor[] pd = bwMerged.getPropertyDescriptors();
//                    for (int i = 0; i < pd.length; i++)
//					{
//						String propName = pd[i].getName();
//						if (bwModel.isWritableProperty(propName))
//						{
//							bwModel.setPropertyValue(propName, bwMerged.getPropertyValue(propName));
//						}
//					}

                }
                catch (DataIntegrityViolationException e)
                {
                    addError(model, bindName, "com.dynamic.charm.web.form.controller.HibernateProcessor.DataIntegrityViolationException.message", e.getMessage());
                }
            }
            else
            {
            	logger.warn("Hibernate service does not support target class " + targetClass.getName());
            }
        }

        return null;
    }

    public ModelAndView handleDelete(FormModel model, HttpServletRequest request,
        HttpServletResponse response)
    {
        logger.debug("handleDelete()");

        Iterator iter = model.getBindNames();
        while (iter.hasNext())
        {
            String bindName = (String) iter.next();
            Object bound = model.getBoundObject(bindName);
            if (hibernateService.supports(bound.getClass()))
            {
                try
                {
                    logger.info("Merging: " + bound);
                    bound = hibernateService.merge(bound);
                    logger.info("Deleting: " + bound);
                    hibernateService.delete(bound);
                }
                catch (DataIntegrityViolationException e)
                {
                    addError(model, bindName,
                        "com.dynamic.charm.web.form.controller.HibernateProcessor.constraintViolation.message",
                        "The row can not be deleted, it is referenced elsewhere.");
                }
            }
        }

        return null;
    }

    public boolean validate(FormModel model, HttpServletRequest request,
        HttpServletResponse response)
    {
        return true;
    }

    public void onShowForm(FormModel model, HttpServletRequest request,
        HttpServletResponse response)
    {
    }

    public void performRequestBindings(FormModel model, HttpServletRequest request,
        HttpServletResponse response)
    {
    }

    public HibernateService getHibernateService()
    {
        return hibernateService;
    }

    public void setHibernateService(HibernateService hibernateService)
    {
        this.hibernateService = hibernateService;
    }

}
