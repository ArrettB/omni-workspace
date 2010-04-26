/*
 * Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written consent of Dynamic
 * Information Systems. All rights reserved.
 *
 * Copyright 2005, Dynamic Information Systems, LLC $Id:
 * HibernateFormService.java 160 2005-07-26 13:53:17Z $
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 * FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL DYNAMIC
 * INFORMATIONS SYTEMS, LLC BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * ====================================================================
 */


package com.dynamic.charm.web.form;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.hibernate.metadata.ClassMetadata;

import com.dynamic.charm.common.ArrayUtils;
import com.dynamic.charm.exception.CharmException;
import com.dynamic.charm.query.hibernate.HibernateService;


public class HibernateFormService implements FormService
{
    private final static Logger logger = Logger.getLogger(HibernateFormService.class);
    private HibernateService hibernateService;

    private Map cache = new HashMap();
    Object lock = new Object();

    public String[] getRequiredFields(String tableOrClass)
    {
        try
        {
            Class clazz = hibernateService.resolveClass(tableOrClass);
            synchronized (lock)
            {
                String[] result = (String[]) cache.get(clazz);
                if (result == null)
                {
                    logger.info("Determining mandatory columns for " + clazz.getName());
                    result = determineRequiredFields(clazz);
                    cache.put(clazz, result);
                }
                else
                {
 //                   logger.info("Returning cached mandatory columns for " + clazz.getName());
                }
                return result;
            }
        }
        catch (ClassNotFoundException e)
        {
            throw new CharmException("Could not get required fields for " + tableOrClass, e);
        }
    }

    public String[] determineRequiredFields(Class clazz)
    {
        ClassMetadata classMeta = hibernateService.getSessionFactory().getClassMetadata(clazz);
        List tempResult = new ArrayList();
        String[] properties = classMeta.getPropertyNames();
        boolean[] nullable = classMeta.getPropertyNullability();
        for (int i = 0; i < nullable.length; i++)
        {
            if (!nullable[i])
            {
                tempResult.add(properties[i]);
            }
        }

        String[] result = (String[]) ArrayUtils.toArray(tempResult, String.class);
        return result;
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
