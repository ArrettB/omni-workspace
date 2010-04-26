/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: FormProcessor.java 199 2006-11-14 23:38:41Z gcase $

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

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.ModelAndViewDefiningException;

import com.dynamic.charm.web.form.FormModel;


public interface FormProcessor
{
    /**
    * This method is called when the save button has been used to submit the form. Normally, this method will return null,
    * which means that the other processors should be allowed to execute.  If the FormProcessor wishes to short-circuit the handleDelete process,
    * they would use this to return the ModelAndView to be used to show the next page, overriding the view defined in the formModel
    *
    * @param model the FormModel instance
    * @param request the request
    * @param response the response
    * @return true if the validation process should be allowed to continue, pass false to short-circuit the process
    */
    public ModelAndView handleSave(FormModel model, HttpServletRequest request,
        HttpServletResponse response);

    /**
     * This method is called when the delete button has been used to submit the form.  Normally, this method will return null,
     * which means that the other processors should be allowed to execute.  If the FormProcessor wishes to short-circuit the handleDelete process,
     * they would use this to return the ModelAndView to be used to show the next page, overriding the view defined in the formModel
     *
     * @param model the FormModel instance
     * @param request the request
     * @param response the response
     * @return the new model and view that should be used
     */
    public ModelAndView handleDelete(FormModel model, HttpServletRequest request,
        HttpServletResponse response);

    /**
     * Validate the form.
     *
     * @param model the FormModel instance
     * @param request the request
     * @param response the response
     * @return true if the validation process should be allowed to continue, pass false to short-circuit the process
     */
    public boolean validate(FormModel model, HttpServletRequest request,
        HttpServletResponse response);

    /**
     * This method is called when the form is about to be displayed, in cases where an error is returned
     *
     * @param model the FormModel instance
     * @param request the request
     * @param response the response
     */
    public void onShowForm(FormModel model, HttpServletRequest request, HttpServletResponse response) 
    	throws ModelAndViewDefiningException;

    /**
     * This method is when the save button has been used to submit the form, and should be used to manipulate model to remove/add any additional properties
     *
     * @param model the FormModel instance
     * @param request the request
     * @param response the response
     */
    public void performRequestBindings(FormModel model, HttpServletRequest request,
        HttpServletResponse response);
}
