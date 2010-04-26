/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.

 * Copyright 2005, Dynamic Information Systems, LLC
 * $Id: ParameterBundle.java 206 2006-12-07 00:43:17Z gcase $

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


package com.dynamic.charm.query.core;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.SqlTypeValue;

import com.dynamic.charm.common.ArrayUtils;
import com.dynamic.charm.common.Constants;
import com.dynamic.charm.exception.CharmException;
import com.dynamic.charm.query.jdbc.NamedParameter;


/**
 * @author gcase
 *
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class ParameterBundle
{
    private Map storage = new HashMap();
    private int numPositions = 0;

    public ParameterBundle()
    {
        super();
    }

    public ParameterBundle(String[] parameterNames, int[] parameterTypes)
    {
        if (!ArrayUtils.isCompatible(parameterNames, parameterTypes))
        {
            throw new CharmException("parameterNames and parameterTypes parameters must match");
        }

        for (int i = 0; i < parameterNames.length; i++)
        {
            addParameter(parameterNames[i], parameterTypes[i]);
        }
    }

    public ParameterBundle(String[] parameterNames, int[] parameterTypes, Object[] parameterValues)
    {
        if (!ArrayUtils.isCompatible(parameterNames, parameterValues))
        {
            throw new CharmException("parameterNames and parameterValues parameters must match");
        }
        if (!ArrayUtils.isCompatible(parameterNames, parameterTypes))
        {
            throw new CharmException("parameterNames and parameterTypes parameters must match");
        }

        for (int i = 0; i < parameterNames.length; i++)
        {
            addParameter(parameterNames[i], parameterTypes[i], parameterValues[i]);
        }
    }

    public NamedParameter addParameter(String parameterName, int parameterType)
    {
        return addParameter(parameterName, parameterType, null);
    }

    public NamedParameter addParameter(String parameterName, Object parameterValue)
    {
        return addParameter(parameterName, SqlTypeValue.TYPE_UNKNOWN, parameterValue);
    }

    public NamedParameter addParameter(String parameterName)
    {
        return addParameter(parameterName, SqlTypeValue.TYPE_UNKNOWN, null);
    }

    public NamedParameter addParameter(String parameterName, int parameterType,
        Object parameterValue)
    {
        NamedParameter np = new NamedParameter(parameterName, parameterType, parameterValue);
        storage.put(parameterName, np);
        return np;
    }

    /**
     * @param parameterName
     * @param i
     */
    public void addPosition(String parameterName)
    {
        getGuaranteedNamedParameter(parameterName).addPosition(++numPositions);
    }

    public Object[] toValueArray()
    {
        Object[] result = new Object[storage.size()];
        int i = 0;
        for (Iterator iter = storage.values().iterator(); iter.hasNext();)
        {
            NamedParameter np = (NamedParameter) iter.next();
            result[i] = np.getValue();
        }
        return result;
    }

    public String[] toNameArray()
    {
        String[] result = new String[storage.size()];
        int i = 0;
        for (Iterator iter = storage.keySet().iterator(); iter.hasNext();)
        {
            NamedParameter np = (NamedParameter) iter.next();
            result[i] = np.getName();
        }
        return result;
    }

    public int[] toTypeArray()
    {
        int[] result = new int[storage.size()];
        int i = 0;
        for (Iterator iter = storage.keySet().iterator(); iter.hasNext();)
        {
            NamedParameter np = (NamedParameter) iter.next();
            result[i] = np.getSqlType();
        }
        return result;
    }

    public NamedParameter getNamedParameter(String parameterName)
    {
        return (NamedParameter) storage.get(parameterName);
    }

    public NamedParameter getGuaranteedNamedParameter(String parameterName)
    {
        NamedParameter np = getNamedParameter(parameterName);
        if (np == null)
        {
            throw new CharmException("Could not find a parameter with name " + parameterName);
        }
        return np;
    }

    public String getSQLTypeName(String parameterName)
    {
        return getGuaranteedNamedParameter(parameterName).getTypeName();
    }

    public Object getParameterValue(String parameterName)
    {
        return getGuaranteedNamedParameter(parameterName).getValue();
    }

    public int getParameterCount()
    {
        return numPositions;
    }

    public int getDistinctParameterCount()
    {
        return storage.size();
    }

    public List getParameterPositions(String parameterName)
    {
        return getGuaranteedNamedParameter(parameterName).getParameterPositions();
    }

    public NamedParameter[] toNamedParameterArray()
    {
        NamedParameter[] result = new NamedParameter[storage.size()];
        int i = 0;
        for (Iterator iter = storage.keySet().iterator(); iter.hasNext();)
        {
            NamedParameter np = (NamedParameter) iter.next();
            result[i] = np;
        }
        return result;
    }

    public Object[] toValueArrayByPosition()
    {
        Object[] result = new Object[getParameterCount()];
        for (Iterator iter = storage.values().iterator(); iter.hasNext();)
        {
            NamedParameter np = (NamedParameter) iter.next();
            Object value = np.getValue();
            for (Iterator iterator = np.getParameterPositions().iterator(); iterator.hasNext();)
            {
                Integer position = (Integer) iterator.next();
                result[position.intValue() - 1] = value;
            }
        }

        return result;
    }

    public int[] toTypeArrayByPosition()
    {
        int[] result = new int[numPositions];
        for (Iterator iter = storage.values().iterator(); iter.hasNext();)
        {
            NamedParameter np = (NamedParameter) iter.next();
            int type = np.getSqlType();
            for (Iterator iterator = np.getParameterPositions().iterator(); iterator.hasNext();)
            {
                Integer position = (Integer) iterator.next();
                result[position.intValue() - 1] = type;
            }
        }

        return result;
    }

    public void fillInValues(String[] parameterNames, Object[] parameterValue)
    {
        for (int i = 0; i < parameterNames.length; i++)
        {
            NamedParameter np = getGuaranteedNamedParameter(parameterNames[i]);
            np.setValue(parameterValue[i]);
        }
    }
    
    public String toString()
    {
    	StringBuffer result = new StringBuffer();
    	result.append("ParameterBundle:");
    	for (Iterator iter = storage.values().iterator(); iter.hasNext();)
		{
			result.append("\t" + iter.next()  + Constants.LINE_SEP);
		}
    	return result.toString();
    }
}
