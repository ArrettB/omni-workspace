/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: AbstractService.java 199 2006-11-14 23:38:41Z gcase $

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


package com.dynamic.charm.service;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.BeanInitializationException;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;


public abstract class AbstractService implements InitializingBean, ApplicationContextAware
{
    protected List requiredProperties = new LinkedList();
	private ApplicationContext applicationContext;

    public AbstractService()
    {
        setup();
    }

    public abstract void setup();

    public void registerRequiredProperty(String propertyName)
    {
        requiredProperties.add(propertyName);
    }

    public void afterPropertiesSet() throws Exception
    {
        for (Iterator iter = requiredProperties.iterator(); iter.hasNext();)
        {
            String propertyName = (String) iter.next();
            Object propValue = BeanUtils.getProperty(this, propertyName);
            if (propValue == null)
            {
                throw new BeanInitializationException(propertyName + " is a required property of " + this.getClass().getName() + ".  Please edit your applicationContext.xml accordingly.");
            }
        }
    }
    
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException
    {
    	this.applicationContext = applicationContext;
    }
    
    public ApplicationContext getApplicationContext()
    {
    	return applicationContext;
    }
    
}
