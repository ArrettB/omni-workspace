/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: ParamHelper.java 199 2006-11-14 23:38:41Z gcase $

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


package com.dynamic.charm.web.tag.support;

import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.jdbc.core.SqlTypeValue;


/**
 * @author gcase
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class ParamHelper implements ParamParent
{
    private Map paramMap = new LinkedHashMap();

    public void release()
    {
        paramMap.clear();
        paramMap = null;
    }

    public void addParameter(String name, Object value)
    {
        paramMap.put(name, value);
    }

    public Iterator getParameterNames()
    {
        return paramMap.entrySet().iterator();
    }

    public Object getParameterValue(String name)
    {
        return paramMap.get(name);
    }

    public Object[] toValueArray()
    {
        Object[] result = new Object[paramMap.size()];
        int i = 0;
        for (Iterator iter = paramMap.keySet().iterator(); iter.hasNext();)
        {
            String name = (String) iter.next();
            result[i++] = (Object) paramMap.get(name);
        }
        return result;
    }

    public String[] toNameArray()
    {
        String[] result = new String[paramMap.size()];
        int i = 0;
        for (Iterator iter = paramMap.keySet().iterator(); iter.hasNext();)
        {
            String name = (String) iter.next();
            result[i++] = name;
        }
        return result;
    }

    public int[] toTypeArray()
    {
        int[] result = new int[paramMap.size()];
        for (int i = 0; i < result.length; i++)
        {
            result[i] = SqlTypeValue.TYPE_UNKNOWN;
        }
        return result;
    }

    public int getNumberParameters()
    {
        return paramMap.size();
    }
}
