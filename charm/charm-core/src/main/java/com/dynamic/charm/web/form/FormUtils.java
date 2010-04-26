/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: FormUtils.java 359 2008-11-20 15:28:11Z bvonhaden $

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


package com.dynamic.charm.web.form;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.collections.IteratorUtils;
import org.apache.log4j.Logger;

import com.dynamic.charm.exception.ParameterMissingException;
import com.dynamic.charm.web.RequestUtils;
import com.dynamic.charm.web.form.tag.ButtonTag;
import com.dynamic.charm.web.form.tag.FormTag;

/**
 * Utilities for the Charm Form.
 * 
 * @version $Id: FormUtils.java 359 2008-11-20 15:28:11Z bvonhaden $
 */
public class FormUtils
{
    private final static Logger logger = Logger.getLogger(FormUtils.class);

    public static String getFormName(HttpServletRequest request)
    {
        try
        {
            return RequestUtils.getRequiredStringParameter(request, FormTag.FORM_NAME_PARAM);
        }
        catch (ParameterMissingException e)
        {
            logger.warn("Could not find form name as a request parameter", e);
            return null;
        }
    }

    public static FormModel getFormModelFromSession(HttpServletRequest request)
    {
        String formName = getFormName(request);
        return getFormModelFromSession(request, formName);
    }

    public static FormModel getFormModelFromSession(HttpServletRequest request, String formName)
    {
        String attributeName = getFormModelSessionAttributeName(formName);
        return (FormModel) request.getSession().getAttribute(attributeName);
    }

    public static String getFormModelSessionAttributeName(String formName)
    {
        return FormTag.class.getName() + "." + formName;
    }

    public static void placeFormInSession(FormModel model, HttpServletRequest request)
    {
        String attributeName = getFormModelSessionAttributeName(model.getFormName());
        logger.info("Placing FormModel into session:" + attributeName);
        request.getSession().setAttribute(attributeName, model);
    }

    /**
     * This method removes ALL the FormModels from session, there is no reason to keep any of them
     * after any of them are processed.
     *
     */
    public static void removeFormsFromSession(HttpServletRequest request)
    {
        HttpSession session = request.getSession();
        //needs to be put in a separate list to avoid concurrent modification exce
        List toBeRemoved = new ArrayList();
        Iterator iter = IteratorUtils.asIterator(session.getAttributeNames());
        while (iter.hasNext())
        {
            String attributeName = (String) iter.next();
            if (attributeName.startsWith(FormTag.class.getName() + "."))
            {
            	toBeRemoved.add(attributeName);
            }
        }
        
        for (Iterator iter2 = toBeRemoved.iterator(); iter2.hasNext();)
		{
        	String attributeName = (String) iter2.next();
        	session.removeAttribute(attributeName);
		}
    }

    public static String getSubmitType(HttpServletRequest request)
    {
        try
        {
            return RequestUtils.getRequiredStringParameter(request, ButtonTag.FORM_SUBMIT_PARAM);
        }
        catch (ParameterMissingException e)
        {
            logger.warn("Could not find submit type as a request parameter", e);
            return null;
        }
    }

    /**
     * 
     * @param request
     * @return true if this is a cancel operation.
     */
    public static boolean isCancel(HttpServletRequest request)
    {
        return ButtonTag.FORM_CANCEL_BUTTON.equalsIgnoreCase(getSubmitType(request));
    }

    /**
     * 
     * @param request
     * @return true if this is a delete operation
     */
    public static boolean isDelete(HttpServletRequest request)
    {
        return ButtonTag.FORM_DELETE_BUTTON.equalsIgnoreCase(getSubmitType(request));
    }

    /**
     * 
     * @param request
     * @return true if this is a save operation.
     */
    public static boolean isSave(HttpServletRequest request)
    {
        return ButtonTag.FORM_SAVE_BUTTON.equalsIgnoreCase(getSubmitType(request));
    }
    
    /**
     * Get the list of parameter names to forward.
     * 
     * @param request
     * @param model
     * @return the list of parameters that need to be forwarded.
     */
	public static Iterator getForwardParameterNames(HttpServletRequest request, FormModel model)
	{
		List result = new ArrayList();
		if (model.isForwardParameters())
		{
			String fwd = model.getForwardParameterList();
			if (fwd != null)
			{
				String[] fwdList = fwd.split(",");
				for (int i = 0; i < fwdList.length; i++ )
				{
					result.add(fwdList[i]);
				}
			}
			else
			{
				result.addAll(request.getParameterMap().keySet());
			}
		}
		
		return result.iterator();
	}

	/**
	 * Get a list of the field names that should be forwarded.
	 * 
	 * @param request
	 * @param model
	 * @return the list of fields to be forwarded.
	 */
	public static List getForwardFieldsAsParameterNames(FormModel model)
	{
		List result = new ArrayList();

		String fwd = model.getForwardBoundFieldAsParameterList();
		if (fwd != null)
		{
			String[] fwdList = fwd.split(",");
			for (int i = 0; i < fwdList.length; i++ )
			{
				result.add(fwdList[i]);
			}
		}
		
		return result;
	}
}
