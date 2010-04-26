package com.dynamic.charm.web.controller;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.BeanCreationException;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.core.Ordered;
import org.springframework.web.servlet.HandlerExceptionResolver;
import org.springframework.web.servlet.ModelAndView;

import com.dynamic.charm.exception.ExceptionUtils;

/**
 * @author gcase
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class CharmExceptionHandler implements HandlerExceptionResolver, Ordered, InitializingBean
{

    private int order;
    private String view;
    
    /* (non-Javadoc)
     * @see org.springframework.beans.factory.InitializingBean#afterPropertiesSet()
     */
    public void afterPropertiesSet() throws BeanCreationException
    {
        if (view == null)
        {
            throw new BeanCreationException("view is required for [" + this.getClass().getName() + "]");
        }
           
    }
    public ModelAndView resolveException(HttpServletRequest request, HttpServletResponse response, Object handler, Exception e)
    {
        if (true)
        {
            ModelAndView result = new ModelAndView(view);
            result.addObject("exception", e);
            result.addObject("stacktrace", ExceptionUtils.formatStackTrace(e));
            result.addObject("properties", System.getProperties());
            return result;
        }
        else
        {
            return null;
        }
    }

    /**
     * @return Returns the order.
     */
    public int getOrder()
    {
        return order;
    }

    /**
     * @param order
     *            The order to set.
     */
    public void setOrder(int order)
    {
        this.order = order;
    }

    /**
     * @return Returns the view.
     */
    public String getView()
    {
        return view;
    }

    /**
     * @param view
     *            The view to set.
     */
    public void setView(String view)
    {
        this.view = view;
    }



}
