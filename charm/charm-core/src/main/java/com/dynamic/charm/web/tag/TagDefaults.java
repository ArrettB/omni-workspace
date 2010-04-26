/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: TagDefaults.java 199 2006-11-14 23:38:41Z gcase $

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


/*
 * Created on May 20, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.dynamic.charm.web.tag;

import java.beans.PropertyDescriptor;
import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.BeanUtils;

import com.dynamic.charm.exception.CharmException;


/**
 * @author gcase
 *
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class TagDefaults
{
    private final static TagDefaults _instance = new TagDefaults();

    private final static Logger logger = Logger.getLogger(TagDefaults.class);

    private Map classDefaultSetMapping = new HashMap();

    private TagDefaults()
    {
    }

    public static TagDefaults getInstance()
    {
        return _instance;
    }

    public void registerDefault(Class tagClass, String propertyName, Object defaultValue)
    {
        PropertyDescriptor[] pds = BeanUtils.getPropertyDescriptors(tagClass);
        boolean found = false;
        for (int i = 0; i < pds.length; i++)
        {
            if (pds[i].getName().equals(propertyName))
            {
                found = true;
                break;
            }
        }
        if (!found)
        {
            throw new CharmException("Can not register default for property " + propertyName + " on class " + tagClass.getName() + ", property does not exist");
        }
        else
        {
            getDefaultSet(tagClass).addDefault(propertyName, defaultValue);
        }
    }

    public void clearDefaults(Class tagClass)
    {
        classDefaultSetMapping.remove(tagClass);
    }

    public void clearAllDefaults()
    {
        classDefaultSetMapping.clear();
    }

    public Object getDefaultValue(Class tagClass, String propertyName)
    {
        DefaultSet set = getDefaultSet(tagClass);
        return set.getDefault(propertyName);
    }

    protected DefaultSet getDefaultSet(Class tagClass)
    {
        DefaultSet result = (DefaultSet) classDefaultSetMapping.get(tagClass);
        if (result == null)
        {
            result = new DefaultSet();
            classDefaultSetMapping.put(tagClass, result);
        }
        return result;
    }

    public void setDefaultValue(Object tagInstance, String propertyName)
    {
        try
        {
            DefaultSet set = getDefaultSet(tagInstance.getClass());
            if (set.isRegistered(propertyName))
            {
                Object propValue = org.apache.commons.beanutils.BeanUtils.getProperty(tagInstance,
                        propertyName);
                if (propValue == null)
                {
                    Object defaultValue = set.getDefault(propertyName);
                    logger.debug("Value not set for " + propertyName + ", setting to " + defaultValue);
                    org.apache.commons.beanutils.BeanUtils.setProperty(tagInstance, propertyName,
                        defaultValue);
                }
                else
                {
                    throw new CharmException("No default value registered for " + propertyName + " on " + tagInstance.getClass());
                }
            }
        }
        catch (IllegalAccessException e)
        {
            throw new CharmException("IllegalAccessException accessing property " + propertyName + " on " + tagInstance);
        }
        catch (InvocationTargetException e)
        {
            throw new CharmException("InvocationTargetException accessing property " + propertyName + " on " + tagInstance);
        }
        catch (NoSuchMethodException e)
        {
            throw new CharmException("NoSuchMethodException accessing property " + propertyName + " on " + tagInstance);
        }
    }

    public void setAllDefaults(Object tagInstance)
    {
        DefaultSet set = getDefaultSet(tagInstance.getClass());
        for (Iterator iter = set.getPropertyIterator(); iter.hasNext();)
        {
            String propertyName = (String) iter.next();
            try
            {
                Object propValue = org.apache.commons.beanutils.BeanUtils.getProperty(tagInstance,
                        propertyName);
                if (propValue == null)
                {
                    Object defaultValue = set.getDefault(propertyName);
                    logger.debug("Value not set for " + propertyName + ", setting to " + defaultValue);
                    org.apache.commons.beanutils.BeanUtils.setProperty(tagInstance, propertyName,
                        defaultValue);
                }
            }
            catch (IllegalAccessException e)
            {
                throw new CharmException("IllegalAccessException accessing property " + propertyName + " on " + tagInstance);
            }
            catch (InvocationTargetException e)
            {
                throw new CharmException("InvocationTargetException accessing property " + propertyName + " on " + tagInstance);
            }
            catch (NoSuchMethodException e)
            {
                throw new CharmException("NoSuchMethodException accessing property " + propertyName + " on " + tagInstance);
            }
        }
    }
}

class DefaultSet
{
    Map defaults = new HashMap();

    public void addDefault(String property, Object defaultValue)
    {
        defaults.put(property, defaultValue);
    }

    public Object getDefault(String property)
    {
        return defaults.get(property);
    }

    public boolean isRegistered(String property)
    {
        return defaults.containsKey(property);
    }

    public Iterator getPropertyIterator()
    {
        return defaults.keySet().iterator();
    }
}
