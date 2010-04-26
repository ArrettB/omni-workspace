/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.

 * Copyright 2005, Dynamic Information Systems, LLC
 * $Id: AbstractDataService.java 210 2006-12-11 17:54:08Z gcase $

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


package com.dynamic.charm.query;

import java.util.List;

import javax.sql.DataSource;

import org.apache.commons.lang.ArrayUtils;

import com.dynamic.charm.exception.CharmException;


/**
 * @author gcase
 *
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public abstract class AbstractDataService implements DataService
{
    protected DataSource dataSource;
    protected boolean isDefault;

    public DataSource getDataSource()
    {
        return dataSource;
    }

    public void setDataSource(DataSource dataSource)
    {
        this.dataSource = dataSource;
    }

    public List queryForList(String query)
    {
        return queryForList(query, ArrayUtils.EMPTY_STRING_ARRAY, ArrayUtils.EMPTY_OBJECT_ARRAY, null);
    }

    public List queryForList(String query, String parameterName, Object parameterValue)
    {
        return queryForList(query, new String[] { parameterName }, new Object[] { parameterValue }, null);
    }

    public List queryForList(String query, String parameterName, Object parameterValue, int parameterType)
    {
        return queryForList(query, new String[] { parameterName }, new Object[] { parameterValue }, new int[] { parameterType });
    }

    public List queryForList(NamedQuery query)
    {
        return queryForList(query, ArrayUtils.EMPTY_STRING_ARRAY, ArrayUtils.EMPTY_OBJECT_ARRAY);
    }

    public List queryForList(NamedQuery query, Object parameterValue)
    {
        String parameterName = query.getSingleParameterName();
        return queryForList(query, new String[] { parameterName }, new Object[] { parameterValue });
    }

    public Object queryForObject(String query)
    {
        return queryForObject(query, ArrayUtils.EMPTY_STRING_ARRAY, ArrayUtils.EMPTY_OBJECT_ARRAY, null);
    }

    public Object queryForObject(String query, String parameterName, Object parameterValue)
    {
        return queryForObject(query, new String[] { parameterName }, new Object[] { parameterValue }, null);
    }

    public Object queryForObject(String query, String parameterName, Object parameterValue, int parameterType)
    {
        return queryForObject(query, new String[] { parameterName }, new Object[] { parameterValue }, new int[] { parameterType });
    }

    public Object queryForObject(String query, String[] parameterNames, Object[] parameterValues, int[] types)
    {
        List results = queryForList(query, parameterNames, parameterValues, types);
        return getExactlyOneResult(results);
    }

    public Object queryForObject(NamedQuery query)
    {
        return queryForObject(query, ArrayUtils.EMPTY_STRING_ARRAY, ArrayUtils.EMPTY_OBJECT_ARRAY);
    }

    public Object queryForObject(NamedQuery query, Object parameterValue)
    {
        String parameterName = query.getSingleParameterName();
        return queryForObject(query, new String[] { parameterName }, new Object[] { parameterValue });
    }

    public Object queryForObject(NamedQuery query, String[] parameterNames,
        Object[] parameterValues)
    {
        List results = queryForList(query, parameterNames, parameterValues);
        return getExactlyOneResult(results);
    }

    protected Object getExactlyOneResult(List results)
    {
        if (results.size() == 1)
        {
            return results.get(0);
        }
        else if (results.size() > 1)
        {
            throw new CharmException(
                "1 result was requested, and the query returned more than 1 result.");
        }
        return null;
    }

    public boolean getIsDefault()
    {
        return isDefault;
    }

    public void setIsDefault(boolean isDefault)
    {
        this.isDefault = isDefault;
    }
}
