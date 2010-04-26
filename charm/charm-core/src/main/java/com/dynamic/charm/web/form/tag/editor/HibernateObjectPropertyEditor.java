/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: HibernateObjectPropertyEditor.java 199 2006-11-14 23:38:41Z gcase $

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


package com.dynamic.charm.web.form.tag.editor;

import java.beans.PropertyEditorSupport;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import com.dynamic.charm.query.hibernate.HibernateService;


public class HibernateObjectPropertyEditor extends PropertyEditorSupport
{
    private final static Logger logger = Logger.getLogger(HibernateObjectPropertyEditor.class);
    private Class entityClass;
    private HibernateService hibernateService;

    public HibernateObjectPropertyEditor(Class entityClass, HibernateService service)
    {
        logger.debug("HibernateObjectPropertyEditor()");
        this.entityClass = entityClass;
        this.hibernateService = service;
    }

    public void setAsText(String textValue) throws IllegalArgumentException
    {
        logger.debug("setAsText()");
        Object result = null;
        if (StringUtils.isNotBlank(textValue))
        {
            result = hibernateService.get(entityClass, textValue);
        }
        logger.info("Setting value to " + result);
        setValue(result);        	
   }

    public String getAsText()
    {
        logger.debug("getAsText()");
        Object value = getValue();
        return value != null ? value.toString(): null;
    }
}
