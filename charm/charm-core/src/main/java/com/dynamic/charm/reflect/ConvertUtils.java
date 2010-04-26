/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: ConvertUtils.java 206 2006-12-07 00:43:17Z gcase $

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


package com.dynamic.charm.reflect;

import java.text.ParseException;
import java.util.Date;

import org.apache.commons.lang.time.DateUtils;
import org.apache.log4j.Logger;

import com.dynamic.charm.common.ArrayUtils;
import com.dynamic.charm.common.StringUtils;
import com.dynamic.charm.exception.CharmException;


public class ConvertUtils
{
    private final static Logger logger = Logger.getLogger(ConvertUtils.class);

    public static Object[] convert(Object[] original, Class[] intendedTypes)
    {
        if (!ArrayUtils.isCompatible(intendedTypes, original))
        {
            throw new CharmException(
                "Exception in ConvertUtils.convert(): number of values does not match number of intendedtypes");
        }

        Object[] result = new Object[intendedTypes.length];

        // for each of parameters, make a new object of the same type with the
        // correct value
        for (int i = 0; i < intendedTypes.length; i++)
        {
        	if (original[i] == null)
            {
                continue;
            }
        	result[i] = convert(original[i], intendedTypes[i]);
        }

        return result;
    }


    public static Object convert(Object original, Class intendedType)
    {
    	Class actual = original.getClass();

        if (intendedType.equals(actual))
        {
            logger.debug("Classes Compatible:" + intendedType.getName() + " equals " + actual.getName());
           return original;
        }
        else if (intendedType.isAssignableFrom(actual))
        {
            logger.debug("Classes Compatible:" + intendedType.getName() + " is assignable from " + actual.getName());
            return original;
        }
        else if (Date.class.equals(intendedType))
        {
        	logger.debug("Converting object of class " + original.getClass().getName() + " with value of " + original + " to " + intendedType.getName());
        	if (StringUtils.isNotBlank(original.toString()))
        	{
              	try
    			{
    				return DateUtils.parseDate(original.toString(), new String[] {"MM/dd/yyyy", "MM/dd/yy", "dd-MMM-yyyy"});
    			}
    			catch (ParseException e)
    			{
    				throw new CharmException("Could not parse date when converting " + original);
    			}
        	}
        	else
        	{
        		return null;
        	}
        }
        else
        {
            logger.debug("Converting object of class " + original.getClass().getName() + " with value of " + original + " to " + intendedType.getName());
            return org.apache.commons.beanutils.ConvertUtils.convert(original.toString(), intendedType);
        }
    }
    
    public static Class stringToClass(String type)
    {
    	if (type.indexOf(".") >= 0)
			try
			{
				return Class.forName(type);
			}
			catch (ClassNotFoundException e)
			{
				throw new CharmException("Could not convert the string '" + type  +"' to a class.", e);
			}
		else if (type.equalsIgnoreCase("long"))
    		return Long.class;
    	else if (type.equalsIgnoreCase("int"))
    		return int.class;
    	else if (type.equalsIgnoreCase("integer"))
    		return Integer.class;
    	else if (type.equalsIgnoreCase("double"))
    		return Double.class;
    	else if (type.equalsIgnoreCase("float"))
    		return Float.class;
    	else if (type.equalsIgnoreCase("string"))
    		return String.class;
       	else if (type.equalsIgnoreCase("boolean"))
    		return Boolean.class;
    	else
    		return Object.class;
    }
       
    
}
