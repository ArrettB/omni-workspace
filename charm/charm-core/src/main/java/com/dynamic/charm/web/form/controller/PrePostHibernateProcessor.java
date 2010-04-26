/*
 *               ApexIT, Inc.
 *
 * This software can only be used with the expressed written
 * consent of ApexIT, Inc. All rights reserved.
 *
 * Copyright 2008 ApexIT, Inc.
 * $Id: PrePostHibernateProcessor.java 357 2008-11-12 22:02:19Z bvonhaden $
 *
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

import org.springframework.beans.factory.InitializingBean;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.ModelAndViewDefiningException;

import com.dynamic.charm.query.hibernate.HibernateService;
import com.dynamic.charm.web.form.FormModel;

/**
 * Form pre-processors and post-processors that need to access the database should extend this class
 * and override the appropriate methods. 
 * 
 * @version $Id: PrePostHibernateProcessor.java 357 2008-11-12 22:02:19Z bvonhaden $
 */
public class PrePostHibernateProcessor extends AbstractProcessor implements FormProcessor, InitializingBean
{
	private HibernateService hibernateService;

	public void registerRequiredProperties()
	{
		registerRequiredProperty("hibernateService");
	}

	/**
	 * @see com.dynamic.charm.web.CharmWebObjectSupport#afterPropertiesSetInternal()
	 */
	public void afterPropertiesSetInternal()
	{

	}

	/**
	 * @see com.dynamic.charm.web.form.controller.FormProcessor#handleDelete(com.dynamic.charm.web.form.FormModel, javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	public ModelAndView handleDelete(FormModel model, HttpServletRequest request, HttpServletResponse response)
	{
		return null;
	}

	/**
	 * @see com.dynamic.charm.web.form.controller.FormProcessor#handleSave(com.dynamic.charm.web.form.FormModel, javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	public ModelAndView handleSave(FormModel model, HttpServletRequest request, HttpServletResponse response)
	{
		return null;
	}

	/**
	 * @see com.dynamic.charm.web.form.controller.FormProcessor#onShowForm(com.dynamic.charm.web.form.FormModel, javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	public void onShowForm(FormModel model, HttpServletRequest request, HttpServletResponse response)
			throws ModelAndViewDefiningException
	{

	}

	/**
	 * @see com.dynamic.charm.web.form.controller.FormProcessor#performRequestBindings(com.dynamic.charm.web.form.FormModel, javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	public void performRequestBindings(FormModel model, HttpServletRequest request, HttpServletResponse response)
	{

	}

	/**
	 * @see com.dynamic.charm.web.form.controller.FormProcessor#validate(com.dynamic.charm.web.form.FormModel, javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	public boolean validate(FormModel model, HttpServletRequest request, HttpServletResponse response)
	{
		return true;
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
